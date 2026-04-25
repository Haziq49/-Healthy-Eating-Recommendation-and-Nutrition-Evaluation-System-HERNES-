/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.RecipeDAO;
import model.Recipe;
import model.User;

import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.IngredientItem;

public class RecipeServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(RecipeServlet.class.getName());
    private RecipeDAO recipeDAO;

    @Override
    public void init() throws ServletException {
        recipeDAO = new RecipeDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            LOGGER.log(Level.WARNING, "No action parameter provided in RecipeServlet POST request.");
            request.setAttribute("errorMessage", "Invalid request: No action specified.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
            return;
        }

        switch (action) {
            case "addRecipe":
                handleAddRecipe(request, response);
                break;
            case "updateRecipe":
                handleUpdateRecipe(request, response);
                break;
            case "deleteRecipe":
                handleDeleteRecipe(request, response);
                break;
            default:
                LOGGER.log(Level.WARNING, "Unknown POST action: {0}", action);
                request.setAttribute("errorMessage", "Invalid action: " + action);
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                break;
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null) {
            LOGGER.log(Level.INFO, "No action provided in GET; defaulting to listRecipes.");
            handleListRecipes(request, response);
            return;
        }

        switch (action) {
            case "viewRecipeDetail":
                handleViewRecipeDetail(request, response);
                break;
            case "listRecipes":
                handleListRecipes(request, response);
                break;
            case "addRecipePage":
                handleAddRecipePage(request, response);
                break;
            case "editRecipePage":
                handleEditRecipePage(request, response);
                break;
            case "searchRecipes":
                handleSearchRecipes(request, response);
                break;
            default:
                LOGGER.log(Level.WARNING, "Unknown GET action: {0}", action);
                request.setAttribute("errorMessage", "Invalid action: " + action);
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                break;
        }
    }

    // =========================
    // Session / Auth Protection
    // =========================
    private User requireLogin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        User loggedInUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (loggedInUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
        return loggedInUser;
    }

    // =========================
    // GET Handlers
    // =========================
    
    private void handleListRecipes(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User loggedInUser = requireLogin(request, response);
        if (loggedInUser == null) return;

        List<Recipe> recipes = recipeDAO.getAllRecipes();
        request.setAttribute("recipes", recipes);

        request.getRequestDispatcher("/user/recipeList.jsp").forward(request, response);
    }
    
        private void handleViewRecipeDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User loggedInUser = requireLogin(request, response);
        if (loggedInUser == null) return;

        String recipeIDParam = request.getParameter("recipeID");
        if (recipeIDParam == null || recipeIDParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/RecipeServlet?action=listRecipes");
            return;
        }

        int recipeID;
        try {
            recipeID = Integer.parseInt(recipeIDParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/RecipeServlet?action=listRecipes");
            return;
        }

        Recipe recipe = recipeDAO.getRecipeById(recipeID);
        List<IngredientItem> ingredients = recipeDAO.getIngredientsByRecipeId(recipeID);

        request.setAttribute("recipe", recipe);
        request.setAttribute("ingredients", ingredients);

        request.getRequestDispatcher("/user/recipeDetail.jsp").forward(request, response);
    }



    private void handleAddRecipePage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User loggedInUser = requireLogin(request, response);
        if (loggedInUser == null) return;

        request.getRequestDispatcher("/user/recipeAdd.jsp").forward(request, response);

    }

    private void handleEditRecipePage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User loggedInUser = requireLogin(request, response);
        if (loggedInUser == null) return;

        String recipeIDParam = request.getParameter("recipeID");
        if (isBlank(recipeIDParam)) {
            request.setAttribute("errorMessage", "Recipe ID is missing for editing.");
            response.sendRedirect(request.getContextPath() + "/RecipeServlet?action=listRecipes");
            return;
        }

        int recipeID;
        try {
            recipeID = Integer.parseInt(recipeIDParam);
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid recipeID format: " + recipeIDParam, e);
            request.setAttribute("errorMessage", "Invalid Recipe ID.");
            response.sendRedirect(request.getContextPath() + "/RecipeServlet?action=listRecipes");
            return;
        }

        Recipe recipe = recipeDAO.getRecipeById(recipeID);
        if (recipe == null) {
            request.setAttribute("errorMessage", "Recipe not found.");
            response.sendRedirect(request.getContextPath() + "/RecipeServlet?action=listRecipes");
            return;
        }

        List<IngredientItem> ingredients = recipeDAO.getIngredientsByRecipeId(recipeID);
        request.setAttribute("recipe", recipe);
        request.setAttribute("ingredients", ingredients);
        request.getRequestDispatcher("/user/recipeEdit.jsp").forward(request, response);

    }

    private void handleSearchRecipes(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User loggedInUser = requireLogin(request, response);
        if (loggedInUser == null) return;

        String keyword = request.getParameter("q");
        if (keyword != null) keyword = keyword.trim();

        List<Recipe> results;
        if (keyword != null && !keyword.isEmpty()) {
            // ✅ Use DAO search (recommended)
            results = recipeDAO.searchByName(keyword);
        } else {
            results = recipeDAO.getAllRecipes();
        }

        request.setAttribute("recipes", results);
        request.setAttribute("searchKeyword", keyword);
        request.getRequestDispatcher("/user/recipeList.jsp").forward(request, response);

    }

    // =========================
    // POST Handlers
    // =========================
    private void handleAddRecipe(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User loggedInUser = requireLogin(request, response);
        if (loggedInUser == null) return;

        // ✅ No recipeID from user anymore
        String recipeName = request.getParameter("recipeName");
        String instruction = request.getParameter("instruction");

        if (isBlank(recipeName) || isBlank(instruction)) {
            request.setAttribute("errorMessage", "Please fill in Recipe Name and Instruction.");
            request.getRequestDispatcher("/user/recipeAdd.jsp").forward(request, response);
            return;
        }

        Recipe newRecipe = new Recipe();
        newRecipe.setRecipeName(recipeName.trim());
        newRecipe.setInstruction(instruction.trim());
        

        int newId = recipeDAO.addRecipe(newRecipe);
        if (newId > 0) {
                    // Read ingredient arrays from form
            String[] ingredientNames = request.getParameterValues("ingredientName");
            String[] quantities = request.getParameterValues("quantity");
            String[] units = request.getParameterValues("unit");

            // If user didn’t add any ingredient rows (shouldn’t happen if required, but still safe)
            if (ingredientNames != null) {
                for (int i = 0; i < ingredientNames.length; i++) {
                    String ingName = (ingredientNames[i] == null) ? "" : ingredientNames[i].trim();
                    if (ingName.isEmpty()) continue;

                    String qty = (quantities != null && i < quantities.length && quantities[i] != null)
                            ? quantities[i].trim() : null;

                    String unit = (units != null && i < units.length && units[i] != null)
                            ? units[i].trim() : null;

                    // 1) get existing ingredientId or create a new one
                    int ingredientId = recipeDAO.findIngredientIdByName(ingName);
                    if (ingredientId == 0) {
                        ingredientId = recipeDAO.insertIngredient(ingName);
                    }

                    // 2) insert into recipeingredient (junction)
                    recipeDAO.insertRecipeIngredient(newId, ingredientId, qty, unit);
                }
            }
            // optional: message using session (survives redirect)
            HttpSession session = request.getSession();
            session.setAttribute("successMessage", "Recipe added successfully (ID: " + newId + ").");
            response.sendRedirect(request.getContextPath() + "/RecipeServlet?action=listRecipes");
        } else {
            request.setAttribute("errorMessage", "Failed to add recipe. Please try again.");
            request.getRequestDispatcher("/user/recipeAdd.jsp").forward(request, response);

        }
    }

    private void handleUpdateRecipe(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User loggedInUser = requireLogin(request, response);
        if (loggedInUser == null) return;

        String recipeIDParam = request.getParameter("recipeID");
        String recipeName = request.getParameter("recipeName");
        String instruction = request.getParameter("instruction");
        String[] ingredientNames = request.getParameterValues("ingredientName");
        String[] quantities = request.getParameterValues("quantity");
        String[] units = request.getParameterValues("unit");

        if (isBlank(recipeIDParam) || isBlank(recipeName) || isBlank(instruction)) {
            request.setAttribute("errorMessage", "Please fill in all required fields.");
            request.getRequestDispatcher("/user/recipeEdit.jsp").forward(request, response);
            return;
        }

        int recipeID;
        try {
            recipeID = Integer.parseInt(recipeIDParam.trim());
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid recipeID format on update: " + recipeIDParam, e);
            request.setAttribute("errorMessage", "Invalid Recipe ID.");
            request.getRequestDispatcher("/user/recipeEdit.jsp").forward(request, response);
            return;
        }

        Recipe updated = new Recipe();
        updated.setRecipeID(recipeID);
        updated.setRecipeName(recipeName.trim());
        updated.setInstruction(instruction.trim());

        boolean success = recipeDAO.updateRecipe(updated);
        if (success) {
            recipeDAO.deleteRecipeIngredients(recipeID);

            if (ingredientNames != null) {
                for (int i = 0; i < ingredientNames.length; i++) {
                    String ingName = (ingredientNames[i] == null) ? "" : ingredientNames[i].trim();
                    if (ingName.isEmpty()) continue;

                    String qty = (quantities != null && i < quantities.length && quantities[i] != null)
                            ? quantities[i].trim() : null;

                    String unit = (units != null && i < units.length && units[i] != null)
                            ? units[i].trim() : null;

                    int ingredientId = recipeDAO.findIngredientIdByName(ingName);
                    if (ingredientId == 0) {
                        ingredientId = recipeDAO.insertIngredient(ingName);
                    }

                    recipeDAO.insertRecipeIngredient(recipeID, ingredientId, qty, unit);
                }
            }

            HttpSession session = request.getSession();
            session.setAttribute("successMessage", "Recipe updated successfully.");
            response.sendRedirect(request.getContextPath() + "/RecipeServlet?action=listRecipes");
        } else {
            request.setAttribute("errorMessage", "Failed to update recipe. Please try again.");
            request.setAttribute("recipe", updated);
            request.setAttribute("ingredients", recipeDAO.getIngredientsByRecipeId(recipeID));
            request.getRequestDispatcher("/user/recipeEdit.jsp").forward(request, response);
        }
    }

    private void handleDeleteRecipe(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User loggedInUser = requireLogin(request, response);
        if (loggedInUser == null) return;

        String recipeIDParam = request.getParameter("recipeID");
        if (isBlank(recipeIDParam)) {
            response.sendRedirect(request.getContextPath() + "/RecipeServlet?action=listRecipes");
            return;
        }

        int recipeID;
        try {
            recipeID = Integer.parseInt(recipeIDParam.trim());
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid recipeID format on delete: " + recipeIDParam, e);
            response.sendRedirect(request.getContextPath() + "/RecipeServlet?action=listRecipes");
            return;
        }

        boolean success = recipeDAO.deleteRecipe(recipeID);
        if (!success) {
            LOGGER.log(Level.WARNING, "Failed to delete recipe: {0}", recipeID);
        }

        response.sendRedirect(request.getContextPath() + "/RecipeServlet?action=listRecipes");
    }

    // =========================
    // Helpers
    // =========================
    private boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }
}


