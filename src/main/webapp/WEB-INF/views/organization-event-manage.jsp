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
                                        <button type="button" onclick="openRejectModal(${v.registrationId}, ${event.eventId})" class="btn-action danger" style="padding: 6px 16px;">Reject</button>
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

<!-- Reject Modal -->
<div id="rejectModal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 1000; align-items: center; justify-content: center;">
    <div style="background: white; padding: 30px; border-radius: 16px; width: 90%; max-width: 500px; box-shadow: 0 10px 40px rgba(0,0,0,0.2);">
        <h3 style="margin: 0 0 20px 0; color: #0f172a;">Reject Application</h3>
        <form id="rejectForm" method="post" action="${pageContext.request.contextPath}/organization/manage-registrations">
            <input type="hidden" name="registrationId" id="rejectRegistrationId">
            <input type="hidden" name="eventId" id="rejectEventId">
            <input type="hidden" name="action" value="reject">
            <div style="margin-bottom: 20px;">
                <label style="display: block; margin-bottom: 8px; font-weight: 600; color: #475569;">Reason for rejection: <span style="color: #ef4444;">*</span></label>
                <textarea name="reviewNote" required style="width: 100%; min-height: 100px; padding: 12px; border: 2px solid #e2e8f0; border-radius: 8px; font-family: inherit; resize: vertical;" placeholder="Please provide a reason for rejecting this application..."></textarea>
            </div>
            <div style="display: flex; gap: 10px; justify-content: flex-end;">
                <button type="button" onclick="closeRejectModal()" style="padding: 10px 20px; border: 2px solid #e2e8f0; background: white; border-radius: 8px; cursor: pointer; font-weight: 600; color: #64748b;">Cancel</button>
                <button type="submit" style="padding: 10px 20px; border: none; background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%); color: white; border-radius: 8px; cursor: pointer; font-weight: 600;">Reject</button>
            </div>
        </form>
    </div>
</div>

<script>
function openRejectModal(registrationId, eventId) {
    document.getElementById('rejectRegistrationId').value = registrationId;
    document.getElementById('rejectEventId').value = eventId;
    document.getElementById('rejectModal').style.display = 'flex';
}

function closeRejectModal() {
    document.getElementById('rejectModal').style.display = 'none';
    document.getElementById('rejectForm').reset();
}

window.onclick = function(event) {
    const modal = document.getElementById('rejectModal');
    if (event.target === modal) {
        closeRejectModal();
    }
}
</script>