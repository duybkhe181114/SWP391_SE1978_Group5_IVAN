<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="/components/header.jsp"/>

<style>
    .org-profile-page {
        max-width: 1180px;
        margin: 0 auto;
        padding: 32px 24px 56px;
    }

    .org-hero {
        display: grid;
        grid-template-columns: minmax(0, 1.8fr) minmax(280px, 0.9fr);
        gap: 20px;
        padding: 28px;
        border-radius: 24px;
        background:
            radial-gradient(circle at top left, rgba(245, 158, 11, 0.18), transparent 32%),
            linear-gradient(135deg, #0f172a 0%, #1e293b 52%, #334155 100%);
        color: #f8fafc;
        box-shadow: 0 24px 70px rgba(15, 23, 42, 0.24);
    }

    .org-eyebrow {
        display: inline-flex;
        align-items: center;
        gap: 8px;
        padding: 8px 14px;
        border-radius: 999px;
        background: rgba(255, 255, 255, 0.12);
        color: #fde68a;
        font-size: 12px;
        font-weight: 700;
        letter-spacing: 0.12em;
        text-transform: uppercase;
    }

    .org-hero h1 {
        margin: 16px 0 10px;
        font-size: clamp(30px, 4vw, 44px);
        line-height: 1.05;
    }

    .org-hero p {
        margin: 0;
        max-width: 720px;
        color: rgba(248, 250, 252, 0.82);
        font-size: 15px;
        line-height: 1.7;
    }

    .org-meta-card {
        display: grid;
        gap: 14px;
        align-content: start;
        padding: 22px;
        border-radius: 20px;
        background: rgba(255, 255, 255, 0.08);
        border: 1px solid rgba(255, 255, 255, 0.14);
    }

    .status-badge {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        width: fit-content;
        padding: 8px 14px;
        border-radius: 999px;
        font-size: 12px;
        font-weight: 700;
        letter-spacing: 0.08em;
        text-transform: uppercase;
    }

    .status-approved {
        background: rgba(34, 197, 94, 0.18);
        color: #bbf7d0;
    }

    .status-pending {
        background: rgba(245, 158, 11, 0.18);
        color: #fde68a;
    }

    .status-rejected {
        background: rgba(239, 68, 68, 0.18);
        color: #fecaca;
    }

    .status-default {
        background: rgba(148, 163, 184, 0.18);
        color: #e2e8f0;
    }

    .meta-item {
        padding-top: 14px;
        border-top: 1px solid rgba(255, 255, 255, 0.14);
    }

    .meta-label {
        display: block;
        margin-bottom: 4px;
        color: rgba(226, 232, 240, 0.72);
        font-size: 12px;
        text-transform: uppercase;
        letter-spacing: 0.08em;
    }

    .meta-value {
        color: #f8fafc;
        font-size: 15px;
        font-weight: 600;
        line-height: 1.5;
    }

    .message-stack {
        display: grid;
        gap: 12px;
        margin: 22px 0 0;
    }

    .page-message {
        padding: 16px 18px;
        border-radius: 14px;
        border: 1px solid transparent;
        font-size: 14px;
        line-height: 1.6;
    }

    .message-success {
        background: #ecfdf5;
        border-color: #a7f3d0;
        color: #166534;
    }

    .message-info {
        background: #eff6ff;
        border-color: #bfdbfe;
        color: #1d4ed8;
    }

    .message-error {
        background: #fef2f2;
        border-color: #fecaca;
        color: #b91c1c;
    }

    .message-warning {
        background: #fff7ed;
        border-color: #fed7aa;
        color: #c2410c;
    }

    .org-actions {
        display: flex;
        flex-wrap: wrap;
        gap: 12px;
        margin-top: 18px;
    }

    .org-btn {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        padding: 12px 18px;
        border-radius: 12px;
        border: 1px solid transparent;
        text-decoration: none;
        font-weight: 700;
        font-size: 14px;
        transition: transform 0.2s ease, box-shadow 0.2s ease, border-color 0.2s ease;
        cursor: pointer;
    }

    .org-btn:hover {
        transform: translateY(-1px);
    }

    .org-btn-primary {
        background: #0f172a;
        color: #f8fafc;
        box-shadow: 0 12px 30px rgba(15, 23, 42, 0.14);
    }

    .org-btn-secondary {
        background: #ffffff;
        color: #0f172a;
        border-color: #dbe4f0;
    }

    .org-grid {
        display: grid;
        grid-template-columns: repeat(12, minmax(0, 1fr));
        gap: 20px;
        margin-top: 26px;
    }

    .org-card {
        grid-column: span 6;
        padding: 24px;
        background: #ffffff;
        border: 1px solid #e2e8f0;
        border-radius: 20px;
        box-shadow: 0 12px 32px rgba(15, 23, 42, 0.06);
    }

    .org-card-wide {
        grid-column: span 12;
    }

    .org-card h2 {
        margin: 0 0 18px;
        color: #0f172a;
        font-size: 18px;
    }

    .field-grid {
        display: grid;
        grid-template-columns: repeat(2, minmax(0, 1fr));
        gap: 16px;
    }

    .field {
        display: grid;
        gap: 6px;
    }

    .field-wide {
        grid-column: 1 / -1;
    }

    .field-label {
        font-size: 12px;
        font-weight: 700;
        letter-spacing: 0.08em;
        text-transform: uppercase;
        color: #64748b;
    }

    .field-value {
        min-height: 48px;
        padding: 13px 14px;
        border-radius: 12px;
        border: 1px solid #e2e8f0;
        background: #f8fafc;
        color: #0f172a;
        line-height: 1.6;
        overflow-wrap: anywhere;
        word-break: break-word;
        white-space: normal;
    }

    .field-value-empty {
        color: #94a3b8;
        font-style: italic;
    }

    .stats-strip {
        display: grid;
        grid-template-columns: repeat(3, minmax(0, 1fr));
        gap: 14px;
    }

    .stat-box {
        padding: 18px;
        border-radius: 16px;
        background: linear-gradient(180deg, #fff7ed 0%, #ffffff 100%);
        border: 1px solid #fed7aa;
    }

    .stat-box strong {
        display: block;
        margin-bottom: 6px;
        color: #9a3412;
        font-size: 12px;
        letter-spacing: 0.08em;
        text-transform: uppercase;
    }

    .stat-box span {
        color: #7c2d12;
        font-size: 28px;
        font-weight: 800;
    }

    .org-form {
        display: grid;
        gap: 22px;
    }

    .form-section {
        padding: 22px;
        border: 1px solid #e2e8f0;
        border-radius: 18px;
        background: #ffffff;
    }

    .form-section h2 {
        margin: 0 0 18px;
        font-size: 18px;
        color: #0f172a;
    }

    .form-grid {
        display: grid;
        grid-template-columns: repeat(2, minmax(0, 1fr));
        gap: 16px;
    }

    .form-group {
        display: grid;
        gap: 8px;
    }

    .form-group-wide {
        grid-column: 1 / -1;
    }

    .form-group label {
        font-size: 12px;
        font-weight: 700;
        letter-spacing: 0.08em;
        text-transform: uppercase;
        color: #475569;
    }

    .form-group input,
    .form-group select,
    .form-group textarea {
        width: 100%;
        padding: 13px 14px;
        border-radius: 12px;
        border: 1px solid #cbd5e1;
        background: #ffffff;
        color: #0f172a;
        font: inherit;
        box-sizing: border-box;
    }

    .form-group textarea {
        min-height: 140px;
        resize: vertical;
        line-height: 1.6;
    }

    .form-actions {
        display: flex;
        justify-content: flex-end;
        gap: 12px;
        margin-top: 6px;
    }

    @media (max-width: 960px) {
        .org-hero,
        .org-card,
        .org-card-wide {
            grid-template-columns: 1fr;
            grid-column: span 12;
        }

        .field-grid,
        .form-grid,
        .stats-strip {
            grid-template-columns: 1fr;
        }
    }
</style>

<div class="admin-page">
    <div class="org-profile-page">
        <section class="org-hero">
            <div>
                <span class="org-eyebrow">Organization Profile</span>
                <h1>
                    <c:choose>
                        <c:when test="${not empty profile.organizationName}">
                            ${profile.organizationName}
                        </c:when>
                        <c:otherwise>
                            Organization account
                        </c:otherwise>
                    </c:choose>
                </h1>
                <p>
                    Manage the legal, representative, and contact information used for organization review and public organization data.
                </p>

                <div class="org-actions">
                    <a class="org-btn org-btn-secondary" href="${pageContext.request.contextPath}/organization/dashboard">Back to Dashboard</a>
                    <c:choose>
                        <c:when test="${param.action == 'edit' and not hasPendingUpdateRequest}">
                            <a class="org-btn org-btn-secondary" href="${pageContext.request.contextPath}/organization/profile">Cancel Editing</a>
                        </c:when>
                        <c:when test="${hasPendingUpdateRequest}">
                            <span class="org-btn org-btn-secondary" style="opacity: 0.65; cursor: not-allowed;">Update Request Pending</span>
                        </c:when>
                        <c:otherwise>
                            <a class="org-btn org-btn-primary" href="${pageContext.request.contextPath}/organization/profile?action=edit">Edit Organization Profile</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <aside class="org-meta-card">
                <c:choose>
                    <c:when test="${profile.approvalStatus == 'Approved'}">
                        <span class="status-badge status-approved">Approved</span>
                    </c:when>
                    <c:when test="${profile.approvalStatus == 'Pending'}">
                        <span class="status-badge status-pending">Pending Review</span>
                    </c:when>
                    <c:when test="${profile.approvalStatus == 'Rejected'}">
                        <span class="status-badge status-rejected">Rejected</span>
                    </c:when>
                    <c:otherwise>
                        <span class="status-badge status-default">Unknown Status</span>
                    </c:otherwise>
                </c:choose>

                <div class="meta-item">
                    <span class="meta-label">Account Email</span>
                    <span class="meta-value">${profile.email}</span>
                </div>

                <div class="meta-item">
                    <span class="meta-label">Representative</span>
                    <span class="meta-value">
                        <c:choose>
                            <c:when test="${not empty profile.representativeName}">
                                ${profile.representativeName}
                            </c:when>
                            <c:otherwise>
                                Not provided
                            </c:otherwise>
                        </c:choose>
                    </span>
                </div>

                <div class="meta-item">
                    <span class="meta-label">Organization Record</span>
                    <span class="meta-value">
                        <c:choose>
                            <c:when test="${not empty profile.organizationId}">
                                Available in Organizations table
                            </c:when>
                            <c:otherwise>
                                Not created yet
                            </c:otherwise>
                        </c:choose>
                    </span>
                </div>
            </aside>
        </section>

        <div class="message-stack">
            <c:if test="${param.success == '1'}">
                <div class="page-message message-success">
                    Organization profile update request submitted successfully. Your current live profile stays unchanged until an admin approves the request.
                </div>
            </c:if>

            <c:if test="${not empty error}">
                <div class="page-message message-error">${error}</div>
            </c:if>

            <c:if test="${hasPendingUpdateRequest}">
                <div class="page-message message-info">
                    There is a pending organization profile update request waiting for admin review. Editing is locked until that request is approved or rejected.
                </div>
            </c:if>

            <c:if test="${not empty latestUpdateRequest and latestUpdateRequest.status == 'Rejected' and not empty latestUpdateRequest.reviewNote}">
                <div class="page-message message-warning">
                    <strong>Last update request note:</strong> ${latestUpdateRequest.reviewNote}
                </div>
            </c:if>

            <c:if test="${empty profile.organizationId}">
                <div class="page-message message-warning">
                    This account does not have a linked row in <code>Organizations</code> yet. Event creation and other organization-facing features that rely on that table may remain unavailable until the organization record exists.
                </div>
            </c:if>
        </div>

        <c:choose>
            <c:when test="${param.action == 'edit' and not hasPendingUpdateRequest}">
                <form class="org-form" method="post" action="${pageContext.request.contextPath}/organization/profile">
                    <section class="form-section">
                        <h2>Organization Details</h2>
                        <div class="form-grid">
                            <div class="form-group form-group-wide">
                                <label>Organization Name</label>
                                <input type="text" name="organizationName" value="${profile.organizationName}" required>
                            </div>

                            <div class="form-group">
                                <label>Organization Type</label>
                                <select name="organizationType" required>
                                    <option value="">Select type</option>
                                    <option value="NGO" ${profile.organizationType == 'NGO' ? 'selected' : ''}>NGO</option>
                                    <option value="Non-profit" ${profile.organizationType == 'Non-profit' ? 'selected' : ''}>Non-profit</option>
                                    <option value="Social Enterprise" ${profile.organizationType == 'Social Enterprise' ? 'selected' : ''}>Social Enterprise</option>
                                    <option value="Community Group" ${profile.organizationType == 'Community Group' ? 'selected' : ''}>Community Group</option>
                                    <option value="Government Agency" ${profile.organizationType == 'Government Agency' ? 'selected' : ''}>Government Agency</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label>Established Year</label>
                                <input type="number" name="establishedYear" min="1900" max="2100" value="${profile.establishedYear}">
                            </div>

                            <div class="form-group">
                                <label>Tax Code</label>
                                <input type="text" name="taxCode" value="${profile.taxCode}">
                            </div>

                            <div class="form-group">
                                <label>Business License Number</label>
                                <input type="text" name="businessLicense" value="${profile.businessLicense}">
                            </div>
                        </div>
                    </section>

                    <section class="form-section">
                        <h2>Representative</h2>
                        <div class="form-grid">
                            <div class="form-group">
                                <label>Representative Name</label>
                                <input type="text" name="representativeName" value="${profile.representativeName}" required>
                            </div>

                            <div class="form-group">
                                <label>Representative Position</label>
                                <input type="text" name="representativePosition" value="${profile.representativePosition}" required>
                            </div>
                        </div>
                    </section>

                    <section class="form-section">
                        <h2>Contact and Presence</h2>
                        <div class="form-grid">
                            <div class="form-group">
                                <label>Phone</label>
                                <input type="text" name="phone" value="${profile.phone}" required>
                            </div>

                            <div class="form-group">
                                <label>Website</label>
                                <input type="url" name="website" value="${profile.website}">
                            </div>

                            <div class="form-group form-group-wide">
                                <label>Address</label>
                                <input type="text" name="address" value="${profile.address}" required>
                            </div>

                            <div class="form-group form-group-wide">
                                <label>Facebook Page</label>
                                <input type="url" name="facebookPage" value="${profile.facebookPage}">
                            </div>
                        </div>
                    </section>

                    <section class="form-section">
                        <h2>About the Organization</h2>
                        <div class="form-grid">
                            <div class="form-group form-group-wide">
                                <label>Description</label>
                                <textarea name="description" required>${profile.description}</textarea>
                            </div>
                        </div>
                    </section>

                    <div class="form-actions">
                        <a class="org-btn org-btn-secondary" href="${pageContext.request.contextPath}/organization/profile">Cancel</a>
                        <button class="org-btn org-btn-primary" type="submit">Submit Update Request</button>
                    </div>
                </form>
            </c:when>

            <c:otherwise>
                <div class="org-grid">
                    <section class="org-card">
                        <h2>Organization Summary</h2>
                        <div class="field-grid">
                            <div class="field">
                                <span class="field-label">Organization Name</span>
                                <div class="field-value ${empty profile.organizationName ? 'field-value-empty' : ''}">
                                    ${empty profile.organizationName ? 'Not provided' : profile.organizationName}
                                </div>
                            </div>

                            <div class="field">
                                <span class="field-label">Organization Type</span>
                                <div class="field-value ${empty profile.organizationType ? 'field-value-empty' : ''}">
                                    ${empty profile.organizationType ? 'Not provided' : profile.organizationType}
                                </div>
                            </div>

                            <div class="field">
                                <span class="field-label">Established Year</span>
                                <div class="field-value ${empty profile.establishedYear ? 'field-value-empty' : ''}">
                                    ${empty profile.establishedYear ? 'Not provided' : profile.establishedYear}
                                </div>
                            </div>

                            <div class="field">
                                <span class="field-label">Current Review Status</span>
                                <div class="field-value ${empty profile.approvalStatus ? 'field-value-empty' : ''}">
                                    ${empty profile.approvalStatus ? 'Not provided' : profile.approvalStatus}
                                </div>
                            </div>
                        </div>
                    </section>

                    <section class="org-card">
                        <h2>Representative and Contact</h2>
                        <div class="field-grid">
                            <div class="field">
                                <span class="field-label">Representative Name</span>
                                <div class="field-value ${empty profile.representativeName ? 'field-value-empty' : ''}">
                                    ${empty profile.representativeName ? 'Not provided' : profile.representativeName}
                                </div>
                            </div>

                            <div class="field">
                                <span class="field-label">Position</span>
                                <div class="field-value ${empty profile.representativePosition ? 'field-value-empty' : ''}">
                                    ${empty profile.representativePosition ? 'Not provided' : profile.representativePosition}
                                </div>
                            </div>

                            <div class="field">
                                <span class="field-label">Email</span>
                                <div class="field-value ${empty profile.email ? 'field-value-empty' : ''}">
                                    ${empty profile.email ? 'Not provided' : profile.email}
                                </div>
                            </div>

                            <div class="field">
                                <span class="field-label">Phone</span>
                                <div class="field-value ${empty profile.phone ? 'field-value-empty' : ''}">
                                    ${empty profile.phone ? 'Not provided' : profile.phone}
                                </div>
                            </div>

                            <div class="field field-wide">
                                <span class="field-label">Address</span>
                                <div class="field-value ${empty profile.address ? 'field-value-empty' : ''}">
                                    ${empty profile.address ? 'Not provided' : profile.address}
                                </div>
                            </div>

                            <div class="field">
                                <span class="field-label">Website</span>
                                <div class="field-value ${empty profile.website ? 'field-value-empty' : ''}">
                                    ${empty profile.website ? 'Not provided' : profile.website}
                                </div>
                            </div>

                            <div class="field">
                                <span class="field-label">Facebook Page</span>
                                <div class="field-value ${empty profile.facebookPage ? 'field-value-empty' : ''}">
                                    ${empty profile.facebookPage ? 'Not provided' : profile.facebookPage}
                                </div>
                            </div>
                        </div>
                    </section>

                    <section class="org-card">
                        <h2>Compliance and Review</h2>
                        <div class="field-grid">
                            <div class="field">
                                <span class="field-label">Tax Code</span>
                                <div class="field-value ${empty profile.taxCode ? 'field-value-empty' : ''}">
                                    ${empty profile.taxCode ? 'Not provided' : profile.taxCode}
                                </div>
                            </div>

                            <div class="field">
                                <span class="field-label">Business License</span>
                                <div class="field-value ${empty profile.businessLicense ? 'field-value-empty' : ''}">
                                    ${empty profile.businessLicense ? 'Not provided' : profile.businessLicense}
                                </div>
                            </div>

                            <div class="field">
                                <span class="field-label">Reviewed At</span>
                                <div class="field-value ${empty profile.reviewedAt ? 'field-value-empty' : ''}">
                                    <c:choose>
                                        <c:when test="${not empty profile.reviewedAt}">
                                            <fmt:formatDate value="${profile.reviewedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                        </c:when>
                                        <c:otherwise>Not reviewed yet</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="field">
                                <span class="field-label">Last Updated</span>
                                <div class="field-value ${empty profile.updatedAt ? 'field-value-empty' : ''}">
                                    <c:choose>
                                        <c:when test="${not empty profile.updatedAt}">
                                            <fmt:formatDate value="${profile.updatedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                        </c:when>
                                        <c:otherwise>Not recorded</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="field field-wide">
                                <span class="field-label">Admin Review Note</span>
                                <div class="field-value ${empty profile.reviewNote ? 'field-value-empty' : ''}">
                                    ${empty profile.reviewNote ? 'No review note available' : profile.reviewNote}
                                </div>
                            </div>
                        </div>
                    </section>

                    <section class="org-card">
                        <h2>Organization Record</h2>
                        <c:choose>
                            <c:when test="${not empty organizationRecord}">
                                <div class="stats-strip">
                                    <div class="stat-box">
                                        <strong>Organization Record</strong>
                                        <span>${organizationRecord.OrganizationId}</span>
                                    </div>
                                    <div class="stat-box">
                                        <strong>Approved Events</strong>
                                        <span>${organizationStats.totalEvents}</span>
                                    </div>
                                    <div class="stat-box">
                                        <strong>Approved Volunteers</strong>
                                        <span>${organizationStats.totalVolunteers}</span>
                                    </div>
                                </div>

                                <div class="field-grid" style="margin-top: 18px;">
                                    <div class="field field-wide">
                                        <span class="field-label">Organization Name In Events Table</span>
                                        <div class="field-value ${empty organizationRecord.Name ? 'field-value-empty' : ''}">
                                            ${empty organizationRecord.Name ? 'Not provided' : organizationRecord.Name}
                                        </div>
                                    </div>

                                    <div class="field field-wide">
                                        <span class="field-label">Organization Description In Events Table</span>
                                        <div class="field-value ${empty organizationRecord.Description ? 'field-value-empty' : ''}">
                                            ${empty organizationRecord.Description ? 'Not provided' : organizationRecord.Description}
                                        </div>
                                    </div>
                                </div>
                            </c:when>

                            <c:otherwise>
                                <div class="field-value field-value-empty">
                                    No row in the Organizations table is linked to this account yet.
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </section>

                    <section class="org-card org-card-wide">
                        <h2>About the Organization</h2>
                        <div class="field-value ${empty profile.description ? 'field-value-empty' : ''}" style="min-height: 120px;">
                            ${empty profile.description ? 'No description provided yet.' : profile.description}
                        </div>
                    </section>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<jsp:include page="/components/footer.jsp"/>
