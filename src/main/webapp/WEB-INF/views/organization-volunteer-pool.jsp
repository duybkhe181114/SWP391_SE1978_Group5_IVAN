<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/components/header.jsp"/>

<c:set var="eventIsFull" value="${event.maxVolunteers > 0 and event.currentVolunteers >= event.maxVolunteers}" />

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
    .message-success { background: #dcfce7; border-color: #bbf7d0; color: #166534; }
    .message-error { background: #fef2f2; border-color: #fecaca; color: #991b1b; }
    .panel { background: #fff; border: 1px solid #e2e8f0; border-radius: 18px; box-shadow: 0 10px 30px rgba(15, 23, 42, 0.05); overflow: hidden; }
    .panel-header { padding: 22px 24px; border-bottom: 1px solid #e2e8f0; display: flex; justify-content: space-between; align-items: center; gap: 16px; flex-wrap: wrap; }
    .panel-title { margin: 0; color: #0f172a; font-size: 20px; }
    .panel-note { margin: 8px 0 0; color: #64748b; line-height: 1.6; }
    .search-form { display: flex; gap: 10px; flex-wrap: wrap; align-items: center; }
    .search-form input { min-width: 280px; padding: 11px 14px; border-radius: 10px; border: 1px solid #cbd5e1; font: inherit; }
    .btn { display: inline-flex; align-items: center; justify-content: center; padding: 10px 16px; border-radius: 10px; border: 1px solid transparent; font-weight: 700; cursor: pointer; text-decoration: none; }
    .btn-primary { background: #0f172a; color: #fff; }
    .btn-success { background: #16a34a; color: #fff; }
    .btn-disabled { background: #f8fafc; color: #94a3b8; border-color: #e2e8f0; cursor: not-allowed; }
    .table-wrap { overflow-x: auto; }
    .table { width: 100%; border-collapse: collapse; }
    .table thead { background: #f8fafc; }
    .table th, .table td { padding: 16px 18px; text-align: left; border-bottom: 1px solid #e2e8f0; vertical-align: top; }
    .table th { color: #64748b; font-size: 12px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.08em; }
    .name { font-weight: 700; color: #0f172a; }
    .sub { margin-top: 6px; color: #94a3b8; font-size: 12px; }
    .link-btn { background: none; border: none; padding: 0; margin-top: 6px; color: #7c3aed; font-weight: 700; cursor: pointer; font-size: 12px; }
    .empty { padding: 30px 24px; text-align: center; color: #94a3b8; }
    .modal-overlay { display: none; position: fixed; inset: 0; background: rgba(15, 23, 42, 0.58); z-index: 1000; align-items: center; justify-content: center; padding: 20px; }
    .modal-card { background: #fff; border-radius: 18px; width: 100%; max-width: 620px; max-height: 90vh; overflow-y: auto; box-shadow: 0 18px 40px rgba(15, 23, 42, 0.22); }
    .modal-header { padding: 22px 24px 16px; border-bottom: 1px solid #e2e8f0; display: flex; justify-content: space-between; align-items: center; gap: 16px; }
    .modal-header h3 { margin: 0; color: #0f172a; font-size: 20px; }
    .modal-close { border: none; background: none; color: #94a3b8; font-size: 28px; cursor: pointer; }
    .modal-body { padding: 24px; }
    @media (max-width: 760px) { .screen-shell { padding: 24px 14px 0; } }
</style>

<div class="screen-page">
    <div class="screen-shell">
        <div class="header-row">
            <div>
                <h1>Volunteer Pool</h1>
                <p>Browse active volunteers outside this event, inspect their profiles, and add them directly when needed.</p>
            </div>
            <a class="nav-link" href="${pageContext.request.contextPath}/event/detail?id=${event.eventId}">Back to Event</a>
        </div>

        <div class="nav-row">
            <a class="nav-link" href="${pageContext.request.contextPath}/event/detail?id=${event.eventId}">Overview</a>
            <a class="nav-link nav-link-active" href="${pageContext.request.contextPath}/organization/volunteer-pool?eventId=${event.eventId}">Volunteer Pool</a>
            <a class="nav-link" href="${pageContext.request.contextPath}/organization/active-team?eventId=${event.eventId}">Event Members</a>
            <a class="nav-link" href="${pageContext.request.contextPath}/organization/registration-log?eventId=${event.eventId}">Registration Log</a>
        </div>

        <c:if test="${param.success == 'volunteer_added'}">
            <div class="message message-success">Volunteer added to the event successfully.</div>
        </c:if>
        <c:if test="${param.error == 'missing_volunteer'}">
            <div class="message message-error">Please choose a volunteer to add.</div>
        </c:if>
        <c:if test="${param.error == 'event_full'}">
            <div class="message message-error">This event is already full. Increase the volunteer limit before adding more people.</div>
        </c:if>
        <c:if test="${param.error == 'volunteer_add_failed'}">
            <div class="message message-error">Volunteer could not be added. They may already belong to this event.</div>
        </c:if>

        <section class="panel">
            <div class="panel-header">
                <div>
                    <h2 class="panel-title">${event.eventName}</h2>
                    <p class="panel-note">Search by name, email, phone, or skill to find the right volunteer for this event.</p>
                </div>

                <form method="get" action="${pageContext.request.contextPath}/organization/volunteer-pool" class="search-form">
                    <input type="hidden" name="eventId" value="${event.eventId}">
                    <input type="text" name="q" value="${poolQuery}" placeholder="Search volunteers">
                    <button type="submit" class="btn btn-primary">Search</button>
                </form>
            </div>

            <div class="table-wrap">
                <table class="table">
                    <thead>
                    <tr>
                        <th>Volunteer</th>
                        <th>Contact</th>
                        <th>Skills</th>
                        <th style="text-align: center;">Action</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:choose>
                        <c:when test="${empty availableVolunteers}">
                            <tr>
                                <td colspan="4" class="empty">No available volunteers matched the current search.</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach items="${availableVolunteers}" var="v">
                                <tr>
                                    <td>
                                        <div class="name">${v.fullName}</div>
                                        <div class="sub">${empty v.province ? 'Province not provided' : v.province}</div>
                                        <button type="button" class="link-btn" onclick="openProfileModal(${v.volunteerId})">View Profile</button>
                                    </td>
                                    <td>
                                        <div>${v.email}</div>
                                        <div class="sub">${empty v.phone ? 'No phone' : v.phone}</div>
                                    </td>
                                    <td>${empty v.skills ? 'No skills listed' : v.skills}</td>
                                    <td style="text-align: center;">
                                        <c:choose>
                                            <c:when test="${eventIsFull}">
                                                <button type="button" class="btn btn-disabled" disabled>Event Full</button>
                                            </c:when>
                                            <c:otherwise>
                                                <form method="post" action="${pageContext.request.contextPath}/organization/manage-event">
                                                    <input type="hidden" name="action" value="add_volunteer">
                                                    <input type="hidden" name="returnTo" value="volunteer-pool">
                                                    <input type="hidden" name="eventId" value="${event.eventId}">
                                                    <input type="hidden" name="volunteerId" value="${v.volunteerId}">
                                                    <button type="submit" class="btn btn-success" onclick="return confirm('Add this volunteer directly to the event?');">Add To Event</button>
                                                </form>
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

window.addEventListener("click", function (event) {
    const profileModal = document.getElementById("profileModal");
    if (event.target === profileModal) {
        closeProfileModal();
    }
});
</script>

<jsp:include page="/components/footer.jsp"/>
