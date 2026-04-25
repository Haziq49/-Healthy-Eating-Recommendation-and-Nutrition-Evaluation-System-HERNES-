<%-- 
    Document   : recipeAdd
    Created on : 19 Jan 2026, 4:13:52 PM
    Author     : haziq
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User"%>

<%
    request.setAttribute("activePage", "recipes");
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
    <title>Add Recipe | HERNES</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">
    
        <script>
                function addIngredientRow(){
                    const wrap = document.getElementById("ingredientsWrap");
                    const div = document.createElement("div");
                    div.className = "ingredient-row";
                    div.style = "display:flex; gap:10px; margin-bottom:10px;";
                    div.innerHTML = `
                        <input type="text" name="ingredientName" placeholder="Ingredient name" required style="flex:2;">
                        <input type="number" name="quantity" placeholder="Qty"step="0.01" min="0" required style="flex:1;">
                        <select name="unit" required style="flex:1;">
                            <option value="">Unit</option>
                            <option value="g">g</option>
                            <option value="kg">kg</option>
                            <option value="ml">ml</option>
                            <option value="l">l</option>
                            <option value="tsp">tsp</option>
                            <option value="tbsp">tbsp</option>
                            <option value="cup">cup</option>
                            <option value="pcs">pcs</option>
                        </select>
                        <button type="button" onclick="removeRow(this)">X</button>
                    `;
                    wrap.appendChild(div);
                }
                function removeRow(btn){
                    const row = btn.closest(".ingredient-row");
                    const wrap = document.getElementById("ingredientsWrap");
                    if (wrap.children.length > 1) row.remove(); // keep at least 1 row
                }
        </script>
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

    <a href="${pageContext.request.contextPath}/user/recipeList.jsp"
       class="<%= currentPage.contains("recipe") ? "active" : "" %>">
        🍴 Recipes
    </a>

    <a href="#"
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
    <p class="welcome">➕ Add New Recipe</p>
    <h2>Create Recipe</h2>
    <p class="desc">Fill in the details and save your recipe.</p>
</section>

<div class="content">
    <div class="card">

        <!-- ===== Form ===== -->
        <form action="${pageContext.request.contextPath}/RecipeServlet" method="post">
            <input type="hidden" name="action" value="addRecipe">

            <div class="row">
                <div class="col form-group">
                    <label for="recipeName">Recipe Name</label>
                    <input id="recipeName" type="text" name="recipeName" required value="${param.recipeName}">
                </div>
            </div>

            <div class="form-group">
                <label for="instruction">Instruction</label>
                <textarea id="instruction" name="instruction" required>${param.instruction}</textarea>
            </div>

            <h3 style="margin-top:16px;">Ingredients</h3>

            <div id="ingredientsWrap">
                <div class="ingredient-row" style="display:flex; gap:10px; margin-bottom:10px;">
                    <input type="text" name="ingredientName" placeholder="Ingredient name" required style="flex:2;">
                    <input type="number" name="quantity" placeholder="Qty"step="0.01" min="0" required style="flex:1;">
                    <select name="unit" required style="flex:1;">
                        <option value="">Unit</option>
                        <option value="g">g (grams)</option>
                        <option value="kg">kg (kilograms)</option>
                        <option value="ml">ml (milliliters)</option>
                        <option value="l">l (liters)</option>
                        <option value="tsp">tsp (teaspoon)</option>
                        <option value="tbsp">tbsp (tablespoon)</option>
                        <option value="cup">cup</option>
                        <option value="pcs">pcs (pieces)</option>
                    </select>
                    <button type="button" onclick="removeRow(this)">X</button>
                </div>
            </div>

            <button type="button" class="btn btn-outline" onclick="addIngredientRow()">+ Add Ingredient</button>
            
            <div class="form-actions">
                <button class="btn" type="submit">Save</button>
                <a class="btn btn-outline" href="<%=request.getContextPath()%>/RecipeServlet?action=listRecipes">Cancel</a>
            </div>
        </form>

    </div>
</div>

</body>
</html>
