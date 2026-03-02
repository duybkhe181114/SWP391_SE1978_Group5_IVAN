<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="/components/header.jsp"/>

<style>
    .comparison-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 20px;
        margin-top: 15px;
    }
    .data-col {
        background: #f8fafc;
        padding: 15px;
        border-radius: 12px;
        border: 1px solid #e2e8f0;
    }
    .data-col h4 {
        margin-top: 0;
        margin-bottom: 15px;
        color: #334155;
        font-size: 15px;
        text-align: center;
        border-bottom: 2px solid #e2e8f0;
        padding-bottom: 8px;
    }
    .data-row {
        margin-bottom: 12px;
    }
    .data-label {
        font-size: 12px;
        color: #64748b;
        text-transform: uppercase;
        font-weight: 600;
        margin-bottom: 4px;
        display: block;
    }
    .data-value {
        font-size: 14px;
        color: #0f172a;
        font-weight: 500;
    }
    .highlight-change {
        color: #2563eb; /* Màu xanh nước biển báo hiệu dữ liệu mới */
        font-weight: 700;
    }
    .skill-tag {
        display: inline-block;
        background: #e2e8f0;
        color: #475569;
        padding: 4px 8px;
        border-radius: 6px;
        font-size: 12px;
        margin: 2px;
    }
</style>

<div class="admin-page">
    <div class="admin-container">

        <h2 class="section-title">
            <span style="color: #667eea;">●</span> Review Profile Updates
        </h2>

        <c:if test="${param.success == 1}">
            <div style="background: #dcfce7; color: #166534; padding: 12px 20px; border-radius: 8px; margin-bottom: 20px; font-weight: 500;">
                Action completed successfully!
            </div>
        </c:if>

        <div class="admin-table-wrapper">
            <table class="table admin-table">
                <thead>
                    <tr>
                        <th style="width: 50px;">#</th>
                        <th>User Email</th>
                        <th>Requested At</th>
                        <th>Status</th>
                        <th style="width: 120px; text-align: center;">Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${pendingRequests}" var="req" varStatus="loop">
                        <tr>
                            <td><span style="color: #94a3b8;">${loop.index + 1}</span></td>
                            <td><div class="user-email">${req.email}</div></td>
                            <td style="color: #64748b; font-size: 14px;">
                                <fmt:formatDate value="${req.requestedAt}" pattern="dd MMM, yyyy HH:mm"/>
                            </td>
                            <td><span class="badge" style="background: #fef08a; color: #854d0e;">Pending</span></td>
                            <td style="text-align: center;">
                                <button type="button" class="btn-action info" onclick="document.getElementById('modal_${req.requestId}').style.display='flex'">
                                    Review
                                </button>
                            </td>
                        </tr>

                        <div id="modal_${req.requestId}" class="modal-overlay">
                            <div class="modal" style="width: 700px; max-width: 95%;">
                                <h3>Review Profile Update - <span style="color:#667eea">${req.email}</span></h3>

                                <div class="comparison-grid">
                                    <div class="data-col">
                                        <h4>Current Profile</h4>
                                        <div class="data-row">
                                            <span class="data-label">Full Name</span>
                                            <span class="data-value">${req.oldFirstName} ${req.oldLastName}</span>
                                        </div>
                                        <div class="data-row">
                                            <span class="data-label">Phone</span>
                                            <span class="data-value">${empty req.oldPhone ? 'N/A' : req.oldPhone}</span>
                                        </div>
                                        <div class="data-row">
                                            <span class="data-label">Province</span>
                                            <span class="data-value">${empty req.oldProvince ? 'N/A' : req.oldProvince}</span>
                                        </div>
                                        <div class="data-row">
                                            <span class="data-label">Address</span>
                                            <span class="data-value">${empty req.oldAddress ? 'N/A' : req.oldAddress}</span>
                                        </div>
                                        <div class="data-row">
                                            <span class="data-label">Skills</span>
                                            <div>
                                                <c:forEach var="skill" items="${allSkills}">
                                                    <c:set var="searchStr" value=",${skill.skillId}," />
                                                    <c:set var="oldIdsStr" value=",${req.oldSkillIds}," />
                                                    <c:if test="${oldIdsStr.contains(searchStr)}">
                                                        <span class="skill-tag">${skill.skillName}</span>
                                                    </c:if>
                                                </c:forEach>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="data-col" style="background: #f0fdf4; border-color: #bbf7d0;">
                                        <h4 style="color: #166534; border-bottom-color: #bbf7d0;">Requested Changes</h4>
                                        <div class="data-row">
                                            <span class="data-label">Full Name</span>
                                            <span class="data-value highlight-change">${req.newFirstName} ${req.newLastName}</span>
                                        </div>
                                        <div class="data-row">
                                            <span class="data-label">Phone</span>
                                            <span class="data-value highlight-change">${empty req.newPhone ? 'N/A' : req.newPhone}</span>
                                        </div>
                                        <div class="data-row">
                                            <span class="data-label">Province</span>
                                            <span class="data-value highlight-change">${empty req.newProvince ? 'N/A' : req.newProvince}</span>
                                        </div>
                                        <div class="data-row">
                                            <span class="data-label">Address</span>
                                            <span class="data-value highlight-change">${empty req.newAddress ? 'N/A' : req.newAddress}</span>
                                        </div>
                                        <div class="data-row">
                                            <span class="data-label">Skills</span>
                                            <div>
                                                <c:forEach var="skill" items="${allSkills}">
                                                    <c:set var="searchStr" value=",${skill.skillId}," />
                                                    <c:set var="newIdsStr" value=",${req.newSkillIds}," />
                                                    <c:if test="${newIdsStr.contains(searchStr)}">
                                                        <span class="skill-tag" style="background: #bfdbfe; color: #1e3a8a;">${skill.skillName}</span>
                                                    </c:if>
                                                </c:forEach>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <form method="post" action="${pageContext.request.contextPath}/admin/review-profiles" style="margin-top: 20px;">
                                    <input type="hidden" name="requestId" value="${req.requestId}">
<div style="margin-top: 15px; text-align: left;">
        <label style="font-size: 13px; font-weight: 600; color: #64748b;">Review Note (Optional):</label>
        <textarea name="reviewNote" rows="2" style="width: 100%; border: 1px solid #e2e8f0; border-radius: 8px; padding: 8px; margin-top: 5px;" placeholder="Leave a comment for the user..."></textarea>
    </div>
                                    <div class="modal-actions">
                                        <button type="button" class="btn-clear" onclick="document.getElementById('modal_${req.requestId}').style.display='none'">Close</button>

                                        <button type="submit" name="action" value="reject" class="btn-action danger" style="width: auto; padding: 10px 20px; margin-left: auto;">
                                            Reject
                                        </button>

                                        <button type="submit" name="action" value="approve" class="btn-action success" style="width: auto; padding: 10px 20px;">
                                            Approve
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                        </c:forEach>

                    <c:if test="${empty pendingRequests}">
                        <tr>
                            <td colspan="5" style="text-align: center; padding: 30px; color: #64748b;">
                                🎉 No pending profile updates at the moment.
                            </td>
                        </tr>
                    </c:if>

                </tbody>
            </table>
        </div>
    </div>
</div>

<jsp:include page="/components/footer.jsp"/>