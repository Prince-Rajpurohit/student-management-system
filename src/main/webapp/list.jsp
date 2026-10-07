<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, com.app.model.Student" %>
<%
  List<Student> list = (List<Student>) request.getAttribute("students");
  if (list == null) list = new ArrayList<>();

  Integer totalStudents = (Integer) request.getAttribute("totalStudents");
  if (totalStudents == null) totalStudents = list.size();

  Integer activeStudents = (Integer) request.getAttribute("activeStudents");
  if (activeStudents == null) activeStudents = list.size();

  Integer courseCount = (Integer) request.getAttribute("courseCount");
  if (courseCount == null) courseCount = 0;

  String avgGpa = (String) request.getAttribute("avgGpa");
  if (avgGpa == null) avgGpa = "3.50";

  Set<String> allCourses = (Set<String>) request.getAttribute("allCourses");
  if (allCourses == null) allCourses = new TreeSet<>();

  String paramQuery = (String) request.getAttribute("paramQuery");
  if (paramQuery == null) paramQuery = "";

  String paramCourseFilter = (String) request.getAttribute("paramCourseFilter");
  if (paramCourseFilter == null) paramCourseFilter = "All";

  String paramStatusFilter = (String) request.getAttribute("paramStatusFilter");
  if (paramStatusFilter == null) paramStatusFilter = "All";

  String currentUser = (session != null && session.getAttribute("user") != null)
      ? (String) session.getAttribute("user") : "Administrator";
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Student Directory | EduCore</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
  <link rel="stylesheet" href="assets/style.css">
