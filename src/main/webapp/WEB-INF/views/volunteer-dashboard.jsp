<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Volunteer Dashboard - IVAN</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">

    <style>
        .stat-card {
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            border: 1px solid #e2e8f0;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        .stat-card h3 {
            margin: 0 0 10px 0;
            color: #64748b;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .stat-card .number {
            font-size: 36px;
            font-weight: 700;
            color: #0f172a;
        }
        .stat-card.primary { border-top: 4px solid #667eea; }
        .stat-card.success { border-top: 4px solid #22c55e; }
        .stat-card.warning { border-top: 4px solid #eab308; }
    </style>
</head>
<body>
    <jsp:include page="/components/header.jsp"/>

    <div class="admin-page">
        <div class="admin-container">

            <h2 class="section-title" style="margin-bottom: 5px;">
                <span style="color: #667eea;">●</span> Dashboard
            </h2>
            <p style="color: #64748b; margin-bottom: 30px;">
                Welcome back, <strong>${not empty sessionScope.userName ? sessionScope.userName : 'Volunteer'}</strong>! Here is your activity overview.
            </p>

            <div class="form-grid" style="grid-template-columns: repeat(3, 1fr); gap: 20px; margin-bottom: 40px;">
                <div class="stat-card primary">
                    <h3>Total Applied</h3>
                    <div class="number">${registeredEvents}</div>
                </div>
                <div class="stat-card warning">
                    <h3>Upcoming Events</h3>
                    <div class="number">${upcomingEvents}</div>
                </div>
                <div class="stat-card success">
                    <h3>Completed Events</h3>
                    <div class="number">${completedEvents}</div>
                </div>
            </div>

            <div style="margin-bottom: 30px; display: flex; gap: 15px;">
                <a href="${pageContext.request.contextPath}/events" class="btn-primary" style="text-decoration: none; padding: 10px 20px;">
                    Find New Events
                </a>
                <a href="${pageContext.request.contextPath}/profile" class="btn-clear" style="text-decoration: none; padding: 10px 20px;">
                    Update Profile
                </a>
            </div>

<h2 id="workspaces" class="section-title" style="font-size: 20px; border: none; margin-bottom: 15px; scroll-margin-top: 80px;">
    My Applications & Workspaces
</h2>

            <div class="admin-table-wrapper">
                <table class="table admin-table">
                    <thead>
                        <tr>
                            <th style="width: 50px;">#</th>
                            <th>Event Name</th>
                            <th>Location</th>
                            <th>Date</th>
                            <th>Status</th>
                            <th style="width: 120px; text-align: center;">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${myEvents}" var="e" varStatus="loop">
                            <tr>
                                <td><span style="color: #94a3b8;">${loop.index + 1}</span></td>
                                <td style="font-weight: 500; color: #0f172a;">${e.eventName}</td>
                                <td style="color: #64748b;">${e.location}</td>
                                <td style="color: #64748b; font-size: 14px;">
                                    <fmt:formatDate value="${e.startDateAsDate}" pattern="dd MMM, yyyy"/>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${e.status == 'Approved'}">
                                            <span class="badge badge-active">Approved</span>
                                        </c:when>
                                        <c:when test="${e.status == 'Rejected'}">
                                            <span class="badge badge-inactive" style="background: #fee2e2; color: #991b1b;">Rejected</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge" style="background: #fef08a; color: #854d0e;">Pending</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
<td style="text-align:center;">
    <div style="display:flex; gap:8px; justify-content:center;">

        <a href="${pageContext.request.contextPath}/event/detail?id=${e.eventId}"
           class="btn-action info"
           style="text-decoration:none; padding:6px 12px; background:#f1f5f9; color:#475569; border-radius:6px;">
            View
        </a>

        <c:if test="${e.status == 'Approved'}">
            <a href="${pageContext.request.contextPath}/volunteer/workspace?eventId=${e.eventId}"
               style="text-decoration:none; padding:6px 12px; background:#8b5cf6; color:white; border-radius:6px; font-weight:600;">
                🚀 Workspace
            </a>
        </c:if>

    </div>
</td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty myEvents}">
                            <tr>
                                <td colspan="6" style="text-align: center; padding: 40px; color: #64748b;">
                                    You haven't applied to any events yet.
                                    <br>
                                    <a href="${pageContext.request.contextPath}/home" style="color: #667eea; font-weight: 500; display: inline-block; margin-top: 10px;">Browse events</a>
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>

        </div>
    </div>

    <jsp:include page="/components/footer.jsp"/>
</body>
</html>