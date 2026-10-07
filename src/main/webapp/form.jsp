<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.app.model.Student" %>
<%
  Student s = (Student) request.getAttribute("student");
  boolean edit = (s != null);
  String currentUser = (session != null && session.getAttribute("user") != null)
      ? (String) session.getAttribute("user") : "Administrator";
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title><%= edit ? "Edit Student" : "Add New Student" %> | EduCore</title>
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
        <a href="students" class="nav-item-link">
          <i class="bi bi-people-fill"></i>
          <span>Student Directory</span>
        </a>
        <a href="students?action=new" class="nav-item-link <%= !edit ? "active" : "" %>">
          <i class="bi bi-person-plus-fill"></i>
          <span>Add New Student</span>
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

    <!-- Main Workspace -->
    <main class="app-main">
      <header class="app-topbar">
        <div class="topbar-breadcrumb">
          <h4><%= edit ? "Edit Student Profile" : "Create Student Record" %></h4>
        </div>
        <div class="topbar-actions">
          <a href="students" class="btn btn-outline-custom">
            <i class="bi bi-arrow-left"></i> Back to List
          </a>
        </div>
      </header>

      <div class="app-content">
        <div class="row justify-content-center">
          <div class="col-12 col-lg-8 col-xl-7">
            <div class="app-card shadow-sm">
              <div class="app-card-header">
                <h5 class="app-card-title">
                  <i class="bi bi-person-lines-fill text-primary"></i>
                  <%= edit ? "Edit Student Information (#" + s.getId() + ")" : "Fill Student Details" %>
                </h5>
              </div>
              <div class="app-card-body">
                <form action="students" method="post">
                  <input type="hidden" name="id" value="<%= edit ? s.getId() : "" %>">

                  <div class="form-section-heading">
                    <i class="bi bi-person me-1"></i> Personal Information
                  </div>

                  <div class="mb-3">
                    <label class="form-label" for="name">Full Name <span class="text-danger">*</span></label>
                    <input class="form-control" id="name" name="name" required
                           placeholder="e.g. John Doe" value="<%= edit ? s.getName() : "" %>">
                  </div>

                  <div class="mb-4">
                    <label class="form-label" for="email">Email Address <span class="text-danger">*</span></label>
                    <input class="form-control" type="email" id="email" name="email" required
                           placeholder="e.g. john.doe@university.edu" value="<%= edit ? s.getEmail() : "" %>">
                  </div>

                  <div class="form-section-heading">
                    <i class="bi bi-journal-bookmark me-1"></i> Academic Details
                  </div>

                  <div class="mb-3">
                    <label class="form-label" for="course">Course / Major <span class="text-danger">*</span></label>
                    <input class="form-control" id="course" name="course" required
                           placeholder="e.g. Computer Science, Business Administration"
                           value="<%= edit ? s.getCourse() : "" %>">
                  </div>

                  <div class="row g-3 mb-4">
                    <div class="col-6">
                      <label class="form-label" for="gpa">GPA (0.00 - 4.00)</label>
                      <input class="form-control" type="number" step="0.01" min="0.0" max="4.0" id="gpa" name="gpa"
                             placeholder="3.50" value="<%= edit ? String.format(java.util.Locale.US, "%.2f", s.getGpa()) : "3.50" %>">
                    </div>

                    <div class="col-6">
                      <label class="form-label" for="status">Enrollment Status</label>
                      <select class="form-select" id="status" name="status">
                        <option value="Active" <%= (edit && "Active".equalsIgnoreCase(s.getStatus())) ? "selected" : "" %>>Active</option>
                        <option value="Graduated" <%= (edit && "Graduated".equalsIgnoreCase(s.getStatus())) ? "selected" : "" %>>Graduated</option>
                        <option value="On-Leave" <%= (edit && "On-Leave".equalsIgnoreCase(s.getStatus())) ? "selected" : "" %>>On Leave</option>
                        <option value="Suspended" <%= (edit && "Suspended".equalsIgnoreCase(s.getStatus())) ? "selected" : "" %>>Suspended</option>
                      </select>
                    </div>
                  </div>

                  <div class="d-flex justify-content-end gap-2 pt-3 border-top">
                    <a class="btn btn-outline-custom px-4" href="students">Cancel</a>
                    <button class="btn btn-primary px-4" type="submit">
                      <i class="bi bi-check-lg"></i> <%= edit ? "Update Record" : "Save Student" %>
                    </button>
                  </div>
                </form>
              </div>
            </div>
          </div>
        </div>
      </div>
    </main>
  </div>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>