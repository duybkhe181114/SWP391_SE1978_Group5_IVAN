<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/components/header.jsp"/>

<style>
    .screen-page { background: #f8fafc; min-height: 100vh; padding-bottom: 56px; }
    .screen-shell { max-width: 1280px; margin: 0 auto; padding: 32px 20px 0; }
    .header-row { display: flex; justify-content: space-between; gap: 16px; flex-wrap: wrap; align-items: center; margin-bottom: 20px; }
    .header-row h1 { margin: 0; color: #0f172a; font-size: 30px; }
    .header-row p { margin: 8px 0 0; color: #64748b; line-height: 1.6; }
    .nav-row { display: flex; gap: 10px; flex-wrap: wrap; margin-bottom: 20px; }
    .nav-link { display: inline-flex; padding: 10px 16px; border-radius: 10px; border: 1px solid #cbd5e1; background: #fff; color: #475569; text-decoration: none; font-weight: 700; }
    .nav-link-active { background: #0f172a; color: #fff; border-color: #0f172a; }
    .message { padding: 14px 18px; border-radius: 12px; margin-bottom: 16px; border: 1px solid transparent; line-height: 1.6; }
    .message-error { background: #fef2f2; border-color: #fecaca; color: #991b1b; }
    .panel { background: #fff; border: 1px solid #e2e8f0; border-radius: 18px; box-shadow: 0 10px 30px rgba(15, 23, 42, 0.05); overflow: hidden; }
    .panel-header { padding: 22px 24px; border-bottom: 1px solid #e2e8f0; display: flex; justify-content: space-between; align-items: center; gap: 16px; flex-wrap: wrap; }
    .panel-title { margin: 0; color: #0f172a; font-size: 20px; }
    .panel-note { margin: 8px 0 0; color: #64748b; line-height: 1.6; }
    .toolbar { display: flex; gap: 10px; flex-wrap: wrap; align-items: center; }
    .toolbar input, .toolbar select { padding: 11px 14px; border-radius: 10px; border: 1px solid #cbd5e1; font: inherit; }
    .btn { display: inline-flex; align-items: center; justify-content: center; padding: 10px 16px; border-radius: 10px; border: 1px solid transparent; font-weight: 700; cursor: pointer; text-decoration: none; background: #fff; }
    .btn-primary { background: #0f172a; color: #fff; }
    .btn-purple { background: #8b5cf6; color: #fff; }
    .btn-success { background: #16a34a; color: #fff; }
    .btn-danger { background: #dc2626; color: #fff; }
    .btn-muted { background: #f8fafc; color: #475569; border-color: #cbd5e1; }
    .table-wrap { overflow-x: auto; }
    .table { width: 100%; border-collapse: collapse; }
    .table thead { background: #f8fafc; }
    .table th, .table td { padding: 16px 18px; text-align: left; border-bottom: 1px solid #e2e8f0; vertical-align: top; }
    .table th { color: #64748b; font-size: 12px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.08em; }
    .name { font-weight: 700; color: #0f172a; }
    .sub { margin-top: 6px; color: #94a3b8; font-size: 12px; }
    .link-btn { background: none; border: none; padding: 0; margin-top: 6px; color: #7c3aed; font-weight: 700; cursor: pointer; font-size: 12px; }
    .badge { display: inline-flex; align-items: center; padding: 6px 12px; border-radius: 999px; font-size: 12px; font-weight: 700; border: 1px solid transparent; }
    .badge-volunteer { background: #dcfce7; border-color: #bbf7d0; color: #166534; }
    .badge-coordinator { background: #e0e7ff; border-color: #c7d2fe; color: #4338ca; }
    .actions { display: flex; gap: 8px; flex-wrap: wrap; justify-content: center; }
    .empty { padding: 30px 24px; text-align: center; color: #94a3b8; }
    .modal-overlay { display: none; position: fixed; inset: 0; background: rgba(15, 23, 42, 0.58); z-index: 1000; align-items: center; justify-content: center; padding: 20px; }
    .modal-card { background: #fff; border-radius: 18px; width: 100%; max-width: 620px; max-height: 90vh; overflow-y: auto; box-shadow: 0 18px 40px rgba(15, 23, 42, 0.22); }
    .modal-small { max-width: 520px; }
    .modal-header { padding: 22px 24px 16px; border-bottom: 1px solid #e2e8f0; display: flex; justify-content: space-between; align-items: center; gap: 16px; }
    .modal-header h3 { margin: 0; color: #0f172a; font-size: 20px; }
    .modal-close { border: none; background: none; color: #94a3b8; font-size: 28px; cursor: pointer; }
    .modal-body { padding: 24px; }
    .modal-actions { display: flex; justify-content: flex-end; gap: 10px; margin-top: 18px; flex-wrap: wrap; }
    @media (max-width: 760px) { .screen-shell { padding: 24px 14px 0; } }
</style>

<div class="screen-page">
    <div class="screen-shell">
        <div class="header-row">
            <div>
                <h1>Event Members</h1>
                <p>Manage approved volunteers and coordinators for this event from a dedicated member management screen.</p>
            </div>
            <a class="nav-link" href="${pageContext.request.contextPath}/event/detail?id=${event.eventId}">Back to Event</a>
        </div>

        <div class="nav-row">
            <a class="nav-link" href="${pageContext.request.contextPath}/event/detail?id=${event.eventId}">Overview</a>
            <a class="nav-link" href="${pageContext.request.contextPath}/organization/volunteer-pool?eventId=${event.eventId}">Volunteer Pool</a>
            <a class="nav-link nav-link-active" href="${pageContext.request.contextPath}/organization/active-team?eventId=${event.eventId}">Event Members</a>
            <a class="nav-link" href="${pageContext.request.contextPath}/organization/registration-log?eventId=${event.eventId}">Registration Log</a>
        </div>

        <c:if test="${param.error == 'User not found'}">
            <div class="message message-error">No volunteer account matched that email address.</div>
        </c:if>
        <section class="panel">
            <div class="panel-header">
                <div>
                    <h2 class="panel-title">${event.eventName}</h2>
                    <p class="panel-note">Search approved members, filter by role, view profiles, and manage coordinator assignments.</p>
                </div>

                <div class="toolbar">
                    <form method="get" action="${pageContext.request.contextPath}/organization/active-team" class="toolbar">
                        <input type="hidden" name="eventId" value="${event.eventId}">
                        <input type="text" name="q" value="${teamQuery}" placeholder="Search members">
                        <select name="role">
                            <option value="">All Roles</option>
                            <option value="volunteer" ${roleFilter == 'volunteer' ? 'selected' : ''}>Volunteer</option>
                            <option value="coordinator" ${roleFilter == 'coordinator' ? 'selected' : ''}>Coordinator</option>
                        </select>
                        <button type="submit" class="btn btn-primary">Apply</button>
                    </form>

                    <button type="button" class="btn btn-purple" onclick="document.getElementById('addCoordModal').style.display='flex'">Add Coordinator</button>
                </div>
            </div>

            <div class="table-wrap">
                <table class="table">
                    <thead>
                    <tr>
                        <th>Member</th>
                        <th>Contact</th>
                        <th>Role</th>
                        <th style="text-align: center;">Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${empty activeTeam}">
                            <tr>
                                <td colspan="4" class="empty">No active team members matched the current filters.</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach items="${activeTeam}" var="v">
                                <tr>
                                    <td>
                                        <div class="name">${v.fullName}</div>
                                        <button type="button" class="link-btn" onclick="openProfileModal(${v.volunteerId})">View Profile</button>
                                    </td>
                                    <td>
                                        <div>${v.email}</div>
                                        <div class="sub">${empty v.phone ? 'No phone' : v.phone}</div>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${v.isCoordinator == 1}">
                                                <span class="badge badge-coordinator">Coordinator</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-volunteer">Volunteer</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="text-align: center;">
                                        <div class="actions">
                                            <c:if test="${v.isCoordinator == 0}">
                                                <form method="post" action="${pageContext.request.contextPath}/organization/manage-registrations">
                                                    <input type="hidden" name="returnTo" value="active-team">
                                                    <input type="hidden" name="volunteerId" value="${v.volunteerId}">
                                                    <input type="hidden" name="eventId" value="${event.eventId}">
                                                    <button type="submit" name="action" value="promote" class="btn btn-purple">Promote</button>
                                                </form>
                                            </c:if>

                                            <c:if test="${v.isCoordinator == 1}">
                                                <form method="post" action="${pageContext.request.contextPath}/organization/manage-registrations">
                                                    <input type="hidden" name="returnTo" value="active-team">
                                                    <input type="hidden" name="volunteerId" value="${v.volunteerId}">
                                                    <input type="hidden" name="eventId" value="${event.eventId}">
                                                    <button type="submit" name="action" value="revoke" class="btn btn-muted" onclick="return confirm('Demote this coordinator to volunteer?');">Revoke</button>
                                                </form>
                                            </c:if>

                                            <c:if test="${not empty v.registrationId}">
                                                <button type="button" class="btn btn-danger" onclick="openKickModal(${v.registrationId}, ${v.volunteerId}, ${event.eventId})">Remove</button>
                                            </c:if>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>
        </section>
    </div>
</div>

<div id="profileModal" class="modal-overlay">
    <div class="modal-card">
        <div class="modal-header">
            <h3>Volunteer Profile</h3>
            <button type="button" class="modal-close" onclick="closeProfileModal()">&times;</button>
        </div>
        <div id="profileModalBody" class="modal-body">
            <div class="empty">Loading volunteer profile...</div>
        </div>
    </div>
</div>

<div id="addCoordModal" class="modal-overlay">
    <div class="modal-card">
        <div class="modal-header">
            <h3>Promote Coordinator</h3>
            <button type="button" class="modal-close" onclick="document.getElementById('addCoordModal').style.display='none'">&times;</button>
        </div>
        <div class="modal-body">
            <div style="background: #f8fafc; padding: 18px; border-radius: 14px; border: 1px solid #e2e8f0;">
                <h4 style="margin: 0 0 14px; color: #0f172a;">Promote Volunteer By Email</h4>
                <div class="sub" style="margin-bottom: 12px;">Use this when you already know the volunteer account and want to promote them without searching the member list first.</div>
                <form method="post" action="${pageContext.request.contextPath}/organization/manage-registrations" style="display: grid; gap: 12px;">
                    <input type="hidden" name="returnTo" value="active-team">
                    <input type="hidden" name="eventId" value="${event.eventId}">
                    <input type="hidden" name="action" value="promote_by_email">
                    <input type="email" name="email" required placeholder="Enter volunteer email"
                           style="width: 100%; padding: 10px 14px; border-radius: 10px; border: 1px solid #cbd5e1;">
                    <button type="submit" class="btn btn-purple">Promote To Coordinator</button>
                </form>
            </div>
        </div>
    </div>
</div>

<div id="kickModal" class="modal-overlay">
    <div class="modal-card modal-small">
        <div class="modal-header">
            <h3>Remove Member</h3>
            <button type="button" class="modal-close" onclick="document.getElementById('kickModal').style.display='none'">&times;</button>
        </div>
        <div class="modal-body">
            <form method="post" action="${pageContext.request.contextPath}/organization/manage-registrations">
                <input type="hidden" name="returnTo" value="active-team">
                <input type="hidden" name="registrationId" id="kickRegistrationId">
                <input type="hidden" name="volunteerId" id="kickVolunteerId">
                <input type="hidden" name="eventId" id="kickEventId">
                <input type="hidden" name="action" value="kick">
                <textarea name="kickReason" required style="width: 100%; min-height: 110px; padding: 12px 14px; border-radius: 10px; border: 1px solid #cbd5e1;" placeholder="Explain why this member is being removed"></textarea>
                <div class="modal-actions">
                    <button type="button" class="btn btn-muted" onclick="document.getElementById('kickModal').style.display='none'">Cancel</button>
                    <button type="submit" class="btn btn-danger">Remove</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
function openProfileModal(volunteerId) {
    const modal = document.getElementById("profileModal");
    const body = document.getElementById("profileModalBody");
    modal.style.display = "flex";
    body.innerHTML = '<div class="empty">Loading volunteer profile...</div>';

    fetch('${pageContext.request.contextPath}/volunteer/profile?id=' + volunteerId)
        .then(function (response) {
            if (!response.ok) {
                throw new Error("Not found");
            }
            return response.text();
        })
        .then(function (html) {
            body.innerHTML = html;
        })
        .catch(function () {
            body.innerHTML = '<div class="empty" style="color: #dc2626;">Error loading volunteer profile.</div>';
        });
}

function closeProfileModal() {
    document.getElementById("profileModal").style.display = "none";
}

function openKickModal(registrationId, volunteerId, eventId) {
    document.getElementById("kickRegistrationId").value = registrationId;
    document.getElementById("kickVolunteerId").value = volunteerId;
    document.getElementById("kickEventId").value = eventId;
    document.getElementById("kickModal").style.display = "flex";
}

window.addEventListener("click", function (event) {
    const profileModal = document.getElementById("profileModal");
    const addCoordModal = document.getElementById("addCoordModal");
    const kickModal = document.getElementById("kickModal");

    if (event.target === profileModal) {
        closeProfileModal();
    }
    if (event.target === addCoordModal) {
        addCoordModal.style.display = "none";
    }
    if (event.target === kickModal) {
        kickModal.style.display = "none";
    }
});
</script>

<jsp:include page="/components/footer.jsp"/>
