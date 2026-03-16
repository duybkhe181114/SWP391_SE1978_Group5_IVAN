<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<jsp:include page="/components/header.jsp"/>

<style>
/* NỀN VÀ BỐ CỤC TỔNG THỂ */
.coord-page { background-color: #f8fafc; min-height: 100vh; padding: 40px 0; font-family: 'Inter', sans-serif; }
.coord-container { max-width: 1400px; margin: 0 auto; padding: 0 30px; }

/* HEADER SANG TRỌNG CÓ VIỀN TRÊN */
.coord-header { background: white; border-radius: 16px; padding: 25px 35px; margin-bottom: 30px; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05); border: 1px solid #e2e8f0; display: flex; justify-content: space-between; align-items: center; position: relative; overflow: hidden; }
.coord-header::before { content: ''; position: absolute; top: 0; left: 0; width: 100%; height: 4px; background: linear-gradient(135deg, #667eea, #764ba2); }
.coord-title { font-size: 24px; font-weight: 800; color: #0f172a; margin: 0; display: flex; align-items: center; gap: 10px; }
.coord-title .icon { font-size: 28px; }
.event-badge { background: #f5f3ff; color: #6d28d9; padding: 8px 16px; border-radius: 10px; font-weight: 700; font-size: 14px; border: 1px solid #ddd6fe; display: flex; align-items: center; gap: 8px; }

/* TABS KIỂU IOS (SEGMENTED CONTROLS) */
.tabs-nav { display: inline-flex; background: #e2e8f0; border-radius: 12px; padding: 6px; margin-bottom: 30px; gap: 4px; }
.tab-btn { padding: 10px 24px; background: transparent; border: none; border-radius: 8px; font-size: 14px; font-weight: 600; color: #475569; cursor: pointer; transition: all 0.2s ease; display: flex; align-items: center; gap: 8px; }
.tab-btn:hover { color: #0f172a; }
.tab-btn.active { background: white; color: #4f46e5; box-shadow: 0 1px 3px rgba(0,0,0,0.1); }
.tab-content { display: none; }
.tab-content.active { display: block; animation: fadeIn 0.4s ease forwards; }
@keyframes fadeIn { from { opacity: 0; transform: translateY(8px); } to { opacity: 1; transform: translateY(0); } }

/* CARD CHUNG */
.card { background: white; border-radius: 16px; padding: 30px; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05); border: 1px solid #e2e8f0; }
.card-title { font-size: 18px; font-weight: 800; color: #0f172a; margin: 0 0 25px 0; display: flex; align-items: center; gap: 10px; border-bottom: 1px solid #f1f5f9; padding-bottom: 15px; }

/* FORM ELEMENTS */
.form-group { margin-bottom: 20px; }
.form-label { display: block; font-size: 13px; font-weight: 700; color: #475569; margin-bottom: 8px; }
.form-input, .form-select, .form-textarea { width: 100%; padding: 12px 16px; border: 1px solid #cbd5e1; border-radius: 10px; font-size: 14px; transition: 0.2s; font-family: inherit; background: #f8fafc; color: #1e293b; box-sizing: border-box; }
.form-input:focus, .form-select:focus, .form-textarea:focus { outline: none; border-color: #8b5cf6; background: white; box-shadow: 0 0 0 4px rgba(139,92,246,0.1); }
.form-textarea { resize: vertical; min-height: 80px; }
.schedule-box { background: white; border: 1px solid #e2e8f0; border-radius: 12px; padding: 20px; margin-bottom: 20px; box-shadow: inset 0 2px 4px rgba(0,0,0,0.02); }
.time-row { display: flex; gap: 12px; }

/* BUTTONS */
.btn-primary { width: 100%; padding: 14px; background: #8b5cf6; color: white; border: none; border-radius: 10px; font-size: 15px; font-weight: 700; cursor: pointer; transition: 0.2s; }
.btn-primary:hover { background: #7c3aed; box-shadow: 0 4px 12px rgba(124, 58, 237, 0.3); transform: translateY(-1px); }
.filter-bar { background: white; border: 1px solid #e2e8f0; border-radius: 12px; padding: 20px; margin-bottom: 25px; display: flex; gap: 15px; flex-wrap: wrap; align-items: flex-end; box-shadow: 0 2px 4px rgba(0,0,0,0.02); }
.filter-col { flex: 1; min-width: 140px; }
.filter-actions { display: flex; gap: 10px; }
.btn-filter { padding: 12px 20px; background: #4f46e5; color: white; border: none; border-radius: 10px; font-size: 14px; font-weight: 700; cursor: pointer; transition: 0.2s; }
.btn-filter:hover { background: #4338ca; }
.btn-clear { padding: 12px 20px; background: white; color: #64748b; border: 1px solid #cbd5e1; border-radius: 10px; font-size: 14px; font-weight: 700; text-decoration: none; transition: 0.2s; display: inline-flex; align-items: center; justify-content: center; }
.btn-clear:hover { background: #f1f5f9; color: #0f172a; }

/* TASK CARDS */
.task-count { font-size: 13px; color: #64748b; font-weight: 700; background: #f1f5f9; padding: 4px 10px; border-radius: 20px; }
.task-card { border: 1px solid #e2e8f0; border-radius: 12px; padding: 20px; margin-bottom: 15px; background: white; transition: 0.2s; position: relative; }
.task-card:hover { box-shadow: 0 10px 20px -5px rgba(0,0,0,0.08); transform: translateY(-2px); border-color: #cbd5e1; }
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
.task-desc { color: #334155; font-size: 14px; line-height: 1.6; margin-bottom: 12px; }
.task-note { background: #f8fafc; border-left: 3px solid #8b5cf6; padding: 10px 14px; border-radius: 6px; font-size: 13px; color: #475569; margin-bottom: 12px; }
.task-meta { font-size: 12px; color: #64748b; margin-bottom: 15px; display: flex; gap: 15px; font-weight: 500; }
.task-actions { display: flex; gap: 10px; border-top: 1px dashed #e2e8f0; padding-top: 15px; }
.btn-confirm { padding: 8px 16px; background: #10b981; color: white; border: none; border-radius: 8px; font-size: 13px; font-weight: 700; cursor: pointer; transition: 0.2s; }
.btn-confirm:hover { background: #059669; }
.btn-delete { padding: 8px 16px; background: white; color: #ef4444; border: 1px solid #fecaca; border-radius: 8px; font-size: 13px; font-weight: 700; cursor: pointer; transition: 0.2s; }
.btn-delete:hover { background: #fef2f2; }

/* TABLE */
.table-wrapper { background: white; border-radius: 16px; overflow: hidden; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05); border: 1px solid #e2e8f0; }
.data-table { width: 100%; border-collapse: collapse; }
.data-table thead { background: #f8fafc; border-bottom: 2px solid #e2e8f0; }
.data-table th { padding: 15px 20px; text-align: left; font-size: 12px; font-weight: 700; color: #64748b; text-transform: uppercase; letter-spacing: 0.5px; }
.data-table td { padding: 18px 20px; border-bottom: 1px solid #f1f5f9; vertical-align: middle; }
.volunteer-name { font-weight: 700; color: #0f172a; font-size: 15px; margin-bottom: 4px; }
.view-profile-btn { background: none; border: none; padding: 0; font-size: 12px; color: #8b5cf6; font-weight: 700; cursor: pointer; transition: 0.2s; display: inline-flex; align-items: center; gap: 4px; }
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
.empty-icon { font-size: 48px; margin-bottom: 15px; opacity: 0.8; }
.empty-text { font-size: 16px; font-weight: 600; color: #0f172a; }
.manual-card { max-width: 500px; margin: 0 auto; text-align: center; }
.manual-icon { font-size: 60px; margin-bottom: 15px; }

/* MODAL */
#profileModal { display: none; position: fixed; inset: 0; background: rgba(15, 23, 42, 0.6); backdrop-filter: blur(4px); z-index: 9999; align-items: center; justify-content: center; }
.modal-content { background: white; border-radius: 20px; width: 90%; max-width: 650px; max-height: 90vh; overflow-y: auto; position: relative; box-shadow: 0 25px 50px -12px rgba(0,0,0,0.3); }
.modal-close { position: absolute; top: 15px; right: 15px; background: #f1f5f9; color: #64748b; border: none; border-radius: 50%; width: 36px; height: 36px; cursor: pointer; font-size: 16px; font-weight: bold; z-index: 10; transition: 0.2s; display: flex; align-items: center; justify-content: center; }
.modal-close:hover { background: #e2e8f0; color: #0f172a; }
</style>

<div class="coord-page">
<div class="coord-container">

<div class="coord-header">
<h1 class="coord-title"><span class="icon"></span> Coordinator Workspace</h1>
<div class="event-badge">📌 ${event.eventName}</div>
</div>

<c:if test="${not empty param.error}">
<div class="alert alert-error">❌ &nbsp; ${param.error}</div>
</c:if>

<c:if test="${not empty param.success}">
<div class="alert alert-success">✅ &nbsp; ${param.success}</div>
</c:if>

<div class="tabs-nav">
<button class="tab-btn active" onclick="switchTab(event,'tab-tasks')">📋 Tasks & Schedule</button>
<button class="tab-btn" onclick="switchTab(event,'tab-volunteers')">👥 Team Management</button>
<button class="tab-btn" onclick="switchTab(event,'tab-manual')">➕ Quick Add</button>
</div>

<div id="tab-tasks" class="tab-content active">
<div style="display: grid; grid-template-columns: 380px 1fr; gap: 30px; align-items: start;">

<div class="card">
<h3 class="card-title">📝 Assign New Task</h3>
<form method="post" action="${pageContext.request.contextPath}/coordinator/assign-task">
<input type="hidden" name="eventId" value="${event.eventId}">

<div class="form-group">
<label class="form-label">Assign To</label>
<select name="volunteerId" required class="form-select">
<option value="">-- Select Volunteer --</option>
<c:forEach items="${approvedVolunteers}" var="v">
<option value="${v.volunteerId}">${v.fullName}</option>
</c:forEach>
</select>
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

<div class="schedule-box">
<div class="schedule-title">🗓 Schedule Details</div>
<div class="form-group" style="margin-bottom: 12px;">
<input type="date" name="workDate" required class="form-input">
</div>
<div class="time-row">
<input type="time" name="startTime" required class="form-input" placeholder="Start">
<input type="time" name="endTime" required class="form-input" placeholder="End">
</div>
</div>

<button type="submit" class="btn-primary">🚀 Assign Task</button>
</form>
</div>

<div class="card">
<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; border-bottom: 1px solid #f1f5f9; padding-bottom: 15px;">
<h3 class="card-title" style="margin: 0; border: none; padding: 0;">📊 Task Overview</h3>
<span class="task-count">${fn:length(eventTasks)} Task(s)</span>
</div>

<form method="get" action="${pageContext.request.contextPath}/event/detail" class="filter-bar">
<input type="hidden" name="id" value="${event.eventId}">

<div class="filter-col">
<label class="form-label">Status</label>
<select name="filterStatus" class="form-select">
<option value="">All</option>
<option value="Pending" ${filterStatus == 'Pending' ? 'selected' : ''}>Pending</option>
<option value="In Progress" ${filterStatus == 'In Progress' ? 'selected' : ''}>In Progress</option>
<option value="Completed" ${filterStatus == 'Completed' ? 'selected' : ''}>Completed</option>
<option value="Confirmed" ${filterStatus == 'Confirmed' ? 'selected' : ''}>Confirmed</option>
</select>
</div>

<div class="filter-col">
<label class="form-label">Priority</label>
<select name="filterPriority" class="form-select">
<option value="">All</option>
<option value="High" ${filterPriority == 'High' ? 'selected' : ''}>High</option>
<option value="Medium" ${filterPriority == 'Medium' ? 'selected' : ''}>Medium</option>
<option value="Low" ${filterPriority == 'Low' ? 'selected' : ''}>Low</option>
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

<div style="max-height: 600px; overflow-y: auto; padding-right: 5px;">
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
<c:choose>
<c:when test="${t.priority == 'High'}"><span class="badge badge-priority-high">🔴 High</span></c:when>
<c:when test="${t.priority == 'Low'}"><span class="badge badge-priority-low">🟢 Low</span></c:when>
<c:otherwise><span class="badge badge-priority-medium">🟡 Medium</span></c:otherwise>
</c:choose>
<c:choose>
<c:when test="${t.status == 'Confirmed'}"><span class="badge badge-status-confirmed">✅ Confirmed</span></c:when>
<c:when test="${t.status == 'Completed'}"><span class="badge badge-status-completed">⏳ Awaiting</span></c:when>
<c:when test="${t.status == 'In Progress'}"><span class="badge badge-status-progress">🚀 In Progress</span></c:when>
<c:otherwise><span class="badge badge-status-pending">🕒 Pending</span></c:otherwise>
</c:choose>
</div>
</div>

<div class="task-desc">${t.description}</div>

<c:if test="${not empty t.note}">
<div class="task-note">💬 <strong>Note:</strong> ${t.note}</div>
</c:if>

<div class="task-meta">
<span>📅 ${t.workDate}</span>
<span>⏰ ${t.startTime} - ${t.endTime}</span>
</div>

<c:if test="${t.status == 'Completed' || t.status == 'Pending'}">
<div class="task-actions">
<c:if test="${t.status == 'Completed'}">
<form method="post" action="${pageContext.request.contextPath}/coordinator/task-action" style="margin:0">
<input type="hidden" name="eventId" value="${event.eventId}">
<input type="hidden" name="taskId" value="${t.taskId}">
<input type="hidden" name="action" value="confirm">
<button type="submit" class="btn-confirm">✅ Confirm Task</button>
</form>
</c:if>
<c:if test="${t.status == 'Pending'}">
<form method="post" action="${pageContext.request.contextPath}/coordinator/task-action" style="margin:0" onsubmit="return confirm('Delete this task?')">
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

<div id="tab-volunteers" class="tab-content">
<div class="table-wrapper">
<table class="data-table">
<thead>
<tr>
<th>Volunteer</th>
<th>Contact</th>
<th>Status</th>
<th style="text-align:center">Actions</th>
</tr>
</thead>
<tbody>
<c:forEach items="${allVolunteers}" var="v">
<tr>
<td>
<div class="volunteer-name">${v.fullName}</div>
<button type="button" onclick="openProfileModal(${v.volunteerId})" class="view-profile-btn">🔍 View Profile</button>
</td>
<td style="color:#475569; font-size: 14px;">${v.email}</td>
<td>
<c:choose>
<c:when test="${v.status == 'Approved'}"><span class="status-badge status-approved">✓ Approved</span></c:when>
<c:when test="${v.status == 'Pending'}"><span class="status-badge status-pending">⏳ Pending</span></c:when>
<c:otherwise><span class="status-badge status-pending" style="background:#f1f5f9; color:#475569;">${v.status}</span></c:otherwise>
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
<form method="post" action="${pageContext.request.contextPath}/coordinator/manage-action" style="margin:0" onsubmit="return confirm('Remove this volunteer?')">
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

<div id="tab-manual" class="tab-content">
<div class="card manual-card">
<div class="manual-icon">🏃‍♂️</div>
<h3 class="manual-title">Walk-in Registration</h3>
<p class="manual-desc">Quickly add an existing volunteer to this event</p>
<form method="post" action="${pageContext.request.contextPath}/coordinator/manage-action">
<input type="hidden" name="action" value="manual_add">
<input type="hidden" name="eventId" value="${event.eventId}">
<input type="hidden" name="tab" value="manual">
<div class="form-group">
<input type="email" name="email" required class="form-input" placeholder="volunteer@example.com" style="text-align: center;">
</div>
<button type="submit" class="btn-primary" style="padding: 14px 30px; width: auto;">➕ Add to Event</button>
</form>
</div>
</div>

</div>
</div>

<div id="profileModal">
<div class="modal-content">
<button onclick="closeProfileModal()" class="modal-close">✕</button>
<div id="profileModalBody">
<div style="text-align:center;padding:80px 20px;color:#94a3b8">
<div style="font-size:40px;margin-bottom:15px">⏳</div>
<div style="font-weight:600">Loading profile...</div>
</div>
</div>
</div>
</div>

<script>
function switchTab(evt,tabId){
document.querySelectorAll('.tab-content').forEach(el=>el.classList.remove('active'))
document.querySelectorAll('.tab-btn').forEach(el=>el.classList.remove('active'))
document.getElementById(tabId).classList.add('active')
evt.currentTarget.classList.add('active')
}

function openProfileModal(volunteerId){
document.getElementById('profileModal').style.display='flex'
fetch('${pageContext.request.contextPath}/volunteer/profile?id='+volunteerId)
.then(res=>res.text())
.then(html=>document.getElementById('profileModalBody').innerHTML=html)
.catch(()=>document.getElementById('profileModalBody').innerHTML='<div style="padding:40px;text-align:center;color:#ef4444">Error loading profile</div>')
}

function closeProfileModal(){
document.getElementById('profileModal').style.display='none'
}

window.onload=function(){
const params=new URLSearchParams(window.location.search)
const tab=params.get('tab')
if(tab){
const btn=document.querySelector('.tab-btn[onclick*="tab-'+tab+'"]')
if(btn)btn.click()
}
}
</script>

<jsp:include page="/components/footer.jsp"/>