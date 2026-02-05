<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
<header class="header">
  <div class="header-inner">
    <div class="logo">IVAN</div>

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
          <span>Dashboard</span>
          <span style="font-size: 10px; margin-left: 5px;">&#9662;</span>
        </div>
        <div class="dropdown-menu">
          <div class="dropdown-content"> <% if ("Organization".equals(userRole)) { %>
            <a href="${pageContext.request.contextPath}/organization/dashboard">Dashboard</a>
            <a href="${pageContext.request.contextPath}/organization/create-event">Create Event</a>
            <% } else if ("Admin".equals(userRole)) { %>
            <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
            <a href="${pageContext.request.contextPath}/admin/manage-events">Manage Events</a>
            <a href="${pageContext.request.contextPath}/admin/manage-users">Manage Users</a>
            <% } else { %>
            <a href="${pageContext.request.contextPath}/volunteer/dashboard">Dashboard</a>
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
