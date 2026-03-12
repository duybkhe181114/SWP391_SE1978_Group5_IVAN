<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<section id="events" class="section container">
  <h2 class="section-title">Upcoming Events</h2>

<div class="event-grid">
    <c:forEach items="${events}" var="e">

      <div class="event-card" style="border-radius: 12px; overflow: hidden; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1); background: white; display: flex; flex-direction: column; height: 100%;">

        <img
                class="event-image"
                src="${pageContext.request.contextPath}${empty e.eventImageUrl
                ? '/assets/images/events/default.png'
                : e.eventImageUrl}"
                alt="${e.eventName}"
                style="width: 100%; height: 200px; object-fit: cover; display: block;"
        />

        <div class="event-info" style="padding: 20px; display: flex; flex-direction: column; flex-grow: 1;">
          <h3 style="margin-top: 0; margin-bottom: 12px; font-size: 18px; color: #0f172a;">${e.eventName}</h3>

          <p class="org" style="color: #64748b; font-size: 14px; margin: 0 0 8px 0;">
             🏢 ${e.organizationName}
          </p>
          <p class="location" style="color: #64748b; font-size: 14px; margin: 0 0 8px 0;">
             📍 ${e.location}
          </p>

          <p class="date" style="color: #64748b; font-size: 14px; margin: 0 0 20px 0;">
             📅 <fmt:formatDate value="${e.startDateAsDate}" pattern="dd/MM/yyyy"/>
            –
            <fmt:formatDate value="${e.endDateAsDate}" pattern="dd/MM/yyyy"/>
          </p>

          <div style="margin-top: auto;">
            <c:choose>
                <c:when test="${not empty coordinatedEventIds and coordinatedEventIds.contains(e.eventId)}">
                    <a href="${pageContext.request.contextPath}/event/detail?id=${e.eventId}"
                    style="display: block; width: 100%; text-align: center; background: #8b5cf6; color: white; padding: 10px; border-radius: 8px; font-weight: 700; text-decoration: none;">
                    👑 Manage Event
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/event/detail?id=${e.eventId}"
               style="display: block; width: 100%; text-align: center; background: #667eea; color: white; padding: 10px; border-radius: 8px; font-weight: 600; text-decoration: none;">
                View Details
                    </a>
                </c:otherwise>
            </c:choose>
          </div>

        </div>

      </div>

    </c:forEach>
  </div>
</section>