<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

            <!DOCTYPE html>
            <html>

            <head>
                <meta charset="UTF-8">
                <title>My Support Requests</title>
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
                    rel="stylesheet">

                <style>
                    * {
                        margin: 0;
                        padding: 0;
                        box-sizing: border-box;
                    }

                    body {
                        font-family: 'Inter', 'Segoe UI', sans-serif;
                        background: linear-gradient(135deg, #f5f7fa 0%, #e4e9f2 100%);
                        min-height: 100vh;
                        padding: 0;
                    }

                    .page-wrapper {
                        max-width: 1200px;
                        margin: 0 auto;
                        padding: 40px 24px;
                    }

                    /* ===== PAGE HEADER ===== */
                    .page-header {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        margin-bottom: 32px;
                    }

                    .page-header h1 {
                        font-size: 28px;
                        font-weight: 700;
                        color: #1e293b;
                    }

                    .page-header .subtitle {
                        font-size: 14px;
                        color: #64748b;
                        margin-top: 4px;
                    }

                    .btn-create {
                        display: inline-flex;
                        align-items: center;
                        gap: 8px;
                        padding: 12px 24px;
                        background: linear-gradient(135deg, #6366f1, #8b5cf6);
                        color: white;
                        text-decoration: none;
                        border-radius: 12px;
                        font-weight: 600;
                        font-size: 14px;
                        transition: all 0.2s;
                        box-shadow: 0 4px 14px rgba(99, 102, 241, 0.35);
                    }

                    .btn-create:hover {
                        transform: translateY(-2px);
                        box-shadow: 0 6px 20px rgba(99, 102, 241, 0.45);
                    }

                    .btn-back {
                        display: inline-flex;
                        align-items: center;
                        gap: 6px;
                        padding: 10px 20px;
                        background: #fff;
                        color: #475569;
                        text-decoration: none;
                        border-radius: 10px;
                        font-weight: 500;
                        font-size: 14px;
                        border: 1px solid #e2e8f0;
                        transition: all 0.2s;
                    }

                    .btn-back:hover {
                        background: #f8fafc;
                        border-color: #cbd5e1;
                    }

                    .header-actions {
                        display: flex;
                        gap: 12px;
                        align-items: center;
                    }

                    /* ===== STATS BAR ===== */
                    .stats-bar {
                        display: flex;
                        gap: 16px;
                        margin-bottom: 28px;
                    }

                    .stat-chip {
                        display: flex;
                        align-items: center;
                        gap: 8px;
                        padding: 10px 18px;
                        background: white;
                        border-radius: 10px;
                        font-size: 13px;
                        font-weight: 600;
                        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
                        cursor: pointer;
                        transition: all 0.2s;
                        border: 2px solid transparent;
                    }

                    .stat-chip:hover {
                        transform: translateY(-1px);
                    }

                    .stat-chip.active {
                        border-color: #6366f1;
                    }

                    .stat-dot {
                        width: 10px;
                        height: 10px;
                        border-radius: 50%;
                    }

                    .dot-all {
                        background: #6366f1;
                    }

                    .dot-pending {
                        background: #f59e0b;
                    }

                    .dot-approved {
                        background: #22c55e;
                    }

                    .dot-accepted {
                        background: #3b82f6;
                    }

                    .dot-rejected {
                        background: #ef4444;
                    }

                    /* ===== EMPTY STATE ===== */
                    .empty-state {
                        text-align: center;
                        padding: 80px 40px;
                        background: white;
                        border-radius: 16px;
                        box-shadow: 0 4px 16px rgba(0, 0, 0, 0.04);
                    }

                    .empty-state .icon {
                        font-size: 56px;
                        margin-bottom: 16px;
                    }

                    .empty-state h3 {
                        font-size: 20px;
                        color: #334155;
                        margin-bottom: 8px;
                    }

                    .empty-state p {
                        color: #94a3b8;
                        font-size: 14px;
                        margin-bottom: 24px;
                    }

                    /* ===== REQUEST CARDS ===== */
                    .request-list {
                        display: flex;
                        flex-direction: column;
                        gap: 16px;
                    }

                    .request-card {
                        background: white;
                        border-radius: 14px;
                        padding: 24px 28px;
                        box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
                        transition: all 0.25s;
                        border-left: 4px solid transparent;
                        display: grid;
                        grid-template-columns: 1fr auto;
                        gap: 16px;
                        align-items: start;
                    }

                    .request-card:hover {
                        transform: translateY(-2px);
                        box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08);
                    }

                    .request-card.status-PENDING {
                        border-left-color: #f59e0b;
                    }

                    .request-card.status-APPROVED {
                        border-left-color: #22c55e;
                    }

                    .request-card.status-ACCEPTED {
                        border-left-color: #3b82f6;
                    }

                    .request-card.status-REJECTED {
                        border-left-color: #ef4444;
                    }

                    .request-card.status-COMPLETED {
                        border-left-color: #8b5cf6;
                    }

                    .card-main h3 {
                        font-size: 17px;
                        font-weight: 600;
                        color: #1e293b;
                        margin-bottom: 10px;
                    }

                    .card-meta {
                        display: flex;
                        flex-wrap: wrap;
                        gap: 16px;
                        margin-bottom: 10px;
                    }

                    .meta-item {
                        display: flex;
                        align-items: center;
                        gap: 5px;
                        font-size: 13px;
                        color: #64748b;
                    }

                    .meta-item .meta-icon {
                        font-size: 14px;
                    }

                    .card-right {
                        display: flex;
                        flex-direction: column;
                        align-items: flex-end;
                        gap: 12px;
                        min-width: 140px;
                    }

                    /* ===== STATUS BADGES ===== */
                    .badge {
                        padding: 5px 14px;
                        border-radius: 20px;
                        font-size: 12px;
                        font-weight: 600;
                        text-transform: uppercase;
                        letter-spacing: 0.5px;
                    }

                    .badge-PENDING {
                        background: #fef3c7;
                        color: #92400e;
                    }

                    .badge-APPROVED {
                        background: #dcfce7;
                        color: #166534;
                    }

                    .badge-ACCEPTED {
                        background: #dbeafe;
                        color: #1e40af;
                    }

                    .badge-REJECTED {
                        background: #fee2e2;
                        color: #991b1b;
                    }

                    .badge-COMPLETED {
                        background: #ede9fe;
                        color: #5b21b6;
                    }

                    /* ===== PRIORITY ===== */
                    .priority-tag {
                        font-size: 12px;
                        font-weight: 600;
                        padding: 3px 10px;
                        border-radius: 6px;
                    }

                    .priority-LOW {
                        background: #f0f9ff;
                        color: #0369a1;
                    }

                    .priority-MEDIUM {
                        background: #fffbeb;
                        color: #b45309;
                    }

                    .priority-HIGH {
                        background: #fef2f2;
                        color: #dc2626;
                    }

                    .priority-URGENT {
                        background: #450a0a;
                        color: #fecaca;
                    }

                    /* ===== REJECT REASON ===== */
                    .reject-reason {
                        margin-top: 8px;
                        padding: 10px 14px;
                        background: #fef2f2;
                        border-radius: 8px;
                        font-size: 13px;
                        color: #991b1b;
                        border: 1px solid #fecaca;
                    }

                    .reject-reason strong {
                        display: block;
                        margin-bottom: 3px;
                        font-size: 12px;
                        text-transform: uppercase;
                        letter-spacing: 0.3px;
                    }

                    /* ===== VIEW DETAIL LINK ===== */
                    .detail-link {
                        font-size: 13px;
                        font-weight: 600;
                        color: #6366f1;
                        text-decoration: none;
                        transition: color 0.2s;
                    }

                    .detail-link:hover {
                        color: #4f46e5;
                        text-decoration: underline;
                    }

                    .card-date {
                        font-size: 12px;
                        color: #94a3b8;
                    }
                </style>

                <script>
                    function filterCards(status) {
                        var cards = document.querySelectorAll('.request-card');
                        var chips = document.querySelectorAll('.stat-chip');

                        chips.forEach(function (c) { c.classList.remove('active'); });
                        event.currentTarget.classList.add('active');

                        cards.forEach(function (card) {
                            if (status === 'ALL' || card.classList.contains('status-' + status)) {
                                card.style.display = 'grid';
                            } else {
                                card.style.display = 'none';
                            }
                        });
                    }
                </script>
            </head>

            <body>

                <%@ include file="/components/header.jsp" %>

                    <div class="page-wrapper">

                        <!-- PAGE HEADER -->
                        <div class="page-header">
                            <div>
                                <h1>📋 My Support Requests</h1>
                                <div class="subtitle">Track the status of all your submitted requests</div>
                            </div>
                            <div class="header-actions">
                                <a href="${pageContext.request.contextPath}/home" class="btn-back">← Home</a>
                                <a href="${pageContext.request.contextPath}/createSupportRequest" class="btn-create">
                                    ＋ New Request
                                </a>
                            </div>
                        </div>

                        <!-- STATS BAR -->
                        <div class="stats-bar">
                            <div class="stat-chip active" onclick="filterCards('ALL')">
                                <span class="stat-dot dot-all"></span> All
                            </div>
                            <div class="stat-chip" onclick="filterCards('PENDING')">
                                <span class="stat-dot dot-pending"></span> Pending
                            </div>
                            <div class="stat-chip" onclick="filterCards('APPROVED')">
                                <span class="stat-dot dot-approved"></span> Approved
                            </div>
                            <div class="stat-chip" onclick="filterCards('ACCEPTED')">
                                <span class="stat-dot dot-accepted"></span> Accepted
                            </div>
                            <div class="stat-chip" onclick="filterCards('REJECTED')">
                                <span class="stat-dot dot-rejected"></span> Rejected
                            </div>
                        </div>

                        <!-- EMPTY STATE -->
                        <c:if test="${empty requestList}">
                            <div class="empty-state">
                                <div class="icon">📭</div>
                                <h3>No requests yet</h3>
                                <p>You haven't submitted any support requests. Create one to get started!</p>
                                <a href="${pageContext.request.contextPath}/createSupportRequest" class="btn-create">
                                    ＋ Create Request
                                </a>
                            </div>
                        </c:if>

                        <!-- REQUEST LIST -->
                        <c:if test="${not empty requestList}">
                            <div class="request-list">

                                <c:forEach var="r" items="${requestList}">

                                    <div class="request-card status-${r.status}">

                                        <div class="card-main">
                                            <h3>${r.title}</h3>

                                            <div class="card-meta">
                                                <div class="meta-item">
                                                    <span class="meta-icon">📂</span>
                                                    ${not empty r.categoryName ? r.categoryName : 'N/A'}
                                                </div>
                                                <div class="meta-item">
                                                    <span class="meta-icon">📍</span>
                                                    ${not empty r.supportLocation ? r.supportLocation : 'N/A'}
                                                </div>
                                                <div class="meta-item">
                                                    <span class="meta-icon">👥</span>
                                                    ${r.affectedPeople} people
                                                </div>
                                                <div class="meta-item">
                                                    <span class="meta-icon">💰</span>
                                                    $${r.estimatedAmount}
                                                </div>
                                            </div>

                                            <div class="card-meta">
                                                <span class="priority-tag priority-${r.priority}">
                                                    ${r.priority}
                                                </span>
                                            </div>

                                            <%-- Show reject reason if rejected --%>
                                                <c:if test="${r.status == 'REJECTED' && not empty r.rejectReason}">
                                                    <div class="reject-reason">
                                                        <strong>❌ Reject Reason</strong>
                                                        ${r.rejectReason}
                                                    </div>
                                                </c:if>
                                        </div>

                                        <div class="card-right">
                                            <span class="badge badge-${r.status}">
                                                ${r.status}
                                            </span>
                                            <div class="card-date">
                                                ${r.createdAt}
                                            </div>
                                            <a class="detail-link"
                                                href="${pageContext.request.contextPath}/adminSpRequestDetail?id=${r.requestId}">
                                                View Detail →
                                            </a>
                                        </div>

                                    </div>

                                </c:forEach>

                            </div>
                        </c:if>

                    </div>

            </body>

            </html>