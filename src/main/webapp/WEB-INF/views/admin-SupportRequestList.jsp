<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Support Requests</title>

<style>
body {
    margin: 0;
    font-family: Arial, sans-serif;
    background: #f4f6f9;
}

.container {
    padding: 40px 60px;
}

h2 {
    margin-bottom: 25px;
}

table {
    width: 100%;
    border-collapse: collapse;
    background: #fff;
    border-radius: 10px;
    overflow: hidden;
    box-shadow: 0 6px 18px rgba(0,0,0,0.06);
}

thead {
    background: #2563eb;
    color: white;
}

th, td {
    padding: 12px 14px;
    text-align: left;
    font-size: 14px;
}

th {
    font-weight: 600;
}

tbody tr {
    border-bottom: 1px solid #eee;
    transition: 0.2s;
}

tbody tr:hover {
    background: #f1f5f9;
}

/* STATUS */
.status {
    padding: 4px 10px;
    border-radius: 20px;
    font-size: 12px;
    font-weight: 600;
}

.pending { background: #fff4e5; color: #ff9800; }
.approved { background: #e8f5e9; color: #2e7d32; }
.rejected { background: #fdecea; color: #c62828; }
.completed { background: #e3f2fd; color: #1565c0; }

/* PRIORITY */
.priority {
    font-weight: 600;
}

.low { color: #0284c7; }
.medium { color: #ca8a04; }
.high { color: #dc2626; }
.urgent { color: #7f1d1d; }

/* BUTTON */
.detail-btn {
    padding: 6px 12px;
    background: #2563eb;
    color: white;
    text-decoration: none;
    border-radius: 6px;
    font-size: 13px;
    font-weight: 600;
}

.detail-btn:hover {
    background: #1e40af;
}
</style>
</head>

<body>

<div class="container">
    <h2>Support Requests</h2>

    <c:if test="${empty requestList}">
        <p>No support requests found.</p>
    </c:if>

    <c:if test="${not empty requestList}">
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Title</th>
                    <th>Category</th>
                    <th>Priority</th>
                    <th>Status</th>
                    <th>Location</th>
                    <th>Estimated</th>
                    <th>Created At</th>
                    <th>Action</th>
                </tr>
            </thead>

            <tbody>
                <c:forEach var="r" items="${requestList}">
                    <tr>
                        <td>${r.requestId}</td>
                        <td>${r.title}</td>
                        <td>${r.categoryName}</td>

                        <!-- PRIORITY -->
                        <td class="priority ${r.priority.toLowerCase()}">
                            ${r.priority}
                        </td>

                        <!-- STATUS -->
                        <td>
                            <span class="status ${r.status.toLowerCase()}">
                                ${r.status}
                            </span>
                        </td>

                        <td>${r.supportLocation}</td>
                        <td>$${r.estimatedAmount}</td>
                        <td>${r.createdAt}</td>

                        <td>
                            <a class="detail-btn"
                               href="${pageContext.request.contextPath}/adminSpRequestDetail?id=${r.requestId}">
                                Detail
                            </a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </c:if>

</div>

</body>
</html>