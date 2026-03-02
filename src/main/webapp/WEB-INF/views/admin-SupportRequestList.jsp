<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<section class="page-section">
    <h2 class="section-title">All Support Requests</h2>

    <!-- Nếu danh sách rỗng -->
    <c:if test="${empty requestList}">
        <p>No support requests found.</p>
    </c:if>

    <!-- Nếu có dữ liệu -->
    <c:if test="${not empty requestList}">
        <div class="request-grid">

            <c:forEach var="r" items="${requestList}">

                <div class="request-card">

                    <!-- Title -->
                    <h3>${r.title}</h3>

                    <!-- Basic Info -->
                    <div class="request-meta">
                        <strong>Beneficiary:</strong> ${r.beneficiaryName}
                    </div>

                    <div class="request-meta">
                        <strong>Location:</strong> ${r.supportLocation}
                    </div>

                    <div class="request-meta">
                        <strong>Category:</strong> ${r.categoryId}
                    </div>

                    <div class="request-meta">
                        <strong>Priority:</strong> ${r.priority}
                    </div>

                    <div class="request-meta">
                        <strong>Affected:</strong> ${r.affectedPeople}
                    </div>

                    <div class="request-meta">
                        <strong>Estimated:</strong> ${r.estimatedAmount}
                    </div>

                    <div class="request-meta">
                        <strong>Created:</strong> ${r.createdAt}
                    </div>

                    <!-- Status -->
                    <c:choose>
                        <c:when test="${r.status == 'PENDING'}">
                            <span class="status status-pending">
                                ${r.status}
                            </span>
                        </c:when>

                        <c:when test="${r.status == 'APPROVED'}">
                            <span class="status status-approved">
                                ${r.status}
                            </span>
                        </c:when>

                        <c:otherwise>
                            <span class="status status-rejected">
                                ${r.status}
                            </span>
                        </c:otherwise>
                    </c:choose>

                    <br/><br/>

                    <!-- Detail Button -->
                    <a class="view-btn"
                       href="${pageContext.request.contextPath}/request-detail?id=${r.requestId}">
                        View Detail
                    </a>

                </div>

            </c:forEach>

        </div>
    </c:if>
</section>