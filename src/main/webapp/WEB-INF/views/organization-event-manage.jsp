<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/components/header.jsp"/>

<div class="admin-page">
    <div class="admin-container">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
            <h2 class="section-title" style="margin-bottom: 0; border: none;">
                <span style="color: #667eea;">●</span> Event Management
            </h2>
            <span style="background: #f1f5f9; padding: 8px 16px; border-radius: 8px; font-weight: 600; color: #475569;">
                ID: #${event.eventId}
            </span>
        </div>

        <div style="background: white; padding: 25px; border-radius: 16px; margin-bottom: 30px; box-shadow: 0 4px 20px rgba(0,0,0,0.03);">
            <h1 style="font-size: 24px; color: #0f172a; margin-bottom: 15px;">${event.eventName}</h1>
            <div class="stat-grid">
                <div class="mini-stat">
                    <label>Total Slots</label>
                    <span class="value">${event.maxVolunteers}</span>
                </div>
                <div class="mini-stat" style="border-left-color: #10b981;">
                    <label>Joined</label>
                    <span class="value">${event.currentVolunteers}</span>
                </div>
                <div class="mini-stat" style="border-left-color: #f59e0b;">
                    <label>Remaining</label>
                    <span class="value">${event.maxVolunteers - event.currentVolunteers}</span>
                </div>
            </div>
        </div>

        <div class="admin-table-wrapper">
            <h3 style="padding: 20px; border-bottom: 1px solid #f1f5f9; margin: 0;">Registration Requests</h3>
            <table class="table admin-table">
                <thead>
                    <tr>
                        <th>Volunteer</th>
                        <th>Email & Phone</th>
                        <th>Status</th>
                        <th style="text-align: center;">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${volunteers}" var="v">
                        <tr>
                            <td>
                                <div style="font-weight: 600; color: #0f172a;">${v.fullName}</div>
                                <a href="${pageContext.request.contextPath}/volunteer/profile?id=${v.volunteerId}"
                                   style="font-size: 12px; color: #667eea; text-decoration: none;">View Profile</a>
                            </td>
                            <td>
                                <div style="font-size: 14px;">${v.email}</div>
                                <div style="font-size: 12px; color: #94a3b8;">${empty v.phone ? 'No phone' : v.phone}</div>
                            </td>
                            <td>
                                <span class="status-pill ${v.status == 'Approved' ? 'status-approved' : 'status-pending'}">
                                    ${v.status}
                                </span>
                            </td>
                            <td style="text-align: center;">
                                <c:if test="${v.status == 'Pending'}">
                                    <div style="display: flex; gap: 8px; justify-content: center;">
                                        <form method="post" action="${pageContext.request.contextPath}/organization/manage-registrations">
                                            <input type="hidden" name="registrationId" value="${v.registrationId}">
                                            <input type="hidden" name="eventId" value="${event.eventId}">
                                            <button type="submit" name="action" value="approve" class="btn-action success" style="padding: 6px 16px;">Approve</button>
                                        </form>
                                        <form method="post" action="${pageContext.request.contextPath}/organization/manage-registrations">
                                            <input type="hidden" name="registrationId" value="${v.registrationId}">
                                            <input type="hidden" name="eventId" value="${event.eventId}">
                                            <button type="submit" name="action" value="reject" class="btn-action danger" style="padding: 6px 16px;">Reject</button>
                                        </form>
                                    </div>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>