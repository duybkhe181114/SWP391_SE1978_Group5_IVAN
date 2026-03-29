<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/components/header.jsp"/>

<style>
    .fc-theme-standard .fc-scrollgrid { border: 1px solid #e2e8f0; border-radius: 8px; overflow: hidden; }
    .fc-theme-standard th { background: #f8fafc; padding: 12px 0; font-weight: 700; color: #475569; text-transform: uppercase; font-size: 13px; }
    .fc-timegrid-slot-label-cushion { font-size: 12px; color: #94a3b8; }

    .fc-event { border-radius: 6px !important; border: none !important; box-shadow: 0 2px 4px rgba(0,0,0,0.1); transition: 0.2s; cursor: pointer; overflow: hidden; }
    .fc-event:hover { transform: scale(1.02); box-shadow: 0 6px 15px rgba(0,0,0,0.15); z-index: 10 !important; }

    .custom-evt { padding: 6px; color: white; display: flex; flex-direction: column; gap: 3px; height: 100%; box-sizing: border-box; overflow: hidden; }
    .custom-evt-title { font-size: 13px; font-weight: 800; line-height: 1.3; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
    .custom-evt-detail { font-size: 11px; font-weight: 500; opacity: 0.95; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; display: flex; align-items: center; gap: 4px; }
    .custom-evt-type { font-size: 10px; font-weight: 800; opacity: 0.85; background: rgba(255,255,255,0.2); border-radius: 3px; padding: 1px 5px; display: inline-block; }

    .fc-daygrid-event .custom-evt { padding: 4px 6px; }
    .fc-daygrid-event .custom-evt-detail { font-size: 10px; }

    .fc-toolbar-title { font-weight: 800 !important; color: #0f172a; font-size: 22px !important; }
    .fc-button-primary { background-color: #667eea !important; border-color: #667eea !important; text-transform: capitalize !important; font-weight: 600 !important; border-radius: 8px !important; padding: 8px 16px !important; }
    .fc-button-primary:hover { background-color: #5a67d8 !important; }
    .fc-button-active { background-color: #4f46e5 !important; }
</style>

<div class="admin-page" style="background: #f8fafc; min-height: 100vh; padding-bottom: 60px;">
    <div class="container" style="max-width: 1200px;">

        <div style="text-align: center; margin-bottom: 30px;">
            <h1 style="margin: 0 0 10px 0; font-size: 32px; color: #0f172a; font-weight: 800;">📅 My Schedule</h1>
        </div>

        <div style="background: white; padding: 30px; border-radius: 16px; box-shadow: 0 4px 20px rgba(0,0,0,0.03); border: 1px solid #e2e8f0;">

            <%-- Legend --%>
            <div style="display: flex; gap: 20px; margin-bottom: 20px; justify-content: flex-end; font-size: 13px; font-weight: 600; color: #475569; flex-wrap: wrap;">
                <div style="display:flex;align-items:center;gap:6px;"><span style="width:12px;height:12px;background:#f59e0b;border-radius:3px;"></span> Pending</div>
                <div style="display:flex;align-items:center;gap:6px;"><span style="width:12px;height:12px;background:#3b82f6;border-radius:3px;"></span> In Progress</div>
                <div style="display:flex;align-items:center;gap:6px;"><span style="width:12px;height:12px;background:#10b981;border-radius:3px;"></span> Completed/Confirmed</div>
                <div style="display:flex;align-items:center;gap:6px;"><span style="width:12px;height:12px;background:#8b5cf6;border-radius:3px;"></span> Flexible (Deadline)</div>
                <div style="display:flex;align-items:center;gap:6px;"><span style="width:12px;height:12px;background:#0ea5e9;border-radius:3px;"></span> Scheduled</div>
            </div>

            <div id="calendar"></div>

        </div>
    </div>
</div>

<script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.11/index.global.min.js'></script>
<script>
  document.addEventListener('DOMContentLoaded', function() {
    var calendarEl = document.getElementById('calendar');

    // Build events array from server-side data
    var events = [
      <c:forEach items="${allTasks}" var="t" varStatus="status">
      <c:if test="${not empty t.calStart}">
      {
        title: '<c:out value="${t.description}" />',
        start: '${t.calStart}',
        end: '${t.calEnd}',
        backgroundColor: (function() {
          var s = '${t.status}';
          var tp = '${t.taskType}';
          if (s === 'In Progress') return '#3b82f6';
          if (s === 'Completed' || s === 'Confirmed') return '#10b981';
          // Pending: distinguish by type
          return tp === 'SCHEDULED' ? '#0ea5e9' : '#8b5cf6';
        })(),
        url: '${pageContext.request.contextPath}/volunteer/workspace?eventId=${t.eventId}',
        extendedProps: {
          eventName: '<c:out value="${t.eventName}" />',
          coordinator: '<c:out value="${t.coordinatorName}" />',
          taskType: '${t.taskType}',
          status: '${t.status}',
          location: '<c:out value="${t.location}" />',
          note: '<c:out value="${t.note}" />'
        }
      }${not status.last ? ',' : ''}
      </c:if>
      </c:forEach>
    ];

    var calendar = new FullCalendar.Calendar(calendarEl, {
      initialView: 'timeGridWeek',
      headerToolbar: {
        left: 'prev,next today',
        center: 'title',
        right: 'dayGridMonth,timeGridWeek,timeGridDay'
      },
      allDaySlot: false,
      height: 'auto',
      slotEventOverlap: false,
      eventDisplay: 'block',
      events: events,

      eventContent: function(arg) {
        var props = arg.event.extendedProps;
        var typeBadge = props.taskType === 'SCHEDULED' ? '🗓 Scheduled' : '⏱ Flexible';
        var noteHtml = '';
        if (props.note && props.note.trim()) {
          noteHtml = '<div class="custom-evt-detail" style="color:#fef08a;">⚠️ ' + props.note + '</div>';
        }
        var locHtml = props.location ? '<div class="custom-evt-detail">📍 ' + props.location + '</div>' : '';
        var html = '<div class="custom-evt" title="' + arg.event.title + '">'
          + '<div class="custom-evt-type">' + typeBadge + '</div>'
          + '<div class="custom-evt-title">' + arg.event.title + '</div>'
          + '<div class="custom-evt-detail">⏰ ' + arg.timeText + '</div>'
          + '<div class="custom-evt-detail">📍 ' + props.eventName + '</div>'
          + '<div class="custom-evt-detail">👤 ' + props.coordinator + '</div>'
          + locHtml
          + noteHtml
          + '</div>';
        return { html: html };
      }
    });

    calendar.render();
  });
</script>

<jsp:include page="/components/footer.jsp"/>