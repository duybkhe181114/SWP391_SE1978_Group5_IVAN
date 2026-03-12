<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/components/header.jsp"/>

<div class="admin-page" style="background: #f8fafc; min-height: 100vh; padding-bottom: 60px;">
    <div class="admin-container">

        <!-- HEADER -->
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
            <h2 class="section-title" style="margin-bottom: 0; border: none;">
                <span style="color: #8b5cf6;">●</span> Coordinator Workspace
            </h2>

            <span style="background: #e0e7ff; color: #4f46e5; padding: 8px 16px; border-radius: 8px; font-weight: 700; border: 1px solid #c7d2fe;">
                ${event.eventName}
            </span>
        </div>


        <!-- ALERT ERROR -->
        <c:if test="${not empty param.error}">
            <div style="background: #fef2f2; color: #991b1b; padding: 15px 20px; border-radius: 12px; margin-bottom: 25px; border: 1px solid #fecaca; font-weight: 600; display: flex; align-items: center; gap: 10px;">
                <span>❌</span> ${param.error}
            </div>
        </c:if>

        <!-- ALERT SUCCESS -->
        <c:if test="${not empty param.success}">
            <div style="background: #f0fdf4; color: #166534; padding: 15px 20px; border-radius: 12px; margin-bottom: 25px; border: 1px solid #bbf7d0; font-weight: 600; display: flex; align-items: center; gap: 10px;">
                <span>✅</span> ${param.success}
            </div>
        </c:if>


        <!-- MAIN GRID -->
        <div style="display: grid; grid-template-columns: 350px 1fr; gap: 30px; align-items: start;">

            <!-- ASSIGN TASK -->
            <div style="background: white; padding: 25px; border-radius: 16px; box-shadow: 0 4px 20px rgba(0,0,0,0.03);">
                <h3 style="margin: 0 0 20px 0; font-size: 18px; color: #0f172a; border-bottom: 2px solid #f1f5f9; padding-bottom: 10px;">
                    📝 Assign New Task
                </h3>

                <form method="post" action="${pageContext.request.contextPath}/coordinator/assign-task">
                    <input type="hidden" name="eventId" value="${event.eventId}">

                    <div style="margin-bottom: 15px;">
                        <label style="display: block; font-size: 13px; font-weight: 600; color: #475569; margin-bottom: 8px;">
                            Assign To <span style="color: red;">*</span>
                        </label>

                        <select name="volunteerId" required style="width: 100%; padding: 10px; border: 1px solid #cbd5e1; border-radius: 8px;">
                            <option value="">-- Select Volunteer --</option>

                            <c:forEach items="${approvedVolunteers}" var="v">
                                <option value="${v.volunteerId}">
                                    ${v.fullName} (${v.email})
                                </option>
                            </c:forEach>

                        </select>
                    </div>

                    <div style="margin-bottom: 15px;">
                        <label style="display: block; font-size: 13px; font-weight: 600; color: #475569; margin-bottom: 8px;">
                            Task Description <span style="color: red;">*</span>
                        </label>

                        <textarea name="taskDescription" required rows="3"
                            placeholder="What needs to be done?"
                            style="width: 100%; padding: 10px; border: 1px solid #cbd5e1; border-radius: 8px; resize: vertical;">
                        </textarea>
                    </div>


                    <div style="background: #f8fafc; padding: 15px; border-radius: 8px; margin-bottom: 20px; border: 1px solid #e2e8f0;">

                        <h4 style="margin: 0 0 10px 0; font-size: 13px; color: #334155;">
                            🗓️ Schedule (Required)
                        </h4>

                        <div style="margin-bottom: 10px;">
                            <label style="font-size: 12px; color: #64748b;">Date:</label>

                            <input type="date" name="workDate" required
                                style="width: 100%; padding: 8px; border: 1px solid #cbd5e1; border-radius: 6px;">
                        </div>

                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 10px;">

                            <div>
                                <label style="font-size: 12px; color: #64748b;">Start Time:</label>

                                <input type="time" name="startTime" required
                                    style="width: 100%; padding: 8px; border: 1px solid #cbd5e1; border-radius: 6px;">
                            </div>

                            <div>
                                <label style="font-size: 12px; color: #64748b;">End Time:</label>

                                <input type="time" name="endTime" required
                                    style="width: 100%; padding: 8px; border: 1px solid #cbd5e1; border-radius: 6px;">
                            </div>

                        </div>

                    </div>


                    <button type="submit"
                        class="btn-primary"
                        style="width: 100%; padding: 12px; border-radius: 8px; background: #8b5cf6; border-color: #8b5cf6; font-weight: 700;">
                        🚀 Assign Task
                    </button>

                </form>
            </div>



            <!-- TASK LIST -->
            <div style="background: white; padding: 25px; border-radius: 16px; box-shadow: 0 4px 20px rgba(0,0,0,0.03);">

                <h3 style="margin: 0 0 20px 0; font-size: 18px; color: #0f172a; border-bottom: 2px solid #f1f5f9; padding-bottom: 10px;">
                    📊 Task Progress
                </h3>

                <c:if test="${empty eventTasks}">

                    <div style="text-align: center; padding: 40px; color: #94a3b8; border: 2px dashed #e2e8f0; border-radius: 12px;">
                        <div style="font-size: 40px; margin-bottom: 10px;">📋</div>
                        <div>Tasks will appear here once assigned.</div>
                    </div>

                </c:if>


                <c:if test="${not empty eventTasks}">

                    <div style="display: flex; flex-direction: column; gap: 15px;">

                        <c:forEach items="${eventTasks}" var="t">

                            <div style="padding: 15px; border: 1px solid #e2e8f0; border-radius: 12px; background: #f8fafc;">

                                <div style="display: flex; justify-content: space-between; margin-bottom: 8px;">
                                    <span style="font-weight: 700; color: #1e293b; font-size: 15px;">
                                        ${t.volunteerName}
                                    </span>

                                    <span style="font-size: 12px; font-weight: 700; padding: 4px 10px; border-radius: 20px;
                                        ${t.status == 'Pending' ? 'background:#fef9c3; color:#854d0e;' :
                                          t.status == 'In Progress' ? 'background:#dbeafe; color:#1e40af;' :
                                          t.status == 'Completed' ? 'background:#dcfce7; color:#166534;' :
                                          'background:#e2e8f0; color:#475569;'}">

                                        ${t.status}

                                    </span>
                                </div>

                                <p style="color: #475569; font-size: 14px; margin: 0 0 10px 0;">
                                    ${t.description}
                                </p>

                                <div style="font-size: 12px; color: #64748b; display: flex; gap: 15px;">
                                    <span>📅 ${t.workDate}</span>
                                    <span>⏰ ${t.startTime} - ${t.endTime}</span>
                                </div>

                            </div>

                        </c:forEach>

                    </div>

                </c:if>

            </div>

        </div>

    </div>
</div>

<jsp:include page="/components/footer.jsp"/>