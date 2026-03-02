<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
            letter-spacing: 0.5px;
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
            transition: 0.2s ease-in-out;
        }

        .approve-btn {
            background: #28a745;
            color: white;
        }

        .approve-btn:hover {
            background: #218838;
        }

        .reject-btn {
            background: #dc3545;
            color: white;
        }

        .reject-btn:hover {
            background: #c82333;
        }

        .back-btn {
            background: #6c757d;
            color: white;
        }

        .back-btn:hover {
            background: #5a6268;
        }

        textarea {
            width: 100%;
            height: 80px;
            margin-top: 10px;
            padding: 10px;
            border-radius: 8px;
            border: 1px solid #ccc;
        }

        #rejectBox {
            margin-top: 15px;
        }

    </style>

    <script>
        function showRejectBox() {
            document.getElementById("rejectBox").style.display = "block";
        }

        function goBack() {
            window.history.back();
        }
    </script>

</head>
<body>

<div class="container">
    <div class="card">

        <div class="header">
            <h2>Support Request Detail</h2>
            <button class="back-btn" onclick="goBack()">← Back</button>
        </div>

        <!-- BASIC INFO -->
        <div class="section">
            <div class="section-title">Basic Information</div>
            <div class="grid">
                <div class="label">Title:</div>
                <div class="value">Emergency Medical Support for Child</div>

                <div class="label">Description:</div>
                <div class="value description-box">
                    A 6-year-old child needs urgent heart surgery but the family cannot afford the medical expenses.
                </div>
            </div>
        </div>

        <!-- SUPPORT DETAILS -->
        <div class="section">
            <div class="section-title">Support Details</div>
            <div class="grid">
                <div class="label">Category:</div>
                <div class="value">MEDICAL</div>

                <div class="label">Priority:</div>
                <div class="value">URGENT</div>

                <div class="label">Location:</div>
                <div class="value">Ho Chi Minh City</div>

                <div class="label">Beneficiary:</div>
                <div class="value">Nguyen Van A</div>

                <div class="label">Affected People:</div>
                <div class="value">1</div>

                <div class="label">Estimated Amount:</div>
                <div class="value">$ 5000</div>
            </div>
        </div>

        <!-- CONTACT INFO -->
        <div class="section">
            <div class="section-title">Contact Information</div>
            <div class="grid">
                <div class="label">Email:</div>
                <div class="value">support@example.com</div>

                <div class="label">Phone:</div>
                <div class="value">0901234567</div>
            </div>
        </div>

        <!-- PROOF -->
        <div class="section">
            <div class="section-title">Proof</div>
            <img src="https://via.placeholder.com/350x220.png?text=Proof+Image"
                 class="proof-img" alt="Proof Image"/>
        </div>

        <!-- SYSTEM INFO -->
        <div class="section">
            <div class="section-title">System Information</div>
            <div class="grid">
                <div class="label">Status:</div>
                <div class="value">
                    <span class="status-badge PENDING">PENDING</span>
                </div>

                <div class="label">Created At:</div>
                <div class="value">2026-03-03 10:30:00</div>

                <div class="label">Created By:</div>
                <div class="value">User ID: 101</div>
            </div>
        </div>

        <!-- ACTIONS -->
        <div class="actions">
            <button class="approve-btn">Approve</button>
            <button class="reject-btn" onclick="showRejectBox()">Reject</button>
        </div>

        <div id="rejectBox" style="display:none;">
            <textarea placeholder="Enter reject reason..."></textarea>
            <div class="actions">
                <button class="reject-btn">Confirm Reject</button>
            </div>
        </div>

    </div>
</div>

</body>
</html>