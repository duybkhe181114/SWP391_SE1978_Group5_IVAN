<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<jsp:include page="/components/header.jsp"/>

<style>
/* NỀN VÀ BỐ CỤC TỔNG THỂ */
.coord-page { background-color: #f8fafc; min-height: 100vh; padding: 40px 0; font-family: 'Inter', sans-serif; }
.coord-container { max-width: 1400px; margin: 0 auto; padding: 0 30px; }

/* HEADER */
.coord-header { background: white; border-radius: 16px; padding: 25px 35px; margin-bottom: 30px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); border: 1px solid #e2e8f0; display: flex; justify-content: space-between; align-items: center; position: relative; overflow: hidden; }
.coord-header::before { content: ''; position: absolute; top: 0; left: 0; width: 100%; height: 4px; background: linear-gradient(135deg, #667eea, #764ba2); }
.coord-title { font-size: 24px; font-weight: 800; color: #0f172a; margin: 0; display: flex; align-items: center; gap: 10px; }
.event-badge { background: #f5f3ff; color: #6d28d9; padding: 8px 16px; border-radius: 10px; font-weight: 700; font-size: 14px; border: 1px solid #ddd6fe; display: flex; align-items: center; gap: 8px; }

/* TABS */
.tabs-nav { display: inline-flex; background: #e2e8f0; border-radius: 12px; padding: 6px; margin-bottom: 30px; gap: 4px; }
.tab-btn { padding: 10px 24px; background: transparent; border: none; border-radius: 8px; font-size: 14px; font-weight: 600; color: #475569; cursor: pointer; transition: all 0.2s ease; display: flex; align-items: center; gap: 8px; }
.tab-btn:hover { color: #0f172a; }
.tab-btn.active { background: white; color: #4f46e5; box-shadow: 0 1px 3px rgba(0,0,0,0.1); }
.tab-content { display: none; }
.tab-content.active { display: block; animation: fadeIn 0.4s ease forwards; }
@keyframes fadeIn { from { opacity: 0; transform: translateY(8px); } to { opacity: 1; transform: translateY(0); } }

/* CARD */
.card { background: white; border-radius: 16px; padding: 30px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); border: 1px solid #e2e8f0; }
.card-title { font-size: 18px; font-weight: 800; color: #0f172a; margin: 0 0 25px 0; display: flex; align-items: center; gap: 10px; border-bottom: 1px solid #f1f5f9; padding-bottom: 15px; }

/* FORM */
.form-group { margin-bottom: 20px; }
.form-label { display: block; font-size: 13px; font-weight: 700; color: #475569; margin-bottom: 8px; }
.form-input, .form-select, .form-textarea { width: 100%; padding: 12px 16px; border: 1px solid #cbd5e1; border-radius: 10px; font-size: 14px; transition: 0.2s; font-family: inherit; background: #f8fafc; color: #1e293b; box-sizing: border-box; }
.form-input:focus, .form-select:focus, .form-textarea:focus { outline: none; border-color: #8b5cf6; background: white; box-shadow: 0 0 0 4px rgba(139,92,246,0.1); }
.form-textarea { resize: vertical; min-height: 80px; }
.schedule-box { background: #fafafa; border: 1px solid #e2e8f0; border-radius: 12px; padding: 20px; margin-bottom: 20px; }
.time-row { display: flex; gap: 12px; }

/* Task type toggle */
.type-toggle { display: flex; gap: 10px; margin-bottom: 16px; }
.type-radio { display: none; }
.type-label {
    flex: 1; padding: 12px; border-radius: 10px; border: 2px solid #e2e8f0;
    cursor: pointer; text-align: center; font-weight: 700; font-size: 13px;
    transition: all 0.2s; background: white; color: #64748b;
}
.type-label:hover { border-color: #a5b4fc; background: #f5f3ff; }
.type-radio:checked + .type-label { border-color: #6366f1; background: #eef2ff; color: #3730a3; }

/* BUTTONS */
.btn-primary { width: 100%; padding: 14px; background: #8b5cf6; color: white; border: none; border-radius: 10px; font-size: 15px; font-weight: 700; cursor: pointer; transition: 0.2s; }
.btn-primary:hover { background: #7c3aed; box-shadow: 0 4px 12px rgba(124,58,237,0.3); transform: translateY(-1px); }
.filter-bar { background: white; border: 1px solid #e2e8f0; border-radius: 12px; padding: 20px; margin-bottom: 25px; display: flex; gap: 15px; flex-wrap: wrap; align-items: flex-end; }
.filter-col { flex: 1; min-width: 140px; }
.filter-actions { display: flex; gap: 10px; }
.btn-filter { padding: 12px 20px; background: #4f46e5; color: white; border: none; border-radius: 10px; font-size: 14px; font-weight: 700; cursor: pointer; }
.btn-filter:hover { background: #4338ca; }
.btn-clear { padding: 12px 20px; background: white; color: #64748b; border: 1px solid #cbd5e1; border-radius: 10px; font-size: 14px; font-weight: 700; text-decoration: none; display: inline-flex; align-items: center; justify-content: center; }
.btn-clear:hover { background: #f1f5f9; }

/* TASK CARDS */
.task-count { font-size: 13px; color: #64748b; font-weight: 700; background: #f1f5f9; padding: 4px 10px; border-radius: 20px; }
.task-card { border: 1px solid #e2e8f0; border-radius: 12px; padding: 20px; margin-bottom: 15px; background: white; transition: 0.2s; }
.task-card:hover { box-shadow: 0 10px 20px -5px rgba(0,0,0,0.08); transform: translateY(-2px); }
.task-card.priority-high { border-left: 4px solid #ef4444; }
.task-card.priority-medium { border-left: 4px solid #f59e0b; }
.task-card.priority-low { border-left: 4px solid #10b981; }
.task-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 12px; }
.task-volunteer { font-size: 16px; font-weight: 800; color: #0f172a; margin-bottom: 4px; }
.task-badges { display: flex; gap: 6px; flex-wrap: wrap; }
.badge { font-size: 11px; font-weight: 800; padding: 4px 10px; border-radius: 6px; }
.badge-priority-high { background: #fef2f2; color: #991b1b; }
.badge-priority-medium { background: #fffbeb; color: #92400e; }
.badge-priority-low { background: #f0fdf4; color: #166534; }
.badge-status-confirmed { background: #dcfce7; color: #166534; border: 1px solid #bbf7d0; }
.badge-status-completed { background: #fef9c3; color: #854d0e; border: 1px solid #fde047; }
.badge-status-progress { background: #e0e7ff; color: #3730a3; border: 1px solid #c7d2fe; }
.badge-status-pending { background: #f1f5f9; color: #475569; border: 1px solid #e2e8f0; }
.badge-type-flexible { background: #f0fdf4; color: #065f46; border: 1px solid #6ee7b7; }
.badge-type-scheduled { background: #eff6ff; color: #1e40af; border: 1px solid #bfdbfe; }
.task-desc { color: #334155; font-size: 14px; line-height: 1.6; margin-bottom: 12px; }
.task-note { background: #f8fafc; border-left: 3px solid #8b5cf6; padding: 10px 14px; border-radius: 6px; font-size: 13px; color: #475569; margin-bottom: 12px; }
.task-meta { font-size: 12px; color: #64748b; margin-bottom: 15px; display: flex; flex-wrap: wrap; gap: 10px; font-weight: 500; }
.task-actions { display: flex; gap: 10px; border-top: 1px dashed #e2e8f0; padding-top: 15px; }
.btn-confirm { padding: 8px 16px; background: #10b981; color: white; border: none; border-radius: 8px; font-size: 13px; font-weight: 700; cursor: pointer; }
.btn-confirm:hover { background: #059669; }
.btn-delete { padding: 8px 16px; background: white; color: #ef4444; border: 1px solid #fecaca; border-radius: 8px; font-size: 13px; font-weight: 700; cursor: pointer; }
.btn-delete:hover { background: #fef2f2; }

/* TABLE */
.table-wrapper { background: white; border-radius: 16px; overflow: hidden; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); border: 1px solid #e2e8f0; }
.data-table { width: 100%; border-collapse: collapse; }
.data-table thead { background: #f8fafc; border-bottom: 2px solid #e2e8f0; }
.data-table th { padding: 15px 20px; text-align: left; font-size: 12px; font-weight: 700; color: #64748b; text-transform: uppercase; letter-spacing: 0.5px; }
.data-table td { padding: 18px 20px; border-bottom: 1px solid #f1f5f9; vertical-align: middle; }
.volunteer-name { font-weight: 700; color: #0f172a; font-size: 15px; margin-bottom: 4px; }
.view-profile-btn { background: none; border: none; padding: 0; font-size: 12px; color: #8b5cf6; font-weight: 700; cursor: pointer; }
.view-profile-btn:hover { color: #6d28d9; }
.status-badge { display: inline-block; padding: 6px 12px; border-radius: 20px; font-size: 12px; font-weight: 700; }
.status-approved { background: #dcfce7; color: #166534; }
.status-pending { background: #fef9c3; color: #854d0e; }
.btn-action { padding: 8px 16px; border: none; border-radius: 8px; font-size: 13px; font-weight: 700; cursor: pointer; transition: 0.2s; }
.btn-action.success { background: #10b981; color: white; }
.btn-action.success:hover { background: #059669; }
.btn-action.danger { background: white; color: #ef4444; border: 1px solid #fecaca; }
.btn-action.danger:hover { background: #fef2f2; }
.you-label { font-size: 12px; color: #94a3b8; font-weight: 600; font-style: italic; }

/* OTHERS */
.alert { padding: 16px 20px; border-radius: 12px; margin-bottom: 25px; font-weight: 600; display: flex; align-items: center; font-size: 14px; }
.alert-error { background: #fef2f2; color: #991b1b; border: 1px solid #fecaca; }
.alert-success { background: #f0fdf4; color: #166534; border: 1px solid #bbf7d0; }
.empty-state { text-align: center; padding: 60px 20px; color: #64748b; }
.empty-icon { font-size: 48px; margin-bottom: 15px; }
.empty-text { font-size: 16px; font-weight: 600; color: #0f172a; }
.manual-card { max-width: 500px; margin: 0 auto; text-align: center; }

/* MODAL */
#profileModal { display: none; position: fixed; inset: 0; background: rgba(15,23,42,0.6); backdrop-filter: blur(4px); z-index: 9999; align-items: center; justify-content: center; }
.modal-content { background: white; border-radius: 20px; width: 90%; max-width: 650px; max-height: 90vh; overflow-y: auto; position: relative; box-shadow: 0 25px 50px -12px rgba(0,0,0,0.3); }
.modal-close { position: absolute; top: 15px; right: 15px; background: #f1f5f9; color: #64748b; border: none; border-radius: 50%; width: 36px; height: 36px; cursor: pointer; font-size: 16px; font-weight: bold; z-index: 10; transition: 0.2s; display: flex; align-items: center; justify-content: center; }
.modal-close:hover { background: #e2e8f0; color: #0f172a; }
</style>

<div class="coord-page">
<div class="coord-container">

<div class="coord-header">
  <h1 class="coord-title"><span>🗂</span> Coordinator Workspace</h1>
  <div class="event-badge">📌 ${event.eventName}</div>
</div>

<c:if test="${not empty param.error}">
  <div class="alert alert-error">❌ &nbsp; ${param.error}</div>
</c:if>
<c:if test="${not empty param.success}">
  <div class="alert alert-success">✅ &nbsp; ${param.success}</div>
</c:if>

<div class="tabs-nav">
  <button class="tab-btn active" onclick="switchTab(event,'tab-tasks')">📋 Tasks &amp; Schedule</button>
  <button class="tab-btn" onclick="switchTab(event,'tab-volunteers')">👥 Team Management</button>
  <button class="tab-btn" onclick="switchTab(event,'tab-manual')">➕ Quick Add</button>
</div>

<%-- ═══════════════════ TAB: TASKS ═══════════════════ --%>
<div id="tab-tasks" class="tab-content active">
<div style="display: grid; grid-template-columns: 420px 1fr; gap: 30px; align-items: start;">

  <%-- ─────────── ASSIGN FORM ─────────── --%>
  <div class="card">
    <h3 class="card-title">📝 Assign New Task</h3>
    <form method="post" action="${pageContext.request.contextPath}/coordinator/assign-task">
      <input type="hidden" name="eventId" value="${event.eventId}">

      <div class="form-group">
        <label class="form-label">Assign To</label>
        <select name="volunteerId" required class="form-select" multiple style="min-height: 120px;">
          <c:forEach items="${approvedVolunteers}" var="v">
            <option value="${v.volunteerId}">${v.fullName}</option>
          </c:forEach>
        </select>
        <small style="color:#64748b; margin-top:6px; display:block;">Hold Ctrl/Cmd to select multiple</small>
      </div>

      <div class="form-group">
        <label class="form-label">Task Type</label>
        <div class="type-toggle">
          <input type="radio" name="taskType" id="type-flex" value="FLEXIBLE" class="type-radio" checked onchange="toggleTaskTypeFields(this.value)">
          <label for="type-flex" class="type-label">⏱ Flexible</label>
          <input type="radio" name="taskType" id="type-sched" value="SCHEDULED" class="type-radio" onchange="toggleTaskTypeFields(this.value)">
          <label for="type-sched" class="type-label">🗓 Scheduled</label>
        </div>
      </div>

      <div class="form-group">
        <label class="form-label">Task Description</label>
        <textarea name="taskDescription" required class="form-textarea" placeholder="Describe the task in detail..."></textarea>
      </div>

      <div class="form-group">
        <label class="form-label">Priority Level</label>
        <select name="priority" required class="form-select">
          <option value="Low">🟢 Low Priority</option>
          <option value="Medium" selected>🟡 Medium Priority</option>
          <option value="High">🔴 High Priority</option>
        </select>
      </div>

      <div class="form-group">
        <label class="form-label">Location <span style="color:#94a3b8; font-weight:400;">(optional)</span></label>
        <input type="text" name="location" class="form-input" placeholder="e.g. Hall A, Room 301...">
      </div>

      <%-- FLEXIBLE only: Deadline --%>
      <div class="schedule-box" id="flex-fields">
        <div style="font-size:13px; font-weight:700; color:#065f46; margin-bottom:12px;">⏱ Flexible Task — Deadline</div>
        <div class="form-group" style="margin-bottom:0;">
          <label class="form-label">Due Date &amp; Time</label>
          <input type="datetime-local" name="dueDate" id="assign-dueDate" class="form-input">
        </div>
      </div>

      <%-- SCHEDULED only: Start + End datetime --%>
      <div class="schedule-box" id="sched-fields" style="display:none;">
        <div style="font-size:13px; font-weight:700; color:#1e40af; margin-bottom:12px;">🗓 Scheduled Task — Time Window</div>
        <div class="form-group" style="margin-bottom:12px;">
          <label class="form-label">Start Date &amp; Time</label>
          <input type="datetime-local" name="startDateTime" id="assign-startDateTime" class="form-input">
        </div>
        <div class="form-group" style="margin-bottom:0;">
          <label class="form-label">End Date &amp; Time</label>
          <input type="datetime-local" name="endDateTime" id="assign-endDateTime" class="form-input">
        </div>
      </div>

      <button type="submit" class="btn-primary">🚀 Assign Task</button>
    </form>
  </div>

  <%-- ─────────── TASK LIST ─────────── --%>
  <div class="card">
    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:25px; border-bottom:1px solid #f1f5f9; padding-bottom:15px;">
      <h3 class="card-title" style="margin:0; border:none; padding:0;">📊 Task Overview</h3>
      <span class="task-count">${fn:length(eventTasks)} Task(s)</span>
    </div>

    <form method="get" action="${pageContext.request.contextPath}/event/detail" class="filter-bar">
      <input type="hidden" name="id" value="${event.eventId}">
      <div class="filter-col">
        <label class="form-label">Status</label>
        <select name="filterStatus" class="form-select">
          <option value="">All</option>
          <option value="Pending"     ${filterStatus == 'Pending'     ? 'selected' : ''}>Pending</option>
          <option value="In Progress" ${filterStatus == 'In Progress' ? 'selected' : ''}>In Progress</option>
          <option value="Completed"   ${filterStatus == 'Completed'   ? 'selected' : ''}>Completed</option>
          <option value="Confirmed"   ${filterStatus == 'Confirmed'   ? 'selected' : ''}>Confirmed</option>
        </select>
      </div>
      <div class="filter-col">
        <label class="form-label">Priority</label>
        <select name="filterPriority" class="form-select">
          <option value="">All</option>
          <option value="High"   ${filterPriority == 'High'   ? 'selected' : ''}>High</option>
          <option value="Medium" ${filterPriority == 'Medium' ? 'selected' : ''}>Medium</option>
          <option value="Low"    ${filterPriority == 'Low'    ? 'selected' : ''}>Low</option>
        </select>
      </div>
      <div class="filter-col">
        <label class="form-label">Volunteer</label>
        <select name="filterVolunteerId" class="form-select">
          <option value="">All</option>
          <c:forEach items="${approvedVolunteers}" var="v">
            <option value="${v.volunteerId}" ${filterVolunteerId == v.volunteerId ? 'selected' : ''}>${v.fullName}</option>
          </c:forEach>
        </select>
      </div>
      <div class="filter-actions">
        <button type="submit" class="btn-filter">Filter</button>
        <a href="${pageContext.request.contextPath}/event/detail?id=${event.eventId}" class="btn-clear">Clear</a>
      </div>
    </form>

    <div style="max-height: 650px; overflow-y: auto; padding-right: 5px;">
      <c:if test="${empty eventTasks}">
        <div class="empty-state">
          <div class="empty-icon">📭</div>
          <div class="empty-text">No tasks assigned yet.</div>
        </div>
      </c:if>

      <c:forEach items="${eventTasks}" var="t">
        <c:set var="priorityClass" value="priority-${fn:toLowerCase(t.priority)}"/>
        <div class="task-card ${priorityClass}">
          <div class="task-header">
            <div>
              <div class="task-volunteer">${t.volunteerName}</div>
            </div>
            <div class="task-badges">
              <%-- Task Type Badge --%>
              <c:choose>
                <c:when test="${t.taskType == 'FLEXIBLE'}"><span class="badge badge-type-flexible">⏱ Flexible</span></c:when>
                <c:otherwise><span class="badge badge-type-scheduled">🗓 Scheduled</span></c:otherwise>
              </c:choose>
              <%-- Priority Badge --%>
              <c:choose>
                <c:when test="${t.priority == 'High'}"><span class="badge badge-priority-high">🔴 High</span></c:when>
                <c:when test="${t.priority == 'Low'}"><span class="badge badge-priority-low">🟢 Low</span></c:when>
                <c:otherwise><span class="badge badge-priority-medium">🟡 Medium</span></c:otherwise>
              </c:choose>
              <%-- Status Badge --%>
              <c:choose>
                <c:when test="${t.status == 'Confirmed'}"><span class="badge badge-status-confirmed">✅ Confirmed</span></c:when>
                <c:when test="${t.status == 'Completed'}"><span class="badge badge-status-completed">⏳ Awaiting</span></c:when>
                <c:when test="${t.status == 'In Progress'}"><span class="badge badge-status-progress">🚀 Active</span></c:when>
                <c:otherwise><span class="badge badge-status-pending">🕒 Pending</span></c:otherwise>
              </c:choose>
            </div>
          </div>

          <div class="task-desc">${t.description}</div>

          <c:if test="${not empty t.note}">
            <div class="task-note">💬 <strong>Note:</strong> ${t.note}</div>
          </c:if>

          <div class="task-meta">
            <c:choose>
              <c:when test="${t.taskType == 'FLEXIBLE'}">
                <span>⏰ Due: <fmt:formatDate value="${t.dueDate}" pattern="dd MMM yyyy, HH:mm"/></span>
              </c:when>
              <c:otherwise>
                <span>🕐 <fmt:formatDate value="${t.startTime}" pattern="dd MMM, HH:mm"/> – <fmt:formatDate value="${t.endTime}" pattern="HH:mm"/></span>
              </c:otherwise>
            </c:choose>
            <c:if test="${not empty t.location}">
              <span>📍 ${t.location}</span>
            </c:if>
            <c:if test="${not empty t.acceptedAt}">
              <span style="color:#6366f1;">🔑 Accepted: <fmt:formatDate value="${t.acceptedAt}" pattern="dd MMM, HH:mm"/></span>
            </c:if>
            <c:if test="${not empty t.completedAt}">
              <span style="color:#10b981;">✅ Finished: <fmt:formatDate value="${t.completedAt}" pattern="dd MMM, HH:mm"/></span>
              <span style="color:#f59e0b;">⏳ ${t.durationText}</span>
            </c:if>
          </div>

          <%-- ACTIONS: only FLEXIBLE Completed needs confirm button; Pending tasks can be deleted --%>
          <c:if test="${(t.status == 'Completed' && t.taskType == 'FLEXIBLE') || t.status == 'Pending'}">
            <div class="task-actions">
              <c:if test="${t.status == 'Completed' && t.taskType == 'FLEXIBLE'}">
                <form method="post" action="${pageContext.request.contextPath}/coordinator/task-action" style="margin:0">
                  <input type="hidden" name="eventId" value="${event.eventId}">
                  <input type="hidden" name="taskId" value="${t.taskId}">
                  <input type="hidden" name="action" value="confirm">
                  <button type="submit" class="btn-confirm">✅ Confirm</button>
                </form>
<%-- Format ngày tháng và lưu vào biến trước --%>
<fmt:formatDate value="${t.dueDate}" pattern="yyyy-MM-dd'T'HH:mm" var="fmtDueDate" />
<fmt:formatDate value="${t.startTime}" pattern="yyyy-MM-dd'T'HH:mm" var="fmtStartTime" />
<fmt:formatDate value="${t.endTime}" pattern="yyyy-MM-dd'T'HH:mm" var="fmtEndTime" />

<%-- Truyền biến vào nút bấm --%>
<button type="button" class="btn-delete"
  data-task-id="${t.taskId}"
  data-volunteer-id="${t.volunteerId}"
  data-description="${fn:escapeXml(t.description)}"
  data-priority="${t.priority}"
  data-task-type="${t.taskType}"
  data-due-date="${fmtDueDate}"
  data-start-time="${fmtStartTime}"
  data-end-time="${fmtEndTime}"
  data-location="${fn:escapeXml(t.location)}"
  onclick="openReassignModal(this)">
  ❌ Reject &amp; Reassign
</button>
              </c:if>
              <c:if test="${t.status == 'Pending'}">
                <form method="post" action="${pageContext.request.contextPath}/coordinator/task-action" style="margin:0"
                      onsubmit="return confirm('Delete this task?')">
                  <input type="hidden" name="eventId" value="${event.eventId}">
                  <input type="hidden" name="taskId" value="${t.taskId}">
                  <input type="hidden" name="action" value="delete">
                  <button type="submit" class="btn-delete">🗑 Delete Task</button>
                </form>
              </c:if>
            </div>
          </c:if>
        </div>
      </c:forEach>
    </div>
  </div>

</div>
</div>

<%-- ═══════════════════ TAB: VOLUNTEERS ═══════════════════ --%>
<div id="tab-volunteers" class="tab-content">
  <div class="table-wrapper">
    <table class="data-table">
      <thead>
        <tr>
          <th>Volunteer</th><th>Contact</th><th>Status</th><th style="text-align:center">Actions</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach items="${allVolunteers}" var="v">
          <tr>
            <td>
              <div class="volunteer-name">${v.fullName}</div>
              <button type="button" onclick="openProfileModal(${v.volunteerId})" class="view-profile-btn">🔍 View Profile</button>
            </td>
            <td style="color:#475569; font-size:14px;">${v.email}</td>
            <td>
              <c:choose>
                <c:when test="${v.status == 'Approved'}"><span class="status-badge status-approved">✓ Approved</span></c:when>
                <c:when test="${v.status == 'Pending'}"><span class="status-badge status-pending">⏳ Pending</span></c:when>
                <c:otherwise><span class="status-badge status-pending" style="background:#f1f5f9;color:#475569;">${v.status}</span></c:otherwise>
              </c:choose>
            </td>
            <td style="text-align:center">
              <div style="display:flex; justify-content:center; gap:8px;">
                <c:if test="${v.status == 'Pending'}">
                  <form method="post" action="${pageContext.request.contextPath}/coordinator/manage-action" style="margin:0">
                    <input type="hidden" name="action" value="approve">
                    <input type="hidden" name="eventId" value="${event.eventId}">
                    <input type="hidden" name="registrationId" value="${v.registrationId}">
                    <input type="hidden" name="tab" value="volunteers">
                    <button type="submit" class="btn-action success">✓ Approve</button>
                  </form>
                </c:if>
                <c:if test="${v.status == 'Approved' && v.volunteerId != sessionScope.userId}">
                  <form method="post" action="${pageContext.request.contextPath}/coordinator/manage-action" style="margin:0"
                        onsubmit="return confirm('Remove this volunteer?')">
                    <input type="hidden" name="action" value="kick">
                    <input type="hidden" name="eventId" value="${event.eventId}">
                    <input type="hidden" name="registrationId" value="${v.registrationId}">
                    <input type="hidden" name="tab" value="volunteers">
                    <input type="hidden" name="kickReason" value="Removed by Coordinator">
                    <button type="submit" class="btn-action danger">✕ Remove</button>
                  </form>
                </c:if>
                <c:if test="${v.volunteerId == sessionScope.userId}">
                  <span class="you-label">(You)</span>
                </c:if>
              </div>
            </td>
          </tr>
        </c:forEach>
        <c:if test="${empty allVolunteers}">
          <tr><td colspan="4" style="text-align:center; padding:40px; color:#64748b;">No volunteers found.</td></tr>
        </c:if>
      </tbody>
    </table>
  </div>
</div>

<%-- ═══════════════════ TAB: QUICK ADD ═══════════════════ --%>
<div id="tab-manual" class="tab-content">
  <div class="card manual-card">
    <div style="font-size:60px; text-align:center; margin-bottom:15px;">🏃‍♂️</div>
    <h3 class="card-title" style="justify-content:center;">Walk-in Registration</h3>
    <p style="color:#64748b; text-align:center;">Quickly add an existing volunteer to this event</p>
    <form method="post" action="${pageContext.request.contextPath}/coordinator/manage-action">
      <input type="hidden" name="action" value="manual_add">
      <input type="hidden" name="eventId" value="${event.eventId}">
      <input type="hidden" name="tab" value="manual">
      <div class="form-group">
        <input type="email" name="email" required class="form-input" placeholder="volunteer@example.com" style="text-align:center;">
      </div>
      <button type="submit" class="btn-primary" style="width:auto; padding:14px 30px; display:block; margin:0 auto;">➕ Add to Event</button>
    </form>
  </div>
</div>

</div>
</div>

<%-- ═══════════════════ PROFILE MODAL ═══════════════════ --%>
<div id="profileModal">
  <div class="modal-content">
    <button onclick="closeProfileModal()" class="modal-close">✕</button>
    <div id="profileModalBody">
      <div style="text-align:center; padding:80px 20px; color:#94a3b8;">
        <div style="font-size:40px; margin-bottom:15px;">⏳</div>
        <div style="font-weight:600;">Loading profile...</div>
      </div>
    </div>
  </div>
</div>

<%-- ═══════════════════ REASSIGN MODAL ═══════════════════ --%>
<div id="reassignModal" style="display:none; position:fixed; inset:0; background:rgba(15,23,42,0.6); backdrop-filter:blur(4px); z-index:9999; align-items:center; justify-content:center;">
  <div style="background:white; border-radius:20px; width:90%; max-width:520px; padding:30px; position:relative; box-shadow:0 25px 50px -12px rgba(0,0,0,0.3); max-height:90vh; overflow-y:auto;">
    <button type="button" onclick="closeReassignModal()" class="modal-close">✕</button>
    <h3 style="margin-top:0; font-size:18px; font-weight:800; color:#0f172a; margin-bottom:20px;">❌ Reject &amp; Reassign Task</h3>
    <form method="post" action="${pageContext.request.contextPath}/coordinator/task-action">
      <input type="hidden" name="eventId" value="${event.eventId}">
      <input type="hidden" name="taskId" id="rTaskId">
      <input type="hidden" name="action" value="reject_reassign">

      <div class="form-group">
        <label class="form-label">Assign To</label>
        <select name="volunteerId" id="rVolunteerId" required class="form-select">
          <c:forEach items="${approvedVolunteers}" var="v">
            <option value="${v.volunteerId}">${v.fullName}</option>
          </c:forEach>
        </select>
      </div>

      <div class="form-group">
        <label class="form-label">Task Description</label>
        <textarea name="taskDescription" id="rDescription" required class="form-textarea"></textarea>
      </div>

      <div class="form-group">
        <label class="form-label">Priority</label>
        <select name="priority" id="rPriority" required class="form-select">
          <option value="Low">🟢 Low</option>
          <option value="Medium">🟡 Medium</option>
          <option value="High">🔴 High</option>
        </select>
      </div>

      <div class="form-group">
        <label class="form-label">Task Type</label>
        <input type="text" name="taskType" id="rTaskType" class="form-input" readonly style="background:#f1f5f9;">
      </div>

      <div class="form-group">
        <label class="form-label">Location <span style="color:#94a3b8; font-weight:400;">(optional)</span></label>
        <input type="text" name="location" id="rLocation" class="form-input" placeholder="e.g. Hall A...">
      </div>

      <%-- Shown conditionally via JS --%>
      <div id="r-flex-fields">
        <div class="form-group">
          <label class="form-label">Due Date &amp; Time</label>
          <input type="datetime-local" name="dueDate" id="rDueDate" class="form-input">
        </div>
      </div>
      <div id="r-sched-fields" style="display:none;">
        <div class="form-group">
          <label class="form-label">Start Date &amp; Time</label>
          <input type="datetime-local" name="startDateTime" id="rStartDateTime" class="form-input">
        </div>
        <div class="form-group">
          <label class="form-label">End Date &amp; Time</label>
          <input type="datetime-local" name="endDateTime" id="rEndDateTime" class="form-input">
        </div>
      </div>

      <button type="submit" class="btn-primary" style="background:#ef4444;">Submit Reassignment</button>
    </form>
  </div>
</div>

<script>
function switchTab(evt, tabId) {
  document.querySelectorAll('.tab-content').forEach(el => el.classList.remove('active'));
  document.querySelectorAll('.tab-btn').forEach(el => el.classList.remove('active'));
  document.getElementById(tabId).classList.add('active');
  evt.currentTarget.classList.add('active');
}

function toggleTaskTypeFields(type) {
  if (type === 'FLEXIBLE') {
    document.getElementById('flex-fields').style.display = 'block';
    document.getElementById('sched-fields').style.display = 'none';
    document.getElementById('assign-dueDate').required = true;
    document.getElementById('assign-startDateTime').required = false;
    document.getElementById('assign-endDateTime').required = false;
  } else {
    document.getElementById('flex-fields').style.display = 'none';
    document.getElementById('sched-fields').style.display = 'block';
    document.getElementById('assign-dueDate').required = false;
    document.getElementById('assign-startDateTime').required = true;
    document.getElementById('assign-endDateTime').required = true;
  }
}

function openProfileModal(volunteerId) {
  document.getElementById('profileModal').style.display = 'flex';
  fetch('${pageContext.request.contextPath}/volunteer/profile?id=' + volunteerId)
    .then(res => res.text())
    .then(html => document.getElementById('profileModalBody').innerHTML = html)
    .catch(() => document.getElementById('profileModalBody').innerHTML = '<div style="padding:40px;text-align:center;color:#ef4444">Error loading profile</div>');
}
function closeProfileModal() { document.getElementById('profileModal').style.display = 'none'; }

/**
 * @param datetimeVal - ISO string coming from Java Timestamp (may contain space instead of T)
 * Converts to "YYYY-MM-DDTHH:mm" for datetime-local input
 */
function toDatetimeLocal(val) {
  if (!val) return '';
  // Replace space with T if needed, trim seconds
  return val.toString().substring(0, 16).replace(' ', 'T');
}


function openReassignModal(btn) {
  // Lấy dữ liệu an toàn từ data-attributes
  document.getElementById('rTaskId').value = btn.getAttribute('data-task-id');
  document.getElementById('rVolunteerId').value = btn.getAttribute('data-volunteer-id');
  document.getElementById('rDescription').value = btn.getAttribute('data-description');
  document.getElementById('rPriority').value = btn.getAttribute('data-priority');

  const taskType = btn.getAttribute('data-task-type');
  document.getElementById('rTaskType').value = taskType;
  document.getElementById('rLocation').value = btn.getAttribute('data-location') || '';

  if (taskType === 'FLEXIBLE') {
    document.getElementById('r-flex-fields').style.display = 'block';
    document.getElementById('r-sched-fields').style.display = 'none';
    document.getElementById('rDueDate').value = btn.getAttribute('data-due-date');
  } else {
    document.getElementById('r-flex-fields').style.display = 'none';
    document.getElementById('r-sched-fields').style.display = 'block';
    document.getElementById('rStartDateTime').value = btn.getAttribute('data-start-time');
    document.getElementById('rEndDateTime').value = btn.getAttribute('data-end-time');
  }

  document.getElementById('reassignModal').style.display = 'flex';
}
function closeReassignModal() { document.getElementById('reassignModal').style.display = 'none'; }

window.onload = function() {
  // Re-activate tab from URL param
  const tab = new URLSearchParams(window.location.search).get('tab');
  if (tab) {
    const btn = document.querySelector('.tab-btn[onclick*="tab-' + tab + '"]');
    if (btn) btn.click();
  }
  // Init task type fields
  toggleTaskTypeFields('FLEXIBLE');
};
</script>

<jsp:include page="/components/footer.jsp"/>