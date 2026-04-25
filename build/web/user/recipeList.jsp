<%-- 
    Document   : recipeList
    Created on : 19 Jan 2026, 4:13:08 PM
    Author     : haziq
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*,model.Recipe, model.User" %>

<%
    List<Recipe> recipes = (List<Recipe>) request.getAttribute("recipes");
    if (recipes == null) {
        recipes = java.util.Collections.emptyList();
    }
%>

<%
    request.setAttribute("activePage", "recipes");
    String currentPage = request.getRequestURI();
%>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) { response.sendRedirect(request.getContextPath() + "/login.jsp");
 return; }

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
    <title>Manage Recipes | HERNES</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">
</head>

<body>

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
        <a href="<%= request.getContextPath() %>/LoginServlet?action=logout" class="logout-link">Logout</a>
    </div>
</header>

<section class="hero">
    <p class="welcome">🍴 Manage Recipes</p>
    <h2>Recipe List</h2>
    <p class="desc">Add, edit, or delete recipes in the system.</p>
</section>

<div class="content">
    <div class="top-row">
        <div class="muted">Total recipes: <b><%= recipes.size() %></b></div>
        <a class="btn" href="<%= request.getContextPath() %>/RecipeServlet?action=addRecipePage">+ Add Recipe</a>
    </div>

    <div class="table-wrap">
        <table>
    <tr>
        <th style="width:160px;">Recipe ID</th>
        <th>Recipe Name</th>
        <th style="width:220px;">Actions</th>
    </tr>

    <%
        if (recipes != null && !recipes.isEmpty()) {
            for (Recipe r : recipes) {
    %>
    <tr>
        <td><%= r.getRecipeID() %></td>
        <td><%= r.getRecipeName() %></td>
        
        
        <td>
            <div class="actions">
                
                <a class="btn btn-sm"
                   href="<%=request.getContextPath()%>/RecipeServlet?action=viewRecipeDetail&recipeID=<%=r.getRecipeID()%>">
                   View
                </a>
        
                <a class="link"
                   href="<%= request.getContextPath() %>/RecipeServlet?action=editRecipePage&recipeID=<%= r.getRecipeID() %>">
                    Edit
                </a>

                <form action="<%= request.getContextPath() %>/RecipeServlet" method="post" class="inline-form">
                    <input type="hidden" name="action" value="deleteRecipe">
                    <input type="hidden" name="recipeID" value="<%= r.getRecipeID() %>">
                    <button class="small-btn btn-danger" type="submit"
                            onclick="return confirm('Delete this recipe?')">
                        Delete
                    </button>
                </form>
            </div>
        </td>
    </tr>
    <%
            } // end for
        } else {
    %>
    <tr>
        <td colspan="3" class="muted">No recipes found.</td>
    </tr>
    <%
        } // end if
    %>
</table>

    </div>
</div>

</body>
</html>
