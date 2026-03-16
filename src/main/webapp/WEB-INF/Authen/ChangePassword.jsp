<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Change Password - IVAN</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <style>
        * {
            box-sizing: border-box;
            font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            margin: 0;
            height: 100vh;
            background: linear-gradient(135deg, #eef3fb, #f9fbff);
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .changepass-container {
            width: 420px;
            max-width: 90%;
            background: #fff;
            padding: 40px 35px;
            border-radius: 12px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.08);
        }

        .changepass-container h2 {
            text-align: center;
            margin-bottom: 6px;
            color: #3b4a6b;
            font-size: 28px;
            font-weight: 600;
        }

        .changepass-container p {
            text-align: center;
            margin-bottom: 25px;
            color: #666;
            font-size: 14px;
        }

        .input-group {
            position: relative;
            margin-bottom: 16px;
        }

        .input-group i {
            position: absolute;
            top: 50%;
            left: 14px;
            transform: translateY(-50%);
            color: #9aa4b2;
            font-size: 16px;
        }

        .input-group input {
            width: 100%;
            padding: 14px 14px 14px 44px;
            border-radius: 8px;
            border: 1px solid #e2e6ef;
            font-size: 15px;
            outline: none;
            transition: all 0.2s;
        }

        .input-group input::placeholder {
            color: #b1b8c5;
        }

        .input-group input:focus {
            border-color: #5b8def;
            box-shadow: 0 0 6px rgba(91,141,239,0.25);
        }

        .rules {
            font-size: 13px;
            margin-bottom: 14px;
            padding-left: 8px;
            color: #28a745;
        }

        .error-box, .success-box {
            margin-bottom: 16px;
            padding: 12px;
            border-radius: 8px;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .error-box {
            background: #fdecec;
            color: #e25555;
            border: 1px solid #f5c2c2;
        }

        .success-box {
            background: #e9fff1;
            color: #2f855a;
            border: 1px solid #c6f6d5;
        }

        /* ===== BUTTONS SONG SONG ===== */
        .buttons {
            display: flex;
            gap: 12px;
            margin-top: 16px;
        }

        .btn-update, .btn-cancel {
            flex: 1;
            padding: 14px;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            font-size: 15px;
            border: none;
            transition: all 0.2s;
            text-align: center;
            text-decoration: none;
            display: inline-block;
        }

        .btn-update {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .btn-update:hover {
            opacity: 0.95;
            transform: translateY(-2px);
        }

        .btn-cancel {
            background: #f1f1f1;
            border: 1px solid #ccc;
            color: #333;
        }

        .btn-cancel:hover {
            background: #e2e2e2;
        }

        @media (max-width: 480px) {
            .changepass-container {
                padding: 30px 20px;
            }

            .buttons {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>

<div class="changepass-container">
    <h2>Change Password</h2>
    <p>Enter your current and new password to update your account</p>

    <!-- THÔNG BÁO LỖI -->
    <c:if test="${not empty ERROR}">
        <div class="error-box">
            ⚠ ${ERROR}
        </div>
    </c:if>

    <!-- THÔNG BÁO THÀNH CÔNG -->
    <c:if test="${not empty SUCCESS}">
        <div class="success-box">
            ✅ ${SUCCESS}
        </div>
    </c:if>

    <form action="changepassword" method="post">
        <div class="input-group">
            <i>🔒</i>
            <input type="password" name="oldPassword" placeholder="Current Password" required>
        </div>

        <div class="input-group">
            <i>🔒</i>
            <input type="password" name="newPassword" placeholder="New Password" required>
        </div>

        <div class="rules">
            ✔ At least 8 characters <br>
            ✔ 1 uppercase letter <br>
            ✔ 1 number
        </div>

        <div class="input-group">
            <i>🔒</i>
            <input type="password" name="confirmPassword" placeholder="Confirm New Password" required>
        </div>

        <div class="buttons">
            <button type="submit" class="btn-update">Update Password</button>
            <a href="home.jsp" class="btn-cancel">Cancel</a>
        </div>
    </form>
</div>

</body>
</html>
