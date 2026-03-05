<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="/components/header.jsp"/>

<style>
    .impact-stat { text-align: center; padding: 15px; background: #f8fafc; border-radius: 12px; border: 1px solid #e2e8f0; }
    .impact-stat .num { font-size: 24px; font-weight: 800; color: #667eea; margin-bottom: 5px; }
    .impact-stat .label { font-size: 12px; color: #64748b; text-transform: uppercase; font-weight: 700; }

    .event-list-card { display: flex; gap: 20px; background: white; padding: 15px; border-radius: 12px; border: 1px solid #e2e8f0; transition: 0.2s; align-items: center; }
    .event-list-card:hover { border-color: #cbd5e1; box-shadow: 0 4px 15px rgba(0,0,0,0.03); transform: translateX(5px); }
    .event-thumb { width: 100px; height: 80px; border-radius: 8px; object-fit: cover; }
</style>

<div class="admin-page" style="background: #f8fafc; min-height: 100vh; padding-bottom: 60px;">

    <div style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); height: 220px; width: 100%;"></div>

    <div class="container" style="margin-top: -80px;">
        <div style="display: grid; grid-template-columns: 1fr 2.5fr; gap: 30px;">

            <div>
                <div style="background: white; padding: 30px; border-radius: 16px; box-shadow: 0 4px 20px rgba(0,0,0,0.05);">
                    <div style="width: 120px; height: 120px; border-radius: 50%; box-shadow: 0 4px 15px rgba(0,0,0,0.1); margin: 0 auto 20px auto; border: 4px solid white; overflow: hidden; background: white;">
                        <img src="${pageContext.request.contextPath}${empty org.LogoUrl ? '/assets/images/events/default.png' : org.LogoUrl}"
                             style="width: 100%; height: 100%; object-fit: cover;" alt="Logo">
                    </div>

                    <div style="text-align: center; margin-bottom: 25px;">
                        <h2 style="font-size: 22px; color: #0f172a; margin-bottom: 5px; font-weight: 800;">${org.Name}</h2>
                        <span style="background: #dcfce7; color: #166534; padding: 4px 10px; border-radius: 20px; font-size: 11px; font-weight: 700;">
                            ✓ Verified NGO
                        </span>
                        <div style="color: #64748b; font-size: 13px; margin-top: 10px;">Joined <fmt:formatDate value="${org.CreatedAt}" pattern="MMMM yyyy"/></div>
                    </div>

                    <h4 style="font-size: 12px; text-transform: uppercase; color: #94a3b8; letter-spacing: 1px; margin-bottom: 15px; border-top: 1px solid #f1f5f9; padding-top: 20px;">Contact Info</h4>
                    <div style="display: flex; flex-direction: column; gap: 15px; font-size: 14px; color: #334155;">
                        <div style="display: flex; gap: 10px;"><span>📍</span> <span>${empty org.Address ? 'Not updated' : org.Address}</span></div>
                        <div style="display: flex; gap: 10px;"><span>📧</span> <span>${empty org.Email ? 'Not updated' : org.Email}</span></div>
                        <div style="display: flex; gap: 10px;"><span>📞</span> <span>${empty org.Phone ? 'Not updated' : org.Phone}</span></div>
                        <c:if test="${not empty org.Website}">
                            <div style="display: flex; gap: 10px;"><span>🌐</span> <a href="${org.Website}" target="_blank" style="color: #667eea; text-decoration: none; font-weight: 600;">Visit Website</a></div>
                        </c:if>
                    </div>
                </div>
            </div>

            <div>
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 30px;">
                    <div class="impact-stat">
                        <div class="num">${orgStats.totalEvents}</div>
                        <div class="label">Total Campaigns</div>
                    </div>
                    <div class="impact-stat" style="background: #f0fdf4; border-color: #bbf7d0;">
                        <div class="num" style="color: #166534;">${orgStats.totalVolunteers}+</div>
                        <div class="label">Volunteers Engaged</div>
                    </div>
                </div>

                <div style="background: white; padding: 35px; border-radius: 16px; box-shadow: 0 4px 20px rgba(0,0,0,0.05); margin-bottom: 30px;">
                    <h3 style="font-size: 20px; color: #0f172a; margin-bottom: 15px;">About Us</h3>
                    <p style="color: #475569; line-height: 1.7; font-size: 15px;">
                        ${empty org.Description ? 'This organization is actively contributing to community events. More details will be updated soon.' : org.Description}
                    </p>
                </div>

                <h3 style="font-size: 20px; color: #0f172a; margin-bottom: 20px;">Campaigns (${orgEvents.size()})</h3>

                <div style="display: flex; flex-direction: column; gap: 15px;">
                    <c:forEach items="${orgEvents}" var="e">
                        <div class="event-list-card">
                            <img src="${pageContext.request.contextPath}${empty e.eventImageUrl ? '/assets/images/events/default.png' : e.eventImageUrl}" class="event-thumb">

                            <div style="flex-grow: 1;">
                                <h4 style="margin: 0 0 8px 0; color: #1e293b; font-size: 17px; font-weight: 700;">${e.eventName}</h4>
                                <div style="color: #64748b; font-size: 13px; margin-bottom: 5px;">📍 ${e.location}</div>
                                <div style="color: #667eea; font-size: 13px; font-weight: 600;">📅 <fmt:formatDate value="${e.startDateAsDate}" pattern="dd MMM, yyyy"/></div>
                            </div>

                            <div>
                                <a href="${pageContext.request.contextPath}/event/detail?id=${e.eventId}" class="btn-primary" style="padding: 10px 24px; text-decoration: none; font-size: 14px; border-radius: 8px;">Explore</a>
                            </div>
                        </div>
                    </c:forEach>

                    <c:if test="${empty orgEvents}">
                        <div style="padding: 40px; text-align: center; color: #94a3b8; background: white; border-radius: 12px; border: 2px dashed #e2e8f0; font-weight: 600;">
                            No active campaigns at the moment.
                        </div>
                    </c:if>
                </div>
            </div>

        </div>
    </div>
</div>

<jsp:include page="/components/footer.jsp"/>