<%-- 
    Document   : login
    Created on : 18 Jan 2026, 6:50:39 PM
    Author     : haziq
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Login | HERNES</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">
</head>

<body class="auth-page">

  <form class="card auth-card" action="${pageContext.request.contextPath}/LoginServlet" method="post">
    <input type="hidden" name="action" value="login">

    <h1>Login</h1>
    <p class="subtitle">Healthy Eating Recommendation & Nutrition Evaluation</p>

    <label>Email Address</label>
    <div class="input-group">
      <input type="email" name="email" placeholder="Enter your email" required>
    </div>

    <label>Password</label>
    <div class="input-group">
      <input type="password" name="password" placeholder="Enter your password" required>
    </div>

    <button type="submit" class="btn">Login</button>

    <% if (request.getAttribute("error") != null) { %>
      <div class="msg"><%= request.getAttribute("error") %></div>
    <% } %>

    <% if ("1".equals(request.getParameter("registered"))) { %>
      <div class="msg msg-success">Registration successful. Please log in.</div>
    <% } %>

    <div class="link-row">
      No account yet? <a href="${pageContext.request.contextPath}/register.jsp" style="color:#047857;text-decoration:none;font-weight:600;">Register here</a>
    </div>

  </form>

</body>
</html>
