<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Support Request - IVAN</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <style>
        body { background: #f1f5f9; font-family: 'Inter', 'Segoe UI', sans-serif; margin: 0; }
        .page-wrapper { max-width: 820px; margin: 0 auto; padding: 40px 24px 60px; }
        .page-header { margin-bottom: 32px; }
        .page-header h1 { font-size: 26px; font-weight: 700; color: #1e293b; margin: 0 0 6px; }
        .page-header p { color: #64748b; font-size: 14px; margin: 0; }
        .reject-banner { background: #fef2f2; border: 1px solid #fecaca; border-radius: 12px; padding: 14px 20px; margin-bottom: 24px; font-size: 14px; color: #991b1b; }
        .reject-banner strong { display: block; margin-bottom: 4px; }
        .card { background: white; border-radius: 16px; box-shadow: 0 2px 16px rgba(0,0,0,0.06); overflow: hidden; }
        .section-header { padding: 20px 28px 0; }
        .section-header h3 { font-size: 15px; font-weight: 700; color: #1e293b; margin: 0 0 4px; display: flex; align-items: center; gap: 8px; }
        .section-header p { font-size: 13px; color: #94a3b8; margin: 0 0 16px; }
        .section-divider { height: 1px; background: #f1f5f9; margin: 0 28px; }
        .form-body { padding: 24px 28px; }
        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; font-size: 13px; font-weight: 600; color: #374151; margin-bottom: 6px; }
        .form-group label .req { color: #ef4444; margin-left: 2px; }
        .form-group input, .form-group select, .form-group textarea { width: 100%; padding: 10px 14px; border: 1.5px solid #e2e8f0; border-radius: 8px; font-size: 14px; color: #1e293b; background: #fafafa; transition: border 0.2s, box-shadow 0.2s; box-sizing: border-box; font-family: inherit; }
        .form-group input:focus, .form-group select:focus, .form-group textarea:focus { outline: none; border-color: #6366f1; background: white; box-shadow: 0 0 0 3px rgba(99,102,241,0.12); }
        .form-group input.invalid, .form-group select.invalid, .form-group textarea.invalid { border-color: #ef4444; }
        .form-group textarea { height: 120px; resize: vertical; }
        .field-error { font-size: 12px; color: #ef4444; margin-top: 4px; display: none; }
        .form-actions { display: flex; gap: 12px; justify-content: flex-end; }
        .btn-cancel { padding: 11px 24px; background: white; color: #64748b; border: 1.5px solid #e2e8f0; border-radius: 8px; font-size: 14px; font-weight: 600; cursor: pointer; text-decoration: none; display: inline-flex; align-items: center; transition: all 0.2s; }
        .btn-cancel:hover { background: #f8fafc; }
        .btn-submit { padding: 11px 32px; background: linear-gradient(135deg, #6366f1, #8b5cf6); color: white; border: none; border-radius: 8px; font-size: 14px; font-weight: 600; cursor: pointer; box-shadow: 0 4px 14px rgba(99,102,241,0.3); transition: all 0.2s; }
        .btn-submit:hover { transform: translateY(-1px); }
    </style>
</head>
<body>

<%@ include file="/components/header.jsp" %>

<div class="page-wrapper">
    <div class="page-header">
        <h1>✏️ Edit & Resubmit Request</h1>
        <p>Update your request based on the rejection feedback, then resubmit for review.</p>
    </div>

    <c:if test="${not empty sr.rejectReason}">
        <div class="reject-banner">
            <strong>❌ Rejection Reason:</strong>
            ${sr.rejectReason}
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/editSupportRequest" method="post" id="editForm" novalidate>
        <input type="hidden" name="requestId" value="${sr.requestId}">

        <!-- SECTION 1 -->
        <div class="card" style="margin-bottom: 20px;">
            <div class="section-header">
                <h3>📌 1. Basic Information</h3>
                <p>Describe the situation briefly</p>
            </div>
            <div class="section-divider"></div>
            <div class="form-body">
                <div class="form-group">
                    <label>Request Title <span class="req">*</span></label>
                    <input type="text" name="title" id="title" value="${sr.title}" maxlength="200">
                    <div class="field-error" id="titleErr">Title is required</div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Type of Support <span class="req">*</span></label>
                        <select name="categoryId" id="categoryId">
                            <option value="">-- Select Support Type --</option>
                            <c:forEach var="cat" items="${categories}">
                                <option value="${cat.categoryId}" ${sr.categoryId == cat.categoryId ? 'selected' : ''}>${cat.name}</option>
                            </c:forEach>
                        </select>
                        <div class="field-error" id="categoryErr">Please select a support type</div>
                    </div>
                    <div class="form-group">
                        <label>Urgency Level <span class="req">*</span></label>
                        <select name="priority" id="priority">
                            <option value="">-- Select Priority --</option>
                            <option value="LOW"    ${sr.priority == 'LOW'    ? 'selected' : ''}>🟢 Low</option>
                            <option value="MEDIUM" ${sr.priority == 'MEDIUM' ? 'selected' : ''}>🟡 Medium</option>
                            <option value="HIGH"   ${sr.priority == 'HIGH'   ? 'selected' : ''}>🔴 High</option>
                            <option value="URGENT" ${sr.priority == 'URGENT' ? 'selected' : ''}>🚨 Urgent</option>
                        </select>
                        <div class="field-error" id="priorityErr">Please select urgency level</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- SECTION 2 -->
        <div class="card" style="margin-bottom: 20px;">
            <div class="section-header">
                <h3>📍 2. Support Details</h3>
                <p>Tell us more about who needs help and where</p>
            </div>
            <div class="section-divider"></div>
            <div class="form-body">
                <div class="form-row">
                    <div class="form-group">
                        <label>Location <span class="req">*</span></label>
                        <input type="text" name="supportLocation" id="supportLocation" value="${sr.supportLocation}">
                        <div class="field-error" id="locationErr">Location is required</div>
                    </div>
                    <div class="form-group">
                        <label>Beneficiary Name <span class="req">*</span></label>
                        <input type="text" name="beneficiaryName" id="beneficiaryName" value="${sr.beneficiaryName}">
                        <div class="field-error" id="beneficiaryErr">Beneficiary name is required</div>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Number of People Affected</label>
                        <input type="number" name="affectedPeople" id="affectedPeople" min="1" value="${sr.affectedPeople}">
                        <div class="field-error" id="affectedErr">Must be a positive number</div>
                    </div>
                    <div class="form-group">
                        <label>Estimated Amount Needed (VND)</label>
                        <input type="number" name="estimatedAmount" id="estimatedAmount" min="0" value="${sr.estimatedAmount}">
                        <div class="field-error" id="amountErr">Must be a positive number</div>
                    </div>
                </div>
                <div class="form-group">
                    <label>Detailed Description <span class="req">*</span></label>
                    <textarea name="description" id="description">${sr.description}</textarea>
                    <div class="field-error" id="descErr">Description is required (min 20 characters)</div>
                </div>
            </div>
        </div>

        <!-- SECTION 3 -->
        <div class="card" style="margin-bottom: 20px;">
            <div class="section-header">
                <h3>📞 3. Contact Information</h3>
                <p>How can we reach you about this request?</p>
            </div>
            <div class="section-divider"></div>
            <div class="form-body">
                <div class="form-row">
                    <div class="form-group">
                        <label>Email <span class="req">*</span></label>
                        <input type="email" name="contactEmail" id="contactEmail" value="${sr.contactEmail}">
                        <div class="field-error" id="emailErr">Please enter a valid email</div>
                    </div>
                    <div class="form-group">
                        <label>Phone Number</label>
                        <input type="text" name="contactPhone" id="contactPhone" value="${sr.contactPhone}">
                        <div class="field-error" id="phoneErr">Phone number format is invalid</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- ACTIONS -->
        <div class="card">
            <div class="form-body">
                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/viewSpRequestUser" class="btn-cancel">Cancel</a>
                    <button type="submit" class="btn-submit">🔄 Save & Resubmit →</button>
                </div>
            </div>
        </div>

    </form>
</div>

<script>
    function markInvalid(id, errId, show) {
        const el = document.getElementById(id);
        const err = document.getElementById(errId);
        if (el) el.classList.toggle('invalid', show);
        if (err) err.style.display = show ? 'block' : 'none';
    }

    document.getElementById('editForm').addEventListener('submit', function(e) {
        let valid = true;
        const title       = document.getElementById('title').value.trim();
        const category    = document.getElementById('categoryId').value;
        const priority    = document.getElementById('priority').value;
        const location    = document.getElementById('supportLocation').value.trim();
        const beneficiary = document.getElementById('beneficiaryName').value.trim();
        const description = document.getElementById('description').value.trim();
        const email       = document.getElementById('contactEmail').value.trim();
        const affected    = document.getElementById('affectedPeople').value;
        const amount      = document.getElementById('estimatedAmount').value;
        const phone       = document.getElementById('contactPhone').value.trim();

        markInvalid('title',          'titleErr',      !title);                    if (!title) valid = false;
        markInvalid('categoryId',     'categoryErr',   !category);                 if (!category) valid = false;
        markInvalid('priority',       'priorityErr',   !priority);                 if (!priority) valid = false;
        markInvalid('supportLocation','locationErr',   !location);                 if (!location) valid = false;
        markInvalid('beneficiaryName','beneficiaryErr',!beneficiary);              if (!beneficiary) valid = false;
        markInvalid('description',    'descErr',       description.length < 20);   if (description.length < 20) valid = false;

        const emailOk = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
        markInvalid('contactEmail', 'emailErr', !emailOk); if (!emailOk) valid = false;

        if (affected && (isNaN(affected) || parseInt(affected) < 1)) { markInvalid('affectedPeople','affectedErr',true); valid = false; }
        else markInvalid('affectedPeople','affectedErr',false);

        if (amount && (isNaN(amount) || parseFloat(amount) < 0)) { markInvalid('estimatedAmount','amountErr',true); valid = false; }
        else markInvalid('estimatedAmount','amountErr',false);

        if (phone && !/^[0-9+\-\s]{7,15}$/.test(phone)) { markInvalid('contactPhone','phoneErr',true); valid = false; }
        else markInvalid('contactPhone','phoneErr',false);

        if (!valid) e.preventDefault();
    });
</script>
</body>
</html>
