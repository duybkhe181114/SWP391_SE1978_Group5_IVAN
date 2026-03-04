<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <title>Organization - Coordinators</title>

    <style>
        /* ===== GIỮ NGUYÊN CSS CỦA BẠN ===== */
        * { box-sizing: border-box; }

        body {
            font-family: "Segoe UI", sans-serif;
            background: linear-gradient(135deg, #eef2ff, #f8fafc);
            padding: 40px;
            margin: 0;
        }

        .container { max-width: 1200px; margin: auto; }

        h2 { margin-bottom: 25px; color: #1e293b; }

        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 8px 30px rgba(0,0,0,0.05);
        }

        th, td { padding: 16px; text-align: left; }

        th {
            background: #1e293b;
            color: white;
            font-weight: 600;
            font-size: 14px;
            letter-spacing: 0.5px;
        }

        tr:nth-child(even) { background: #f8fafc; }
        tr:hover { background: #eef3ff; transition: 0.2s; }

        td:first-child { font-weight: 600; color: #1e293b; }

        .badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
        }

        .ACTIVE { background: #d4edda; color: #155724; }
        .BUSY { background: #fff3cd; color: #856404; }

        .assignment { font-size: 13px; color: #475569; }

        .view-btn {
            padding: 8px 14px;
            border-radius: 6px;
            background: #4f46e5;
            color: white;
            border: none;
            cursor: pointer;
            font-weight: 500;
        }

        .view-btn:hover { background: #4338ca; }

        .modal-overlay {
            position: fixed;
            inset: 0;
            background: rgba(0,0,0,0.4);
            display: none;
            align-items: center;
            justify-content: center;
        }

        .modal {
            background: white;
            padding: 30px;
            border-radius: 12px;
            width: 500px;
            max-width: 90%;
            box-shadow: 0 10px 40px rgba(0,0,0,0.1);
        }

        .close-btn {
            margin-top: 20px;
            padding: 8px 14px;
            border: none;
            background: #ef4444;
            color: white;
            border-radius: 6px;
            cursor: pointer;
        }

        .close-btn:hover { background: #dc2626; }
    </style>
</head>

<body>

<div class="container">
    <h2>Organization - Coordinators</h2>

    <table>
        <tr>
            <th>Name</th>
            <th>Email</th>
            <th>Status</th>
            <th>Current Assignment</th>
            <th>Action</th>
        </tr>

        <!-- ===== DATA DYNAMIC ===== -->
        <c:forEach var="c" items="${coordinators}">
            <tr>
                <td>${c.fullName}</td>
                <td>${c.email}</td>
                <td>
                    <span class="badge ${c.status}">
                        ${c.status}
                    </span>
                </td>
                <td>
                    <div class="assignment">
                        ${empty c.assignment ? 'No current assignment' : c.assignment}
                    </div>
                </td>
                <td>
                    <button class="view-btn"
                        onclick="openModal(
                            '${c.fullName}',
                            '${c.email}',
                            '${c.status}',
                            '${empty c.assignment ? 'No current assignment' : c.assignment}'
                        )">
                        View
                    </button>
                </td>
            </tr>
        </c:forEach>

    </table>
</div>

<!-- Modal -->
<div class="modal-overlay" id="modal">
    <div class="modal">
        <h3>Coordinator Detail</h3>
        <p><strong>Name:</strong> <span id="mName"></span></p>
        <p><strong>Email:</strong> <span id="mEmail"></span></p>
        <p><strong>Status:</strong> <span id="mStatus"></span></p>
        <p><strong>Current Assignment:</strong> <span id="mAssignment"></span></p>
        <button class="close-btn" onclick="closeModal()">Close</button>
    </div>
</div>

<script>
    function openModal(name, email, status, assignment) {
        document.getElementById("mName").innerText = name;
        document.getElementById("mEmail").innerText = email;
        document.getElementById("mStatus").innerText = status;
        document.getElementById("mAssignment").innerText = assignment;
        document.getElementById("modal").style.display = "flex";
    }

    function closeModal() {
        document.getElementById("modal").style.display = "none";
    }
</script>

</body>
</html>