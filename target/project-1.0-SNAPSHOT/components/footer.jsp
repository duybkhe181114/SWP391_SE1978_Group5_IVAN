<style>
  .footer {
    background: rgba(6, 8, 12, 0.9);
    backdrop-filter: blur(18px);
    -webkit-backdrop-filter: blur(18px);
    border-top: 1px solid rgba(255,255,255,0.06);
    color: rgba(255,255,255,0.7);
    padding: 56px 0 32px;
    margin-top: 80px;
  }

  .footer-content {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
    gap: 40px;
    margin-bottom: 40px;
  }

  /* ===== SECTION ===== */
  .footer-section h3 {
    font-size: 14px;
    font-weight: 600;
    letter-spacing: 0.6px;
    margin-bottom: 16px;
    color: #fff;
    text-transform: uppercase;
  }

  .footer-section p {
    font-size: 14px;
    line-height: 1.6;
    margin-bottom: 10px;
    color: rgba(255,255,255,0.65);
  }

  .footer-section a {
    font-size: 14px;
    color: rgba(255,255,255,0.65);
    text-decoration: none;
    display: inline-block;
    margin-bottom: 10px;
    transition: color 0.2s ease;
  }

  .footer-section a:hover {
    color: #fff;
  }

  /* ===== SOCIAL ===== */
  .social-links {
    display: flex;
    gap: 12px;
    margin-top: 8px;
  }

  .social-links a {
    width: 36px;
    height: 36px;
    border-radius: 10px;
    background: rgba(255,255,255,0.06);
    border: 1px solid rgba(255,255,255,0.08);
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 13px;
    font-weight: 600;
    color: rgba(255,255,255,0.75);
    transition: background 0.2s ease, color 0.2s ease;
  }

  .social-links a:hover {
    background: rgba(255,255,255,0.12);
    color: #fff;
  }

  /* ===== BOTTOM ===== */
  .footer-bottom {
    text-align: center;
    padding-top: 24px;
    border-top: 1px solid rgba(255,255,255,0.06);
    font-size: 13px;
    color: rgba(255,255,255,0.55);
  }
</style>

<footer class="footer">
  <div class="container">
    <div class="footer-content">

      <div class="footer-section">
        <h3>IVAN</h3>
        <p>International Volunteer Assistance Network</p>
        <p>Connecting volunteers with meaningful opportunities worldwide.</p>
      </div>

      <div class="footer-section">
        <h3>Quick Links</h3>
        <a href="${pageContext.request.contextPath}/home">Home</a>
        <a href="#">Browse Events</a>
        <a href="#">About</a>
        <a href="#">Contact</a>
      </div>

      <div class="footer-section">
        <h3>For Organizations</h3>
        <a href="#">Create Event</a>
        <a href="#">Dashboard</a>
        <a href="#">Resources</a>
      </div>

      <div class="footer-section">
        <h3>Connect</h3>
        <div class="social-links">
          <a href="#" title="Facebook">Fb</a>
          <a href="#" title="Twitter">Tw</a>
          <a href="#" title="Instagram">Ig</a>
          <a href="#" title="LinkedIn">In</a>
        </div>
      </div>

    </div>

    <div class="footer-bottom">
      © 2026 IVAN. All rights reserved.
    </div>
  </div>
</footer>
