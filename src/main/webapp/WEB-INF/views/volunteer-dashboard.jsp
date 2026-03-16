<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Volunteer Dashboard - IVAN</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <style>
        body { background: #f1f5f9; font-family: 'Inter', sans-serif; }

        .dash-hero {
            background: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%);
            border-radius: 20px;
            padding: 36px 40px;
            color: white;
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 32px;
            position: relative;
            overflow: hidden;
        }
        .dash-hero::after {
            content: '🌟';
            position: absolute;
            right: 160px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 100px;
            opacity: 0.08;
        }
        .dash-hero h1 { margin: 0 0 6px 0; font-size: 26px; font-weight: 800; }
        .dash-hero p  { margin: 0; opacity: 0.85; font-size: 15px; }
        .dash-hero .hero-actions { display: flex; gap: 12px; flex-shrink: 0; }
        .hero-btn {
            padding: 10px 22px; border-radius: 10px; font-weight: 700;
            font-size: 14px; text-decoration: none; transition: 0.2s;
        }
        .hero-btn-primary { background: white; color: #4f46e5; }
        .hero-btn-primary:hover { background: #e0e7ff; }
        .hero-btn-outline { background: rgba(255,255,255,0.15); color: white; border: 1px solid rgba(255,255,255,0.4); }
        .hero-btn-outline:hover { background: rgba(255,255,255,0.25); }

        .stat-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-bottom: 32px; }
        .stat-card {
            background: white; border-radius: 16px; padding: 24px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.04); border: 1px solid #e2e8f0;
            display: flex; align-items: center; gap: 18px; transition: 0.2s;
        }
        .stat-card:hover { transform: translateY(-3px); box-shadow: 0 8px 24px rgba(0,0,0,0.08); }
        .stat-icon {
            width: 52px; height: 52px; border-radius: 14px;
            display: flex; align-items: center; justify-content: center;
            font-size: 22px; flex-shrink: 0;
        }
        .stat-body { flex: 1; }
        .stat-label { font-size: 12px; font-weight: 700; color: #94a3b8; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 4px; }
        .stat-value { font-size: 32px; font-weight: 800; color: #0f172a; line-height: 1; }
        .stat-sub { font-size: 12px; color: #94a3b8; margin-top: 4px; }

        .main-grid { display: grid; grid-template-columns: 1fr 340px; gap: 24px; align-items: start; }

        .panel { background: white; border-radius: 16px; box-shadow: 0 2px 12px rgba(0,0,0,0.04); overflow: hidden; }
        .panel-header {
            padding: 18px 24px; border-bottom: 1px solid #f1f5f9;
            display: flex; justify-content: space-between; align-items: center;
        }
        .panel-header h3 { margin: 0; font-size: 16px; font-weight: 800; color: #0f172a; }
        .panel-header a { font-size: 13px; color: #4f46e5; text-decoration: none; font-weight: 600; }

        .event-row { display: flex; align-items: center; gap: 16px; padding: 16px 24px; border-bottom: 1px solid #f8fafc; transition: 0.15s; }
        .event-row:last-child { border-bottom: none; }
        .event-row:hover { background: #fafbff; }
        .event-thumb { width: 48px; height: 48px; border-radius: 10px; object-fit: cover; background: #e0e7ff; flex-shrink: 0; }
        .event-info { flex: 1; min-width: 0; }
        .event-info .name { font-weight: 700; color: #1e293b; font-size: 14px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .event-info .meta { font-size: 12px; color: #94a3b8; margin-top: 3px; }
        .event-actions { display: flex; gap: 8px; flex-shrink: 0; }
        .btn-sm { padding: 6px 14px; border-radius: 8px; font-size: 12px; font-weight: 700; text-decoration: none; transition: 0.15s; }
        .btn-view { background: #f1f5f9; color: #475569; }
        .btn-view:hover { background: #e2e8f0; }
        .btn-workspace { background: #4f46e5; color: white; }
        .btn-workspace:hover { background: #4338ca; }

        .status-badge { display: inline-block; padding: 3px 10px; border-radius: 20px; font-size: 11px; font-weight: 700; }
        .s-approved  { background: #dcfce7; color: #166534; }
        .s-pending   { background: #fef9c3; color: #854d0e; }
        .s-rejected  { background: #fee2e2; color: #991b1b; }
        .s-invited   { background: #ede9fe; color: #6d28d9; }
        .s-declined  { background: #e0f2fe; color: #0369a1; }

        .rec-card { display: flex; gap: 14px; padding: 14px; border-radius: 12px; text-decoration: none; color: inherit; transition: 0.15s; }
        .rec-card:hover { background: #f8fafc; }
        .rec-thumb { width: 64px; height: 64px; border-radius: 10px; object-fit: cover; background: #e0e7ff; flex-shrink: 0; }
        .rec-info .rec-name { font-size: 13px; font-weight: 700; color: #1e293b; margin-bottom: 4px; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
        .rec-info .rec-meta { font-size: 11px; color: #94a3b8; }

        .task-strip { display: grid; grid-template-columns: repeat(3,1fr); gap: 12px; margin-bottom: 32px; }
        .task-strip-card {
            background: white; border-radius: 14px; padding: 18px 20px;
            display: flex; align-items: center; gap: 14px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.04); border: 1px solid #e2e8f0;
        }
        .task-strip-icon { font-size: 24px; }
        .task-strip-label { font-size: 12px; color: #94a3b8; font-weight: 600; text-transform: uppercase; letter-spacing: 0.4px; }
        .task-strip-value { font-size: 22px; font-weight: 800; color: #0f172a; }

        .empty-state { text-align: center; padding: 48px 20px; color: #94a3b8; }
        .empty-state .icon { font-size: 44px; margin-bottom: 12px; }
        .empty-state .title { font-size: 15px; font-weight: 700; color: #475569; margin-bottom: 4px; }
    </style>
</head>
<body>
<jsp:include page="/components/header.jsp"/>

<div style="max-width:1240px; margin:0 auto; padding: 36px 24px 80px;">

    <%-- Hero Banner --%>
    <div class="dash-hero">
        <div>
            <h1>Welcome back, ${not empty sessionScope.userName ? sessionScope.userName : 'Volunteer'}! 👋</h1>
            <p>Here's what's happening with your volunteer journey today.</p>
        </div>
        <div class="hero-actions">
            <a href="${pageContext.request.contextPath}/events" class="hero-btn hero-btn-outline">🔍 Browse Events</a>
            <a href="${pageContext.request.contextPath}/profile" class="hero-btn hero-btn-primary">✏️ Edit Profile</a>
        </div>
    </div>

    <%-- Stat Cards --%>
    <div class="stat-grid">
        <div class="stat-card">
            <div class="stat-icon" style="background:#eff6ff;">📋</div>
            <div class="stat-body">
                <div class="stat-label">Applications & Invites</div>
                <div class="stat-value">${registeredEvents}</div>
                <div class="stat-sub">total registrations</div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon" style="background:#fffbeb;">⏳</div>
            <div class="stat-body">
                <div class="stat-label">Upcoming Events</div>
                <div class="stat-value">${upcomingEvents}</div>
                <div class="stat-sub">scheduled ahead</div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon" style="background:#f0fdf4;">✅</div>
            <div class="stat-body">
                <div class="stat-label">Completed Events</div>
                <div class="stat-value">${completedEvents}</div>
                <div class="stat-sub">events finished</div>
            </div>
        </div>
        <div class="stat-card" style="background: linear-gradient(135deg,#f5f3ff 0%,white 100%); border-color:#ddd6fe;">
            <div class="stat-icon" style="background:#ede9fe;">🔥</div>
            <div class="stat-body">
                <div class="stat-label" style="color:#7c3aed;">Impact Hours</div>
                <div class="stat-value" style="color:#6d28d9;">${impactHours} <span style="font-size:14px;color:#8b5cf6;">hrs</span></div>
                <div class="stat-sub">confirmed volunteer work</div>
            </div>
        </div>
    </div>

    <%-- Task Summary Strip --%>
    <div class="task-strip">
        <div class="task-strip-card" style="border-left:4px solid #f59e0b;">
            <div class="task-strip-icon">🕒</div>
            <div>
                <div class="task-strip-label">Pending Tasks</div>
                <div class="task-strip-value">${taskPending}</div>
            </div>
        </div>
        <div class="task-strip-card" style="border-left:4px solid #3b82f6;">
            <div class="task-strip-icon">🚀</div>
            <div>
                <div class="task-strip-label">In Progress</div>
                <div class="task-strip-value">${taskInProgress}</div>
            </div>
        </div>
        <div class="task-strip-card" style="border-left:4px solid #10b981;">
            <div class="task-strip-icon">🎉</div>
            <div>
                <div class="task-strip-label">Completed Tasks</div>
                <div class="task-strip-value">${taskDone}</div>
            </div>
        </div>
    </div>

    <%-- Main Grid --%>
    <div class="main-grid">

        <%-- Events Table --%>
        <div class="panel">
            <div class="panel-header">
                <h3>📁 My Applications & Workspaces</h3>
                <a href="${pageContext.request.contextPath}/events">Browse more →</a>
            </div>

            <c:if test="${empty myEvents}">
                <div class="empty-state">
                    <div class="icon">📂</div>
                    <div class="title">No applications yet</div>
                    <div>Start by browsing and applying to events.</div>
                </div>
            </c:if>

            <c:forEach items="${myEvents}" var="e">
                <div class="event-row">
                    <img class="event-thumb"
                         src="${empty e.eventImageUrl
                              ? 'https://images.unsplash.com/photo-1552664730-d307ca884978?auto=format&fit=crop&w=96&q=80'
                              : pageContext.request.contextPath += e.eventImageUrl}"
                         alt="event"/>
                    <div class="event-info">
                        <div class="name">${e.eventName}</div>
                        <div class="meta">
                            📅 <fmt:formatDate value="${e.startDateAsDate}" pattern="dd MMM yyyy"/>
                            &nbsp;·&nbsp; 📍 ${e.location}
                        </div>
                    </div>
                    <c:choose>
                        <c:when test="${e.status == 'Approved'}">
                            <span class="status-badge s-approved">✅ Approved</span>
                        </c:when>
                        <c:when test="${e.status == 'Rejected'}">
                            <span class="status-badge s-rejected">❌ Rejected</span>
                        </c:when>
                        <c:when test="${e.status == 'Invited'}">
                            <span class="status-badge s-invited">💌 Invited</span>
                        </c:when>
                        <c:when test="${e.status == 'Declined'}">
                            <span class="status-badge s-declined">↩ Declined</span>
                        </c:when>
                        <c:otherwise>
                            <span class="status-badge s-pending">⏳ Pending</span>
                        </c:otherwise>
                    </c:choose>
                    <div class="event-actions">
                        <a href="${pageContext.request.contextPath}/event/detail?id=${e.eventId}" class="btn-sm btn-view">View</a>
                        <c:if test="${e.status == 'Approved'}">
                            <a href="${pageContext.request.contextPath}/volunteer/workspace?eventId=${e.eventId}" class="btn-sm btn-workspace">🚀 Workspace</a>
                        </c:if>
                    </div>
                </div>
            </c:forEach>
        </div>

        <%-- Right Column --%>
        <div style="display:flex;flex-direction:column;gap:24px;">

            <%-- Quick Links --%>
            <div class="panel">
                <div class="panel-header"><h3>⚡ Quick Actions</h3></div>
                <div style="padding:16px;display:flex;flex-direction:column;gap:10px;">
                    <a href="${pageContext.request.contextPath}/events"
                       style="display:flex;align-items:center;gap:12px;padding:12px 16px;background:#f8fafc;border-radius:10px;text-decoration:none;color:#1e293b;font-weight:600;font-size:14px;transition:0.15s;"
                       onmouseover="this.style.background='#e0e7ff'" onmouseout="this.style.background='#f8fafc'">
                        <span style="font-size:20px;">🔍</span> Browse All Events
                    </a>
                    <a href="${pageContext.request.contextPath}/volunteer/my-schedule"
                       style="display:flex;align-items:center;gap:12px;padding:12px 16px;background:#f8fafc;border-radius:10px;text-decoration:none;color:#1e293b;font-weight:600;font-size:14px;transition:0.15s;"
                       onmouseover="this.style.background='#e0e7ff'" onmouseout="this.style.background='#f8fafc'">
                        <span style="font-size:20px;">📅</span> My Schedule
                    </a>
                    <a href="${pageContext.request.contextPath}/profile"
                       style="display:flex;align-items:center;gap:12px;padding:12px 16px;background:#f8fafc;border-radius:10px;text-decoration:none;color:#1e293b;font-weight:600;font-size:14px;transition:0.15s;"
                       onmouseover="this.style.background='#e0e7ff'" onmouseout="this.style.background='#f8fafc'">
                        <span style="font-size:20px;">👤</span> Update Profile
                    </a>
                </div>
            </div>

            <%-- Recommended Events --%>
            <div class="panel">
                <div class="panel-header">
                    <h3>✨ Recommended</h3>
                    <a href="${pageContext.request.contextPath}/events">See all →</a>
                </div>
                <div style="padding:12px 8px;">
                    <c:if test="${empty recommendedEvents}">
                        <div class="empty-state" style="padding:30px 20px;">
                            <div class="icon" style="font-size:32px;">🎯</div>
                            <div>No new recommendations right now.</div>
                        </div>
                    </c:if>
                    <c:forEach items="${recommendedEvents}" var="re">
                        <a href="${pageContext.request.contextPath}/event/detail?id=${re.eventId}" class="rec-card">
                            <img class="rec-thumb"
                                 src="${empty re.eventImageUrl
                                      ? 'https://images.unsplash.com/photo-1552664730-d307ca884978?auto=format&fit=crop&w=128&q=80'
                                      : pageContext.request.contextPath += re.eventImageUrl}"
                                 alt="event"/>
                            <div class="rec-info">
                                <div class="rec-name">${re.eventName}</div>
                                <div class="rec-meta">📅 <fmt:formatDate value="${re.startDateAsDate}" pattern="dd MMM yyyy"/></div>
                                <div class="rec-meta" style="margin-top:2px;">📍 ${re.location}</div>
                            </div>
                        </a>
                    </c:forEach>
                </div>
            </div>

        </div>
    </div>
</div>

<jsp:include page="/components/footer.jsp"/>
</body>
</html>
