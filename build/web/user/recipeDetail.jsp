<%-- 
    Document   : recipeDetail
    Created on : 21 Jan 2026, 2:39:00 PM
    Author     : haziq
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Recipe, model.User" %>
<%@ page import="model.IngredientItem" %>

<%
  Recipe recipe = (Recipe) request.getAttribute("recipe");
  List<IngredientItem> ingredients = (List<IngredientItem>) request.getAttribute("ingredients");
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
<html>
<head>
    <meta charset="UTF-8">
    <title>View Recipe Detail | HERNES</title>
    
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


    <a href="<%= request.getContextPath() %>/NutritionServlet?action=evaluate&recipeID=<%= (recipe != null) ? recipe.getRecipeID() : 0 %>"
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
    <p class="welcome">View Recipe</p>
    <h2>View Recipe</h2>
    <p class="desc">Look detail on recipe</p>
</section>
    
  <div class="page">

  <div class="form-card">
    <div class="form-grid">

      <!-- Recipe ID -->
      <div class="field">
        <label>Recipe ID (readonly)</label>
        <input class="input" type="text" readonly
               value="<%= (recipe != null) ? recipe.getRecipeID() : "" %>">
      </div>

      <!-- Recipe Name -->
      <div class="field">
        <label>Recipe Name</label>
        <input class="input" type="text" readonly
               value="<%= (recipe != null) ? recipe.getRecipeName() : "" %>">
      </div>

      <!-- Instructions -->
      <div class="field full">
        <label>Instruction</label>
        <textarea class="textarea" readonly><%= (recipe != null && recipe.getInstruction() != null) ? recipe.getInstruction() : "" %></textarea>
      </div>

    </div>

    <!-- Ingredients Table -->
    <div class="section-title">Ingredients</div>

    <div class="table-wrap">

      <table>
        <thead>
          <tr>
            <th style="width:55%;">Ingredient</th>
            <th style="width:20%;">Quantity</th>
            <th style="width:25%;">Unit</th>
          </tr>
        </thead>
        <tbody>
          <%
            if (ingredients != null && !ingredients.isEmpty()) {
              for (IngredientItem ing : ingredients) {
                String qty = (ing.getQuantity() != null) ? ing.getQuantity().trim() : "";
                String unit = (ing.getUnit() != null) ? ing.getUnit().trim() : "";
          %>
            <tr>
              <td><%= ing.getIngredientName() %></td>
              <td><%= qty.isEmpty() ? "—" : qty %></td>
              <td><%= unit.isEmpty() ? "—" : unit %></td>
            </tr>
          <%
              }
            } else {
          %>
            <tr>
              <td colspan="3" class="muted">No ingredients recorded for this recipe.</td>
            </tr>
          <%
            }
          %>
        </tbody>
      </table>
    </div>

    <!-- Actions -->
    <div class="form-actions">
      <a class="btn btn-secondary" href="<%=request.getContextPath()%>/RecipeServlet?action=listRecipes">Back</a>
      <a class="btn" href="<%=request.getContextPath()%>/NutritionServlet?action=evaluate&recipeID=<%=recipe.getRecipeID()%>">Evaluate Nutrition</a>

      <!-- Optional: go to edit page -->
      <!--
      <a class="btn" href="<%=request.getContextPath()%>/RecipeServlet?action=edit&recipeID=<%=recipe.getRecipeID()%>">Edit</a>
      -->
    </div>

  </div>
</div>

</body>
</html>
