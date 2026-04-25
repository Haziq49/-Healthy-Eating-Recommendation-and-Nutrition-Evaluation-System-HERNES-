<%-- 
    Document   : dashboard
    Created on : 18 Jan 2026, 11:26:39 PM
    Author     : haziq
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User"%>

<%
    request.setAttribute("activePage", "home");
    String currentPage = request.getRequestURI();
%>

<%
    // Session protection
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // Avatar initials
    String initials = "U";
    if (user.getUserName() != null && !user.getUserName().trim().isEmpty()) {
        String[] parts = user.getUserName().trim().split("\\s+");
        String first = parts[0].substring(0, 1).toUpperCase();
        String second = (parts.length > 1) ? parts[1].substring(0, 1).toUpperCase() : "";
        initials = first + second;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>HERNES Dashboard</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">
</head>

<body>

<!-- ===== NAVBAR ===== -->
<header class="navbar">
    <div class="nav-left">
        <div class="logo">🍽️</div>
        <div>
            <h1>HERNES</h1>
            <span>Healthy Eating Recommendation & Nutrition Evaluation</span>
        </div>
    </div>

    <nav class="nav-center">
    <a href="${pageContext.request.contextPath}/user/dashboard.jsp"
       class="<%= currentPage.endsWith("dashboard.jsp") ? "active" : "" %>">
        🏠 Home
    </a>

    <a href="<%= request.getContextPath() %>/RecipeServlet?action=listRecipes"
   class="<%= currentPage.contains("recipe") ? "active" : "" %>">
    🍴 Recipes
</a>


    <a href="<%= request.getContextPath() %>/NutritionServlet?action=home"
           class="<%= currentPage.contains("nutrition") ? "active" : "" %>">
            📊 Nutrition Evaluation
        </a>

    <a href="#"
       class="<%= currentPage.contains("profile") ? "active" : "" %>">
        👤 Profile
    </a>
</nav>


    <div class="nav-right">
        <div class="avatar"><%= initials %></div>
        <a href="<%= request.getContextPath() %>/LoginServlet?action=logout" class="button">Logout</a>
    </div>
</header>

<!-- ===== HERO ===== -->
<section class="hero">
    <p class="welcome">🍃 Welcome back, <%= user.getUserName() %>!</p>
    <h2>Healthy Eating Recommendation and Nutrition Evaluation System</h2>
    <p class="desc">
        Find personalized meal recommendations tailored to your health goals
    </p>

    <div class="search-box">
        <form action="<%= request.getContextPath() %>/RecipeServlet" method="get" style="display:flex;width:100%;">
            <input type="hidden" name="action" value="searchRecipes">
            <input type="text" name="q" placeholder="Search for healthy recipes, ingredients, or cuisines...">
            <button type="submit">Search</button>
        </form>
    </div>
</section>

</body>
</html>
