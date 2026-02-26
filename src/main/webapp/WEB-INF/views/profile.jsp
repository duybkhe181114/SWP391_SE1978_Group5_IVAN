<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="/components/header.jsp"/>

<style>
    /* CSS cho trang View */
    .view-value {
        font-size: 15px; font-weight: 500; color: #1f2937;
        padding: 8px 12px; background: #f8fafc; border-radius: 8px;
        border: 1px solid #e2e8f0; min-height: 40px;
        display: flex; align-items: center;
    }
    .view-group label {
        font-size: 13px; font-weight: 600; color: #64748b;
        margin-bottom: 6px; display: block; text-transform: uppercase;
        letter-spacing: 0.5px;
    }
    .view-group { margin-bottom: 20px; }

    /* CSS vô hiệu hóa ô check skill ở màn hình view */
    .skills-view { pointer-events: none; }
</style>

<div class="admin-page">
    <div class="profile-wrapper">
        <div class="profile-card">

            <%-- KIỂM TRA THAM SỐ TRÊN URL: Nếu có ?action=edit thì hiện FORM, ngược lại hiện VIEW --%>
            <c:choose>

                <%-- ========================================== --%>
                <%-- MÀN HÌNH EDIT PROFILE                      --%>
                <%-- ========================================== --%>
                <c:when test="${param.action == 'edit'}">
                    <h2 class="section-title" style="font-size: 26px; margin-bottom: 24px; border: none;">
                        <span style="color: #667eea;">●</span> Edit Profile
                    </h2>

                    <form method="post" action="${pageContext.request.contextPath}/profile">

                        <div class="section-title" style="font-size: 18px; margin: 20px 0 15px; border-bottom: 2px solid #f1f5f9; padding-bottom: 10px;">
                            Personal Information
                        </div>

                        <div class="form-grid">
                            <div class="form-group">
                                <label>First Name</label>
                                <input type="text" name="firstName" value="${profile.firstName}" required>
                            </div>
                            <div class="form-group">
                                <label>Last Name</label>
                                <input type="text" name="lastName" value="${profile.lastName}" required>
                            </div>
                            <div class="form-group">
                                <label>Phone</label>
                                <input type="text" name="phone" value="${profile.phone}">
                            </div>
                            <div class="form-group">
                                <label>Date of Birth</label>
                                <input type="date" name="dateOfBirth" value="${profile.dateOfBirth}">
                            </div>
                            <div class="form-group">
                                <label>Gender</label>
                                <select name="gender">
                                    <option value="">-- Select --</option>
                                    <option value="Male" ${profile.gender == 'Male' ? 'selected' : ''}>Male</option>
                                    <option value="Female" ${profile.gender == 'Female' ? 'selected' : ''}>Female</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Province</label>
                                <input type="text" name="province" value="${profile.province}">
                            </div>
                            <div class="form-group full-width">
                                <label>Address</label>
                                <input type="text" name="address" value="${profile.address}">
                            </div>
                        </div>

                        <div class="section-title" style="font-size: 18px; margin: 30px 0 15px; border-bottom: 2px solid #f1f5f9; padding-bottom: 10px;">
                            Emergency Contact
                        </div>

                        <div class="form-grid">
                            <div class="form-group">
                                <label>Name</label>
                                <input type="text" name="emergencyName" value="${profile.emergencyContactName}">
                            </div>
                            <div class="form-group">
                                <label>Phone</label>
                                <input type="text" name="emergencyPhone" value="${profile.emergencyContactPhone}">
                            </div>
                        </div>

                        <div class="section-title" style="font-size: 18px; margin: 30px 0 15px; border-bottom: 2px solid #f1f5f9; padding-bottom: 10px;">
                            Select Your Skills
                        </div>

                        <div class="skills-group">
                            <c:forEach var="skill" items="${allSkills}">
                                <div class="skill-item">
                                    <input type="checkbox" id="edit_skill_${skill.skillId}" class="skill-checkbox" name="skills" value="${skill.skillId}"
                                           <c:if test="${selectedSkills.contains(skill.skillId)}">checked</c:if> />
                                    <label for="edit_skill_${skill.skillId}" class="skill-badge">${skill.skillName}</label>
                                </div>
                            </c:forEach>
                        </div>

                        <div style="margin-top: 40px; display: flex; gap: 12px; justify-content: flex-end;">
                            <a href="${pageContext.request.contextPath}/profile" class="btn-clear" style="padding: 12px 24px; text-decoration: none;">
                                Cancel
                            </a>
                            <button type="submit" class="btn-primary" style="padding: 12px 24px;">
                                Save Changes
                            </button>
                        </div>

                    </form>
                </c:when>


                <%-- ========================================== --%>
                <%-- MÀN HÌNH VIEW PROFILE (MẶC ĐỊNH)           --%>
                <%-- ========================================== --%>
                <c:otherwise>
                    <h2 class="section-title" style="font-size: 26px; margin-bottom: 24px; border: none;">
                        <span style="color: #667eea;">●</span> My Profile
                    </h2>

                    <c:if test="${param.success == 1}">
                        <div class="success-message" style="margin-bottom: 20px;">
                            Profile updated successfully!
                        </div>
                    </c:if>

                    <div class="section-title" style="font-size: 18px; margin: 20px 0 15px; border-bottom: 2px solid #f1f5f9; padding-bottom: 10px;">
                        Personal Information
                    </div>

                    <div class="form-grid">
                        <div class="view-group">
                            <label>First Name</label>
                            <div class="view-value">${profile.firstName != null ? profile.firstName : '<span style="color:#94a3b8; font-style:italic;">Not provided</span>'}</div>
                        </div>
                        <div class="view-group">
                            <label>Last Name</label>
                            <div class="view-value">${profile.lastName != null ? profile.lastName : '<span style="color:#94a3b8; font-style:italic;">Not provided</span>'}</div>
                        </div>
                        <div class="view-group">
                            <label>Phone</label>
                            <div class="view-value">${profile.phone != null ? profile.phone : '<span style="color:#94a3b8; font-style:italic;">Not provided</span>'}</div>
                        </div>
                        <div class="view-group">
                            <label>Date of Birth</label>
                            <div class="view-value">${profile.dateOfBirth != null ? profile.dateOfBirth : '<span style="color:#94a3b8; font-style:italic;">Not provided</span>'}</div>
                        </div>
                        <div class="view-group">
                            <label>Gender</label>
                            <div class="view-value">${profile.gender != null ? profile.gender : '<span style="color:#94a3b8; font-style:italic;">Not provided</span>'}</div>
                        </div>
                        <div class="view-group">
                            <label>Province</label>
                            <div class="view-value">${profile.province != null ? profile.province : '<span style="color:#94a3b8; font-style:italic;">Not provided</span>'}</div>
                        </div>
                        <div class="view-group full-width">
                            <label>Address</label>
                            <div class="view-value">${profile.address != null ? profile.address : '<span style="color:#94a3b8; font-style:italic;">Not provided</span>'}</div>
                        </div>
                    </div>

                    <div class="section-title" style="font-size: 18px; margin: 30px 0 15px; border-bottom: 2px solid #f1f5f9; padding-bottom: 10px;">
                        Emergency Contact
                    </div>

                    <div class="form-grid">
                        <div class="view-group">
                            <label>Name</label>
                            <div class="view-value">${profile.emergencyContactName != null ? profile.emergencyContactName : '<span style="color:#94a3b8; font-style:italic;">Not provided</span>'}</div>
                        </div>
                        <div class="view-group">
                            <label>Phone</label>
                            <div class="view-value">${profile.emergencyContactPhone != null ? profile.emergencyContactPhone : '<span style="color:#94a3b8; font-style:italic;">Not provided</span>'}</div>
                        </div>
                    </div>

                    <div class="section-title" style="font-size: 18px; margin: 30px 0 15px; border-bottom: 2px solid #f1f5f9; padding-bottom: 10px;">
                        My Skills
                    </div>

                    <div class="skills-group skills-view">
                        <c:set var="hasSkill" value="false" />
                        <c:forEach var="skill" items="${allSkills}">
                            <c:if test="${selectedSkills.contains(skill.skillId)}">
                                <c:set var="hasSkill" value="true" />
                                <div class="skill-item">
                                    <input type="checkbox" class="skill-checkbox" checked style="display: none;" />
                                    <label class="skill-badge" style="margin: 0;">${skill.skillName}</label>
                                </div>
                            </c:if>
                        </c:forEach>

                        <c:if test="${!hasSkill}">
                            <span style="color:#94a3b8; font-style:italic; display: block; padding: 10px 0;">No skills added yet. Click Edit Profile to add skills.</span>
                        </c:if>
                    </div>

                    <div style="margin-top: 40px; text-align: right;">
                         <a href="?action=edit" class="btn-primary" style="display: inline-block; text-decoration: none; padding: 12px 24px;">
                            Edit Profile
                         </a>
                    </div>
                </c:otherwise>

            </c:choose>

        </div>
    </div>
</div>

<jsp:include page="/components/footer.jsp"/>