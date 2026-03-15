<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Organizations - Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <style>
        body { background: #f8fafc; font-family: 'Segoe UI', sans-serif; }
        .page-shell { max-width: 1440px; margin: 0 auto; padding: 28px 20px 48px; }
        .hero { padding: 28px; border-radius: 24px; color: #f8fafc; background: linear-gradient(135deg, #0f172a 0%, #1e293b 55%, #334155 100%); box-shadow: 0 22px 50px rgba(15, 23, 42, 0.18); }
        .hero-chip { display: inline-flex; padding: 8px 14px; border-radius: 999px; background: rgba(255,255,255,0.12); color: #fde68a; font-size: 12px; font-weight: 700; letter-spacing: 0.08em; text-transform: uppercase; }
        .hero h1 { margin: 14px 0 10px; font-size: clamp(30px, 4vw, 42px); line-height: 1.05; }
        .hero p { max-width: 880px; margin: 0; color: rgba(248, 250, 252, 0.82); line-height: 1.7; }
        .stats-grid { display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 16px; margin-top: 22px; }
        .stat-card { padding: 18px 20px; border-radius: 18px; background: rgba(255,255,255,0.09); border: 1px solid rgba(255,255,255,0.14); }
        .stat-label { font-size: 12px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.08em; color: rgba(226,232,240,0.76); }
        .stat-value { margin-top: 8px; font-size: 30px; font-weight: 800; color: #fff; }
        .alert { margin-top: 18px; padding: 14px 16px; border-radius: 14px; border: 1px solid transparent; font-size: 14px; line-height: 1.6; }
        .alert-success { background: #ecfdf5; border-color: #a7f3d0; color: #166534; }
        .alert-error { background: #fef2f2; border-color: #fecaca; color: #b91c1c; }
        .section { margin-top: 24px; padding: 24px; border: 1px solid #e2e8f0; border-radius: 24px; background: #fff; box-shadow: 0 14px 30px rgba(15, 23, 42, 0.05); }
        .section h2 { margin: 0 0 8px; color: #0f172a; font-size: 24px; }
        .section-note { margin: 0 0 18px; color: #64748b; line-height: 1.6; }
        .toolbar form { display: grid; grid-template-columns: minmax(0, 2fr) minmax(220px, 0.9fr) auto; gap: 14px; align-items: end; }
        .field { display: grid; gap: 8px; }
        .field label { color: #475569; font-size: 13px; font-weight: 700; }
        .field input, .field select, .field textarea, .modal-form input, .modal-form textarea, .modal-form select { width: 100%; box-sizing: border-box; padding: 12px 14px; border: 1px solid #cbd5e1; border-radius: 12px; font: inherit; background: #fff; color: #0f172a; }
        .field textarea, .modal-form textarea { resize: vertical; min-height: 84px; }
        .filter-actions, .card-actions, .modal-actions { display: flex; flex-wrap: wrap; gap: 10px; }
        .btn, .btn-link { display: inline-flex; align-items: center; justify-content: center; padding: 12px 18px; border-radius: 12px; border: 1px solid transparent; text-decoration: none; font-size: 14px; font-weight: 700; cursor: pointer; transition: transform .2s ease; }
        .btn:hover, .btn-link:hover { transform: translateY(-1px); }
        .btn-primary { background: #0f172a; color: #f8fafc; }
        .btn-secondary { background: #eff6ff; color: #1d4ed8; border-color: #bfdbfe; }
        .btn-clear { background: #f8fafc; color: #475569; border-color: #cbd5e1; }
        .btn-success { background: #16a34a; color: #fff; }
        .btn-danger { background: #dc2626; color: #fff; }
        .directory-grid, .queue-grid { display: grid; gap: 18px; }
        .org-card { padding: 22px; border-radius: 20px; border: 1px solid #e2e8f0; background: linear-gradient(180deg, #fff 0%, #f8fafc 100%); }
        .org-top { display: flex; justify-content: space-between; gap: 18px; align-items: start; }
        .org-name { margin: 0; color: #0f172a; font-size: 24px; }
        .org-email { margin-top: 8px; color: #475569; font-size: 14px; }
        .chip-row { display: flex; flex-wrap: wrap; gap: 8px; margin-top: 14px; }
        .chip { display: inline-flex; align-items: center; padding: 7px 12px; border-radius: 999px; font-size: 12px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.05em; }
        .chip-approved { background: #dcfce7; color: #166534; }
        .chip-pending { background: #fff7ed; color: #c2410c; }
        .chip-rejected { background: #fef2f2; color: #b91c1c; }
        .chip-blocked { background: #fee2e2; color: #991b1b; }
        .chip-review { background: #eff6ff; color: #1d4ed8; }
        .chip-neutral { background: #e2e8f0; color: #334155; }
        .summary-grid, .detail-grid { display: grid; grid-template-columns: repeat(4, minmax(0, 1fr)); gap: 14px; margin-top: 18px; }
        .detail-grid { grid-template-columns: repeat(3, minmax(0, 1fr)); }
        .box { padding: 14px 16px; border-radius: 16px; border: 1px solid #e2e8f0; background: #fff; }
        .box-wide { grid-column: 1 / -1; }
        .box-label { color: #64748b; font-size: 12px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.08em; }
        .box-value { margin-top: 6px; color: #0f172a; line-height: 1.6; overflow-wrap: anywhere; word-break: break-word; }
        .details-panel { display: none; margin-top: 18px; padding-top: 18px; border-top: 1px solid #e2e8f0; }
        .empty-state { padding: 42px 20px; border: 1px dashed #cbd5e1; border-radius: 18px; background: #f8fafc; text-align: center; color: #94a3b8; }
        .modal-overlay { display: none; position: fixed; inset: 0; z-index: 40; padding: 24px; overflow-y: auto; background: rgba(15, 23, 42, 0.55); }
        .modal { max-width: 900px; margin: 24px auto; border-radius: 24px; border: 1px solid #e2e8f0; background: #fff; box-shadow: 0 24px 60px rgba(15, 23, 42, 0.2); }
        .modal-header { padding: 24px 24px 16px; border-bottom: 1px solid #e2e8f0; }
        .modal-header h3 { margin: 0; color: #0f172a; font-size: 26px; }
        .modal-header p { margin: 8px 0 0; color: #64748b; line-height: 1.6; }
        .modal-form { padding: 22px 24px 26px; }
        .modal-grid { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 14px; }
        .span-2 { grid-column: 1 / -1; }
        @media (max-width: 1100px) { .stats-grid, .summary-grid, .detail-grid, .modal-grid { grid-template-columns: repeat(2, minmax(0, 1fr)); } .toolbar form { grid-template-columns: 1fr; } }
        @media (max-width: 760px) { .page-shell { padding: 24px 14px 40px; } .stats-grid, .summary-grid, .detail-grid, .modal-grid { grid-template-columns: 1fr; } .org-top, .filter-actions, .card-actions, .modal-actions { flex-direction: column; } }
    </style>
</head>
<body>
<jsp:include page="/components/header.jsp"/>

<div class="page-shell">
    <div class="hero">
        <span class="hero-chip">Admin Panel</span>
        <h1>Manage Organizations</h1>
        <p>Browse every organization account, inspect live profile data, update approved profiles directly, and handle pending registrations or pending profile updates from the same screen.</p>

        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-label">Organizations In Directory</div>
                <div class="stat-value">${fn:length(organizations)}</div>
            </div>
            <div class="stat-card">
                <div class="stat-label">Pending Registrations</div>
                <div class="stat-value">${fn:length(pendingOrganizations)}</div>
            </div>
            <div class="stat-card">
                <div class="stat-label">Pending Profile Updates</div>
                <div class="stat-value">${fn:length(pendingProfileUpdates)}</div>
            </div>
        </div>
    </div>

    <c:if test="${param.success == 'reviewed'}"><div class="alert alert-success">Organization review completed successfully.</div></c:if>
    <c:if test="${param.success == 'updated'}"><div class="alert alert-success">Organization profile updated successfully.</div></c:if>
    <c:if test="${param.error == 'note_required'}"><div class="alert alert-error">Review note is required when rejecting a request.</div></c:if>
    <c:if test="${param.error == 'organization_not_found'}"><div class="alert alert-error">The selected organization could not be found.</div></c:if>
    <c:if test="${param.error == 'organization_not_editable'}"><div class="alert alert-error">Only approved organizations can be edited directly here. Pending or rejected ones must stay in the review queue.</div></c:if>
    <c:if test="${param.error == 'pending_update_exists'}"><div class="alert alert-error">This organization already has a pending profile update request. Review that request before editing the live profile.</div></c:if>
    <c:if test="${param.error == 'update_failed'}"><div class="alert alert-error">The organization profile could not be updated. Please try again.</div></c:if>
    <c:if test="${param.error == 'invalid_request'}"><div class="alert alert-error">The requested organization action was invalid.</div></c:if>

    <div class="section">
        <h2>Organization Directory</h2>
        <p class="section-note">Use the directory to view live organization data. Approved organizations without a pending update request can be edited directly here.</p>

        <div class="toolbar">
            <form method="get" action="${pageContext.request.contextPath}/admin/manage-organizations">
                <div class="field">
                    <label>Search Organizations</label>
                    <input type="text" name="q" value="${param.q}" placeholder="Organization name, representative, email, or phone">
                </div>

                <div class="field">
                    <label>Status</label>
                    <select name="status">
                        <option value="">All</option>
                        <option value="approved" ${param.status == 'approved' ? 'selected' : ''}>Approved</option>
                        <option value="pending" ${param.status == 'pending' ? 'selected' : ''}>Pending Registration</option>
                        <option value="rejected" ${param.status == 'rejected' ? 'selected' : ''}>Rejected</option>
                        <option value="blocked" ${param.status == 'blocked' ? 'selected' : ''}>Blocked Account</option>
                        <option value="pending_update" ${param.status == 'pending_update' ? 'selected' : ''}>Pending Profile Update</option>
                    </select>
                </div>

                <div class="filter-actions">
                    <button type="submit" class="btn btn-primary">Apply Filters</button>
                    <a href="${pageContext.request.contextPath}/admin/manage-organizations" class="btn-link btn-clear">Clear</a>
                </div>
            </form>
        </div>

        <div class="directory-grid">
            <c:choose>
                <c:when test="${empty organizations}">
                    <div class="empty-state">No organizations matched the current filters.</div>
                </c:when>
                <c:otherwise>
                    <c:forEach items="${organizations}" var="org">
                        <div class="org-card">
                            <div class="org-top">
                                <div>
                                    <h3 class="org-name">${not empty org.organizationName ? org.organizationName : org.email}</h3>
                                    <div class="org-email">${org.email}</div>
                                    <div class="chip-row">
                                        <c:choose>
                                            <c:when test="${org.approvalStatus == 'Pending'}"><span class="chip chip-pending">Pending Registration</span></c:when>
                                            <c:when test="${org.approvalStatus == 'Rejected'}"><span class="chip chip-rejected">Rejected</span></c:when>
                                            <c:when test="${not org.isActive}"><span class="chip chip-blocked">Blocked Account</span></c:when>
                                            <c:otherwise><span class="chip chip-approved">Approved</span></c:otherwise>
                                        </c:choose>
                                        <c:if test="${org.pendingUpdateRequestCount > 0}"><span class="chip chip-review">Pending Update Request</span></c:if>
                                        <c:choose>
                                            <c:when test="${not empty org.organizationId}"><span class="chip chip-neutral">Organization Record Linked</span></c:when>
                                            <c:otherwise><span class="chip chip-neutral">No Organization Row</span></c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                                <div style="text-align:right; color:#64748b; font-size:14px;">
                                    <div>Created <fmt:formatDate value="${org.accountCreatedAt}" pattern="dd MMM yyyy"/></div>
                                    <c:if test="${not empty org.reviewedAt}"><div>Reviewed <fmt:formatDate value="${org.reviewedAt}" pattern="dd MMM yyyy HH:mm"/></div></c:if>
                                </div>
                            </div>

                            <div class="summary-grid">
                                <div class="box">
                                    <div class="box-label">Representative</div>
                                    <div class="box-value">${empty org.representativeName ? 'N/A' : org.representativeName}</div>
                                </div>
                                <div class="box">
                                    <div class="box-label">Phone</div>
                                    <div class="box-value">${empty org.phone ? 'N/A' : org.phone}</div>
                                </div>
                                <div class="box">
                                    <div class="box-label">Type</div>
                                    <div class="box-value">${empty org.organizationType ? 'N/A' : org.organizationType}</div>
                                </div>
                                <div class="box">
                                    <div class="box-label">Organization Record</div>
                                    <div class="box-value">${empty org.linkedOrganizationName ? 'Not linked yet' : org.linkedOrganizationName}</div>
                                </div>
                            </div>

                            <div class="card-actions" style="margin-top: 18px;">
                                <button type="button" class="btn btn-secondary" onclick="toggleDetails('details-${org.userId}')">View Details</button>

                                <c:choose>
                                    <c:when test="${org.approvalStatus == 'Approved' and org.pendingUpdateRequestCount == 0}">
                                        <button type="button"
                                                class="btn btn-primary"
                                                data-user-id="${org.userId}"
                                                data-organization-name="${fn:escapeXml(org.organizationName)}"
                                                data-organization-type="${fn:escapeXml(org.organizationType)}"
                                                data-established-year="${org.establishedYear}"
                                                data-tax-code="${fn:escapeXml(org.taxCode)}"
                                                data-business-license="${fn:escapeXml(org.businessLicense)}"
                                                data-representative-name="${fn:escapeXml(org.representativeName)}"
                                                data-representative-position="${fn:escapeXml(org.representativePosition)}"
                                                data-phone="${fn:escapeXml(org.phone)}"
                                                data-address="${fn:escapeXml(org.address)}"
                                                data-website="${fn:escapeXml(org.website)}"
                                                data-facebook-page="${fn:escapeXml(org.facebookPage)}"
                                                data-description="${fn:escapeXml(org.description)}"
                                                onclick="openOrganizationEditModal(this)">
                                            Edit Live Profile
                                        </button>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="#review-queue" class="btn-link btn-clear">Go To Review Queue</a>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div id="details-${org.userId}" class="details-panel">
                                <div class="detail-grid">
                                    <div class="box">
                                        <div class="box-label">Organization Type</div>
                                        <div class="box-value">${empty org.organizationType ? 'N/A' : org.organizationType}</div>
                                    </div>
                                    <div class="box">
                                        <div class="box-label">Established Year</div>
                                        <div class="box-value">${empty org.establishedYear ? 'N/A' : org.establishedYear}</div>
                                    </div>
                                    <div class="box">
                                        <div class="box-label">Representative Position</div>
                                        <div class="box-value">${empty org.representativePosition ? 'N/A' : org.representativePosition}</div>
                                    </div>
                                    <div class="box">
                                        <div class="box-label">Tax Code</div>
                                        <div class="box-value">${empty org.taxCode ? 'N/A' : org.taxCode}</div>
                                    </div>
                                    <div class="box">
                                        <div class="box-label">Business License</div>
                                        <div class="box-value">${empty org.businessLicense ? 'N/A' : org.businessLicense}</div>
                                    </div>
                                    <div class="box">
                                        <div class="box-label">Website</div>
                                        <div class="box-value">${empty org.website ? 'N/A' : org.website}</div>
                                    </div>
                                    <div class="box box-wide">
                                        <div class="box-label">Address</div>
                                        <div class="box-value">${empty org.address ? 'N/A' : org.address}</div>
                                    </div>
                                    <div class="box box-wide">
                                        <div class="box-label">Description</div>
                                        <div class="box-value">${empty org.description ? 'No description provided.' : org.description}</div>
                                    </div>
                                    <div class="box box-wide">
                                        <div class="box-label">Last Review Note</div>
                                        <div class="box-value">${empty org.reviewNote ? 'No review note yet.' : org.reviewNote}</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <div id="review-queue" class="section">
        <h2>Review Queue</h2>
        <p class="section-note">Pending organization registrations and pending profile-update requests are handled here.</p>

        <c:if test="${empty pendingOrganizations and empty pendingProfileUpdates}">
            <div class="empty-state">No pending organization items are waiting for review.</div>
        </c:if>

        <c:if test="${not empty pendingOrganizations}">
            <div class="queue-grid">
                <c:forEach items="${pendingOrganizations}" var="org">
                    <div class="org-card">
                        <h3 class="org-name">${not empty org.organizationName ? org.organizationName : org.email}</h3>
                        <div class="chip-row">
                            <span class="chip chip-pending">New Registration</span>
                            <c:if test="${not empty org.linkedOrganizationName}"><span class="chip chip-neutral">Organization Record Linked</span></c:if>
                        </div>
                        <div class="org-email">Email: ${org.email} | Submitted: <fmt:formatDate value="${org.createdAt}" pattern="dd MMM yyyy HH:mm"/></div>

                        <div class="detail-grid">
                            <div class="box">
                                <div class="box-label">Representative</div>
                                <div class="box-value">${empty org.representativeName ? 'N/A' : org.representativeName}</div>
                            </div>
                            <div class="box">
                                <div class="box-label">Phone</div>
                                <div class="box-value">${empty org.phone ? 'N/A' : org.phone}</div>
                            </div>
                            <div class="box">
                                <div class="box-label">Website</div>
                                <div class="box-value">${empty org.website ? 'N/A' : org.website}</div>
                            </div>
                            <div class="box box-wide">
                                <div class="box-label">Address</div>
                                <div class="box-value">${empty org.address ? 'N/A' : org.address}</div>
                            </div>
                            <div class="box box-wide">
                                <div class="box-label">Description</div>
                                <div class="box-value">${empty org.description ? 'No description provided.' : org.description}</div>
                            </div>
                        </div>

                        <form method="post" action="${pageContext.request.contextPath}/admin/manage-organizations" class="field" style="margin-top: 18px;">
                            <input type="hidden" name="requestType" value="registration">
                            <input type="hidden" name="userId" value="${org.userId}">
                            <label>Review Note</label>
                            <textarea name="reviewNote" placeholder="Optional for approval, required for rejection"></textarea>
                            <div class="card-actions">
                                <button type="submit" name="action" value="approve" class="btn btn-success" onclick="return confirm('Approve this organization registration?')">Approve Registration</button>
                                <button type="submit" name="action" value="reject" class="btn btn-danger" onclick="return confirm('Reject this organization registration?')">Reject Registration</button>
                            </div>
                        </form>
                    </div>
                </c:forEach>
            </div>
        </c:if>

        <c:if test="${not empty pendingProfileUpdates}">
            <div class="queue-grid" style="margin-top: 18px;">
                <c:forEach items="${pendingProfileUpdates}" var="org">
                    <div class="org-card">
                        <h3 class="org-name">${not empty org.organizationName ? org.organizationName : org.email}</h3>
                        <div class="chip-row"><span class="chip chip-review">Profile Update Request</span></div>
                        <div class="org-email">Email: ${org.email} | Requested: <fmt:formatDate value="${org.requestedAt}" pattern="dd MMM yyyy HH:mm"/></div>

                        <div class="detail-grid">
                            <div class="box">
                                <div class="box-label">Representative</div>
                                <div class="box-value">${empty org.representativeName ? 'N/A' : org.representativeName}</div>
                            </div>
                            <div class="box">
                                <div class="box-label">Phone</div>
                                <div class="box-value">${empty org.phone ? 'N/A' : org.phone}</div>
                            </div>
                            <div class="box">
                                <div class="box-label">Website</div>
                                <div class="box-value">${empty org.website ? 'N/A' : org.website}</div>
                            </div>
                            <div class="box box-wide">
                                <div class="box-label">Address</div>
                                <div class="box-value">${empty org.address ? 'N/A' : org.address}</div>
                            </div>
                            <div class="box box-wide">
                                <div class="box-label">Requested Description</div>
                                <div class="box-value">${empty org.description ? 'No description provided.' : org.description}</div>
                            </div>
                        </div>

                        <form method="post" action="${pageContext.request.contextPath}/admin/manage-organizations" class="field" style="margin-top: 18px;">
                            <input type="hidden" name="requestType" value="profile_update">
                            <input type="hidden" name="requestId" value="${org.requestId}">
                            <label>Review Note</label>
                            <textarea name="reviewNote" placeholder="Optional for approval, required for rejection"></textarea>
                            <div class="card-actions">
                                <button type="submit" name="action" value="approve" class="btn btn-success" onclick="return confirm('Approve this organization profile update?')">Approve Update</button>
                                <button type="submit" name="action" value="reject" class="btn btn-danger" onclick="return confirm('Reject this organization profile update?')">Reject Update</button>
                            </div>
                        </form>
                    </div>
                </c:forEach>
            </div>
        </c:if>
    </div>
</div>

<div id="organizationEditModal" class="modal-overlay">
    <div class="modal">
        <div class="modal-header">
            <h3>Edit Organization Profile</h3>
            <p>These changes are applied directly to the live organization profile because the action is performed by an admin.</p>
        </div>

        <form method="post" action="${pageContext.request.contextPath}/admin/manage-organizations" class="modal-form">
            <input type="hidden" name="requestType" value="organization_update">
            <input type="hidden" name="userId" id="editUserId">

            <div class="modal-grid">
                <div class="field span-2">
                    <label>Organization Name</label>
                    <input type="text" name="organizationName" id="editOrganizationName" required>
                </div>
                <div class="field">
                    <label>Organization Type</label>
                    <input type="text" name="organizationType" id="editOrganizationType">
                </div>
                <div class="field">
                    <label>Established Year</label>
                    <input type="number" name="establishedYear" id="editEstablishedYear" min="1900" max="2100">
                </div>
                <div class="field">
                    <label>Tax Code</label>
                    <input type="text" name="taxCode" id="editTaxCode">
                </div>
                <div class="field">
                    <label>Business License</label>
                    <input type="text" name="businessLicense" id="editBusinessLicense">
                </div>
                <div class="field">
                    <label>Representative Name</label>
                    <input type="text" name="representativeName" id="editRepresentativeName" required>
                </div>
                <div class="field">
                    <label>Representative Position</label>
                    <input type="text" name="representativePosition" id="editRepresentativePosition" required>
                </div>
                <div class="field">
                    <label>Phone</label>
                    <input type="text" name="phone" id="editPhone" required>
                </div>
                <div class="field span-2">
                    <label>Address</label>
                    <input type="text" name="address" id="editAddress" required>
                </div>
                <div class="field">
                    <label>Website</label>
                    <input type="text" name="website" id="editWebsite">
                </div>
                <div class="field">
                    <label>Facebook Page</label>
                    <input type="text" name="facebookPage" id="editFacebookPage">
                </div>
                <div class="field span-2">
                    <label>Description</label>
                    <textarea name="description" id="editDescription" required></textarea>
                </div>
                <div class="field span-2">
                    <label>Admin Note</label>
                    <textarea name="reviewNote" id="editReviewNote" placeholder="Optional note describing why this live update was made."></textarea>
                </div>
            </div>

            <div class="modal-actions" style="margin-top: 20px;">
                <button type="button" class="btn-link btn-clear" onclick="closeOrganizationEditModal()">Cancel</button>
                <button type="submit" class="btn btn-primary">Save Organization Profile</button>
            </div>
        </form>
    </div>
</div>

<script>
function toggleDetails(id) {
    const panel = document.getElementById(id);
    if (!panel) {
        return;
    }
    panel.style.display = panel.style.display === "block" ? "none" : "block";
}

function openOrganizationEditModal(button) {
    document.getElementById("editUserId").value = button.dataset.userId || "";
    document.getElementById("editOrganizationName").value = button.dataset.organizationName || "";
    document.getElementById("editOrganizationType").value = button.dataset.organizationType || "";
    document.getElementById("editEstablishedYear").value = button.dataset.establishedYear || "";
    document.getElementById("editTaxCode").value = button.dataset.taxCode || "";
    document.getElementById("editBusinessLicense").value = button.dataset.businessLicense || "";
    document.getElementById("editRepresentativeName").value = button.dataset.representativeName || "";
    document.getElementById("editRepresentativePosition").value = button.dataset.representativePosition || "";
    document.getElementById("editPhone").value = button.dataset.phone || "";
    document.getElementById("editAddress").value = button.dataset.address || "";
    document.getElementById("editWebsite").value = button.dataset.website || "";
    document.getElementById("editFacebookPage").value = button.dataset.facebookPage || "";
    document.getElementById("editDescription").value = button.dataset.description || "";
    document.getElementById("editReviewNote").value = "";
    document.getElementById("organizationEditModal").style.display = "block";
}

function closeOrganizationEditModal() {
    document.getElementById("organizationEditModal").style.display = "none";
}

window.addEventListener("click", function (event) {
    const modal = document.getElementById("organizationEditModal");
    if (event.target === modal) {
        closeOrganizationEditModal();
    }
});
</script>

<jsp:include page="/components/footer.jsp"/>
</body>
</html>
