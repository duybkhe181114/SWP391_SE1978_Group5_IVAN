<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Organization Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #f5f7fa; }
        .dashboard { padding: 30px; max-width: 1400px; margin: 0 auto; }
        .page-title { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 40px; border-radius: 12px; margin-bottom: 30px; box-shadow: 0 4px 15px rgba(102,126,234,0.3); }
        .page-title h1 { font-size: 32px; margin-bottom: 8px; font-weight: 700; }
        .page-title p { font-size: 16px; opacity: 0.95; }
        .alert-success { background: #d4edda; border-left: 4px solid #28a745; color: #155724; padding: 15px 20px; border-radius: 8px; margin-bottom: 20px; }
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px; margin-bottom: 30px; }
        .stat-card { background: white; padding: 25px; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); border-left: 4px solid #667eea; }
        .stat-card.approved { border-left-color: #28a745; }
        .stat-card.pending { border-left-color: #ffc107; }
        .stat-label { font-size: 13px; color: #7f8c8d; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 8px; }
        .stat-value { font-size: 36px; font-weight: 700; color: #2c3e50; }
        .actions { background: white; padding: 25px; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); margin-bottom: 30px; }
        .actions h2 { font-size: 18px; color: #2c3e50; margin-bottom: 15px; }
        .btn-group { display: flex; gap: 12px; flex-wrap: wrap; }
        .btn { padding: 12px 24px; border-radius: 8px; text-decoration: none; font-weight: 600; font-size: 14px; transition: all 0.3s; display: inline-block; }
        .btn-primary { background: #667eea; color: white; }
        .btn-primary:hover { background: #5568d3; transform: translateY(-2px); box-shadow: 0 4px 12px rgba(102,126,234,0.4); }
        .events-section { background: white; padding: 25px; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
        .events-section h2 { font-size: 20px; color: #2c3e50; margin-bottom: 20px; }
        .events-table { width: 100%; border-collapse: collapse; }
        .events-table thead { background: #f8f9fa; }
        .events-table th { padding: 15px; text-align: left; font-size: 13px; color: #7f8c8d; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; }
        .events-table td { padding: 15px; border-bottom: 1px solid #ecf0f1; color: #2c3e50; }
        .events-table tr:hover { background: #f8f9fa; }
        .badge { padding: 6px 12px; border-radius: 20px; font-size: 12px; font-weight: 600; display: inline-block; }
        .badge-success { background: #d4edda; color: #155724; }
        .badge-warning { background: #fff3cd; color: #856404; }
        .badge-danger { background: #f8d7da; color: #721c24; }
        .btn-view { padding: 6px 16px; background: #667eea; color: white; text-decoration: none; border-radius: 6px; font-size: 13px; }
        .btn-view:hover { background: #5568d3; }
        .empty-state { text-align: center; padding: 60px 20px; color: #7f8c8d; }
    </style>
</head>
<body>
    <jsp:include page="/components/header.jsp"/>
    
    <div class="dashboard">
        <div class="page-title">
            <h1>Organization Dashboard</h1>
            <p>Manage your events and track performance</p>
        </div>
        
        <c:if test="${param.msg != null}">
            <div class="alert-success">${param.msg}</div>
        </c:if>
        
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-label">Total Events</div>
                <div class="stat-value">${totalEvents != null ? totalEvents : 0}</div>
            </div>
            <div class="stat-card approved">
                <div class="stat-label">Approved Events</div>
                <div class="stat-value">${approvedEvents != null ? approvedEvents : 0}</div>
            </div>
            <div class="stat-card pending">
                <div class="stat-label">Pending Approval</div>
                <div class="stat-value">${pendingEvents != null ? pendingEvents : 0}</div>
            </div>
        </div>
        
        <div class="actions">
            <h2>Quick Actions</h2>
            <div class="btn-group">
                <a href="${pageContext.request.contextPath}/organization/create-event" class="btn btn-primary">+ Create New Event</a>
            </div>
        </div>
        
        <div class="events-section">
            <h2>Your Events</h2>
            <c:if test="${empty events}">
                <div class="empty-state">
                    <p style="font-size: 16px; margin-bottom: 8px;">No events yet</p>
                    <p style="font-size: 14px;">Create your first event to get started!</p>
                </div>
            </c:if>
            <c:if test="${not empty events}">
                <table class="events-table">
                    <thead>
                        <tr>
                            <th>Event Title</th>
                            <th>Location</th>
                            <th>Start Date</th>
                            <th>End Date</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="event" items="${events}">
                            <tr>
                                <td><strong>${event.eventName}</strong></td>
                                <td>${event.location}</td>
                                <td>${event.startDate.toLocalDate()}</td>
                                <td>${event.endDate.toLocalDate()}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${event.status == 'Approved'}">
                                            <span class="badge badge-success">Approved</span>
                                        </c:when>
                                        <c:when test="${event.status == 'Pending'}">
                                            <span class="badge badge-warning">Pending</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-danger">Rejected</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/event/detail?id=${event.eventId}" class="btn-view">View Details</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:if>
        </div>
    </div>
    
    <jsp:include page="/components/footer.jsp"/>
</body>
</html>
