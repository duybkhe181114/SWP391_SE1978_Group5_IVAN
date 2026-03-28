<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<section style="background-color:#f8fafc; padding:50px 0; border-bottom:1px solid #e2e8f0;">
    <div class="container">

        <div style="text-align:center; margin-bottom:30px;">
            <h2 style="font-size:30px; color:#0f172a; margin-bottom:8px;">
                How IVAN Works
            </h2>
            <p style="color:#64748b; font-size:15px;">
                Join our community and start making an impact in just 3 simple steps.
            </p>
        </div>

        <div style="display:grid; grid-template-columns:repeat(auto-fit,minmax(260px,1fr)); gap:25px; text-align:center;">

            <style>
                .how-card {
                    display: block;
                    padding: 28px 22px;
                    background: white;
                    border-radius: 16px;
                    box-shadow: 0 6px 18px rgba(0,0,0,0.04);
                    text-decoration: none;
                    color: inherit;
                    transition: all 0.2s ease;
                }
                .how-card:hover {
                    box-shadow: 0 10px 25px rgba(0,0,0,0.1);
                    transform: translateY(-4px);
                }
            </style>

            <c:choose>
                <c:when test="${sessionScope.userRole == 'Volunteer'}">
                    <c:set var="createLink" value="${pageContext.request.contextPath}/volunteer/dashboard"/>
                </c:when>
                <c:when test="${sessionScope.userRole == 'Organization'}">
                    <c:set var="createLink" value="${pageContext.request.contextPath}/organization/dashboard"/>
                </c:when>
                <c:when test="${sessionScope.userRole == 'Coordinator'}">
                    <c:set var="createLink" value="${pageContext.request.contextPath}/coordinator/dashboard"/>
                </c:when>
                <c:when test="${sessionScope.userRole == 'Admin'}">
                    <c:set var="createLink" value="${pageContext.request.contextPath}/admin/dashboard"/>
                </c:when>
                <c:otherwise>
                    <c:set var="createLink" value="${pageContext.request.contextPath}/register"/>
                </c:otherwise>
            </c:choose>

            <a href="${createLink}" class="how-card">
                <div style="font-size:42px; margin-bottom:18px;">👤</div>
                <h3 style="font-size:18px; margin-bottom:10px; color:#1e293b;">1. Create an Account</h3>
                <p style="color:#64748b; font-size:14px; line-height:1.6;">
                    Sign up as a volunteer or an organization to get started.
                </p>
            </a>

            <a href="${pageContext.request.contextPath}/events" class="how-card">
                <div style="font-size:42px; margin-bottom:18px;">🔍</div>
                <h3 style="font-size:18px; margin-bottom:10px; color:#1e293b;">2. Find Opportunities</h3>
                <p style="color:#64748b; font-size:14px; line-height:1.6;">
                    Browse upcoming events that match your skills and location.
                </p>
            </a>

            <a href="${pageContext.request.contextPath}/events" class="how-card">
                <div style="font-size:42px; margin-bottom:18px;">🤝</div>
                <h3 style="font-size:18px; margin-bottom:10px; color:#1e293b;">3. Make an Impact</h3>
                <p style="color:#64748b; font-size:14px; line-height:1.6;">
                    Apply for events, participate, and help build a better community.
                </p>
            </a>

        </div>
    </div>
</section>