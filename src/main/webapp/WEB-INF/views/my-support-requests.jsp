<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Support Requests | IVAN</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        body { background: #f8fafc; font-family: 'Inter', sans-serif; margin: 0; color: #1e293b; }

        .page-wrapper { max-width: 1280px; margin: 0 auto; padding: 36px 28px 60px; }

        /* ── Header ── */
        .page-header {
            display: flex; justify-content: space-between; align-items: center;
            margin-bottom: 32px;
        }
        .page-header h1 { font-size: 24px; font-weight: 800; color: #0f172a; margin: 0 0 4px; }
        .page-header .subtitle { font-size: 13px; color: #64748b; }
        .header-actions { display: flex; gap: 10px; }

        .btn { display: inline-flex; align-items: center; gap: 6px; padding: 9px 18px; border-radius: 8px; font-size: 13px; font-weight: 600; text-decoration: none; transition: all .18s; }
        .btn-ghost { background: white; color: #475569; border: 1.5px solid #e2e8f0; }
        .btn-ghost:hover { border-color: #94a3b8; color: #1e293b; }
        .btn-primary { background: #6366f1; color: white; border: none; }
        .btn-primary:hover { background: #4f46e5; box-shadow: 0 4px 12px rgba(99,102,241,.35); }

        /* ── Stat cards ── */
        .stat-row { display: flex; gap: 14px; margin-bottom: 28px; flex-wrap: wrap; }
        .stat-card {
            flex: 1; min-width: 130px; background: white; border-radius: 12px;
            padding: 16px 20px; box-shadow: 0 1px 6px rgba(0,0,0,.06);
            border-top: 3px solid transparent; cursor: pointer; transition: all .18s;
        }
        .stat-card:hover { transform: translateY(-2px); box-shadow: 0 4px 16px rgba(0,0,0,.09); }
        .stat-card.active { box-shadow: 0 4px 16px rgba(0,0,0,.1); }
        .stat-card .count { font-size: 26px; font-weight: 800; line-height: 1; margin-bottom: 4px; }
        .stat-card .label { font-size: 12px; font-weight: 600; color: #64748b; text-transform: uppercase; letter-spacing: .4px; }

        .sc-all     { border-top-color: #6366f1; } .sc-all .count     { color: #6366f1; }
        .sc-pending { border-top-color: #f59e0b; } .sc-pending .count { color: #f59e0b; }
        .sc-approved{ border-top-color: #22c55e; } .sc-approved .count{ color: #22c55e; }
        .sc-accepted{ border-top-color: #3b82f6; } .sc-accepted .count{ color: #3b82f6; }
        .sc-rejected{ border-top-color: #ef4444; } .sc-rejected .count{ color: #ef4444; }

        /* ── Toolbar ── */
        .toolbar { display: flex; align-items: center; gap: 10px; margin-bottom: 16px; flex-wrap: wrap; }
        .search-wrap { margin-left: auto; position: relative; }
        .search-wrap svg { position: absolute; left: 10px; top: 50%; transform: translateY(-50%); color: #94a3b8; pointer-events: none; }
        .search-wrap input {
            padding: 8px 12px 8px 34px; border: 1.5px solid #e2e8f0; border-radius: 8px;
            font-size: 13px; width: 230px; outline: none; background: white; color: #1e293b;
        }
        .search-wrap input:focus { border-color: #6366f1; }

        /* ── Table ── */
        .table-card { background: white; border-radius: 14px; box-shadow: 0 2px 12px rgba(0,0,0,.05); overflow: hidden; }
        table { width: 100%; border-collapse: collapse; }
        thead tr { background: #0f172a; }
        thead th { padding: 13px 16px; text-align: left; font-size: 11px; font-weight: 700; color: #94a3b8; text-transform: uppercase; letter-spacing: .6px; white-space: nowrap; }
        tbody tr { border-bottom: 1px solid #f1f5f9; transition: background .12s; }
        tbody tr:last-child { border-bottom: none; }
        tbody tr:hover { background: #f8fafc; }
        td { padding: 14px 16px; font-size: 13.5px; color: #334155; vertical-align: middle; }

        /* title cell */
        .title-main { font-weight: 600; color: #0f172a; max-width: 220px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .title-id   { font-size: 11px; color: #94a3b8; margin-top: 2px; }

        /* reject inline */
        .reject-inline {
            margin-top: 7px; padding: 7px 10px;
            background: #fff1f2; border-left: 3px solid #ef4444;
            border-radius: 0 6px 6px 0; font-size: 12px; color: #be123c;
            max-width: 240px;
        }
        .reject-inline .rl { font-size: 10px; font-weight: 700; text-transform: uppercase; letter-spacing: .4px; margin-bottom: 2px; color: #9f1239; }

        /* badges */
        .badge { padding: 3px 10px; border-radius: 20px; font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: .4px; display: inline-block; white-space: nowrap; }
        .badge-PENDING  { background: #fef3c7; color: #92400e; }
        .badge-APPROVED { background: #dcfce7; color: #166534; }
        .badge-REJECTED { background: #fee2e2; color: #991b1b; }
        .badge-ACCEPTED { background: #dbeafe; color: #1e40af; }
        .badge-COMPLETED{ background: #ede9fe; color: #5b21b6; }

        /* priority */
        .pri { display: inline-flex; align-items: center; gap: 5px; font-size: 13px; font-weight: 600; }
        .pri-dot { width: 7px; height: 7px; border-radius: 50%; flex-shrink: 0; }
        .pri-dot-Low,.pri-dot-LOW         { background: #22c55e; }
        .pri-dot-Medium,.pri-dot-MEDIUM   { background: #f59e0b; }
        .pri-dot-High,.pri-dot-HIGH       { background: #ef4444; }
        .pri-dot-Urgent,.pri-dot-URGENT   { background: #7c3aed; }

        /* amount */
        .amount { font-variant-numeric: tabular-nums; font-weight: 500; }

        /* date */
        .date-cell { font-size: 12px; color: #64748b; white-space: nowrap; }

        /* action buttons */
        .action-col { white-space: nowrap; }
        .btn-view { padding: 5px 13px; background: #6366f1; color: white; border-radius: 6px; font-size: 12px; font-weight: 600; text-decoration: none; display: inline-block; }
        .btn-view:hover { background: #4f46e5; }
        .btn-edit { padding: 5px 11px; background: #fff7ed; color: #c2410c; border: 1px solid #fed7aa; border-radius: 6px; font-size: 12px; font-weight: 600; text-decoration: none; display: inline-block; margin-left: 6px; }
        .btn-edit:hover { background: #ffedd5; border-color: #fb923c; }

        /* empty */
        .empty-state { text-align: center; padding: 72px 40px; }
        .empty-state .ei { font-size: 52px; margin-bottom: 14px; }
        .empty-state p { color: #94a3b8; font-size: 14px; margin-bottom: 20px; }
    </style>
</head>
<body>
<%@ include file="/components/header.jsp" %>

<div class="page-wrapper">

    <%-- counts --%>
    <c:set var="cAll"      value="0"/>
    <c:set var="cPending"  value="0"/>
    <c:set var="cApproved" value="0"/>
    <c:set var="cAccepted" value="0"/>
    <c:set var="cRejected" value="0"/>
    <c:forEach var="r" items="${requestList}">
        <c:set var="cAll" value="${cAll + 1}"/>
        <c:if test="${r.status == 'PENDING'}">  <c:set var="cPending"  value="${cPending  + 1}"/></c:if>
        <c:if test="${r.status == 'APPROVED'}"> <c:set var="cApproved" value="${cApproved + 1}"/></c:if>
        <c:if test="${r.status == 'ACCEPTED'}"> <c:set var="cAccepted" value="${cAccepted + 1}"/></c:if>
        <c:if test="${r.status == 'REJECTED'}"> <c:set var="cRejected" value="${cRejected + 1}"/></c:if>
    </c:forEach>

    <div class="page-header">
        <div>
            <h1>My Support Requests</h1>
            <div class="subtitle">Track and manage all your submitted requests</div>
        </div>
        <div class="header-actions">
            <a href="${pageContext.request.contextPath}/home" class="btn btn-ghost">← Home</a>
            <a href="${pageContext.request.contextPath}/createSupportRequest" class="btn btn-primary">＋ New Request</a>
        </div>
    </div>

    <div class="stat-row">
        <div class="stat-card sc-all active"      onclick="filterTable('ALL',this)">
            <div class="count">${cAll}</div><div class="label">All</div>
        </div>
        <div class="stat-card sc-pending"  onclick="filterTable('PENDING',this)">
            <div class="count">${cPending}</div><div class="label">Pending</div>
        </div>
        <div class="stat-card sc-approved" onclick="filterTable('APPROVED',this)">
            <div class="count">${cApproved}</div><div class="label">Approved</div>
        </div>
        <div class="stat-card sc-accepted" onclick="filterTable('ACCEPTED',this)">
            <div class="count">${cAccepted}</div><div class="label">Accepted</div>
        </div>
        <div class="stat-card sc-rejected" onclick="filterTable('REJECTED',this)">
            <div class="count">${cRejected}</div><div class="label">Rejected</div>
        </div>
    </div>

    <div class="toolbar">
        <div class="search-wrap">
            <svg width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg>
            <input type="text" id="searchInput" placeholder="Search by title..." oninput="searchTable()">
        </div>
    </div>

    <div class="table-card">
        <c:choose>
            <c:when test="${empty requestList}">
                <div class="empty-state">
                    <div class="ei">📭</div>
                    <p>You haven't submitted any support requests yet.</p>
                    <a href="${pageContext.request.contextPath}/createSupportRequest" class="btn btn-primary">＋ Create your first request</a>
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
                                <td>
                                    <div class="title-main" title="${r.title}">${r.title}</div>
                                    <div class="title-id">#${r.requestId}</div>
                                    <c:if test="${r.status == 'REJECTED' && not empty r.rejectReason}">
                                        <div class="reject-inline">
                                            <div class="rl">Reject reason</div>
                                            ${r.rejectReason}
                                        </div>
                                    </c:if>
                                </td>
                                <td>${not empty r.categoryName ? r.categoryName : '—'}</td>
                                <td>
                                    <span class="pri">
                                        <span class="pri-dot pri-dot-${r.priority}"></span>
                                        ${r.priority}
                                    </span>
                                </td>
                                <td><span class="badge badge-${r.status}">${r.status}</span></td>
                                <td>${not empty r.supportLocation ? r.supportLocation : '—'}</td>
                                <td class="amount">
                                    <c:choose>
                                        <c:when test="${r.estimatedAmount != null && r.estimatedAmount > 0}">
                                            <fmt:formatNumber value="${r.estimatedAmount}" type="number" maxFractionDigits="0"/> VND
                                        </c:when>
                                        <c:otherwise>—</c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="date-cell">
                                    ${not empty r.createdAt ? r.createdAt.toString().replace('T',' ').substring(0,16) : '—'}
                                </td>
                                <td class="action-col">
                                    <a class="btn-view" href="${pageContext.request.contextPath}/adminSpRequestDetail?id=${r.requestId}">View</a>
                                    <c:if test="${r.status == 'REJECTED' || r.status == 'PENDING'}">
                                        <a class="btn-edit" href="${pageContext.request.contextPath}/editSupportRequest?id=${r.requestId}">✏️ Edit</a>
                                    </c:if>
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
    let currentFilter = 'ALL';

    function filterTable(status, el) {
        currentFilter = status;
        document.querySelectorAll('.stat-card').forEach(c => c.classList.remove('active'));
        el.classList.add('active');
        applyFilters();
    }

    function searchTable() { applyFilters(); }

    function applyFilters() {
        const q = document.getElementById('searchInput').value.toLowerCase();
        document.querySelectorAll('#sprTable tbody tr').forEach(row => {
            const matchStatus = currentFilter === 'ALL' || row.dataset.status === currentFilter;
            const matchSearch = (row.dataset.title || '').toLowerCase().includes(q);
            row.style.display = (matchStatus && matchSearch) ? '' : 'none';
        });
    }
</script>
</body>
</html>
