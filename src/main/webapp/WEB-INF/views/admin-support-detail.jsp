<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Support Request Detail - IVAN</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <style>
        body { background: #f1f5f9; font-family: 'Inter', 'Segoe UI', sans-serif; margin: 0; }
        .page-wrapper { max-width: 960px; margin: 0 auto; padding: 40px 24px 60px; }

        /* ===== PAGE HEADER ===== */
        .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 28px; }
        .page-header-left h1 { font-size: 24px; font-weight: 700; color: #1e293b; margin: 0 0 4px; }
        .page-header-left .subtitle { font-size: 13px; color: #64748b; }
        .btn-back { display: inline-flex; align-items: center; gap: 6px; padding: 9px 18px; background: white; color: #475569; border: 1.5px solid #e2e8f0; border-radius: 8px; font-size: 13px; font-weight: 600; text-decoration: none; transition: all 0.2s; }
        .btn-back:hover { background: #f8fafc; border-color: #cbd5e1; }

        /* ===== STATUS BANNER ===== */
        .status-banner { display: flex; align-items: center; gap: 16px; padding: 16px 24px; border-radius: 12px; margin-bottom: 24px; }
        .status-banner.PENDING  { background: #fffbeb; border: 1.5px solid #fde68a; }
        .status-banner.APPROVED { background: #f0fdf4; border: 1.5px solid #bbf7d0; }
        .status-banner.REJECTED { background: #fef2f2; border: 1.5px solid #fecaca; }
        .status-banner.ACCEPTED { background: #eff6ff; border: 1.5px solid #bfdbfe; }
        .status-banner .banner-icon { font-size: 28px; }
        .status-banner .banner-text strong { font-size: 15px; color: #1e293b; display: block; }
        .status-banner .banner-text span { font-size: 13px; color: #64748b; }
        .badge { padding: 5px 14px; border-radius: 20px; font-size: 12px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.4px; display: inline-block; }
        .badge-PENDING  { background: #fef3c7; color: #92400e; }
        .badge-APPROVED { background: #dcfce7; color: #166534; }
        .badge-REJECTED { background: #fee2e2; color: #991b1b; }
        .badge-ACCEPTED { background: #dbeafe; color: #1e40af; }
        .badge-COMPLETED{ background: #ede9fe; color: #5b21b6; }

        /* ===== CARDS ===== */
        .card { background: white; border-radius: 14px; box-shadow: 0 2px 12px rgba(0,0,0,0.05); margin-bottom: 20px; overflow: hidden; }
        .card-header { padding: 18px 24px; border-bottom: 1px solid #f1f5f9; display: flex; align-items: center; gap: 10px; }
        .card-header h3 { font-size: 14px; font-weight: 700; color: #1e293b; margin: 0; text-transform: uppercase; letter-spacing: 0.4px; }
        .card-body { padding: 24px; }

        /* ===== INFO GRID ===== */
        .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .info-item label { font-size: 12px; font-weight: 600; color: #94a3b8; text-transform: uppercase; letter-spacing: 0.4px; display: block; margin-bottom: 4px; }
        .info-item .val { font-size: 14px; color: #1e293b; font-weight: 500; }
        .info-item.full { grid-column: 1 / -1; }

        .description-box { background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 10px; padding: 16px; font-size: 14px; color: #334155; line-height: 1.7; }

        /* ===== PRIORITY ===== */
        .priority-tag { display: inline-flex; align-items: center; gap: 6px; font-size: 13px; font-weight: 600; padding: 4px 12px; border-radius: 20px; }
        .priority-LOW      { background: #f0f9ff; color: #0369a1; }
        .priority-MEDIUM   { background: #fffbeb; color: #b45309; }
        .priority-HIGH     { background: #fef2f2; color: #dc2626; }
        .priority-URGENT   { background: #450a0a; color: #fecaca; }

        /* ===== PROOF IMAGE ===== */
        .proof-img { max-width: 100%; max-height: 320px; border-radius: 10px; border: 1px solid #e2e8f0; display: block; }
        .no-proof { padding: 24px; background: #f8fafc; border-radius: 10px; text-align: center; color: #94a3b8; font-size: 13px; border: 1.5px dashed #e2e8f0; }

        /* ===== REJECT REASON BOX ===== */
        .reject-reason-box { background: #fef2f2; border: 1px solid #fecaca; border-radius: 10px; padding: 16px; }
        .reject-reason-box .rr-label { font-size: 12px; font-weight: 700; color: #991b1b; text-transform: uppercase; letter-spacing: 0.4px; margin-bottom: 6px; }
        .reject-reason-box .rr-text { font-size: 14px; color: #7f1d1d; }

        /* ===== ACTION PANEL ===== */
        .action-panel { background: white; border-radius: 14px; box-shadow: 0 2px 12px rgba(0,0,0,0.05); padding: 24px; }
        .action-panel h3 { font-size: 14px; font-weight: 700; color: #1e293b; margin: 0 0 16px; text-transform: uppercase; letter-spacing: 0.4px; }
        .action-buttons { display: flex; gap: 12px; }
        .btn-approve { padding: 11px 24px; background: linear-gradient(135deg, #22c55e, #16a34a); color: white; border: none; border-radius: 8px; font-size: 14px; font-weight: 600; cursor: pointer; transition: all 0.2s; box-shadow: 0 4px 12px rgba(34,197,94,0.3); }
        .btn-approve:hover { transform: translateY(-1px); box-shadow: 0 6px 16px rgba(34,197,94,0.4); }
        .btn-reject  { padding: 11px 24px; background: white; color: #ef4444; border: 1.5px solid #fca5a5; border-radius: 8px; font-size: 14px; font-weight: 600; cursor: pointer; transition: all 0.2s; }
        .btn-reject:hover { background: #fef2f2; border-color: #ef4444; }
        .btn-accept  { padding: 11px 24px; background: linear-gradient(135deg, #6366f1, #8b5cf6); color: white; border: none; border-radius: 8px; font-size: 14px; font-weight: 600; cursor: pointer; transition: all 0.2s; box-shadow: 0 4px 12px rgba(99,102,241,0.3); }
        .btn-accept:hover { transform: translateY(-1px); box-shadow: 0 6px 16px rgba(99,102,241,0.4); }

        /* ===== REJECT FORM ===== */
        .reject-form-box { margin-top: 16px; padding: 20px; background: #fef2f2; border-radius: 10px; border: 1.5px solid #fecaca; display: none; }
        .reject-form-box label { font-size: 13px; font-weight: 600; color: #991b1b; display: block; margin-bottom: 8px; }
        .reject-form-box textarea { width: 100%; padding: 10px 14px; border: 1.5px solid #fca5a5; border-radius: 8px; font-size: 14px; height: 90px; resize: vertical; box-sizing: border-box; font-family: inherit; background: white; }
        .reject-form-box textarea:focus { outline: none; border-color: #ef4444; }
        .reject-form-box .reject-actions { display: flex; gap: 10px; justify-content: flex-end; margin-top: 12px; }
        .btn-cancel-reject { padding: 9px 18px; background: white; color: #64748b; border: 1.5px solid #e2e8f0; border-radius: 8px; font-size: 13px; font-weight: 600; cursor: pointer; }
        .btn-confirm-reject { padding: 9px 18px; background: #ef4444; color: white; border: none; border-radius: 8px; font-size: 13px; font-weight: 600; cursor: pointer; }
    </style>
</head>
<body>

<%@ include file="/components/header.jsp" %>

<div class="page-wrapper">

    <!-- PAGE HEADER -->
    <div class="page-header">
        <div class="page-header-left">
            <h1>📋 Support Request Detail</h1>
            <div class="subtitle">Request #${requestDetail.requestId}</div>
        </div>
        <c:choose>
            <c:when test="${userRole == 'ADMIN' || userRole == 'Admin'}">
                <a href="${pageContext.request.contextPath}/viewSpRequestAdmin" class="btn-back">← Back to List</a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/viewSpRequestUser" class="btn-back">← Back to My Requests</a>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- STATUS BANNER -->
    <div class="status-banner ${requestDetail.status}">
        <div class="banner-icon">
            <c:choose>
                <c:when test="${requestDetail.status == 'PENDING'}">⏳</c:when>
                <c:when test="${requestDetail.status == 'APPROVED'}">✅</c:when>
                <c:when test="${requestDetail.status == 'REJECTED'}">❌</c:when>
                <c:when test="${requestDetail.status == 'ACCEPTED'}">📋</c:when>
                <c:otherwise>📌</c:otherwise>
            </c:choose>
        </div>
        <div class="banner-text">
            <strong>
                <span class="badge badge-${requestDetail.status}">${requestDetail.status}</span>
            </strong>
            <span>
                <c:choose>
                    <c:when test="${requestDetail.status == 'PENDING'}">Awaiting admin review</c:when>
                    <c:when test="${requestDetail.status == 'APPROVED'}">Approved by admin — visible to organizations</c:when>
                    <c:when test="${requestDetail.status == 'REJECTED'}">Rejected by admin</c:when>
                    <c:when test="${requestDetail.status == 'ACCEPTED'}">Accepted by an organization</c:when>
                    <c:otherwise>${requestDetail.status}</c:otherwise>
                </c:choose>
            </span>
        </div>
    </div>

    <!-- REJECT REASON (nếu bị từ chối) -->
    <c:if test="${requestDetail.status == 'REJECTED' && not empty requestDetail.rejectReason}">
        <div class="reject-reason-box" style="margin-bottom: 20px;">
            <div class="rr-label">❌ Reject Reason</div>
            <div class="rr-text">${requestDetail.rejectReason}</div>
        </div>
    </c:if>

    <!-- BASIC INFO -->
    <div class="card">
        <div class="card-header">
            <span>📌</span>
            <h3>Basic Information</h3>
        </div>
        <div class="card-body">
            <div class="info-grid">
                <div class="info-item full">
                    <label>Title</label>
                    <div class="val" style="font-size:16px; font-weight:700;">${requestDetail.title}</div>
                </div>
                <div class="info-item">
                    <label>Category</label>
                    <div class="val">${not empty requestDetail.categoryName ? requestDetail.categoryName : '—'}</div>
                </div>
                <div class="info-item">
                    <label>Priority</label>
                    <div class="val">
                        <span class="priority-tag priority-${requestDetail.priority}">${requestDetail.priority}</span>
                    </div>
                </div>
                <div class="info-item full">
                    <label>Description</label>
                    <div class="description-box">${requestDetail.description}</div>
                </div>
            </div>
        </div>
    </div>

    <!-- SUPPORT DETAILS -->
    <div class="card">
        <div class="card-header">
            <span>📍</span>
            <h3>Support Details</h3>
        </div>
        <div class="card-body">
            <div class="info-grid">
                <div class="info-item">
                    <label>Location</label>
                    <div class="val">${not empty requestDetail.supportLocation ? requestDetail.supportLocation : '—'}</div>
                </div>
                <div class="info-item">
                    <label>Beneficiary</label>
                    <div class="val">${not empty requestDetail.beneficiaryName ? requestDetail.beneficiaryName : '—'}</div>
                </div>
                <div class="info-item">
                    <label>Affected People</label>
                    <div class="val">
                        <c:choose>
                            <c:when test="${requestDetail.affectedPeople != null && requestDetail.affectedPeople > 0}">
                                ${requestDetail.affectedPeople} people
                            </c:when>
                            <c:otherwise>—</c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="info-item">
                    <label>Estimated Amount</label>
                    <div class="val">
                        <c:choose>
                            <c:when test="${requestDetail.estimatedAmount != null && requestDetail.estimatedAmount > 0}">
                                <fmt:formatNumber value="${requestDetail.estimatedAmount}" type="number" maxFractionDigits="0"/> VND
                            </c:when>
                            <c:otherwise>—</c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- CONTACT -->
    <div class="card">
        <div class="card-header">
            <span>📞</span>
            <h3>Contact Information</h3>
        </div>
        <div class="card-body">
            <div class="info-grid">
                <div class="info-item">
                    <label>Email</label>
                    <div class="val">${not empty requestDetail.contactEmail ? requestDetail.contactEmail : '—'}</div>
                </div>
                <div class="info-item">
                    <label>Phone</label>
                    <div class="val">${not empty requestDetail.contactPhone ? requestDetail.contactPhone : '—'}</div>
                </div>
            </div>
        </div>
    </div>

    <!-- PROOF IMAGE -->
    <div class="card">
        <div class="card-header">
            <span>🖼</span>
            <h3>Proof / Evidence</h3>
        </div>
        <div class="card-body">
            <c:choose>
                <c:when test="${not empty requestDetail.proofImageUrl}">
                    <img src="${pageContext.request.contextPath}/uploads/${requestDetail.proofImageUrl}"
                         class="proof-img" alt="Proof Image"/>
                </c:when>
                <c:otherwise>
                    <div class="no-proof">📎 No proof image uploaded</div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- SYSTEM INFO -->
    <div class="card">
        <div class="card-header">
            <span>🕐</span>
            <h3>System Information</h3>
        </div>
        <div class="card-body">
            <div class="info-grid">
                <div class="info-item">
                    <label>Submitted At</label>
                    <div class="val">${requestDetail.createdAt}</div>
                </div>
                <div class="info-item">
                    <label>Submitted By</label>
                    <div class="val">User #${requestDetail.createdBy}</div>
                </div>
                <c:if test="${not empty requestDetail.reviewedAt}">
                    <div class="info-item">
                        <label>Reviewed At</label>
                        <div class="val">${requestDetail.reviewedAt}</div>
                    </div>
                </c:if>
                <c:if test="${not empty requestDetail.adminNote}">
                    <div class="info-item full">
                        <label>Admin Note</label>
                        <div class="description-box">${requestDetail.adminNote}</div>
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <!-- ===== ADMIN ACTIONS (chỉ khi PENDING) ===== -->
    <c:if test="${(userRole == 'ADMIN' || userRole == 'Admin') && requestDetail.status == 'PENDING'}">
        <div class="action-panel">
            <h3>⚙ Admin Actions</h3>
            <div class="action-buttons">
                <form action="${pageContext.request.contextPath}/updateSupportRequestStatus" method="post">
                    <input type="hidden" name="requestId" value="${requestDetail.requestId}"/>
                    <input type="hidden" name="status" value="APPROVED"/>
                    <button type="submit" class="btn-approve">✅ Approve Request</button>
                </form>
                <button type="button" class="btn-reject" onclick="toggleRejectForm()">❌ Reject Request</button>
            </div>

            <div class="reject-form-box" id="rejectFormBox">
                <form action="${pageContext.request.contextPath}/updateSupportRequestStatus" method="post">
                    <input type="hidden" name="requestId" value="${requestDetail.requestId}"/>
                    <input type="hidden" name="status" value="REJECTED"/>
                    <label>Reason for rejection <span style="color:#ef4444">*</span></label>
                    <textarea name="rejectReason" placeholder="Explain why this request is being rejected..." required></textarea>
                    <div class="reject-actions">
                        <button type="button" class="btn-cancel-reject" onclick="toggleRejectForm()">Cancel</button>
                        <button type="submit" class="btn-confirm-reject">Confirm Reject</button>
                    </div>
                </form>
            </div>
        </div>
    </c:if>

    <!-- ===== ORGANIZATION ACTIONS (chỉ khi APPROVED) ===== -->
    <c:if test="${userRole == 'Organization' && requestDetail.status == 'APPROVED'}">
        <div class="action-panel">
            <h3>⚙ Organization Actions</h3>
            <div class="action-buttons">
                <form action="${pageContext.request.contextPath}/org/support-request-detail" method="post">
                    <input type="hidden" name="requestId" value="${requestDetail.requestId}"/>
                    <input type="hidden" name="action" value="ACCEPT"/>
                    <button type="submit" class="btn-accept">📋 Accept This Request</button>
                </form>
            </div>
        </div>
    </c:if>

</div>

<script>
    function toggleRejectForm() {
        const box = document.getElementById('rejectFormBox');
        box.style.display = box.style.display === 'block' ? 'none' : 'block';
    }
</script>
</body>
</html>
