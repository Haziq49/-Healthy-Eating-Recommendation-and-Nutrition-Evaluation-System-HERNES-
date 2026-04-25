/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

/**
 *
 * @author haziq
 */
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Utility class for establishing and managing database connections.
 * This class provides a static method to get a connection to the MySQL database.
 */
public class DBConnection {

    // JDBC driver name and database URL
    private static final String JDBC_DRIVER = "com.mysql.cj.jdbc.Driver";
    private static final String DB_URL = "jdbc:mysql://localhost:3306/pita?useSSL=false&serverTimezone=UTC";

    // Database credentials
    private static final String USER = "root"; // YOUR_DB_USERNAME
    private static final String PASS = ""; // YOUR_DB_PASSWORD

    // Logger for database connection issues
    private static final Logger LOGGER = Logger.getLogger(DBConnection.class.getName());

    /**
     * Establishes and returns a database connection.
     *
     * @return A valid java.sql.Connection object, or null if a connection cannot be established.
     */
    public static Connection getConnection() {
        Connection conn = null;
        try {
            // Register JDBC driver
            Class.forName(JDBC_DRIVER);

            // Open a connection
            LOGGER.log(Level.INFO, "Connecting to database...");
            conn = DriverManager.getConnection(DB_URL, USER, PASS);
            LOGGER.log(Level.INFO, "Database connection established successfully.");
        } catch (SQLException se) {
            // Handle errors for JDBC
            LOGGER.log(Level.SEVERE, "SQLException occurred while connecting to database: " + se.getMessage(), se);
        } catch (Exception e) {
            // Handle errors for Class.forName
            LOGGER.log(Level.SEVERE, "Exception occurred while loading JDBC driver: " + e.getMessage(), e);
        }
        return conn;
    }

    /**
     * Closes the provided database connection.
     *
     * @param conn The Connection object to be closed.
     */
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
                LOGGER.log(Level.INFO, "Database connection closed.");
            } catch (SQLException se) {
                LOGGER.log(Level.SEVERE, "SQLException occurred while closing database connection: " + se.getMessage(), se);
            }
        }
    }
}