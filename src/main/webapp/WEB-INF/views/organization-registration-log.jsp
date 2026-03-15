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
    .panel { background: #fff; border: 1px solid #e2e8f0; border-radius: 18px; box-shadow: 0 10px 30px rgba(15, 23, 42, 0.05); overflow: hidden; }
    .panel-header { padding: 22px 24px; border-bottom: 1px solid #e2e8f0; display: flex; justify-content: space-between; align-items: center; gap: 16px; flex-wrap: wrap; }
    .panel-title { margin: 0; color: #0f172a; font-size: 20px; }
    .panel-note { margin: 8px 0 0; color: #64748b; line-height: 1.6; }
    .toolbar { display: flex; gap: 10px; flex-wrap: wrap; align-items: center; }
    .toolbar input, .toolbar select { padding: 11px 14px; border-radius: 10px; border: 1px solid #cbd5e1; font: inherit; }
    .btn { display: inline-flex; align-items: center; justify-content: center; padding: 10px 16px; border-radius: 10px; border: 1px solid transparent; font-weight: 700; cursor: pointer; text-decoration: none; background: #fff; }
    .btn-primary { background: #0f172a; color: #fff; }
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
    .badge-pending { background: #fef9c3; border-color: #fde68a; color: #854d0e; }
    .badge-rejected { background: #fee2e2; border-color: #fecaca; color: #991b1b; }
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
                <h1>Registration Log</h1>
                <p>Review pending and rejected applications for this event in a dedicated screening view.</p>
            </div>
            <a class="nav-link" href="${pageContext.request.contextPath}/event/detail?id=${event.eventId}">Back to Event</a>
        </div>

        <div class="nav-row">
            <a class="nav-link" href="${pageContext.request.contextPath}/event/detail?id=${event.eventId}">Overview</a>
            <a class="nav-link" href="${pageContext.request.contextPath}/organization/volunteer-pool?eventId=${event.eventId}">Volunteer Pool</a>
            <a class="nav-link" href="${pageContext.request.contextPath}/organization/active-team?eventId=${event.eventId}">Event Members</a>
            <a class="nav-link nav-link-active" href="${pageContext.request.contextPath}/organization/registration-log?eventId=${event.eventId}">Registration Log</a>
        </div>

        <section class="panel">
            <div class="panel-header">
                <div>
                    <h2 class="panel-title">${event.eventName}</h2>
                    <p class="panel-note">Filter applications by status, inspect volunteer profiles, and approve or reject from one place.</p>
                </div>

                <form method="get" action="${pageContext.request.contextPath}/organization/registration-log" class="toolbar">
                    <input type="hidden" name="eventId" value="${event.eventId}">
                    <input type="text" name="q" value="${logQuery}" placeholder="Search applicants">
                    <select name="status">
                        <option value="">All Review States</option>
                        <option value="Pending" ${statusFilter == 'Pending' ? 'selected' : ''}>Pending</option>
                        <option value="Rejected" ${statusFilter == 'Rejected' ? 'selected' : ''}>Rejected</option>
                    </select>
                    <button type="submit" class="btn btn-primary">Apply</button>
                </form>
            </div>

            <div class="table-wrap">
                <table class="table">
                    <thead>
                    <tr>
                        <th>Applicant</th>
                        <th>Contact</th>
                        <th>Status</th>
                        <th style="text-align: center;">Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${empty registrationLog}">
                            <tr>
                                <td colspan="4" class="empty">No registration items matched the current filters.</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach items="${registrationLog}" var="v">
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
                                            <c:when test="${v.status == 'Pending'}">
                                                <span class="badge badge-pending">Pending</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-rejected">Rejected</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td style="text-align: center;">
                                        <c:choose>
                                            <c:when test="${v.status == 'Pending'}">
                                                <div class="actions">
                                                    <form method="post" action="${pageContext.request.contextPath}/organization/manage-registrations">
                                                        <input type="hidden" name="returnTo" value="registration-log">
                                                        <input type="hidden" name="registrationId" value="${v.registrationId}">
                                                        <input type="hidden" name="eventId" value="${event.eventId}">
                                                        <button type="submit" name="action" value="approve" class="btn btn-success">Approve</button>
                                                    </form>
                                                    <button type="button" class="btn btn-danger" onclick="openRejectModal(${v.registrationId}, ${event.eventId})">Reject</button>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="sub">No further actions</span>
                                            </c:otherwise>
                                        </c:choose>
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

<div id="rejectModal" class="modal-overlay">
    <div class="modal-card modal-small">
        <div class="modal-header">
            <h3>Reject Application</h3>
            <button type="button" class="modal-close" onclick="document.getElementById('rejectModal').style.display='none'">&times;</button>
        </div>
        <div class="modal-body">
            <form method="post" action="${pageContext.request.contextPath}/organization/manage-registrations">
                <input type="hidden" name="returnTo" value="registration-log">
                <input type="hidden" name="registrationId" id="rejectRegistrationId">
                <input type="hidden" name="eventId" id="rejectEventId">
                <input type="hidden" name="action" value="reject">
                <textarea name="reviewNote" required style="width: 100%; min-height: 110px; padding: 12px 14px; border-radius: 10px; border: 1px solid #cbd5e1;" placeholder="Explain why this application is being rejected"></textarea>
                <div class="modal-actions">
                    <button type="button" class="btn btn-muted" onclick="document.getElementById('rejectModal').style.display='none'">Cancel</button>
                    <button type="submit" class="btn btn-danger">Reject</button>
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

function openRejectModal(registrationId, eventId) {
    document.getElementById("rejectRegistrationId").value = registrationId;
    document.getElementById("rejectEventId").value = eventId;
    document.getElementById("rejectModal").style.display = "flex";
}

window.addEventListener("click", function (event) {
    const profileModal = document.getElementById("profileModal");
    const rejectModal = document.getElementById("rejectModal");

    if (event.target === profileModal) {
        closeProfileModal();
    }
    if (event.target === rejectModal) {
        rejectModal.style.display = "none";
    }
});
</script>

<jsp:include page="/components/footer.jsp"/>
