<section id="events" class="section container">
  <h2 class="section-title">Upcoming Events</h2>

  <div class="event-grid">
    <c:forEach items="${events}" var="e">
      <div class="event-card">
        <img src="${e.organizationLogoUrl}" alt="logo">

        <div class="event-info">
          <h3>${e.eventName}</h3>
          <p class="org">${e.organizationName}</p>
          <p>${e.location}</p>
          <p class="date">
              ${e.startDate} – ${e.endDate}
          </p>

          <form method="post" action="${pageContext.request.contextPath}/volunteer/register">
            <input type="hidden" name="eventId" value="${e.eventId}">
            <button type="submit" class="btn btn-primary">Register</button>
          </form>
        </div>
      </div>
    </c:forEach>
  </div>
</section>
