package Controller;

import DAO.UserProfileDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.net.URLEncoder;
import java.nio.file.*;

@WebServlet(name = "AvatarUploadController", urlPatterns = {"/profile/avatar"})
@MultipartConfig(maxFileSize = 3 * 1024 * 1024) // 3 MB limit
public class AvatarUploadController extends HttpServlet {

    private static final java.util.Set<String> ALLOWED_TYPES =
            java.util.Set.of("image/jpeg", "image/png", "image/webp");

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer userId = (Integer) request.getSession().getAttribute("userId");
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Part filePart = request.getPart("avatar");

        if (filePart == null || filePart.getSize() == 0) {
            redirect(response, request, "No file selected.");
            return;
        }

        String contentType = filePart.getContentType();
        if (contentType == null || !ALLOWED_TYPES.contains(contentType.toLowerCase())) {
            redirect(response, request, "Only JPG, PNG or WEBP images are allowed.");
            return;
        }

        // Resolve absolute path to webapp/assets/images/avatars/
        String uploadDir = getServletContext().getRealPath("/assets/images/avatars");
        Files.createDirectories(Paths.get(uploadDir));

        // Always use userId as filename to auto-replace old avatar
        String ext = contentType.contains("png") ? ".png"
                   : contentType.contains("webp") ? ".webp" : ".jpg";
        String filename = "avatar_" + userId + ext;

        // Delete any previous avatar file with a different extension
        for (String oldExt : new String[]{".jpg", ".png", ".webp"}) {
            Path old = Paths.get(uploadDir, "avatar_" + userId + oldExt);
            if (!oldExt.equals(ext)) Files.deleteIfExists(old);
        }

        Path savePath = Paths.get(uploadDir, filename);
        try (InputStream in = filePart.getInputStream()) {
            Files.copy(in, savePath, StandardCopyOption.REPLACE_EXISTING);
        }

        String dbPath = "/assets/images/avatars/" + filename;
        new UserProfileDAO().updateAvatar(userId, dbPath);

        // Update session so header can reflect change immediately
        request.getSession().setAttribute("userAvatar", dbPath);

        response.sendRedirect(request.getContextPath() + "/profile?success=avatar");
    }

    private void redirect(HttpServletResponse response, HttpServletRequest request, String msg)
            throws IOException {
        response.sendRedirect(request.getContextPath() + "/profile?avatarError="
                + URLEncoder.encode(msg, "UTF-8"));
    }
}
