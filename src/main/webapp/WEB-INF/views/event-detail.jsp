<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>${event.eventName} - IVAN</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <style>
        body { background: #f8fafc; font-family: "Inter", sans-serif; }
        .hero-banner {
            width: 100%;
            height: 340px;
            background: #64748b;
            background-image: url('${empty event.eventImageUrl ? "https://images.unsplash.com/photo-1552664730-d307ca884978?auto=format&fit=crop&q=80" : event.eventImageUrl}');
            background-size: cover;
            background-position: center;
            position: relative;
        }
        .hero-banner::after {
            content: "";
            position: absolute;
            inset: 0;
            background: linear-gradient(to top, rgba(15, 23, 42, 0.9), rgba(15, 23, 42, 0.18));
        }
        .page-shell {
            max-width: 1120px;
            margin: -110px auto 48px;
            padding: 0 20px;
            position: relative;
            z-index: 2;
            display: grid;
            grid-template-columns: minmax(0, 2fr) minmax(320px, 360px);
            gap: 28px;
        }
        .card {
            background: #fff;
            border-radius: 18px;
            box-shadow: 0 10px 30px rgba(15, 23, 42, 0.06);
            border: 1px solid #e2e8f0;
        }
        .main-card { padding: 34px; }
        .side-card { padding: 28px; height: fit-content; position: sticky; top: 92px; }
        .event-title { margin: 0; color: #0f172a; font-size: 34px; line-height: 1.15; }
        .org-name { margin-top: 14px; color: #475569; font-size: 16px; }
        .section-title { margin: 36px 0 14px; color: #0f172a; font-size: 20px; }
        .desc { color: #475569; line-height: 1.8; white-space: pre-wrap; }
        .alert {
            padding: 14px 16px;
            border-radius: 12px;
            border: 1px solid transparent;
            margin-bottom: 16px;
            line-height: 1.6;
        }
        .alert-success { background: #dcfce7; border-color: #bbf7d0; color: #166534; }
        .alert-error { background: #fef2f2; border-color: #fecaca; color: #991b1b; }
        .alert-info { background: #eff6ff; border-color: #bfdbfe; color: #1d4ed8; }
        .status-box {
            padding: 16px;
            border-radius: 14px;
            margin-bottom: 14px;
            border: 1px solid transparent;
        }
        .status-pending { background: #fef9c3; border-color: #fde68a; color: #854d0e; }
        .status-invited { background: #ede9fe; border-color: #c4b5fd; color: #6d28d9; }
        .status-approved { background: #dcfce7; border-color: #bbf7d0; color: #166534; }
        .status-rejected { background: #fee2e2; border-color: #fecaca; color: #991b1b; }
        .info-list { list-style: none; padding: 0; margin: 0 0 28px; }
        .info-list li {
            padding: 14px 0;
            border-bottom: 1px solid #e2e8f0;
            display: grid;
            gap: 6px;
        }
        .info-label {
            color: #64748b;
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.08em;
        }
        .info-value { color: #0f172a; font-size: 16px; font-weight: 600; }
        .progress-bar {
            width: 100%;
            height: 10px;
            background: #e2e8f0;
            border-radius: 999px;
            overflow: hidden;
            margin-top: 10px;
        }
        .progress-fill {
            height: 100%;
            background: linear-gradient(90deg, #2563eb, #7c3aed);
        }
        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 100%;
            padding: 12px 16px;
            border-radius: 12px;
            border: 1px solid transparent;
            font-weight: 700;
            cursor: pointer;
            text-decoration: none;
        }
        .btn-primary { background: #0f172a; color: #fff; }
        .btn-secondary { background: #fff; color: #475569; border-color: #cbd5e1; }
        .btn-danger { background: #fff1f2; color: #e11d48; border-color: #fecdd3; }
        .btn-muted {
            background: #f8fafc;
            color: #94a3b8;
            border-color: #e2e8f0;
            cursor: not-allowed;
        }
        .stack { display: grid; gap: 12px; }
        .submission-card {
            margin-top: 24px;
            padding: 20px;
            border-radius: 16px;
            background: #f8fafc;
            border: 1px solid #e2e8f0;
        }
        .submission-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 16px;
        }
        .submission-item {
            display: grid;
            gap: 6px;
        }
        .submission-item-wide { grid-column: 1 / -1; }
        .submission-label {
            color: #64748b;
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.08em;
        }
        .submission-value {
            color: #0f172a;
            line-height: 1.7;
            white-space: pre-wrap;
        }
        .submission-value-compact {
            white-space: normal;
            overflow-wrap: anywhere;
        }
        .comment-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
            margin-bottom: 18px;
            flex-wrap: wrap;
        }
        .comment-card {
            padding: 18px 20px;
            border-radius: 14px;
            border: 1px solid #e2e8f0;
            margin-bottom: 14px;
        }
        .comment-top {
            display: flex;
            justify-content: space-between;
            gap: 16px;
            margin-bottom: 10px;
        }
        .stars { color: #f59e0b; }
        .filter-row {
            display: flex;
            gap: 14px;
            flex-wrap: wrap;
            align-items: end;
            padding: 16px 18px;
            border-radius: 14px;
            background: #f8fafc;
            margin-bottom: 20px;
        }
        .filter-row label,
        .form-grid label {
            display: block;
            margin-bottom: 8px;
            color: #475569;
            font-size: 13px;
            font-weight: 700;
        }
        .filter-row select,
        .form-grid select,
        .form-grid textarea {
            width: 100%;
            padding: 11px 12px;
            border-radius: 10px;
            border: 1px solid #cbd5e1;
            font: inherit;
            box-sizing: border-box;
        }
        .form-grid {
            display: grid;
            gap: 16px;
        }
        .modal-overlay {
            display: none;
            position: fixed;
            inset: 0;
            background: rgba(15, 23, 42, 0.55);
            z-index: 1000;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .modal-card {
            width: 100%;
            max-width: 760px;
            background: #fff;
            border-radius: 18px;
            box-shadow: 0 20px 45px rgba(15, 23, 42, 0.2);
            border: 1px solid #e2e8f0;
            overflow: hidden;
        }
        .modal-header {
            padding: 22px 24px 16px;
            border-bottom: 1px solid #e2e8f0;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
        }
        .modal-header h3 { margin: 0; color: #0f172a; }
        .modal-close {
            background: none;
            border: none;
            color: #94a3b8;
            font-size: 28px;
            cursor: pointer;
        }
        .modal-body { padding: 24px; }
        .modal-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            flex-wrap: wrap;
            margin-top: 18px;
        }
        @media (max-width: 960px) {
            .page-shell { grid-template-columns: 1fr; }
            .side-card { position: static; }
            .submission-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
<jsp:include page="/components/header.jsp"/>

<div class="hero-banner"></div>

<div class="page-shell">
    <div class="card main-card">
        <h1 class="event-title">${event.eventName}</h1>
        <div class="org-name">Organized by <strong>${event.organizationName}</strong></div>

        <c:if test="${param.success == 'applied'}">
            <div class="alert alert-success">Your application was submitted. The organization can now review your motivation, experience, and availability.</div>
        </c:if>
        <c:if test="${param.success == 'cancelled'}">
            <div class="alert alert-info">Your current event registration was removed.</div>
        </c:if>
        <c:if test="${param.success == 'invitation_accepted'}">
            <div class="alert alert-success">Invitation accepted. You are now part of this event.</div>
        </c:if>
        <c:if test="${param.success == 'invitation_declined'}">
            <div class="alert alert-info">Invitation declined. You can still apply later if you change your mind.</div>
        </c:if>

        <c:if test="${param.error == 'missing_application_fields'}">
            <div class="alert alert-error">Please complete all application fields before submitting.</div>
        </c:if>
        <c:if test="${param.error == 'already_applied'}">
            <div class="alert alert-error">You already have an active application or invitation for this event.</div>
        </c:if>
        <c:if test="${param.error == 'event_full'}">
            <div class="alert alert-error">This event is full right now.</div>
        </c:if>
        <c:if test="${param.error == 'event_not_open'}">
            <div class="alert alert-error">This event is not open for new applications.</div>
        </c:if>
        <c:if test="${param.error == 'invitation_not_found'}">
            <div class="alert alert-error">The invitation could not be found or is no longer active.</div>
        </c:if>

        <h2 class="section-title">About This Event</h2>
        <div class="desc"><c:out value="${event.description}" /></div>

        <c:if test="${not empty latestRegistration and latestRegistration.registrationType == 'Application'}">
            <div class="submission-card">
                <h3 style="margin: 0 0 14px; color: #0f172a;">Your Latest Application</h3>
                <div class="submission-grid">
                    <div class="submission-item">
                        <div class="submission-label">Commitment</div>
                        <div class="submission-value">${empty latestRegistration.commitmentLevel ? 'Not provided' : latestRegistration.commitmentLevel}</div>
                    </div>
                    <div class="submission-item">
                        <div class="submission-label">Submitted At</div>
                        <div class="submission-value submission-value-compact">
                            <c:choose>
                                <c:when test="${not empty latestRegistrationAppliedLabel}">
                                    <c:out value="${latestRegistrationAppliedLabel}" />
                                </c:when>
                                <c:otherwise>Not available</c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="submission-item submission-item-wide">
                        <div class="submission-label">Why You Want To Join</div>
                        <div class="submission-value"><c:out value="${latestRegistration.applicationReason}" /></div>
                    </div>
                    <div class="submission-item submission-item-wide">
                        <div class="submission-label">Relevant Experience</div>
                        <div class="submission-value"><c:out value="${latestRegistration.relevantExperience}" /></div>
                    </div>
                    <div class="submission-item submission-item-wide">
                        <div class="submission-label">Availability</div>
                        <div class="submission-value"><c:out value="${latestRegistration.availabilityNote}" /></div>
                    </div>
                </div>
            </div>
        </c:if>

        <c:if test="${not empty latestRegistration and latestRegistration.registrationType == 'Invitation' and enrollStatus == 'Invited'}">
            <div class="submission-card">
                <h3 style="margin: 0 0 14px; color: #0f172a;">Invitation Details</h3>
                <div class="submission-item submission-item-wide">
                    <div class="submission-label">Message From Organization</div>
                    <div class="submission-value">
                        <c:out value="${empty latestRegistration.invitationMessage ? 'No invitation message was provided.' : latestRegistration.invitationMessage}" />
                    </div>
                </div>
            </div>
        </c:if>

        <c:if test="${enrollStatus == 'Approved'}">
            <div class="submission-card" style="background: linear-gradient(135deg, #eff6ff 0%, #eef2ff 100%); border-color: #c7d2fe;">
                <h3 style="margin: 0 0 10px; color: #1d4ed8;">You are on the team</h3>
                <div style="color: #334155; line-height: 1.7;">Your participation is approved. You can open your volunteer workspace to view tasks and schedules for this event.</div>
                <div style="margin-top: 16px;">
                    <a class="btn btn-primary" href="${pageContext.request.contextPath}/volunteer/workspace?eventId=${event.eventId}">Open Volunteer Workspace</a>
                </div>
            </div>
        </c:if>

        <div style="margin-top: 42px; padding-top: 30px; border-top: 1px solid #e2e8f0;">
            <div class="comment-header">
                <div>
                    <h2 style="margin: 0; color: #0f172a;">Comments and Ratings</h2>
                    <div style="margin-top: 6px; color: #64748b;">Only approved volunteers can comment after the event has closed.</div>
                </div>

                <c:if test="${not empty avgRating}">
                    <div class="alert" style="margin: 0; background: #fef9c3; border-color: #fde68a; color: #854d0e;">
                        Average rating:
                        <strong><fmt:formatNumber value="${avgRating}" maxFractionDigits="1" /></strong>
                    </div>
                </c:if>
            </div>

            <c:if test="${enrollStatus == 'Approved' and not eventClosedForFeedback}">
                <div class="alert alert-info">Comments will open after this event is closed.</div>
            </c:if>

            <c:if test="${canComment}">
                <form method="post" action="${pageContext.request.contextPath}/event/detail" class="submission-card" style="margin-top: 0;">
                    <input type="hidden" name="eventId" value="${event.eventId}">
                    <input type="hidden" name="action" value="comment">
                    <div class="form-grid">
                        <div>
                            <label for="rating">Your Rating</label>
                            <select id="rating" name="rating" required>
                                <option value="">Choose a rating</option>
                                <option value="5">5 - Excellent</option>
                                <option value="4">4 - Good</option>
                                <option value="3">3 - Average</option>
                                <option value="2">2 - Poor</option>
                                <option value="1">1 - Very poor</option>
                            </select>
                        </div>
                        <div>
                            <label for="comment">Your Comment</label>
                            <textarea id="comment" name="comment" rows="4" required placeholder="Share your experience for future volunteers."></textarea>
                        </div>
                    </div>
                    <div class="modal-actions">
                        <button type="submit" class="btn btn-primary" style="width: auto;">Submit Comment</button>
                    </div>
                </form>
            </c:if>

            <div class="filter-row">
                <div style="min-width: 180px;">
                    <label for="ratingFilter">Filter by Rating</label>
                    <select id="ratingFilter">
                        <option value="">All ratings</option>
                        <option value="5" ${ratingFilter == 5 ? 'selected' : ''}>5 stars</option>
                        <option value="4" ${ratingFilter == 4 ? 'selected' : ''}>4 stars</option>
                        <option value="3" ${ratingFilter == 3 ? 'selected' : ''}>3 stars</option>
                        <option value="2" ${ratingFilter == 2 ? 'selected' : ''}>2 stars</option>
                        <option value="1" ${ratingFilter == 1 ? 'selected' : ''}>1 star</option>
                    </select>
                </div>
                <div style="min-width: 180px;">
                    <label for="sortOrder">Sort by</label>
                    <select id="sortOrder">
                        <option value="newest" ${sortOrder == 'newest' ? 'selected' : ''}>Newest first</option>
                        <option value="oldest" ${sortOrder == 'oldest' ? 'selected' : ''}>Oldest first</option>
                    </select>
                </div>
                <div>
                    <button type="button" class="btn btn-secondary" style="width: auto;" onclick="applyFilter()">Refresh</button>
                </div>
            </div>

            <c:choose>
                <c:when test="${empty comments}">
                    <div class="alert alert-info">No comments yet.</div>
                </c:when>
                <c:otherwise>
                    <c:forEach items="${comments}" var="c">
                        <div class="comment-card">
                            <div class="comment-top">
                                <div>
                                    <strong style="color: #0f172a;">${c.userName}</strong>
                                    <div class="stars">
                                        <c:forEach begin="1" end="${c.rating}">★</c:forEach>
                                    </div>
                                </div>
                                <div style="color: #94a3b8; font-size: 13px;">
                                    <fmt:formatDate value="${c.createdAt}" pattern="dd MMM yyyy" />
                                </div>
                            </div>
                            <div style="color: #475569; line-height: 1.7;"><c:out value="${c.comment}" /></div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <div class="card side-card">
        <ul class="info-list">
            <li>
                <div class="info-label">Location</div>
                <div class="info-value">${event.location}</div>
            </li>
            <li>
                <div class="info-label">Start Date</div>
                <div class="info-value"><fmt:formatDate value="${event.startDateAsDate}" pattern="dd MMM yyyy" /></div>
            </li>
            <li>
                <div class="info-label">End Date</div>
                <div class="info-value"><fmt:formatDate value="${event.endDateAsDate}" pattern="dd MMM yyyy" /></div>
            </li>
            <li>
                <div class="info-label">Volunteer Capacity</div>
                <c:choose>
                    <c:when test="${event.maxVolunteers > 0}">
                        <div class="info-value">${event.currentVolunteers} / ${event.maxVolunteers} confirmed</div>
                        <div class="progress-bar">
                            <div class="progress-fill" style="width: ${event.currentVolunteers * 100 / event.maxVolunteers > 100 ? 100 : event.currentVolunteers * 100 / event.maxVolunteers}%"></div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="info-value">${event.currentVolunteers} confirmed, unlimited capacity</div>
                    </c:otherwise>
                </c:choose>
            </li>
            <li>
                <div class="info-label">Event Status</div>
                <div class="info-value">${event.status}</div>
            </li>
        </ul>

        <c:choose>
            <c:when test="${empty sessionScope.userId}">
                <a href="${pageContext.request.contextPath}/login" class="btn btn-primary">Log In To Apply</a>
            </c:when>
            <c:when test="${sessionScope.userRole != 'Volunteer'}">
                <button class="btn btn-muted" disabled>Only volunteer accounts can apply</button>
            </c:when>
            <c:when test="${enrollStatus == 'Pending'}">
                <div class="status-box status-pending">
                    <strong>Application pending</strong>
                    <div style="margin-top: 6px;">The organization is reviewing your application.</div>
                </div>
                <form method="post" action="${pageContext.request.contextPath}/event/detail">
                    <input type="hidden" name="eventId" value="${event.eventId}">
                    <button type="submit" name="action" value="cancel" class="btn btn-danger" onclick="return confirm('Cancel your pending application?');">Cancel Application</button>
                </form>
            </c:when>
            <c:when test="${enrollStatus == 'Invited'}">
                <div class="status-box status-invited">
                    <strong>Invitation waiting</strong>
                    <div style="margin-top: 6px;">The organization invited you to join this event.</div>
                </div>
                <div class="stack">
                    <form method="post" action="${pageContext.request.contextPath}/event/detail">
                        <input type="hidden" name="eventId" value="${event.eventId}">
                        <button type="submit" name="action" value="accept_invitation" class="btn btn-primary">Accept Invitation</button>
                    </form>
                    <form method="post" action="${pageContext.request.contextPath}/event/detail">
                        <input type="hidden" name="eventId" value="${event.eventId}">
                        <button type="submit" name="action" value="decline_invitation" class="btn btn-secondary" onclick="return confirm('Decline this invitation?');">Decline Invitation</button>
                    </form>
                </div>
            </c:when>
            <c:when test="${enrollStatus == 'Approved'}">
                <div class="status-box status-approved">
                    <strong>Participation approved</strong>
                    <div style="margin-top: 6px;">You are confirmed for this event.</div>
                </div>
                <div class="stack">
                    <a href="${pageContext.request.contextPath}/volunteer/workspace?eventId=${event.eventId}" class="btn btn-primary">Open Workspace</a>
                    <form method="post" action="${pageContext.request.contextPath}/event/detail">
                        <input type="hidden" name="eventId" value="${event.eventId}">
                        <button type="submit" name="action" value="cancel" class="btn btn-danger" onclick="return confirm('Withdraw from this event?');">Withdraw Participation</button>
                    </form>
                </div>
            </c:when>
            <c:when test="${enrollStatus == 'Rejected'}">
                <div class="status-box status-rejected">
                    <strong>Application rejected</strong>
                    <div style="margin-top: 6px;">
                        <c:out value="${empty rejectReason ? 'No reason was provided.' : rejectReason}" />
                    </div>
                </div>
                <c:choose>
                    <c:when test="${eventOpenForApplication and not event.isFull}">
                        <button type="button" class="btn btn-primary" onclick="openApplyModal()">Apply Again</button>
                    </c:when>
                    <c:otherwise>
                        <button class="btn btn-muted" disabled>Re-application is currently unavailable</button>
                    </c:otherwise>
                </c:choose>
            </c:when>
            <c:otherwise>
                <c:choose>
                    <c:when test="${not eventOpenForApplication}">
                        <button class="btn btn-muted" disabled>Applications are closed for this event</button>
                    </c:when>
                    <c:when test="${event.isFull}">
                        <button class="btn btn-muted" disabled>Event is full</button>
                    </c:when>
                    <c:otherwise>
                        <button type="button" class="btn btn-primary" onclick="openApplyModal()">Apply To This Event</button>
                    </c:otherwise>
                </c:choose>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<div id="applyModal" class="modal-overlay">
    <div class="modal-card">
        <div class="modal-header">
            <h3>Apply To ${event.eventName}</h3>
            <button type="button" class="modal-close" onclick="closeApplyModal()">&times;</button>
        </div>
        <div class="modal-body">
            <form method="post" action="${pageContext.request.contextPath}/event/detail" class="form-grid">
                <input type="hidden" name="eventId" value="${event.eventId}">
                <input type="hidden" name="action" value="apply">

                <div>
                    <label for="applicationReason">Why do you want to join this event?</label>
                    <textarea id="applicationReason" name="applicationReason" rows="4" required placeholder="Explain your motivation and how you want to contribute."></textarea>
                </div>

                <div>
                    <label for="relevantExperience">Relevant experience</label>
                    <textarea id="relevantExperience" name="relevantExperience" rows="4" required placeholder="Describe related volunteer work, community service, or useful practical experience."></textarea>
                </div>

                <div>
                    <label for="commitmentLevel">Commitment level</label>
                    <select id="commitmentLevel" name="commitmentLevel" required>
                        <option value="">Choose one</option>
                        <option value="Full event commitment">Full event commitment</option>
                        <option value="Most of the event">Most of the event</option>
                        <option value="Assigned shifts only">Assigned shifts only</option>
                    </select>
                </div>

                <div>
                    <label for="availabilityNote">Availability and scheduling notes</label>
                    <textarea id="availabilityNote" name="availabilityNote" rows="4" required placeholder="Share timing constraints, available days, transport notes, or anything the organizer should know."></textarea>
                </div>

                <div class="modal-actions">
                    <button type="button" class="btn btn-secondary" style="width: auto;" onclick="closeApplyModal()">Cancel</button>
                    <button type="submit" class="btn btn-primary" style="width: auto;">Submit Application</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="/components/footer.jsp"/>

<script>
function openApplyModal() {
    document.getElementById("applyModal").style.display = "flex";
}

function closeApplyModal() {
    document.getElementById("applyModal").style.display = "none";
}

function applyFilter() {
    const ratingFilter = document.getElementById("ratingFilter").value;
    const sortOrder = document.getElementById("sortOrder").value;
    let url = "${pageContext.request.contextPath}/event/detail?id=${event.eventId}";
    if (ratingFilter) {
        url += "&ratingFilter=" + encodeURIComponent(ratingFilter);
    }
    if (sortOrder) {
        url += "&sortOrder=" + encodeURIComponent(sortOrder);
    }
    window.location.href = url;
}

window.addEventListener("click", function (event) {
    const modal = document.getElementById("applyModal");
    if (event.target === modal) {
        closeApplyModal();
    }
});

<c:if test="${param.error == 'missing_application_fields'}">
openApplyModal();
</c:if>
</script>
</body>
</html>
