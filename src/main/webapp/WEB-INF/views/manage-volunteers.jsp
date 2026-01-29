<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Volunteers</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/layout.css">
    <style>
        .container { padding: 60px 0; }
        .volunteer-list { margin-top: 30px; }
        .volunteer-card { background: white; padding: 25px; margin-bottom: 20px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); display: flex; justify-content: space-between; align-items: center; }
        .volunteer-info h3 { margin: 0 0 10px 0; color: #333; }
        .volunteer-info p { margin: 5px 0; color: #666; }
        .status { display: inline-block; padding: 6px 12px; border-radius: 6px; font-size: 12px; font-weight: 600; }
        .status.pending { background: #fff3cd; color: #856404; }
        .status.approved { background: #d4edda; color: #155724; }
        .status.rejected { background: #f8d7da; color: #721c24; }
        .actions { display: flex; gap: 10px; }
        .btn { padding: 10px 20px; border: none; border-radius: 8px; cursor: pointer; font-weight: 600; transition: all 0.3s; }
        .btn-approve { background: #28a745; color: white; }
        .btn-reject { background: #dc3545; color: white; }
        .btn:hover { transform: translateY(-2px); }
    </style>
</head>
<body>
    <jsp:include page="/components/header.jsp"/>
    
    <div class="container">
        <h1>Manage Volunteers</h1>
        
        <div class="volunteer-list">
            <c:forEach items="${volunteers}" var="v">
                <div class="volunteer-card">
                    <div class="volunteer-info">
                        <h3>${v.fullName != null ? v.fullName : v.email}</h3>
                        <p>Email: ${v.email}</p>
                        <p>Phone: ${v.phone != null ? v.phone : 'N/A'}</p>
                        <p>Gender: ${v.gender != null ? v.gender : 'N/A'}</p>
                        <p>Address: ${v.address != null ? v.address : 'N/A'}</p>
                        <p>Registered: ${v.registeredAt}</p>
                        <span class="status ${v.status.toLowerCase()}">${v.status}</span>
                    </div>
                    
                    <c:if test="${v.status == 'Pending'}">
                        <div class="actions">
                            <form method="post" style="display: inline;">
                                <input type="hidden" name="registrationId" value="${v.registrationId}">
                                <input type="hidden" name="eventId" value="${eventId}">
                                <input type="hidden" name="action" value="approve">
                                <button type="submit" class="btn btn-approve">Approve</button>
                            </form>
                            <form method="post" style="display: inline;">
                                <input type="hidden" name="registrationId" value="${v.registrationId}">
                                <input type="hidden" name="eventId" value="${eventId}">
                                <input type="hidden" name="action" value="reject">
                                <button type="submit" class="btn btn-reject">Reject</button>
                            </form>
                        </div>
                    </c:if>
                </div>
            </c:forEach>
        </div>
    </div>
    
    <jsp:include page="/components/footer.jsp"/>
</body>
</html>
