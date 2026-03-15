<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<jsp:include page="/components/header.jsp"/>

<div class="admin-page">
  <div class="admin-container">

    <h2 class="section-title">
      <span style="color: #667eea;">&#9679;</span> Manage Users
    </h2>

    <c:if test="${param.success == 'blocked'}">
      <div class="success-message" style="margin-bottom: 20px;">User was blocked successfully.</div>
    </c:if>
    <c:if test="${param.success == 'unblocked'}">
      <div class="success-message" style="margin-bottom: 20px;">User access was restored successfully.</div>
    </c:if>
    <c:if test="${param.success == 'updated'}">
      <div class="success-message" style="margin-bottom: 20px;">User information updated successfully.</div>
    </c:if>

    <c:if test="${param.error == 'self_block'}">
      <div class="error-box">You cannot block the admin account currently in use.</div>
    </c:if>
    <c:if test="${param.error == 'user_not_found'}">
      <div class="error-box">The selected user could not be found.</div>
    </c:if>
    <c:if test="${param.error == 'org_review_flow'}">
      <div class="error-box">Pending or rejected organization accounts must be handled in Manage Organizations, not from this screen.</div>
    </c:if>
    <c:if test="${param.error == 'last_admin'}">
      <div class="error-box">You cannot block the last active admin account.</div>
    </c:if>
    <c:if test="${param.error == 'status_update_failed'}">
      <div class="error-box">Could not change user status. Please try again.</div>
    </c:if>

    <div class="filter-bar">
      <form method="get" action="${pageContext.request.contextPath}/admin/manage-users" class="filter-form">

        <div class="filter-group">
          <label>Search</label>
          <input type="text" name="q" placeholder="Name / Email / Phone..." value="${param.q}">
        </div>

        <div class="filter-group">
          <label>Role</label>
          <select name="role">
            <option value="">All</option>
            <option value="Admin" ${param.role=='Admin'?'selected':''}>Admin</option>
            <option value="Organization" ${param.role=='Organization'?'selected':''}>Organization</option>
            <option value="Coordinator" ${param.role=='Coordinator'?'selected':''}>Coordinator</option>
            <option value="Volunteer" ${param.role=='Volunteer'?'selected':''}>Volunteer</option>
            <option value="SupportRequester" ${param.role=='SupportRequester'?'selected':''}>Support Requester</option>
          </select>
        </div>

        <div class="filter-group">
          <label>Status</label>
          <select name="status">
            <option value="">All</option>
            <option value="active" ${param.status=='active'?'selected':''}>Active</option>
            <option value="blocked" ${(param.status=='blocked' || param.status=='inactive')?'selected':''}>Blocked</option>
            <option value="review" ${param.status=='review'?'selected':''}>Needs Review</option>
          </select>
        </div>

        <div class="filter-group">
          <label>From</label>
          <input type="date" name="fromDate" value="${param.fromDate}">
        </div>

        <div class="filter-group">
          <label>To</label>
          <input type="date" name="toDate" value="${param.toDate}">
        </div>

        <div class="filter-actions">
          <button class="btn-primary" type="submit">Apply</button>
          <a href="${pageContext.request.contextPath}/admin/manage-users" class="btn-clear">Clear</a>
        </div>
      </form>
    </div>

    <div class="admin-table-wrapper">
      <table class="table admin-table">
        <thead>
        <tr>
          <th style="width: 50px;">#</th>
          <th>User Information</th>
          <th>Role</th>
          <th>Location</th>
          <th>Status</th>
          <th>Created At</th>
          <th style="width: 190px;">Action</th>
        </tr>
        </thead>

        <tbody>
        <c:choose>
          <c:when test="${empty users}">
            <tr>
              <td colspan="7">
                <div class="empty-state">No users matched the current filters.</div>
              </td>
            </tr>
          </c:when>
          <c:otherwise>
            <c:forEach items="${users}" var="u" varStatus="loop">
              <tr>
                <td>
                  <span style="color: #94a3b8;">${loop.index + 1}</span>
                </td>

                <td>
                  <div class="user-email">${u.email}</div>
                  <div style="font-size: 13px; color: #64748b;">
                    ${not empty u.fullName ? u.fullName : 'No Name'}
                  </div>
                </td>

                <td>
                  <span class="badge role-${u.role}">${u.role}</span>
                </td>

                <td>
                  <div style="font-size: 14px;">${u.province != null ? u.province : 'N/A'}</div>
                  <div style="font-size: 12px; color: #94a3b8;">${u.phone}</div>
                </td>

                <td>
                  <c:choose>
                    <c:when test="${u.role == 'Organization' and not empty u.approvalStatus and u.approvalStatus == 'Pending'}">
                      <span class="badge badge-pending-org">Pending Approval</span>
                    </c:when>
                    <c:when test="${u.role == 'Organization' and not empty u.approvalStatus and u.approvalStatus == 'Rejected'}">
                      <span class="badge badge-rejected-org">Rejected</span>
                    </c:when>
                    <c:when test="${u.active}">
                      <span class="badge badge-active">&#9679; Active</span>
                    </c:when>
                    <c:otherwise>
                      <span class="badge badge-inactive">&#9679; Blocked</span>
                    </c:otherwise>
                  </c:choose>
                </td>

                <td style="color: #64748b; font-size: 14px;">
                  <fmt:formatDate value="${u.createdAt}" pattern="dd MMM, yyyy"/>
                </td>

                <td>
                  <div style="display:flex; gap:8px; flex-wrap: wrap;">
                    <button type="button"
                            class="btn-action info"
                            data-user-id="${u.userId}"
                            data-email="${fn:escapeXml(u.email)}"
                            data-first-name="${fn:escapeXml(u.firstName)}"
                            data-last-name="${fn:escapeXml(u.lastName)}"
                            data-phone="${fn:escapeXml(u.phone)}"
                            data-province="${fn:escapeXml(u.province)}"
                            data-address="${fn:escapeXml(u.address)}"
                            data-role="${fn:escapeXml(u.role)}"
                            data-skill-ids="${fn:escapeXml(u.skillIds)}"
                            onclick="openEditModal(this)">
                      Edit
                    </button>

                    <c:choose>
                      <c:when test="${currentAdminId == u.userId}">
                        <button type="button" class="btn-action muted" disabled>Current Admin</button>
                      </c:when>

                      <c:when test="${u.role == 'Organization' and not empty u.approvalStatus and u.approvalStatus != 'Approved'}">
                        <a href="${pageContext.request.contextPath}/admin/manage-organizations?status=pending#review-queue" class="btn-action warning-link">Review Org</a>
                      </c:when>

                      <c:otherwise>
                        <form method="post" action="${pageContext.request.contextPath}/admin/manage-users" style="margin: 0;">
                          <input type="hidden" name="userId" value="${u.userId}" />
                          <input type="hidden" name="action" value="toggle_status" />
                          <input type="hidden" name="active" value="${u.active ? 'false' : 'true'}" />

                          <button type="submit"
                                  class="btn-action ${u.active ? 'danger' : 'success'}"
                                  onclick="return confirm('${u.active ? 'Block this user for policy violation?' : 'Restore access for this user?'}');">
                            ${u.active ? 'Block' : 'Unblock'}
                          </button>
                        </form>
                      </c:otherwise>
                    </c:choose>
                  </div>
                </td>
              </tr>
            </c:forEach>
          </c:otherwise>
        </c:choose>
        </tbody>
      </table>
    </div>

    <div class="pagination-wrapper">
      <div class="pagination">
        <c:if test="${totalPages > 1}">
          <div class="pagination">
            <c:if test="${currentPage > 1}">
              <a href="?page=${currentPage - 1}&q=${param.q}&role=${param.role}&status=${param.status}&fromDate=${param.fromDate}&toDate=${param.toDate}">Prev</a>
            </c:if>

            <c:forEach begin="1" end="${totalPages}" var="p">
              <a href="?page=${p}&q=${param.q}&role=${param.role}&status=${param.status}&fromDate=${param.fromDate}&toDate=${param.toDate}"
                 class="${p == currentPage ? 'active' : ''}">
                ${p}
              </a>
            </c:forEach>

            <c:if test="${currentPage < totalPages}">
              <a href="?page=${currentPage + 1}&q=${param.q}&role=${param.role}&status=${param.status}&fromDate=${param.fromDate}&toDate=${param.toDate}">Next</a>
            </c:if>
          </div>
        </c:if>
      </div>
    </div>
  </div>
