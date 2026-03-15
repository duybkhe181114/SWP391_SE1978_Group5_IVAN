<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>${currentSection == 'review' ? 'Event Review Queue' : 'Manage Events'} - Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <style>
        body { background: #f8fafc; font-family: 'Segoe UI', sans-serif; }
        .page-shell { max-width: 1360px; margin: 0 auto; padding: 28px 18px 48px; }
        .hero { padding: 28px; border-radius: 24px; color: #f8fafc; background: linear-gradient(135deg, #0f172a 0%, #1e293b 55%, #334155 100%); box-shadow: 0 24px 60px rgba(15, 23, 42, 0.16); }
        .hero h1 { margin: 10px 0 8px; font-size: clamp(30px, 4vw, 42px); }
        .hero p { margin: 0; max-width: 760px; color: rgba(248, 250, 252, 0.8); line-height: 1.7; }
        .hero-chip { display: inline-flex; padding: 8px 14px; border-radius: 999px; background: rgba(255,255,255,0.12); color: #fde68a; font-size: 12px; font-weight: 700; letter-spacing: 0.08em; text-transform: uppercase; }
        .stats-grid { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 16px; margin-top: 22px; }
        .stat-card { padding: 18px 20px; border-radius: 18px; background: rgba(255,255,255,0.09); border: 1px solid rgba(255,255,255,0.14); }
        .stat-label { font-size: 12px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.08em; color: rgba(226,232,240,0.76); }
        .stat-value { margin-top: 8px; font-size: 30px; font-weight: 800; color: #fff; }
        .page-nav { display: flex; flex-wrap: wrap; gap: 12px; margin-top: 22px; }
        .page-nav a { display: inline-flex; align-items: center; justify-content: center; padding: 12px 18px; border-radius: 12px; border: 1px solid rgba(255,255,255,0.16); text-decoration: none; font-size: 14px; font-weight: 700; color: #e2e8f0; background: rgba(15, 23, 42, 0.16); }
        .page-nav a.is-active { background: #fff; color: #0f172a; border-color: #fff; }
        .alert { margin-top: 18px; padding: 14px 16px; border-radius: 14px; border: 1px solid transparent; font-size: 14px; line-height: 1.6; }
        .alert-success { background: #ecfdf5; border-color: #a7f3d0; color: #166534; }
        .alert-error { background: #fef2f2; border-color: #fecaca; color: #b91c1c; }
        .section { margin-top: 24px; padding: 24px; border-radius: 24px; border: 1px solid #e2e8f0; background: #fff; box-shadow: 0 14px 30px rgba(15, 23, 42, 0.05); }
        .section h2 { margin: 0 0 8px; color: #0f172a; font-size: 24px; }
        .section-note { margin: 0 0 18px; color: #64748b; line-height: 1.6; }
        .toolbar form { display: grid; grid-template-columns: minmax(0, 2fr) minmax(220px, 0.9fr) auto; gap: 14px; align-items: end; }
        .field { display: grid; gap: 8px; }
        .field label { color: #475569; font-size: 13px; font-weight: 700; }
        .field input, .field select { width: 100%; box-sizing: border-box; padding: 12px 14px; border: 1px solid #cbd5e1; border-radius: 12px; font: inherit; background: #fff; color: #0f172a; }
        .event-list { display: grid; gap: 18px; }
        .event-card { padding: 22px; border-radius: 20px; border: 1px solid #e2e8f0; background: linear-gradient(180deg, #fff 0%, #f8fafc 100%); }
        .event-top { display: flex; justify-content: space-between; gap: 18px; align-items: start; }
        .event-title { margin: 0; color: #0f172a; font-size: 24px; }
        .event-subtitle { margin-top: 8px; color: #475569; font-size: 14px; line-height: 1.6; }
        .chip { display: inline-flex; align-items: center; padding: 7px 12px; border-radius: 999px; font-size: 12px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.05em; background: #fff7ed; color: #c2410c; }
        .chip-approved { background: #dcfce7; color: #166534; }
        .chip-rejected { background: #fee2e2; color: #991b1b; }
        .chip-closed { background: #e2e8f0; color: #334155; }
        .detail-grid { display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 14px; margin-top: 18px; }
        .box { padding: 14px 16px; border-radius: 16px; border: 1px solid #e2e8f0; background: #fff; }
        .box-wide { grid-column: 1 / -1; }
        .box-label { color: #64748b; font-size: 12px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.08em; }
        .box-value { margin-top: 6px; color: #0f172a; line-height: 1.6; overflow-wrap: anywhere; }
        .review-form { margin-top: 18px; display: grid; gap: 10px; }
        .review-form label { color: #334155; font-size: 13px; font-weight: 700; }
        .review-form textarea { width: 100%; min-height: 90px; box-sizing: border-box; padding: 12px 14px; border: 1px solid #cbd5e1; border-radius: 12px; font: inherit; resize: vertical; }
        .review-form textarea.has-error { border-color: #f87171; background: #fff5f5; }
        .field-error { display: none; color: #b91c1c; font-size: 13px; font-weight: 600; }
        .action-row { display: flex; flex-wrap: wrap; gap: 10px; }
        .btn { display: inline-flex; align-items: center; justify-content: center; padding: 12px 18px; border-radius: 12px; border: 1px solid transparent; text-decoration: none; font-size: 14px; font-weight: 700; cursor: pointer; transition: transform .2s ease; }
        .btn:hover { transform: translateY(-1px); }
        .btn-approve { background: #16a34a; color: #fff; }
        .btn-reject { background: #dc2626; color: #fff; }
        .btn-secondary { background: #eff6ff; color: #1d4ed8; }
        .btn-clear { background: #f8fafc; color: #475569; border-color: #cbd5e1; }
        .directory-summary { display: grid; grid-template-columns: repeat(4, minmax(0, 1fr)); gap: 14px; margin-top: 18px; }
        .empty-state { padding: 42px 20px; border: 1px dashed #cbd5e1; border-radius: 18px; background: #f8fafc; text-align: center; color: #94a3b8; }
        @media (max-width: 960px) { .detail-grid, .directory-summary, .stats-grid { grid-template-columns: 1fr; } .event-top, .action-row { flex-direction: column; } .toolbar form { grid-template-columns: 1fr; } }
    </style>
</head>
<body>
<jsp:include page="/components/header.jsp"/>

<div class="page-shell">
    <div class="hero">
        <span class="hero-chip">Admin Review</span>
        <h1>${currentSection == 'review' ? 'Event Review Queue' : 'Manage Events'}</h1>
        <p>
            <c:choose>
                <c:when test="${currentSection == 'review'}">
                    Review pending event submissions here, then approve or reject them with clear feedback for the organization.
                </c:when>
                <c:otherwise>
                    Browse the full event directory to inspect approved, pending, rejected, and closed events across the system.
                </c:otherwise>
            </c:choose>
        </p>
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-label">All Events</div>
                <div class="stat-value">${allEventCount}</div>
            </div>
            <div class="stat-card">
                <div class="stat-label">Pending Review</div>
                <div class="stat-value">${pendingEventCount}</div>
            </div>
        </div>
        <div class="page-nav">
            <a href="${pageContext.request.contextPath}/admin/manage-events" class="${currentSection == 'directory' ? 'is-active' : ''}">Event Directory</a>
            <a href="${pageContext.request.contextPath}/admin/review-events" class="${currentSection == 'review' ? 'is-active' : ''}">Pending Event Queue</a>
        </div>
    </div>

    <c:if test="${param.success == 'reviewed'}"><div class="alert alert-success">Event review saved successfully.</div></c:if>
    <c:if test="${param.error == 'invalid_event'}"><div class="alert alert-error">The selected event could not be found.</div></c:if>
    <c:if test="${param.error == 'invalid_action'}"><div class="alert alert-error">That event action was not recognized.</div></c:if>

    <c:if test="${currentSection == 'directory'}">
    <div class="section">
        <h2>Event Directory</h2>
        <p class="section-note">This section lists all events in the system so the admin can inspect approved, pending, rejected, and closed events from one place.</p>

        <div class="toolbar">
            <form method="get" action="${pageContext.request.contextPath}/admin/manage-events">
                <div class="field">
                    <label>Search Events</label>
                    <input type="text" name="q" value="${param.q}" placeholder="Event title, organization, location, or contact">
                </div>

                <div class="field">
                    <label>Status</label>
                    <select name="status">
                        <option value="">All</option>
                        <option value="Approved" ${param.status == 'Approved' ? 'selected' : ''}>Approved</option>
                        <option value="Pending" ${param.status == 'Pending' ? 'selected' : ''}>Pending</option>
                        <option value="Rejected" ${param.status == 'Rejected' ? 'selected' : ''}>Rejected</option>
                        <option value="Closed" ${param.status == 'Closed' ? 'selected' : ''}>Closed</option>
                    </select>
                </div>

                <div class="action-row">
                    <button type="submit" class="btn btn-secondary">Apply Filters</button>
                    <a href="${pageContext.request.contextPath}/admin/manage-events" class="btn btn-clear">Clear</a>
                </div>
            </form>
        </div>

        <c:choose>
            <c:when test="${empty allEvents}">
                <div class="empty-state">
                    <p style="font-size: 16px; margin-bottom: 8px;">No events matched the current filters</p>
                    <p style="font-size: 14px;">Try clearing the filters or adjusting your search terms.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="event-list">
                    <c:forEach var="event" items="${allEvents}">
                        <div class="event-card">
                            <div class="event-top">
                                <div>
                                    <h3 class="event-title">${event.eventName}</h3>
                                    <div class="event-subtitle">${event.organizationName} • ${event.location}</div>
                                </div>
                                <c:choose>
                                    <c:when test="${event.status == 'Approved'}"><span class="chip chip-approved">Approved</span></c:when>
                                    <c:when test="${event.status == 'Rejected'}"><span class="chip chip-rejected">Rejected</span></c:when>
                                    <c:when test="${event.status == 'Closed'}"><span class="chip chip-closed">Closed</span></c:when>
                                    <c:otherwise><span class="chip">Pending</span></c:otherwise>
                                </c:choose>
                            </div>

                            <div class="directory-summary">
                                <div class="box">
                                    <div class="box-label">Schedule</div>
                                    <div class="box-value">
                                        <c:choose>
                                            <c:when test="${not empty event.startDateAsDate and not empty event.endDateAsDate}">
                                                <fmt:formatDate value="${event.startDateAsDate}" pattern="dd MMM yyyy" /> -
                                                <fmt:formatDate value="${event.endDateAsDate}" pattern="dd MMM yyyy" />
                                            </c:when>
                                            <c:otherwise>Not scheduled</c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <div class="box">
                                    <div class="box-label">Volunteers</div>
                                    <div class="box-value">${event.currentVolunteers} / ${event.maxVolunteers == 0 ? 'Unlimited' : event.maxVolunteers}</div>
                                </div>
                                <div class="box">
                                    <div class="box-label">Primary Contact</div>
                                    <div class="box-value">${empty event.contactName ? 'Not provided' : event.contactName}</div>
                                </div>
                                <div class="box">
                                    <div class="box-label">Review Note</div>
                                    <div class="box-value">${empty event.reviewNote ? 'No review note' : event.reviewNote}</div>
                                </div>
                            </div>

                            <div class="detail-grid">
                                <div class="box">
                                    <div class="box-label">Contact Email</div>
                                    <div class="box-value">${empty event.contactEmail ? 'Not provided' : event.contactEmail}</div>
                                </div>
                                <div class="box">
                                    <div class="box-label">Contact Phone</div>
                                    <div class="box-value">${empty event.contactPhone ? 'Not provided' : event.contactPhone}</div>
                                </div>
                                <div class="box">
                                    <div class="box-label">Reviewed At</div>
                                    <div class="box-value">
                                        <c:choose>
                                            <c:when test="${not empty event.reviewedAtAsDate}">
                                                <fmt:formatDate value="${event.reviewedAtAsDate}" pattern="dd MMM yyyy HH:mm" />
                                            </c:when>
                                            <c:otherwise>Not reviewed</c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <div class="box box-wide">
                                    <div class="box-label">Description</div>
                                    <div class="box-value"><c:out value="${event.description}" /></div>
                                </div>
                                <c:if test="${not empty event.requirements}">
                                    <div class="box box-wide">
                                        <div class="box-label">Volunteer Requirements</div>
                                        <div class="box-value"><c:out value="${event.requirements}" /></div>
                                    </div>
                                </c:if>
                                <c:if test="${not empty event.benefits}">
                                    <div class="box box-wide">
                                        <div class="box-label">Volunteer Benefits</div>
                                        <div class="box-value"><c:out value="${event.benefits}" /></div>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
    </c:if>

    <c:if test="${currentSection == 'review'}">
    <div class="section">
        <h2>Pending Event Queue</h2>
        <p class="section-note">Rejecting an event requires feedback so the organization knows what to fix before resubmitting.</p>

        <c:choose>
            <c:when test="${empty pendingEvents}">
                <div class="empty-state">
                    <p style="font-size: 16px; margin-bottom: 8px;">No pending events</p>
                    <p style="font-size: 14px;">All event submissions have been reviewed.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="event-list">
                    <c:forEach var="event" items="${pendingEvents}">
                        <div class="event-card" id="event-${event.eventId}">
                            <div class="event-top">
                                <div>
                                    <h3 class="event-title">${event.eventName}</h3>
                                    <div class="event-subtitle">
                                        ${event.organizationName} • ${event.location}
                                    </div>
                                </div>
                                <span class="chip">Pending Review</span>
                            </div>

                            <div class="detail-grid">
                                <div class="box">
                                    <div class="box-label">Schedule</div>
                                    <div class="box-value">
                                        <fmt:formatDate value="${event.startDateAsDate}" pattern="dd MMM yyyy" />
                                        -
                                        <fmt:formatDate value="${event.endDateAsDate}" pattern="dd MMM yyyy" />
                                    </div>
                                </div>
                                <div class="box">
                                    <div class="box-label">Volunteer Limit</div>
                                    <div class="box-value">${event.maxVolunteers == 0 ? 'Unlimited' : event.maxVolunteers}</div>
                                </div>
                                <div class="box">
                                    <div class="box-label">Primary Contact</div>
                                    <div class="box-value">${empty event.contactName ? 'Not provided' : event.contactName}</div>
                                </div>
                                <c:if test="${not empty event.contactEmail or not empty event.contactPhone}">
                                    <div class="box">
                                        <div class="box-label">Contact Details</div>
                                        <div class="box-value">
                                            <c:if test="${not empty event.contactEmail}">${event.contactEmail}</c:if>
                                            <c:if test="${not empty event.contactEmail and not empty event.contactPhone}"><br></c:if>
                                            <c:if test="${not empty event.contactPhone}">${event.contactPhone}</c:if>
                                        </div>
                                    </div>
                                </c:if>
                                <div class="box box-wide">
                                    <div class="box-label">Description</div>
                                    <div class="box-value"><c:out value="${event.description}" /></div>
                                </div>
                                <c:if test="${not empty event.requirements}">
                                    <div class="box box-wide">
                                        <div class="box-label">Volunteer Requirements</div>
                                        <div class="box-value"><c:out value="${event.requirements}" /></div>
                                    </div>
                                </c:if>
                                <c:if test="${not empty event.benefits}">
                                    <div class="box box-wide">
                                        <div class="box-label">Volunteer Benefits</div>
                                        <div class="box-value"><c:out value="${event.benefits}" /></div>
                                    </div>
                                </c:if>
                            </div>

                            <form method="post" class="review-form" action="${pageContext.request.contextPath}/admin/manage-events">
                                <input type="hidden" name="eventId" value="${event.eventId}">
                                <label>Review Note</label>
                                <textarea
                                        name="reviewNote"
                                        class="${param.error == 'note_required' and param.eventId == event.eventId ? 'has-error' : ''}"
                                        placeholder="Optional for approval, required for rejection."></textarea>
                                <c:if test="${param.error == 'note_required' and param.eventId == event.eventId}">
                                    <div class="field-error" style="display: block;">Please add a rejection note for this event before rejecting it.</div>
                                </c:if>
                                <div class="field-error inline-error">Please add a rejection note for this event before rejecting it.</div>
                                <div class="action-row">
                                    <button type="submit" name="action" value="approve" class="btn btn-approve" onclick="return confirm('Approve this event submission?')">Approve Event</button>
                                    <button type="submit" name="action" value="reject" class="btn btn-reject" onclick="return validateEventReject(this)">Reject With Note</button>
                                </div>
                            </form>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
    </c:if>
</div>

<script>
function validateEventReject(button) {
    const form = button.form;
    const noteField = form.querySelector('textarea[name="reviewNote"]');
    const inlineError = form.querySelector('.inline-error');

    if (noteField && noteField.value.trim() !== "") {
        noteField.classList.remove("has-error");
        if (inlineError) {
            inlineError.style.display = "none";
        }
        return confirm("Reject this event submission?");
    }

    noteField.classList.add("has-error");
    if (inlineError) {
        inlineError.style.display = "block";
    }
    noteField.focus();
    return false;
}
</script>

<jsp:include page="/components/footer.jsp"/>
</body>
</html>
