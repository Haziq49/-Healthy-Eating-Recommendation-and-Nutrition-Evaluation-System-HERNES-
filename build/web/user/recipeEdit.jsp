<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.IngredientItem,model.Recipe,model.User" %>

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

    Recipe r = (Recipe) request.getAttribute("recipe");
    if (r == null) {
        response.sendRedirect(request.getContextPath() + "/RecipeServlet?action=listRecipes");
        return;
    }

    List<IngredientItem> ingredients = (List<IngredientItem>) request.getAttribute("ingredients");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Recipe | HERNES</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">

    <script>
        function addIngredientRow(name = '', quantity = '', unit = '') {
    const wrap = document.getElementById("ingredientsWrap");
    const div = document.createElement("div");
    div.className = "ingredient-row";
    div.innerHTML = `
        <input type="text" name="ingredientName" placeholder="Ingredient name" required style="flex:2;" value="\${name}">
        <input type="number" name="quantity" placeholder="Qty" step="0.01" min="0" required style="flex:1;" value="\${quantity}">
        <select name="unit" required style="flex:1;">
            <option value="">Unit</option>
            <option value="g" \${unit === 'g' ? 'selected' : ''}>g</option>
            <option value="kg" \${unit === 'kg' ? 'selected' : ''}>kg</option>
            <option value="ml" \${unit === 'ml' ? 'selected' : ''}>ml</option>
            <option value="l" \${unit === 'l' ? 'selected' : ''}>l</option>
            <option value="tsp" \${unit === 'tsp' ? 'selected' : ''}>tsp</option>
            <option value="tbsp" \${unit === 'tbsp' ? 'selected' : ''}>tbsp</option>
            <option value="cup" \${unit === 'cup' ? 'selected' : ''}>cup</option>
            <option value="pcs" \${unit === 'pcs' ? 'selected' : ''}>pcs</option>
        </select>
        <button type="button" class="remove-btn" onclick="removeRow(this)">X</button>
    `;
    wrap.appendChild(div);
}

        function removeRow(btn) {
            const wrap = document.getElementById("ingredientsWrap");
            if (wrap.children.length > 1) {
                btn.closest(".ingredient-row").remove();
            }
        }
    </script>
</head>

<body>

<header class="navbar">
    <div class="nav-left">
        <div class="logo">R</div>
        <div>
            <h1>HERNES</h1>
            <span>Healthy Eating Recommendation & Nutrition Evaluation</span>
        </div>
    </div>

    <nav class="nav-center">
        <a href="${pageContext.request.contextPath}/user/dashboard.jsp"
           class="<%= currentPage.endsWith("dashboard.jsp") ? "active" : "" %>">Home</a>
        <a href="<%= request.getContextPath() %>/RecipeServlet?action=listRecipes"
           class="<%= currentPage.contains("recipe") ? "active" : "" %>">Recipes</a>
        <a href="<%= request.getContextPath() %>/NutritionServlet?action=home"
           class="<%= currentPage.contains("nutrition") ? "active" : "" %>">Nutrition Tracker</a>
    </nav>

    <div class="nav-right">
        <div class="avatar"><%= initials %></div>
        <a href="<%= request.getContextPath() %>/LoginServlet?action=logout" class="logout-link">Logout</a>
    </div>
</header>

<section class="hero">
    <p class="welcome">Edit Recipe</p>
    <h2>Update Recipe</h2>
    <p class="desc">Modify recipe details and ingredients, then save your changes.</p>
</section>

<div class="content">
    <div class="card">
        <form action="<%= request.getContextPath() %>/RecipeServlet" method="post">
            <input type="hidden" name="action" value="updateRecipe">
            <input type="hidden" name="recipeID" value="<%= r.getRecipeID() %>">

            <div class="row">
                <div class="col">
                    <label>Recipe ID (readonly)</label>
                    <input type="text" value="<%= r.getRecipeID() %>" readonly>
                </div>
                <div class="col">
                    <label for="recipeName">Recipe Name</label>
                    <input id="recipeName" type="text" name="recipeName" value="<%= r.getRecipeName() %>" required>
                </div>
            </div>

            <label for="instruction">Instruction</label>
            <textarea id="instruction" name="instruction" required><%= r.getInstruction() %></textarea>

            <label>Ingredients</label>
            <div id="ingredientsWrap">
                <%
                    if (ingredients != null && !ingredients.isEmpty()) {
                        for (IngredientItem ing : ingredients) {
                %>
                <div class="ingredient-row">
                    <input type="text" name="ingredientName" placeholder="Ingredient name" required style="flex:2;"
                           value="<%= ing.getIngredientName() %>">
                    <input type="number" name="quantity" placeholder="Qty" step="0.01" min="0" required style="flex:1;"
                           value="<%= ing.getQuantity() %>">
                    <select name="unit" required style="flex:1;">
                        <option value="">Unit</option>
                        <option value="g" <%= "g".equals(ing.getUnit()) ? "selected" : "" %>>g</option>
                        <option value="kg" <%= "kg".equals(ing.getUnit()) ? "selected" : "" %>>kg</option>
                        <option value="ml" <%= "ml".equals(ing.getUnit()) ? "selected" : "" %>>ml</option>
                        <option value="l" <%= "l".equals(ing.getUnit()) ? "selected" : "" %>>l</option>
                        <option value="tsp" <%= "tsp".equals(ing.getUnit()) ? "selected" : "" %>>tsp</option>
                        <option value="tbsp" <%= "tbsp".equals(ing.getUnit()) ? "selected" : "" %>>tbsp</option>
                        <option value="cup" <%= "cup".equals(ing.getUnit()) ? "selected" : "" %>>cup</option>
                        <option value="pcs" <%= "pcs".equals(ing.getUnit()) ? "selected" : "" %>>pcs</option>
                    </select>
                    <button type="button" class="remove-btn" onclick="removeRow(this)">X</button>
                </div>
                <%
                        }
                    } else {
                %>
                <div class="ingredient-row">
                    <input type="text" name="ingredientName" placeholder="Ingredient name" required style="flex:2;">
                    <input type="number" name="quantity" placeholder="Qty" step="0.01" min="0" required style="flex:1;">
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
                    <button type="button" class="remove-btn" onclick="removeRow(this)">X</button>
                </div>
                <%
                    }
                %>
            </div>

            <div class="actions">
                <button type="button" class="btn btn-outline" onclick="addIngredientRow()">+ Add Ingredient</button>
            </div>

            <div class="actions">
                <button class="btn" type="submit">Update</button>
                <a class="btn btn-outline" href="<%= request.getContextPath() %>/RecipeServlet?action=listRecipes">Cancel</a>
            </div>
        </form>
    </div>
</div>

</body>
</html>
