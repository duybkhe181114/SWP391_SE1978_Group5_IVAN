<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/components/header.jsp"/>

<div class="admin-page" style="background: #f8fafc; min-height: 100vh; padding-bottom: 60px;">
    <div class="admin-container">

        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
            <h2 class="section-title" style="margin-bottom: 0; border: none;">
                <span style="color: #667eea;">●</span> Event Management
            </h2>
            <span style="background: #e2e8f0; padding: 8px 16px; border-radius: 8px; font-weight: 700; color: #475569;">
                ID: #${event.eventId}
            </span>
        </div>

        <div style="background: white; padding: 30px; border-radius: 16px; margin-bottom: 30px; box-shadow: 0 4px 20px rgba(0,0,0,0.03);">
            <h1 style="font-size: 24px; color: #0f172a; margin-bottom: 20px;">${event.eventName}</h1>

            <div class="stat-grid" style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px;">
                <div class="mini-stat" style="background: #f8fafc; padding: 20px; border-radius: 12px; border-left: 4px solid #667eea;">
                    <label style="color: #64748b; font-size: 12px; font-weight: 700; text-transform: uppercase;">Total Slots</label>
                    <div style="font-size: 28px; font-weight: 800; color: #1e293b; margin-top: 5px;">
                        ${event.maxVolunteers == 0 ? 'Unlimited' : event.maxVolunteers}
                    </div>
                </div>

                <div class="mini-stat" style="background: #f8fafc; padding: 20px; border-radius: 12px; border-left: 4px solid #10b981;">
                    <label style="color: #64748b; font-size: 12px; font-weight: 700; text-transform: uppercase;">Joined</label>
                    <div style="font-size: 28px; font-weight: 800; color: #1e293b; margin-top: 5px;">${event.currentVolunteers}</div>
                </div>

                <div class="mini-stat" style="background: #f8fafc; padding: 20px; border-radius: 12px; border-left: 4px solid #f59e0b;">
                    <label style="color: #64748b; font-size: 12px; font-weight: 700; text-transform: uppercase;">Remaining</label>
                    <div style="font-size: 28px; font-weight: 800; color: #1e293b; margin-top: 5px;">
                        ${event.maxVolunteers == 0 ? '∞' : (event.maxVolunteers - event.currentVolunteers)}
                    </div>
                </div>
            </div>
        </div>


        <div class="admin-table-wrapper" style="margin-bottom: 40px; border-radius: 16px; overflow: hidden; box-shadow: 0 4px 20px rgba(0,0,0,0.03);">

            <div style="display: flex; justify-content: space-between; align-items: center; padding: 20px 25px; background: white; border-bottom: 1px solid #f1f5f9;">
                <h3 style="margin: 0; font-size: 18px; color: #0f172a;">👥 Active Event Team</h3>

                <button onclick="document.getElementById('addCoordModal').style.display='flex'"
                        class="btn-primary"
                        style="padding: 8px 16px; font-size: 14px; border-radius: 8px; background: #8b5cf6; border-color: #8b5cf6;">
                    ➕ Add Coordinator
                </button>
            </div>

            <table class="table admin-table" style="margin: 0;">
                <thead style="background: #f8fafc;">
                <tr>
                    <th>Member</th>
                    <th>Contact</th>
                    <th>Role</th>
                    <th style="text-align: center;">Actions</th>
                </tr>
                </thead>

                <tbody style="background: white;">
                <c:forEach items="${volunteers}" var="v">
                    <c:if test="${v.status == 'Approved'}">

                        <tr>

                            <td>
                                <div style="font-weight: 700; color: #0f172a;">${v.fullName}</div>
                                <button type="button" onclick="openProfileModal(${v.volunteerId})"
                                   style="background: none; border: none; padding: 0; font-size: 12px; color: #8b5cf6; font-weight: 600; display: block; margin-top: 4px; transition: 0.2s; cursor: pointer;">
                                    🔍 View Profile
                                </button>
                            </td>

                            <td>
                                <div style="font-size: 14px; color: #334155;">${v.email}</div>
                                <div style="font-size: 12px; color: #94a3b8;">
                                    ${empty v.phone ? 'No phone' : v.phone}
                                </div>
                            </td>

                            <td>

                                <c:choose>

                                    <c:when test="${v.isCoordinator == 1}">
                                        <span style="background: #e0e7ff; color: #4f46e5; padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: 700; border: 1px solid #c7d2fe;">
                                            👑 Coordinator
                                        </span>
                                    </c:when>

                                    <c:otherwise>
                                        <span style="background: #dcfce7; color: #166534; padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: 700; border: 1px solid #bbf7d0;">
                                            Volunteer
                                        </span>
                                    </c:otherwise>

                                </c:choose>

                            </td>

                            <td style="text-align: center;">

                                <div style="display: flex; gap: 8px; justify-content: center;">

                                    <c:if test="${v.isCoordinator == 0}">
                                        <form method="post"
                                              action="${pageContext.request.contextPath}/organization/manage-registrations">
                                            <input type="hidden" name="volunteerId" value="${v.volunteerId}">
                                            <input type="hidden" name="eventId" value="${event.eventId}">

                                            <button type="submit"
                                                    name="action"
                                                    value="promote"
                                                    class="btn-primary"
                                                    style="padding: 6px 16px; font-size: 13px; border-radius: 6px; background: #8b5cf6; border-color: #8b5cf6;">
                                                ⬆️ Promote
                                            </button>
                                        </form>
                                    </c:if>

                                    <c:if test="${v.isCoordinator == 1}">
                                        <form method="post"
                                              action="${pageContext.request.contextPath}/organization/manage-registrations">
                                            <input type="hidden" name="volunteerId" value="${v.volunteerId}">
                                            <input type="hidden" name="eventId" value="${event.eventId}">

                                            <button type="submit"
                                                    name="action"
                                                    value="revoke"
                                                    class="btn-action"
                                                    style="padding: 6px 16px; font-size: 13px; border-radius: 6px; background: #f1f5f9; color: #475569; border: 1px solid #cbd5e1;"
                                                    onclick="return confirm('Demote this coordinator to volunteer?');">
                                                ⬇️ Revoke
                                            </button>
                                        </form>
                                    </c:if>

                                    <button type="button"
                                            onclick="openKickModal(${v.registrationId}, ${v.volunteerId}, ${event.eventId}, '${v.fullName}')"
                                            class="btn-action danger"
                                            style="padding: 6px 16px; font-size: 13px; border-radius: 6px;">
                                        🥾 Kick
                                    </button>

                                </div>

                            </td>

                        </tr>

                    </c:if>
                </c:forEach>
                </tbody>

            </table>
        </div>


        <div class="admin-table-wrapper"
             style="border-radius: 16px; overflow: hidden; box-shadow: 0 4px 20px rgba(0,0,0,0.03);">

            <h3 style="padding: 20px 25px; background: white; border-bottom: 1px solid #f1f5f9; margin: 0; font-size: 18px; color: #0f172a;">
                📋 Registration Log
            </h3>

            <table class="table admin-table" style="margin: 0;">

                <thead style="background: #f8fafc;">
                <tr>
                    <th>Applicant</th>
                    <th>Contact</th>
                    <th>Status</th>
                    <th style="text-align: center;">Actions</th>
                </tr>
                </thead>

                <tbody style="background: white;">

                <c:forEach items="${volunteers}" var="v">

                    <c:if test="${v.status == 'Pending' || v.status == 'Rejected'}">

                        <tr style="${v.status == 'Rejected' ? 'opacity: 0.7;' : ''}">

                            <td>
                                <div style="font-weight: 700; color: #0f172a;">${v.fullName}</div>
                                <button type="button" onclick="openProfileModal(${v.volunteerId})"
                                   style="background: none; border: none; padding: 0; font-size: 12px; color: #8b5cf6; font-weight: 600; display: block; margin-top: 4px; transition: 0.2s; cursor: pointer;">
                                    🔍 View Profile
                                </button>
                            </td>

                            <td>
                                <div style="font-size: 14px; color: #334155;">${v.email}</div>
                            </td>

                            <td>

                                <span style="padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: 700;
                                          ${v.status == 'Pending' ? 'background: #fef9c3; color: #854d0e; border: 1px solid #fef08a;' : 'background: #fee2e2; color: #991b1b; border: 1px solid #fecaca;'}">
                                    ${v.status}
                                </span>

                            </td>

                            <td style="text-align: center;">

                                <c:if test="${v.status == 'Pending'}">

                                    <div style="display: flex; gap: 8px; justify-content: center;">

                                        <form method="post"
                                              action="${pageContext.request.contextPath}/organization/manage-registrations">

                                            <input type="hidden" name="registrationId" value="${v.registrationId}">
                                            <input type="hidden" name="eventId" value="${event.eventId}">

                                            <button type="submit"
                                                    name="action"
                                                    value="approve"
                                                    class="btn-action success"
                                                    style="padding: 6px 16px; font-size: 13px; border-radius: 6px;">
                                                Approve
                                            </button>

                                        </form>

                                        <button type="button"
                                                onclick="openRejectModal(${v.registrationId}, ${event.eventId})"
                                                class="btn-action danger"
                                                style="padding: 6px 16px; font-size: 13px; border-radius: 6px;">
                                            Reject
                                        </button>

                                    </div>

                                </c:if>

                                <c:if test="${v.status == 'Rejected'}">
                                    <span style="font-size: 12px; color: #94a3b8;">No actions</span>
                                </c:if>

                            </td>

                        </tr>

                    </c:if>

                </c:forEach>

                </tbody>

            </table>
        </div>
    </div>
