<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Charity Support Requests</title>
    <style>
        body {
            font-family: "Segoe UI", sans-serif;
            background: #f4f6fa;
            padding: 40px;
        }

        .container {
            max-width: 1200px;
            margin: auto;
        }

        h2 {
            margin-bottom: 20px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 5px 20px rgba(0,0,0,0.05);
        }

        th, td {
            padding: 15px;
            text-align: left;
        }

        th {
            background: #2c3e50;
            color: white;
            font-weight: 600;
        }

        tr:nth-child(even) {
            background: #f9fbfd;
        }

        tr:hover {
            background: #eef3f9;
        }

        .badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
        }

        .WAITING { background: #fff3cd; color: #856404; }
        .ACCEPTED { background: #d4edda; color: #155724; }
        .DECLINED { background: #f8d7da; color: #721c24; }

        .view-btn {
            padding: 6px 12px;
            border-radius: 6px;
            background: #007bff;
            color: white;
            border: none;
            cursor: pointer;
        }

        .view-btn:hover {
            background: #0069d9;
        }

    </style>
</head>
<body>

<div class="container">
    <h2>Approved Support Requests</h2>

    <table>
        <tr>
            <th>Title</th>
            <th>Category</th>
            <th>Priority</th>
            <th>Location</th>
            <th>Amount</th>
            <th>Status</th>
            <th>Action</th>
        </tr>

        <tr>
            <td>Emergency Medical Support</td>
            <td>MEDICAL</td>
            <td>URGENT</td>
            <td>Ho Chi Minh City</td>
            <td>$ 5000</td>
            <td><span class="badge WAITING">WAITING</span></td>
            <td><button class="view-btn">View</button></td>
        </tr>
    </table>

</div>

</body>
</html>