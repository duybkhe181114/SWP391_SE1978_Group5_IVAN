<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Create Organization</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/RegisterOrganization.css">

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
</head>
<body>

<div class="page-wrapper">
    <div class="register-box">

        <h2>Create Organization</h2>
        <p class="sub-text">Please enter organization information</p>

        <form action="create-organization" method="post">

            <!-- Organization name -->
            <div class="input-box">
                <i class="fa-solid fa-building"></i>
                <input type="text" name="name"
                       placeholder="Organization Name" required>
            </div>

            <!-- Description -->
            <div class="input-box">
                <i class="fa-solid fa-align-left"></i>
                <input type="text" name="description"
                       placeholder="Description">
            </div>

            <!-- Phone -->
            <div class="input-box">
                <i class="fa-solid fa-phone"></i>
                <input type="text" name="phone"
                       placeholder="Phone">
            </div>

            <!-- Email -->
            <div class="input-box">
                <i class="fa-regular fa-envelope"></i>
                <input type="email" name="email"
                       placeholder="Email">
            </div>

            <!-- Address -->
            <div class="input-box">
                <i class="fa-solid fa-location-dot"></i>
                <input type="text" name="address"
                       placeholder="Address">
            </div>

            <!-- Website -->
            <div class="input-box">
                <i class="fa-solid fa-globe"></i>
                <input type="text" name="website"
                       placeholder="Website">
            </div>

            <button type="submit" class="btn-register">
                Create Organization
            </button>
        </form>

    </div>
</div>

</body>
</html>
