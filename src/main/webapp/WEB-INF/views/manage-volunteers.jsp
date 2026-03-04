<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Volunteers</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/layout.css">
    <style>
        .container { padding: 60px 0; }
        .volunteer-list { margin-top: 30px; }
        .volunteer-card { background: white; padding: 25px; margin-bottom: 20px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); display: flex; justify-content: space-between; align-items: center; }
        .volunteer-info h3 { margin: 0 0 10px 0; color: #333; }
        .volunteer-info p { margin: 5px 0; color: #666; }
        .status { display: inline-block; padding: 6px 12px; border-radius: 6px; font-size: 12px; font-weight: 600; }
        .status.pending { background: #fff3cd; color: #856404; }
        .status.approved { background: #d4edda; color: #155724; }
        .status.rejected { background: #f8d7da; color: #721c24; }
        .actions { display: flex; gap: 10px; }
        .btn { padding: 10px 20px; border: none; border-radius: 8px; cursor: pointer; font-weight: 600; transition: all 0.3s; }
        .btn-approve { background: #28a745; color: white; }
        .btn-reject { background: #dc3545; color: white; }
        .btn:hover { transform: translateY(-2px); }
        
        /* Modal styles */
        .modal { display: none; position: fixed; z-index: 1000; left: 0; top: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); }
        .modal-content { background: white; margin: 10% auto; padding: 30px; border-radius: 12px; width: 500px; box-shadow: 0 4px 20px rgba(0,0,0,0.2); }
        .modal-header { margin-bottom: 20px; }
        .modal-header h2 { margin: 0; color: #333; }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; margin-bottom: 8px; font-weight: 600; color: #555; }
        .form-group textarea { width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 8px; font-size: 14px; resize: vertical; min-height: 100px; }
        .modal-actions { display: flex; gap: 10px; justify-content: flex-end; }
        .btn-cancel { background: #6c757d; color: white; }
    </style>
</head>
<body>
    <jsp:include page="/components/header.jsp"/>
    
    <div class="container">
        <h1>Manage Volunteers</h1>
        
        <div class="volunteer-list">
            <c:forEach items="${volunteers}" var="v">
                <div class="volunteer-card">
                    <div class="volunteer-info">
                        <h3>${v.fullName != null ? v.fullName : v.email}</h3>
                        <p>Email: ${v.email}</p>
                        <p>Phone: ${v.phone != null ? v.phone : 'N/A'}</p>
                        <p>Gender: ${v.gender != null ? v.gender : 'N/A'}</p>
                        <p>Address: ${v.address != null ? v.address : 'N/A'}</p>
                        <p>Registered: ${v.registeredAt}</p>
                        <span class="status ${v.status.toLowerCase()}">${v.status}</span>
                    </div>
                    
                    <c:if test="${v.status == 'Pending'}">
                        <div class="actions">
                            <form method="post" style="display: inline;">
                                <input type="hidden" name="registrationId" value="${v.registrationId}">
                                <input type="hidden" name="eventId" value="${eventId}">
                                <input type="hidden" name="action" value="approve">
                                <button type="submit" class="btn btn-approve">Approve</button>
                            </form>
                            <button type="button" class="btn btn-reject" onclick="showRejectModal(${v.registrationId})">Reject</button>
                        </div>
                    </c:if>
                </div>
            </c:forEach>
        </div>
    </div>
    
    <!-- Reject Modal -->
    <div id="rejectModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h2>Reject Application</h2>
            </div>
            <form method="post" id="rejectForm">
                <input type="hidden" name="registrationId" id="rejectRegistrationId">
                <input type="hidden" name="eventId" value="${eventId}">
                <input type="hidden" name="action" value="reject">
                
                <div class="form-group">
                    <label for="reviewNote">Reason for rejection: <span style="color: red;">*</span></label>
                    <textarea name="reviewNote" id="reviewNote" required placeholder="Please provide a reason for rejecting this application..."></textarea>
                </div>
                
                <div class="modal-actions">
                    <button type="button" class="btn btn-cancel" onclick="closeRejectModal()">Cancel</button>
                    <button type="submit" class="btn btn-reject">Confirm Reject</button>
                </div>
            </form>
        </div>
    </div>
    
    <script>
        function showRejectModal(registrationId) {
            document.getElementById('rejectRegistrationId').value = registrationId;
            document.getElementById('rejectModal').style.display = 'block';
        }
        
        function closeRejectModal() {
            document.getElementById('rejectModal').style.display = 'none';
            document.getElementById('reviewNote').value = '';
        }
        
        window.onclick = function(event) {
            const modal = document.getElementById('rejectModal');
            if (event.target == modal) {
                closeRejectModal();
            }
        }
    </script>
    </style>
</head>
<body>
    <jsp:include page="/components/header.jsp"/>
    
    <div class="container">
        <h1>Manage Volunteers</h1>
        
        <div class="volunteer-list">
            <c:forEach items="${volunteers}" var="v">
                <div class="volunteer-card">
                    <div class="volunteer-info">
                        <h3>${v.fullName != null ? v.fullName : v.email}</h3>
                        <p>Email: ${v.email}</p>
                        <p>Phone: ${v.phone != null ? v.phone : 'N/A'}</p>
                        <p>Gender: ${v.gender != null ? v.gender : 'N/A'}</p>
                        <p>Address: ${v.address != null ? v.address : 'N/A'}</p>
                        <p>Registered: ${v.registeredAt}</p>
                        <span class="status ${v.status.toLowerCase()}">${v.status}</span>
                    </div>
                    
                    <c:if test="${v.status == 'Pending'}">
                        <div class="actions">
                            <form method="post" style="display: inline;">
                                <input type="hidden" name="registrationId" value="${v.registrationId}">
                                <input type="hidden" name="eventId" value="${eventId}">
                                <input type="hidden" name="action" value="approve">
                                <button type="submit" class="btn btn-approve">Approve</button>
                            </form>
                            <button type="button" class="btn btn-reject" onclick="showRejectModal(${v.registrationId})">Reject</button>
                        </div>
                    </c:if>
                </div>
            </c:forEach>
        </div>
    </div>
    
    <jsp:include page="/components/footer.jsp"/>
</body>
</html>
