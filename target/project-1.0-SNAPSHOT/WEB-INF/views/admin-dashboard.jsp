<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #f5f7fa; }
        .dashboard { padding: 30px; max-width: 1400px; margin: 0 auto; }
        .page-title { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 40px; border-radius: 12px; margin-bottom: 30px; box-shadow: 0 4px 15px rgba(102,126,234,0.3); }
        .page-title h1 { font-size: 32px; margin-bottom: 8px; font-weight: 700; }
        .page-title p { font-size: 16px; opacity: 0.95; }
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px; margin-bottom: 30px; }
        .stat-card { background: white; padding: 25px; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); border-left: 4px solid #667eea; }
        .stat-label { font-size: 13px; color: #7f8c8d; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 8px; }
        .stat-value { font-size: 36px; font-weight: 700; color: #2c3e50; }
        .actions { background: white; padding: 25px; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
        .actions h2 { font-size: 18px; color: #2c3e50; margin-bottom: 15px; }
        .btn-group { display: flex; gap: 12px; flex-wrap: wrap; }
        .btn { padding: 12px 24px; border-radius: 8px; text-decoration: none; font-weight: 600; font-size: 14px; transition: all 0.3s; display: inline-block; }
        .btn-primary { background: #667eea; color: white; }
        .btn-primary:hover { background: #5568d3; transform: translateY(-2px); box-shadow: 0 4px 12px rgba(102,126,234,0.4); }
    </style>
</head>
<body>
    <jsp:include page="/components/header.jsp"/>
    
    <div class="dashboard">
        <div class="page-title">
            <h1>Admin Dashboard</h1>
            <p>Manage platform and oversee all activities</p>
        </div>
        
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-label">Total Users</div>
                <div class="stat-value">${totalUsers != null ? totalUsers : 0}</div>
            </div>
            <div class="stat-card">
                <div class="stat-label">Total Organizations</div>
                <div class="stat-value">${totalOrganizations != null ? totalOrganizations : 0}</div>
            </div>
            <div class="stat-card">
                <div class="stat-label">Total Events</div>
                <div class="stat-value">${totalEvents != null ? totalEvents : 0}</div>
            </div>
        </div>
        
        <div class="actions">
            <h2>Quick Actions</h2>
            <div class="btn-group">
                <a href="${pageContext.request.contextPath}/admin/manage-events" class="btn btn-primary">Manage Events</a>
            </div>
        </div>
    </div>
    
    <jsp:include page="/components/footer.jsp"/>
</body>
</html>