</div>


<div id="profileModal" style="display: none; position: fixed; inset: 0; background: rgba(15, 23, 42, 0.6); backdrop-filter: blur(4px); z-index: 9999; align-items: center; justify-content: center;">
    <div style="background: white; border-radius: 16px; width: 90%; max-width: 600px; max-height: 90vh; overflow-y: auto; position: relative; box-shadow: 0 20px 40px rgba(0,0,0,0.2);">
        <button onclick="closeProfileModal()" style="position: absolute; top: 15px; right: 15px; background: rgba(0,0,0,0.2); color: white; border: none; border-radius: 50%; width: 32px; height: 32px; cursor: pointer; font-size: 16px; font-weight: bold; z-index: 10; display: flex; align-items: center; justify-content: center; transition: 0.2s;" onmouseover="this.style.background='rgba(0,0,0,0.4)'" onmouseout="this.style.background='rgba(0,0,0,0.2)'">✕</button>
        <div id="profileModalBody">
            <div style="text-align: center; padding: 60px; color: #64748b;">
                <div style="font-size: 30px; margin-bottom: 10px;">⏳</div>
                Loading volunteer profile...
            </div>
        </div>
    </div>
</div>

<div id="addCoordModal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 1000; align-items: center; justify-content: center;">
    <div style="background: white; padding: 30px; border-radius: 16px; width: 90%; max-width: 550px; box-shadow: 0 10px 40px rgba(0,0,0,0.2); max-height: 90vh; overflow-y: auto;">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px;">
            <h3 style="margin: 0; color: #0f172a; font-size: 20px;">➕ Add Coordinator</h3>
            <button onclick="document.getElementById('addCoordModal').style.display='none'" style="background: none; border: none; font-size: 24px; cursor: pointer; color: #94a3b8;">&times;</button>
        </div>

        <div style="background: #f8fafc; padding: 20px; border-radius: 12px; margin-bottom: 20px; border: 1px solid #e2e8f0;">
            <h4 style="margin: 0 0 15px 0; color: #1e293b; font-size: 15px;">Option 1: Assign Existing Coordinator</h4>
            <form method="post" action="${pageContext.request.contextPath}/organization/manage-registrations" style="display: flex; gap: 10px;">
                <input type="hidden" name="eventId" value="${event.eventId}">
                <input type="hidden" name="action" value="assign_existing">
                <select name="coordinatorId" required style="flex-grow: 1; padding: 10px 14px; border: 1px solid #cbd5e1; border-radius: 8px; font-family: inherit;">
                    <option value="">-- Select Active Coordinator --</option>
                    <c:forEach var="ac" items="${activeCoordinators}">
                        <option value="${ac.coordinatorId}">${ac.coordinatorName} (${ac.coordinatorEmail})</option>
                    </c:forEach>
                </select>
                <button type="submit" class="btn-primary" style="padding: 10px 20px; border-radius: 8px; white-space: nowrap;">Assign</button>
            </form>
            <c:if test="${empty activeCoordinators}">
                <div style="font-size: 12px; color: #ef4444; margin-top: 8px;">* Your organization doesn't have any active coordinators yet.</div>
            </c:if>
        </div>

        <div style="text-align: center; color: #94a3b8; font-weight: 600; font-size: 14px; margin-bottom: 20px;">OR</div>

        <div style="background: #f8fafc; padding: 20px; border-radius: 12px; border: 1px solid #e2e8f0;">
            <h4 style="margin: 0 0 15px 0; color: #1e293b; font-size: 15px;">Option 2: Promote Volunteer by Email</h4>
            <form method="post" action="${pageContext.request.contextPath}/organization/manage-registrations" style="display: flex; flex-direction: column; gap: 15px;">
                <input type="hidden" name="eventId" value="${event.eventId}">
                <input type="hidden" name="action" value="promote_by_email">
                <input type="email" name="email" required placeholder="Enter volunteer's email address..." style="width: 100%; padding: 10px 14px; border: 1px solid #cbd5e1; border-radius: 8px;">
                <button type="submit" class="btn-primary" style="padding: 12px; border-radius: 8px; background: #8b5cf6; border-color: #8b5cf6;">🚀 Promote to Coordinator</button>
            </form>
        </div>
    </div>
