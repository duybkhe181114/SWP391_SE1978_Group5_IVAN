<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Create Support Request - IVAN</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">

    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', 'Segoe UI', sans-serif; background: #f5f7fa; min-height: 100vh; }

        .page-wrapper { max-width: 800px; margin: 0 auto; padding: 32px 24px; }

        .breadcrumb { display: flex; align-items: center; gap: 8px; font-size: 13px; color: #94a3b8; margin-bottom: 24px; }
        .breadcrumb a { color: #6366f1; text-decoration: none; font-weight: 500; }
        .breadcrumb a:hover { text-decoration: underline; }
        .breadcrumb span.sep { color: #cbd5e1; }

        .form-card {
            background: #fff; border-radius: 16px; padding: 36px 32px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.04);
        }

        .form-card h1 { font-size: 24px; font-weight: 700; color: #1e293b; margin-bottom: 4px; }
        .form-card > p { color: #64748b; font-size: 14px; margin-bottom: 28px; }

        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 18px; }
        .full-width { grid-column: 1 / -1; }

        .field { margin-bottom: 0; }
        .field label { display: block; font-size: 13px; font-weight: 600; color: #475569; margin-bottom: 6px; }
        .field label .req { color: #ef4444; }

        .field input, .field select, .field textarea {
            width: 100%; padding: 12px 14px; border-radius: 10px; border: 1.5px solid #e2e8f0;
            font-size: 14px; outline: none; transition: all 0.2s; font-family: 'Inter', sans-serif;
            background: #fafbfc;
        }
        .field input:focus, .field select:focus, .field textarea:focus {
            border-color: #6366f1; background: #fff;
            box-shadow: 0 0 0 3px rgba(99,102,241,0.1);
        }
        .field textarea { height: 120px; resize: vertical; }
        .field .error-msg { font-size: 12px; color: #ef4444; margin-top: 4px; display: none; }
        .field input.invalid, .field select.invalid, .field textarea.invalid {
            border-color: #ef4444; box-shadow: 0 0 0 3px rgba(239,68,68,0.08);
        }

        .field .char-count { font-size: 11px; color: #94a3b8; text-align: right; margin-top: 4px; }

        /* FILE UPLOAD */
        .upload-area {
            border: 2px dashed #e2e8f0; border-radius: 12px; padding: 28px;
            text-align: center; color: #94a3b8; transition: all 0.2s; cursor: pointer;
        }
        .upload-area:hover { border-color: #6366f1; background: #f8f9ff; }
        .upload-area svg { width: 32px; height: 32px; margin-bottom: 8px; }
        .upload-area p { font-size: 13px; margin-bottom: 4px; }
        .upload-area .hint { font-size: 11px; color: #cbd5e1; }
        .upload-area input[type="file"] { display: none; }

        /* BUTTONS */
        .button-group { display: flex; gap: 12px; margin-top: 28px; }
        .btn-submit, .btn-cancel {
            padding: 14px 28px; border-radius: 10px; font-weight: 600; font-size: 14px;
            border: none; cursor: pointer; transition: all 0.2s; font-family: 'Inter', sans-serif;
            text-decoration: none; text-align: center;
        }
        .btn-submit {
            flex: 1; background: linear-gradient(135deg, #6366f1, #8b5cf6); color: white;
            box-shadow: 0 4px 14px rgba(99,102,241,0.3);
        }
        .btn-submit:hover { transform: translateY(-1px); box-shadow: 0 6px 20px rgba(99,102,241,0.4); }
        .btn-cancel { background: #f8fafc; border: 1.5px solid #e2e8f0; color: #475569; }
        .btn-cancel:hover { background: #f1f5f9; border-color: #cbd5e1; }

        /* SERVER ERROR */
        .server-error {
            padding: 12px 16px; background: #fef2f2; border: 1px solid #fecaca;
            border-radius: 10px; color: #dc2626; font-size: 14px; margin-bottom: 20px;
            display: flex; align-items: center; gap: 8px;
        }
        .server-error svg { width: 18px; height: 18px; flex-shrink: 0; }

        @media (max-width: 600px) {
            .form-grid { grid-template-columns: 1fr; }
            .form-card { padding: 24px 18px; }
        }
    </style>
</head>
<body>

<%@ include file="/components/header.jsp" %>

<div class="page-wrapper">

    <!-- BREADCRUMB -->
    <div class="breadcrumb">
        <a href="${pageContext.request.contextPath}/home">Home</a>
        <span class="sep">/</span>
        <a href="${pageContext.request.contextPath}/viewSpRequestUser">My Requests</a>
        <span class="sep">/</span>
        <span>Create New</span>
    </div>

    <div class="form-card">
        <h1>Create Support Request</h1>
        <p>Fill in the details below to submit a new support request</p>

        <!-- SERVER ERROR -->
        <c:if test="${not empty error}">
            <div class="server-error">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
                ${error}
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/createSupportRequest" method="post"
              enctype="multipart/form-data" id="sprForm" novalidate onsubmit="return validateForm()">

            <div class="form-grid">

                <!-- Title -->
                <div class="field full-width">
                    <label for="title">Title <span class="req">*</span></label>
                    <input type="text" id="title" name="title" placeholder="Brief title for your request" required
                           value="${param.title}">
                    <div class="error-msg" id="title-err">Title is required</div>
                </div>

                <!-- Category -->
                <div class="field">
                    <label for="categoryId">Category <span class="req">*</span></label>
                    <select id="categoryId" name="categoryId" required>
                        <option value="">-- Select Category --</option>
                        <c:forEach var="cat" items="${categories}">
                            <option value="${cat.categoryId}" ${param.categoryId == cat.categoryId ? 'selected' : ''}>${cat.name}</option>
                        </c:forEach>
                    </select>
                    <div class="error-msg" id="category-err">Please select a category</div>
                </div>

                <!-- Priority -->
                <div class="field">
                    <label for="priority">Priority <span class="req">*</span></label>
                    <select id="priority" name="priority" required>
                        <option value="LOW" ${param.priority == 'LOW' ? 'selected' : ''}>Low</option>
                        <option value="MEDIUM" ${param.priority == 'MEDIUM' ? 'selected' : ''}>Medium</option>
                        <option value="HIGH" ${param.priority == 'HIGH' ? 'selected' : ''}>High</option>
                        <option value="URGENT" ${param.priority == 'URGENT' ? 'selected' : ''}>Urgent</option>
                    </select>
                </div>

                <!-- Location -->
                <div class="field">
                    <label for="location">Location</label>
                    <input type="text" id="location" name="supportLocation" placeholder="e.g. District 1, HCMC"
                           value="${param.supportLocation}">
                </div>

                <!-- Beneficiary -->
                <div class="field">
                    <label for="beneficiary">Beneficiary Name</label>
                    <input type="text" id="beneficiary" name="beneficiaryName" placeholder="Name of beneficiary"
                           value="${param.beneficiaryName}">
                </div>

                <!-- Affected People -->
                <div class="field">
                    <label for="affected">Affected People</label>
                    <input type="number" id="affected" name="affectedPeople" placeholder="0" min="0"
                           value="${param.affectedPeople}">
                </div>

                <!-- Estimated Amount -->
                <div class="field">
                    <label for="amount">Estimated Amount ($)</label>
                    <input type="number" id="amount" name="estimatedAmount" placeholder="0.00" step="0.01" min="0"
                           value="${param.estimatedAmount}">
                </div>

                <!-- Description -->
                <div class="field full-width">
                    <label for="description">Description <span class="req">*</span></label>
                    <textarea id="description" name="description" placeholder="Provide details about the support needed..."
                              required oninput="updateCharCount()">${param.description}</textarea>
                    <div class="char-count"><span id="charCount">0</span> / 2000 characters</div>
                    <div class="error-msg" id="desc-err">Description is required</div>
                </div>

                <!-- Contact -->
                <div class="field">
                    <label for="email">Contact Email</label>
                    <input type="email" id="email" name="contactEmail" placeholder="email@example.com"
                           value="${param.contactEmail}">
                    <div class="error-msg" id="email-err">Enter a valid email</div>
                </div>

                <div class="field">
                    <label for="phone">Contact Phone</label>
                    <input type="tel" id="phone" name="contactPhone" placeholder="0123 456 789"
                           value="${param.contactPhone}">
                </div>

                <!-- Proof Image -->
                <div class="field full-width">
                    <label>Proof Image (optional)</label>
                    <div class="upload-area" onclick="document.getElementById('proofFile').click()">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/></svg>
                        <p id="fileName">Click to upload an image</p>
                        <span class="hint">JPG, PNG up to 5MB</span>
                        <input type="file" id="proofFile" name="proofImage" accept="image/*" onchange="showFileName(this)">
                    </div>
                </div>

            </div>

            <div class="button-group">
                <button type="submit" class="btn-submit">Submit Request</button>
                <a href="${pageContext.request.contextPath}/viewSpRequestUser" class="btn-cancel">Cancel</a>
            </div>
        </form>
    </div>
</div>

<script>
    function validateForm() {
        var valid = true;
        clearErrors();

        var title = document.getElementById('title');
        if (!title.value.trim()) { showError('title', 'title-err'); valid = false; }

        var cat = document.getElementById('categoryId');
        if (!cat.value) { showError('categoryId', 'category-err'); valid = false; }

        var desc = document.getElementById('description');
        if (!desc.value.trim()) { showError('description', 'desc-err'); valid = false; }

        var email = document.getElementById('email');
        if (email.value.trim() && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email.value)) {
            showError('email', 'email-err'); valid = false;
        }

        return valid;
    }

    function showError(inputId, msgId) {
        document.getElementById(inputId).classList.add('invalid');
        document.getElementById(msgId).style.display = 'block';
    }

    function clearErrors() {
        document.querySelectorAll('.invalid').forEach(function(el) { el.classList.remove('invalid'); });
        document.querySelectorAll('.error-msg').forEach(function(el) { el.style.display = 'none'; });
    }

    function updateCharCount() {
        var len = document.getElementById('description').value.length;
        document.getElementById('charCount').textContent = len;
    }

    function showFileName(input) {
        document.getElementById('fileName').textContent = input.files[0] ? input.files[0].name : 'Click to upload an image';
    }

    // Init char count
    updateCharCount();
</script>

</body>
</html>