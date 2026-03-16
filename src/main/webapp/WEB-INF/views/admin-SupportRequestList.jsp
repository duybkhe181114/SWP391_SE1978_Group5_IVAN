<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Support Requests - Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">

    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', 'Segoe UI', sans-serif; background: #f5f7fa; min-height: 100vh; }

        .page-wrapper { max-width: 1300px; margin: 0 auto; padding: 32px 24px; }

        /* ===== BREADCRUMB ===== */
        .breadcrumb { display: flex; align-items: center; gap: 8px; font-size: 13px; color: #94a3b8; margin-bottom: 24px; }
        .breadcrumb a { color: #6366f1; text-decoration: none; font-weight: 500; }
        .breadcrumb a:hover { text-decoration: underline; }
        .breadcrumb span.sep { color: #cbd5e1; }

        /* ===== PAGE HEADER ===== */
        .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 28px; }
        .page-header h1 { font-size: 26px; font-weight: 700; color: #1e293b; }
        .page-header .subtitle { font-size: 14px; color: #64748b; margin-top: 4px; }

        /* ===== STATS GRID ===== */
        .stats-grid { display: grid; grid-template-columns: repeat(5, 1fr); gap: 16px; margin-bottom: 28px; }
        .stat-card {
            background: white; border-radius: 14px; padding: 20px 24px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.04); border-left: 4px solid transparent;
            transition: transform 0.2s;
        }
        .stat-card:hover { transform: translateY(-2px); }
        .stat-card .stat-label { font-size: 13px; color: #64748b; font-weight: 500; margin-bottom: 8px; text-transform: uppercase; letter-spacing: 0.5px; }
        .stat-card .stat-value { font-size: 28px; font-weight: 700; color: #1e293b; }
        .stat-card.total { border-left-color: #6366f1; }
        .stat-card.pending { border-left-color: #f59e0b; }
        .stat-card.approved { border-left-color: #22c55e; }
        .stat-card.rejected { border-left-color: #ef4444; }
        .stat-card.accepted { border-left-color: #3b82f6; }

        /* ===== FILTER & SEARCH ===== */
        .toolbar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; flex-wrap: wrap; gap: 12px; }
        .filter-tabs { display: flex; gap: 6px; }
        .filter-tab {
            padding: 8px 18px; border-radius: 8px; font-size: 13px; font-weight: 600;
            border: 1.5px solid #e2e8f0; background: white; color: #64748b;
            cursor: pointer; transition: all 0.2s;
        }
        .filter-tab:hover { border-color: #6366f1; color: #6366f1; }
        .filter-tab.active { background: #6366f1; color: white; border-color: #6366f1; }

        .search-box { position: relative; }
        .search-box input {
            padding: 10px 14px 10px 38px; border-radius: 10px; border: 1.5px solid #e2e8f0;
            font-size: 13px; width: 260px; outline: none; transition: all 0.2s;
            font-family: 'Inter', sans-serif;
        }
        .search-box input:focus { border-color: #6366f1; box-shadow: 0 0 0 3px rgba(99,102,241,0.1); }
        .search-box svg { position: absolute; left: 12px; top: 50%; transform: translateY(-50%); width: 16px; height: 16px; color: #94a3b8; }

        /* ===== TABLE ===== */
        .table-container { background: white; border-radius: 14px; box-shadow: 0 2px 12px rgba(0,0,0,0.04); overflow: hidden; }

        table { width: 100%; border-collapse: collapse; }
        thead { background: #f8fafc; }
        th {
            padding: 14px 16px; text-align: left; font-size: 12px; font-weight: 600;
            color: #64748b; text-transform: uppercase; letter-spacing: 0.5px;
            border-bottom: 1.5px solid #e2e8f0;
        }
        td { padding: 14px 16px; font-size: 14px; color: #334155; border-bottom: 1px solid #f1f5f9; }
        tbody tr { transition: background 0.15s; }
        tbody tr:hover { background: #f8fafc; }
        tbody tr:last-child td { border-bottom: none; }

        .title-cell { font-weight: 600; color: #1e293b; max-width: 200px; overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }

        /* STATUS */
        .status-badge {
            display: inline-flex; align-items: center; gap: 6px;
            padding: 5px 12px; border-radius: 20px; font-size: 11px; font-weight: 700;
            text-transform: uppercase; letter-spacing: 0.5px;
        }
        .status-badge .dot { width: 7px; height: 7px; border-radius: 50%; }
        .status-PENDING { background: #fef3c7; color: #92400e; }
        .status-PENDING .dot { background: #f59e0b; }
        .status-APPROVED { background: #dcfce7; color: #166534; }
        .status-APPROVED .dot { background: #22c55e; }
        .status-REJECTED { background: #fee2e2; color: #991b1b; }
        .status-REJECTED .dot { background: #ef4444; }
        .status-ACCEPTED { background: #dbeafe; color: #1e40af; }
        .status-ACCEPTED .dot { background: #3b82f6; }

        /* PRIORITY */
        .priority-badge { font-weight: 600; font-size: 12px; }
        .priority-LOW { color: #0ea5e9; }
        .priority-MEDIUM { color: #f59e0b; }
        .priority-HIGH { color: #ef4444; }
        .priority-URGENT { color: #fff; background: #991b1b; padding: 3px 10px; border-radius: 6px; font-size: 11px; }

        /* ACTION BUTTON */
        .detail-btn {
            display: inline-flex; align-items: center; gap: 4px;
            padding: 7px 14px; background: #6366f1; color: white;
            text-decoration: none; border-radius: 8px; font-size: 12px; font-weight: 600;
            transition: all 0.2s;
        }
        .detail-btn:hover { background: #4f46e5; transform: translateY(-1px); }
        .detail-btn svg { width: 14px; height: 14px; }

        .empty-state { text-align: center; padding: 60px 40px; color: #94a3b8; }
        .empty-state svg { width: 48px; height: 48px; margin-bottom: 12px; color: #cbd5e1; }
        .empty-state h3 { font-size: 16px; color: #64748b; margin-bottom: 4px; }

        @media (max-width: 900px) {
            .stats-grid { grid-template-columns: repeat(2, 1fr); }
            .toolbar { flex-direction: column; align-items: flex-start; }
            .search-box input { width: 100%; }
        }
    </style>
</head>
<body>

<%@ include file="/components/header.jsp" %>

<div class="page-wrapper">

    <!-- BREADCRUMB -->
    <div class="breadcrumb">
        <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
        <span class="sep">/</span>
        <span>Support Requests</span>
    </div>

    <!-- PAGE HEADER -->
    <div class="page-header">
        <div>
            <h1>Support Requests</h1>
            <div class="subtitle">Manage and review all support requests</div>
        </div>
    </div>

    <!-- STATS -->
    <div class="stats-grid">
        <div class="stat-card total">
            <div class="stat-label">Total</div>
            <div class="stat-value">${totalCount}</div>
        </div>
        <div class="stat-card pending">
            <div class="stat-label">Pending</div>
            <div class="stat-value">${pendingCount}</div>
        </div>
        <div class="stat-card approved">
            <div class="stat-label">Approved</div>
            <div class="stat-value">${approvedCount}</div>
        </div>
        <div class="stat-card rejected">
            <div class="stat-label">Rejected</div>
            <div class="stat-value">${rejectedCount}</div>
        </div>
        <div class="stat-card accepted">
            <div class="stat-label">Accepted</div>
            <div class="stat-value">${acceptedCount}</div>
        </div>
    </div>

    <!-- TOOLBAR -->
    <div class="toolbar">
        <div class="filter-tabs">
            <button class="filter-tab active" onclick="filterTable('ALL', this)">All</button>
            <button class="filter-tab" onclick="filterTable('PENDING', this)">Pending</button>
            <button class="filter-tab" onclick="filterTable('APPROVED', this)">Approved</button>
            <button class="filter-tab" onclick="filterTable('REJECTED', this)">Rejected</button>
            <button class="filter-tab" onclick="filterTable('ACCEPTED', this)">Accepted</button>
        </div>
        <div class="search-box">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
            <input type="text" placeholder="Search by title, location..." oninput="searchTable(this.value)">
        </div>
    </div>

    <!-- TABLE -->
    <c:if test="${empty requestList}">
        <div class="table-container">
            <div class="empty-state">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
                <h3>No support requests found</h3>
                <p>There are no support requests in the system yet.</p>
            </div>
        </div>
    </c:if>

    <c:if test="${not empty requestList}">
        <div class="table-container">
            <table id="sprTable">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Title</th>
                        <th>Category</th>
                        <th>Priority</th>
                        <th>Status</th>
                        <th>Location</th>
                        <th>Estimated</th>
                        <th>Created</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="r" items="${requestList}">
                        <tr data-status="${r.status}">
                            <td style="color:#94a3b8; font-weight:500;">#${r.requestId}</td>
                            <td class="title-cell">${r.title}</td>
                            <td>${r.categoryName}</td>
                            <td>
                                <span class="priority-badge priority-${r.priority}">${r.priority}</span>
                            </td>
                            <td>
                                <span class="status-badge status-${r.status}">
                                    <span class="dot"></span>
                                    ${r.status}
                                </span>
                            </td>
                            <td>${r.supportLocation}</td>
                            <td style="font-weight:600;">
                                <c:if test="${r.estimatedAmount != null && r.estimatedAmount > 0}">
                                    <fmt:formatNumber value="${r.estimatedAmount}" type="currency" currencySymbol="$"/>
                                </c:if>
                                <c:if test="${r.estimatedAmount == null || r.estimatedAmount == 0}">—</c:if>
                            </td>
                            <td style="font-size:12px; color:#94a3b8;">${r.createdAt}</td>
                            <td>
                                <a class="detail-btn" href="${pageContext.request.contextPath}/adminSpRequestDetail?id=${r.requestId}">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                                    Detail
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </c:if>

</div>

<script>
    function filterTable(status, btn) {
        var tabs = document.querySelectorAll('.filter-tab');
        tabs.forEach(function(t) { t.classList.remove('active'); });
        btn.classList.add('active');

        var rows = document.querySelectorAll('#sprTable tbody tr');
        rows.forEach(function(row) {
            if (status === 'ALL' || row.getAttribute('data-status') === status) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
    }

    function searchTable(query) {
        var rows = document.querySelectorAll('#sprTable tbody tr');
        var q = query.toLowerCase();
        rows.forEach(function(row) {
            var text = row.textContent.toLowerCase();
            row.style.display = text.indexOf(q) !== -1 ? '' : 'none';
        });
    }
</script>

</body>
</html>