</div>

<div id="rejectModal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:1000; align-items:center; justify-content:center;">
    <div style="background:white; padding:30px; border-radius:16px; width:90%; max-width:500px;">
        <h3>Reject Application</h3>
        <form method="post" action="${pageContext.request.contextPath}/organization/manage-registrations">
            <input type="hidden" name="registrationId" id="rejectRegistrationId">
            <input type="hidden" name="eventId" id="rejectEventId">
            <input type="hidden" name="action" value="reject">
            <textarea name="reviewNote" required style="width:100%; min-height:100px; padding: 10px; border-radius: 8px; border: 1px solid #cbd5e1;"></textarea>
            <div style="margin-top:20px; text-align:right;">
                <button type="button" onclick="document.getElementById('rejectModal').style.display='none'" style="padding: 8px 16px; border: none; background: #f1f5f9; border-radius: 6px; cursor: pointer; margin-right: 10px;">Cancel</button>
                <button type="submit" class="btn-action danger" style="padding: 8px 16px; border: none; border-radius: 6px; cursor: pointer;">Reject</button>
            </div>
        </form>
    </div>
</div>

<div id="kickModal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:1000; align-items:center; justify-content:center;">
    <div style="background:white; padding:30px; border-radius:16px; width:90%; max-width:500px;">
        <h3>Kick Member</h3>
        <form method="post" action="${pageContext.request.contextPath}/organization/manage-registrations">
            <input type="hidden" name="registrationId" id="kickRegistrationId">
            <input type="hidden" name="volunteerId" id="kickVolunteerId">
            <input type="hidden" name="eventId" id="kickEventId">
            <input type="hidden" name="action" value="kick">
            <textarea name="kickReason" required style="width:100%; min-height:100px; padding: 10px; border-radius: 8px; border: 1px solid #cbd5e1;"></textarea>
            <div style="margin-top:20px; text-align:right;">
                <button type="button" onclick="document.getElementById('kickModal').style.display='none'" style="padding: 8px 16px; border: none; background: #f1f5f9; border-radius: 6px; cursor: pointer; margin-right: 10px;">Cancel</button>
                <button type="submit" class="btn-action danger" style="padding: 8px 16px; border: none; border-radius: 6px; cursor: pointer;">Remove</button>
            </div>
        </form>
    </div>
