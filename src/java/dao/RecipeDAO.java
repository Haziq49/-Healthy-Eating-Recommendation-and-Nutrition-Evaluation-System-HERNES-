/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

/**
 *
 * @author haziq
 */

import model.Recipe;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.IngredientItem;

public class RecipeDAO {

    /**
     * Insert recipe (recipeID is AUTO_INCREMENT).
     * Returns generated recipeID if success, otherwise -1.
     */
    public int addRecipe(Recipe r) {
        String sql = "INSERT INTO recipe (RecipeName, Instructions) VALUES (?, ?)";

        try (Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);) {

            ps.setString(1, r.getRecipeName());
            ps.setString(2, r.getInstruction());

            int affected = ps.executeUpdate();
            if (affected == 0) return -1;

            // get generated id
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                }
            }
            return -1;

        } catch (SQLException e) {
            e.printStackTrace();
            return -1;
        }
    }

    public List<Recipe> getAllRecipes() {
        List<Recipe> list = new ArrayList<>();
        String sql = "SELECT recipeID, RecipeName, Instructions FROM recipe ORDER BY recipeID DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Recipe r = new Recipe();
                r.setRecipeID(rs.getInt("recipeID"));
                r.setRecipeName(rs.getString("RecipeName"));
                r.setInstruction(rs.getString("Instructions"));
                list.add(r);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    

    public Recipe getRecipeById(int recipeID) {
        String sql = "SELECT recipeID, RecipeName, Instructions FROM recipe WHERE recipeID = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, recipeID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Recipe r = new Recipe();
                    r.setRecipeID(rs.getInt("recipeID"));
                    r.setRecipeName(rs.getString("RecipeName"));
                    r.setInstruction(rs.getString("Instructions"));
                    return r;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    

    public boolean updateRecipe(Recipe r) {
        String sql = "UPDATE recipe SET RecipeName = ?, Instructions = ? WHERE recipeID = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, r.getRecipeName());
            ps.setString(2, r.getInstruction());
            ps.setInt(3, r.getRecipeID());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteRecipe(int recipeID) {
        String sql = "DELETE FROM recipe WHERE recipeID = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, recipeID);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Optional: search recipes by name (used by your dashboard search box).
     */
    public List<Recipe> searchByName(String keyword) {
        List<Recipe> list = new ArrayList<>();
        String sql = "SELECT recipeID, RecipeName, Instructions FROM recipe WHERE recipeName LIKE ? ORDER BY recipeID DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, "%" + keyword + "%");

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Recipe r = new Recipe();
                    r.setRecipeID(rs.getInt("recipeID"));
                    r.setRecipeName(rs.getString("RecipeName"));
                    r.setInstruction(rs.getString("Instructions"));
                    list.add(r);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
        public int findIngredientIdByName(String name) {
        String sql = "SELECT IngredientID FROM ingredient WHERE IngredientName = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("IngredientID");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
            public int insertIngredient(String name) {
        String sql = "INSERT INTO ingredient (IngredientName) VALUES (?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, name);
            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
                public boolean insertRecipeIngredient(int recipeId, int ingredientId, String quantity, String unit) {
        String sql = "INSERT INTO recipeingredient (RecipeID, IngredientID, Quantity, Unit) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, recipeId);
            ps.setInt(2, ingredientId);

            if (quantity == null || quantity.isEmpty()) ps.setNull(3, java.sql.Types.VARCHAR);
            else ps.setString(3, quantity);

            if (unit == null || unit.isEmpty()) ps.setNull(4, java.sql.Types.VARCHAR);
            else ps.setString(4, unit);

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    public List<IngredientItem> getIngredientsByRecipeId(int recipeID) {
    List<IngredientItem> list = new ArrayList<>();

    String sql =
        "SELECT i.IngredientName AS ingredientName, " +
        "       ri.Quantity AS quantity, " +
        "       ri.Unit AS unit " +
        "FROM recipeingredient ri " +
        "JOIN ingredient i ON i.IngredientID = ri.IngredientID " +
        "WHERE ri.RecipeID = ?";

    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setInt(1, recipeID);

        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                IngredientItem item = new IngredientItem();
                item.setIngredientName(rs.getString("ingredientName"));
                item.setQuantity(rs.getString("quantity"));
                item.setUnit(rs.getString("unit"));
                list.add(item);
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

    return list;
    }

    public boolean deleteRecipeIngredients(int recipeId) {
        String sql = "DELETE FROM recipeingredient WHERE RecipeID = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, recipeId);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}



