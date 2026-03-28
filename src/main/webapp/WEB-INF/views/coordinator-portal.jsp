<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="/components/header.jsp"/>

<style>
    :root {
        --primary: #4f46e5;
        --primary-hover: #4338ca;
        --bg-page: #f8fafc;
        --bg-card: #ffffff;
        --text-main: #0f172a;
        --text-muted: #64748b;
        --border: #e2e8f0;
    }

    /* BỐ CỤC TỔNG THỂ */
    .coordinator-portal {
        font-family: 'Inter', system-ui, -apple-system, sans-serif;
        background: var(--bg-page);
        min-height: 100vh;
        padding: 40px 20px 80px;
    }
    .portal-container {
        max-width: 1200px;
        margin: 0 auto;
    }

    /* HEADER PAGE */
    .page-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 40px;
        flex-wrap: wrap;
        gap: 20px;
    }
    .page-title {
        font-size: 32px;
        font-weight: 800;
        color: var(--text-main);
        margin: 0 0 8px 0;
        display: flex;
        align-items: center;
        gap: 12px;
    }
    .page-subtitle {
        color: var(--text-muted);
        font-size: 16px;
        margin: 0;
    }
    .btn-outline {
        background: var(--bg-card);
        border: 1px solid #cbd5e1;
        color: var(--text-main);
        padding: 10px 20px;
        border-radius: 10px;
        font-weight: 600;
        text-decoration: none;
        transition: all 0.2s ease;
        display: inline-flex;
        align-items: center;
        gap: 8px;
        box-shadow: 0 1px 2px rgba(0,0,0,0.05);
    }
    .btn-outline:hover {
        border-color: var(--text-muted);
        background: #f1f5f9;
    }

    /* THẺ THỐNG KÊ (STATS) */
    .stats-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
        gap: 24px;
        margin-bottom: 50px;
    }
    .portal-stat-card {
        background: var(--bg-card);
        border-radius: 16px;
        padding: 24px;
        display: flex;
        align-items: center;
        gap: 20px;
        box-shadow: 0 4px 6px -1px rgba(0,0,0,0.02), 0 2px 4px -1px rgba(0,0,0,0.02);
        border: 1px solid var(--border);
        transition: transform 0.2s, box-shadow 0.2s;
    }
    .portal-stat-card:hover {
        transform: translateY(-4px);
        box-shadow: 0 10px 25px -5px rgba(0,0,0,0.05), 0 8px 10px -6px rgba(0,0,0,0.01);
    }
    .stat-icon-wrapper {
        width: 64px;
        height: 64px;
        border-radius: 16px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 28px;
    }
    .stat-info h4 {
        margin: 0 0 4px 0;
        font-size: 13px;
        color: var(--text-muted);
        text-transform: uppercase;
        letter-spacing: 0.5px;
        font-weight: 700;
    }
    .stat-info .stat-number {
        font-size: 32px;
        font-weight: 800;
        color: var(--text-main);
        line-height: 1;
    }

    /* TIÊU ĐỀ PHÂN MỤC */
    .section-divider {
        border-top: 2px dashed var(--border);
        margin: 50px 0 30px;
        position: relative;
    }
    .section-title {
        position: absolute;
        top: -14px;
        left: 0;
        background: var(--bg-page);
        padding-right: 20px;
        font-size: 18px;
        font-weight: 700;
        color: var(--text-main);
        display: flex;
        align-items: center;
        gap: 8px;
    }

    /* DANH SÁCH TASK CẦN DUYỆT */
    .task-list {
        display: flex;
        flex-direction: column;
        gap: 16px;
    }
    .task-card {
        background: var(--bg-card);
        border-left: 4px solid #f59e0b;
        border-radius: 12px;
        padding: 20px 24px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        gap: 20px;
        box-shadow: 0 1px 3px rgba(0,0,0,0.05);
        border-top: 1px solid var(--border);
        border-right: 1px solid var(--border);
        border-bottom: 1px solid var(--border);
        transition: transform 0.2s;
        flex-wrap: wrap;
    }
    .task-card:hover {
        transform: translateX(4px);
    }
    .task-meta {
        font-size: 12px;
        color: var(--text-muted);
        font-weight: 700;
        margin-bottom: 6px;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }
    .task-title {
        margin: 0 0 6px 0;
        font-size: 16px;
        color: var(--text-main);
        font-weight: 600;
    }
    .task-subtitle {
        font-size: 14px;
        color: var(--text-muted);
    }
    .task-subtitle strong {
        color: var(--text-main);
    }
    .btn-warning {
        background: #fffbeb;
        border: 1px solid #fcd34d;
        color: #b45309;
        padding: 10px 20px;
        border-radius: 8px;
        font-weight: 600;
        text-decoration: none;
        transition: all 0.2s ease;
        white-space: nowrap;
        font-size: 14px;
    }
    .btn-warning:hover {
        background: #fef3c7;
        border-color: #f59e0b;
    }
    .empty-state {
        background: var(--bg-card);
        border-radius: 16px;
        padding: 50px 20px;
        text-align: center;
        border: 1px dashed #cbd5e1;
        color: var(--text-muted);
    }

    /* DANH SÁCH EVENT WORKSPACES */
    .events-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
        gap: 24px;
    }
    .event-card {
        background: var(--bg-card);
        border-radius: 16px;
        overflow: hidden;
        box-shadow: 0 4px 6px -1px rgba(0,0,0,0.02), 0 2px 4px -1px rgba(0,0,0,0.02);
        border: 1px solid var(--border);
        transition: all 0.3s ease;
        display: flex;
        flex-direction: column;
    }
    .event-card:hover {
        transform: translateY(-6px);
        box-shadow: 0 20px 25px -5px rgba(0,0,0,0.05), 0 10px 10px -5px rgba(0,0,0,0.02);
    }
    .event-img-wrap {
        position: relative;
        height: 180px;
        background: #e2e8f0;
    }
    .event-img-wrap img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }
    .status-badge {
        position: absolute;
        top: 16px;
        right: 16px;
        background: rgba(15, 23, 42, 0.75);
        backdrop-filter: blur(4px);
        color: white;
        padding: 6px 14px;
        border-radius: 20px;
        font-size: 12px;
        font-weight: 600;
        display: flex;
        align-items: center;
        gap: 6px;
    }
    .status-dot {
        width: 8px;
        height: 8px;
        background: #4ade80;
        border-radius: 50%;
        display: inline-block;
        box-shadow: 0 0 8px rgba(74, 222, 128, 0.6);
    }
    .event-content {
        padding: 24px;
        flex-grow: 1;
        display: flex;
        flex-direction: column;
    }
    .event-title {
        margin: 0 0 8px 0;
        font-size: 18px;
        color: var(--text-main);
        font-weight: 700;
        line-height: 1.4;
    }
    .event-location {
        margin: 0 0 24px 0;
        font-size: 14px;
        color: var(--text-muted);
        display: flex;
        align-items: center;
        gap: 6px;
    }
    .btn-primary {
        display: block;
        text-align: center;
        background: var(--primary);
        color: white;
        padding: 12px;
        border-radius: 10px;
        font-weight: 600;
        text-decoration: none;
        font-size: 15px;
        transition: all 0.2s ease;
        margin-top: auto;
    }
    .btn-primary:hover {
        background: var(--primary-hover);
        box-shadow: 0 4px 12px rgba(79, 70, 229, 0.25);
    }
