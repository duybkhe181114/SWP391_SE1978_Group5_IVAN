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

          <a href="login" class="btn btn-primary">Register</a>
        </div>
      </div>
    </c:forEach>
  </div>
</section>
