<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="/components/header.jsp"/>

<style>
    body { background: #f1f5f9; }

    .ws-header {
        background: linear-gradient(135deg, #1e293b 0%, #334155 100%);
        padding: 32px 40px;
        color: white;
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 32px;
        border-radius: 0 0 24px 24px;
    }
    .ws-header h1 { margin: 0 0 4px 0; font-size: 24px; font-weight: 800; }
    .ws-header .sub { opacity: 0.7; font-size: 14px; }
    .ws-header .back { color: rgba(255,255,255,0.6); text-decoration: none; font-size: 13px; font-weight: 600; display:inline-block; margin-bottom:8px; }
    .ws-header .back:hover { color: white; }

    .ws-counter-strip { display: flex; gap: 12px; }
    .ws-counter {
        background: rgba(255,255,255,0.12);
        border: 1px solid rgba(255,255,255,0.2);
        border-radius: 10px;
        padding: 10px 18px;
        text-align: center;
        min-width: 80px;
    }
    .ws-counter .num { font-size: 22px; font-weight: 800; }
    .ws-counter .lbl { font-size: 11px; opacity: 0.7; text-transform: uppercase; letter-spacing: 0.4px; }

    .kanban-board { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; align-items: start; }

    .kanban-col {
        background: white;
        border-radius: 16px;
        overflow: hidden;
        box-shadow: 0 2px 12px rgba(0,0,0,0.04);
        border: 1px solid #e2e8f0;
    }
    .col-header {
        padding: 16px 20px;
        display: flex;
        align-items: center;
        justify-content: space-between;
        border-bottom: 1px solid #f1f5f9;
    }
    .col-header .col-title { font-size: 13px; font-weight: 800; text-transform: uppercase; letter-spacing: 0.6px; display: flex; align-items: center; gap: 8px; }
    .col-count { font-size: 12px; font-weight: 700; padding: 2px 8px; border-radius: 20px; }
    .col-body { padding: 16px; min-height: 400px; }

    .task-card {
        background: #f8fafc;
        border: 1px solid #e2e8f0;
        border-radius: 12px;
        padding: 16px;
        margin-bottom: 14px;
        transition: 0.2s;
    }
    .task-card:hover { box-shadow: 0 6px 20px rgba(0,0,0,0.07); transform: translateY(-2px); }
    .task-card:last-child { margin-bottom: 0; }

    .task-card-top { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 10px; }
    .task-desc { font-size: 14px; font-weight: 600; color: #1e293b; line-height: 1.5; flex: 1; margin-right: 8px; }

    .priority-badge { display:inline-flex; align-items:center; gap:4px; font-size:11px; font-weight:700; padding:3px 9px; border-radius:20px; white-space:nowrap; flex-shrink:0; }
    .priority-High   { background:#fee2e2; color:#991b1b; }
    .priority-Medium { background:#fef9c3; color:#854d0e; }
    .priority-Low    { background:#dcfce7; color:#166534; }

    .task-meta { background: white; border: 1px solid #f1f5f9; border-radius: 8px; padding: 10px 12px; margin-bottom: 12px; }
    .task-meta-row { display: flex; align-items: center; gap: 6px; font-size: 12px; color: #64748b; margin-bottom: 4px; }
    .task-meta-row:last-child { margin-bottom: 0; }

    .task-action-btn {
        width: 100%; padding: 10px; border: none; border-radius: 8px;
        font-weight: 700; font-size: 13px; cursor: pointer; transition: 0.15s;
    }
    .btn-start    { background: #4f46e5; color: white; }
    .btn-start:hover { background: #4338ca; }
    .btn-complete { background: #10b981; color: white; }
    .btn-complete:hover { background: #059669; }

    .note-input {
        width: 100%; padding: 8px 10px; border: 1px solid #e2e8f0;
        border-radius: 8px; font-size: 12px; resize: vertical;
        margin-bottom: 8px; font-family: inherit; color: #475569;
        background: white;
    }
    .note-input:focus { outline: none; border-color: #a5b4fc; }

    .done-badge {
        text-align: center; font-size: 12px; font-weight: 700;
        padding: 8px; border-radius: 8px; margin-top: 8px;
    }
    .done-confirmed { background: #dcfce7; color: #166534; }
    .done-awaiting  { background: #dbeafe; color: #1e40af; }

    .empty-col { text-align: center; padding: 48px 20px; color: #cbd5e1; }
    .empty-col .icon { font-size: 36px; margin-bottom: 10px; }
    .empty-col .txt { font-size: 13px; }
</style>

<%-- Count tasks per column for header counters --%>
<c:set var="cntPending"    value="0"/>
<c:set var="cntProgress"   value="0"/>
<c:set var="cntDone"       value="0"/>
<c:forEach items="${myTasks}" var="t">
    <c:if test="${t.status == 'Pending'}">    <c:set var="cntPending"  value="${cntPending  + 1}"/></c:if>
    <c:if test="${t.status == 'In Progress'}"><c:set var="cntProgress" value="${cntProgress + 1}"/></c:if>
    <c:if test="${t.status == 'Completed' || t.status == 'Confirmed'}"><c:set var="cntDone" value="${cntDone + 1}"/></c:if>
</c:forEach>

<div class="ws-header">
    <div>
        <a href="${pageContext.request.contextPath}/event/detail?id=${event.eventId}" class="back">← Back to Event</a>
        <h1>My Workspace</h1>
        <div class="sub">📍 ${event.eventName}</div>
    </div>
    <div class="ws-counter-strip">
        <div class="ws-counter">
            <div class="num">${myTasks.size()}</div>
            <div class="lbl">Total</div>
        </div>
        <div class="ws-counter">
            <div class="num">${cntPending}</div>
            <div class="lbl">To Do</div>
        </div>
        <div class="ws-counter">
            <div class="num">${cntProgress}</div>
            <div class="lbl">Active</div>
        </div>
        <div class="ws-counter">
            <div class="num">${cntDone}</div>
            <div class="lbl">Done</div>
        </div>
    </div>
</div>

<div style="max-width:1300px; margin:0 auto; padding: 0 24px 80px;">
<div class="kanban-board">

    <%-- TO DO --%>
    <div class="kanban-col">
        <div class="col-header" style="border-top: 4px solid #f59e0b;">
            <div class="col-title" style="color:#92400e;">🕒 To Do</div>
            <span class="col-count" style="background:#fef9c3;color:#92400e;">${cntPending}</span>
        </div>
        <div class="col-body">
            <c:set var="hasAny" value="false"/>
            <c:forEach items="${myTasks}" var="t">
                <c:if test="${t.status == 'Pending'}">
                    <c:set var="hasAny" value="true"/>
                    <div class="task-card">
                        <div class="task-card-top">
                            <div class="task-desc">${t.description}</div>
                            <span class="priority-badge priority-${t.priority}">
                                <c:choose>
                                    <c:when test="${t.priority == 'High'}">🔴</c:when>
                                    <c:when test="${t.priority == 'Low'}">🟢</c:when>
                                    <c:otherwise>🟡</c:otherwise>
                                </c:choose>
                                ${t.priority}
                            </span>
                        </div>
                        <div class="task-meta">
                            <div class="task-meta-row">📅 <span>${t.workDate}</span></div>
                            <div class="task-meta-row">⏰ <span>${t.startTime} – ${t.endTime}</span></div>
                            <div class="task-meta-row">👤 <span>${t.coordinatorName}</span></div>
                        </div>
                        <form method="post" action="${pageContext.request.contextPath}/volunteer/update-task">
                            <input type="hidden" name="eventId" value="${event.eventId}">
                            <input type="hidden" name="taskId"  value="${t.taskId}">
                            <button type="submit" name="action" value="start" class="task-action-btn btn-start">▶ Start Working</button>
                        </form>
                    </div>
                </c:if>
            </c:forEach>
            <c:if test="${!hasAny}">
                <div class="empty-col">
                    <div class="icon">✅</div>
                    <div class="txt">No pending tasks</div>
                </div>
            </c:if>
        </div>
    </div>

    <%-- IN PROGRESS --%>
    <div class="kanban-col">
        <div class="col-header" style="border-top: 4px solid #4f46e5;">
            <div class="col-title" style="color:#3730a3;">🚀 In Progress</div>
            <span class="col-count" style="background:#e0e7ff;color:#3730a3;">${cntProgress}</span>
        </div>
        <div class="col-body">
            <c:set var="hasAny" value="false"/>
            <c:forEach items="${myTasks}" var="t">
                <c:if test="${t.status == 'In Progress'}">
                    <c:set var="hasAny" value="true"/>
                    <div class="task-card" style="border-left: 3px solid #4f46e5;">
                        <div class="task-card-top">
                            <div class="task-desc">${t.description}</div>
                            <span class="priority-badge priority-${t.priority}">
                                <c:choose>
                                    <c:when test="${t.priority == 'High'}">🔴</c:when>
                                    <c:when test="${t.priority == 'Low'}">🟢</c:when>
                                    <c:otherwise>🟡</c:otherwise>
                                </c:choose>
                                ${t.priority}
                            </span>
                        </div>
                        <div class="task-meta">
                            <div class="task-meta-row">📅 <span>${t.workDate}</span></div>
                            <div class="task-meta-row">⏰ <span>${t.startTime} – ${t.endTime}</span></div>
                            <div class="task-meta-row">👤 <span>${t.coordinatorName}</span></div>
                        </div>
                        <form method="post" action="${pageContext.request.contextPath}/volunteer/update-task">
                            <input type="hidden" name="eventId" value="${event.eventId}">
                            <input type="hidden" name="taskId"  value="${t.taskId}">
                            <textarea name="note" rows="2" class="note-input" placeholder="Add a completion note (optional)..."></textarea>
                            <button type="submit" name="action" value="complete" class="task-action-btn btn-complete">✅ Mark as Completed</button>
                        </form>
                    </div>
                </c:if>
            </c:forEach>
            <c:if test="${!hasAny}">
                <div class="empty-col">
                    <div class="icon">🚀</div>
                    <div class="txt">Nothing in progress</div>
                </div>
            </c:if>
        </div>
    </div>

    <%-- DONE --%>
    <div class="kanban-col">
        <div class="col-header" style="border-top: 4px solid #10b981;">
            <div class="col-title" style="color:#065f46;">🎉 Done</div>
            <span class="col-count" style="background:#dcfce7;color:#065f46;">${cntDone}</span>
        </div>
        <div class="col-body">
            <c:set var="hasAny" value="false"/>
            <c:forEach items="${myTasks}" var="t">
                <c:if test="${t.status == 'Completed' || t.status == 'Confirmed'}">
                    <c:set var="hasAny" value="true"/>
                    <div class="task-card" style="opacity:0.9;">
                        <div class="task-card-top">
                            <div class="task-desc" style="color:#475569;">${t.description}</div>
                            <span class="priority-badge priority-${t.priority}">
                                <c:choose>
                                    <c:when test="${t.priority == 'High'}">🔴</c:when>
                                    <c:when test="${t.priority == 'Low'}">🟢</c:when>
                                    <c:otherwise>🟡</c:otherwise>
                                </c:choose>
                                ${t.priority}
                            </span>
                        </div>
                        <div class="task-meta">
                            <div class="task-meta-row">📅 <span>${t.workDate}</span></div>
                            <div class="task-meta-row">⏰ <span>${t.startTime} – ${t.endTime}</span></div>
                            <div class="task-meta-row">👤 <span>${t.coordinatorName}</span></div>
                        </div>
                        <c:if test="${t.status == 'Confirmed'}">
                            <div class="done-badge done-confirmed">✅ Confirmed by Coordinator</div>
                        </c:if>
                        <c:if test="${t.status == 'Completed'}">
                            <div class="done-badge done-awaiting">⏳ Awaiting Coordinator Confirmation</div>
                        </c:if>
                    </div>
                </c:if>
            </c:forEach>
            <c:if test="${!hasAny}">
                <div class="empty-col">
                    <div class="icon">🎯</div>
                    <div class="txt">No completed tasks yet</div>
                </div>
            </c:if>
        </div>
    </div>

</div>
</div>

<jsp:include page="/components/footer.jsp"/>
