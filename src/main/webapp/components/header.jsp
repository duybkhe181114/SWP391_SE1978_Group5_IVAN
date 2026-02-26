<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
<header class="header">
  <div class="header-inner">
    <a href="${pageContext.request.contextPath}/home" class="logo" style="text-decoration: none;">IVAN</a>

    <nav class="nav">
      <a href="${pageContext.request.contextPath}/home">Home</a>
      <a href="#">Events</a>
      <a href="#">About</a>

      <%
        String userRole = (String) session.getAttribute("userRole");
        if (userRole != null) {
      %>
      <div class="user-menu">
        <div class="user-btn">
        <div class="user-menu">
<div class="user-btn" style="white-space: nowrap; height: 42px; display: flex; align-items: center;">
          <span style="font-weight: 600;">Hi, ${not empty sessionScope.userName ? sessionScope.userName : 'User'}</span>
          <span style="font-size: 11px; margin-left: 6px;">&#9662;</span>
        </div>
        </div>
        <div class="dropdown-menu">
          <div class="dropdown-content">
            <% if ("Organization".equals(userRole)) { %>
            <a href="${pageContext.request.contextPath}/organization/dashboard">Dashboard</a>
            <a href="${pageContext.request.contextPath}/organization/create-event">Create Event</a>
            <% } else if ("Admin".equals(userRole)) { %>
            <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
            <a href="${pageContext.request.contextPath}/admin/manage-events">Manage Events</a>
            <a href="${pageContext.request.contextPath}/admin/manage-users">Manage Users</a>
            <% } else { %>
            <a href="${pageContext.request.contextPath}/volunteer/dashboard">Dashboard</a>
            <% } %>

            <a href="${pageContext.request.contextPath}/profile">My Profile</a>

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