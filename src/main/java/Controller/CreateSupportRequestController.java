package Controller;

import Entity.SupportRequest;
import DAO.SupportRequestDAO;
import DAO.SupportCategoryDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.time.LocalDateTime;

@WebServlet("/createSupportRequest")
@MultipartConfig
public class CreateSupportRequestController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // ===== TẠO ENTITY TRƯỚC =====
        SupportRequest sr = new SupportRequest();

        // ===== LẤY DATA =====
        String title = request.getParameter("title");

        String categoryId = request.getParameter("categoryId");
        String priority = request.getParameter("priority");
        String location = request.getParameter("supportLocation");
        String beneficiaryName = request.getParameter("beneficiaryName");

        String affectedStr = request.getParameter("affectedPeople");
        String amountStr = request.getParameter("estimatedAmount");

        Integer affectedPeople = (affectedStr == null || affectedStr.isEmpty())
                ? null : Integer.parseInt(affectedStr);

        Double estimatedAmount = (amountStr == null || amountStr.isEmpty())
                ? null : Double.parseDouble(amountStr);

        String description = request.getParameter("description");
        String email = request.getParameter("contactEmail");
        String phone = request.getParameter("contactPhone");

        // ===== HANDLE FILE UPLOAD =====
        Part filePart = request.getPart("proofImage");
        String fileName = null;

        if (filePart != null && filePart.getSize() > 0) {

            fileName = System.currentTimeMillis() + "_"
                    + filePart.getSubmittedFileName();

            String uploadPath = getServletContext()
                    .getRealPath("") + File.separator + "uploads";

            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdir();

            filePart.write(uploadPath + File.separator + fileName);
        }

        // ===== SET ENTITY =====
        sr.setTitle(title);
        sr.setCategoryId(categoryId);
        sr.setPriority(priority);
        sr.setSupportLocation(location);
        sr.setBeneficiaryName(beneficiaryName);
        sr.setAffectedPeople(affectedPeople);
        sr.setEstimatedAmount(estimatedAmount);
        sr.setDescription(description);
        sr.setProofImageUrl(fileName);
        sr.setContactEmail(email);
        sr.setContactPhone(phone);

        Object userObj = request.getSession().getAttribute("userId");

        if (userObj == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        sr.setCreatedBy((Integer) userObj);
        sr.setStatus("PENDING");
        sr.setCreatedAt(LocalDateTime.now());
        sr.setUpdatedAt(LocalDateTime.now());
        sr.setIsDeleted(false);

        // ===== CALL DAO =====
        SupportRequestDAO dao = new SupportRequestDAO();
        dao.insert(sr);

        response.sendRedirect(request.getContextPath() + "/viewSpRequestUser");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (request.getSession().getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        SupportCategoryDAO categoryDAO = new SupportCategoryDAO();
        request.setAttribute("categories", categoryDAO.getAll());

        request.getRequestDispatcher("/WEB-INF/views/createSupportRequest.jsp")
                .forward(request, response);
    }
}