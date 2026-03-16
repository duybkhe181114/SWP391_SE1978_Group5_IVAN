<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="/components/header.jsp"/>

<div class="admin-page">
  <div class="admin-container">

    <h2 class="section-title">
      <span style="color: #667eea;">●</span> Manage Users
    </h2>

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
            <option value="Volunteer" ${param.role=='Volunteer'?'selected':''}>Volunteer</option>
          </select>
        </div>

        <div class="filter-group">
          <label>Status</label>
          <select name="status">
            <option value="">All</option>
            <option value="active" ${param.status=='active'?'selected':''}>Active</option>
            <option value="inactive" ${param.status=='inactive'?'selected':''}>Inactive</option>
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

    <!-- TABLE -->
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
          <th style="width: 120px;">Action</th>
        </tr>
        </thead>

        <tbody>
        <c:forEach items="${users}" var="u" varStatus="loop">
          <tr>
            <!-- INDEX -->
            <td>
                <span style="color: #94a3b8;">
                    ${loop.index + 1}
                </span>
            </td>

            <!-- USER INFO -->
            <td>
              <div class="user-email">${u.email}</div>
              <div style="font-size: 13px; color: #64748b;">
                  ${not empty u.fullName ? u.fullName : 'No Name'}
              </div>
            </td>

            <!-- ROLE -->
            <td>
                <span class="badge role-${u.role}">
                    ${u.role}
                </span>
            </td>

            <!-- LOCATION -->
            <td>
              <div style="font-size: 14px;">
                  ${u.province != null ? u.province : 'N/A'}
              </div>
              <div style="font-size: 12px; color: #94a3b8;">
                  ${u.phone}
              </div>
            </td>

            <!-- STATUS -->
            <td>
              <c:choose>
                <c:when test="${u.active}">
                  <span class="badge badge-active">● Active</span>
                </c:when>
                <c:otherwise>
                  <span class="badge badge-inactive">● Inactive</span>
                </c:otherwise>
              </c:choose>
            </td>

            <!-- CREATED AT -->
            <td style="color: #64748b; font-size: 14px;">
              <fmt:formatDate value="${u.createdAt}" pattern="dd MMM, yyyy"/>
            </td>

            <td>
              <div style="display:flex; gap:8px;">

                <!-- EDIT -->
                 <button type="button"
                        class="btn-action info"
                        onclick="openEditModal(
                                '${u.userId}',
                                '${u.email}',
                                '${u.firstName}',
                                '${u.lastName}',
                                '${u.phone}',
                                '${u.province}',
                                '${u.address}',
                                '${u.role}',
                                '${u.skillIds}'
                                )">
                  Edit
                </button>

                <!-- TOGGLE -->
                <form method="post" action="${pageContext.request.contextPath}/admin/manage-users">
                  <input type="hidden" name="userId" value="${u.userId}" />
                  <input type="hidden" name="action" value="toggle" />

                  <button type="submit" class="btn-action ${u.active ? 'danger' : 'success'}">
                      ${u.active ? 'Deactivate' : 'Activate'}
                  </button>
                </form>

              </div>
            </td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
    </div>
    <!-- PAGINATION -->
    <div class="pagination-wrapper">
      <div class="pagination">
        <c:if test="${totalPages > 1}">
          <div class="pagination">
            <c:if test="${currentPage > 1}">
              <a href="?page=${currentPage - 1}&q=${param.q}&role=${param.role}&status=${param.status}&fromDate=${param.fromDate}&toDate=${param.toDate}">
                ‹ Prev
              </a>
            </c:if>

            <c:forEach begin="1" end="${totalPages}" var="p">
              <a href="?page=${p}&q=${param.q}&role=${param.role}&status=${param.status}&fromDate=${param.fromDate}&toDate=${param.toDate}"
                 class="${p == currentPage ? 'active' : ''}">
                  ${p}
              </a>
            </c:forEach>

            <c:if test="${currentPage < totalPages}">
              <a href="?page=${currentPage + 1}&q=${param.q}&role=${param.role}&status=${param.status}&fromDate=${param.fromDate}&toDate=${param.toDate}">
                Next ›
              </a>
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


<script>
function openEditModal(id, email, firstName, lastName, phone, province, address, role, skillIdsStr) {
    document.getElementById("editUserId").value = id;
    document.getElementById("editEmail").value = email;
    document.getElementById("editFirstName").value = firstName || "";
    document.getElementById("editLastName").value = lastName || "";
    document.getElementById("editPhone").value = phone || "";
    document.getElementById("editProvince").value = province || "";
    document.getElementById("editAddress").value = address || "";
    document.getElementById("editRole").value = role;

    document.querySelectorAll('.admin-skill-cb').forEach(cb => cb.checked = false);

    if (skillIdsStr && skillIdsStr.trim() !== "") {
        let selectedSkills = skillIdsStr.split(',');
        selectedSkills.forEach(skillId => {
            let checkbox = document.querySelector('.admin-skill-cb[value="' + skillId.trim() + '"]');
            if (checkbox) checkbox.checked = true;
        });
    }

    document.getElementById("editUserModal").style.display = "flex";
  }
</script>