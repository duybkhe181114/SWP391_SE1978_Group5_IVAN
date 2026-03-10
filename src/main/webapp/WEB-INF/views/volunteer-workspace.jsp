<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/components/header.jsp"/>

<style>
    .kanban-board { display: grid; grid-template-columns: repeat(3, 1fr); gap: 24px; align-items: start; }
    .kanban-col { background: #f1f5f9; padding: 20px; border-radius: 16px; min-height: 500px; }
    .kanban-col h4 { margin: 0 0 20px 0; font-size: 16px; color: #334155; display: flex; align-items: center; justify-content: space-between; }
    .task-card { background: white; padding: 20px; border-radius: 12px; box-shadow: 0 4px 6px rgba(0,0,0,0.02); margin-bottom: 16px; border: 1px solid #e2e8f0; transition: 0.2s; }
    .task-card:hover { box-shadow: 0 10px 15px rgba(0,0,0,0.05); transform: translateY(-2px); }
</style>

<div class="admin-page" style="background: #ffffff; min-height: 100vh; padding-bottom: 60px;">
    <div class="container" style="max-width: 1400px; padding-top: 40px;">

        <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 40px;">
            <div>
                <a href="${pageContext.request.contextPath}/event/detail?id=${event.eventId}" style="color: #64748b; text-decoration: none; font-size: 14px; font-weight: 600; margin-bottom: 10px; display: inline-block;">← Back to Event</a>
                <h1 style="margin: 0; font-size: 28px; color: #0f172a; font-weight: 800;">My Workspace</h1>
                <div style="color: #667eea; font-weight: 600; margin-top: 5px;">📍 ${event.eventName}</div>
            </div>
            <div style="background: #f8fafc; padding: 10px 20px; border-radius: 10px; border: 1px solid #e2e8f0;">
                <span style="color: #64748b; font-size: 13px;">Total Assigned Tasks:</span>
                <span style="font-weight: 800; color: #0f172a; font-size: 18px; margin-left: 5px;">${myTasks.size()}</span>
            </div>
        </div>

        <div class="kanban-board">

            <div class="kanban-col" style="border-top: 4px solid #f59e0b;">
                <h4>TO DO <span style="background: white; padding: 2px 8px; border-radius: 10px; font-size: 12px;">🕒</span></h4>
                <c:forEach items="${myTasks}" var="t">
                    <c:if test="${t.status == 'Pending'}">
                        <div class="task-card">
                            <p style="margin: 0 0 15px 0; color: #1e293b; font-weight: 600; font-size: 15px; line-height: 1.5;">${t.description}</p>
                            <div style="font-size: 12px; color: #64748b; margin-bottom: 15px; background: #f8fafc; padding: 10px; border-radius: 8px;">
                                <div>📅 ${t.workDate}</div>
                                <div style="margin-top: 4px;">⏰ ${t.startTime} - ${t.endTime}</div>
                            </div>
                            <form method="post" action="${pageContext.request.contextPath}/volunteer/update-task">
                                <input type="hidden" name="eventId" value="${event.eventId}">
                                <input type="hidden" name="taskId" value="${t.taskId}">
                                <button type="submit" name="action" value="start" style="width: 100%; padding: 10px; background: #3b82f6; color: white; border: none; border-radius: 8px; font-weight: 700; cursor: pointer;">▶️ Start Working</button>
                            </form>
                        </div>
                    </c:if>
                </c:forEach>
            </div>

            <div class="kanban-col" style="border-top: 4px solid #3b82f6;">
                <h4>IN PROGRESS <span style="background: white; padding: 2px 8px; border-radius: 10px; font-size: 12px;">🚀</span></h4>
                <c:forEach items="${myTasks}" var="t">
                    <c:if test="${t.status == 'In Progress'}">
                        <div class="task-card" style="border-left: 4px solid #3b82f6;">
                            <p style="margin: 0 0 15px 0; color: #1e293b; font-weight: 600; font-size: 15px; line-height: 1.5;">${t.description}</p>
                            <div style="font-size: 12px; color: #64748b; margin-bottom: 15px; background: #f8fafc; padding: 10px; border-radius: 8px;">
                                <div>📅 ${t.workDate}</div>
                                <div style="margin-top: 4px;">⏰ ${t.startTime} - ${t.endTime}</div>
                            </div>
                            <form method="post" action="${pageContext.request.contextPath}/volunteer/update-task">
                                <input type="hidden" name="eventId" value="${event.eventId}">
                                <input type="hidden" name="taskId" value="${t.taskId}">
                                <button type="submit" name="action" value="complete" style="width: 100%; padding: 10px; background: #10b981; color: white; border: none; border-radius: 8px; font-weight: 700; cursor: pointer;">✅ Mark Completed</button>
                            </form>
                        </div>
                    </c:if>
                </c:forEach>
            </div>

            <div class="kanban-col" style="border-top: 4px solid #10b981; opacity: 0.8;">
                <h4>DONE <span style="background: white; padding: 2px 8px; border-radius: 10px; font-size: 12px;">🎉</span></h4>
                <c:forEach items="${myTasks}" var="t">
                    <c:if test="${t.status == 'Completed'}">
                        <div class="task-card">
                            <p style="margin: 0 0 15px 0; color: #475569; font-weight: 600; font-size: 15px; text-decoration: line-through;">${t.description}</p>
                            <div style="font-size: 12px; color: #94a3b8; margin-bottom: 10px;">
                                Completed on schedule.
                            </div>
                            <div style="text-align: center; color: #10b981; font-weight: 800; font-size: 14px; padding: 8px; background: #dcfce7; border-radius: 8px;">
                                🎉 Excellent!
                            </div>
                        </div>
                    </c:if>
                </c:forEach>
            </div>

        </div>
    </div>
</div>

<jsp:include page="/components/footer.jsp"/>