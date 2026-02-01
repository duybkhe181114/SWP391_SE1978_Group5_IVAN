<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Create Event</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/layout.css">
    <style>
        .form-container { max-width: 800px; margin: 60px auto; padding: 40px; background: white; border-radius: 16px; box-shadow: 0 10px 30px rgba(0,0,0,0.1); }
        .form-container h1 { margin-bottom: 30px; color: #333; }
        .form-group { margin-bottom: 25px; }
        .form-group label { display: block; margin-bottom: 8px; font-weight: 600; color: #555; }
        .form-group input, .form-group textarea { width: 100%; padding: 12px; border: 2px solid #e0e0e0; border-radius: 8px; font-size: 14px; transition: border 0.3s; }
        .form-group input:focus, .form-group textarea:focus { outline: none; border-color: #667eea; }
        .form-group textarea { min-height: 120px; resize: vertical; }
        .btn-submit { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 14px 40px; border: none; border-radius: 8px; font-size: 16px; font-weight: 600; cursor: pointer; transition: transform 0.3s; }
        .btn-submit:hover { transform: translateY(-2px); }
        .error { color: #e74c3c; margin-bottom: 20px; padding: 12px; background: #fee; border-radius: 8px; }
    </style>
</head>
<body>
    <jsp:include page="/components/header.jsp"/>
    
    <div class="form-container">
        <h1>Create New Event</h1>
        
        <% if (request.getAttribute("error") != null) { %>
            <div class="error">${error}</div>
        <% } %>
        
        <form method="post" action="${pageContext.request.contextPath}/organization/create-event">
            <div class="form-group">
                <label>Event Title *</label>
                <input type="text" name="title" required>
            </div>
            
            <div class="form-group">
                <label>Description *</label>
                <textarea name="description" required></textarea>
            </div>
            
            <div class="form-group">
                <label>Location *</label>
                <input type="text" name="location" required>
            </div>
            
            <div class="form-group">
                <label>Start Date *</label>
                <input type="datetime-local" name="startDate" required>
            </div>
            
            <div class="form-group">
                <label>End Date *</label>
                <input type="datetime-local" name="endDate" required>
            </div>
            
            <div class="form-group">
                <label>Required Volunteers *</label>
                <input type="number" name="requiredVolunteers" min="1" required>
            </div>
            
            <button type="submit" class="btn-submit">Create Event</button>
        </form>
    </div>
    
    <jsp:include page="/components/footer.jsp"/>
</body>
</html>