</div>

<div id="editUserModal" class="modal-overlay">
  <div class="modal" style="width: 600px; max-width: 90%; max-height: 90vh; overflow-y: auto;">
    <h3>Edit User Profile</h3>
    <form method="post" action="${pageContext.request.contextPath}/admin/manage-users">

      <input type="hidden" name="userId" id="editUserId"/>
      <input type="hidden" name="action" value="edit" />

      <div class="form-group">
        <label>Email</label>
        <input type="text" id="editEmail" disabled style="background: #f1f5f9; color: #64748b;" />
      </div>

      <div class="form-grid" style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
        <div class="form-group">
          <label>First Name</label>
          <input type="text" name="firstName" id="editFirstName" />
        </div>

        <div class="form-group">
          <label>Last Name</label>
          <input type="text" name="lastName" id="editLastName" />
        </div>

        <div class="form-group">
          <label>Phone</label>
          <input type="text" name="phone" id="editPhone" />
        </div>

        <div class="form-group">
          <label>Role</label>
          <select name="role" id="editRole">
            <option value="Admin">Admin</option>
            <option value="Organization">Organization</option>
            <option value="Coordinator">Coordinator</option>
            <option value="Volunteer">Volunteer</option>
            <option value="SupportRequester">Support Requester</option>
          </select>
        </div>

        <div class="form-group">
          <label>Province</label>
          <input type="text" name="province" id="editProvince" />
        </div>

        <div class="form-group">
          <label>Address</label>
          <input type="text" name="address" id="editAddress" />
        </div>
      </div>

      <div class="form-group" style="margin-top: 15px;">
        <label>Skills</label>
        <div class="skills-group" style="display: flex; flex-wrap: wrap; gap: 10px; margin-top: 8px;">
          <c:forEach var="skill" items="${allSkills}">
            <label style="font-size: 13px; display: flex; align-items: center; gap: 5px; cursor: pointer;">
              <input type="checkbox" name="skills" value="${skill.skillId}" class="admin-skill-cb" style="width: auto;" />
              ${skill.skillName}
            </label>
          </c:forEach>
        </div>
      </div>

      <div class="modal-actions" style="margin-top: 25px;">
        <button type="button" class="btn-clear" onclick="closeEditModal()">Cancel</button>
        <button type="submit" class="btn-primary">Save Changes</button>
      </div>
    </form>
  </div>
