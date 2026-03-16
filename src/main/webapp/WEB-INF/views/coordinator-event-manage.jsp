<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="/components/header.jsp"/>

<div id="profileModal" style="display:none;position:fixed;inset:0;background:rgba(15,23,42,0.6);backdrop-filter:blur(4px);z-index:9999;align-items:center;justify-content:center;">
    <div style="background:white;border-radius:16px;width:90%;max-width:600px;max-height:90vh;overflow-y:auto;position:relative;box-shadow:0 20px 40px rgba(0,0,0,0.2);">
        <button onclick="closeProfileModal()" style="position:absolute;top:15px;right:15px;background:rgba(0,0,0,0.2);color:white;border:none;border-radius:50%;width:32px;height:32px;cursor:pointer;font-size:16px;font-weight:bold;z-index:10;display:flex;align-items:center;justify-content:center;">✕</button>
        <div id="profileModalBody">
            <div style="text-align:center;padding:60px;color:#64748b;">
                <div style="font-size:30px;margin-bottom:10px;">⏳</div>
                Loading volunteer profile...
            </div>
        </div>
    </div>
</div>

<style>
.tabs-header{display:flex;gap:10px;border-bottom:2px solid #e2e8f0;margin-bottom:25px}
.tab-btn{padding:12px 24px;background:none;border:none;font-size:15px;font-weight:600;color:#64748b;cursor:pointer;border-bottom:3px solid transparent;margin-bottom:-2px;transition:.2s}
.tab-btn:hover{color:#4f46e5}
.tab-btn.active{color:#4f46e5;border-bottom-color:#4f46e5}
.tab-content{display:none;animation:fadeIn .3s}
.tab-content.active{display:block}
@keyframes fadeIn{from{opacity:0;transform:translateY(5px)}to{opacity:1;transform:translateY(0)}}
</style>

<div class="admin-page" style="background:#f8fafc;min-height:100vh;padding-bottom:60px;">
<div class="admin-container">

<div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:20px;">
<h2 class="section-title" style="margin-bottom:0;border:none;">
<span style="color:#8b5cf6;">●</span> Coordinator Workspace
</h2>
<span style="background:#e0e7ff;color:#4f46e5;padding:8px 16px;border-radius:8px;font-weight:700;border:1px solid #c7d2fe;">
👑 ${event.eventName}
</span>
</div>

<c:if test="${not empty param.error}">
<div style="background:#fef2f2;color:#991b1b;padding:15px;border-radius:8px;margin-bottom:20px;">
❌ ${param.error}
</div>
</c:if>

<c:if test="${not empty param.success}">
<div style="background:#f0fdf4;color:#166534;padding:15px;border-radius:8px;margin-bottom:20px;">
✅ ${param.success}
</div>
</c:if>

<div class="tabs-header">
<button class="tab-btn active" onclick="switchTab(event,'tab-tasks')">📋 Tasks & Schedule</button>
<button class="tab-btn" onclick="switchTab(event,'tab-volunteers')">👥 Manage Volunteers</button>
<button class="tab-btn" onclick="switchTab(event,'tab-manual')">➕ Manual Registration</button>
</div>

<div id="tab-tasks" class="tab-content active">

<div style="display:grid;grid-template-columns:370px 1fr;gap:30px;align-items:start;">

<div style="background:white;padding:25px;border-radius:16px;box-shadow:0 4px 20px rgba(0,0,0,0.03);">

<h3 style="margin:0 0 20px 0;font-size:18px;">📝 Assign New Task</h3>

<form method="post" action="${pageContext.request.contextPath}/coordinator/assign-task">

<input type="hidden" name="eventId" value="${event.eventId}">

<div style="margin-bottom:15px;">
<label style="display:block;font-size:13px;font-weight:600;margin-bottom:8px;">Assign To *</label>
<select name="volunteerId" required style="width:100%;padding:10px;border:1px solid #cbd5e1;border-radius:8px;">
<option value="">-- Select Volunteer --</option>
<c:forEach items="${approvedVolunteers}" var="v">
<option value="${v.volunteerId}">${v.fullName} (${v.email})</option>
</c:forEach>
</select>
</div>

<div style="margin-bottom:15px;">
<label style="display:block;font-size:13px;font-weight:600;margin-bottom:8px;">Task Description *</label>
<textarea name="taskDescription" required rows="3" style="width:100%;padding:10px;border:1px solid #cbd5e1;border-radius:8px;"></textarea>
</div>

<div style="margin-bottom:15px;">
<label style="display:block;font-size:13px;font-weight:600;margin-bottom:8px;">Priority *</label>
<select name="priority" required style="width:100%;padding:10px;border:1px solid #cbd5e1;border-radius:8px;">
<option value="Low">🟢 Low</option>
<option value="Medium" selected>🟡 Medium</option>
<option value="High">🔴 High</option>
</select>
</div>

<div style="background:#f8fafc;padding:15px;border-radius:8px;margin-bottom:20px;">
<h4 style="margin:0 0 10px 0;font-size:13px;">🗓 Schedule</h4>
<input type="date" name="workDate" required style="width:100%;padding:8px;border:1px solid #cbd5e1;border-radius:6px;margin-bottom:10px;">
<div style="display:flex;gap:10px;">
<input type="time" name="startTime" required style="width:100%;padding:8px;border:1px solid #cbd5e1;border-radius:6px;">
<input type="time" name="endTime" required style="width:100%;padding:8px;border:1px solid #cbd5e1;border-radius:6px;">
</div>
</div>

<button type="submit" class="btn-primary" style="width:100%;padding:12px;border-radius:8px;">🚀 Assign Task</button>

</form>
</div>

<div style="background:white;padding:25px;border-radius:16px;box-shadow:0 4px 20px rgba(0,0,0,0.03);">

<h3 style="margin:0 0 20px 0;font-size:18px;">📊 Task Progress</h3>

<c:if test="${empty eventTasks}">
<div style="text-align:center;padding:40px;color:#94a3b8;">No tasks assigned yet.</div>
</c:if>

<c:forEach items="${eventTasks}" var="t">

<c:set var="borderColor" value="#e2e8f0"/>
<c:if test="${t.priority == 'High'}"><c:set var="borderColor" value="#ef4444"/></c:if>
<c:if test="${t.priority == 'Medium'}"><c:set var="borderColor" value="#f59e0b"/></c:if>
<c:if test="${t.priority == 'Low'}"><c:set var="borderColor" value="#10b981"/></c:if>

<div style="padding:15px;border:1px solid #e2e8f0;border-left:4px solid ${borderColor};border-radius:12px;background:#f8fafc;margin-bottom:15px;">

<div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:8px;">
<span style="font-weight:700;">${t.volunteerName}</span>
<div style="display:flex;gap:6px;align-items:center;">

<c:choose>
<c:when test="${t.priority == 'High'}"><span style="font-size:11px;font-weight:700;padding:3px 8px;border-radius:20px;background:#fee2e2;color:#991b1b;">🔴 High</span></c:when>
<c:when test="${t.priority == 'Low'}"><span style="font-size:11px;font-weight:700;padding:3px 8px;border-radius:20px;background:#dcfce7;color:#166534;">🟢 Low</span></c:when>
<c:otherwise><span style="font-size:11px;font-weight:700;padding:3px 8px;border-radius:20px;background:#fef9c3;color:#854d0e;">🟡 Medium</span></c:otherwise>
</c:choose>

<c:choose>
<c:when test="${t.status == 'Confirmed'}"><span style="font-size:12px;font-weight:700;padding:4px 10px;border-radius:20px;background:#dcfce7;color:#166534;">✅ Confirmed</span></c:when>
<c:when test="${t.status == 'Completed'}"><span style="font-size:12px;font-weight:700;padding:4px 10px;border-radius:20px;background:#fef9c3;color:#854d0e;">⏳ Awaiting Confirmation</span></c:when>
<c:when test="${t.status == 'In Progress'}"><span style="font-size:12px;font-weight:700;padding:4px 10px;border-radius:20px;background:#e0e7ff;color:#3730a3;">🚀 In Progress</span></c:when>
<c:otherwise><span style="font-size:12px;font-weight:700;padding:4px 10px;border-radius:20px;background:#f1f5f9;color:#475569;">🕒 Pending</span></c:otherwise>
</c:choose>

</div>
</div>

<p style="color:#475569;font-size:14px;margin:0 0 8px 0;">${t.description}</p>

<c:if test="${not empty t.note}">
<div style="font-size:12px;color:#64748b;background:#fffbeb;padding:6px 10px;border-radius:6px;margin-bottom:8px;">💬 Volunteer note: ${t.note}</div>
</c:if>

<div style="font-size:12px;color:#64748b;margin-bottom:10px;">📅 ${t.workDate} | ⏰ ${t.startTime} - ${t.endTime}</div>

<div style="display:flex;gap:8px;">
<c:if test="${t.status == 'Completed'}">
<form method="post" action="${pageContext.request.contextPath}/coordinator/task-action" style="margin:0;">
<input type="hidden" name="eventId" value="${event.eventId}">
<input type="hidden" name="taskId" value="${t.taskId}">
<input type="hidden" name="action" value="confirm">
<button type="submit" style="padding:6px 14px;background:#10b981;color:white;border:none;border-radius:6px;font-size:12px;font-weight:700;cursor:pointer;">✅ Confirm</button>
</form>
</c:if>
<c:if test="${t.status == 'Pending'}">
<form method="post" action="${pageContext.request.contextPath}/coordinator/task-action" style="margin:0;" onsubmit="return confirm('Delete this task?')">
<input type="hidden" name="eventId" value="${event.eventId}">
<input type="hidden" name="taskId" value="${t.taskId}">
<input type="hidden" name="action" value="delete">
<button type="submit" style="padding:6px 14px;background:#ef4444;color:white;border:none;border-radius:6px;font-size:12px;font-weight:700;cursor:pointer;">🗑 Delete</button>
</form>
</c:if>
</div>

</div>

</c:forEach>

</div>
</div>
</div>

<div id="tab-volunteers" class="tab-content">

<div style="background:white;padding:25px;border-radius:16px;box-shadow:0 4px 20px rgba(0,0,0,0.03);">

<table class="table admin-table" style="width:100%;border-collapse:collapse;">

<thead style="background:#f8fafc;border-bottom:2px solid #e2e8f0;">
<tr>
<th style="padding:15px;text-align:left;">Volunteer</th>
<th style="padding:15px;text-align:left;">Contact</th>
<th style="padding:15px;text-align:left;">Status</th>
<th style="padding:15px;text-align:center;">Action</th>
</tr>
</thead>

<tbody>

<c:forEach items="${allVolunteers}" var="v">

<tr style="border-bottom:1px solid #f1f5f9;">

<td style="padding: 15px;">
        <div style="font-weight: 700; color: #1e293b; font-size: 15px;">${v.fullName}</div>

        <button type="button" onclick="openProfileModal(${v.volunteerId})"
           style="background: none; border: none; padding: 0; font-size: 12px; color: #8b5cf6; font-weight: 600; display: inline-block; margin-top: 4px; transition: 0.2s; cursor: pointer;">
            🔍 View Profile
        </button>
        </td>

<td style="padding:15px;color:#475569;font-size:14px;">
${v.email}
</td>

<td style="padding:15px;">
${v.status}
</td>

<td style="padding:15px;text-align:center;">

<div style="display:flex;justify-content:center;gap:8px;">

<c:if test="${v.status == 'Pending'}">

<form method="post" action="${pageContext.request.contextPath}/coordinator/manage-action">

<input type="hidden" name="action" value="approve">
<input type="hidden" name="eventId" value="${event.eventId}">
<input type="hidden" name="registrationId" value="${v.registrationId}">
<input type="hidden" name="tab" value="volunteers">

<button type="submit" class="btn-action success">
Approve
</button>

</form>

</c:if>

<c:if test="${v.status == 'Approved' && v.volunteerId != sessionScope.userId}">

<form method="post" action="${pageContext.request.contextPath}/coordinator/manage-action">

<input type="hidden" name="action" value="kick">
<input type="hidden" name="eventId" value="${event.eventId}">
<input type="hidden" name="registrationId" value="${v.registrationId}">
<input type="hidden" name="tab" value="volunteers">
<input type="hidden" name="kickReason" value="Removed by Coordinator">

<button type="submit" class="btn-action danger"
onclick="return confirm('Remove volunteer from event?')">
Kick
</button>

</form>

</c:if>

<c:if test="${v.volunteerId == sessionScope.userId}">
<span style="font-size:12px;color:#94a3b8;">(You)</span>
</c:if>

</div>

</td>

</tr>

</c:forEach>

</tbody>

</table>

</div>
</div>

<div id="tab-manual" class="tab-content">

<div style="background:white;padding:30px;border-radius:16px;box-shadow:0 4px 20px rgba(0,0,0,0.03);max-width:500px;margin:0 auto;">

<div style="text-align:center;margin-bottom:25px;">
<div style="font-size:50px;margin-bottom:10px;">🏃‍♂️</div>
<h3>Walk-in Registration</h3>
<p style="color:#64748b;">Manually add an existing volunteer</p>
</div>

<form method="post" action="${pageContext.request.contextPath}/coordinator/manage-action">

<input type="hidden" name="action" value="manual_add">
<input type="hidden" name="eventId" value="${event.eventId}">
<input type="hidden" name="tab" value="manual">

<input type="email" name="email" required placeholder="example@ivan.com"
style="width:100%;padding:12px;border:1px solid #cbd5e1;border-radius:8px;margin-bottom:20px;">

<button type="submit" class="btn-primary" style="width:100%;padding:14px;border-radius:8px;">
➕ Add to Event
</button>

</form>

</div>
</div>

</div>
</div>

<script>

function openProfileModal(volunteerId){

document.getElementById('profileModal').style.display='flex'

fetch('${pageContext.request.contextPath}/volunteer/profile?id='+volunteerId)
.then(res=>res.text())
.then(html=>{
document.getElementById('profileModalBody').innerHTML=html
})
.catch(()=>{
document.getElementById('profileModalBody').innerHTML='Error loading profile'
})

}

function closeProfileModal(){
document.getElementById('profileModal').style.display='none'
}

function switchTab(evt,tabId){

let contents=document.getElementsByClassName("tab-content")
for(let i=0;i<contents.length;i++){
contents[i].classList.remove("active")
}

let btns=document.getElementsByClassName("tab-btn")
for(let i=0;i<btns.length;i++){
btns[i].classList.remove("active")
}

document.getElementById(tabId).classList.add("active")
evt.currentTarget.classList.add("active")

}

window.onload=function(){

const params=new URLSearchParams(window.location.search)
const tab=params.get("tab")

if(tab){
document.querySelector(`.tab-btn[onclick*="tab-${tab}"]`).click()
}

}

</script>

<jsp:include page="/components/footer.jsp"/>