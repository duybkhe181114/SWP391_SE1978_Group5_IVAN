<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Support Requests Demo</title>

<style>
body {
    margin: 0;
    font-family: Arial, sans-serif;
    background: #f8fafc;
}

.page-section {
    padding: 40px 60px;
}

.section-title {
    font-size: 28px;
    font-weight: 700;
    margin-bottom: 30px;
}

.request-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
    gap: 25px;
}

.request-card {
    background: #fff;
    border-radius: 14px;
    padding: 22px;
    box-shadow: 0 8px 20px rgba(0,0,0,0.05);
    transition: 0.3s ease;
    display: flex;
    flex-direction: column;
}

.request-card:hover {
    transform: translateY(-6px);
}
.request-card {
    position: relative;
}
.request-card h3 {
    font-size: 20px;
    margin-bottom: 15px;
}

.request-meta {
    font-size: 14px;
    margin-bottom: 6px;
    color: #555;
}

.status {
    display: inline-block;
    padding: 6px 14px;
    border-radius: 20px;
    font-size: 12px;
    font-weight: 600;
    margin-top: 10px;
}

.status-pending {
    background: #fff4e5;
    color: #ff9800;
}

.status-approved {
    background: #e8f5e9;
    color: #4caf50;
}

.status-rejected {
    background: #fdecea;
    color: #f44336;
}

.view-btn {
    margin-top: auto;
    text-align: center;
    padding: 10px;
    border-radius: 8px;
    background: #2563eb;
    color: #fff;
    text-decoration: none;
    font-weight: 600;
    transition: 0.2s;
}

.view-btn:hover {
    background: #1e40af;
}
.status-low {
    background: #e0f2fe;
    color: #0284c7;
}

.status-medium {
    background: #fef9c3;
    color: #ca8a04;
}

.status-high {
    background: #fee2e2;
    color: #dc2626;
}

.status-urgent {
    background: #7f1d1d;
    color: white;
}
.status-badge {
    position: absolute;
    top: 15px;
    right: 15px;
    padding: 6px 12px;
    border-radius: 20px;
    font-size: 11px;
    font-weight: 700;
    letter-spacing: 0.5px;
}

.status-pending {
    background: #fff4e5;
    color: #ff9800;
}

.status-approved {
    background: #e8f5e9;
    color: #2e7d32;
}

.status-rejected {
    background: #fdecea;
    color: #c62828;
}

.status-completed {
    background: #e3f2fd;
    color: #1565c0;
}
</style>
</head>
<body>

<section class="page-section">
    <h2 class="section-title">Support Requests</h2>

    <div class="request-grid">

<c:if test="${empty requestList}">
    <p>No pending support requests.</p>
</c:if>

<c:if test="${not empty requestList}">
    <div class="request-grid">

        <c:forEach var="r" items="${requestList}">
            <div class="request-card">
<c:choose>
    <c:when test="${r.status == 'PENDING'}">
        <span class="status-badge status-pending">
            PENDING
        </span>
    </c:when>

    <c:when test="${r.status == 'APPROVED'}">
        <span class="status-badge status-approved">
            APPROVED
        </span>
    </c:when>

    <c:when test="${r.status == 'REJECTED'}">
        <span class="status-badge status-rejected">
            REJECTED
        </span>
    </c:when>

    <c:otherwise>
        <span class="status-badge status-completed">
            COMPLETED
        </span>
    </c:otherwise>
</c:choose>
                <!-- Title -->
                <h3>${r.title}</h3>

                <!-- Priority badge -->
                <div class="request-meta">
                    <strong>Priority:</strong>
                    <span class="status status-${r.priority.toLowerCase()}">
                        ${r.priority}
                    </span>
                </div>

                <!-- Category -->
                <div class="request-meta">
                    <strong>Category:</strong> ${r.categoryId}
                </div>

                <!-- Beneficiary -->
                <div class="request-meta">
                    <strong>Beneficiary:</strong> ${r.beneficiaryName}
                </div>

                <!-- Location -->
                <div class="request-meta">
                    <strong>Location:</strong> ${r.supportLocation}
                </div>

                <!-- Impact -->
                <div class="request-meta">
                    <strong>Affected People:</strong> ${r.affectedPeople}
                </div>

                <!-- Estimated -->
                <div class="request-meta">
                    <strong>Estimated Amount:</strong> $${r.estimatedAmount}
                </div>

                <!-- Created info -->
                <div class="request-meta">
                    <strong>Created By:</strong> ${r.createdBy}
                </div>

                <div class="request-meta">
                    <strong>Created At:</strong> ${r.createdAt}
                </div>

                <br/>

                <a class="view-btn"
                   href="${pageContext.request.contextPath}/request-detail?id=${r.requestId}">
                     Detail
                </a>

            </div>
        </c:forEach>

    </div>
</c:if>

    </div>
</section>

</body>
</html>