</style>

<div class="coordinator-portal">
    <div class="portal-container">

        <div class="page-header">
            <div>
                <h1 class="page-title">
                    👑 Coordinator Portal
                </h1>
                <p class="page-subtitle">Command Center: Manage your teams, track progress, and assign tasks.</p>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/events" class="btn-outline">
                    🔍 Find More Events
                </a>
            </div>
        </div>

        <div class="stats-grid">
            <div class="portal-stat-card">
                <div class="stat-icon-wrapper" style="background: #e0e7ff; color: #4f46e5;">
                    🏆
                </div>
                <div class="stat-info">
                    <h4>Active Events</h4>
                    <div class="stat-number">${stats.totalEvents}</div>
                </div>
            </div>

            <div class="portal-stat-card">
                <div class="stat-icon-wrapper" style="background: #dcfce7; color: #166534;">
                    👥
                </div>
                <div class="stat-info">
                    <h4>Volunteers Led</h4>
                    <div class="stat-number">${stats.totalVolunteers}</div>
                </div>
            </div>

            <div class="portal-stat-card">
                <div class="stat-icon-wrapper" style="background: #fef3c7; color: #b45309;">
                    📋
                </div>
                <div class="stat-info">
                    <h4>Tasks Assigned</h4>
                    <div class="stat-number">${stats.totalTasks}</div>
                </div>
            </div>
        </div>

        <div class="section-divider">
            <span class="section-title">⏳ Tasks Awaiting Confirmation</span>
        </div>

        <c:choose>
            <c:when test="${empty pendingReviewTasks}">
                <div class="empty-state">
                    🎉 All caught up! No tasks need your review at the moment.
                </div>
            </c:when>
            <c:otherwise>
                <div class="task-list">
                    <c:forEach items="${pendingReviewTasks}" var="t">
                        <div class="task-card">
                            <div>
                                <div class="task-meta">${t.eventName}</div>
                                <h4 class="task-title">${t.description}</h4>
                                <div class="task-subtitle">
                                    Completed by <strong>${t.volunteerName}</strong> • ${t.workDate}
                                </div>
                            </div>
                            <div>
                                <a href="${pageContext.request.contextPath}/event/detail?id=${t.eventId}&tab=tasks" class="btn-warning">
                                    Review Task &rarr;
                                </a>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>

        <div class="section-divider" style="margin-top: 60px;">
            <span class="section-title">📍 Your Event Workspaces</span>
        </div>

        <c:if test="${empty managedEvents}">
            <div class="empty-state" style="padding: 80px 20px;">
                <div style="font-size: 60px; margin-bottom: 15px;">🤷‍♂️</div>
                <h3 style="color: #0f172a; font-size: 20px; margin: 0 0 10px 0;">No events in your portfolio yet</h3>
                <p style="margin: 0;">Participate in events and show your leadership skills to be promoted!</p>
            </div>
        </c:if>

        <c:if test="${not empty managedEvents}">
            <div class="events-grid">
                <c:forEach items="${managedEvents}" var="e">
                    <div class="event-card">

                        <div class="event-img-wrap">
                            <img src="${empty e.eventImageUrl ? 'https://images.unsplash.com/photo-1552664730-d307ca884978?auto=format&fit=crop&q=80' : pageContext.request.contextPath += e.eventImageUrl}" alt="Event Cover">
                            <div class="status-badge">
                                <span class="status-dot"></span> Active
                            </div>
                        </div>

                        <div class="event-content">
                            <h3 class="event-title">${e.eventName}</h3>
                            <p class="event-location">📍 ${e.location}</p>

                            <a href="${pageContext.request.contextPath}/event/detail?id=${e.eventId}" class="btn-primary">
                                ⚙️ Manage Event
                            </a>
                        </div>

                    </div>
                </c:forEach>
            </div>
        </c:if>

    </div>
</div>

<jsp:include page="/components/footer.jsp"/>