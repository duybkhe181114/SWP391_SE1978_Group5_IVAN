<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="/components/header.jsp"/>

<style>
    /* UI CHUYÊN NGHIỆP CHO PORTAL */
    .portal-stat-card {
        background: white;
        border-radius: 16px;
        padding: 25px;
        display: flex;
        align-items: center;
        gap: 20px;
        box-shadow: 0 4px 20px rgba(0,0,0,0.04);
        border: 1px solid #f1f5f9;
        transition: transform 0.2s, box-shadow 0.2s;
    }
    .portal-stat-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 10px 25px rgba(0,0,0,0.08);
    }
    .stat-icon-wrapper {
        width: 60px;
        height: 60px;
        border-radius: 14px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 28px;
    }
    .stat-info h4 {
        margin: 0 0 5px 0;
        font-size: 14px;
        color: #64748b;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        font-weight: 700;
    }
    .stat-info .stat-number {
        font-size: 32px;
        font-weight: 800;
        color: #0f172a;
        line-height: 1;
    }
</style>

<div class="admin-page" style="background: #f8fafc; min-height: 100vh; padding-bottom: 60px;">
    <div class="container" style="max-width: 1200px; padding-top: 40px;">

        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 40px;">
            <div>
                <h1 style="margin: 0 0 8px 0; font-size: 34px; color: #0f172a; font-weight: 800; display: flex; align-items: center; gap: 10px;">
                    👑 Coordinator Portal
                </h1>
                <p style="color: #64748b; font-size: 16px; margin: 0;">Command Center: Manage your teams, track progress, and assign tasks.</p>
            </div>
            <div>
                <a href="${pageContext.request.contextPath}/events" style="background: white; border: 2px solid #e2e8f0; color: #475569; padding: 10px 20px; border-radius: 10px; font-weight: 600; text-decoration: none; transition: 0.2s;">🔍 Find More Events</a>
            </div>
        </div>

        <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 24px; margin-bottom: 40px;">

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

        <div style="border-top: 2px dashed #e2e8f0; margin-bottom: 30px; position: relative;">
            <span style="position: absolute; top: -14px; left: 0; background: #f8fafc; padding-right: 15px; font-size: 18px; font-weight: 800; color: #0f172a;">
                📍 Your Event Workspaces
            </span>
        </div>

        <c:if test="${empty managedEvents}">
            <div style="background: white; border-radius: 16px; padding: 60px 20px; text-align: center; border: 2px dashed #cbd5e1; box-shadow: 0 4px 15px rgba(0,0,0,0.02);">
                <div style="font-size: 60px; margin-bottom: 15px;">🤷‍♂️</div>
                <h3 style="color: #0f172a; font-size: 20px;">No events in your portfolio yet</h3>
                <p style="color: #64748b; margin-bottom: 20px;">Participate in events and show your leadership skills to be promoted!</p>
            </div>
        </c:if>

        <c:if test="${not empty managedEvents}">
            <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 24px;">
                <c:forEach items="${managedEvents}" var="e">
                    <div style="background: white; border-radius: 16px; overflow: hidden; box-shadow: 0 4px 15px rgba(0,0,0,0.05); border: 1px solid #e2e8f0; transition: 0.2s; display: flex; flex-direction: column;">

                        <div style="position: relative;">
                            <img src="${empty e.eventImageUrl ? 'https://images.unsplash.com/photo-1552664730-d307ca884978?auto=format&fit=crop&q=80' : pageContext.request.contextPath += e.eventImageUrl}" style="width: 100%; height: 180px; object-fit: cover;">
                            <div style="position: absolute; top: 15px; right: 15px; background: rgba(0,0,0,0.6); backdrop-filter: blur(4px); color: white; padding: 6px 12px; border-radius: 20px; font-size: 12px; font-weight: 600; display: flex; align-items: center; gap: 5px;">
                                <span style="width: 8px; height: 8px; background: #4ade80; border-radius: 50%; display: inline-block;"></span> Active
                            </div>
                        </div>

                        <div style="padding: 20px; flex-grow: 1; display: flex; flex-direction: column;">
                            <h3 style="margin: 0 0 10px 0; font-size: 18px; color: #0f172a; font-weight: 800; line-height: 1.4;">${e.eventName}</h3>
                            <p style="margin: 0 0 20px 0; font-size: 13px; color: #64748b; display: flex; align-items: center; gap: 6px;">📍 ${e.location}</p>

                            <div style="margin-top: auto;">
                                <a href="${pageContext.request.contextPath}/event/detail?id=${e.eventId}" style="display: block; text-align: center; background: linear-gradient(135deg, #8b5cf6 0%, #6d28d9 100%); color: white; padding: 12px; border-radius: 10px; font-weight: 700; text-decoration: none; font-size: 15px; transition: 0.2s; box-shadow: 0 4px 10px rgba(139, 92, 246, 0.3);">
                                    ⚙️ Manage Event
                                </a>
                            </div>
                        </div>

                    </div>
                </c:forEach>
            </div>
        </c:if>
    </div>
</div>

<jsp:include page="/components/footer.jsp"/>