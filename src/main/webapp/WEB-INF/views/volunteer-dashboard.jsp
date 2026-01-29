<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Volunteer Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/layout.css">
    <style>
        .dashboard { padding: 60px 0; background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); min-height: 100vh; }
        .dashboard-header { color: white; margin-bottom: 40px; }
        .dashboard-header h1 { font-size: 42px; margin: 0 0 10px 0; }
        .dashboard-header p { font-size: 18px; opacity: 0.9; }
        .stats { display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 25px; margin: 40px 0; }
        .stat-card { 
            background: white; 
            padding: 35px; 
            border-radius: 16px; 
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
            transition: transform 0.3s, box-shadow 0.3s;
            position: relative;
            overflow: hidden;
        }
        .stat-card:hover { transform: translateY(-5px); box-shadow: 0 15px 40px rgba(0,0,0,0.2); }
        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 4px;
            height: 100%;
            background: linear-gradient(180deg, #f093fb 0%, #f5576c 100%);
        }
        .stat-card h3 { margin: 0 0 15px 0; color: #666; font-size: 15px; text-transform: uppercase; letter-spacing: 1px; }
        .stat-card .number { font-size: 48px; font-weight: bold; background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
        .stat-card .icon { position: absolute; right: 20px; top: 20px; font-size: 40px; opacity: 0.1; }
        .actions { margin: 40px 0; display: flex; gap: 15px; flex-wrap: wrap; }
        .btn { 
            display: inline-block; 
            padding: 16px 32px; 
            background: white;
            color: #f5576c; 
            text-decoration: none; 
            border-radius: 12px; 
            font-weight: 600;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            transition: all 0.3s;
        }
        .btn:hover { transform: translateY(-2px); box-shadow: 0 6px 20px rgba(0,0,0,0.15); background: #fff5f7; }
        .recent-section { background: white; padding: 35px; border-radius: 16px; box-shadow: 0 10px 30px rgba(0,0,0,0.15); margin-top: 30px; }
        .recent-section h2 { margin: 0 0 20px 0; color: #333; }
        .progress-bar { background: #f0f0f0; height: 8px; border-radius: 4px; overflow: hidden; margin-top: 10px; }
        .progress-fill { background: linear-gradient(90deg, #f093fb 0%, #f5576c 100%); height: 100%; border-radius: 4px; }
    </style>
</head>
<body>
    <jsp:include page="/components/header.jsp"/>
    
    <div class="dashboard">
        <div class="container">
            <div class="dashboard-header">
                <h1>Volunteer Dashboard</h1>
                <p>Welcome back, <strong>${volunteerName}</strong>!</p>
            </div>
            
            <div class="stats">
                <div class="stat-card">
                    <h3>Registered Events</h3>
                    <div class="number">${registeredEvents}</div>
                </div>
                <div class="stat-card">
                    <h3>Completed Events</h3>
                    <div class="number">${completedEvents}</div>
                    <div class="progress-bar">
                        <div class="progress-fill" style="width: ${(completedEvents * 100) / registeredEvents}%"></div>
                    </div>
                </div>
                <div class="stat-card">
                    <h3>Upcoming Events</h3>
                    <div class="number">${upcomingEvents}</div>
                </div>
            </div>
            
            <div class="actions">
                <a href="${pageContext.request.contextPath}/home" class="btn">Browse Events</a>
                <a href="#" class="btn">My Registrations</a>
                <a href="#" class="btn">My Profile</a>
            </div>
            
            <div class="recent-section">
                <h2>My Upcoming Events</h2>
                <p style="color: #666;">Your registered events and schedules will appear here.</p>
            </div>
        </div>
    </div>
    
    <jsp:include page="/components/footer.jsp"/>
</body>
</html>
