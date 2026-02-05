<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<section id="events" class="section container">
  <h2 class="section-title">Upcoming Events</h2>

  <div class="event-grid">
    <c:forEach items="${events}" var="e">
      <div class="event-card">

        <!-- EVENT IMAGE -->
        <img
                class="event-image"
                src="${pageContext.request.contextPath}${empty e.eventImageUrl
                ? '/assets/images/events/default.png'
                : e.eventImageUrl}"
                alt="${e.eventName}"
        />

        <div class="event-info">
          <h3>${e.eventName}</h3>

          <p class="org">${e.organizationName}</p>
          <p class="location">${e.location}</p>

          <p class="date">
            <fmt:formatDate value="${e.startDateAsDate}" pattern="dd/MM/yyyy"/>
            –
            <fmt:formatDate value="${e.endDateAsDate}" pattern="dd/MM/yyyy"/>
          </p>

          <form method="post"
                action="${pageContext.request.contextPath}/volunteer/register">
            <input type="hidden" name="eventId" value="${e.eventId}">
            <button type="submit" class="btn btn-primary">
              Register
            </button>
          </form>
        </div>

      </div>
    </c:forEach>
  </div>
</section>
