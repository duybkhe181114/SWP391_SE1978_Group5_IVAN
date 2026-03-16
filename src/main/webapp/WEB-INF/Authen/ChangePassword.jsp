<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Change Password - IVAN</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <style>
        * { box-sizing: border-box; font-family: 'Inter', 'Segoe UI', sans-serif; }

        body {
            margin: 0; height: 100vh;
            background: linear-gradient(135deg, #f0f4ff 0%, #e8ecf7 50%, #f5f7fa 100%);
            display: flex; justify-content: center; align-items: center;
        }

        .changepass-container {
            width: 460px; max-width: 92%;
            background: #ffffff;
            padding: 44px 38px;
            border-radius: 16px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.08), 0 1px 3px rgba(0,0,0,0.04);
        }

        .changepass-container h2 {
            text-align: center; margin-bottom: 6px;
            color: #1e293b; font-size: 26px; font-weight: 700;
        }

        .changepass-container > p {
            text-align: center; margin-bottom: 28px;
            color: #64748b; font-size: 14px; line-height: 1.5;
        }

        .input-group {
            position: relative; margin-bottom: 18px;
        }

        .input-group label {
            display: block; font-size: 13px; font-weight: 600;
            color: #475569; margin-bottom: 6px;
        }

        .input-wrap {
            position: relative;
        }

        .input-wrap svg {
            position: absolute; top: 50%; left: 14px; transform: translateY(-50%);
            width: 18px; height: 18px; color: #94a3b8;
        }

        .input-wrap input {
            width: 100%; padding: 13px 44px 13px 42px;
            border-radius: 10px; border: 1.5px solid #e2e8f0;
            font-size: 14px; outline: none; transition: all 0.2s;
            background: #fafbfc;
        }

        .input-wrap input::placeholder { color: #b1b8c5; }

        .input-wrap input:focus {
            border-color: #6366f1; background: #fff;
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.12);
        }

        .input-wrap input.error-input {
            border-color: #ef4444;
            box-shadow: 0 0 0 3px rgba(239, 68, 68, 0.1);
        }

        .input-wrap input.valid-input {
            border-color: #22c55e;
        }

        .toggle-pass {
            position: absolute; top: 50%; right: 12px; transform: translateY(-50%);
            background: none; border: none; cursor: pointer; color: #94a3b8;
            padding: 4px; display: flex; align-items: center;
        }
        .toggle-pass:hover { color: #64748b; }
        .toggle-pass svg { width: 18px; height: 18px; }

        /* ===== PASSWORD RULES ===== */
        .rules {
            margin-bottom: 18px; padding: 14px 16px;
            background: #f8fafc; border-radius: 10px;
            border: 1px solid #e2e8f0;
        }
        .rules p { font-size: 12px; font-weight: 600; color: #475569; margin: 0 0 8px 0; text-transform: uppercase; letter-spacing: 0.5px; }
        .rule-item {
            display: flex; align-items: center; gap: 8px;
            font-size: 13px; color: #94a3b8; margin-bottom: 4px;
            transition: color 0.2s;
        }
        .rule-item svg { width: 14px; height: 14px; flex-shrink: 0; }
        .rule-item.passed { color: #22c55e; }
        .rule-item.failed { color: #ef4444; }

        /* ===== MESSAGES ===== */
        .msg-box {
            margin-bottom: 18px; padding: 12px 16px;
            border-radius: 10px; font-size: 14px;
            display: flex; align-items: center; gap: 10px;
        }
        .msg-box svg { width: 18px; height: 18px; flex-shrink: 0; }
        .error-box { background: #fef2f2; color: #dc2626; border: 1px solid #fecaca; }
        .success-box { background: #f0fdf4; color: #16a34a; border: 1px solid #bbf7d0; }

        /* ===== BUTTONS ===== */
        .buttons { display: flex; gap: 12px; margin-top: 20px; }

        .btn-update, .btn-cancel {
            flex: 1; padding: 14px; border-radius: 10px;
            font-weight: 600; cursor: pointer; font-size: 14px;
            border: none; transition: all 0.2s;
            text-align: center; text-decoration: none; display: inline-block;
        }

        .btn-update {
            background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%);
            color: white;
            box-shadow: 0 4px 14px rgba(99, 102, 241, 0.3);
        }
        .btn-update:hover {
            transform: translateY(-1px);
            box-shadow: 0 6px 20px rgba(99, 102, 241, 0.4);
        }
        .btn-update:disabled {
            opacity: 0.5; cursor: not-allowed; transform: none;
            box-shadow: none;
        }

        .btn-cancel {
            background: #f8fafc; border: 1.5px solid #e2e8f0; color: #475569;
        }
        .btn-cancel:hover { background: #f1f5f9; border-color: #cbd5e1; }

        @media (max-width: 480px) {
            .changepass-container { padding: 30px 20px; }
            .buttons { flex-direction: column; }
        }
    </style>
</head>
<body>

<div class="changepass-container">
    <h2>Change Password</h2>
    <p>Update your password to keep your account secure</p>

    <!-- ERROR -->
    <c:if test="${not empty ERROR}">
        <div class="msg-box error-box">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
            ${ERROR}
        </div>
    </c:if>

    <!-- SUCCESS -->
    <c:if test="${not empty SUCCESS}">
        <div class="msg-box success-box">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>
            ${SUCCESS}
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/changepassword" method="post" id="changePassForm">

        <!-- Current Password -->
        <div class="input-group">
            <label for="oldPassword">Current Password</label>
            <div class="input-wrap">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                <input type="password" id="oldPassword" name="oldPassword" placeholder="Enter current password" required>
                <button type="button" class="toggle-pass" onclick="togglePassword('oldPassword', this)">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                </button>
            </div>
        </div>

        <!-- New Password -->
        <div class="input-group">
            <label for="newPassword">New Password</label>
            <div class="input-wrap">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                <input type="password" id="newPassword" name="newPassword" placeholder="Enter new password" required oninput="validateRules()">
                <button type="button" class="toggle-pass" onclick="togglePassword('newPassword', this)">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                </button>
            </div>
        </div>

        <!-- Rules -->
        <div class="rules">
            <p>Password Requirements</p>
            <div class="rule-item" id="rule-length">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"/></svg>
                <span>At least 8 characters</span>
            </div>
            <div class="rule-item" id="rule-upper">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"/></svg>
                <span>1 uppercase letter</span>
            </div>
            <div class="rule-item" id="rule-number">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"/></svg>
                <span>1 number</span>
            </div>
        </div>

        <!-- Confirm Password -->
        <div class="input-group">
            <label for="confirmPassword">Confirm New Password</label>
            <div class="input-wrap">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Re-enter new password" required oninput="validateMatch()">
                <button type="button" class="toggle-pass" onclick="togglePassword('confirmPassword', this)">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                </button>
            </div>
            <div id="matchMsg" style="font-size:12px; margin-top:4px; display:none;"></div>
        </div>

        <div class="buttons">
            <button type="submit" class="btn-update" id="submitBtn">Update Password</button>
            <a href="${pageContext.request.contextPath}/home" class="btn-cancel">Cancel</a>
        </div>
    </form>
</div>

<script>
    var checkSvg = '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>';
    var circleSvg = '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"/></svg>';
    var xSvg = '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="12" cy="12" r="10"/><line x1="15" y1="9" x2="9" y2="15"/><line x1="9" y1="9" x2="15" y2="15"/></svg>';

    function validateRules() {
        var pw = document.getElementById('newPassword').value;
        setRule('rule-length', pw.length >= 8);
        setRule('rule-upper', /[A-Z]/.test(pw));
        setRule('rule-number', /[0-9]/.test(pw));
        validateMatch();
    }

    function setRule(id, passed) {
        var el = document.getElementById(id);
        el.classList.remove('passed', 'failed');
        if (passed) {
            el.classList.add('passed');
            el.querySelector('svg').outerHTML = checkSvg;
        } else {
            el.querySelector('svg').outerHTML = circleSvg;
        }
    }

    function validateMatch() {
        var pw = document.getElementById('newPassword').value;
        var cf = document.getElementById('confirmPassword').value;
        var msg = document.getElementById('matchMsg');
        var cfInput = document.getElementById('confirmPassword');

        if (cf.length === 0) {
            msg.style.display = 'none';
            cfInput.classList.remove('error-input', 'valid-input');
            return;
        }

        msg.style.display = 'block';
        if (pw === cf) {
            msg.innerHTML = '<span style="color:#22c55e">Passwords match</span>';
            cfInput.classList.remove('error-input');
            cfInput.classList.add('valid-input');
        } else {
            msg.innerHTML = '<span style="color:#ef4444">Passwords do not match</span>';
            cfInput.classList.remove('valid-input');
            cfInput.classList.add('error-input');
        }
    }

    function togglePassword(inputId, btn) {
        var input = document.getElementById(inputId);
        if (input.type === 'password') {
            input.type = 'text';
            btn.innerHTML = '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"/><line x1="1" y1="1" x2="23" y2="23"/></svg>';
        } else {
            input.type = 'password';
            btn.innerHTML = '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>';
        }
    }
</script>

</body>
</html>
