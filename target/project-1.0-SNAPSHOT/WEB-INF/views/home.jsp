<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/components/header.jsp"/>
<jsp:include page="/components/hero.jsp"/>

<% if (session.getAttribute("userId") != null) { %>
<section class="dashboard-buttons" style="background: #f8f9fa; padding: 40px 0;">
  <div class="container" style="text-align: center;">
    <h2 style="margin-bottom: 30px; color: #333;">Quick Access</h2>
    <div style="display: flex; gap: 20px; justify-content: center; flex-wrap: wrap;">
      <a href="${pageContext.request.contextPath}/volunteer/dashboard" 
         style="display: inline-block; padding: 20px 40px; background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); color: white; text-decoration: none; border-radius: 12px; font-weight: 600; font-size: 18px; box-shadow: 0 4px 15px rgba(0,0,0,0.2); transition: transform 0.3s;" 
         onmouseover="this.style.transform='translateY(-5px)'" 
         onmouseout="this.style.transform='translateY(0)'">
        Volunteer Dashboard
      </a>
      <a href="${pageContext.request.contextPath}/organization/dashboard" 
         style="display: inline-block; padding: 20px 40px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; text-decoration: none; border-radius: 12px; font-weight: 600; font-size: 18px; box-shadow: 0 4px 15px rgba(0,0,0,0.2); transition: transform 0.3s;" 
         onmouseover="this.style.transform='translateY(-5px)'" 
         onmouseout="this.style.transform='translateY(0)'">
        Organization Dashboard
      </a>
    </div>
  </div>
</section>
<% } %>

<jsp:include page="/components/event-list.jsp"/>
<jsp:include page="/components/footer.jsp"/>