<%@ page contentType="text/html;charset=UTF-8" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">

<style>
  /* ====== CHUẨN HOÁ HEADER SANG TRỌNG ====== */
  .custom-header { background: white; box-shadow: 0 2px 15px rgba(0,0,0,0.05); position: sticky; top: 0; z-index: 9999; border-bottom: 1px solid #f1f5f9; font-family: 'Inter', sans-serif; }
  .custom-header .header-inner { display: flex; justify-content: space-between; align-items: center; max-width: 1400px; margin: 0 auto; padding: 0 20px; height: 70px; }
  .custom-header .logo { font-size: 24px; font-weight: 900; color: #4f46e5; text-decoration: none; letter-spacing: 1px; }

  .custom-nav { display: flex; align-items: center; gap: 25px; }
  .custom-nav > a { color: #475569; text-decoration: none; font-weight: 600; font-size: 15px; transition: 0.2s; padding: 8px 12px; border-radius: 8px; }
  .custom-nav > a:hover { color: #4f46e5; background: #f8fafc; }
  .custom-nav > a.highlight-nav { color: #8b5cf6; background: #f5f3ff; }
  .custom-nav > a.highlight-nav:hover { background: #ede9fe; }

  /* ====== DROPDOWN ĐỘC QUYỀN (TRÁNH XUNG ĐỘT BASE.CSS) ====== */
  .hd-wrapper { position: relative; }
  .hd-btn { display: flex; align-items: center; gap: 8px; cursor: pointer; padding: 8px 16px; background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 30px; font-weight: 600; color: #0f172a; transition: 0.2s; user-select: none; }
  .hd-btn:hover, .hd-btn.active { background: #f1f5f9; border-color: #cbd5e1; box-shadow: 0 2px 5px rgba(0,0,0,0.02); }
  .hd-btn .avatar { width: 28px; height: 28px; background: #c7d2fe; color: #4f46e5; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 14px; }

  /* Chặn display:none của base.css bằng display:block !important */
  .hd-menu { visibility: hidden; opacity: 0; position: absolute; right: 0; top: 120%; background: white; min-width: 260px; box-shadow: 0 10px 40px rgba(0,0,0,0.15); border-radius: 16px; border: 1px solid #e2e8f0; padding: 10px 0; transition: all 0.2s ease; transform: translateY(10px); z-index: 10000; display: block !important; }

  /* Class dùng để kích hoạt bằng Javascript */
  .hd-menu.show-menu { visibility: visible !important; opacity: 1 !important; transform: translateY(0) !important; }

  .dd-category { font-size: 11px; font-weight: 800; color: #94a3b8; text-transform: uppercase; letter-spacing: 0.5px; padding: 12px 20px 4px 20px; }
  .dd-item { display: flex; align-items: center; gap: 12px; padding: 10px 20px; color: #475569; text-decoration: none; font-size: 14px; font-weight: 500; transition: 0.2s; }
  .dd-item:hover { background: #f8fafc; color: #4f46e5; }
  .dd-divider { height: 1px; background: #f1f5f9; margin: 8px 0; }
  .dd-item-danger { color: #e11d48; }
  .dd-item-danger:hover { background: #fff1f2; color: #be123c; }
</style>

<header class="custom-header">
  <div class="header-inner">
    <a href="${pageContext.request.contextPath}/home" class="logo">IVAN</a>

    <nav class="custom-nav">
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
              <a href="${pageContext.request.contextPath}/coordinator/portal" class="highlight-nav">👑 Coordinator Portal</a>
          <% } %>
      <%
      } else {
      %>
          <a href="#">About</a>
      <%
      }
      %>

      <% String userRole = (String) session.getAttribute("userRole"); if (userRole != null) { %>
        <div class="hd-wrapper">
          <div class="hd-btn" id="headerDropBtn" onclick="toggleHeaderMenu(event)">
            <div class="avatar">👤</div>
            <span>${not empty sessionScope.userName ? sessionScope.userName : 'User'}</span>
            <span style="font-size: 10px; margin-left: 2px;">▼</span>
          </div>

          <div class="hd-menu" id="headerDropContent">

            <% if ("Organization".equalsIgnoreCase(userRole)) { %>
                <div class="dd-category">Workspace</div>
                <a href="${pageContext.request.contextPath}/organization/dashboard" class="dd-item">📊 Dashboard</a>
                <a href="${pageContext.request.contextPath}/organization/create-event" class="dd-item">➕ Create Event</a>

                <div class="dd-category">Support</div>
                <a href="${pageContext.request.contextPath}/viewSpRequestAdmin" class="dd-item">💬 Support Requests</a>

            <% } else if ("Admin".equalsIgnoreCase(userRole)) { %>
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="dd-item">📊 System Dashboard</a>

                <div class="dd-category">Events Management</div>
                <a href="${pageContext.request.contextPath}/admin/manage-events" class="dd-item">📅 Manage Events</a>
                <a href="${pageContext.request.contextPath}/admin/review-events" class="dd-item">⏱️ Event Review Queue</a>
                <a href="${pageContext.request.contextPath}/admin/event-reports" class="dd-item">📈 Event Reports</a>

                <div class="dd-category">Users & Organizations</div>
                <a href="${pageContext.request.contextPath}/admin/manage-users" class="dd-item">👥 Manage Users</a>
                <a href="${pageContext.request.contextPath}/admin/manage-organizations" class="dd-item">🏢 Manage Organizations</a>
                <a href="${pageContext.request.contextPath}/admin/review-organizations" class="dd-item">📑 Org Review Queue</a>
                <a href="${pageContext.request.contextPath}/admin/review-profiles" class="dd-item">👤 Profile Review Queue</a>

                <div class="dd-category">System</div>
                <a href="${pageContext.request.contextPath}/viewSpRequestAdmin" class="dd-item">💬 Support Requests</a>

            <% } else if ("Coordinator".equalsIgnoreCase(userRole)) { %>
                <div class="dd-category">Management</div>
                <a href="${pageContext.request.contextPath}/coordinator/portal" class="dd-item">👑 Dashboard</a>
                <a href="${pageContext.request.contextPath}/events" class="dd-item">📅 Browse Events</a>

            <% } else { %>
                <div class="dd-category">My Activities</div>
                <a href="${pageContext.request.contextPath}/volunteer/dashboard" class="dd-item">📊 Dashboard</a>
                <a href="${pageContext.request.contextPath}/volunteer/dashboard#workspaces" class="dd-item">🚀 My Workspaces</a>
                <a href="${pageContext.request.contextPath}/viewSpRequestUser" class="dd-item">💬 My Requests</a>
            <% } %>

            <div class="dd-divider"></div>

            <div class="dd-category">Account</div>
            <% if ("Organization".equalsIgnoreCase(userRole)) { %>
                <a href="${pageContext.request.contextPath}/organization/profile" class="dd-item">⚙️ Settings & Profile</a>
            <% } else { %>
                <a href="${pageContext.request.contextPath}/profile" class="dd-item">⚙️ Settings & Profile</a>
            <% } %>

            <a href="${pageContext.request.contextPath}/logout" class="dd-item dd-item-danger">🚪 Logout</a>
          </div>
        </div>
      <% } else { %>
        <a href="${pageContext.request.contextPath}/login" style="background: #4f46e5; color: white; padding: 10px 24px; border-radius: 8px; font-weight: 700; text-decoration: none; transition: 0.2s;">Login</a>
      <% } %>
    </nav>
  </div>
</header>

<script>
  // Script mở/tắt menu chạy mượt mà, không sợ đụng hàng
  function toggleHeaderMenu(event) {
      event.stopPropagation(); // Không cho cú click văng ra ngoài màn hình
      var menu = document.getElementById('headerDropContent');
      var btn = document.getElementById('headerDropBtn');

      if (menu) menu.classList.toggle('show-menu');
      if (btn) btn.classList.toggle('active');
  }

  // Tự động tắt nếu click ra chỗ khác
  window.addEventListener('click', function(event) {
      var menu = document.getElementById('headerDropContent');
      var btn = document.getElementById('headerDropBtn');

      if (menu && menu.classList.contains('show-menu')) {
          if (!btn.contains(event.target) && !menu.contains(event.target)) {
              menu.classList.remove('show-menu');
              btn.classList.remove('active');
          }
      }
  });
</script>