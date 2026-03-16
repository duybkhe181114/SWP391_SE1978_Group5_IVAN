<%@ page contentType="text/html;charset=UTF-8" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
<header class="header">
  <div class="header-inner">
    <a href="${pageContext.request.contextPath}/home" class="logo" style="text-decoration: none;">IVAN</a>

    <nav class="nav">
      <a href="${pageContext.request.contextPath}/home">Home</a>
      <a href="${pageContext.request.contextPath}/events">Events</a>

      <%
      String role = (String) session.getAttribute("userRole");
      Integer userId = (Integer) session.getAttribute("userId");

      if ("Volunteer".equalsIgnoreCase(role) || "Coordinator".equalsIgnoreCase(role)) {
          boolean isCoordinator = false;
          if (userId != null) {
              DAO.EventCoordinatorDAO coordDAO = new DAO.EventCoordinatorDAO();
              java.util.List<Integer> managedEvents = coordDAO.getCoordinatedEventIds(userId);
              isCoordinator = managedEvents != null && !managedEvents.isEmpty();
          }
      %>
          <% if ("Volunteer".equalsIgnoreCase(role)) { %>
              <a href="${pageContext.request.contextPath}/volunteer/my-schedule">My Schedule</a>
          <% } %>

          <% if ("Coordinator".equalsIgnoreCase(role) || isCoordinator) { %>
              <a href="${pageContext.request.contextPath}/coordinator/portal" style="color: #8b5cf6; font-weight: 700;">Coordinator Portal</a>
          <% } %>
      <%
      } else {
      %>
          <a href="#">About</a>
      <%
      }
      %>

      <% String userRole = (String) session.getAttribute("userRole"); if (userRole != null) { %>
        <div class="user-menu">
          <div class="user-btn" style="white-space: nowrap; height: 42px; display: flex; align-items: center;">
            <span style="font-weight: 600;">Hi, ${not empty sessionScope.userName ? sessionScope.userName : 'User'}</span>
            <span style="font-size: 11px; margin-left: 6px;">&#9662;</span>
          </div>
          <div class="dropdown-menu">
            <div class="dropdown-content">
              <% if ("Organization".equalsIgnoreCase(userRole)) { %>
                <a href="${pageContext.request.contextPath}/organization/dashboard">Dashboard</a>
                <a href="${pageContext.request.contextPath}/organization/create-event">Create Event</a>
                <a href="${pageContext.request.contextPath}/org/support-requests">Support Requests</a>
              <% } else if ("Admin".equalsIgnoreCase(userRole)) { %>
                <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
                <a href="${pageContext.request.contextPath}/admin/manage-events">Manage Events</a>
                <a href="${pageContext.request.contextPath}/admin/review-events">Event Review Queue</a>
                <a href="${pageContext.request.contextPath}/admin/manage-users">Manage Users</a>
                <a href="${pageContext.request.contextPath}/admin/manage-organizations">Manage Organizations</a>
                <a href="${pageContext.request.contextPath}/admin/review-organizations">Review Queue</a>
                <a href="${pageContext.request.contextPath}/admin/review-profiles">Review Profiles</a>
                <a href="${pageContext.request.contextPath}/viewSpRequestAdmin">Support Requests</a>
              <% } else if ("Coordinator".equalsIgnoreCase(userRole)) { %>
                <a href="${pageContext.request.contextPath}/coordinator/portal">Dashboard</a>
                <a href="${pageContext.request.contextPath}/events">Events</a>
              <% } else { %>
                <a href="${pageContext.request.contextPath}/volunteer/dashboard">Dashboard</a>
                <a href="${pageContext.request.contextPath}/volunteer/dashboard#workspaces">My Workspaces</a>
                <a href="${pageContext.request.contextPath}/viewSpRequestUser">My Requests</a>
              <% } %>

              <% if ("Organization".equalsIgnoreCase(userRole)) { %>
                <a href="${pageContext.request.contextPath}/organization/profile">My Profile</a>
              <% } else { %>
                <a href="${pageContext.request.contextPath}/profile">My Profile</a>
              <% } %>
              <hr style="border: 0; border-top: 1px solid #eee; margin: 5px 0;">
              <a href="${pageContext.request.contextPath}/logout" style="color: #e53e3e;">Logout</a>
            </div>
          </div>
        </div>
      <% } else { %>
        <a href="${pageContext.request.contextPath}/login" class="btn-login">Login</a>
      <% } %>
    </nav>
  </div>
</header>
