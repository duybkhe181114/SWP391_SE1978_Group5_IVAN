<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>${event.eventName} - IVAN</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <style>
        body { background: #f8fafc; font-family: 'Inter', sans-serif; }
        .hero-banner { width: 100%; height: 350px; background: #64748b; background-image: url('${empty event.eventImageUrl ? "https://images.unsplash.com/photo-1552664730-d307ca884978?auto=format&fit=crop&q=80" : event.eventImageUrl}'); background-size: cover; background-position: center; position: relative; }
        .hero-banner::after { content: ''; position: absolute; inset: 0; background: linear-gradient(to top, rgba(15,23,42,0.9), transparent); }
        .detail-wrapper { max-width: 1000px; margin: -100px auto 40px; position: relative; z-index: 10; display: grid; grid-template-columns: 2fr 1fr; gap: 30px; padding: 0 20px; }
        .main-card { background: white; border-radius: 16px; padding: 40px; box-shadow: 0 10px 30px rgba(0,0,0,0.05); }
        .side-card { background: white; border-radius: 16px; padding: 30px; box-shadow: 0 10px 30px rgba(0,0,0,0.05); height: fit-content; position: sticky; top: 100px; }
        .event-title { font-size: 32px; font-weight: 800; color: #0f172a; margin-bottom: 10px; }
        .org-name { font-size: 16px; color: #64748b; font-weight: 500; display: flex; align-items: center; gap: 8px; margin-bottom: 30px; }
        .org-name i { color: #667eea; }
        .description-content { font-size: 16px; color: #475569; line-height: 1.8; margin-top: 20px; white-space: pre-wrap; }

        .info-list { list-style: none; padding: 0; margin: 0 0 30px 0; }
        .info-list li { padding: 15px 0; border-bottom: 1px solid #f1f5f9; display: flex; flex-direction: column; gap: 5px; }
        .info-label { font-size: 13px; color: #94a3b8; font-weight: 600; text-transform: uppercase; }
        .info-val { font-size: 16px; color: #1e293b; font-weight: 500; }

        .progress-bar { width: 100%; height: 10px; background: #e2e8f0; border-radius: 10px; margin: 10px 0; overflow: hidden; }
        .progress-fill { height: 100%; background: linear-gradient(90deg, #667eea, #764ba2); border-radius: 10px; }

        .btn-full { display: block; width: 100%; padding: 14px; border-radius: 10px; text-align: center; font-weight: 600; font-size: 16px; cursor: pointer; border: none; transition: 0.2s; text-decoration: none; }
        .btn-apply { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; }
        .btn-apply:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(102,126,234,0.3); }
        .btn-cancel { background: #fff1f2; color: #e11d48; border: 1px solid #fecdd3; }
        .btn-cancel:hover { background: #e11d48; color: white; }
        .btn-disabled { background: #f1f5f9; color: #94a3b8; cursor: not-allowed; }

        .status-badge { display: inline-block; padding: 10px 15px; border-radius: 8px; font-weight: 600; width: 100%; text-align: center; margin-bottom: 15px; }
        .status-pending { background: #fef9c3; color: #854d0e; border: 1px solid #fde047; }
        .status-approved { background: #dcfce7; color: #166534; border: 1px solid #86efac; }

        .alert { padding: 15px; border-radius: 8px; margin-bottom: 20px; font-weight: 500; }
        .alert-success { background: #dcfce7; color: #166534; }
    </style>
</head>
<body>
    <jsp:include page="/components/header.jsp"/>

    <div class="hero-banner"></div>

    <div class="detail-wrapper">

        <div class="main-card">
            <h1 class="event-title">${event.eventName}</h1>
            <div class="org-name">🏢 Organized by <strong>${event.organizationName}</strong></div>

            <c:if test="${param.success == 'applied'}">
                <div class="alert alert-success">🎉 Registration successful! Please wait for the organization's approval.</div>
            </c:if>
            <c:if test="${param.success == 'cancelled'}">
                <div class="alert" style="background: #f1f5f9; color: #475569;">Your registration has been cancelled.</div>
            </c:if>

            <h3 style="margin-top: 30px; font-size: 20px; color: #0f172a;">About this Event</h3>
            <div class="description-content"><c:out value="${event.description}" /></div>

            <c:if test="${enrollStatus == 'Approved'}">
                <div style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 25px 30px; border-radius: 16px; color: white; display: flex; justify-content: space-between; align-items: center; margin-top: 40px; box-shadow: 0 10px 30px rgba(102, 126, 234, 0.3);">
                    <div>
                        <h3 style="margin: 0 0 8px 0; font-size: 22px; font-weight: 800;">🎉 Welcome to the Team!</h3>
                        <p style="margin: 0; font-size: 15px; opacity: 0.9;">You have assigned tasks waiting in your workspace.</p>
                    </div>
                    <a href="${pageContext.request.contextPath}/volunteer/workspace?eventId=${event.eventId}"
                       style="background: white; color: #667eea; padding: 12px 24px; border-radius: 10px; font-weight: 700; text-decoration: none; transition: 0.2s; box-shadow: 0 4px 15px rgba(0,0,0,0.1); white-space: nowrap;">
                        ➡️ Enter Workspace
                    </a>
                </div>
            </c:if>

            <div style="margin-top: 50px; padding-top: 30px; border-top: 2px solid #f1f5f9;">
                <h3 style="font-size: 20px; color: #0f172a; margin-bottom: 20px;">💬 Comments & Ratings</h3>

                <c:if test="${not empty avgRating}">
                    <div style="background: #fef9c3; padding: 15px; border-radius: 10px; margin-bottom: 20px; display: flex; align-items: center; gap: 10px;">
                        <span style="font-size: 24px; font-weight: 700; color: #854d0e;"><fmt:formatNumber value="${avgRating}" maxFractionDigits="1"/> ⭐</span>
                        <span style="color: #854d0e; font-weight: 500;">Average Rating</span>
                    </div>
                </c:if>

                <c:if test="${canComment}">
                    <form method="post" action="${pageContext.request.contextPath}/event/detail" style="background: #f8fafc; padding: 20px; border-radius: 10px; margin-bottom: 30px;">
                        <input type="hidden" name="eventId" value="${event.eventId}">
                        <input type="hidden" name="action" value="comment">
                        <div style="margin-bottom: 15px;">
                            <label style="display: block; margin-bottom: 8px; font-weight: 600; color: #475569;">Your Rating:</label>
                            <div id="starRating" style="display: flex; gap: 5px;">
                                <input type="radio" name="rating" value="1" id="r1" required style="display: none;">
                                <label for="r1" onclick="setRating(1)" class="star-label" style="font-size: 28px; cursor: pointer; filter: grayscale(1);">⭐</label>
                                <input type="radio" name="rating" value="2" id="r2" style="display: none;">
                                <label for="r2" onclick="setRating(2)" class="star-label" style="font-size: 28px; cursor: pointer; filter: grayscale(1);">⭐</label>
                                <input type="radio" name="rating" value="3" id="r3" style="display: none;">
                                <label for="r3" onclick="setRating(3)" class="star-label" style="font-size: 28px; cursor: pointer; filter: grayscale(1);">⭐</label>
                                <input type="radio" name="rating" value="4" id="r4" style="display: none;">
                                <label for="r4" onclick="setRating(4)" class="star-label" style="font-size: 28px; cursor: pointer; filter: grayscale(1);">⭐</label>
                                <input type="radio" name="rating" value="5" id="r5" style="display: none;">
                                <label for="r5" onclick="setRating(5)" class="star-label" style="font-size: 28px; cursor: pointer; filter: grayscale(1);">⭐</label>
                            </div>
                        </div>
                        <div style="margin-bottom: 15px;">
                            <label style="display: block; margin-bottom: 8px; font-weight: 600; color: #475569;">Your Comment:</label>
                            <textarea name="comment" required style="width: 100%; min-height: 80px; padding: 12px; border: 2px solid #e2e8f0; border-radius: 8px; font-family: inherit; resize: vertical;" placeholder="Share your experience..."></textarea>
                        </div>
                        <button type="submit" style="padding: 10px 20px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; border: none; border-radius: 8px; font-weight: 600; cursor: pointer;">Submit Comment</button>
                    </form>
                </c:if>

                <div style="background: #f8fafc; padding: 15px; border-radius: 10px; margin-bottom: 20px; display: flex; gap: 15px; flex-wrap: wrap;">
                    <div>
                        <label style="font-size: 13px; color: #64748b; font-weight: 600; display: block; margin-bottom: 5px;">Filter by Rating:</label>
                        <select onchange="applyFilter()" id="ratingFilter" style="padding: 8px 12px; border: 2px solid #e2e8f0; border-radius: 8px; font-weight: 500; cursor: pointer;">
                            <option value="">All Ratings</option>
                            <option value="5" ${ratingFilter == 5 ? 'selected' : ''}>⭐⭐⭐⭐⭐ (5 stars)</option>
                            <option value="4" ${ratingFilter == 4 ? 'selected' : ''}>⭐⭐⭐⭐ (4 stars)</option>
                            <option value="3" ${ratingFilter == 3 ? 'selected' : ''}>⭐⭐⭐ (3 stars)</option>
                            <option value="2" ${ratingFilter == 2 ? 'selected' : ''}>⭐⭐ (2 stars)</option>
                            <option value="1" ${ratingFilter == 1 ? 'selected' : ''}>⭐ (1 star)</option>
                        </select>
                    </div>
                    <div>
                        <label style="font-size: 13px; color: #64748b; font-weight: 600; display: block; margin-bottom: 5px;">Sort by:</label>
                        <select onchange="applyFilter()" id="sortOrder" style="padding: 8px 12px; border: 2px solid #e2e8f0; border-radius: 8px; font-weight: 500; cursor: pointer;">
                            <option value="newest" ${sortOrder == 'newest' ? 'selected' : ''}>Newest First</option>
                            <option value="oldest" ${sortOrder == 'oldest' ? 'selected' : ''}>Oldest First</option>
                        </select>
                    </div>
                </div>

                <div>
                    <c:forEach items="${comments}" var="c">
                        <div style="background: white; padding: 20px; border: 1px solid #e2e8f0; border-radius: 10px; margin-bottom: 15px;">
                            <div style="display: flex; justify-content: space-between; align-items: start; margin-bottom: 10px;">
                                <div>
                                    <strong style="color: #0f172a;">${c.userName}</strong>
                                    <div style="color: #f59e0b; margin-top: 5px;">
                                        <c:forEach begin="1" end="${c.rating}">⭐</c:forEach>
                                    </div>
                                </div>
                                <span style="font-size: 13px; color: #94a3b8;">
                                    <fmt:formatDate value="${c.createdAt}" pattern="dd MMM yyyy" />
                                </span>
                            </div>
                            <p style="color: #475569; line-height: 1.6; margin: 0;">${c.comment}</p>
                        </div>
                    </c:forEach>
                    <c:if test="${empty comments}">
                        <p style="text-align: center; color: #94a3b8; padding: 30px;">No comments yet. Be the first to share your experience!</p>
                    </c:if>
                </div>
            </div>

        </div> <div class="side-card">
            <ul class="info-list">
                <li>
                    <span class="info-label">Location</span>
                    <span class="info-val">📍 ${event.location}</span>
                </li>
                <li>
                    <span class="info-label">Start Date</span>
                    <span class="info-val">📅 <fmt:parseDate value="${event.startDate}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedStartDate" type="both" /><fmt:formatDate pattern="dd MMM, yyyy" value="${parsedStartDate}" /></span>
                </li>
                <li>
                    <span class="info-label">End Date</span>
                    <span class="info-val">🏁 <fmt:parseDate value="${event.endDate}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedEndDate" type="both" /><fmt:formatDate pattern="dd MMM, yyyy" value="${parsedEndDate}" /></span>
                </li>
                <li>
                    <span class="info-label">Volunteers Needed</span>
                    <c:set var="percent" value="${(event.currentVolunteers / event.maxVolunteers) * 100}" />
                    <span class="info-val">👥 ${event.currentVolunteers} / ${event.maxVolunteers} Joined</span>
                    <div class="progress-bar"><div class="progress-fill" style="width: ${percent > 100 ? 100 : percent}%;"></div></div>
                </li>
            </ul>

            <c:choose>
                <c:when test="${empty sessionScope.userId}">
                    <a href="${pageContext.request.contextPath}/login" class="btn-full btn-apply">Log in to Apply</a>
                </c:when>

                <c:when test="${sessionScope.userRole != 'Volunteer'}">
                    <button class="btn-full btn-disabled" disabled>Only Volunteers can apply</button>
                </c:when>

                <c:otherwise>
                    <c:choose>
                        <c:when test="${enrollStatus == 'Pending'}">
                            <div class="status-badge status-pending">⏳ Waiting for Approval</div>
                            <form method="post" action="${pageContext.request.contextPath}/event/detail">
                                <input type="hidden" name="eventId" value="${event.eventId}">
                                <button type="submit" name="action" value="cancel" class="btn-full btn-cancel" onclick="return confirm('Are you sure you want to cancel your application?');">Cancel Request</button>
                            </form>
                        </c:when>

                        <c:when test="${enrollStatus == 'Approved'}">
                            <div class="status-badge status-approved">✅ Application Approved</div>
                            <form method="post" action="${pageContext.request.contextPath}/event/detail">
                                <input type="hidden" name="eventId" value="${event.eventId}">
                                <button type="submit" name="action" value="cancel" class="btn-full btn-cancel" onclick="return confirm('Are you sure you want to withdraw from this event?');">Withdraw Participation</button>
                            </form>
                        </c:when>

                        <c:when test="${enrollStatus == 'Rejected'}">
                            <div class="alert" style="background: #fef2f2; color: #991b1b; border: 1px solid #fecaca; margin-bottom: 15px;">
                                <strong>❌ Application Rejected</strong>
                                <c:if test="${not empty rejectReason}">
                                    <p style="margin: 8px 0 0 0; font-size: 14px;">Reason: ${rejectReason}</p>
                                </c:if>
                            </div>
                            <form method="post" action="${pageContext.request.contextPath}/event/detail">
                                <input type="hidden" name="eventId" value="${event.eventId}">
                                <button type="submit" name="action" value="apply" class="btn-full btn-apply">Apply Again</button>
                            </form>
                        </c:when>

                        <c:otherwise>
                            <c:choose>
                                <c:when test="${event.currentVolunteers >= event.maxVolunteers}">
                                    <button class="btn-full btn-disabled" disabled>Event is Full</button>
                                </c:when>
                                <c:otherwise>
                                    <form method="post" action="${pageContext.request.contextPath}/event/detail">
                                        <input type="hidden" name="eventId" value="${event.eventId}">
                                        <button type="submit" name="action" value="apply" class="btn-full btn-apply">Apply Now</button>
                                    </form>
                                </c:otherwise>
                            </c:choose>
                        </c:otherwise>
                    </c:choose>
                </c:otherwise>
            </c:choose>

        </div>
    </div> <jsp:include page="/components/footer.jsp"/>
    
    <script>
    function setRating(rating) {
        document.querySelectorAll('.star-label').forEach((label, index) => {
            if (index < rating) {
                label.style.filter = 'grayscale(0)';
            } else {
                label.style.filter = 'grayscale(1)';
            }
        });
    }
    
    function applyFilter() {
        const ratingFilter = document.getElementById('ratingFilter').value;
        const sortOrder = document.getElementById('sortOrder').value;
        const eventId = ${event.eventId};
        
        let url = '${pageContext.request.contextPath}/event/detail?id=' + eventId;
        if (ratingFilter) url += '&ratingFilter=' + ratingFilter;
        if (sortOrder) url += '&sortOrder=' + sortOrder;
        
        window.location.href = url;
    }
    </script>
</body>
</html>