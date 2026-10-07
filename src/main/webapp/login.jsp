<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Login | EduCore StudentApp</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
  <link rel="stylesheet" href="assets/style.css">
</head>
<body>
  <div class="auth-wrapper">
    <div class="auth-card">
      <div class="text-center mb-4">
        <div class="auth-brand-icon">
          <i class="bi bi-mortarboard-fill"></i>
        </div>
        <h3 class="fw-bold text-dark mb-1">EduCore Portal</h3>
        <p class="text-muted small">Sign in to manage student records</p>
      </div>

      <% String error = (String) request.getAttribute("error");
         if (error != null && !error.isEmpty()) { %>
        <div class="alert alert-danger alert-dismissible fade show border-0 shadow-sm mb-4" role="alert">
          <i class="bi bi-exclamation-triangle-fill me-2"></i><%= error %>
          <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
      <% } %>

      <% if ("true".equals(request.getParameter("logout"))) { %>
        <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm mb-4" role="alert">
          <i class="bi bi-check-circle-fill me-2"></i>You have logged out successfully.
          <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
      <% } %>

      <form action="login" method="post">
        <div class="mb-3">
          <label class="form-label" for="username"><i class="bi bi-person me-1"></i> Username</label>
          <input type="text" class="form-control" id="username" name="username" value="admin" placeholder="e.g. admin" required autofocus>
        </div>
        <div class="mb-4">
          <label class="form-label" for="password"><i class="bi bi-lock me-1"></i> Password</label>
          <input type="password" class="form-control" id="password" name="password" value="admin123" placeholder="••••••••" required>
        </div>
        <button class="btn btn-primary w-100 py-2.5 fw-bold text-uppercase" style="letter-spacing: 0.05em;" type="submit">
          Sign In <i class="bi bi-box-arrow-in-right ms-2"></i>
        </button>
      </form>

      <div class="text-center mt-4 pt-3 border-top">
        <small class="text-muted">Default Credentials: <strong>admin</strong> / <strong>admin123</strong></small>
      </div>
    </div>
  </div>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>