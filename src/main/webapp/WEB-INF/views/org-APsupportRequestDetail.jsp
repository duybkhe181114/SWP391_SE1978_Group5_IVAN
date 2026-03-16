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

        .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 28px; }
        .page-header-left h1 { font-size: 24px; font-weight: 700; color: #1e293b; margin: 0 0 4px; }
        .page-header-left .subtitle { font-size: 13px; color: #64748b; }
        .btn-back { display: inline-flex; align-items: center; gap: 6px; padding: 9px 18px; background: white; color: #475569; border: 1.5px solid #e2e8f0; border-radius: 8px; font-size: 13px; font-weight: 600; text-decoration: none; transition: all 0.2s; }
        .btn-back:hover { background: #f8fafc; border-color: #cbd5e1; }

        .status-banner { display: flex; align-items: center; gap: 16px; padding: 16px 24px; border-radius: 12px; margin-bottom: 24px; background: #f0fdf4; border: 1.5px solid #bbf7d0; }
        .status-banner .banner-icon { font-size: 28px; }
        .status-banner .banner-text strong { font-size: 15px; color: #1e293b; display: block; }
        .status-banner .banner-text span { font-size: 13px; color: #64748b; }
        .badge-APPROVED { background: #dcfce7; color: #166534; padding: 5px 14px; border-radius: 20px; font-size: 12px; font-weight: 700; text-transform: uppercase; display: inline-block; }

        .card { background: white; border-radius: 14px; box-shadow: 0 2px 12px rgba(0,0,0,0.05); margin-bottom: 20px; overflow: hidden; }
        .card-header { padding: 18px 24px; border-bottom: 1px solid #f1f5f9; display: flex; align-items: center; gap: 10px; }
        .card-header h3 { font-size: 14px; font-weight: 700; color: #1e293b; margin: 0; text-transform: uppercase; letter-spacing: 0.4px; }
        .card-body { padding: 24px; }

        .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .info-item label { font-size: 12px; font-weight: 600; color: #94a3b8; text-transform: uppercase; letter-spacing: 0.4px; display: block; margin-bottom: 4px; }
        .info-item .val { font-size: 14px; color: #1e293b; font-weight: 500; }
        .info-item.full { grid-column: 1 / -1; }
        .description-box { background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 10px; padding: 16px; font-size: 14px; color: #334155; line-height: 1.7; }

        .priority-tag { display: inline-flex; align-items: center; gap: 6px; font-size: 13px; font-weight: 600; padding: 4px 12px; border-radius: 20px; }
        .priority-LOW    { background: #f0f9ff; color: #0369a1; }
        .priority-MEDIUM { background: #fffbeb; color: #b45309; }
        .priority-HIGH   { background: #fef2f2; color: #dc2626; }
        .priority-URGENT { background: #450a0a; color: #fecaca; }

        .proof-img { max-width: 100%; max-height: 320px; border-radius: 10px; border: 1px solid #e2e8f0; display: block; }
        .no-proof { padding: 24px; background: #f8fafc; border-radius: 10px; text-align: center; color: #94a3b8; font-size: 13px; border: 1.5px dashed #e2e8f0; }

        .action-panel { background: white; border-radius: 14px; box-shadow: 0 2px 12px rgba(0,0,0,0.05); padding: 24px; }
        .action-panel h3 { font-size: 14px; font-weight: 700; color: #1e293b; margin: 0 0 8px; text-transform: uppercase; letter-spacing: 0.4px; }
        .action-panel p { font-size: 13px; color: #64748b; margin: 0 0 16px; }
        .btn-accept { padding: 12px 28px; background: linear-gradient(135deg, #6366f1, #8b5cf6); color: white; border: none; border-radius: 8px; font-size: 14px; font-weight: 600; cursor: pointer; transition: all 0.2s; box-shadow: 0 4px 12px rgba(99,102,241,0.3); }
        .btn-accept:hover { transform: translateY(-1px); box-shadow: 0 6px 16px rgba(99,102,241,0.4); }
    </style>
</head>
<body>

<%@ include file="/components/header.jsp" %>

<div class="page-wrapper">

    <div class="page-header">
        <div class="page-header-left">
            <h1>📋 Support Request Detail</h1>
            <div class="subtitle">Request #${requestDetail.requestId}</div>
        </div>
        <a href="${pageContext.request.contextPath}/org/support-requests" class="btn-back">← Back to List</a>
    </div>

    <div class="status-banner">
        <div class="banner-icon">✅</div>
        <div class="banner-text">
            <strong><span class="badge-APPROVED">APPROVED</span></strong>
            <span>This request has been approved by admin and is available for your organization to accept.</span>
        </div>
    </div>

    <!-- BASIC INFO -->
    <div class="card">
        <div class="card-header"><span>📌</span><h3>Basic Information</h3></div>
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
        <div class="card-header"><span>📍</span><h3>Support Details</h3></div>
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
        <div class="card-header"><span>📞</span><h3>Contact Information</h3></div>
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

    <!-- PROOF -->
    <div class="card">
        <div class="card-header"><span>🖼</span><h3>Proof / Evidence</h3></div>
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

    <!-- ACTION -->
    <div class="action-panel">
        <h3>⚙ Organization Action</h3>
        <p>By accepting this request, your organization commits to providing the necessary support.</p>
        <form action="${pageContext.request.contextPath}/org/support-request-detail" method="post">
            <input type="hidden" name="requestId" value="${requestDetail.requestId}"/>
            <input type="hidden" name="action" value="ACCEPT"/>
            <button type="submit" class="btn-accept">📋 Accept This Request</button>
        </form>
    </div>

</div>
</body>
</html>
