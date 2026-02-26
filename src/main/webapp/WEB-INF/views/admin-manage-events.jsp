<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Events - Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #f5f7fa; }
        .dashboard { padding: 30px; max-width: 1400px; margin: 0 auto; }
        .page-title { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 40px; border-radius: 12px; margin-bottom: 30px; box-shadow: 0 4px 15px rgba(102,126,234,0.3); }
        .page-title h1 { font-size: 32px; margin-bottom: 8px; font-weight: 700; }
        .page-title p { font-size: 16px; opacity: 0.95; }
        .events-section { background: white; padding: 25px; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
        .events-section h2 { font-size: 20px; color: #2c3e50; margin-bottom: 20px; }
        .events-table { width: 100%; border-collapse: collapse; }
        .events-table thead { background: #f8f9fa; }
        .events-table th { padding: 15px; text-align: left; font-size: 13px; color: #7f8c8d; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; }
        .events-table td { padding: 15px; border-bottom: 1px solid #ecf0f1; color: #2c3e50; }
        .events-table tr:hover { background: #f8f9fa; }
        .badge { padding: 6px 12px; border-radius: 20px; font-size: 12px; font-weight: 600; display: inline-block; }
        .badge-warning { background: #fff3cd; color: #856404; }
        .btn-action { padding: 8px 16px; border: none; border-radius: 6px; font-size: 13px; font-weight: 600; cursor: pointer; margin-right: 8px; }
        .btn-approve { background: #28a745; color: white; }
        .btn-approve:hover { background: #218838; }
        .btn-reject { background: #dc3545; color: white; }
        .btn-reject:hover { background: #c82333; }
        .empty-state { text-align: center; padding: 60px 20px; color: #7f8c8d; }
    </style>
</head>
<body>
    <jsp:include page="/components/header.jsp"/>
    
    <div class="dashboard">
        <div class="page-title">
            <h1>Manage Events</h1>
            <p>Review and approve pending events from organizations</p>
        </div>
        
        <div class="events-section">
            <h2>Pending Events</h2>
            <c:if test="${empty pendingEvents}">
                <div class="empty-state">
                    <p style="font-size: 16px; margin-bottom: 8px;">No pending events</p>
                    <p style="font-size: 14px;">All events have been reviewed</p>
                </div>
            </c:if>
            <c:if test="${not empty pendingEvents}">
                <table class="events-table">
                    <thead>
                        <tr>
                            <th>Event Title</th>
                            <th>Organization</th>
                            <th>Location</th>
                            <th>Start Date</th>
                            <th>End Date</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="event" items="${pendingEvents}">
                            <tr>
                                <td><strong>${event.eventName}</strong></td>
                                <td>${event.organizationName}</td>
                                <td>${event.location}</td>
                                <td>${event.startDate.toLocalDate()}</td>
                                <td>${event.endDate.toLocalDate()}</td>
                                <td>
                                    <span class="badge badge-warning">Pending</span>
                                </td>
                                <td>
                                    <form method="post" style="display: inline;">
                                        <input type="hidden" name="eventId" value="${event.eventId}">
                                        <input type="hidden" name="action" value="approve">
                                        <button type="submit" class="btn-action btn-approve">Approve</button>
                                    </form>
                                    <form method="post" style="display: inline;">
                                        <input type="hidden" name="eventId" value="${event.eventId}">
                                        <input type="hidden" name="action" value="reject">
                                        <button type="submit" class="btn-action btn-reject">Reject</button>
                                    </form>
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
