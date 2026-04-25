<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.Ingredient"%>
<%@page import="model.Recipe"%>
<%@page import="model.User"%>

<%
    request.setAttribute("activePage", "recipes");
    String currentPage = request.getRequestURI();
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    Recipe recipe = (Recipe) request.getAttribute("recipe");
    List<Ingredient> ingredients = (List<Ingredient>) request.getAttribute("ingredients");
    List<Recipe> searchResults = (List<Recipe>) request.getAttribute("searchResults");
    String searchKeyword = (String) request.getAttribute("searchKeyword");

    String initials = "U";
    if (user.getUserName() != null && !user.getUserName().trim().isEmpty()) {
        String[] parts = user.getUserName().trim().split("\\s+");
        String first = parts[0].substring(0, 1).toUpperCase();
        String second = (parts.length > 1) ? parts[1].substring(0, 1).toUpperCase() : "";
        initials = first + second;
    }

    String energyStatus = "High";
    if (recipe != null && recipe.getTotalEnergy() < 400) {
        energyStatus = "Low";
    } else if (recipe != null && recipe.getTotalEnergy() < 700) {
        energyStatus = "Moderate";
    }

    String proteinStatus = (recipe != null && recipe.getTotalProtein() >= 20) ? "High" : "Moderate";
    String fatStatus = (recipe != null && recipe.getTotalFat() < 10) ? "Low" : "High";
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Nutrition Evaluation</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">
</head>

<body>

<header class="navbar">
    <div class="nav-left">
        <div class="logo">N</div>
        <div>
            <h1>HERNES</h1>
            <span>Nutrition Evaluation</span>
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
        <a class="logout-link" href="${pageContext.request.contextPath}/LoginServlet?action=logout">Logout</a>
    </div>
</header>

<section class="hero">
    <h2>Nutrition Evaluation</h2>
    <p class="desc">Search a recipe, then review the total nutrients and ingredient-by-ingredient contribution.</p>

    <div class="search-box">
        <form action="<%= request.getContextPath() %>/NutritionServlet" method="get" style="display:flex;width:100%;">
            <input type="hidden" name="action" value="searchRecipes">
            <input type="text" name="q" placeholder="Search recipe name..." value="<%= searchKeyword != null ? searchKeyword : "" %>">
            <button type="submit">Search</button>
        </form>
    </div>
</section>

<div class="content">
    <% if (request.getAttribute("errorMessage") != null) { %>
    <div class="error-message"><%= request.getAttribute("errorMessage") %></div>
    <% } %>

    <% if (searchResults != null) { %>
    <div class="section-title">Recipe Search Results</div>
    <div class="table-wrap">
        <table>
            <thead>
                <tr>
                    <th>Recipe ID</th>
                    <th>Recipe Name</th>
                    <th>Instruction</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <% if (!searchResults.isEmpty()) {
                    for (Recipe result : searchResults) { %>
                <tr>
                    <td><%= result.getRecipeID() %></td>
                    <td><%= result.getRecipeName() %></td>
                    <td><%= result.getInstruction() %></td>
                    <td>
                        <a class="btn" href="<%= request.getContextPath() %>/NutritionServlet?action=evaluate&recipeID=<%= result.getRecipeID() %>">
                            Evaluate Nutrition
                        </a>
                    </td>
                </tr>
                <%  }
                   } else { %>
                <tr>
                    <td colspan="4" class="muted">No recipe matched your search.</td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
    <% } %>

    <div class="top-row">
        <div class="muted">
            Recipe:
            <strong><%= (recipe != null) ? recipe.getRecipeName() : "No recipe selected" %></strong>
        </div>
        <a class="btn btn-secondary" href="<%= request.getContextPath() %>/RecipeServlet?action=listRecipes">Back to Recipes</a>
    </div>

    <% if (recipe != null) { %>
    <div class="cards">
        <div class="card">
            <h4>Calories</h4>
            <p><%= recipe.getTotalEnergy() %> kcal</p>
        </div>
        <div class="card">
            <h4>Protein</h4>
            <p><%= recipe.getTotalProtein() %> g</p>
        </div>
        <div class="card">
            <h4>Fat</h4>
            <p><%= recipe.getTotalFat() %> g</p>
        </div>
        <div class="card">
            <h4>Carbs</h4>
            <p><%= recipe.getTotalCarb() %> g</p>
        </div>
    </div>

    <div class="section-title">Nutrition Summary</div>
    <div class="table-wrap">
        <table>
            <thead>
                <tr>
                    <th>Nutrient</th>
                    <th>Unit</th>
                    <th>Total Value</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>Energy</td>
                    <td>kcal</td>
                    <td><%= recipe.getTotalEnergy() %></td>
                    <td><span class="status-pill"><%= energyStatus %></span></td>
                </tr>
                <tr>
                    <td>Protein</td>
                    <td>g</td>
                    <td><%= recipe.getTotalProtein() %></td>
                    <td><span class="status-pill"><%= proteinStatus %></span></td>
                </tr>
                <tr>
                    <td>Fat</td>
                    <td>g</td>
                    <td><%= recipe.getTotalFat() %></td>
                    <td><span class="status-pill"><%= fatStatus %></span></td>
                </tr>
                <tr>
                    <td>Carbohydrate</td>
                    <td>g</td>
                    <td><%= recipe.getTotalCarb() %></td>
                    <td><span class="status-pill">Tracked</span></td>
                </tr>
            </tbody>
        </table>
    </div>

    <div class="section-title">Ingredient Nutrient Details</div>
    <div class="table-wrap">
        <table>
            <thead>
                <tr>
                    <th>Ingredient</th>
                    <th>Original Qty</th>
                    <th>Qty in Gram</th>
                    <th>Energy (kcal)</th>
                    <th>Protein (g)</th>
                    <th>Fat (g)</th>
                    <th>Carb (g)</th>
                </tr>
            </thead>
            <tbody>
                <%
                    if (ingredients != null && !ingredients.isEmpty()) {
                        for (Ingredient ing : ingredients) {
                %>
                <tr>
                    <td><%= ing.getIngredientName() %></td>
                    <td><%= ing.getQuantity() %> <%= (ing.getUnit() != null) ? ing.getUnit() : "" %></td>
                    <td><%= ing.getQuantityInGram() %> g</td>
                    <td><%= ing.getTotalEnergy() %></td>
                    <td><%= ing.getTotalProtein() %></td>
                    <td><%= ing.getTotalFat() %></td>
                    <td><%= ing.getTotalCarb() %></td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="7" class="muted">No ingredient nutrient details are available for this recipe.</td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </div>
    <% } %>
</div>

</body>
</html>
