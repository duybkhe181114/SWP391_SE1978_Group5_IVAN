<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Volunteer Dashboard - IVAN</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <style>
        .stat-card { background: white; padding: 25px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.03); border: 1px solid #e2e8f0; display: flex; flex-direction: column; justify-content: center; transition: 0.2s; }
        .stat-card:hover { transform: translateY(-3px); box-shadow: 0 8px 25px rgba(0,0,0,0.06); }
        .stat-card h3 { margin: 0 0 10px 0; color: #64748b; font-size: 13px; text-transform: uppercase; letter-spacing: 0.5px; font-weight: 700; display: flex; align-items: center; gap: 8px; }
        .stat-card .number { font-size: 36px; font-weight: 800; color: #0f172a; }
        .stat-card.primary { border-bottom: 4px solid #3b82f6; }
        .stat-card.warning { border-bottom: 4px solid #f59e0b; }
        .stat-card.success { border-bottom: 4px solid #10b981; }
        .stat-card.purple { border-bottom: 4px solid #8b5cf6; } /* Tím cho Impact Hours */

        .rec-card { display: flex; gap: 15px; padding: 15px; border: 1px solid #e2e8f0; border-radius: 12px; margin-bottom: 15px; transition: 0.2s; text-decoration: none; color: inherit; background: white; }
        .rec-card:hover { border-color: #cbd5e1; box-shadow: 0 4px 12px rgba(0,0,0,0.05); }
        .rec-img { width: 80px; height: 80px; border-radius: 8px; object-fit: cover; background: #f1f5f9; }
        .rec-info h4 { margin: 0 0 5px 0; font-size: 15px; color: #1e293b; font-weight: 700; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
        .rec-info p { margin: 0; font-size: 12px; color: #64748b; margin-bottom: 4px; }
    </style>
</head>
<body style="background: #f8fafc; font-family: 'Inter', sans-serif;">
    <jsp:include page="/components/header.jsp"/>

    <div class="admin-page" style="padding-bottom: 60px;">
        <div class="container" style="max-width: 1200px; padding-top: 40px;">

            <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 30px;">
                <div>
                    <h2 style="margin: 0 0 5px 0; font-size: 28px; font-weight: 800; color: #0f172a;">Dashboard</h2>
                    <p style="color: #64748b; margin: 0; font-size: 15px;">
                        Welcome back, <strong style="color: #3b82f6;">${not empty sessionScope.userName ? sessionScope.userName : 'Volunteer'}</strong>! Here is your activity overview.
                    </p>
                </div>
                <div style="display: flex; gap: 15px;">
                    <a href="${pageContext.request.contextPath}/profile" style="padding: 10px 20px; border-radius: 8px; border: 1px solid #cbd5e1; color: #475569; text-decoration: none; font-weight: 600; background: white;">Update Profile</a>
                </div>
            </div>

            <div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-bottom: 40px;">
                <div class="stat-card primary">
                    <h3>📋 Total Applied</h3>
                    <div class="number">${registeredEvents}</div>
                </div>
                <div class="stat-card warning">
                    <h3>⏳ Upcoming Events</h3>
                    <div class="number">${upcomingEvents}</div>
                </div>
                <div class="stat-card success">
                    <h3>✅ Completed Events</h3>
                    <div class="number">${completedEvents}</div>
                </div>
                <div class="stat-card purple" style="background: linear-gradient(135deg, #f3e8ff 0%, white 100%);">
                    <h3 style="color: #6d28d9;">🔥 Impact Hours</h3>
                    <div class="number" style="color: #6d28d9;">${impactHours} <span style="font-size: 14px; color: #8b5cf6;">hrs</span></div>
                </div>
            </div>

            <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 30px; align-items: start;">

                <div style="background: white; border-radius: 16px; box-shadow: 0 4px 20px rgba(0,0,0,0.03); overflow: hidden;">
                    <div style="padding: 20px 25px; border-bottom: 1px solid #f1f5f9; display: flex; justify-content: space-between; align-items: center;">
                        <h2 id="workspaces" style="margin: 0; font-size: 18px; color: #0f172a; font-weight: 700; scroll-margin-top: 80px;">
                            My Applications & Workspaces
                        </h2>
                    </div>

                    <div style="overflow-x: auto;">
                        <table class="table admin-table" style="margin: 0; width: 100%;">
                            <thead style="background: #f8fafc;">
                                <tr>
                                    <th style="padding: 15px 25px; font-size: 12px;">Event Name</th>
                                    <th style="font-size: 12px;">Date</th>
                                    <th style="font-size: 12px;">Status</th>
                                    <th style="width: 140px; text-align: center; font-size: 12px;">Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${myEvents}" var="e">
                                    <tr style="border-bottom: 1px solid #f1f5f9;">
                                        <td style="padding: 15px 25px;">
                                            <div style="font-weight: 600; color: #1e293b; font-size: 15px;">${e.eventName}</div>
                                            <div style="font-size: 12px; color: #64748b; margin-top: 4px;">📍 ${e.location}</div>
                                        </td>
                                        <td style="color: #475569; font-size: 14px; font-weight: 500;">
                                            <fmt:formatDate value="${e.startDateAsDate}" pattern="dd MMM, yyyy"/>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${e.status == 'Approved'}">
                                                    <span style="background: #dcfce7; color: #166534; padding: 4px 10px; border-radius: 6px; font-size: 12px; font-weight: 700;">Approved</span>
                                                </c:when>
                                                <c:when test="${e.status == 'Rejected'}">
                                                    <span style="background: #fee2e2; color: #991b1b; padding: 4px 10px; border-radius: 6px; font-size: 12px; font-weight: 700;">Rejected</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span style="background: #fef9c3; color: #854d0e; padding: 4px 10px; border-radius: 6px; font-size: 12px; font-weight: 700;">Pending</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td style="text-align: center;">
                                            <div style="display: flex; gap: 8px; justify-content: center;">
                                                <a href="${pageContext.request.contextPath}/event/detail?id=${e.eventId}" style="padding: 6px 12px; background: #f1f5f9; color: #475569; border-radius: 6px; text-decoration: none; font-size: 13px; font-weight: 600;">View</a>
                                                <c:if test="${e.status == 'Approved'}">
                                                    <a href="${pageContext.request.contextPath}/volunteer/workspace?eventId=${e.eventId}" style="padding: 6px 12px; background: #8b5cf6; color: white; border-radius: 6px; text-decoration: none; font-size: 13px; font-weight: 600;">🚀</a>
                                                </c:if>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>

                                <c:if test="${empty myEvents}">
                                    <tr>
                                        <td colspan="4" style="text-align: center; padding: 50px 20px; color: #64748b;">
                                            <div style="font-size: 40px; margin-bottom: 15px;">📂</div>
                                            <div style="font-size: 16px; font-weight: 600; color: #0f172a; margin-bottom: 5px;">No applications yet</div>
                                            You haven't applied to any events yet.
                                        </td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div style="background: white; border-radius: 16px; padding: 25px; box-shadow: 0 4px 20px rgba(0,0,0,0.03);">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                        <h3 style="margin: 0; font-size: 16px; color: #0f172a; font-weight: 800;">✨ Recommended for You</h3>
                        <a href="${pageContext.request.contextPath}/events" style="font-size: 13px; color: #667eea; text-decoration: none; font-weight: 600;">See All</a>
                    </div>

                    <div style="display: flex; flex-direction: column;">
                        <c:forEach items="${recommendedEvents}" var="re">
                            <a href="${pageContext.request.contextPath}/event/detail?id=${re.eventId}" class="rec-card">
<img src="${empty re.eventImageUrl ? 'https://images.unsplash.com/photo-1552664730-d307ca884978?auto=format&fit=crop&w=150&q=80' : pageContext.request.contextPath += re.eventImageUrl}" alt="Event" class="rec-img">                                <div class="rec-info">
                                    <h4>${re.eventName}</h4>
                                    <p>📅 <fmt:formatDate value="${re.startDateAsDate}" pattern="dd MMM, yyyy"/></p>
                                    <p style="white-space: nowrap; overflow: hidden; text-overflow: ellipsis; max-width: 180px;">📍 ${re.location}</p>
                                </div>
                            </a>
                        </c:forEach>

                        <c:if test="${empty recommendedEvents}">
                            <div style="text-align: center; padding: 30px 10px; color: #94a3b8; font-size: 14px; background: #f8fafc; border-radius: 12px;">
                                No new recommendations at the moment.
                            </div>
                        </c:if>
                    </div>
                </div>

            </div>
        </div>
    </div>

    <jsp:include page="/components/footer.jsp"/>
</body>
</html>