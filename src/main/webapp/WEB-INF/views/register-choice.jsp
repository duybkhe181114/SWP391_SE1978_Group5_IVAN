<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Choose Account Type - IVAN</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <style>
        body { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); min-height: 100vh; display: flex; align-items: center; justify-content: center; font-family: 'Inter', sans-serif; padding: 20px; }
        .choice-container { background: white; padding: 50px; border-radius: 20px; box-shadow: 0 20px 60px rgba(0,0,0,0.3); max-width: 900px; width: 100%; }
        .choice-container h1 { text-align: center; color: #333; margin-bottom: 15px; font-size: 32px; }
        .choice-container p { text-align: center; color: #666; margin-bottom: 40px; font-size: 16px; }
        .choice-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 30px; }
        .choice-card { border: 3px solid #e0e0e0; border-radius: 16px; padding: 40px; text-align: center; transition: all 0.3s; cursor: pointer; text-decoration: none; display: block; position: relative; overflow: hidden; }
        .choice-card::before { content: ''; position: absolute; top: 0; left: 0; right: 0; bottom: 0; background-size: cover; background-position: center; opacity: 0.1; transition: opacity 0.3s; }
        .choice-card:hover::before { opacity: 0.15; }
        .choice-card.volunteer::before { background-image: url('https://i0.wp.com/altlig.com/wp-content/uploads/2018/10/volunteer.png?fit=1280%2C882&ssl=1'); }
        .choice-card.organization::before { background-image: url('https://cdn.vietnambiz.vn/2019/10/1/shutterstock382125727-e1516637190758-15699092646491351591929.jpg'); }
        .choice-card > * { position: relative; z-index: 1; }
        .choice-card:hover { border-color: #667eea; transform: translateY(-5px); box-shadow: 0 10px 30px rgba(102,126,234,0.2); }
        .choice-card .icon { font-size: 64px; margin-bottom: 20px; }
        .choice-card h2 { color: #333; margin-bottom: 15px; font-size: 24px; }
        .choice-card .description { color: #666; font-size: 14px; line-height: 1.6; margin-bottom: 20px; }
        .choice-card .btn { display: inline-block; padding: 12px 30px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; border-radius: 8px; font-weight: 600; margin-top: 10px; }
        .login-link { text-align: center; margin-top: 30px; color: #666; }
        .login-link a { color: #667eea; font-weight: 600; text-decoration: none; }
    </style>
</head>
<body>
    <div class="choice-container">
        <h1>Join IVAN</h1>
        <p>Choose your account type to get started</p>
        
        <div class="choice-grid">
            <a href="${pageContext.request.contextPath}/register/volunteer" class="choice-card volunteer">
                <div class="icon"></div>
                <h2>Volunteer</h2>
                <div class="description">
                    Join as an individual volunteer to participate in community events and make a difference.
                    <br><br>
                    Instant activation<br>
                    Browse events immediately<br>
                    Simple registration
                </div>
                <span class="btn">Register as Volunteer</span>
            </a>
            
            <a href="${pageContext.request.contextPath}/register/organization" class="choice-card organization">
                <div class="icon"></div>
                <h2>Organization</h2>
                <div class="description">
                    Register your organization to create events and recruit volunteers for your causes.
                    <br><br>
                    Requires admin approval<br>
                    Create unlimited events<br>
                    Manage volunteers
                </div>
                <span class="btn">Register as Organization</span>
            </a>
        </div>
        
        <div class="login-link">
            Already have an account? <a href="${pageContext.request.contextPath}/login">Login here</a>
        </div>
    </div>
</body>
</html>
