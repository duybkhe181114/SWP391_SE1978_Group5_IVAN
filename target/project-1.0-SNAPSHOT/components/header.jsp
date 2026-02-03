<style>
  body { font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif; }
  .header {
    background: white;
    padding: 0;
    box-shadow: 0 2px 10px rgba(0,0,0,0.08);
    position: sticky;
    top: 0;
    z-index: 1000;
    border-bottom: 1px solid #e8e8e8;
  }
  .header-inner { 
    display: flex; 
    justify-content: space-between; 
    align-items: center;
    padding: 20px 40px;
    max-width: 1400px;
    margin: 0 auto;
  }
  .logo { 
    font-size: 28px; 
    font-weight: 800; 
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    letter-spacing: -1px;
  }
  .nav { display: flex; gap: 8px; align-items: center; }
  .nav a { 
    color: #4a5568; 
    text-decoration: none; 
    font-weight: 500;
    font-size: 15px;
    transition: all 0.2s;
    padding: 10px 18px;
    border-radius: 8px;
  }
  .nav a:hover { color: #667eea; background: #f7f8fc; }
  .nav a.active { color: white; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); font-weight: 600; }
  .btn-login { 
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white !important;
    padding: 10px 24px !important;
    border-radius: 8px;
    font-weight: 600;
  }
  .btn-login:hover { transform: translateY(-2px); box-shadow: 0 4px 12px rgba(102,126,234,0.4); }
  .user-menu { position: relative; }
  .user-btn {
    display: flex;
    align-items: center;
    gap: 8px;
    padding: 8px 16px;
    background: #f7f8fc;
    border-radius: 8px;
    cursor: pointer;
    font-weight: 500;
    color: #4a5568;
  }
  .user-btn:hover { background: #eef0f7; }
  .dropdown-menu { 
    display: none; 
    position: absolute; 
    top: calc(100% + 8px);
    right: 0; 
    background: white; 
    border-radius: 12px;
    box-shadow: 0 8px 30px rgba(0,0,0,0.12);
    min-width: 200px;
    overflow: hidden;
    border: 1px solid #e8e8e8;
  }
  .user-menu:hover .dropdown-menu,
  .dropdown-menu:hover { display: block; }
  .dropdown-menu a { 
    color: #4a5568; 
    display: block; 
    padding: 12px 20px;
    border-radius: 0;
    font-size: 14px;
  }
  .dropdown-menu a:hover { background: #f7f8fc; color: #667eea; }
</style>

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
            <span>&#9662;</span>
          </div>
          <div class="dropdown-menu">
            <% if ("Organization".equals(userRole)) { %>
              <a href="${pageContext.request.contextPath}/organization/dashboard">Dashboard</a>
              <a href="${pageContext.request.contextPath}/organization/create-event">Create Event</a>
            <% } else if ("Admin".equals(userRole)) { %>
              <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
              <a href="${pageContext.request.contextPath}/admin/manage-events">Manage Events</a>
            <% } else { %>
              <a href="${pageContext.request.contextPath}/volunteer/dashboard">Dashboard</a>
            <% } %>
            <a href="${pageContext.request.contextPath}/logout">Logout</a>
          </div>
        </div>
      <% } else { %>
        <a href="${pageContext.request.contextPath}/login" class="btn-login">Login</a>
      <% } %>
    </nav>
  </div>
</header>
