<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<section style="background: #ffffff; padding: 80px 0;">
    <div class="container">
        <div style="text-align: center; margin-bottom: 50px;">
            <h2 class="section-title" style="justify-content: center; border: none; font-size: 32px; color: #0f172a;">Trusted by Top Organizations</h2>
            <p style="color: #64748b; font-size: 16px;">Collaborating with the most dedicated NGOs and communities.</p>
        </div>

        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 30px; max-width: 1100px; margin: 0 auto;">

            <c:forEach items="${topOrgs}" var="org">
                <div style="background: white; border-radius: 20px; overflow: hidden; box-shadow: 0 10px 30px rgba(0,0,0,0.05); border: 1px solid #f1f5f9; transition: transform 0.3s ease, box-shadow 0.3s ease; display: flex; flex-direction: column; text-align: center; padding: 40px 30px;"
                     onmouseover="this.style.transform='translateY(-10px)'; this.style.boxShadow='0 20px 40px rgba(0,0,0,0.1)';"
                     onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='0 10px 30px rgba(0,0,0,0.05)';">

                    <div style="width: 90px; height: 90px; margin: 0 auto 20px auto; border-radius: 50%; padding: 4px; background: white; box-shadow: 0 4px 15px rgba(0,0,0,0.1);">
                        <img src="${pageContext.request.contextPath}${empty org.LogoUrl ? '/assets/images/events/default.png' : org.LogoUrl}"
                             alt="${org.Name}"
                             style="width: 100%; height: 100%; object-fit: cover; border-radius: 50%;">
                    </div>

                    <h3 style="font-size: 20px; color: #0f172a; margin-bottom: 10px; font-weight: 700;">${org.Name}</h3>

                    <div style="color: #667eea; font-size: 13px; font-weight: 600; margin-bottom: 15px;">
                        📍 ${empty org.Address ? 'Vietnam' : org.Address}
                    </div>

                    <p style="color: #64748b; font-size: 14px; line-height: 1.6; margin-bottom: 30px; display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical; overflow: hidden; flex-grow: 1;">
                        ${empty org.Description ? 'Providing meaningful opportunities to connect volunteers with community needs. Join us today!' : org.Description}
                    </p>

                    <a href="${pageContext.request.contextPath}/organization/detail?id=${org.OrganizationId}"
                       style="display: inline-block; width: 100%; padding: 12px; background: #f8fafc; color: #667eea; text-decoration: none; border-radius: 10px; font-weight: 600; border: 1px solid #e2e8f0; transition: 0.2s;"
                       onmouseover="this.style.background='#667eea'; this.style.color='white';"
                       onmouseout="this.style.background='#f8fafc'; this.style.color='#667eea';">
                        View Profile
                    </a>
                </div>
            </c:forEach>

        </div>
    </div>
</section>