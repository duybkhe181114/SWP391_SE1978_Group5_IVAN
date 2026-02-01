<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/layout.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">

<style>
  .header {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    padding: 20px 0;
    box-shadow: 0 4px 20px rgba(0,0,0,0.1);
    position: sticky;
    top: 0;
    z-index: 1000;
  }
  .header-inner { display: flex; justify-content: space-between; align-items: center; }
  .logo { 
    font-size: 32px; 
    font-weight: bold; 
    color: white;
    text-shadow: 2px 2px 4px rgba(0,0,0,0.2);
    letter-spacing: 2px;
  }
  .nav { display: flex; gap: 30px; align-items: center; }
  .nav a { 
    color: white; 
    text-decoration: none; 
    font-weight: 500;
    transition: all 0.3s;
    padding: 8px 16px;
    border-radius: 8px;
  }
  .nav a:hover { background: rgba(255,255,255,0.2); transform: translateY(-2px); }
  .dropdown { position: relative; }
  .dropdown span { 
    color: white; 
    cursor: pointer; 
    font-weight: 500;
    padding: 8px 16px;
    border-radius: 8px;
    transition: all 0.3s;
  }
  .dropdown:hover span { background: rgba(255,255,255,0.2); }
  .dropdown-menu { 
    display: none; 
    position: absolute; 
    top: 100%; 
    right: 0; 
    background: white; 
    border-radius: 12px;
    box-shadow: 0 8px 25px rgba(0,0,0,0.15);
    margin-top: 10px;
    min-width: 200px;
    overflow: hidden;
  }
  .dropdown:hover .dropdown-menu { display: block; }
  .dropdown-menu a { 
    color: #333; 
    display: block; 
    padding: 12px 20px;
    border-radius: 0;
  }
  .dropdown-menu a:hover { background: #f5f5f5; transform: none; }
</style>

<header class="header">
  <div class="container header-inner">
    <div class="logo">IVAN</div>

    <nav class="nav">
      <a href="${pageContext.request.contextPath}/home">Home</a>
      <a href="#">Events</a>
      <a href="#">Support</a>
      
      <% 
        String userRole = (String) session.getAttribute("userRole");
        if (userRole != null) {
          if ("volunteer".equals(userRole)) {
      %>
        <a href="${pageContext.request.contextPath}/volunteer/dashboard" style="background: rgba(255,255,255,0.2); font-weight: 700;">My Dashboard</a>
      <% 
          } else if ("organization".equals(userRole)) {
      %>
        <a href="${pageContext.request.contextPath}/organization/dashboard" style="background: rgba(255,255,255,0.2); font-weight: 700;">My Dashboard</a>
      <% 
          }
        } else {
      %>
        <a href="${pageContext.request.contextPath}/loginasuser">Login</a>
        <div class="dropdown">
          <span>Register &#9662;</span>
          <div class="dropdown-menu">
            <a href="#">Volunteer</a>
            <a href="#">Organization</a>
          </div>
        </div>
      <% } %>
    </nav>
  </div>
</header>
