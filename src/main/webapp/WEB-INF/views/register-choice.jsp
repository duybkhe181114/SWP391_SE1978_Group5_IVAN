<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Choose Account Type - IVAN</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); min-height: 100vh; display: flex; align-items: center; justify-content: center; font-family: 'Inter', sans-serif; padding: 20px; }
        .choice-container { background: white; padding: 50px; border-radius: 20px; box-shadow: 0 20px 60px rgba(0,0,0,0.3); max-width: 1100px; width: 100%; }
        .choice-container h1 { text-align: center; color: #1e293b; margin-bottom: 8px; font-size: 32px; font-weight: 700; }
        .choice-container > p { text-align: center; color: #64748b; margin-bottom: 40px; font-size: 16px; }

        .choice-grid { display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 24px; }

        .choice-card {
            border: 2px solid #e2e8f0; border-radius: 16px; padding: 32px 24px;
            text-align: center; transition: all 0.3s; cursor: pointer;
            text-decoration: none; display: flex; flex-direction: column; align-items: center;
            position: relative; overflow: hidden; background: white;
        }
        .choice-card:hover { border-color: #6366f1; transform: translateY(-5px); box-shadow: 0 12px 30px rgba(99,102,241,0.15); }

        .choice-card .icon-circle {
            width: 72px; height: 72px; border-radius: 50%; display: flex; align-items: center;
            justify-content: center; margin-bottom: 20px;
        }
        .choice-card .icon-circle svg { width: 36px; height: 36px; }

        .choice-card.user .icon-circle { background: #eff6ff; }
        .choice-card.user .icon-circle svg { color: #3b82f6; }
        .choice-card.volunteer .icon-circle { background: #f0fdf4; }
        .choice-card.volunteer .icon-circle svg { color: #22c55e; }
        .choice-card.organization .icon-circle { background: #fef3c7; }
        .choice-card.organization .icon-circle svg { color: #f59e0b; }

        .choice-card h2 { color: #1e293b; margin-bottom: 12px; font-size: 20px; font-weight: 700; }
        .choice-card .description { color: #64748b; font-size: 13px; line-height: 1.7; margin-bottom: 20px; flex-grow: 1; }
        .choice-card .features { text-align: left; width: 100%; margin-bottom: 20px; }
        .choice-card .features li {
            list-style: none; padding: 6px 0; font-size: 13px; color: #475569;
            display: flex; align-items: center; gap: 8px;
        }
        .choice-card .features li svg { width: 16px; height: 16px; color: #22c55e; flex-shrink: 0; }
        .choice-card .features li.disabled { color: #cbd5e1; }
        .choice-card .features li.disabled svg { color: #cbd5e1; }

        .choice-card .btn {
            display: inline-block; padding: 12px 28px; border-radius: 10px;
            font-weight: 600; font-size: 14px; transition: all 0.2s; width: 100%;
        }
        .choice-card.user .btn { background: #3b82f6; color: white; }
        .choice-card.volunteer .btn { background: #22c55e; color: white; }
        .choice-card.organization .btn { background: #f59e0b; color: white; }

        .login-link { text-align: center; margin-top: 30px; color: #64748b; font-size: 14px; }
        .login-link a { color: #6366f1; font-weight: 600; text-decoration: none; }
        .login-link a:hover { text-decoration: underline; }

        @media (max-width: 800px) { .choice-grid { grid-template-columns: 1fr; } }
    </style>
</head>
<body>
    <div class="choice-container">
        <h1>Join IVAN</h1>
        <p>Choose your account type to get started</p>

        <div class="choice-grid">

            <!-- USER -->
            <a href="${pageContext.request.contextPath}/register/user" class="choice-card user">
                <div class="icon-circle">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></svg>
                </div>
                <h2>User</h2>
                <div class="description">Register as a regular user to browse and create support requests.</div>
                <ul class="features">
                    <li>
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"/></svg>
                        Instant activation
                    </li>
                    <li>
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"/></svg>
                        Create support requests
                    </li>
                    <li>
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"/></svg>
                        Browse events
                    </li>
                    <li class="disabled">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
                        Cannot join events
                    </li>
                </ul>
                <span class="btn">Register as User</span>
            </a>

            <!-- VOLUNTEER -->
            <a href="${pageContext.request.contextPath}/register/volunteer" class="choice-card volunteer">
                <div class="icon-circle">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
                </div>
                <h2>Volunteer</h2>
                <div class="description">Join as a volunteer to participate in community events and make a difference.</div>
                <ul class="features">
                    <li>
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"/></svg>
                        Instant activation
                    </li>
                    <li>
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"/></svg>
                        Create support requests
                    </li>
                    <li>
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"/></svg>
                        Browse events
                    </li>
                    <li>
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"/></svg>
                        Join & participate in events
                    </li>
                </ul>
                <span class="btn">Register as Volunteer</span>
            </a>

            <!-- ORGANIZATION -->
            <a href="${pageContext.request.contextPath}/register/organization" class="choice-card organization">
                <div class="icon-circle">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/></svg>
                </div>
                <h2>Organization</h2>
                <div class="description">Register your organization to create events and recruit volunteers.</div>
                <ul class="features">
                    <li>
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"/></svg>
                        Create unlimited events
                    </li>
                    <li>
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"/></svg>
                        Manage volunteers
                    </li>
                    <li>
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"/></svg>
                        Accept support requests
                    </li>
                    <li class="disabled">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                        Requires admin approval
                    </li>
                </ul>
                <span class="btn">Register as Organization</span>
            </a>

        </div>

        <div class="login-link">
            Already have an account? <a href="${pageContext.request.contextPath}/login">Login here</a>
        </div>
    </div>
</body>
</html>
