<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Organization Registration - IVAN</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <style>
        body { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); min-height: 100vh; padding: 40px 20px; font-family: 'Inter', sans-serif; }
        .register-container { background: white; padding: 40px; border-radius: 16px; box-shadow: 0 20px 60px rgba(0,0,0,0.3); max-width: 800px; margin: 0 auto; }
        .register-container h1 { text-align: center; color: #333; margin-bottom: 10px; font-size: 28px; }
        .register-container .subtitle { text-align: center; color: #f59e0b; margin-bottom: 30px; font-weight: 600; }
        .section-title { font-size: 18px; font-weight: 700; color: #667eea; margin: 30px 0 15px 0; padding-bottom: 10px; border-bottom: 2px solid #e0e0e0; }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; margin-bottom: 8px; font-weight: 600; color: #555; font-size: 14px; }
        .form-group input, .form-group select, .form-group textarea { width: 100%; padding: 12px; border: 2px solid #e0e0e0; border-radius: 8px; font-size: 14px; transition: border 0.3s; box-sizing: border-box; font-family: inherit; }
        .form-group input:focus, .form-group select:focus, .form-group textarea:focus { outline: none; border-color: #667eea; }
        .form-group textarea { min-height: 100px; resize: vertical; }
        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 15px; }
        .btn-submit { width: 100%; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 14px; border: none; border-radius: 8px; font-size: 16px; font-weight: 600; cursor: pointer; transition: transform 0.3s; margin-top: 20px; }
        .btn-submit:hover { transform: translateY(-2px); }
        .error { background: #fee; color: #e74c3c; padding: 12px; border-radius: 8px; margin-bottom: 20px; text-align: center; font-weight: 500; }
        .login-link { text-align: center; margin-top: 20px; color: #666; }
        .login-link a { color: #667eea; font-weight: 600; text-decoration: none; }
        .info-box { background: #fef9c3; padding: 15px; border-radius: 8px; margin-bottom: 20px; color: #854d0e; font-size: 14px; }
        .review-note { background: #fee2e2; padding: 15px; border-radius: 8px; margin-bottom: 20px; border-left: 4px solid #ef4444; }
        .review-note strong { color: #991b1b; display: block; margin-bottom: 8px; font-size: 16px; }
        .review-note p { color: #7f1d1d; margin: 0; }
    </style>
</head>
<body>
    <div class="register-container">
        <c:choose>
            <c:when test="${resubmit}">
                <h1>Resubmit Organization Registration</h1>
                <p class="subtitle">Your previous submission was rejected. Please review and update.</p>
                
                <div class="review-note">
                    <strong>Admin Review Note:</strong>
                    <p>${profile.reviewNote}</p>
                </div>
            </c:when>
            <c:otherwise>
                <h1>Organization Registration</h1>
                <p class="subtitle">Your account will be pending until admin approval</p>
                
                <div class="info-box">
                    Please provide accurate information. Your registration will be reviewed by our admin team before activation.
                </div>
            </c:otherwise>
        </c:choose>
        
        <% if (request.getAttribute("error") != null) { %>
            <div class="error">${error}</div>
        <% } %>
        
        <form method="post" action="${pageContext.request.contextPath}${resubmit ? '/register/organization/resubmit' : '/register/organization'}">
            <c:if test="${resubmit}">
                <input type="hidden" name="userId" value="${profile.userId}">
            </c:if>
            
            <!-- Section 1: Account Information -->
            <c:if test="${!resubmit}">
            <div class="section-title">1. Account Information</div>
            <div class="form-group">
                <label>Email *</label>
                <input type="email" name="email" required pattern="[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$" placeholder="organization@example.com">
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>Password *</label>
                    <input type="password" name="password" required minlength="6" pattern="(?=.*\d)(?=.*[a-z]).{6,}" title="Password must contain at least 1 letter and 1 number">
                </div>
                <div class="form-group">
                    <label>Confirm Password *</label>
                    <input type="password" name="confirmPassword" required minlength="6" pattern="(?=.*\d)(?=.*[a-z]).{6,}">
                </div>
            </div>
            </c:if>
            
            <!-- Section 2: Organization Information -->
            <div class="section-title">${resubmit ? '1' : '2'}. Organization Information</div>
            <div class="form-group">
                <label>Organization Name *</label>
                <input type="text" name="organizationName" required placeholder="ABC Foundation" value="${profile.organizationName}">
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>Organization Type *</label>
                    <select name="organizationType" required>
                        <option value="">-- Select Type --</option>
                        <option value="NGO" ${profile.organizationType == 'NGO' ? 'selected' : ''}>NGO (Non-Governmental Organization)</option>
                        <option value="Non-profit" ${profile.organizationType == 'Non-profit' ? 'selected' : ''}>Non-profit Organization</option>
                        <option value="Social Enterprise" ${profile.organizationType == 'Social Enterprise' ? 'selected' : ''}>Social Enterprise</option>
                        <option value="Community Group" ${profile.organizationType == 'Community Group' ? 'selected' : ''}>Community Group</option>
                        <option value="Government Agency" ${profile.organizationType == 'Government Agency' ? 'selected' : ''}>Government Agency</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Established Year *</label>
                    <input type="number" name="establishedYear" required min="1900" max="2024" placeholder="2020" title="Year must be between 1900 and 2024" value="${profile.establishedYear}">
                </div>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>Tax Code (Optional)</label>
                    <input type="text" name="taxCode" placeholder="0123456789" value="${profile.taxCode}">
                </div>
                <div class="form-group">
                    <label>Business License Number (Optional)</label>
                    <input type="text" name="businessLicense" placeholder="0123456789" value="${profile.businessLicense}">
                </div>
            </div>
            
            <!-- Section 3: Contact Information -->
            <div class="section-title">${resubmit ? '2' : '3'}. Contact Information</div>
            <div class="form-row">
                <div class="form-group">
                    <label>Phone Number * (10-11 digits)</label>
                    <input type="tel" name="phone" required pattern="[0-9]{10,11}" placeholder="0901234567" title="Phone number must be 10-11 digits" value="${profile.phone}">
                </div>
                <div class="form-group">
                    <label>Website (Optional)</label>
                    <input type="url" name="website" placeholder="https://example.com" value="${profile.website}">
                </div>
            </div>
            <div class="form-group">
                <label>Address *</label>
                <input type="text" name="address" required placeholder="123 Street, District, City" value="${profile.address}">
            </div>
            <div class="form-group">
                <label>Facebook Page (Optional)</label>
                <input type="url" name="facebookPage" placeholder="https://facebook.com/yourpage" value="${profile.facebookPage}">
            </div>
            
            <!-- Section 4: Representative Information -->
            <div class="section-title">${resubmit ? '3' : '4'}. Representative Information</div>
            <div class="form-row">
                <div class="form-group">
                    <label>Representative Name *</label>
                    <input type="text" name="representativeName" required placeholder="John Doe" value="${profile.representativeName}">
                </div>
                <div class="form-group">
                    <label>Position *</label>
                    <input type="text" name="representativePosition" required placeholder="Director" value="${profile.representativePosition}">
                </div>
            </div>
            
            <!-- Section 5: Description -->
            <div class="section-title">${resubmit ? '4' : '5'}. Description</div>
            <div class="form-group">
                <label>About Your Organization *</label>
                <textarea name="description" required placeholder="Tell us about your organization, mission, and activities... (minimum 50 characters)" minlength="50">${profile.description}</textarea>
            </div>
            
            <button type="submit" class="btn-submit">${resubmit ? 'Resubmit Registration' : 'Submit Registration'}</button>
        </form>
        
        <div class="login-link">
            Already have an account? <a href="${pageContext.request.contextPath}/login">Login here</a>
            <br>
            <a href="${pageContext.request.contextPath}/register">← Back to role selection</a>
        </div>
    </div>
</body>
</html>