</div>

<jsp:include page="/components/footer.jsp"/>

<style>
  .error-box {
    background: #fef2f2;
    color: #b91c1c;
    padding: 12px 16px;
    border: 1px solid #fecaca;
    border-radius: 10px;
    margin-bottom: 20px;
  }

  .empty-state {
    color: #64748b;
    padding: 28px 16px;
    text-align: center;
  }

  .badge-pending-org {
    background: #fff7ed;
    color: #c2410c;
  }

  .badge-rejected-org {
    background: #fef2f2;
    color: #b91c1c;
  }

  .btn-action.info {
    background: #eff6ff;
    color: #1d4ed8;
    border: 1px solid #bfdbfe;
  }

  .btn-action.info:hover {
    background: #2563eb;
    color: white;
  }

  .btn-action.muted {
    background: #f8fafc;
    color: #94a3b8;
    border: 1px solid #e2e8f0;
    cursor: not-allowed;
  }

  .warning-link {
    background: #fff7ed;
    color: #c2410c;
    border: 1px solid #fed7aa;
    text-align: center;
  }

  .warning-link:hover {
    background: #f97316;
    color: white;
  }
</style>

<script>
function openEditModal(button) {
    document.getElementById("editUserId").value = button.dataset.userId || "";
    document.getElementById("editEmail").value = button.dataset.email || "";
    document.getElementById("editFirstName").value = button.dataset.firstName || "";
    document.getElementById("editLastName").value = button.dataset.lastName || "";
    document.getElementById("editPhone").value = button.dataset.phone || "";
    document.getElementById("editProvince").value = button.dataset.province || "";
    document.getElementById("editAddress").value = button.dataset.address || "";
    document.getElementById("editRole").value = button.dataset.role || "Volunteer";

    document.querySelectorAll(".admin-skill-cb").forEach(cb => cb.checked = false);

    const skillIdsStr = button.dataset.skillIds || "";
    if (skillIdsStr && skillIdsStr.trim() !== "") {
        skillIdsStr.split(",").forEach(skillId => {
            const checkbox = document.querySelector('.admin-skill-cb[value="' + skillId.trim() + '"]');
            if (checkbox) {
                checkbox.checked = true;
            }
        });
    }

    document.getElementById("editUserModal").style.display = "flex";
}

function closeEditModal() {
    document.getElementById("editUserModal").style.display = "none";
}
</script>
