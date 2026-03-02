<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="/components/header.jsp"/>

<style>
    /* Fix Filter Bar: Dàn hàng ngang chuyên nghiệp */
    .filter-section {
        background: white;
        padding: 30px;
        border-radius: 16px;
        box-shadow: 0 4px 20px rgba(0,0,0,0.05);
        margin-bottom: 40px;
        display: flex;
        flex-wrap: wrap;
        gap: 20px;
        align-items: flex-end;
    }
    .filter-group { flex: 1; min-width: 200px; }
    .filter-group label { display: block; font-size: 11px; font-weight: 800; color: #94a3b8; text-transform: uppercase; margin-bottom: 8px; letter-spacing: 1px; }
    .filter-group input, .filter-group select { width: 100%; padding: 12px; border: 1px solid #e2e8f0; border-radius: 10px; font-size: 14px; transition: 0.3s; }
    .filter-group input:focus { border-color: #667eea; outline: none; box-shadow: 0 0 0 3px rgba(102,126,234,0.1); }

    /* Rich Event Card: Đầy đủ thông tin */
    .rich-card { background: white; border-radius: 16px; overflow: hidden; display: flex; flex-direction: column; height: 100%; transition: 0.3s; border: 1px solid #f1f5f9; }
    .rich-card:hover { transform: translateY(-8px); box-shadow: 0 20px 25px -5px rgba(0,0,0,0.1); }
    .card-tag { position: absolute; top: 15px; right: 15px; background: rgba(255,255,255,0.9); padding: 4px 12px; border-radius: 20px; font-size: 11px; font-weight: 700; color: #667eea; z-index: 5; }

    .desc-snippet { font-size: 14px; color: #64748b; line-height: 1.5; margin-bottom: 20px; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
    .slot-info { display: flex; justify-content: space-between; align-items: center; padding-top: 15px; border-top: 1px solid #f1f5f9; margin-top: auto; }
</style>

<div class="admin-page" style="background: #f8fafc; min-height: 100vh; padding: 40px 0;">
    <div class="admin-container">

        <form action="events" method="get" class="filter-section">
            <div class="filter-group">
                <label>Keyword</label>
                <input type="text" name="search" value="${param.search}" placeholder="Search events...">
            </div>
            <div class="filter-group">
                <label>Location</label>
                <select name="location">
                    <option value="">All Locations</option>
                    <c:forEach items="${locations}" var="loc">
                        <option value="${loc}" ${param.location == loc ? 'selected' : ''}>${loc}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="filter-group">
                <label>Sort By</label>
                <select name="sortBy">
                    <option value="upcoming" ${param.sortBy == 'upcoming' ? 'selected' : ''}>Upcoming First</option>
                    <option value="newest" ${param.sortBy == 'newest' ? 'selected' : ''}>Newest Added</option>
                </select>
            </div>
            <button type="submit" class="btn-primary" style="padding: 14px 30px; border-radius: 10px; min-width: 120px;">Apply Filter</button>
        </form>

        <h2 class="section-title" style="margin-bottom: 30px;">
            <span style="color: #667eea;">●</span> Discover Opportunities
        </h2>

        <div class="event-grid" style="display: grid; grid-template-columns: repeat(auto-fill, minmax(340px, 1fr)); gap: 30px;">
<c:forEach items="${events}" var="e">
                <div class="rich-card" style="${e.isExpired ? 'opacity: 0.65; filter: grayscale(40%);' : ''}">
                    <div style="position: relative; height: 210px; overflow: hidden;">

                        <span class="card-tag" style="${e.isExpired || e.isFull ? 'color: #ef4444; background: #fee2e2;' : ''}">
                            <c:choose>
                                <c:when test="${e.isExpired}">⏳ Ended</c:when>
                                <c:when test="${e.isFull}">🚫 Full Slots</c:when>
                                <c:otherwise>🔥 ${e.maxVolunteers == 0 ? 'Unlimited' : e.maxVolunteers} Slots</c:otherwise>
                            </c:choose>
                        </span>

                        <img src="${pageContext.request.contextPath}${empty e.eventImageUrl ? '/assets/images/events/default.png' : e.eventImageUrl}"
                             style="width: 100%; height: 100%; object-fit: cover;">
                    </div>

                    <div style="padding: 24px; display: flex; flex-direction: column; flex-grow: 1;">
                        <h3 style="font-size: 20px; color: #0f172a; margin: 0 0 10px 0; font-weight: 700;">${e.eventName}</h3>

                        <div style="display: flex; flex-direction: column; gap: 8px; margin-bottom: 15px;">
                            <span style="font-size: 13px; color: #64748b;">🏢 ${e.organizationName}</span>
                            <span style="font-size: 13px; color: #64748b;">📍 ${e.location}</span>
                            <span style="font-size: 13px; color: ${e.isExpired ? '#ef4444' : '#667eea'}; font-weight: 600;">
                                📅 <fmt:formatDate value="${e.startDateAsDate}" pattern="dd MMM, yyyy"/>
                            </span>
                        </div>

                        <p class="desc-snippet">${e.description}</p>

                        <div class="slot-info">
                            <a href="event/detail?id=${e.eventId}" class="btn-primary"
                               style="padding: 10px 20px; border-radius: 8px; text-decoration: none; font-size: 14px; ${e.isExpired ? 'background: #94a3b8; border-color: #94a3b8;' : ''}">
                                View Details
                            </a>
                            <span style="font-size: 12px; font-weight: 700; text-transform: uppercase; ${e.isExpired || e.isFull ? 'color: #ef4444;' : 'color: #10b981;'}">
                                <c:choose>
                                    <c:when test="${e.isExpired}">Expired</c:when>
                                    <c:when test="${e.isFull}">Registration Closed</c:when>
                                    <c:otherwise>Active Project</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>

        <div style="display: flex; justify-content: center; gap: 8px; margin-top: 50px;">
            <c:if test="${currentPage > 1}">
                <a href="events?page=${currentPage - 1}&search=${param.search}&location=${param.location}&sortBy=${param.sortBy}"
                   class="page-link" style="padding: 12px 20px;">← Previous</a>
            </c:if>

            <span class="page-link active" style="padding: 12px 20px; background: #667eea; color: white;">${currentPage}</span>

            <a href="events?page=${currentPage + 1}&search=${param.search}&location=${param.location}&sortBy=${param.sortBy}"
               class="page-link" style="padding: 12px 20px;">Next Page →</a>
        </div>
    </div>
</div>