</div>

<script>
    // PROFILE MODAL AJAX
    function openProfileModal(volunteerId) {
        document.getElementById('profileModal').style.display = 'flex';
        document.getElementById('profileModalBody').innerHTML = '<div style="text-align: center; padding: 60px; color: #64748b;"><div style="font-size: 30px; margin-bottom: 10px;">⏳</div>Loading volunteer profile...</div>';

        fetch('${pageContext.request.contextPath}/volunteer/profile?id=' + volunteerId)
            .then(response => {
                if (!response.ok) throw new Error("Not found");
                return response.text();
            })
            .then(html => {
                document.getElementById('profileModalBody').innerHTML = html;
            })
            .catch(error => {
                document.getElementById('profileModalBody').innerHTML = '<div style="text-align: center; padding: 60px; color: #e11d48;">❌ Error loading profile.</div>';
            });
    }

    function closeProfileModal() {
        document.getElementById('profileModal').style.display = 'none';
    }

    // ĐÓNG MODAL KHI CLICK RA NGOÀI (Cho tất cả Modal)
    window.onclick = function(event) {
        var profileModal = document.getElementById('profileModal');
        var addCoordModal = document.getElementById('addCoordModal');
        var rejectModal = document.getElementById('rejectModal');
        var kickModal = document.getElementById('kickModal');

        if (event.target == profileModal) closeProfileModal();
        if (event.target == addCoordModal) addCoordModal.style.display = 'none';
        if (event.target == rejectModal) rejectModal.style.display = 'none';
        if (event.target == kickModal) kickModal.style.display = 'none';
    }

    // OTHER MODALS
    function openRejectModal(registrationId, eventId){
        document.getElementById('rejectRegistrationId').value = registrationId;
        document.getElementById('rejectEventId').value = eventId;
        document.getElementById('rejectModal').style.display='flex';
    }

    function openKickModal(registrationId, volunteerId, eventId, name){
        document.getElementById('kickRegistrationId').value = registrationId;
        document.getElementById('kickVolunteerId').value = volunteerId;
        document.getElementById('kickEventId').value = eventId;
        document.getElementById('kickModal').style.display='flex';
    }
</script>

<jsp:include page="/components/footer.jsp"/>