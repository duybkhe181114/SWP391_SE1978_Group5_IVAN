<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Review Organizations - Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <style>
        body { background: #f8fafc; font-family: 'Inter', sans-serif; }
        .container { max-width: 1400px; margin: 40px auto; padding: 0 20px; }
        h1 { color: #0f172a; margin-bottom: 30px; }
        .alert { padding: 15px; border-radius: 8px; margin-bottom: 20px; }
        .alert-success { background: #dcfce7; color: #166534; }
        .alert-error { background: #fee; color: #e74c3c; }
        .org-card { background: white; border-radius: 12px; padding: 30px; margin-bottom: 20px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
        .org-header { display: flex; justify-content: space-between; align-items: start; margin-bottom: 20px; padding-bottom: 20px; border-bottom: 2px solid #f1f5f9; }
        .org-name { font-size: 24px; font-weight: 700; color: #0f172a; }
        .org-type { display: inline-block; padding: 6px 12px; background: #dbeafe; color: #1e40af; border-radius: 6px; font-size: 14px; font-weight: 600; margin-top: 8px; }
        .info-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin-bottom: 20px; }
        .info-item { }
        .info-label { font-size: 12px; color: #64748b; font-weight: 600; text-transform: uppercase; margin-bottom: 5px; }
        .info-value { font-size: 15px; color: #1e293b; font-weight: 500; }
        .description { background: #f8fafc; padding: 15px; border-radius: 8px; margin-bottom: 20px; }
        .description-label { font-size: 12px; color: #64748b; font-weight: 600; text-transform: uppercase; margin-bottom: 8px; }
        .description-text { color: #475569; line-height: 1.6; }
        .action-form { display: flex; gap: 15px; align-items: end; }
        .form-group { flex: 1; }
        .form-group label { display: block; margin-bottom: 5px; font-size: 13px; font-weight: 600; color: #475569; }
        .form-group textarea { width: 100%; padding: 10px; border: 2px solid #e2e8f0; border-radius: 6px; font-family: inherit; resize: vertical; min-height: 60px; box-sizing: border-box; }
        .btn { padding: 10px 20px; border: none; border-radius: 6px; font-weight: 600; cursor: pointer; transition: all 0.2s; }
        .btn-approve { background: #10b981; color: white; }
        .btn-approve:hover { background: #059669; }
        .btn-reject { background: #ef4444; color: white; }
        .btn-reject:hover { background: #dc2626; }
        .empty-state { text-align: center; padding: 60px 20px; color: #94a3b8; }
    </style>
</head>
<body>
    <jsp:include page="/components/header.jsp"/>
    
    <div class="container">
        <h1>Review Organization Registrations</h1>
        
        <c:if test="${param.success == '1'}">
            <div class="alert alert-success">Organization reviewed successfully!</div>
        </c:if>
        
        <c:if test="${param.error == 'note_required'}">
            <div class="alert alert-error">Review note is required for rejection!</div>
        </c:if>
        
        <c:choose>
            <c:when test="${empty pendingOrganizations}">
                <div class="empty-state">
                    <h2>No pending organizations</h2>
                    <p>All organization registrations have been reviewed.</p>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach items="${pendingOrganizations}" var="org">
                    <div class="org-card">
                        <div class="org-header">
                            <div>
                                <div class="org-name">${org.organizationName}</div>
                                <span class="org-type">${org.organizationType}</span>
                            </div>
                            <div style="text-align: right; color: #64748b; font-size: 14px;">
                                <div>Registered: <fmt:formatDate value="${org.createdAt}" pattern="dd MMM yyyy HH:mm"/></div>
                                <div>Email: ${org.email}</div>
                            </div>
                        </div>
                        
                        <div class="info-grid">
                            <div class="info-item">
                                <div class="info-label">Representative</div>
                                <div class="info-value">${org.representativeName}</div>
                                <div style="font-size: 13px; color: #64748b;">${org.representativePosition}</div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">Established Year</div>
                                <div class="info-value">${org.establishedYear}</div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">Phone</div>
                                <div class="info-value">${org.phone}</div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">Address</div>
                                <div class="info-value">${org.address}</div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">Tax Code</div>
                                <div class="info-value">${org.taxCode != null ? org.taxCode : 'N/A'}</div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">Business License</div>
                                <div class="info-value">${org.businessLicense != null ? org.businessLicense : 'N/A'}</div>
                            </div>
                        </div>
                        
                        <c:if test="${not empty org.website || not empty org.facebookPage}">
                            <div class="info-grid" style="grid-template-columns: repeat(2, 1fr);">
                                <c:if test="${not empty org.website}">
                                    <div class="info-item">
                                        <div class="info-label">Website</div>
                                        <div class="info-value"><a href="${org.website}" target="_blank" style="color: #3b82f6;">${org.website}</a></div>
                                    </div>
                                </c:if>
                                <c:if test="${not empty org.facebookPage}">
                                    <div class="info-item">
                                        <div class="info-label">Facebook Page</div>
                                        <div class="info-value"><a href="${org.facebookPage}" target="_blank" style="color: #3b82f6;">${org.facebookPage}</a></div>
                                    </div>
                                </c:if>
                            </div>
                        </c:if>
                        
                        <div class="description">
                            <div class="description-label">About Organization</div>
                            <div class="description-text">${org.description}</div>
                        </div>
                        
                        <div class="action-form">
                            <form method="post" action="${pageContext.request.contextPath}/admin/review-organizations">
                                <input type="hidden" name="userId" value="${org.userId}">
                                <div class="form-group" style="margin-bottom: 15px;">
                                    <label>Review Note (Optional for approval, Required for rejection)</label>
                                    <textarea name="reviewNote" placeholder="Enter your review note..."></textarea>
                                </div>
                                <div style="display: flex; gap: 10px;">
                                    <button type="submit" name="action" value="approve" class="btn btn-approve" onclick="return confirm('Approve this organization?')">Approve</button>
                                    <button type="submit" name="action" value="reject" class="btn btn-reject" onclick="return confirm('Reject this organization?')">Reject</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
    
    <jsp:include page="/components/footer.jsp"/>
</body>
</html>
