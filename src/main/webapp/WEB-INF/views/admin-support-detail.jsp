<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <title>Support Request Detail</title>

    <style>
        body {
            font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
            background: #f1f4f9;
            margin: 0;
            padding: 40px;
        }

        .container {
            max-width: 1100px;
            margin: auto;
        }

        .card {
            background: #ffffff;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.05);
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }

        h2 {
            margin: 0;
            font-size: 24px;
            color: #2c3e50;
        }

        .section {
            margin-bottom: 35px;
        }

        .section-title {
            font-size: 16px;
            font-weight: 600;
            margin-bottom: 15px;
            color: #34495e;
            text-transform: uppercase;
        }

        .grid {
            display: grid;
            grid-template-columns: 200px 1fr;
            row-gap: 12px;
            column-gap: 20px;
        }

        .label {
            font-weight: 600;
            color: #555;
        }

        .value {
            color: #333;
        }

        .description-box {
            background: #f8f9fb;
            padding: 15px;
            border-radius: 8px;
            border: 1px solid #eee;
        }

        .proof-img {
            max-width: 350px;
            border-radius: 10px;
            margin-top: 10px;
            border: 1px solid #ddd;
        }

        .status-badge {
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
            display: inline-block;
        }

        .PENDING { background: #fff3cd; color: #856404; }
        .APPROVED { background: #d4edda; color: #155724; }
        .REJECTED { background: #f8d7da; color: #721c24; }
        .ACCEPTED { background: #cce5ff; color: #004085; }

        .actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 30px;
        }

        button {
            padding: 10px 18px;
            border-radius: 8px;
            border: none;
            font-weight: 600;
            cursor: pointer;
            font-size: 14px;
            transition: opacity 0.2s;
        }

        button:hover {
            opacity: 0.85;
        }

        .approve-btn { background: #28a745; color: white; }
        .reject-btn { background: #dc3545; color: white; }
        .accept-btn { background: #007bff; color: white; }
        .back-btn { background: #6c757d; color: white; }

        textarea {
            width: 100%;
            height: 80px;
            margin-top: 10px;
            padding: 10px;
            border-radius: 8px;
            border: 1px solid #ccc;
        }
    </style>

    <script>
        function showRejectBox() {
            document.getElementById("rejectBox").style.display = "block";
        }
    </script>
</head>
<body>

<div class="container">
    <div class="card">

        <div class="header">
            <h2>Support Request Detail</h2>

            <a href="${pageContext.request.contextPath}/viewSpRequestAdmin">
                <button type="button" class="back-btn">← Back</button>
            </a>
        </div>

        <!-- BASIC INFO -->
        <div class="section">
            <div class="section-title">Basic Information</div>
            <div class="grid">
                <div class="label">Title:</div>
                <div class="value">${requestDetail.title}</div>

                <div class="label">Description:</div>
                <div class="value description-box">
                    ${requestDetail.description}
                </div>
            </div>
        </div>

        <!-- SUPPORT DETAILS -->
        <div class="section">
            <div class="section-title">Support Details</div>
            <div class="grid">
                <div class="label">Category:</div>
                <div class="value">${requestDetail.categoryName}</div>

                <div class="label">Priority:</div>
                <div class="value">${requestDetail.priority}</div>

                <div class="label">Location:</div>
                <div class="value">${requestDetail.supportLocation}</div>

                <div class="label">Beneficiary:</div>
                <div class="value">${requestDetail.beneficiaryName}</div>

                <div class="label">Affected People:</div>
                <div class="value">${requestDetail.affectedPeople}</div>

                <div class="label">Estimated Amount:</div>
                <div class="value">$ ${requestDetail.estimatedAmount}</div>
            </div>
        </div>

<div class="section-title">Contact Information</div>
<div class="grid">

    <div class="label">Email:</div>
    <div class="value">
        ${requestDetail.contactEmail}
    </div>

    <div class="label">Phone:</div>
    <div class="value">
        ${requestDetail.contactPhone}
    </div>

</div>

<img src="${requestDetail.proofImageUrl}"
     class="proof-img"
     alt="Proof Image"/>

        <!-- SYSTEM INFO -->
        <div class="section">
            <div class="section-title">System Information</div>
            <div class="grid">
                <div class="label">Status:</div>
                <div class="value">
                    <span class="status-badge ${requestDetail.status}">
                        ${requestDetail.status}
                    </span>
                </div>

                <div class="label">Created At:</div>
                <div class="value">${requestDetail.createdAt}</div>

                <div class="label">Created By:</div>
                <div class="value">User ID: ${requestDetail.createdBy}</div>
            </div>
        </div>

        <%-- ===== ADMIN: Approve / Reject (chỉ khi PENDING) ===== --%>
        <c:if test="${userRole == 'ADMIN' && requestDetail.status == 'PENDING'}">
            <div class="actions">

                <!-- APPROVE -->
                <form action="${pageContext.request.contextPath}/updateSupportRequestStatus"
                      method="post">
                    <input type="hidden" name="requestId"
                           value="${requestDetail.requestId}"/>
                    <input type="hidden" name="status" value="APPROVED"/>
                    <button type="submit" class="approve-btn">
                        ✅ Approve
                    </button>
                </form>

                <!-- REJECT -->
                <button type="button"
                        class="reject-btn"
                        onclick="showRejectBox()">
                    ❌ Reject
                </button>
            </div>

            <!-- REJECT BOX -->
            <div id="rejectBox" style="display:none;">
                <form action="${pageContext.request.contextPath}/updateSupportRequestStatus"
                      method="post">

                    <input type="hidden" name="requestId"
                           value="${requestDetail.requestId}"/>
                    <input type="hidden" name="status" value="REJECTED"/>

                    <textarea name="rejectReason"
                              placeholder="Enter reject reason..."
                              required></textarea>

                    <div class="actions">
                        <button type="submit" class="reject-btn">
                            Confirm Reject
                        </button>
                    </div>
                </form>
            </div>
        </c:if>

        <%-- ===== ORGANIZATION: Accept (chỉ khi APPROVED) ===== --%>
        <c:if test="${userRole == 'Organization' && requestDetail.status == 'APPROVED'}">
            <div class="actions">
                <form action="${pageContext.request.contextPath}/updateSupportRequestStatus"
                      method="post">
                    <input type="hidden" name="requestId"
                           value="${requestDetail.requestId}"/>
                    <input type="hidden" name="status" value="ACCEPTED"/>
                    <button type="submit" class="accept-btn">
                        📋 Accept
                    </button>
                </form>
            </div>
        </c:if>

    </div>
</div>

</body>
</html>