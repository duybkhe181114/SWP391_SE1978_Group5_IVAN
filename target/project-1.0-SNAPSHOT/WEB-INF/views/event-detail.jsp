<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>${event.eventName} - Event Details</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #f5f7fa; }
        .detail-container { max-width: 900px; margin: 40px auto; padding: 0 20px; }
        .event-card { background: white; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); overflow: hidden; }
        .event-header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 40px; }
        .event-header h1 { font-size: 32px; margin-bottom: 10px; }
        .event-header .org { font-size: 16px; opacity: 0.9; }
        .event-body { padding: 40px; }
        .info-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 25px; margin-bottom: 30px; }
        .info-item { }
        .info-label { font-size: 12px; color: #7f8c8d; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 5px; }
        .info-value { font-size: 18px; color: #2c3e50; font-weight: 600; }
        .badge { padding: 8px 16px; border-radius: 20px; font-size: 13px; font-weight: 600; display: inline-block; }
        .badge-success { background: #d4edda; color: #155724; }
        .badge-warning { background: #fff3cd; color: #856404; }
        .badge-danger { background: #f8d7da; color: #721c24; }
        .section { margin-top: 30px; padding-top: 30px; border-top: 1px solid #ecf0f1; }
        .section h2 { font-size: 20px; color: #2c3e50; margin-bottom: 15px; }
        .btn-back { display: inline-block; padding: 12px 24px; background: #667eea; color: white; text-decoration: none; border-radius: 8px; font-weight: 600; margin-top: 20px; }
        .btn-back:hover { background: #5568d3; }
    </style>
</head>
<body>
    <jsp:include page="/components/header.jsp"/>
    
    <div class="detail-container">
        <div class="event-card">
            <div class="event-header">
                <h1>${event.eventName}</h1>
                <div class="org">Organized by ${event.organizationName}</div>
            </div>
            
            <div class="event-body">
                <div class="info-grid">
                    <div class="info-item">
                        <div class="info-label">Location</div>
                        <div class="info-value">${event.location}</div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Start Date</div>
                        <div class="info-value">${event.startDate.toLocalDate()}</div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">End Date</div>
                        <div class="info-value">${event.endDate.toLocalDate()}</div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">Status</div>
                        <div class="info-value">
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
                        </div>
                    </div>
                </div>
                
                <a href="${pageContext.request.contextPath}/organization/dashboard" class="btn-back">Back to Dashboard</a>
            </div>
        </div>
    </div>
    
    <jsp:include page="/components/footer.jsp"/>
</body>
</html>
