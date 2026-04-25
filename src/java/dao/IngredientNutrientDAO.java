/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */


/**
 *
 * @author haziq
 */
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Ingredient;
import util.DBConnection;

public class IngredientNutrientDAO {

    public List<Ingredient> getIngredientsByRecipeId(int recipeId) {
        // Prefer MyFCD normalized lookup. If MyFCD tables are unavailable, fallback
        // to legacy nutrient columns on the ingredient table.
        List<Ingredient> ingredients = getFromMyfcd(recipeId);
        if (!ingredients.isEmpty()) {
            return ingredients;
        }

        return getFromLegacyIngredientColumns(recipeId);
    }

        private List<Ingredient> getFromMyfcd(int recipeId) {
        String sql =
            "SELECT i.IngredientID, "
            + "       i.IngredientName, "
            + "       ri.Quantity, "
            + "       ri.Unit, "
            + "       COALESCE(MAX(CASE WHEN sn.name = 'Energy' THEN inu.value_per_100g END), 0) AS EnergyPer100g, "
            + "       COALESCE(MAX(CASE WHEN sn.name = 'Protein' THEN inu.value_per_100g END), 0) AS ProteinPer100g, "
            + "       COALESCE(MAX(CASE WHEN sn.name = 'Fat' THEN inu.value_per_100g END), 0) AS FatPer100g, "
            + "       COALESCE(MAX(CASE WHEN sn.name = 'Carbohydrate' THEN inu.value_per_100g END), 0) AS CarbPer100g "
            + "FROM recipeingredient ri "
            + "JOIN ingredient i ON i.IngredientID = ri.IngredientID "
            + "LEFT JOIN ingredientnutrients inu ON inu.IngredientID = i.IngredientID "
            + "LEFT JOIN sub_nutrients sn ON sn.SubNutrientID = inu.SubNutrientID "
            + "WHERE ri.RecipeID = ? "
            + "GROUP BY i.IngredientID, i.IngredientName, ri.Quantity, ri.Unit";

        return executeIngredientQuery(recipeId, sql);
    }

    private List<Ingredient> getFromLegacyIngredientColumns(int recipeId) {
        String sql =
                "SELECT i.IngredientID, "
                + "i.IngredientName, "
                + "ri.Quantity, "
                + "ri.Unit, "
                + "COALESCE(i.EnergyPer100g, 0) AS EnergyPer100g, "
                + "COALESCE(i.ProteinPer100g, 0) AS ProteinPer100g, "
                + "COALESCE(i.FatPer100g, 0) AS FatPer100g, "
                + "COALESCE(i.CarbPer100g, 0) AS CarbPer100g "
                + "FROM recipeingredient ri "
                + "JOIN ingredient i ON i.IngredientID = ri.IngredientID "
                + "WHERE ri.RecipeID = ?";

        return executeIngredientQuery(recipeId, sql);
    }

    private List<Ingredient> executeIngredientQuery(int recipeId, String sql) {
        List<Ingredient> ingredients = new ArrayList<Ingredient>();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, recipeId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Ingredient ingredient = new Ingredient();
                    ingredient.setIngredientId(rs.getInt("IngredientID"));
                    ingredient.setIngredientName(rs.getString("IngredientName"));
                    ingredient.setQuantity(parseQuantity(rs.getString("Quantity")));
                    ingredient.setUnit(rs.getString("Unit"));
                    ingredient.setEnergyPer100g(rs.getDouble("EnergyPer100g"));
                    ingredient.setProteinPer100g(rs.getDouble("ProteinPer100g"));
                    ingredient.setFatPer100g(rs.getDouble("FatPer100g"));
                    ingredient.setCarbPer100g(rs.getDouble("CarbPer100g"));
                    ingredients.add(ingredient);
                }
            }

        } catch (SQLException e) {
            return new ArrayList<Ingredient>();
        }

        return ingredients;
    }

    private double parseQuantity(String quantity) {
        if (quantity == null || quantity.trim().isEmpty()) {
            return 0;
        }

        try {
            return Double.parseDouble(quantity.trim());
        } catch (NumberFormatException e) {
            return 0;
        }
    }
}
