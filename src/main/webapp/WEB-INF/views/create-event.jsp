<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Create Event</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <style>
        body {
            background: linear-gradient(180deg, #eef2ff 0%, #f8fafc 26%, #ffffff 100%);
        }

        .create-shell {
            max-width: 1180px;
            margin: 0 auto;
            padding: 42px 18px 56px;
        }

        .hero {
            padding: 30px;
            border-radius: 28px;
            background: linear-gradient(135deg, #0f172a 0%, #1e293b 55%, #334155 100%);
            color: #f8fafc;
            box-shadow: 0 24px 60px rgba(15, 23, 42, 0.14);
        }

        .hero h1 {
            margin: 12px 0 10px;
            font-size: clamp(32px, 4vw, 44px);
            line-height: 1.04;
        }

        .hero p {
            max-width: 760px;
            margin: 0;
            color: rgba(248, 250, 252, 0.8);
            line-height: 1.7;
        }

        .hero-chip {
            display: inline-flex;
            padding: 8px 14px;
            border-radius: 999px;
            background: rgba(255, 255, 255, 0.12);
            color: #fde68a;
            font-size: 12px;
            font-weight: 700;
            letter-spacing: 0.08em;
            text-transform: uppercase;
        }

        .form-card {
            margin-top: 24px;
            padding: 28px;
            border-radius: 28px;
            background: #ffffff;
            border: 1px solid #e2e8f0;
            box-shadow: 0 18px 40px rgba(15, 23, 42, 0.06);
        }

        .form-header h2 {
            margin: 0;
            color: #0f172a;
            font-size: 28px;
        }

        .form-header p {
            margin: 10px 0 0;
            color: #64748b;
            line-height: 1.7;
        }

        .alert {
            margin-top: 18px;
            padding: 14px 16px;
            border-radius: 14px;
            font-size: 14px;
            line-height: 1.6;
        }

        .alert-error {
            background: #fef2f2;
            color: #b91c1c;
            border: 1px solid #fecaca;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 18px;
            margin-top: 24px;
        }

        .form-group {
            display: grid;
            gap: 8px;
        }

        .form-group.span-2 {
            grid-column: 1 / -1;
        }

        .form-group label {
            color: #334155;
            font-size: 13px;
            font-weight: 700;
            letter-spacing: 0.02em;
        }

        .form-group label span {
            color: #ef4444;
        }

        .form-group input,
        .form-group textarea {
            width: 100%;
            box-sizing: border-box;
            padding: 13px 14px;
            border-radius: 14px;
            border: 1px solid #cbd5e1;
            background: #fff;
            color: #0f172a;
            font: inherit;
            transition: border-color 0.2s ease, box-shadow 0.2s ease;
        }

        .form-group input:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #6366f1;
            box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.12);
        }

        .form-group textarea {
            min-height: 120px;
            resize: vertical;
        }

        .hint {
            color: #94a3b8;
            font-size: 12px;
            line-height: 1.5;
        }

        .section-title {
            margin-top: 10px;
            padding-top: 18px;
            border-top: 1px solid #e2e8f0;
            color: #0f172a;
            font-size: 18px;
            font-weight: 800;
        }

        .section-title.span-2 {
            grid-column: 1 / -1;
        }

        .form-actions {
            display: flex;
            gap: 12px;
            justify-content: flex-end;
            margin-top: 26px;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 13px 20px;
            border-radius: 14px;
            border: 1px solid transparent;
            text-decoration: none;
            font-weight: 700;
            cursor: pointer;
            transition: transform 0.2s ease;
        }

        .btn:hover {
            transform: translateY(-1px);
        }

        .btn-primary {
            background: #111827;
            color: #f8fafc;
        }

        .btn-secondary {
            background: #f8fafc;
            color: #475569;
            border-color: #cbd5e1;
        }

        @media (max-width: 860px) {
            .create-shell {
                padding: 28px 14px 44px;
            }

            .form-grid {
                grid-template-columns: 1fr;
            }

            .form-group.span-2 {
                grid-column: auto;
            }

            .form-actions {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>
<jsp:include page="/components/header.jsp"/>

<div class="create-shell">
    <section class="hero">
        <span class="hero-chip">Organization Workflow</span>
        <h1>Create A New Event</h1>
        <p>Submit a complete event brief for admin review. We capture the essentials volunteers actually need to decide whether they can join, including contact details, participation requirements, and what support the event provides.</p>
    </section>

    <section class="form-card">
        <div class="form-header">

        <%-- Banner support request nếu đến từ accepted-requests --%>
        <c:if test="${not empty linkedSpr}">
            <div style="background:#eff6ff;border:1.5px solid #bfdbfe;border-radius:12px;padding:16px 20px;margin-bottom:20px;font-size:14px;color:#1e40af;">
                <div style="font-weight:700;margin-bottom:8px;">📋 Creating event for Support Request #${linkedSpr.requestId}</div>
                <div style="display:grid;grid-template-columns:1fr 1fr;gap:8px;font-size:13px;">
                    <div><span style="color:#64748b;">Title:</span> <strong>${linkedSpr.title}</strong></div>
                    <div><span style="color:#64748b;">Priority:</span> <strong>${linkedSpr.priority}</strong></div>
                    <div><span style="color:#64748b;">Location:</span> ${not empty linkedSpr.supportLocation ? linkedSpr.supportLocation : '—'}</div>
                    <div><span style="color:#64748b;">Beneficiary:</span> ${not empty linkedSpr.beneficiaryName ? linkedSpr.beneficiaryName : '—'}</div>
                    <div><span style="color:#64748b;">Affected:</span> ${linkedSpr.affectedPeople} people</div>
                    <div><span style="color:#64748b;">Contact:</span> ${not empty linkedSpr.contactEmail ? linkedSpr.contactEmail : '—'}</div>
                </div>
            </div>
            <input type="hidden" name="supportRequestId" value="${linkedSpr.requestId}">
        </c:if>
            <h2>Event Submission Form</h2>
            <p>Fields marked with an asterisk are required. Rejected events can be updated and resubmitted later from the event management screen.</p>
        </div>

        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-error">${error}</div>
        <% } %>

        <form method="post" action="${pageContext.request.contextPath}/organization/create-event">
            <div class="form-grid">
                <div class="form-group span-2">
                    <label>Event Title <span>*</span></label>
                    <input type="text" name="title" required value="${param.title}" placeholder="Example: Community Health Day">
                </div>

                <div class="form-group span-2">
                    <label>Description <span>*</span></label>
                    <textarea name="description" required placeholder="Summarize the event purpose, what will happen on-site, and what kind of support is needed.">${param.description}</textarea>
                </div>

                <div class="form-group span-2">
                    <label>Location <span>*</span></label>
                    <input type="text" name="location" required value="${param.location}" placeholder="Full address or check-in location">
                </div>

                <div class="form-group span-2">
                    <label>Cover Image URL</label>
                    <input type="url" name="coverImageUrl" value="${param.coverImageUrl}" placeholder="https://example.com/event-cover.jpg">
                    <div class="hint">Paste a public image URL used in cards and event detail pages.</div>
                </div>

                <div class="form-group">
                    <label>Start Date <span>*</span></label>
                    <input type="date" id="startDate" name="startDate" required value="${param.startDate}">
                </div>

                <div class="form-group">
                    <label>End Date <span>*</span></label>
                    <input type="date" id="endDate" name="endDate" required value="${param.endDate}">
                    <div class="hint">End date must be the same as or later than the start date.</div>
                </div>

                <div class="form-group">
                    <label>Volunteer Limit <span>*</span></label>
                    <input type="number" name="requiredVolunteers" min="0" required value="${empty param.requiredVolunteers ? 1 : param.requiredVolunteers}">
                    <div class="hint">Use `0` if the event can accept volunteers without a fixed cap.</div>
                </div>

                <div class="form-group">
                    <label>Primary Contact Name</label>
                    <input type="text" name="contactName" value="${param.contactName}" placeholder="Coordinator or organization representative">
                </div>

                <div class="section-title span-2">Volunteer Preparation</div>

                <div class="form-group">
                    <label>Contact Email</label>
                    <input type="email" name="contactEmail" value="${param.contactEmail}" placeholder="event-contact@organization.org">
                </div>

                <div class="form-group">
                    <label>Contact Phone</label>
                    <input type="text" name="contactPhone" value="${param.contactPhone}" placeholder="Phone number for urgent coordination">
                </div>

                <div class="form-group span-2">
                    <label>Volunteer Requirements</label>
                    <textarea name="requirements" placeholder="Describe skills, physical requirements, schedule expectations, dress code, or who this event is best suited for.">${param.requirements}</textarea>
                </div>

                <div class="form-group span-2">
                    <label>What Volunteers Receive</label>
                    <textarea name="benefits" placeholder="Examples: briefing, on-site support, meals, transport allowance, certificate, or mentorship.">${param.benefits}</textarea>
                </div>
            </div>

            <div class="form-actions">
                <a href="${pageContext.request.contextPath}/organization/dashboard" class="btn btn-secondary">Back To Dashboard</a>
                <button type="submit" class="btn btn-primary">Submit Event For Review</button>
            </div>
        </form>
    </section>
</div>

<script>
const startDateInput = document.getElementById("startDate");
const endDateInput = document.getElementById("endDate");

function syncEndDateMin() {
    if (!startDateInput || !endDateInput) {
        return;
    }
    endDateInput.min = startDateInput.value || "";
}

if (startDateInput && endDateInput) {
    startDateInput.addEventListener("change", syncEndDateMin);
    syncEndDateMin();
}
</script>

<jsp:include page="/components/footer.jsp"/>
</body>
</html>
