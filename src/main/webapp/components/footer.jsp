<style>
  .footer {
    background: #1a202c;
    color: white;
    padding: 60px 0 30px;
    margin-top: 80px;
  }
  .footer-content { 
    display: grid; 
    grid-template-columns: 2fr 1fr 1fr 1fr;
    gap: 40px;
    margin-bottom: 40px;
    max-width: 1400px;
    margin: 0 auto;
    padding: 0 40px 40px;
  }
  .footer-section h3 { 
    font-size: 16px; 
    margin-bottom: 20px;
    color: #fff;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 0.5px;
  }
  .footer-section.brand h3 {
    font-size: 24px;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    text-transform: none;
    letter-spacing: -1px;
  }
  .footer-section p { 
    color: #a0aec0;
    line-height: 1.6;
    margin-bottom: 12px;
    font-size: 14px;
  }
  .footer-section a { 
    color: #a0aec0; 
    text-decoration: none;
    display: block;
    margin-bottom: 10px;
    transition: color 0.2s;
    font-size: 14px;
  }
  .footer-section a:hover { color: #667eea; }
  .footer-bottom { 
    text-align: center; 
    padding-top: 30px; 
    border-top: 1px solid rgba(255,255,255,0.1);
    color: #718096;
    font-size: 14px;
    max-width: 1400px;
    margin: 0 auto;
    padding-left: 40px;
    padding-right: 40px;
  }
  .social-links { display: flex; gap: 12px; margin-top: 20px; }
  .social-links a { 
    width: 36px; 
    height: 36px; 
    background: #2d3748;
    border-radius: 8px;
    display: flex; 
    align-items: center; 
    justify-content: center;
    transition: all 0.2s;
    font-weight: 600;
  }
  .social-links a:hover { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; transform: translateY(-2px); }
</style>

<footer class="footer">
  <div class="footer-content">
    <div class="footer-section brand">
      <h3>IVAN</h3>
      <p>International Volunteer Assistance Network</p>
      <p>Connecting passionate volunteers with meaningful opportunities to make a real difference in communities worldwide.</p>
      <div class="social-links">
        <a href="#" title="Facebook">F</a>
        <a href="#" title="Twitter">T</a>
        <a href="#" title="Instagram">IG</a>
        <a href="#" title="LinkedIn">in</a>
      </div>

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
      <a href="#">Support</a>
    </div>
    
    <div class="footer-section">
      <h3>Support</h3>
      <a href="#">Help Center</a>
      <a href="#">Terms of Service</a>
      <a href="#">Privacy Policy</a>
      <a href="#">FAQ</a>
    </div>
  </div>
  
  <div class="footer-bottom">
    <p>&copy; 2026 IVAN. All rights reserved. Made with love for volunteers worldwide.</p>
  </div>
</footer>
