<style>
  .footer {
    background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
    color: white;
    padding: 40px 0;
    margin-top: 60px;
  }
  .footer-content { 
    display: grid; 
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); 
    gap: 30px;
    margin-bottom: 30px;
  }
  .footer-section h3 { 
    font-size: 18px; 
    margin-bottom: 15px;
    color: #fff;
  }
  .footer-section p, .footer-section a { 
    color: rgba(255,255,255,0.8); 
    text-decoration: none;
    display: block;
    margin-bottom: 8px;
    transition: color 0.3s;
  }
  .footer-section a:hover { color: #fff; }
  .footer-bottom { 
    text-align: center; 
    padding-top: 30px; 
    border-top: 1px solid rgba(255,255,255,0.1);
    color: rgba(255,255,255,0.7);
  }
  .social-links { display: flex; gap: 15px; margin-top: 15px; }
  .social-links a { 
    width: 40px; 
    height: 40px; 
    background: rgba(255,255,255,0.1); 
    border-radius: 50%; 
    display: flex; 
    align-items: center; 
    justify-content: center;
    transition: all 0.3s;
  }
  .social-links a:hover { background: rgba(255,255,255,0.2); transform: translateY(-3px); }
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
        <a href="#">About Us</a>
        <a href="#">Contact</a>
      </div>
      
      <div class="footer-section">
        <h3>For Organizations</h3>
        <a href="#">Create Event</a>
        <a href="#">Dashboard</a>
        <a href="#">Resources</a>
      </div>
      
      <div class="footer-section">
        <h3>Connect With Us</h3>
        <div class="social-links">
          <a href="#" title="Facebook">f</a>
          <a href="#" title="Twitter">t</a>
          <a href="#" title="Instagram">i</a>
          <a href="#" title="LinkedIn">in</a>
        </div>
      </div>
    </div>
    
    <div class="footer-bottom">
      <p>© 2026 IVAN – International Volunteer Assistance Network. All rights reserved.</p>
    </div>
  </div>
</footer>