</head>
<body>
  <div class="app-wrapper">
    <!-- Sidebar Navigation -->
    <aside class="app-sidebar">
      <div class="sidebar-header">
        <div class="brand-icon">
          <i class="bi bi-mortarboard-fill text-white"></i>
        </div>
        <div>
          <h1 class="brand-title">EduCore</h1>
          <div class="brand-subtitle">Management System</div>
        </div>
      </div>

      <div class="sidebar-nav">
        <div class="nav-section-title">Main Menu</div>
        <a href="students" class="nav-item-link active">
          <i class="bi bi-people-fill"></i>
          <span>Student Directory</span>
        </a>
        <a href="students?action=new" class="nav-item-link">
          <i class="bi bi-person-plus-fill"></i>
          <span>Add New Student</span>
        </a>

        <div class="nav-section-title mt-3">Quick Filters</div>
        <a href="students?statusFilter=Active" class="nav-item-link">
          <i class="bi bi-check-circle-fill text-success"></i>
          <span>Active Students</span>
        </a>
        <a href="students?statusFilter=Graduated" class="nav-item-link">
          <i class="bi bi-mortarboard text-info"></i>
          <span>Graduated</span>
        </a>
        <a href="students?statusFilter=On-Leave" class="nav-item-link">
          <i class="bi bi-clock-history text-warning"></i>
          <span>On Leave</span>
        </a>
      </div>

      <div class="sidebar-footer">
        <div class="user-profile-badge justify-content-between">
          <div class="d-flex align-items-center gap-2">
            <div class="user-avatar-sm">
              <%= currentUser.substring(0, 1).toUpperCase() %>
            </div>
            <div class="overflow-hidden" style="max-width: 120px;">
              <div class="fw-bold text-white text-truncate text-capitalize" style="font-size: 0.85rem;"><%= currentUser %></div>
              <div class="text-muted small" style="font-size: 0.72rem;">System Admin</div>
            </div>
          </div>
          <a href="logout" class="btn btn-sm btn-action-icon text-light hover-bg-danger" title="Logout">
            <i class="bi bi-box-arrow-right"></i>
          </a>
        </div>
      </div>
    </aside>

    <!-- Main Content Area -->
    <main class="app-main">
      <!-- Topbar Header -->
      <header class="app-topbar">
        <div class="topbar-breadcrumb">
          <h4>Student Directory</h4>
        </div>
        <div class="topbar-actions">
          <a href="students?action=new" class="btn btn-primary shadow-sm">
            <i class="bi bi-plus-lg"></i> Add Student
          </a>
          <a href="logout" class="btn btn-outline-custom">
            <i class="bi bi-box-arrow-right"></i> Logout
          </a>
        </div>
      </header>

      <!-- App Content Container -->
      <div class="app-content">
        <!-- Stat Cards Row -->
        <div class="row g-3 mb-4">
          <div class="col-12 col-sm-6 col-xl-3">
            <div class="stat-card">
              <div class="stat-card-inner">
                <div>
                  <div class="stat-label">Total Students</div>
                  <h3 class="stat-value"><%= totalStudents %></h3>
                  <span class="stat-badge bg-primary bg-opacity-10 text-primary">
                    <i class="bi bi-person"></i> Registered
                  </span>
                </div>
                <div class="stat-icon-wrapper stat-icon-primary">
                  <i class="bi bi-people"></i>
                </div>
              </div>
            </div>
          </div>

          <div class="col-12 col-sm-6 col-xl-3">
            <div class="stat-card">
              <div class="stat-card-inner">
                <div>
                  <div class="stat-label">Active Enrolled</div>
                  <h3 class="stat-value"><%= activeStudents %></h3>
                  <span class="stat-badge bg-success bg-opacity-10 text-success">
                    <i class="bi bi-check-circle"></i> In Good Standing
                  </span>
                </div>
                <div class="stat-icon-wrapper stat-icon-success">
                  <i class="bi bi-person-check"></i>
                </div>
              </div>
            </div>
          </div>

          <div class="col-12 col-sm-6 col-xl-3">
            <div class="stat-card">
              <div class="stat-card-inner">
                <div>
                  <div class="stat-label">Active Courses</div>
                  <h3 class="stat-value"><%= courseCount %></h3>
                  <span class="stat-badge bg-info bg-opacity-10 text-info">
                    <i class="bi bi-journal-bookmark"></i> Programs
                  </span>
                </div>
                <div class="stat-icon-wrapper stat-icon-info">
                  <i class="bi bi-book"></i>
                </div>
              </div>
            </div>
          </div>

          <div class="col-12 col-sm-6 col-xl-3">
            <div class="stat-card">
              <div class="stat-card-inner">
                <div>
                  <div class="stat-label">Average GPA</div>
                  <h3 class="stat-value"><%= avgGpa %></h3>
                  <span class="stat-badge bg-warning bg-opacity-10 text-warning">
                    <i class="bi bi-star"></i> Performance
                  </span>
                </div>
                <div class="stat-icon-wrapper stat-icon-warning">
                  <i class="bi bi-award"></i>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Filter Toolbar -->
        <div class="filter-toolbar">
          <form action="students" method="get" class="row g-2 align-items-center">
            <div class="col-12 col-md-5">
              <div class="input-group">
                <span class="input-group-text bg-white border-end-0 text-muted">
                  <i class="bi bi-search"></i>
                </span>
                <input type="text" name="query" class="form-control border-start-0 ps-0"
                       placeholder="Search student name, email, or course..." value="<%= paramQuery %>">
              </div>
            </div>

            <div class="col-6 col-md-3">
              <select name="courseFilter" class="form-select">
                <option value="All" <%= "All".equals(paramCourseFilter) ? "selected" : "" %>>All Courses</option>
                <% for (String c : allCourses) { %>
                  <option value="<%= c %>" <%= c.equals(paramCourseFilter) ? "selected" : "" %>><%= c %></option>
                <% } %>
              </select>
            </div>

            <div class="col-6 col-md-2">
              <select name="statusFilter" class="form-select">
                <option value="All" <%= "All".equals(paramStatusFilter) ? "selected" : "" %>>All Statuses</option>
                <option value="Active" <%= "Active".equalsIgnoreCase(paramStatusFilter) ? "selected" : "" %>>Active</option>
                <option value="Graduated" <%= "Graduated".equalsIgnoreCase(paramStatusFilter) ? "selected" : "" %>>Graduated</option>
                <option value="On-Leave" <%= "On-Leave".equalsIgnoreCase(paramStatusFilter) ? "selected" : "" %>>On Leave</option>
                <option value="Suspended" <%= "Suspended".equalsIgnoreCase(paramStatusFilter) ? "selected" : "" %>>Suspended</option>
              </select>
            </div>

            <div class="col-12 col-md-2 d-flex gap-2">
              <button type="submit" class="btn btn-primary w-100">Filter</button>
              <% if (!paramQuery.isEmpty() || !"All".equals(paramCourseFilter) || !"All".equals(paramStatusFilter)) { %>
                <a href="students" class="btn btn-outline-custom" title="Reset Filters"><i class="bi bi-x-lg"></i></a>
              <% } %>
            </div>
          </form>
        </div>

        <!-- Bulk Selection Action Bar -->
        <form id="bulkForm" action="students" method="get">
          <input type="hidden" name="action" value="deleteBatch">
          <div id="bulkBar" class="bulk-bar d-none">
            <div class="d-flex align-items-center gap-2">
              <i class="bi bi-check2-square text-info fs-5"></i>
              <span><strong id="selectedCount">0</strong> student(s) selected</span>
            </div>
            <div class="d-flex gap-2">
              <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Delete selected students permanently?')">
                <i class="bi bi-trash"></i> Delete Selected
              </button>
            </div>
          </div>

          <!-- Data Table Card -->
          <div class="app-card">
            <div class="app-card-header">
              <h5 class="app-card-title">
                <i class="bi bi-table text-primary"></i> Student Directory List
              </h5>
              <span class="text-muted small">Showing <%= list.size() %> entries</span>
            </div>
            <div class="data-table-container">
              <table class="data-table">
                <thead>
                  <tr>
                    <th style="width: 40px;" class="ps-4">
                      <input type="checkbox" id="selectAll" class="form-check-input custom-check">
                    </th>
                    <th style="width: 70px;">ID</th>
                    <th>Student Name & Email</th>
                    <th>Course</th>
                    <th>GPA</th>
                    <th>Status</th>
                    <th class="text-end pe-4">Actions</th>
                  </tr>
                </thead>
                <tbody>
                <% if (!list.isEmpty()) {
                     for (Student s : list) {
                       String gpaClass = "badge-gpa-high";
                       if (s.getGpa() < 3.0 && s.getGpa() >= 2.5) gpaClass = "badge-gpa-mid";
                       else if (s.getGpa() < 2.5) gpaClass = "badge-gpa-low";

                       String statusClass = s.getStatus().toLowerCase().replace(" ", "-");
                %>
                  <tr>
                    <td class="ps-4">
                      <input type="checkbox" name="ids" value="<%= s.getId() %>" class="form-check-input custom-check row-checkbox">
                    </td>
                    <td class="fw-bold text-secondary">#<%= s.getId() %></td>
                    <td>
                      <div class="student-meta">
                        <div class="student-avatar">
                          <%= s.getInitial() %>
                        </div>
                        <div>
                          <div class="student-name"><%= s.getName() != null ? s.getName() : "N/A" %></div>
                          <div class="student-email"><%= s.getEmail() != null ? s.getEmail() : "" %></div>
                        </div>
                      </div>
                    </td>
                    <td>
                      <span class="badge bg-light text-dark border px-2.5 py-1.5 fw-semibold" style="font-size: 0.82rem;">
                        <i class="bi bi-journal-text me-1 text-primary"></i><%= s.getCourse() != null ? s.getCourse() : "General" %>
                      </span>
                    </td>
                    <td>
                      <span class="badge-gpa <%= gpaClass %>">
                        <i class="bi bi-star-fill" style="font-size: 0.7rem;"></i> <%= String.format(Locale.US, "%.2f", s.getGpa()) %>
                      </span>
                    </td>
                    <td>
                      <span class="badge-status <%= statusClass %>">
                        <%= s.getStatus() %>
                      </span>
                    </td>
                    <td class="text-end pe-4">
                      <button type="button" class="btn btn-action-icon btn-outline-custom me-1"
                              onclick="openQuickView('<%= s.getId() %>', '<%= s.getName() %>', '<%= s.getEmail() %>', '<%= s.getCourse() %>', '<%= String.format(Locale.US, "%.2f", s.getGpa()) %>', '<%= s.getStatus() %>')"
                              title="Quick View">
                        <i class="bi bi-eye"></i>
                      </button>
                      <a class="btn btn-action-icon btn-outline-custom me-1" href="students?action=edit&id=<%= s.getId() %>" title="Edit">
                        <i class="bi bi-pencil"></i>
                      </a>
                      <a class="btn btn-action-icon btn-outline-danger" href="students?action=delete&id=<%= s.getId() %>"
                         onclick="return confirm('Permanently delete student <%= s.getName() %>?')" title="Delete">
                        <i class="bi bi-trash"></i>
                      </a>
                    </td>
                  </tr>
                <%   }
                   } else { %>
                  <tr>
                    <td colspan="7" class="text-center py-5">
                      <i class="bi bi-inbox fs-1 d-block mb-2 text-muted"></i>
                      <h6 class="fw-bold text-dark mb-1">No Student Records Found</h6>
                      <p class="text-muted small mb-3">Try adjusting your filters or click "Add Student" to create a record.</p>
                      <a href="students?action=new" class="btn btn-primary btn-sm">
                        <i class="bi bi-plus-lg"></i> Add Student
                      </a>
                    </td>
                  </tr>
                <% } %>
                </tbody>
              </table>
            </div>
          </div>
        </form>
      </div>
    </main>
  </div>

  <!-- Quick View Modal -->
  <div class="modal fade" id="quickViewModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
      <div class="modal-content">
        <div class="modal-header bg-light">
          <h5 class="modal-title fw-bold"><i class="bi bi-person-badge text-primary me-2"></i> Student Overview</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body p-4">
          <div class="student-id-card mb-3">
            <div class="d-flex align-items-center gap-3">
              <div id="modalAvatar" class="student-avatar" style="width: 52px; height: 52px; font-size: 1.2rem; background: rgba(255,255,255,0.2); color: #fff;">
                S
              </div>
              <div>
                <h5 id="modalName" class="fw-bold text-white mb-0">Student Name</h5>
                <div id="modalEmail" class="text-light opacity-75 small">student@example.com</div>
              </div>
            </div>
            <div class="row mt-4 pt-2 border-top border-secondary text-light">
              <div class="col-6">
                <small class="text-muted d-block text-uppercase" style="font-size:0.68rem;">Course</small>
                <span id="modalCourse" class="fw-bold">Computer Science</span>
              </div>
              <div class="col-3">
                <small class="text-muted d-block text-uppercase" style="font-size:0.68rem;">GPA</small>
                <span id="modalGpa" class="fw-bold">3.80</span>
              </div>
              <div class="col-3">
                <small class="text-muted d-block text-uppercase" style="font-size:0.68rem;">Status</small>
                <span id="modalStatus" class="fw-bold">Active</span>
              </div>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <a id="modalEditBtn" href="#" class="btn btn-primary">Edit Record</a>
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
        </div>
      </div>
    </div>
  </div>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
  <script>
    // Bulk Selection Checkboxes Logic
    const selectAll = document.getElementById('selectAll');
    const rowCheckboxes = document.querySelectorAll('.row-checkbox');
    const bulkBar = document.getElementById('bulkBar');
    const selectedCount = document.getElementById('selectedCount');

    function updateBulkBar() {
      const checked = document.querySelectorAll('.row-checkbox:checked');
      if (checked.length > 0) {
        bulkBar.classList.remove('d-none');
        selectedCount.textContent = checked.length;
      } else {
        bulkBar.classList.add('d-none');
      }
    }

    if (selectAll) {
      selectAll.addEventListener('change', function() {
        rowCheckboxes.forEach(cb => {
          cb.checked = selectAll.checked;
          const tr = cb.closest('tr');
          if (tr) {
            if (cb.checked) tr.classList.add('row-selected');
            else tr.classList.remove('row-selected');
          }
        });
        updateBulkBar();
      });
    }

    rowCheckboxes.forEach(cb => {
      cb.addEventListener('change', function() {
        const tr = cb.closest('tr');
        if (tr) {
          if (cb.checked) tr.classList.add('row-selected');
          else tr.classList.remove('row-selected');
        }
        updateBulkBar();
      });
    });

    // Quick View Modal
    function openQuickView(id, name, email, course, gpa, status) {
      document.getElementById('modalName').textContent = name;
      document.getElementById('modalEmail').textContent = email;
      document.getElementById('modalCourse').textContent = course;
      document.getElementById('modalGpa').textContent = gpa;
      document.getElementById('modalStatus').textContent = status;
      document.getElementById('modalAvatar').textContent = name ? name.substring(0, 1).toUpperCase() : 'S';
      document.getElementById('modalEditBtn').href = 'students?action=edit&id=' + id;

      const modal = new bootstrap.Modal(document.getElementById('quickViewModal'));
      modal.show();
    }
  </script>
</body>
</html>