<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Support Requests - Admin | IVAN</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <style>
        body { background: #f1f5f9; font-family: 'Inter', 'Segoe UI', sans-serif; margin: 0; }
        .page-wrapper { max-width: 1300px; margin: 0 auto; padding: 40px 24px 60px; }

        .page-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 28px; }
        .page-header h1 { font-size: 26px; font-weight: 700; color: #1e293b; margin: 0 0 4px; }
        .page-header .subtitle { font-size: 14px; color: #64748b; }

        .filter-bar { display: flex; gap: 10px; margin-bottom: 24px; flex-wrap: wrap; align-items: center; }
        .filter-chip { padding: 7px 16px; border-radius: 20px; font-size: 13px; font-weight: 600; cursor: pointer; border: 2px solid transparent; background: white; color: #64748b; box-shadow: 0 1px 4px rgba(0,0,0,0.06); transition: all 0.2s; }
        .filter-chip:hover { border-color: #6366f1; color: #6366f1; }
        .filter-chip.active { background: #6366f1; color: white; border-color: #6366f1; }
        .filter-chip.chip-pending.active { background: #f59e0b; border-color: #f59e0b; }
        .filter-chip.chip-approved.active { background: #22c55e; border-color: #22c55e; }
        .filter-chip.chip-rejected.active { background: #ef4444; border-color: #ef4444; }

        .search-box { margin-left: auto; }
        .search-box input { padding: 8px 14px; border: 1.5px solid #e2e8f0; border-radius: 8px; font-size: 13px; width: 220px; outline: none; }
        .search-box input:focus { border-color: #6366f1; }

        .table-card { background: white; border-radius: 14px; box-shadow: 0 2px 12px rgba(0,0,0,0.05); overflow: hidden; }
        table { width: 100%; border-collapse: collapse; }
        thead { background: #1e293b; }
        thead th { padding: 14px 16px; text-align: left; font-size: 12px; font-weight: 600; color: #94a3b8; text-transform: uppercase; letter-spacing: 0.5px; }
        tbody tr { border-bottom: 1px solid #f1f5f9; transition: background 0.15s; }
        tbody tr:last-child { border-bottom: none; }
        tbody tr:hover { background: #f8fafc; }
        td { padding: 14px 16px; font-size: 14px; color: #334155; vertical-align: middle; }

        .badge { padding: 4px 12px; border-radius: 20px; font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: 0.4px; display: inline-block; }
        .badge-PENDING { background: #fef3c7; color: #92400e; }
        .badge-APPROVED { background: #dcfce7; color: #166534; }
        .badge-REJECTED { background: #fee2e2; color: #991b1b; }
        .badge-ACCEPTED { background: #dbeafe; color: #1e40af; }
        .badge-COMPLETED { background: #ede9fe; color: #5b21b6; }

        .priority-dot { display: inline-flex; align-items: center; gap: 5px; font-size: 13px; font-weight: 600; }
        .dot { width: 8px; height: 8px; border-radius: 50%; display: inline-block; }
        .dot-LOW { background: #22c55e; }
        .dot-MEDIUM { background: #f59e0b; }
        .dot-HIGH { background: #ef4444; }
        .dot-URGENT { background: #7f1d1d; }

        .btn-detail { padding: 6px 14px; background: #6366f1; color: white; text-decoration: none; border-radius: 6px; font-size: 12px; font-weight: 600; transition: background 0.2s; }
        .btn-detail:hover { background: #4f46e5; }

        .empty-state { text-align: center; padding: 60px; color: #94a3b8; }
        .empty-state .icon { font-size: 48px; margin-bottom: 12px; }

        .title-cell { max-width: 220px; }
        .title-cell .title-text { font-weight: 600; color: #1e293b; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .title-cell .id-text { font-size: 12px; color: #94a3b8; }
    </style>
</head>
<body>

<%@ include file="/components/header.jsp" %>

<div class="page-wrapper">
    <div class="page-header">
        <div>
            <h1>📋 Support Requests</h1>
            <div class="subtitle">Review and manage all submitted support requests</div>
        </div>
    </div>

    <div class="filter-bar">
        <div class="filter-chip active" onclick="filterTable('ALL', this)">All</div>
        <div class="filter-chip chip-pending" onclick="filterTable('PENDING', this)">⏳ Pending</div>
        <div class="filter-chip chip-approved" onclick="filterTable('APPROVED', this)">✅ Approved</div>
        <div class="filter-chip chip-rejected" onclick="filterTable('REJECTED', this)">❌ Rejected</div>
        <div class="filter-chip" onclick="filterTable('ACCEPTED', this)">📋 Accepted</div>
        <div class="search-box">
            <input type="text" id="searchInput" placeholder="🔍 Search by title..." oninput="searchTable()">
        </div>
    </div>

    <div class="table-card">
        <c:choose>
            <c:when test="${empty requestList}">
                <div class="empty-state">
                    <div class="icon">📭</div>
                    <p>No support requests found.</p>
                </div>
            </c:when>
            <c:otherwise>
                <table id="sprTable">
                    <thead>
                        <tr>
                            <th>Request</th>
                            <th>Category</th>
                            <th>Priority</th>
                            <th>Status</th>
                            <th>Location</th>
                            <th>Estimated</th>
                            <th>Submitted</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="r" items="${requestList}">
                            <tr data-status="${r.status}" data-title="${r.title}">
                                <td class="title-cell">
                                    <div class="title-text">${r.title}</div>
                                    <div class="id-text">#${r.requestId}</div>
                                </td>
                                <td>${not empty r.categoryName ? r.categoryName : '—'}</td>
                                <td>
                                    <span class="priority-dot">
                                        <span class="dot dot-${r.priority}"></span>
                                        ${r.priority}
                                    </span>
                                </td>
                                <td><span class="badge badge-${r.status}">${r.status}</span></td>
                                <td>${not empty r.supportLocation ? r.supportLocation : '—'}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${r.estimatedAmount != null && r.estimatedAmount > 0}">
                                            <fmt:formatNumber value="${r.estimatedAmount}" type="number" maxFractionDigits="0"/> VND
                                        </c:when>
                                        <c:otherwise>—</c:otherwise>
                                    </c:choose>
                                </td>
                                <td style="font-size:12px; color:#94a3b8;">${r.createdAt}</td>
                                <td>
                                    <a class="btn-detail"
                                       href="${pageContext.request.contextPath}/adminSpRequestDetail?id=${r.requestId}">
                                        View →
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script>
    function filterTable(status, el) {
        document.querySelectorAll('.filter-chip').forEach(c => c.classList.remove('active'));
        el.classList.add('active');
        document.querySelectorAll('#sprTable tbody tr').forEach(row => {
            row.style.display = (status === 'ALL' || row.dataset.status === status) ? '' : 'none';
        });
    }

    function searchTable() {
        const q = document.getElementById('searchInput').value.toLowerCase();
        document.querySelectorAll('#sprTable tbody tr').forEach(row => {
            const title = (row.dataset.title || '').toLowerCase();
            row.style.display = title.includes(q) ? '' : 'none';
        });
    }
</script>
</body>
</html>
