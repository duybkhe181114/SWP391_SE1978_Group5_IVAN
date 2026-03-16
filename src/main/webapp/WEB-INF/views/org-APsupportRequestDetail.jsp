<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Charity - Support Request Detail</title>

    <style>
        body {
            font-family: "Segoe UI", sans-serif;
            background: #f4f6fa;
            padding: 40px;
            margin: 0;
        }

        .container {
            max-width: 1100px;
            margin: auto;
        }

        .card {
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 6px 25px rgba(0,0,0,0.05);
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }

        h2 {
            margin: 0;
            font-size: 22px;
            color: #2c3e50;
        }

        .back-btn {
            padding: 8px 15px;
            background: #6c757d;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
        }

        .back-btn:hover {
            background: #5a6268;
        }

        .section {
            margin-bottom: 30px;
        }

        .section-title {
            font-weight: 600;
            margin-bottom: 15px;
            color: #34495e;
            text-transform: uppercase;
            font-size: 14px;
            letter-spacing: 0.5px;
        }

        .grid {
            display: grid;
            grid-template-columns: 200px 1fr;
            gap: 10px 20px;
        }

        .label {
            font-weight: 600;
            color: #555;
        }

        .value {
            color: #333;
        }

        .description-box {
            background: #f8f9fc;
            padding: 15px;
            border-radius: 8px;
            border: 1px solid #eee;
        }

        .proof-img {
            max-width: 350px;
            border-radius: 10px;
            border: 1px solid #ddd;
            margin-top: 10px;
        }

        .badge-approved {
            background: #d4edda;
            color: #155724;
            padding: 6px 14px;
            border-radius: 20px;
            font-weight: 600;
            font-size: 13px;
            display: inline-block;
        }

        .action-box {
            background: #f8f9fc;
            padding: 20px;
            border-radius: 10px;
            border: 1px solid #e3e6ea;
            margin-top: 20px;
        }

        input, textarea {
            width: 100%;
            padding: 10px;
            border-radius: 8px;
            border: 1px solid #ccc;
            margin-top: 5px;
            margin-bottom: 15px;
        }

        .actions {
            display: flex;
            gap: 10px;
            justify-content: flex-end;
        }

        button {
            padding: 10px 18px;
            border-radius: 8px;
            border: none;
            font-weight: 600;
            cursor: pointer;
            transition: 0.2s;
        }

        .accept-btn {
            background: #28a745;
            color: white;
        }

        .accept-btn:hover {
            background: #218838;
        }

        .decline-btn {
            background: #dc3545;
            color: white;
        }

        .decline-btn:hover {
            background: #c82333;
        }

    </style>

    <script>
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

        <!-- REQUEST INFO -->
        <div class="section">
            <div class="section-title">Request Information</div>
            <div class="grid">
                <div class="label">Title:</div>
                <div class="value">Emergency Medical Support for Child</div>

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

                <div class="label">Status:</div>
                <div class="value">
                    <span class="badge-approved">APPROVED BY ADMIN</span>
                </div>
            </div>
        </div>

        <!-- DESCRIPTION -->
        <div class="section">
            <div class="section-title">Description</div>
            <div class="description-box">
                A 6-year-old child needs urgent heart surgery but the family cannot afford the medical expenses.
            </div>
        </div>

        <!-- CONTACT -->
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

        <!-- CHARITY ACTION -->
        <div class="section">
            <div class="section-title">Charity Decision</div>

            <div class="action-box">

                <label>Funding Amount</label>
                <input type="number" placeholder="Enter amount you will support">

                <label>Note</label>
                <textarea placeholder="Internal note (optional)"></textarea>

                <div class="actions">
                    <button class="decline-btn">Decline</button>
                    <button class="accept-btn">Accept & Fund</button>
                </div>

            </div>
        </div>

    </div>
</div>

</body>
</html>