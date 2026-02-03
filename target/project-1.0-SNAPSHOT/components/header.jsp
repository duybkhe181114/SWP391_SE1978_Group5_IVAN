<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/layout.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">

<style>
  /* ===== HEADER BASE ===== */
  .header {
    position: sticky;
    top: 0;
    z-index: 1000;
    background: rgba(4, 6, 10, 0.55);
    backdrop-filter: blur(14px);
    -webkit-backdrop-filter: blur(14px);
    border-bottom: 1px solid rgba(255,255,255,0.06);
  }

  .header-inner {
    display: flex;
    align-items: center;
    justify-content: space-between;
    height: 72px;
  }

  /* ===== LOGO ===== */
  .logo {
    font-size: 22px;
    font-weight: 700;
    letter-spacing: 1.5px;
    color: #fff;
  }

  /* ===== NAV ===== */
  .nav {
    display: flex;
    align-items: center;
    gap: 28px;
  }

  .nav a,
  .dropdown-trigger {
    color: rgba(255,255,255,0.85);
    text-decoration: none;
    font-size: 14px;
    font-weight: 500;
    padding: 8px 0;
    cursor: pointer;
  }

  .nav a:hover,
  .dropdown-trigger:hover {
    color: #fff;
  }

  /* ===== CTA BUTTON ===== */
  .nav .cta {
    padding: 8px 16px;
    border-radius: 999px;
    background: rgba(255,255,255,0.1);
    border: 1px solid rgba(255,255,255,0.15);
    font-weight: 600;
  }

  .nav .cta:hover {
    background: rgba(255,255,255,0.18);
  }

  .dropdown {
    position: relative;
  }

  .dropdown::before {
    content: "";
    position: absolute;
    top: 100%;
    right: 0;
    width: 100%;
    height: 12px;
  }

  /* ===== DROPDOWN ===== */

  .dropdown-menu {
    position: absolute;
    top: 100%;
    margin-top: 10px;
    right: 0;
    min-width: 180px;

    background: rgba(6, 8, 12, 0.88);
    backdrop-filter: blur(20px);
    -webkit-backdrop-filter: blur(20px);

    border: 1px solid rgba(255,255,255,0.08);
    border-radius: 12px;

    padding: 6px;

    box-shadow:
            0 12px 24px rgba(0,0,0,0.35);

    opacity: 0;
    visibility: hidden;
    transform: translateY(-4px);
    transition: opacity 0.15s ease, transform 0.15s ease;
    pointer-events: none;
  }

  .dropdown-menu a {
    padding: 10px 14px;
    border-radius: 8px;
    font-size: 14px;
    font-weight: 500;
    color: rgba(255,255,255,0.85);
  }

  .dropdown-menu a:hover {
    background: rgba(255,255,255,0.08);
    color: #fff;
  }

  .dropdown:hover .dropdown-menu {
    opacity: 1;
    visibility: visible;
    transform: translateY(0);
    pointer-events: auto;
  }
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
      %>
      <a href="${pageContext.request.contextPath}/${userRole}/dashboard" class="cta">
        Dashboard
      </a>
      <% } else { %>
      <a href="${pageContext.request.contextPath}/loginasuser">Login</a>

      <div class="dropdown">
        <span class="dropdown-trigger">Register</span>
        <div class="dropdown-menu">
          <a href="#">Volunteer</a>
          <a href="${pageContext.request.contextPath}/create-organization">
            Organization
          </a>
        </div>
      </div>
      <% } %>
    </nav>
  </div>
</header>
