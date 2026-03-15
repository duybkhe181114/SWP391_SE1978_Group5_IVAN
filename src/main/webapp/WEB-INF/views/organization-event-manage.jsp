<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/components/header.jsp"/>

<style>
    .org-event-page {
        background: #f8fafc;
        min-height: 100vh;
        padding-bottom: 56px;
    }

    .org-event-shell {
        max-width: 1180px;
        margin: 0 auto;
        padding: 32px 20px 0;
    }

    .topbar {
        display: flex;
        justify-content: space-between;
        align-items: center;
        gap: 16px;
        margin-bottom: 24px;
        flex-wrap: wrap;
    }

    .topbar h1 {
        margin: 0;
        font-size: 30px;
        color: #0f172a;
    }

    .topbar p {
        margin: 8px 0 0;
        color: #64748b;
        line-height: 1.6;
    }

    .topbar-actions {
        display: flex;
        gap: 12px;
        flex-wrap: wrap;
    }

    .nav-btn,
    .primary-btn {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        padding: 10px 16px;
        border-radius: 10px;
        border: 1px solid #cbd5e1;
        background: #fff;
        color: #475569;
        text-decoration: none;
        font-weight: 700;
    }

    .primary-btn {
        background: #0f172a;
        color: #fff;
        border-color: #0f172a;
        cursor: pointer;
    }

    .message {
        margin-bottom: 16px;
        padding: 14px 18px;
        border-radius: 12px;
        line-height: 1.6;
        border: 1px solid transparent;
    }

    .message-success {
        background: #dcfce7;
        border-color: #bbf7d0;
        color: #166534;
    }

    .message-error {
        background: #fef2f2;
        border-color: #fecaca;
        color: #991b1b;
    }

    .hero,
    .panel {
        background: #fff;
        border: 1px solid #e2e8f0;
        border-radius: 18px;
        box-shadow: 0 10px 30px rgba(15, 23, 42, 0.05);
    }

    .hero {
        padding: 28px;
        margin-bottom: 24px;
    }

    .hero-grid {
        margin-top: 20px;
        display: grid;
        grid-template-columns: repeat(4, minmax(0, 1fr));
        gap: 16px;
    }

    .hero-stat {
        padding: 18px;
        border-radius: 14px;
        background: #f8fafc;
        border: 1px solid #e2e8f0;
    }

    .hero-label {
        color: #64748b;
        font-size: 12px;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 0.08em;
    }

    .hero-value {
        margin-top: 8px;
        font-size: 24px;
        font-weight: 800;
        color: #0f172a;
    }

    .panel {
        overflow: hidden;
        margin-bottom: 24px;
    }

    .panel-header {
        padding: 22px 24px;
        border-bottom: 1px solid #e2e8f0;
    }

    .panel-header h2 {
        margin: 0;
        font-size: 20px;
        color: #0f172a;
    }

    .panel-header p {
        margin: 8px 0 0;
        color: #64748b;
        line-height: 1.6;
    }

    .panel-body {
        padding: 24px;
    }

    .form-grid {
        display: grid;
        grid-template-columns: repeat(2, minmax(0, 1fr));
        gap: 18px;
    }

    .form-group {
        display: grid;
        gap: 8px;
    }

    .form-group-wide {
        grid-column: 1 / -1;
    }

    .form-group label {
        color: #475569;
        font-size: 12px;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 0.08em;
    }

    .form-group input,
    .form-group textarea {
        width: 100%;
        box-sizing: border-box;
        padding: 12px 14px;
        border-radius: 10px;
        border: 1px solid #cbd5e1;
        font: inherit;
        color: #0f172a;
        background: #fff;
    }

    .form-group textarea {
        resize: vertical;
        min-height: 140px;
    }

    .form-actions {
        display: flex;
        justify-content: flex-end;
        margin-top: 18px;
    }

    .feature-grid {
        display: grid;
        grid-template-columns: repeat(3, minmax(0, 1fr));
        gap: 18px;
    }

    .feature-card {
        display: grid;
        gap: 12px;
        padding: 22px;
        border-radius: 16px;
        border: 1px solid #e2e8f0;
        background: linear-gradient(180deg, #ffffff 0%, #f8fafc 100%);
    }

    .feature-card h3 {
        margin: 0;
        color: #0f172a;
        font-size: 18px;
    }

    .feature-card p {
        margin: 0;
        color: #64748b;
        line-height: 1.6;
    }

    .feature-count {
        font-size: 32px;
        font-weight: 800;
        color: #0f172a;
    }

    @media (max-width: 960px) {
        .hero-grid,
        .feature-grid,
        .form-grid {
            grid-template-columns: 1fr;
        }
    }
</style>

<div class="org-event-page">
    <div class="org-event-shell">
        <div class="topbar">
            <div>
                <h1>Event Management</h1>
                <p>Update event configuration here, then open the dedicated volunteer management screens below.</p>
            </div>

            <div class="topbar-actions">
                <a class="nav-btn" href="${pageContext.request.contextPath}/organization/dashboard">Back to Dashboard</a>
                <span class="nav-btn">Event #${event.eventId}</span>
            </div>
        </div>

        <c:if test="${param.success == 'event_updated'}">
            <div class="message message-success">Event information updated successfully.</div>
        </c:if>
        <c:if test="${param.success == 'event_resubmitted'}">
            <div class="message message-success">Event changes saved. Because this event was previously rejected, it has been resubmitted for admin review.</div>
        </c:if>
        <c:if test="${param.error == 'missing_event_fields'}">
            <div class="message message-error">Please fill in all required event fields before saving.</div>
        </c:if>
        <c:if test="${param.error == 'invalid_slot_limit'}">
            <div class="message message-error">Volunteer limit must be a valid number greater than or equal to 0.</div>
        </c:if>
        <c:if test="${param.error == 'invalid_event_dates'}">
            <div class="message message-error">Event dates are invalid. End date cannot be earlier than start date.</div>
        </c:if>
        <c:if test="${param.error == 'slot_below_joined'}">
            <div class="message message-error">Volunteer limit cannot be lower than the number of already approved volunteers.</div>
        </c:if>
        <c:if test="${param.error == 'event_update_failed'}">
            <div class="message message-error">Event update failed. Please try again.</div>
        </c:if>
        <c:if test="${event.status == 'Rejected' and not empty event.reviewNote}">
            <div class="message message-error">Admin feedback: ${event.reviewNote}. Update the event below to send it back for review.</div>
        </c:if>

        <section class="hero">
            <div style="display: flex; justify-content: space-between; gap: 16px; align-items: start; flex-wrap: wrap;">
                <div>
                    <h2 style="margin: 0; color: #0f172a; font-size: 28px;">${event.eventName}</h2>
                    <p style="margin: 10px 0 0; color: #64748b; line-height: 1.7;">
                        ${empty event.description ? 'No event description provided yet.' : event.description}
                    </p>
                    <c:if test="${not empty event.eventImageUrl}">
                        <p style="margin: 12px 0 0;">
                            <a href="${event.eventImageUrl}" target="_blank" rel="noopener" style="color: #7c3aed; font-weight: 700; text-decoration: none;">Open current cover image URL</a>
                        </p>
                    </c:if>
                </div>
                <span class="nav-btn">${event.status}</span>
            </div>

            <div class="hero-grid">
                <div class="hero-stat">
                    <div class="hero-label">Volunteer Limit</div>
                    <div class="hero-value">${event.maxVolunteers == 0 ? 'Unlimited' : event.maxVolunteers}</div>
                </div>
                <div class="hero-stat">
                    <div class="hero-label">Joined Volunteers</div>
                    <div class="hero-value">${event.currentVolunteers}</div>
                </div>
                <div class="hero-stat">
                    <div class="hero-label">Location</div>
                    <div class="hero-value" style="font-size: 18px;">${event.location}</div>
                </div>
                <div class="hero-stat">
                    <div class="hero-label">Schedule</div>
                    <div class="hero-value" style="font-size: 16px;">
                        ${empty event.startDate ? 'N/A' : event.startDate.toLocalDate()}<br>
                        ${empty event.endDate ? '' : event.endDate.toLocalDate()}
                    </div>
                </div>
                <div class="hero-stat">
                    <div class="hero-label">Primary Contact</div>
                    <div class="hero-value" style="font-size: 18px;">
                        ${empty event.contactName ? 'Not set' : event.contactName}
                    </div>
                </div>
            </div>
        </section>

        <section class="panel">
            <div class="panel-header">
                <h2>Edit Event</h2>
                <p>Change event logistics, volunteer expectations, and contact information. Rejected events will automatically move back to pending review after you save.</p>
            </div>

            <div class="panel-body">
                <form method="post" action="${pageContext.request.contextPath}/organization/manage-event">
                    <input type="hidden" name="action" value="update_event">
                    <input type="hidden" name="eventId" value="${event.eventId}">

                    <div class="form-grid">
                        <div class="form-group form-group-wide">
                            <label>Event Title</label>
                            <input type="text" name="title" value="${event.eventName}" required>
                        </div>

                        <div class="form-group">
                            <label>Location</label>
                            <input type="text" name="location" value="${event.location}" required>
                        </div>

                        <div class="form-group">
                            <label>Volunteer Limit</label>
                            <input type="number" name="maxVolunteers" min="0" value="${event.maxVolunteers}" required>
                        </div>

                        <div class="form-group form-group-wide">
                            <label>Cover Image URL</label>
                            <input type="url" name="coverImageUrl" value="${event.eventImageUrl}" placeholder="https://example.com/event-cover.jpg">
                        </div>

                        <div class="form-group">
                            <label>Primary Contact Name</label>
                            <input type="text" name="contactName" value="${event.contactName}" placeholder="Coordinator or representative">
                        </div>

                        <div class="form-group">
                            <label>Contact Phone</label>
                            <input type="text" name="contactPhone" value="${event.contactPhone}" placeholder="Phone for urgent coordination">
                        </div>

                        <div class="form-group form-group-wide">
                            <label>Contact Email</label>
                            <input type="email" name="contactEmail" value="${event.contactEmail}" placeholder="event-contact@organization.org">
                        </div>

                        <div class="form-group">
                            <label>Start Date</label>
                            <input type="date" id="eventStartDate" name="startDate" value="${empty event.startDate ? '' : event.startDate.toLocalDate()}" required>
                        </div>

                        <div class="form-group">
                            <label>End Date</label>
                            <input type="date" id="eventEndDate" name="endDate" value="${empty event.endDate ? '' : event.endDate.toLocalDate()}" required>
                        </div>

                        <div class="form-group form-group-wide">
                            <label>Description</label>
                            <textarea name="description" required>${event.description}</textarea>
                        </div>

                        <div class="form-group form-group-wide">
                            <label>Volunteer Requirements</label>
                            <textarea name="requirements" placeholder="Skills, attendance expectations, dress code, or participation requirements.">${event.requirements}</textarea>
                        </div>

                        <div class="form-group form-group-wide">
                            <label>What Volunteers Receive</label>
                            <textarea name="benefits" placeholder="Meals, training, transport support, certificate, or other event support.">${event.benefits}</textarea>
                        </div>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="primary-btn">Save Event Changes</button>
                    </div>
                </form>
            </div>
        </section>

        <section class="panel">
            <div class="panel-header">
                <h2>Volunteer Management Screens</h2>
                <p>Open the dedicated screens below to manage volunteers in detail.</p>
            </div>

            <div class="panel-body">
                <div class="feature-grid">
                    <div class="feature-card">
                        <div class="feature-count">${availableVolunteerCount}</div>
                        <h3>Volunteer Pool</h3>
                        <p>Browse volunteers outside this event, inspect profiles, and send invitations they must accept.</p>
                        <a class="nav-btn" href="${pageContext.request.contextPath}/organization/volunteer-pool?eventId=${event.eventId}">Open Volunteer Pool</a>
                    </div>

                    <div class="feature-card">
                        <div class="feature-count">${activeTeamCount}</div>
                        <h3>Manage Event Members</h3>
                        <p>Review approved members, promote or revoke coordinators, and remove people from the event.</p>
                        <a class="nav-btn" href="${pageContext.request.contextPath}/organization/active-team?eventId=${event.eventId}">Open Event Members</a>
                    </div>

                    <div class="feature-card">
                        <div class="feature-count">${pendingRegistrationCount + invitedRegistrationCount + rejectedRegistrationCount + declinedRegistrationCount}</div>
                        <h3>Registration Log</h3>
                        <p>Track pending applications, sent invitations, rejection reasons, and volunteer responses in one place.</p>
                        <a class="nav-btn" href="${pageContext.request.contextPath}/organization/registration-log?eventId=${event.eventId}">Open Registration Log</a>
                    </div>
                </div>
            </div>
        </section>
    </div>
</div>

<script>
const eventStartDateInput = document.getElementById("eventStartDate");
const eventEndDateInput = document.getElementById("eventEndDate");

function syncManageEventDates() {
    if (!eventStartDateInput || !eventEndDateInput) {
        return;
    }
    eventEndDateInput.min = eventStartDateInput.value || "";
}

if (eventStartDateInput && eventEndDateInput) {
    eventStartDateInput.addEventListener("change", syncManageEventDates);
    syncManageEventDates();
}
</script>

<jsp:include page="/components/footer.jsp"/>
