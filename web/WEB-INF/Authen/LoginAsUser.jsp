<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/LoginAsUser.css">
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>

<div class="login-container">
    <h2>Login</h2>

    <!-- FORM LOGIN -->
    <form action="loginasuser" method="post">

        <div class="input-group">
            <i class="fa-regular fa-user"></i>
            <input type="text"
                   name="email"
                   placeholder="Email"
                   value="${param.email}"
                   required>
        </div>

        <div class="input-group">
            <i class="fa-solid fa-lock"></i>
            <input type="password"
                   name="password"
                   placeholder="Password"
                   required>
        </div>

        <button type="submit" class="btn-login">Login</button>
    </form>

    <!-- ERROR MESSAGE -->
    <c:if test="${not empty error}">
        <div class="error-box">
            <i class="fa-solid fa-triangle-exclamation"></i>
            ${error}
        </div>
    </c:if>

</div>

</body>
</html>
