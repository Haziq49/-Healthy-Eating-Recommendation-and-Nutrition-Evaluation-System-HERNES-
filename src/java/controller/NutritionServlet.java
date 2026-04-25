/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.IngredientNutrientDAO;
import dao.RecipeDAO;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Ingredient;
import model.Recipe;
import model.User;

public class NutritionServlet extends HttpServlet {

    private IngredientNutrientDAO ingredientDao = new IngredientNutrientDAO();
    private RecipeDAO recipeDao = new RecipeDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User loggedInUser = requireLogin(request, response);
        if (loggedInUser == null) {
            return;
        }

        String action = request.getParameter("action");

        if (action == null) {
            showNutritionHome(request, response);
            return;
        }

        switch (action) {
            case "home":
                showNutritionHome(request, response);
                break;
            case "searchRecipes":
                handleNutritionSearch(request, response);
                break;
            case "evaluate":
                handleNutritionEvaluation(request, response);
                break;
            default:
                showNutritionHome(request, response);
                break;
        }
    }

    private void showNutritionHome(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("searchResults", recipeDao.getAllRecipes());
        request.getRequestDispatcher("/user/nutritionEvaluation.jsp").forward(request, response);
    }

    private void handleNutritionSearch(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("q");
        if (keyword != null) {
            keyword = keyword.trim();
        }

        List<Recipe> recipes;
        if (keyword != null && !keyword.isEmpty()) {
            recipes = recipeDao.searchByName(keyword);
        } else {
            recipes = recipeDao.getAllRecipes();
        }

        request.setAttribute("searchKeyword", keyword);
        request.setAttribute("searchResults", recipes);
        request.getRequestDispatcher("/user/nutritionEvaluation.jsp").forward(request, response);
    }

    private void handleNutritionEvaluation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int recipeId = getRecipeId(request);
            Recipe recipe = recipeDao.getRecipeById(recipeId);

            if (recipe == null) {
                request.setAttribute("searchResults", recipeDao.getAllRecipes());
                request.setAttribute("errorMessage", "Recipe not found.");
                request.getRequestDispatcher("/user/nutritionEvaluation.jsp").forward(request, response);
                return;
            }

            List<Ingredient> ingredients = ingredientDao.getIngredientsByRecipeId(recipeId);
            boolean hasAnyNutrientData = false;

            double totalEnergy = 0;
            double totalProtein = 0;
            double totalFat = 0;
            double totalCarb = 0;

            for (Ingredient ing : ingredients) {
                double qty = convertToGram(ing.getQuantity(), ing.getUnit());
                double ingredientEnergy = round(calculate(qty, ing.getEnergyPer100g()));
                double ingredientProtein = round(calculate(qty, ing.getProteinPer100g()));
                double ingredientFat = round(calculate(qty, ing.getFatPer100g()));
                double ingredientCarb = round(calculate(qty, ing.getCarbPer100g()));

                ing.setQuantityInGram(round(qty));
                ing.setTotalEnergy(ingredientEnergy);
                ing.setTotalProtein(ingredientProtein);
                ing.setTotalFat(ingredientFat);
                ing.setTotalCarb(ingredientCarb);

                if (ing.getEnergyPer100g() > 0
                        || ing.getProteinPer100g() > 0
                        || ing.getFatPer100g() > 0
                        || ing.getCarbPer100g() > 0) {
                    hasAnyNutrientData = true;
                }

                totalEnergy += ingredientEnergy;
                totalProtein += ingredientProtein;
                totalFat += ingredientFat;
                totalCarb += ingredientCarb;
            }

            recipe.setTotalEnergy(round(totalEnergy));
            recipe.setTotalProtein(round(totalProtein));
            recipe.setTotalFat(round(totalFat));
            recipe.setTotalCarb(round(totalCarb));

            request.setAttribute("recipe", recipe);
            request.setAttribute("ingredients", ingredients);
            if (ingredients.isEmpty()) {
                request.setAttribute("errorMessage", "This recipe has no ingredients to evaluate.");
            } else if (!hasAnyNutrientData) {
                request.setAttribute("errorMessage", "No nutrient mapping was found for these ingredients. Check food names in MyFCD import.");
            }
            request.getRequestDispatcher("/user/nutritionEvaluation.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            request.setAttribute("searchResults", recipeDao.getAllRecipes());
            request.setAttribute("errorMessage", "Invalid recipe selected for evaluation.");
            request.getRequestDispatcher("/user/nutritionEvaluation.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Failed to evaluate nutrition.");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    private User requireLogin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        User loggedInUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (loggedInUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }

        return loggedInUser;
    }

    private int getRecipeId(HttpServletRequest request) {
        String recipeIdParam = request.getParameter("recipeID");
        if (recipeIdParam == null || recipeIdParam.trim().isEmpty()) {
            recipeIdParam = request.getParameter("id");
        }
        return Integer.parseInt(recipeIdParam);
    }

    private double calculate(double qtyGram, double per100g) {
        return (qtyGram / 100.0) * per100g;
    }

    private double convertToGram(double qty, String unit) {

        if (unit == null) {
            return qty;
        }

        switch (unit) {
            case "kg":
                return qty * 1000;
            case "g":
                return qty;
            case "ml":
                return qty;
            case "l":
                return qty * 1000;
            case "tbsp":
                return qty * 15;
            case "tsp":
                return qty * 5;
            case "cup":
                return qty * 240;
            case "pcs":
                return qty * 50;
            default:
                return qty;
        }
    }

    private double round(double value) {
        return Math.round(value * 100.0) / 100.0;
    }
}
