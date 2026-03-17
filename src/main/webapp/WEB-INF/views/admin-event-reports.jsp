<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Event Reports - Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <style>
        body { background: #f8fafc; font-family: 'Segoe UI', sans-serif; }
        .shell { max-width: 1360px; margin: 0 auto; padding: 28px 18px 60px; }

        /* Hero */
        .hero { padding: 28px; border-radius: 24px; color: #f8fafc;
                background: linear-gradient(135deg, #0f172a 0%, #1e293b 55%, #334155 100%);
                box-shadow: 0 24px 60px rgba(15,23,42,.16); }
        .hero h1 { margin: 10px 0 8px; font-size: clamp(28px,4vw,40px); }
        .hero p  { margin: 0; color: rgba(248,250,252,.8); line-height: 1.7; max-width: 760px; }
        .hero-chip { display: inline-flex; padding: 8px 14px; border-radius: 999px;
                     background: rgba(255,255,255,.12); color: #fde68a;
                     font-size: 12px; font-weight: 700; letter-spacing: .08em; text-transform: uppercase; }
        .stats-row { display: grid; grid-template-columns: repeat(4,1fr); gap: 14px; margin-top: 22px; }
        .stat-card { padding: 16px 18px; border-radius: 16px;
                     background: rgba(255,255,255,.09); border: 1px solid rgba(255,255,255,.14); }
        .stat-label { font-size: 11px; font-weight: 700; text-transform: uppercase;
                      letter-spacing: .08em; color: rgba(226,232,240,.76); }
        .stat-value { margin-top: 6px; font-size: 28px; font-weight: 800; color: #fff; }

        /* Tabs */
        .tabs { display: flex; gap: 4px; margin-top: 22px; }
        .tab-btn { padding: 10px 20px; border-radius: 12px; border: 1px solid rgba(255,255,255,.18);
                   background: rgba(15,23,42,.18); color: #e2e8f0;
                   font-size: 14px; font-weight: 700; cursor: pointer; text-decoration: none; }
        .tab-btn.active { background: #fff; color: #0f172a; border-color: #fff; }

        /* Section card */
        .section { margin-top: 22px; padding: 24px; border-radius: 24px;
                   border: 1px solid #e2e8f0; background: #fff;
                   box-shadow: 0 14px 30px rgba(15,23,42,.05); }
        .section h2 { margin: 0 0 6px; color: #0f172a; font-size: 22px; }
        .section-note { margin: 0 0 18px; color: #64748b; font-size: 14px; line-height: 1.6; }

        /* Toolbar */
        .toolbar form { display: grid; grid-template-columns: minmax(0,2fr) minmax(200px,.8fr) auto; gap: 14px; align-items: end; }
        .field { display: grid; gap: 6px; }
        .field label { color: #475569; font-size: 13px; font-weight: 700; }
        .field input, .field select { width: 100%; box-sizing: border-box; padding: 11px 13px;
                                      border: 1px solid #cbd5e1; border-radius: 12px; font: inherit; }

        /* Table */
        .tbl-wrap { overflow-x: auto; margin-top: 18px; }
        table { width: 100%; border-collapse: collapse; font-size: 14px; }
        th { padding: 10px 14px; background: #f1f5f9; color: #475569;
             font-size: 12px; font-weight: 700; text-transform: uppercase;
             letter-spacing: .06em; text-align: left; white-space: nowrap; }
        td { padding: 12px 14px; border-bottom: 1px solid #f1f5f9; color: #0f172a; vertical-align: middle; }
        tr:last-child td { border-bottom: none; }
        tr:hover td { background: #f8fafc; }

        /* Chips */
        .chip { display: inline-flex; padding: 4px 10px; border-radius: 999px;
                font-size: 11px; font-weight: 700; text-transform: uppercase; letter-spacing: .05em; }
        .chip-approved { background: #dcfce7; color: #166534; }
        .chip-pending  { background: #fff7ed; color: #c2410c; }
        .chip-rejected { background: #fee2e2; color: #991b1b; }
        .chip-closed   { background: #e2e8f0; color: #334155; }

        /* Stars */
        .stars { color: #f59e0b; font-size: 13px; }

        /* Impact report form */
        .impact-form { display: grid; gap: 14px; }
        .impact-form .row2 { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; }
        .impact-form label { display: block; color: #334155; font-size: 13px; font-weight: 700; margin-bottom: 6px; }
        .impact-form input, .impact-form select, .impact-form textarea {
            width: 100%; box-sizing: border-box; padding: 11px 13px;
            border: 1px solid #cbd5e1; border-radius: 12px; font: inherit; }
        .impact-form textarea { min-height: 90px; resize: vertical; }

        /* Impact report cards */
        .ir-grid { display: grid; gap: 16px; margin-top: 18px; }
        .ir-card { padding: 20px; border-radius: 18px; border: 1px solid #e2e8f0;
                   background: linear-gradient(180deg,#fff 0%,#f8fafc 100%); }
        .ir-title { font-size: 16px; font-weight: 700; color: #0f172a; margin-bottom: 6px; }
        .ir-meta  { font-size: 13px; color: #64748b; margin-bottom: 10px; }
        .ir-summary { font-size: 14px; color: #334155; line-height: 1.6; }
        .ir-stats { display: flex; gap: 20px; margin-top: 12px; }
        .ir-stat  { font-size: 13px; color: #475569; }
        .ir-stat strong { color: #0f172a; }

        /* Buttons */
        .btn { display: inline-flex; align-items: center; justify-content: center;
               padding: 11px 18px; border-radius: 12px; border: 1px solid transparent;
               font-size: 14px; font-weight: 700; cursor: pointer; text-decoration: none; }
        .btn-primary { background: #0f172a; color: #fff; }
        .btn-secondary { background: #eff6ff; color: #1d4ed8; }
        .btn-clear { background: #f8fafc; color: #475569; border-color: #cbd5e1; }

        /* Alert */
        .alert { padding: 13px 16px; border-radius: 12px; font-size: 14px; margin-bottom: 18px; }
        .alert-success { background: #ecfdf5; border: 1px solid #a7f3d0; color: #166534; }
        .alert-error   { background: #fef2f2; border: 1px solid #fecaca; color: #b91c1c; }

        .empty { padding: 40px 20px; border: 1px dashed #cbd5e1; border-radius: 16px;
                 background: #f8fafc; text-align: center; color: #94a3b8; }

        @media (max-width: 900px) {
            .stats-row { grid-template-columns: repeat(2,1fr); }
            .toolbar form { grid-template-columns: 1fr; }
            .impact-form .row2 { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
<jsp:include page="/components/header.jsp"/>

<div class="shell">

    <!-- HERO -->
    <div class="hero">
        <span class="hero-chip">Admin · Reports</span>
        <h1>📊 Event Reports</h1>
        <p>View participation statistics, volunteer feedback, and create impact reports for completed events.</p>

        <div class="stats-row">
            <div class="stat-card">
                <div class="stat-label">Total Events</div>
                <div class="stat-value">${summaryStats.totalEvents}</div>
            </div>
            <div class="stat-card">
                <div class="stat-label">Approved Events</div>
                <div class="stat-value">${summaryStats.approvedEvents}</div>
            </div>
            <div class="stat-card">
                <div class="stat-label">Total Participants</div>
                <div class="stat-value">${summaryStats.totalParticipants}</div>
            </div>
            <div class="stat-card">
                <div class="stat-label">Feedback Received</div>
                <div class="stat-value">${summaryStats.totalFeedback}</div>
            </div>
        </div>

        <div class="tabs">
            <a href="?tab=reports<c:if test='${not empty param.q}'>&q=${param.q}</c:if><c:if test='${not empty param.status}'>&status=${param.status}</c:if>"
               class="tab-btn ${(empty param.tab || param.tab == 'reports') ? 'active' : ''}">Event Reports</a>
            <a href="?tab=impact"
               class="tab-btn ${param.tab == 'impact' ? 'active' : ''}">Impact Reports</a>
        </div>
    </div>

    <!-- ===== TAB: EVENT REPORTS ===== -->
    <c:if test="${empty param.tab || param.tab == 'reports'}">
    <div class="section">
        <h2>Event Participation &amp; Feedback</h2>
        <p class="section-note">Each row shows volunteer participation counts and aggregated feedback ratings per event.</p>

        <div class="toolbar">
            <form method="get" action="${pageContext.request.contextPath}/admin/event-reports">
                <input type="hidden" name="tab" value="reports">
                <div class="field">
                    <label>Search</label>
                    <input type="text" name="q" value="${param.q}" placeholder="Event title or organization">
                </div>
                <div class="field">
                    <label>Status</label>
                    <select name="status">
                        <option value="">All</option>
                        <option value="Approved" ${param.status == 'Approved' ? 'selected' : ''}>Approved</option>
                        <option value="Pending"  ${param.status == 'Pending'  ? 'selected' : ''}>Pending</option>
                        <option value="Rejected" ${param.status == 'Rejected' ? 'selected' : ''}>Rejected</option>
                        <option value="Closed"   ${param.status == 'Closed'   ? 'selected' : ''}>Closed</option>
                    </select>
                </div>
                <div style="display:flex;gap:8px;align-items:end;">
                    <button type="submit" class="btn btn-secondary">Filter</button>
                    <a href="?tab=reports" class="btn btn-clear">Clear</a>
                </div>
            </form>
        </div>

        <c:choose>
            <c:when test="${empty eventReports}">
                <div class="empty"><p>No events matched the current filters.</p></div>
            </c:when>
            <c:otherwise>
                <div class="tbl-wrap">
                    <table>
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Event</th>
                                <th>Organization</th>
                                <th>Status</th>
                                <th>Dates</th>
                                <th>Approved</th>
                                <th>Pending</th>
                                <th>Capacity</th>
                                <th>Feedback</th>
                                <th>Avg Rating</th>
                            </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="r" items="${eventReports}" varStatus="vs">
                            <tr>
                                <td style="color:#94a3b8;">${vs.count}</td>
                                <td style="font-weight:600;">${r.title}</td>
                                <td>${r.orgName}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${r.status == 'Approved'}"><span class="chip chip-approved">Approved</span></c:when>
                                        <c:when test="${r.status == 'Pending'}"> <span class="chip chip-pending">Pending</span></c:when>
                                        <c:when test="${r.status == 'Rejected'}"><span class="chip chip-rejected">Rejected</span></c:when>
                                        <c:otherwise><span class="chip chip-closed">${r.status}</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td style="white-space:nowrap;">
                                    <c:if test="${not empty r.startDate}"><fmt:formatDate value="${r.startDate}" pattern="dd MMM yyyy"/></c:if>
                                    <c:if test="${not empty r.endDate}"> – <fmt:formatDate value="${r.endDate}" pattern="dd MMM yyyy"/></c:if>
                                    <c:if test="${empty r.startDate}">—</c:if>
                                </td>
                                <td style="text-align:center;font-weight:700;color:#16a34a;">${r.approvedVolunteers}</td>
                                <td style="text-align:center;color:#c2410c;">${r.pendingVolunteers}</td>
                                <td style="text-align:center;">${r.maxVolunteers == 0 ? '∞' : r.maxVolunteers}</td>
                                <td style="text-align:center;">${r.totalFeedback}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty r.avgRating}">
                                            <span class="stars">★</span>
                                            <fmt:formatNumber value="${r.avgRating}" maxFractionDigits="1"/>
                                        </c:when>
                                        <c:otherwise><span style="color:#cbd5e1;">—</span></c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
    </c:if>

    <!-- ===== TAB: IMPACT REPORTS ===== -->
    <c:if test="${param.tab == 'impact'}">

        <c:if test="${param.success == '1'}"><div class="alert alert-success">Impact report created successfully.</div></c:if>
        <c:if test="${param.error   == '1'}"><div class="alert alert-error">Failed to create impact report. Please try again.</div></c:if>

        <!-- Create form -->
        <div class="section">
            <h2>Create Impact Report</h2>
            <p class="section-note">Document the real-world outcomes of a completed event.</p>

            <form method="post" action="${pageContext.request.contextPath}/admin/event-reports" class="impact-form">
                <div>
                    <label for="eventId">Event</label>
                    <select name="eventId" id="eventId" required>
                        <option value="">— Select an event —</option>
                        <c:forEach var="r" items="${eventReports}">
                            <option value="${r.eventId}">${r.title} (${r.orgName})</option>
                        </c:forEach>
                    </select>
                </div>
                <div>
                    <label for="summary">Summary</label>
                    <textarea name="summary" id="summary" placeholder="Describe the impact and outcomes of this event…" required></textarea>
                </div>
                <div class="row2">
                    <div>
                        <label for="peopleImpacted">People Impacted</label>
                        <input type="number" name="peopleImpacted" id="peopleImpacted" min="0" value="0" required>
                    </div>
                    <div>
                        <label for="fundsRaised">Funds Raised (VND, optional)</label>
                        <input type="number" name="fundsRaised" id="fundsRaised" min="0" step="1000" placeholder="0">
                    </div>
                </div>
                <div>
                    <button type="submit" class="btn btn-primary">Save Impact Report</button>
                </div>
            </form>
        </div>

        <!-- Existing reports -->
        <div class="section">
            <h2>All Impact Reports</h2>
            <p class="section-note">Previously created impact reports across all events.</p>

            <c:choose>
                <c:when test="${empty impactReports}">
                    <div class="empty"><p>No impact reports have been created yet.</p></div>
                </c:when>
                <c:otherwise>
                    <div class="ir-grid">
                        <c:forEach var="ir" items="${impactReports}">
                            <div class="ir-card">
                                <div class="ir-title">${ir.eventTitle}</div>
                                <div class="ir-meta">
                                    Created by ${ir.createdByName} ·
                                    <fmt:formatDate value="${ir.createdAt}" pattern="dd MMM yyyy HH:mm"/>
                                </div>
                                <div class="ir-summary">${ir.summary}</div>
                                <div class="ir-stats">
                                    <div class="ir-stat">👥 People Impacted: <strong>${ir.peopleImpacted}</strong></div>
                                    <c:if test="${not empty ir.fundsRaised}">
                                        <div class="ir-stat">💰 Funds Raised: <strong><fmt:formatNumber value="${ir.fundsRaised}" type="number" maxFractionDigits="0"/> VND</strong></div>
                                    </c:if>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </c:if>

</div>

<jsp:include page="/components/footer.jsp"/>
</body>
</html>
