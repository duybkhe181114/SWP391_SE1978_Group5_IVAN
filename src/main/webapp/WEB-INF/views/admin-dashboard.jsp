<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', 'Segoe UI', sans-serif; background: #f8fafc; }
        .dashboard { padding: 30px; max-width: 1600px; margin: 0 auto; }
        .page-title { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 40px; border-radius: 16px; margin-bottom: 30px; box-shadow: 0 10px 40px rgba(102,126,234,0.3); }
        .page-title h1 { font-size: 36px; margin-bottom: 8px; font-weight: 700; }
        .page-title p { font-size: 16px; opacity: 0.95; }
        
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 24px; margin-bottom: 30px; }
        .stat-card { background: white; padding: 28px; border-radius: 16px; box-shadow: 0 4px 20px rgba(0,0,0,0.06); position: relative; overflow: hidden; transition: transform 0.3s, box-shadow 0.3s; }
        .stat-card:hover { transform: translateY(-5px); box-shadow: 0 8px 30px rgba(0,0,0,0.12); }
        .stat-card::before { content: ''; position: absolute; top: 0; left: 0; width: 100%; height: 4px; }
        .stat-card.users::before { background: linear-gradient(90deg, #667eea, #764ba2); }
        .stat-card.orgs::before { background: linear-gradient(90deg, #f093fb, #f5576c); }
        .stat-card.events::before { background: linear-gradient(90deg, #4facfe, #00f2fe); }
        .stat-card.regs::before { background: linear-gradient(90deg, #43e97b, #38f9d7); }
        .stat-label { font-size: 14px; color: #64748b; font-weight: 500; margin-bottom: 12px; }
        .stat-value { font-size: 40px; font-weight: 700; color: #1e293b; }
        
        .charts-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 24px; margin-bottom: 30px; }
        .chart-container { background: white; padding: 32px; border-radius: 16px; box-shadow: 0 4px 20px rgba(0,0,0,0.06); }
        .chart-container h2 { font-size: 20px; color: #1e293b; margin-bottom: 24px; font-weight: 600; }
        .chart-wrapper { position: relative; height: 300px; }
        .chart-wrapper.small { height: 250px; }
        
        .actions { background: white; padding: 32px; border-radius: 16px; box-shadow: 0 4px 20px rgba(0,0,0,0.06); }
        .actions h2 { font-size: 20px; color: #1e293b; margin-bottom: 20px; font-weight: 600; }
        .btn-group { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; align-items: stretch; }
        .btn { padding: 14px 28px; border-radius: 10px; text-decoration: none; font-weight: 600; font-size: 15px; line-height: 1.5; transition: all 0.3s; display: flex; align-items: center; justify-content: center; text-align: center; min-height: 50px; }
        .btn-primary { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; }
        .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(102,126,234,0.4); }
        .btn-secondary { background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); color: white; }
        .btn-secondary:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(245,87,108,0.4); }
        
        @media (max-width: 1024px) {
            .charts-grid { grid-template-columns: 1fr; }
        }
        @media (max-width: 768px) {
            .stats-grid { grid-template-columns: 1fr; }
        }
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
            <div class="stat-card users">
                <div class="stat-label">Total Users</div>
                <div class="stat-value">${totalUsers != null ? totalUsers : 0}</div>
            </div>
            <div class="stat-card orgs">
                <div class="stat-label">Total Organizations</div>
                <div class="stat-value">${totalOrganizations != null ? totalOrganizations : 0}</div>
            </div>
            <div class="stat-card events">
                <div class="stat-label">Total Events</div>
                <div class="stat-value">${totalEvents != null ? totalEvents : 0}</div>
            </div>
            <div class="stat-card regs">
                <div class="stat-label">Total Registrations</div>
                <div class="stat-value">${totalRegistrations != null ? totalRegistrations : 0}</div>
            </div>
        </div>
        
        <div class="charts-grid">
            <div class="chart-container">
                <h2>Event Status</h2>
                <div class="chart-wrapper small">
                    <canvas id="statusChart"></canvas>
                </div>
            </div>
            
            <div class="chart-container">
                <h2>System Distribution</h2>
                <div class="chart-wrapper small">
                    <canvas id="distributionChart"></canvas>
                </div>
            </div>
        </div>
        
        <div class="actions">
            <h2>Quick Actions</h2>
            <div class="btn-group">
                <a href="${pageContext.request.contextPath}/admin/manage-events" class="btn btn-primary">Manage Events</a>
                <a href="${pageContext.request.contextPath}/admin/review-organizations" class="btn btn-secondary">Review Organizations</a>
            </div>
        </div>
    </div>
    
    <script>
        // Doughnut Chart - Event Status
        const statusCtx = document.getElementById('statusChart').getContext('2d');
        new Chart(statusCtx, {
            type: 'doughnut',
            data: {
                labels: ['Approved', 'Pending', 'Rejected'],
                datasets: [{
                    data: [
                        ${approvedEvents != null ? approvedEvents : 0},
                        ${pendingEvents != null ? pendingEvents : 0},
                        ${rejectedEvents != null ? rejectedEvents : 0}
                    ],
                    backgroundColor: [
                        'rgba(67, 233, 123, 0.8)',
                        'rgba(255, 193, 7, 0.8)',
                        'rgba(239, 68, 68, 0.8)'
                    ],
                    borderWidth: 0,
                    hoverOffset: 10
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: {
                            padding: 20,
                            font: { size: 13, weight: '500' },
                            usePointStyle: true,
                            pointStyle: 'circle'
                        }
                    },
                    tooltip: {
                        backgroundColor: 'rgba(0,0,0,0.8)',
                        padding: 12,
                        cornerRadius: 8,
                        titleFont: { size: 14, weight: 'bold' },
                        bodyFont: { size: 13 }
                    }
                }
            }
        });
        
        // Pie Chart - Distribution
        const distCtx = document.getElementById('distributionChart').getContext('2d');
        new Chart(distCtx, {
            type: 'pie',
            data: {
                labels: ['Users', 'Organizations', 'Events'],
                datasets: [{
                    data: [
                        ${totalUsers != null ? totalUsers : 0},
                        ${totalOrganizations != null ? totalOrganizations : 0},
                        ${totalEvents != null ? totalEvents : 0}
                    ],
                    backgroundColor: [
                        'rgba(102, 126, 234, 0.8)',
                        'rgba(245, 87, 108, 0.8)',
                        'rgba(79, 172, 254, 0.8)'
                    ],
                    borderWidth: 0,
                    hoverOffset: 10
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: {
                            padding: 20,
                            font: { size: 13, weight: '500' },
                            usePointStyle: true,
                            pointStyle: 'circle'
                        }
                    },
                    tooltip: {
                        backgroundColor: 'rgba(0,0,0,0.8)',
                        padding: 12,
                        cornerRadius: 8,
                        titleFont: { size: 14, weight: 'bold' },
                        bodyFont: { size: 13 }
                    }
                }
            }
        });
        

    </script>
    
    <jsp:include page="/components/footer.jsp"/>
</body>
</html>
