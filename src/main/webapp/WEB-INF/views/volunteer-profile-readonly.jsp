<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<div style="background: white; border-radius: 16px; overflow: hidden; position: relative;">

    <div style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); height: 100px;"></div>

    <div style="padding: 0 30px 30px 30px; position: relative;">

        <div style="width: 100px; height: 100px; background: white; border-radius: 50%; border: 4px solid white; box-shadow: 0 4px 10px rgba(0,0,0,0.1); margin-top: -50px; margin-bottom: 20px; display: flex; align-items: center; justify-content: center; overflow: hidden; background: #e2e8f0; font-size: 40px;">
            <c:choose>
                <c:when test="${not empty vProfile.avatar}">
                    <img src="${pageContext.request.contextPath}${vProfile.avatar}" style="width:100%;height:100%;object-fit:cover;">
                </c:when>
                <c:otherwise>👤</c:otherwise>
            </c:choose>
        </div>

        <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 20px;">
            <div>
                <h1 style="margin: 0 0 5px 0; font-size: 24px; color: #0f172a; font-weight: 800;">${vProfile.fullName}</h1>
                <span style="background: #e0e7ff; color: #4f46e5; padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: 700;">Volunteer Member</span>
            </div>

            <div style="text-align: center; background: #f8fafc; padding: 10px 20px; border-radius: 12px; border: 1px solid #e2e8f0;">
                <div style="font-size: 20px; font-weight: 800; color: #8b5cf6;">${vImpactHours}</div>
                <div style="font-size: 11px; color: #64748b; font-weight: 600; text-transform: uppercase;">Impact Hrs</div>
            </div>
        </div>

        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 20px; font-size: 14px;">
            <div>
                <div style="font-size: 11px; color: #94a3b8; font-weight: 600; text-transform: uppercase; margin-bottom: 5px;">Contact Info</div>
                <div style="color: #1e293b; font-weight: 500; margin-bottom: 6px;">📧 ${vProfile.email}</div>
                <div style="color: #1e293b; font-weight: 500;">📞 ${empty vProfile.phone ? 'Not provided' : vProfile.phone}</div>
            </div>
            <div>
                <div style="font-size: 11px; color: #94a3b8; font-weight: 600; text-transform: uppercase; margin-bottom: 5px;">Personal Details</div>
                <div style="color: #1e293b; font-weight: 500; margin-bottom: 6px;">🎂 DOB: <fmt:formatDate value="${vProfile.dob}" pattern="dd MMM, yyyy" /></div>
                <div style="color: #1e293b; font-weight: 500;">⚧ Gender: ${empty vProfile.gender ? 'Not specified' : vProfile.gender}</div>
            </div>
        </div>

        <div style="margin-bottom: 20px; font-size: 14px;">
            <div style="font-size: 11px; color: #94a3b8; font-weight: 600; text-transform: uppercase; margin-bottom: 5px;">Location</div>
            <div style="color: #1e293b; font-weight: 500;">📍 ${empty vProfile.address ? '' : vProfile.address += ', '} ${empty vProfile.province ? 'Not provided' : vProfile.province}</div>
        </div>

        <div style="background: #fff1f2; border: 1px solid #ffe4e6; padding: 12px; border-radius: 10px; margin-bottom: 20px; font-size: 14px;">
            <div style="font-size: 11px; color: #e11d48; font-weight: 700; text-transform: uppercase; margin-bottom: 5px;">🚨 Emergency Contact</div>
            <div style="color: #1e293b; font-weight: 600;">${empty vProfile.emergencyName ? 'No emergency contact provided' : vProfile.emergencyName}</div>
            <div style="color: #475569;">${vProfile.emergencyPhone}</div>
        </div>

        <div>
            <div style="font-size: 11px; color: #94a3b8; font-weight: 600; text-transform: uppercase; margin-bottom: 10px;">Verified Skills</div>
            <div style="display: flex; flex-wrap: wrap; gap: 8px;">
                <c:forEach items="${vSkills}" var="s">
                    <span style="background: #f1f5f9; color: #475569; padding: 6px 12px; border-radius: 6px; font-size: 13px; font-weight: 500; border: 1px solid #e2e8f0;">${s}</span>
                </c:forEach>
                <c:if test="${empty vSkills}">
                    <span style="color: #94a3b8; font-style: italic; font-size: 13px;">No skills listed.</span>
                </c:if>
            </div>
        </div>
    </div>
</div>