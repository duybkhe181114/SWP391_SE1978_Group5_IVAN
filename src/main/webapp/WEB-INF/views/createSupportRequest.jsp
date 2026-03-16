<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Submit Support Request - IVAN</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <style>
        body { background: #f1f5f9; font-family: 'Inter', 'Segoe UI', sans-serif; margin: 0; }
        .page-wrapper { max-width: 820px; margin: 0 auto; padding: 40px 24px 60px; }

        .page-header { margin-bottom: 32px; }
        .page-header h1 { font-size: 26px; font-weight: 700; color: #1e293b; margin: 0 0 6px; }
        .page-header p { color: #64748b; font-size: 14px; margin: 0; }

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
        .form-group input,
        .form-group select,
        .form-group textarea { width: 100%; padding: 10px 14px; border: 1.5px solid #e2e8f0; border-radius: 8px; font-size: 14px; color: #1e293b; background: #fafafa; transition: border 0.2s, box-shadow 0.2s; box-sizing: border-box; font-family: inherit; }
        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus { outline: none; border-color: #6366f1; background: white; box-shadow: 0 0 0 3px rgba(99,102,241,0.12); }
        .form-group input.invalid,
        .form-group select.invalid,
        .form-group textarea.invalid { border-color: #ef4444; box-shadow: 0 0 0 3px rgba(239,68,68,0.1); }
        .form-group textarea { height: 120px; resize: vertical; }
        .field-error { font-size: 12px; color: #ef4444; margin-top: 4px; display: none; }

        .file-upload-area { border: 2px dashed #e2e8f0; border-radius: 10px; padding: 24px; text-align: center; cursor: pointer; transition: border 0.2s; background: #fafafa; }
        .file-upload-area:hover { border-color: #6366f1; background: #f5f3ff; }
        .file-upload-area input[type=file] { display: none; }
        .file-upload-area .upload-icon { font-size: 32px; margin-bottom: 8px; }
        .file-upload-area p { font-size: 13px; color: #64748b; margin: 0; }
        .file-upload-area .file-name { font-size: 13px; color: #6366f1; font-weight: 600; margin-top: 6px; }

        .confirm-box { display: flex; align-items: flex-start; gap: 10px; padding: 16px; background: #f8fafc; border-radius: 10px; border: 1.5px solid #e2e8f0; margin-bottom: 24px; }
        .confirm-box input[type=checkbox] { width: 16px; height: 16px; margin-top: 2px; flex-shrink: 0; accent-color: #6366f1; }
        .confirm-box span { font-size: 13px; color: #475569; line-height: 1.5; }

        .form-actions { display: flex; gap: 12px; justify-content: flex-end; }
        .btn-cancel { padding: 11px 24px; background: white; color: #64748b; border: 1.5px solid #e2e8f0; border-radius: 8px; font-size: 14px; font-weight: 600; cursor: pointer; text-decoration: none; display: inline-flex; align-items: center; transition: all 0.2s; }
        .btn-cancel:hover { background: #f8fafc; border-color: #cbd5e1; }
        .btn-submit { padding: 11px 32px; background: linear-gradient(135deg, #6366f1, #8b5cf6); color: white; border: none; border-radius: 8px; font-size: 14px; font-weight: 600; cursor: pointer; transition: all 0.2s; box-shadow: 0 4px 14px rgba(99,102,241,0.3); }
        .btn-submit:hover { transform: translateY(-1px); box-shadow: 0 6px 20px rgba(99,102,241,0.4); }

        .step-indicator { display: flex; gap: 0; margin-bottom: 32px; }
        .step { flex: 1; text-align: center; padding: 12px; font-size: 13px; font-weight: 600; color: #94a3b8; border-bottom: 3px solid #e2e8f0; }
        .step.active { color: #6366f1; border-bottom-color: #6366f1; }
    </style>
</head>
<body>

<%@ include file="/components/header.jsp" %>

<div class="page-wrapper">
    <div class="page-header">
        <h1>📋 Submit Support Request</h1>
        <p>Provide accurate information so we can review and connect you with the right support.</p>
    </div>

    <form action="${pageContext.request.contextPath}/createSupportRequest" method="post"
          enctype="multipart/form-data" id="sprForm" novalidate>

        <!-- SECTION 1: Basic Info -->
        <div class="card" style="margin-bottom: 20px;">
            <div class="section-header">
                <h3>📌 1. Basic Information</h3>
                <p>Describe the situation briefly</p>
            </div>
            <div class="section-divider"></div>
            <div class="form-body">
                <div class="form-group">
                    <label>Request Title <span class="req">*</span></label>
                    <input type="text" name="title" id="title" placeholder="Short summary of the situation" maxlength="200">
                    <div class="field-error" id="titleErr">Title is required</div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Type of Support <span class="req">*</span></label>
                        <select name="categoryId" id="categoryId">
                            <option value="">-- Select Support Type --</option>
                            <c:forEach var="c" items="${categories}">
                                <option value="${c.categoryId}">${c.name}</option>
                            </c:forEach>
                        </select>
                        <div class="field-error" id="categoryErr">Please select a support type</div>
                    </div>
                    <div class="form-group">
                        <label>Urgency Level <span class="req">*</span></label>
                        <select name="priority" id="priority">
                            <option value="">-- Select Priority --</option>
                            <option value="LOW">🟢 Low</option>
                            <option value="MEDIUM">🟡 Medium</option>
                            <option value="HIGH">🔴 High</option>
                            <option value="URGENT">🚨 Urgent</option>
                        </select>
                        <div class="field-error" id="priorityErr">Please select urgency level</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- SECTION 2: Support Details -->
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
                        <input type="text" name="supportLocation" id="supportLocation" placeholder="City, district, hospital...">
                        <div class="field-error" id="locationErr">Location is required</div>
                    </div>
                    <div class="form-group">
                        <label>Beneficiary Name <span class="req">*</span></label>
                        <input type="text" name="beneficiaryName" id="beneficiaryName" placeholder="Individual / family / group name">
                        <div class="field-error" id="beneficiaryErr">Beneficiary name is required</div>
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Number of People Affected</label>
                        <input type="number" name="affectedPeople" id="affectedPeople" min="1" placeholder="e.g. 5">
                        <div class="field-error" id="affectedErr">Must be a positive number</div>
                    </div>
                    <div class="form-group">
                        <label>Estimated Amount Needed (VND)</label>
                        <input type="number" name="estimatedAmount" id="estimatedAmount" min="0" placeholder="e.g. 5000000">
                        <div class="field-error" id="amountErr">Must be a positive number</div>
                    </div>
                </div>
                <div class="form-group">
                    <label>Detailed Description <span class="req">*</span></label>
                    <textarea name="description" id="description" placeholder="Describe the situation clearly — what happened, who is affected, what kind of support is needed..."></textarea>
                    <div class="field-error" id="descErr">Description is required (min 20 characters)</div>
                </div>
                <div class="form-group">
                    <label>Upload Proof Image (Optional)</label>
                    <div class="file-upload-area" onclick="document.getElementById('proofImage').click()">
                        <div class="upload-icon">📎</div>
                        <p>Click to upload an image (JPG, PNG, max 5MB)</p>
                        <div class="file-name" id="fileName">No file chosen</div>
                        <input type="file" name="proofImage" id="proofImage" accept="image/*"
                               onchange="document.getElementById('fileName').textContent = this.files[0]?.name || 'No file chosen'">
                    </div>
                </div>
            </div>
        </div>

        <!-- SECTION 3: Contact -->
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
                        <input type="email" name="contactEmail" id="contactEmail" placeholder="you@example.com">
                        <div class="field-error" id="emailErr">Please enter a valid email</div>
                    </div>
                    <div class="form-group">
                        <label>Phone Number</label>
                        <input type="text" name="contactPhone" id="contactPhone" placeholder="e.g. 0901234567">
                        <div class="field-error" id="phoneErr">Phone number format is invalid</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- CONFIRM & SUBMIT -->
        <div class="card">
            <div class="form-body">
                <div class="confirm-box">
                    <input type="checkbox" id="confirmCheck">
                    <span>I confirm that all information provided above is accurate and truthful. I understand that false information may result in rejection of this request.</span>
                </div>
                <div class="field-error" id="confirmErr" style="margin-bottom: 16px;">You must confirm the information is accurate</div>
                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/home" class="btn-cancel">Cancel</a>
                    <button type="submit" class="btn-submit">Submit Request →</button>
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

    document.getElementById('sprForm').addEventListener('submit', function(e) {
        let valid = true;

        const title = document.getElementById('title').value.trim();
        const category = document.getElementById('categoryId').value;
        const priority = document.getElementById('priority').value;
        const location = document.getElementById('supportLocation').value.trim();
        const beneficiary = document.getElementById('beneficiaryName').value.trim();
        const description = document.getElementById('description').value.trim();
        const email = document.getElementById('contactEmail').value.trim();
        const affected = document.getElementById('affectedPeople').value;
        const amount = document.getElementById('estimatedAmount').value;
        const phone = document.getElementById('contactPhone').value.trim();
        const confirmed = document.getElementById('confirmCheck').checked;

        markInvalid('title', 'titleErr', !title);
        if (!title) valid = false;

        markInvalid('categoryId', 'categoryErr', !category);
        if (!category) valid = false;

        markInvalid('priority', 'priorityErr', !priority);
        if (!priority) valid = false;

        markInvalid('supportLocation', 'locationErr', !location);
        if (!location) valid = false;

        markInvalid('beneficiaryName', 'beneficiaryErr', !beneficiary);
        if (!beneficiary) valid = false;

        markInvalid('description', 'descErr', description.length < 20);
        if (description.length < 20) valid = false;

        const emailOk = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
        markInvalid('contactEmail', 'emailErr', !emailOk);
        if (!emailOk) valid = false;

        if (affected && (isNaN(affected) || parseInt(affected) < 1)) {
            markInvalid('affectedPeople', 'affectedErr', true); valid = false;
        } else { markInvalid('affectedPeople', 'affectedErr', false); }

        if (amount && (isNaN(amount) || parseFloat(amount) < 0)) {
            markInvalid('estimatedAmount', 'amountErr', true); valid = false;
        } else { markInvalid('estimatedAmount', 'amountErr', false); }

        if (phone && !/^[0-9+\-\s]{7,15}$/.test(phone)) {
            markInvalid('contactPhone', 'phoneErr', true); valid = false;
        } else { markInvalid('contactPhone', 'phoneErr', false); }

        const confirmErr = document.getElementById('confirmErr');
        confirmErr.style.display = !confirmed ? 'block' : 'none';
        if (!confirmed) valid = false;

        if (!valid) e.preventDefault();
    });
</script>
</body>
</html>
