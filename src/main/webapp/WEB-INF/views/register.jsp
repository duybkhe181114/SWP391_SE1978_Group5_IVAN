<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Register - IVAN</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <style>
        body { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); min-height: 100vh; display: flex; align-items: center; justify-content: center; font-family: 'Inter', sans-serif; }
        .register-container { background: white; padding: 40px; border-radius: 16px; box-shadow: 0 20px 60px rgba(0,0,0,0.3); max-width: 500px; width: 100%; }
        .register-container h1 { text-align: center; color: #333; margin-bottom: 30px; font-size: 28px; }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; margin-bottom: 8px; font-weight: 600; color: #555; font-size: 14px; }
        .form-group input, .form-group select { width: 100%; padding: 12px; border: 2px solid #e0e0e0; border-radius: 8px; font-size: 14px; transition: border 0.3s; box-sizing: border-box; }
        .form-group input:focus, .form-group select:focus { outline: none; border-color: #667eea; }
        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 15px; }
        .btn-submit { width: 100%; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 14px; border: none; border-radius: 8px; font-size: 16px; font-weight: 600; cursor: pointer; transition: transform 0.3s; margin-top: 10px; }
        .btn-submit:hover { transform: translateY(-2px); }
        .error { background: #fee; color: #e74c3c; padding: 12px; border-radius: 8px; margin-bottom: 20px; text-align: center; font-weight: 500; }
        .login-link { text-align: center; margin-top: 20px; color: #666; }
        .login-link a { color: #667eea; font-weight: 600; text-decoration: none; }
        .role-info { background: #f0f9ff; padding: 12px; border-radius: 8px; margin-top: 10px; font-size: 13px; color: #0369a1; display: none; }
    </style>
</head>
<body>
    <div class="register-container">
        <h1>🎯 Create Account</h1>
        
        <% if (request.getAttribute("error") != null) { %>
            <div class="error">❌ ${error}</div>
        <% } %>
        
        <form method="post" action="${pageContext.request.contextPath}/register/volunteer">
            <div class="form-row">
                <div class="form-group">
                    <label>First Name *</label>
                    <input type="text" name="firstName" required>
                </div>
                <div class="form-group">
                    <label>Last Name *</label>
                    <input type="text" name="lastName" required>
                </div>
            </div>
            
            <div class="form-group">
                <label>Email *</label>
                <input type="email" name="email" required>
            </div>
            
            <div class="form-group">
                <label>Password *</label>
                <input type="password" name="password" required minlength="6">
            </div>
            
            <div class="form-group">
                <label>Confirm Password *</label>
                <input type="password" name="confirmPassword" required minlength="6">
            </div>
            
            <div class="form-group">
                <label>Register as *</label>
                <select name="role" id="roleSelect" required onchange="showRoleInfo()">
                    <option value="">-- Select Role --</option>
                    <option value="Volunteer">🙋 Volunteer</option>
                    <option value="Organization">🏢 Organization</option>
                </select>
                
                <div id="volunteerInfo" class="role-info">
                    ✅ Your account will be activated immediately after registration.
                </div>
                <div id="orgInfo" class="role-info">
                    ⏳ Your account will be pending until admin approval.
                </div>
            </div>
            
            <button type="submit" class="btn-submit">Register</button>
        </form>
        
        <div class="login-link">
            Already have an account? <a href="${pageContext.request.contextPath}/login">Login here</a>
        </div>
    </div>
    
    <script>
        function showRoleInfo() {
            const role = document.getElementById('roleSelect').value;
            document.getElementById('volunteerInfo').style.display = role === 'Volunteer' ? 'block' : 'none';
            document.getElementById('orgInfo').style.display = role === 'Organization' ? 'block' : 'none';
        }
    </script>
</body>
</html>
