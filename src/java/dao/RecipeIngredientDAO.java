/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

/**
 *
 * @author haziq
 */
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import util.DBConnection;
import model.Ingredient;

public class RecipeIngredientDAO {

    public List<Ingredient> getByRecipeId(int recipeId) {

        List<Ingredient> list = new ArrayList<>();

        String sql = "SELECT ri.quantity, ri.unit, i.id, i.name " +
                     "FROM recipe_ingredients ri " +
                     "JOIN ingredients i ON ri.ingredient_id = i.id " +
                     "WHERE ri.recipe_id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, recipeId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Ingredient ing = new Ingredient();
                ing.setIngredientId(rs.getInt("ingredientId"));
                ing.setIngredientName(rs.getString("ingredientName"));
                ing.setQuantity(rs.getDouble("quantity"));
                ing.setUnit(rs.getString("unit"));
                list.add(ing);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}
