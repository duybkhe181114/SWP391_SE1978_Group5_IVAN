<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Approved Support Requests - Organization</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">

    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Inter', 'Segoe UI', sans-serif; background: #f5f7fa; min-height: 100vh; }

        .page-wrapper { max-width: 1200px; margin: 0 auto; padding: 32px 24px; }

        .breadcrumb { display: flex; align-items: center; gap: 8px; font-size: 13px; color: #94a3b8; margin-bottom: 24px; }
        .breadcrumb a { color: #6366f1; text-decoration: none; font-weight: 500; }
        .breadcrumb a:hover { text-decoration: underline; }
        .breadcrumb span.sep { color: #cbd5e1; }

        .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 28px; }
        .page-header h1 { font-size: 26px; font-weight: 700; color: #1e293b; }
        .page-header .subtitle { font-size: 14px; color: #64748b; margin-top: 4px; }

        .info-banner {
            display: flex; align-items: center; gap: 12px;
            padding: 14px 20px; background: #eff6ff; border: 1px solid #bfdbfe;
            border-radius: 12px; margin-bottom: 24px; font-size: 14px; color: #1e40af;
        }
        .info-banner svg { width: 20px; height: 20px; flex-shrink: 0; }

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

        .title-cell { font-weight: 600; color: #1e293b; }

        .status-badge {
            display: inline-flex; align-items: center; gap: 6px;
            padding: 5px 12px; border-radius: 20px; font-size: 11px; font-weight: 700;
            text-transform: uppercase; letter-spacing: 0.5px;
            background: #dcfce7; color: #166534;
        }
        .status-badge .dot { width: 7px; height: 7px; border-radius: 50%; background: #22c55e; }

        .priority-badge { font-weight: 600; font-size: 12px; }
        .priority-LOW { color: #0ea5e9; }
        .priority-MEDIUM { color: #f59e0b; }
        .priority-HIGH { color: #ef4444; }
        .priority-URGENT { color: #fff; background: #991b1b; padding: 3px 10px; border-radius: 6px; font-size: 11px; }

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
    </style>
</head>
<body>

<%@ include file="/components/header.jsp" %>

<div class="page-wrapper">

    <div class="breadcrumb">
        <a href="${pageContext.request.contextPath}/organization/dashboard">Dashboard</a>
        <span class="sep">/</span>
        <span>Support Requests</span>
    </div>

    <div class="page-header">
        <div>
            <h1>Approved Support Requests</h1>
            <div class="subtitle">Review and accept approved support requests</div>
        </div>
    </div>

    <div class="info-banner">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="12" y1="16" x2="12" y2="12"/><line x1="12" y1="8" x2="12.01" y2="8"/></svg>
        These are requests that have been approved by an Admin. You can accept them to indicate your organization will fulfil the request.
    </div>

    <c:if test="${empty requestList}">
        <div class="table-container">
            <div class="empty-state">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/></svg>
                <h3>No approved requests available</h3>
                <p>There are no approved support requests at this time.</p>
            </div>
        </div>
    </c:if>

    <c:if test="${not empty requestList}">
        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Title</th>
                        <th>Category</th>
                        <th>Priority</th>
                        <th>Status</th>
                        <th>Location</th>
                        <th>Amount</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="r" items="${requestList}">
                        <tr>
                            <td style="color:#94a3b8; font-weight:500;">#${r.requestId}</td>
                            <td class="title-cell">${r.title}</td>
                            <td>${r.categoryName}</td>
                            <td><span class="priority-badge priority-${r.priority}">${r.priority}</span></td>
                            <td>
                                <span class="status-badge">
                                    <span class="dot"></span>
                                    ${r.status}
                                </span>
                            </td>
                            <td>${r.supportLocation}</td>
                            <td style="font-weight:600;">
                                <c:if test="${r.estimatedAmount > 0}">
                                    <fmt:formatNumber value="${r.estimatedAmount}" type="currency" currencySymbol="$"/>
                                </c:if>
                                <c:if test="${r.estimatedAmount == 0}">—</c:if>
                            </td>
                            <td>
                                <a class="detail-btn" href="${pageContext.request.contextPath}/orgSpRequestDetail?id=${r.requestId}">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
                                    View
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </c:if>

</div>

</body>
</html>