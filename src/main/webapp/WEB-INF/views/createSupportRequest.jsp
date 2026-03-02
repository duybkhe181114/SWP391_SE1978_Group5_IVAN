<!DOCTYPE html>
<html>
<head>
    <title>Request Charity Support</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/SupportRequest.css">
</head>
<body>

<div class="container">
    <div class="card">
        <h2>Charity Support Request</h2>
        <p class="subtitle">
            Please provide accurate information so we can review and support your request.
        </p>

        <form action="createSupportRequest" method="post" enctype="multipart/form-data">

            <!-- ===== BASIC INFO ===== -->
            <h3>1. Basic Information</h3>

            <label class="required">Title</label>
            <input type="text" name="title" required
                   placeholder="Short summary of the situation">

            <label class="required">Type of Support</label>
            <select name="supportType" required>
                <option value="">-- Select Support Type --</option>
                <option value="MEDICAL">Medical Support</option>
                <option value="FOOD">Food & Essential Supplies</option>
                <option value="EDUCATION">Education Support</option>
                <option value="DISASTER">Disaster Relief</option>
                <option value="FINANCIAL">Financial Assistance</option>
            </select>

            <label class="required">Urgency Level</label>
            <select name="priority" required>
                <option value="LOW">Low</option>
                <option value="MEDIUM">Medium</option>
                <option value="HIGH">High</option>
                <option value="URGENT">Urgent</option>
            </select>


            <!-- ===== SITUATION DETAILS ===== -->
            <h3>2. Support Details</h3>

            <label class="required">Location</label>
            <input type="text" name="supportLocation" required
                   placeholder="City, district, hospital, village...">

            <label class="required">Beneficiary Name</label>
            <input type="text" name="beneficiaryName" required
                   placeholder="Individual / family / group name">

            <label>Number of People Affected</label>
            <input type="number" name="affectedPeople" min="1">

            <label>Estimated Amount Needed (VND)</label>
            <input type="number" name="estimatedAmount" min="0">

            <label class="required">Detailed Description</label>
            <textarea name="description" required
                      placeholder="Describe the situation clearly..."></textarea>

            <label>Upload Proof Image (Optional)</label>
            <input type="file" name="proofImage">


            <!-- ===== CONTACT ===== -->
            <h3>3. Contact Information</h3>

            <label class="required">Email</label>
            <input type="email" name="contactEmail" required>

            <label>Phone Number</label>
            <input type="text" name="contactPhone">


            <!-- ===== CONFIRM ===== -->
            <div class="confirm">
                <input type="checkbox" required>
                <span>I confirm that all provided information is true.</span>
            </div>

            <button type="submit">Submit Request</button>

        </form>
    </div>
</div>

</body>
</html>