<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>Coordinator Management</title>
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
                    background: #f5f7fa;
                }

                .page-wrapper {
                    max-width: 1400px;
                    margin: 0 auto;
                    padding: 30px;
                }

                /* ===== PAGE TITLE ===== */
                .page-title {
                    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                    color: white;
                    padding: 40px;
                    border-radius: 12px;
                    margin-bottom: 24px;
                    box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
                }

                .page-title h1 {
                    font-size: 28px;
                    font-weight: 700;
                    margin-bottom: 6px;
                }

                .page-title p {
                    font-size: 14px;
                    opacity: 0.9;
                }

                /* ===== ALERTS ===== */
                .alert {
                    padding: 14px 20px;
                    border-radius: 10px;
                    margin-bottom: 20px;
                    font-size: 14px;
                    font-weight: 500;
                }

                .alert-success {
                    background: #d4edda;
                    color: #155724;
                    border-left: 4px solid #28a745;
                }

                .alert-error {
                    background: #f8d7da;
                    color: #721c24;
                    border-left: 4px solid #dc3545;
                }

                /* ===== LAYOUT GRID ===== */
                .content-grid {
                    display: grid;
                    grid-template-columns: 1fr 380px;
                    gap: 24px;
                    align-items: start;
                }

                /* ===== CARDS ===== */
                .card {
                    background: white;
                    border-radius: 12px;
                    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.06);
                    overflow: hidden;
                }

                .card-header {
                    padding: 20px 24px;
                    border-bottom: 1px solid #f0f0f0;
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                }

                .card-header h2 {
                    font-size: 18px;
                    font-weight: 700;
                    color: #1e293b;
                }

                .card-body {
                    padding: 24px;
                }

                /* ===== TABLE ===== */
                .data-table {
                    width: 100%;
                    border-collapse: collapse;
                }

                .data-table thead {
                    background: #f8fafc;
                }

                .data-table th {
                    padding: 12px 16px;
                    text-align: left;
                    font-size: 12px;
                    color: #64748b;
                    font-weight: 600;
                    text-transform: uppercase;
                    letter-spacing: 0.5px;
                }

                .data-table td {
                    padding: 14px 16px;
                    border-bottom: 1px solid #f1f5f9;
                    font-size: 14px;
                    color: #334155;
                }

                .data-table tbody tr {
                    transition: background 0.15s;
                }

                .data-table tbody tr:hover {
                    background: #f8fafc;
                }

                .coordinator-info {
                    display: flex;
                    flex-direction: column;
                    gap: 2px;
                }

                .coordinator-name {
                    font-weight: 600;
                    color: #1e293b;
                }

                .coordinator-email {
                    font-size: 12px;
                    color: #94a3b8;
                }

                /* ===== STATUS BADGES ===== */
                .badge {
                    padding: 4px 12px;
                    border-radius: 20px;
                    font-size: 11px;
                    font-weight: 600;
                    text-transform: uppercase;
                    letter-spacing: 0.3px;
                }

                .badge-active {
                    background: #dcfce7;
                    color: #166534;
                }

                .badge-busy {
                    background: #fef3c7;
                    color: #92400e;
                }

                .badge-revoked {
                    background: #fee2e2;
                    color: #991b1b;
                }

                /* ===== ACTION BUTTONS ===== */
                .btn-action {
                    padding: 6px 14px;
                    border-radius: 6px;
                    border: none;
                    font-size: 12px;
                    font-weight: 600;
                    cursor: pointer;
                    transition: all 0.2s;
                }

                .btn-revoke {
                    background: #fee2e2;
                    color: #991b1b;
                }

                .btn-revoke:hover {
                    background: #fecaca;
                }

                .btn-reactivate {
                    background: #dcfce7;
                    color: #166534;
                }

                .btn-reactivate:hover {
                    background: #bbf7d0;
                }

                /* ===== FORMS ===== */
                .form-section {
                    margin-bottom: 24px;
                }

                .form-section:last-child {
                    margin-bottom: 0;
                }

                .form-label {
                    display: block;
                    font-size: 13px;
                    font-weight: 600;
                    color: #475569;
                    margin-bottom: 6px;
                }

                .form-input,
                .form-select {
                    width: 100%;
                    padding: 10px 14px;
                    border: 1px solid #e2e8f0;
                    border-radius: 8px;
                    font-size: 14px;
                    color: #334155;
                    transition: border-color 0.2s;
                    font-family: inherit;
                }

                .form-input:focus,
                .form-select:focus {
                    outline: none;
                    border-color: #667eea;
                    box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.15);
                }

                .btn-submit {
                    width: 100%;
                    padding: 12px;
                    border: none;
                    border-radius: 8px;
                    font-size: 14px;
                    font-weight: 600;
                    cursor: pointer;
                    transition: all 0.2s;
                    margin-top: 8px;
                }

                .btn-promote {
                    background: linear-gradient(135deg, #667eea, #764ba2);
                    color: white;
                }

                .btn-promote:hover {
                    opacity: 0.9;
                    transform: translateY(-1px);
                }

                .btn-assign {
                    background: linear-gradient(135deg, #22c55e, #16a34a);
                    color: white;
                }

                .btn-assign:hover {
                    opacity: 0.9;
                    transform: translateY(-1px);
                }

                .divider {
                    border: 0;
                    border-top: 1px solid #f1f5f9;
                    margin: 20px 0;
                }

                .section-title {
                    font-size: 15px;
                    font-weight: 700;
                    color: #334155;
                    margin-bottom: 14px;
                    display: flex;
                    align-items: center;
                    gap: 8px;
                }

                .empty-state {
                    text-align: center;
                    padding: 40px 20px;
                    color: #94a3b8;
                }

                .empty-state .icon {
                    font-size: 40px;
                    margin-bottom: 8px;
                }

                .back-link {
                    display: inline-flex;
                    align-items: center;
                    gap: 6px;
                    color: white;
                    opacity: 0.85;
                    text-decoration: none;
                    font-size: 13px;
                    margin-top: 8px;
                }

                .back-link:hover {
                    opacity: 1;
                }

                .count-badge {
                    background: rgba(255, 255, 255, 0.2);
                    padding: 2px 10px;
                    border-radius: 12px;
                    font-size: 13px;
                }

                @media (max-width: 1024px) {
                    .content-grid {
                        grid-template-columns: 1fr;
                    }
                }
            </style>
        </head>

        <body>

            <jsp:include page="/components/header.jsp" />

            <div class="page-wrapper">

                <!-- PAGE TITLE -->
                <div class="page-title">
                    <h1>👥 Coordinator Management</h1>
                    <p>Promote volunteers, assign coordinators to events, and manage access</p>
                    <a href="${pageContext.request.contextPath}/organization/dashboard" class="back-link">← Back to
                        Dashboard</a>
                </div>

                <!-- ALERTS -->
                <c:if test="${not empty msg}">
                    <div class="alert alert-success">✅ ${msg}</div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-error">❌ ${error}</div>
                </c:if>

                <div class="content-grid">

                    <!-- LEFT: COORDINATORS TABLE -->
                    <div class="card">
                        <div class="card-header">
                            <h2>Coordinators</h2>
                            <span class="badge badge-active" style="font-size: 13px;">
                                ${not empty coordinators ? coordinators.size() : 0} total
                            </span>
                        </div>

                        <c:if test="${empty coordinators}">
                            <div class="empty-state">
                                <div class="icon">👤</div>
                                <p>No coordinators yet. Promote a volunteer to get started!</p>
                            </div>
                        </c:if>

                        <c:if test="${not empty coordinators}">
                            <table class="data-table">
                                <thead>
                                    <tr>
                                        <th>Coordinator</th>
                                        <th>Event</th>
                                        <th>Status</th>
                                        <th>Promoted At</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="c" items="${coordinators}">
                                        <tr>
                                            <td>
                                                <div class="coordinator-info">
                                                    <span class="coordinator-name">${c.coordinatorName}</span>
                                                    <span class="coordinator-email">${c.coordinatorEmail}</span>
                                                </div>
                                            </td>
                                            <td>${c.eventName}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${c.status == 'Active'}">
                                                        <span class="badge badge-active">Active</span>
                                                    </c:when>
                                                    <c:when test="${c.status == 'Busy'}">
                                                        <span class="badge badge-busy">Busy</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge badge-revoked">Revoked</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td style="font-size: 13px; color: #64748b;">${c.promotedAt}</td>
                                            <td>
                                                <c:if test="${c.status != 'Revoked'}">
                                                    <form method="post" style="display:inline;"
                                                        action="${pageContext.request.contextPath}/organization/coordinators">
                                                        <input type="hidden" name="action" value="revoke" />
                                                        <input type="hidden" name="eventId" value="${c.eventId}" />
                                                        <input type="hidden" name="coordinatorId"
                                                            value="${c.coordinatorId}" />
                                                        <button type="submit" class="btn-action btn-revoke"
                                                            onclick="return confirm('Revoke this coordinator?')">
                                                            Revoke
                                                        </button>
                                                    </form>
                                                </c:if>
                                                <c:if test="${c.status == 'Revoked'}">
                                                    <form method="post" style="display:inline;"
                                                        action="${pageContext.request.contextPath}/organization/coordinators">
                                                        <input type="hidden" name="action" value="reactivate" />
                                                        <input type="hidden" name="eventId" value="${c.eventId}" />
                                                        <input type="hidden" name="coordinatorId"
                                                            value="${c.coordinatorId}" />
                                                        <button type="submit" class="btn-action btn-reactivate">
                                                            Reactivate
                                                        </button>
                                                    </form>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:if>
                    </div>

                    <!-- RIGHT: ACTION PANEL -->
                    <div>
                        <!-- PROMOTE VOLUNTEER -->
                        <div class="card" style="margin-bottom: 24px;">
                            <div class="card-header">
                                <h2>⬆️ Promote Volunteer</h2>
                            </div>
                            <div class="card-body">
                                <form method="post"
                                    action="${pageContext.request.contextPath}/organization/coordinators">
                                    <input type="hidden" name="action" value="promote" />

                                    <div class="form-section">
                                        <label class="form-label">Volunteer Email</label>
                                        <input type="email" name="email" class="form-input"
                                            placeholder="volunteer@example.com" required />
                                    </div>

                                    <div class="form-section">
                                        <label class="form-label">Assign to Event</label>
                                        <select name="eventId" class="form-select" required>
                                            <option value="">-- Select Event --</option>
                                            <c:forEach var="e" items="${events}">
                                                <option value="${e.eventId}">${e.eventName}</option>
                                            </c:forEach>
                                        </select>
                                    </div>

                                    <button type="submit" class="btn-submit btn-promote">
                                        ⬆️ Promote to Coordinator
                                    </button>
                                </form>
                            </div>
                        </div>

                        <!-- ASSIGN COORDINATOR -->
                        <div class="card">
                            <div class="card-header">
                                <h2>📋 Assign to Event</h2>
                            </div>
                            <div class="card-body">
                                <form method="post"
                                    action="${pageContext.request.contextPath}/organization/coordinators">
                                    <input type="hidden" name="action" value="assign" />

                                    <div class="form-section">
                                        <label class="form-label">Coordinator</label>
                                        <select name="coordinatorId" class="form-select" required>
                                            <option value="">-- Select Coordinator --</option>
                                            <c:forEach var="ac" items="${activeCoordinators}">
                                                <option value="${ac.coordinatorId}">
                                                    ${ac.coordinatorName} (${ac.coordinatorEmail})
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>

                                    <div class="form-section">
                                        <label class="form-label">Event</label>
                                        <select name="eventId" class="form-select" required>
                                            <option value="">-- Select Event --</option>
                                            <c:forEach var="e" items="${events}">
                                                <option value="${e.eventId}">${e.eventName}</option>
                                            </c:forEach>
                                        </select>
                                    </div>

                                    <button type="submit" class="btn-submit btn-assign">
                                        📋 Assign Coordinator
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>

                </div>

            </div>

            <jsp:include page="/components/footer.jsp" />

        </body>

        </html>