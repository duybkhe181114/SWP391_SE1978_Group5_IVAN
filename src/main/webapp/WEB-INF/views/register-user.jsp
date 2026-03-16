<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Register - IVAN</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <style>
        body { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); min-height: 100vh; display: flex; align-items: center; justify-content: center; font-family: 'Inter', sans-serif; }
        .register-container { background: white; padding: 40px; border-radius: 16px; box-shadow: 0 20px 60px rgba(0,0,0,0.3); max-width: 480px; width: 100%; }
        .register-header { text-align: center; margin-bottom: 30px; }
        .register-header h1 { color: #1e293b; font-size: 26px; margin-bottom: 6px; }
        .register-header p { color: #64748b; font-size: 14px; }
        .form-group { margin-bottom: 18px; }
        .form-group label { display: block; margin-bottom: 6px; font-weight: 600; color: #374151; font-size: 14px; }
        .form-group input { width: 100%; padding: 11px 14px; border: 2px solid #e5e7eb; border-radius: 8px; font-size: 14px; transition: border 0.2s; box-sizing: border-box; }
        .form-group input:focus { outline: none; border-color: #667eea; box-shadow: 0 0 0 3px rgba(102,126,234,0.15); }
        .form-group input.error-field { border-color: #ef4444; }
        .field-error { color: #ef4444; font-size: 12px; margin-top: 4px; display: none; }
        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; }
        .btn-submit { width: 100%; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 13px; border: none; border-radius: 8px; font-size: 15px; font-weight: 600; cursor: pointer; transition: transform 0.2s, box-shadow 0.2s; margin-top: 8px; }
        .btn-submit:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(102,126,234,0.4); }
        .alert-error { background: #fef2f2; color: #dc2626; padding: 12px 16px; border-radius: 8px; margin-bottom: 20px; font-size: 14px; border: 1px solid #fecaca; }
        .footer-links { text-align: center; margin-top: 20px; font-size: 14px; color: #6b7280; }
        .footer-links a { color: #667eea; font-weight: 600; text-decoration: none; }
        .footer-links a:hover { text-decoration: underline; }
        .password-hint { font-size: 12px; color: #9ca3af; margin-top: 4px; }
        .strength-bar { height: 4px; border-radius: 2px; margin-top: 6px; background: #e5e7eb; overflow: hidden; }
        .strength-fill { height: 100%; width: 0; transition: width 0.3s, background 0.3s; border-radius: 2px; }
    </style>
</head>
<body>
<div class="register-container">
    <div class="register-header">
        <h1>Create Account</h1>
        <p>Join IVAN as a regular user</p>
    </div>

    <% if (request.getAttribute("error") != null) { %>
        <div class="alert-error">⚠ ${error}</div>
    <% } %>

    <form method="post" action="${pageContext.request.contextPath}/register/user" id="registerForm" novalidate>
        <div class="form-row">
            <div class="form-group">
                <label>First Name *</label>
                <input type="text" name="firstName" id="firstName" placeholder="John" required>
                <div class="field-error" id="firstNameErr">First name is required</div>
            </div>
            <div class="form-group">
                <label>Last Name *</label>
                <input type="text" name="lastName" id="lastName" placeholder="Doe" required>
                <div class="field-error" id="lastNameErr">Last name is required</div>
            </div>
        </div>

        <div class="form-group">
            <label>Email Address *</label>
            <input type="email" name="email" id="email" placeholder="you@example.com" required>
            <div class="field-error" id="emailErr">Please enter a valid email</div>
        </div>

        <div class="form-group">
            <label>Password *</label>
            <input type="password" name="password" id="password" placeholder="Min. 6 characters" required minlength="6">
            <div class="strength-bar"><div class="strength-fill" id="strengthFill"></div></div>
            <div class="password-hint" id="strengthText">Enter a password</div>
            <div class="field-error" id="passwordErr">Password must be at least 6 characters</div>
        </div>

        <div class="form-group">
            <label>Confirm Password *</label>
            <input type="password" name="confirmPassword" id="confirmPassword" placeholder="Re-enter password" required>
            <div class="field-error" id="confirmErr">Passwords do not match</div>
        </div>

        <button type="submit" class="btn-submit">Create Account</button>
    </form>

    <div class="footer-links">
        Already have an account? <a href="${pageContext.request.contextPath}/login">Login</a><br>
        <a href="${pageContext.request.contextPath}/register">← Back to role selection</a>
    </div>
</div>

<script>
    const form = document.getElementById('registerForm');
    const password = document.getElementById('password');
    const confirmPassword = document.getElementById('confirmPassword');
    const strengthFill = document.getElementById('strengthFill');
    const strengthText = document.getElementById('strengthText');

    password.addEventListener('input', function() {
        const val = this.value;
        let strength = 0;
        if (val.length >= 6) strength++;
        if (/[A-Z]/.test(val)) strength++;
        if (/[0-9]/.test(val)) strength++;
        if (/[^A-Za-z0-9]/.test(val)) strength++;

        const colors = ['#ef4444', '#f59e0b', '#22c55e', '#16a34a'];
        const labels = ['Weak', 'Fair', 'Good', 'Strong'];
        strengthFill.style.width = (strength * 25) + '%';
        strengthFill.style.background = colors[strength - 1] || '#e5e7eb';
        strengthText.textContent = strength > 0 ? labels[strength - 1] : 'Enter a password';
    });

    function showError(id, show) {
        const el = document.getElementById(id);
        el.style.display = show ? 'block' : 'none';
    }

    function markField(id, error) {
        document.getElementById(id).classList.toggle('error-field', error);
    }

    form.addEventListener('submit', function(e) {
        let valid = true;

        const firstName = document.getElementById('firstName').value.trim();
        const lastName = document.getElementById('lastName').value.trim();
        const email = document.getElementById('email').value.trim();
        const pass = password.value;
        const confirm = confirmPassword.value;

        if (!firstName) { showError('firstNameErr', true); markField('firstName', true); valid = false; }
        else { showError('firstNameErr', false); markField('firstName', false); }

        if (!lastName) { showError('lastNameErr', true); markField('lastName', true); valid = false; }
        else { showError('lastNameErr', false); markField('lastName', false); }

        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(email)) { showError('emailErr', true); markField('email', true); valid = false; }
        else { showError('emailErr', false); markField('email', false); }

        if (pass.length < 6) { showError('passwordErr', true); markField('password', true); valid = false; }
        else { showError('passwordErr', false); markField('password', false); }

        if (pass !== confirm) { showError('confirmErr', true); markField('confirmPassword', true); valid = false; }
        else { showError('confirmErr', false); markField('confirmPassword', false); }

        if (!valid) e.preventDefault();
    });
</script>
</body>
</html>
