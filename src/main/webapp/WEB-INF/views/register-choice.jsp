<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Choose Account Type - IVAN</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <style>
        body { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); min-height: 100vh; display: flex; align-items: center; justify-content: center; font-family: 'Inter', sans-serif; padding: 20px; }
        .choice-container { background: white; padding: 50px; border-radius: 20px; box-shadow: 0 20px 60px rgba(0,0,0,0.3); max-width: 1050px; width: 100%; }
        .choice-container h1 { text-align: center; color: #1e293b; margin-bottom: 10px; font-size: 32px; }
        .choice-container > p { text-align: center; color: #64748b; margin-bottom: 40px; font-size: 16px; }
        .choice-grid { display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 24px; }
        .choice-card { border: 2px solid #e2e8f0; border-radius: 16px; padding: 36px 28px; text-align: center; transition: all 0.3s; cursor: pointer; text-decoration: none; display: block; position: relative; overflow: hidden; }
        .choice-card::before { content: ''; position: absolute; top: 0; left: 0; right: 0; bottom: 0; background-size: cover; background-position: center; opacity: 0.06; transition: opacity 0.3s; }
        .choice-card:hover::before { opacity: 0.12; }
        .choice-card.user::before { background: linear-gradient(135deg, #667eea, #764ba2); }
        .choice-card.volunteer::before { background-image: url('https://i0.wp.com/altlig.com/wp-content/uploads/2018/10/volunteer.png?fit=1280%2C882&ssl=1'); }
        .choice-card.organization::before { background-image: url('https://cdn.vietnambiz.vn/2019/10/1/shutterstock382125727-e1516637190758-15699092646491351591929.jpg'); }
        .choice-card > * { position: relative; z-index: 1; }
        .choice-card:hover { border-color: #667eea; transform: translateY(-5px); box-shadow: 0 10px 30px rgba(102,126,234,0.2); }
        .choice-card .icon { font-size: 56px; margin-bottom: 16px; }
        .choice-card h2 { color: #1e293b; margin-bottom: 12px; font-size: 22px; }
        .choice-card .description { color: #64748b; font-size: 13px; line-height: 1.7; margin-bottom: 20px; }
        .choice-card .feature { color: #475569; font-size: 13px; text-align: left; margin-bottom: 20px; }
        .choice-card .feature li { margin-bottom: 6px; list-style: none; padding-left: 0; }
        .choice-card .feature li::before { content: '✓ '; color: #22c55e; font-weight: 700; }
        .choice-card .btn { display: inline-block; padding: 11px 28px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; border-radius: 8px; font-weight: 600; font-size: 14px; }
        .badge-instant { display: inline-block; background: #dcfce7; color: #166534; font-size: 11px; font-weight: 600; padding: 3px 10px; border-radius: 20px; margin-bottom: 12px; }
        .badge-pending { display: inline-block; background: #fef3c7; color: #92400e; font-size: 11px; font-weight: 600; padding: 3px 10px; border-radius: 20px; margin-bottom: 12px; }
        .login-link { text-align: center; margin-top: 30px; color: #64748b; font-size: 14px; }
        .login-link a { color: #667eea; font-weight: 600; text-decoration: none; }
        .login-link a:hover { text-decoration: underline; }
        @media (max-width: 768px) { .choice-grid { grid-template-columns: 1fr; } }
    </style>
</head>
<body>
    <div class="choice-container">
        <h1>Join IVAN</h1>
        <p>Choose your account type to get started</p>

        <div class="choice-grid">

            <a href="${pageContext.request.contextPath}/register/user" class="choice-card user">
                <div class="icon">👤</div>
                <span class="badge-instant">Instant Activation</span>
                <h2>User</h2>
                <div class="description">Create a personal account to submit support requests and track their status.</div>
                <ul class="feature">
                    <li>Submit support requests</li>
                    <li>Track request status</li>
                    <li>Simple registration</li>
                </ul>
                <span class="btn">Register as User</span>
            </a>

            <a href="${pageContext.request.contextPath}/register/volunteer" class="choice-card volunteer">
                <div class="icon">🙋</div>
                <span class="badge-instant">Instant Activation</span>
                <h2>Volunteer</h2>
                <div class="description">Join as an individual volunteer to participate in community events and make a difference.</div>
                <ul class="feature">
                    <li>Browse & join events</li>
                    <li>Track your schedule</li>
                    <li>Build your profile</li>
                </ul>
                <span class="btn">Register as Volunteer</span>
            </a>

            <a href="${pageContext.request.contextPath}/register/organization" class="choice-card organization">
                <div class="icon">🏢</div>
                <span class="badge-pending">Requires Approval</span>
                <h2>Organization</h2>
                <div class="description">Register your organization to create events and recruit volunteers for your causes.</div>
                <ul class="feature">
                    <li>Create unlimited events</li>
                    <li>Manage volunteers</li>
                    <li>Accept support requests</li>
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
