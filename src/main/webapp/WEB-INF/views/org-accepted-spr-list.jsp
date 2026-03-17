<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Accepted Support Requests - IVAN</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <style>
        body { background: #f1f5f9; font-family: 'Inter', 'Segoe UI', sans-serif; margin: 0; }
        .page-wrapper { max-width: 1200px; margin: 0 auto; padding: 40px 24px 60px; }

        .page-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 28px; }
        .page-header h1 { font-size: 26px; font-weight: 700; color: #1e293b; margin: 0 0 4px; }
        .page-header .subtitle { font-size: 14px; color: #64748b; }
        .btn-back { display: inline-flex; align-items: center; gap: 6px; padding: 9px 18px; background: white; color: #475569; border: 1.5px solid #e2e8f0; border-radius: 8px; font-size: 13px; font-weight: 600; text-decoration: none; }
        .btn-back:hover { background: #f8fafc; }

        .filter-bar { display: flex; gap: 10px; margin-bottom: 20px; }
        .filter-bar input { padding: 8px 14px; border: 1.5px solid #e2e8f0; border-radius: 8px; font-size: 13px; width: 260px; outline: none; }
        .filter-bar input:focus { border-color: #6366f1; }

        .table-card { background: white; border-radius: 14px; box-shadow: 0 2px 12px rgba(0,0,0,0.05); overflow-x: auto; }
        table { width: 100%; border-collapse: collapse; min-width: 900px; }
        thead { background: #1e293b; }
        thead th { padding: 14px 16px; text-align: left; font-size: 12px; font-weight: 600; color: #94a3b8; text-transform: uppercase; letter-spacing: 0.5px; }
        tbody tr { border-bottom: 1px solid #f1f5f9; transition: background 0.15s; }
        tbody tr:last-child { border-bottom: none; }
        tbody tr:hover { background: #f8fafc; }
        td { padding: 14px 16px; font-size: 14px; color: #334155; vertical-align: middle; }

        .badge-ACCEPTED { background: #dbeafe; color: #1d4ed8; padding: 4px 12px; border-radius: 20px; font-size: 11px; font-weight: 700; text-transform: uppercase; display: inline-block; }

        .priority-tag { display: inline-flex; align-items: center; font-size: 12px; font-weight: 600; padding: 3px 10px; border-radius: 20px; }
        .priority-LOW    { background: #f0f9ff; color: #0369a1; }
        .priority-MEDIUM { background: #fffbeb; color: #b45309; }
        .priority-HIGH   { background: #fef2f2; color: #dc2626; }
        .priority-URGENT { background: #450a0a; color: #fecaca; }

        .title-cell .title-text { font-weight: 600; color: #1e293b; }
        .title-cell .id-text { font-size: 12px; color: #94a3b8; }

        .btn-view { padding: 6px 14px; background: #6366f1; color: white; text-decoration: none; border-radius: 6px; font-size: 12px; font-weight: 600; transition: background 0.2s; }
        .btn-view:hover { background: #4f46e5; }

        .btn-create-event { padding: 6px 14px; background: linear-gradient(135deg,#6366f1,#8b5cf6); color: white; text-decoration: none; border-radius: 6px; font-size: 12px; font-weight: 600; transition: all 0.2s; white-space: nowrap; }
        .btn-create-event:hover { opacity: 0.88; }
        .btn-view-event { padding: 6px 14px; background: #f0fdf4; color: #16a34a; border: 1.5px solid #bbf7d0; text-decoration: none; border-radius: 6px; font-size: 12px; font-weight: 600; white-space: nowrap; }
        .btn-view-event:hover { background: #dcfce7; }
        .empty-state .icon { font-size: 48px; margin-bottom: 12px; }
        .empty-state p { font-size: 14px; }
    </style>
</head>
<body>

<%@ include file="/components/header.jsp" %>

<div class="page-wrapper">
    <div class="page-header">
        <div>
            <h1>✅ Accepted Support Requests</h1>
            <div class="subtitle">Support requests your organization has committed to handle</div>
        </div>
        <a href="${pageContext.request.contextPath}/org/support-requests" class="btn-back">← Browse Available Requests</a>
    </div>

    <div class="filter-bar">
        <input type="text" id="searchInput" placeholder="🔍 Search by title or location..." oninput="searchTable()">
    </div>

    <div class="table-card">
        <c:choose>
            <c:when test="${empty acceptedList}">
                <div class="empty-state">
                    <div class="icon">📭</div>
                    <p>Your organization hasn't accepted any support requests yet.</p>
                </div>
            </c:when>
            <c:otherwise>
                <table id="sprTable">
                    <thead>
                        <tr>
                            <th>Request</th>
                            <th>Category</th>
                            <th>Priority</th>
                            <th>Location</th>
                            <th>Beneficiary</th>
                            <th>Estimated</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="r" items="${acceptedList}">
                            <tr data-title="${r.title}" data-location="${r.supportLocation}">
                                <td class="title-cell">
                                    <div class="title-text">${r.title}</div>
                                    <div class="id-text">#${r.requestId}</div>
                                </td>
                                <td>${not empty r.categoryName ? r.categoryName : '—'}</td>
                                <td><span class="priority-tag priority-${r.priority}">${r.priority}</span></td>
                                <td>${not empty r.supportLocation ? r.supportLocation : '—'}</td>
                                <td>${not empty r.beneficiaryName ? r.beneficiaryName : '—'}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${r.estimatedAmount != null && r.estimatedAmount > 0}">
                                            <fmt:formatNumber value="${r.estimatedAmount}" type="number" maxFractionDigits="0"/> VND
                                        </c:when>
                                        <c:otherwise>—</c:otherwise>
                                    </c:choose>
                                </td>
                                <td><span class="badge-ACCEPTED">ACCEPTED</span></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${linkedEventMap[r.requestId] != null}">
                                            <a href="${pageContext.request.contextPath}/events/${linkedEventMap[r.requestId]}" class="btn-view-event">✅ View Event</a>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="${pageContext.request.contextPath}/organization/create-event?supportRequestId=${r.requestId}" class="btn-create-event">➕ Create Event</a>
                                        </c:otherwise>
                                    </c:choose>
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
    function searchTable() {
        const q = document.getElementById('searchInput').value.toLowerCase();
        document.querySelectorAll('#sprTable tbody tr').forEach(row => {
            const title = (row.dataset.title || '').toLowerCase();
            const loc = (row.dataset.location || '').toLowerCase();
            row.style.display = (title.includes(q) || loc.includes(q)) ? '' : 'none';
        });
    }
</script>
</body>
</html>
