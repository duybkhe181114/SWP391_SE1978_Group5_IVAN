<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <title>Support Request #${requestDetail.requestId} - Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">

    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', 'Segoe UI', sans-serif; background: #f5f7fa; min-height: 100vh; }

        .page-wrapper { max-width: 1100px; margin: 0 auto; padding: 32px 24px; }

        .breadcrumb { display: flex; align-items: center; gap: 8px; font-size: 13px; color: #94a3b8; margin-bottom: 24px; }
        .breadcrumb a { color: #6366f1; text-decoration: none; font-weight: 500; }
        .breadcrumb a:hover { text-decoration: underline; }
        .breadcrumb span.sep { color: #cbd5e1; }

        .card { background: #fff; border-radius: 16px; padding: 32px; box-shadow: 0 2px 12px rgba(0,0,0,0.04); margin-bottom: 24px; }

        .card-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 28px; }
        .card-header h2 { font-size: 22px; font-weight: 700; color: #1e293b; }

        .back-btn {
            display: inline-flex; align-items: center; gap: 6px;
            padding: 10px 20px; background: #f8fafc; color: #475569;
            text-decoration: none; border-radius: 10px; font-weight: 500; font-size: 13px;
            border: 1.5px solid #e2e8f0; transition: all 0.2s;
        }
        .back-btn:hover { background: #f1f5f9; border-color: #cbd5e1; }
        .back-btn svg { width: 16px; height: 16px; }

        .section { margin-bottom: 28px; }
        .section-title {
            font-size: 12px; font-weight: 700; margin-bottom: 16px; color: #64748b;
            text-transform: uppercase; letter-spacing: 0.8px;
            padding-bottom: 8px; border-bottom: 1.5px solid #f1f5f9;
        }

        .grid { display: grid; grid-template-columns: 180px 1fr; row-gap: 14px; column-gap: 20px; }
        .label { font-weight: 600; color: #64748b; font-size: 13px; }
        .value { color: #1e293b; font-size: 14px; }

        .description-box { background: #f8fafc; padding: 16px; border-radius: 10px; border: 1px solid #e2e8f0; line-height: 1.7; font-size: 14px; color: #334155; }

        .proof-img { max-width: 400px; border-radius: 12px; border: 1px solid #e2e8f0; margin-top: 8px; }

        /* STATUS */
        .status-badge {
            display: inline-flex; align-items: center; gap: 6px;
            padding: 6px 14px; border-radius: 20px; font-size: 12px; font-weight: 700;
            text-transform: uppercase; letter-spacing: 0.5px;
        }
        .status-badge .dot { width: 7px; height: 7px; border-radius: 50%; }
        .PENDING { background: #fef3c7; color: #92400e; }
        .PENDING .dot { background: #f59e0b; }
        .APPROVED { background: #dcfce7; color: #166534; }
        .APPROVED .dot { background: #22c55e; }
        .REJECTED { background: #fee2e2; color: #991b1b; }
        .REJECTED .dot { background: #ef4444; }
        .ACCEPTED { background: #dbeafe; color: #1e40af; }
        .ACCEPTED .dot { background: #3b82f6; }

        /* ACTION BUTTONS */
        .actions { display: flex; justify-content: flex-end; gap: 12px; margin-top: 24px; }

        .btn {
            display: inline-flex; align-items: center; gap: 6px;
            padding: 11px 22px; border-radius: 10px; border: none; font-weight: 600;
            cursor: pointer; font-size: 13px; transition: all 0.2s; font-family: 'Inter', sans-serif;
        }
        .btn:hover { transform: translateY(-1px); }
        .btn-approve { background: #22c55e; color: white; box-shadow: 0 4px 12px rgba(34,197,94,0.3); }
        .btn-approve:hover { background: #16a34a; }
        .btn-reject { background: #ef4444; color: white; box-shadow: 0 4px 12px rgba(239,68,68,0.3); }
        .btn-reject:hover { background: #dc2626; }
        .btn svg { width: 16px; height: 16px; }

        /* REJECT BOX */
        .reject-box {
            margin-top: 20px; padding: 20px; background: #fef2f2; border-radius: 12px;
            border: 1px solid #fecaca; display: none;
        }
        .reject-box label { font-size: 13px; font-weight: 600; color: #991b1b; display: block; margin-bottom: 6px; }
        .reject-box textarea {
            width: 100%; height: 80px; padding: 12px; border-radius: 8px; border: 1px solid #fecaca;
            font-size: 13px; font-family: 'Inter', sans-serif; resize: vertical; outline: none;
        }
        .reject-box textarea:focus { border-color: #ef4444; box-shadow: 0 0 0 3px rgba(239,68,68,0.1); }
    </style>
</head>
<body>

<%@ include file="/components/header.jsp" %>

<div class="page-wrapper">

    <!-- BREADCRUMB -->
    <div class="breadcrumb">
        <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
        <span class="sep">/</span>
        <a href="${pageContext.request.contextPath}/viewSpRequestAdmin">Support Requests</a>
        <span class="sep">/</span>
        <span>Detail #${requestDetail.requestId}</span>
    </div>

    <div class="card">
        <div class="card-header">
            <h2>Support Request #${requestDetail.requestId}</h2>
            <a href="${pageContext.request.contextPath}/viewSpRequestAdmin" class="back-btn">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="19" y1="12" x2="5" y2="12"/><polyline points="12 19 5 12 12 5"/></svg>
                Back to List
            </a>
        </div>

        <!-- BASIC INFO -->
        <div class="section">
            <div class="section-title">Basic Information</div>
            <div class="grid">
                <div class="label">Title</div>
                <div class="value" style="font-weight:600;">${requestDetail.title}</div>

                <div class="label">Category</div>
                <div class="value">${requestDetail.categoryName}</div>

                <div class="label">Priority</div>
                <div class="value" style="font-weight:600;">${requestDetail.priority}</div>

                <div class="label">Status</div>
                <div class="value">
                    <span class="status-badge ${requestDetail.status}">
                        <span class="dot"></span>
                        ${requestDetail.status}
                    </span>
                </div>
            </div>
        </div>

        <!-- SUPPORT DETAILS -->
        <div class="section">
            <div class="section-title">Support Details</div>
            <div class="grid">
                <div class="label">Location</div>
                <div class="value">${requestDetail.supportLocation}</div>

                <div class="label">Beneficiary</div>
                <div class="value">${requestDetail.beneficiaryName}</div>

                <div class="label">Affected People</div>
                <div class="value">${requestDetail.affectedPeople}</div>

                <div class="label">Estimated Amount</div>
                <div class="value" style="font-weight:600; font-size:16px;">
                    <c:if test="${requestDetail.estimatedAmount != null && requestDetail.estimatedAmount > 0}">
                        <fmt:formatNumber value="${requestDetail.estimatedAmount}" type="currency" currencySymbol="$"/>
                    </c:if>
                    <c:if test="${requestDetail.estimatedAmount == null || requestDetail.estimatedAmount == 0}">Not specified</c:if>
                </div>
            </div>
        </div>

        <!-- DESCRIPTION -->
        <div class="section">
            <div class="section-title">Description</div>
            <div class="description-box">${requestDetail.description}</div>
        </div>

        <!-- CONTACT -->
        <div class="section">
            <div class="section-title">Contact Information</div>
            <div class="grid">
                <div class="label">Email</div>
                <div class="value">${requestDetail.contactEmail}</div>

                <div class="label">Phone</div>
                <div class="value">${requestDetail.contactPhone}</div>
            </div>
        </div>

        <!-- PROOF IMAGE -->
        <c:if test="${not empty requestDetail.proofImageUrl}">
            <div class="section">
                <div class="section-title">Proof Image</div>
                <img src="${pageContext.request.contextPath}/uploads/${requestDetail.proofImageUrl}"
                     class="proof-img" alt="Proof Image"
                     onerror="this.style.display='none'"/>
            </div>
        </c:if>

        <!-- SYSTEM INFO -->
        <div class="section">
            <div class="section-title">System Information</div>
            <div class="grid">
                <div class="label">Created At</div>
                <div class="value">${requestDetail.createdAt}</div>

                <div class="label">Created By</div>
                <div class="value">User #${requestDetail.createdBy}</div>

                <c:if test="${not empty requestDetail.adminNote}">
                    <div class="label">Admin Note</div>
                    <div class="value">${requestDetail.adminNote}</div>
                </c:if>

                <c:if test="${requestDetail.status == 'REJECTED' && not empty requestDetail.rejectReason}">
                    <div class="label" style="color:#ef4444;">Reject Reason</div>
                    <div class="value" style="color:#991b1b; background:#fef2f2; padding:8px 12px; border-radius:8px;">
                        ${requestDetail.rejectReason}
                    </div>
                </c:if>
            </div>
        </div>

        <%-- ===== ADMIN: Approve / Reject (chỉ khi PENDING) ===== --%>
        <c:if test="${userRole == 'Admin' && requestDetail.status == 'PENDING'}">
            <div class="actions">
                <form action="${pageContext.request.contextPath}/updateSupportRequestStatus" method="post" style="display:inline;">
                    <input type="hidden" name="requestId" value="${requestDetail.requestId}"/>
                    <input type="hidden" name="status" value="APPROVED"/>
                    <button type="submit" class="btn btn-approve" onclick="return confirm('Are you sure you want to approve this request?')">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><polyline points="20 6 9 17 4 12"/></svg>
                        Approve
                    </button>
                </form>

                <button type="button" class="btn btn-reject" onclick="document.getElementById('rejectBox').style.display='block'; this.style.display='none';">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></svg>
                    Reject
                </button>
            </div>

            <div id="rejectBox" class="reject-box">
                <form action="${pageContext.request.contextPath}/updateSupportRequestStatus" method="post">
                    <input type="hidden" name="requestId" value="${requestDetail.requestId}"/>
                    <input type="hidden" name="status" value="REJECTED"/>

                    <label>Reject Reason *</label>
                    <textarea name="rejectReason" placeholder="Enter the reason for rejection..." required></textarea>

                    <div class="actions" style="margin-top:12px;">
                        <button type="button" class="btn" style="background:#f1f5f9; color:#475569;" onclick="document.getElementById('rejectBox').style.display='none';">Cancel</button>
                        <button type="submit" class="btn btn-reject">Confirm Rejection</button>
                    </div>
                </form>
            </div>
        </c:if>

    </div>
</div>

</body>
</html>