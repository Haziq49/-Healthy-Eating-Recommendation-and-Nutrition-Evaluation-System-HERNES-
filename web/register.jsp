<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Register | HERNES</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">
</head>
<body class="auth-page">

  <form class="card auth-card" action="${pageContext.request.contextPath}/RegisterServlet" method="post">
    <h1>Create Account</h1>
    <p class="subtitle">Healthy Eating Recommendation & Nutrition Evaluation</p>

    <label>Full Name</label>
    <div class="input-group">
      <input type="text" name="userName" placeholder="Enter your full name" required
             value="<%= request.getAttribute("userName") != null ? request.getAttribute("userName") : "" %>">
    </div>

    <label>Email Address</label>
    <div class="input-group">
      <input type="email" name="email" placeholder="Enter your email" required
             value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>">
    </div>

    <label>Password</label>
    <div class="input-group">
      <input type="password" name="password" placeholder="Create a password" required>
    </div>

    <label>Confirm Password</label>
    <div class="input-group">
      <input type="password" name="confirmPassword" placeholder="Confirm your password" required>
    </div>

    <button type="submit" class="btn">Register</button>

    <% if (request.getAttribute("error") != null) { %>
      <div class="msg"><%= request.getAttribute("error") %></div>
    <% } %>

    <div class="link-row">
      Already have an account?
      <a href="${pageContext.request.contextPath}/login.jsp">Login</a>
    </div>
  </form>

</body>
</html>
