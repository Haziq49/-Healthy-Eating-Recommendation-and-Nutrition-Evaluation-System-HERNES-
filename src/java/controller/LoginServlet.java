/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.UserDAO;
import model.User;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

//@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(LoginServlet.class.getName());
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null) {
            request.setAttribute("error", "Invalid request: action not provided.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        switch (action) {
            case "login":
                handleLogin(request, response);
                break;

            // (Optional) support logout via POST too
            case "logout":
                handleLogout(request, response);
                break;

            default:
                request.setAttribute("error", "Invalid action: " + action);
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                break;
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null) {
            request.getRequestDispatcher("/welcome.jsp").forward(request, response);
            return;
        }

        switch (action) {
            case "logout":
                handleLogout(request, response);
                break;

            case "loginPage":
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                break;

            case "welcomePage":
                request.getRequestDispatcher("/welcome.jsp").forward(request, response);
                break;

            default:
                request.setAttribute("error", "Unknown action: " + action);
                request.getRequestDispatcher("/welcome.jsp").forward(request, response);
                break;
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Please enter email and password.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        User authenticatedUser = userDAO.authenticateUser(email, password);
        if (authenticatedUser == null) {
            authenticatedUser = authenticateDummyUser(email, password);
        }

        if (authenticatedUser != null) {
            HttpSession session = request.getSession(true);
            session.setAttribute("user", authenticatedUser);

            LOGGER.log(Level.INFO, "Login successful: {0} ({1})",
                    new Object[]{email, authenticatedUser.getRole()});

            // ✅ Redirect to dashboard (ROOT)
            response.sendRedirect(request.getContextPath() + "/user/dashboard.jsp");
        } else {
            request.setAttribute("error", "Invalid email or password.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            LOGGER.log(Level.WARNING, "Login failed for: {0}", email);
        }
    }

    private void handleLogout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
            LOGGER.log(Level.INFO, "User logged out successfully.");
        }

        // ✅ After logout, go back to login page
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }

    private User authenticateDummyUser(String email, String password) {

        if (!"123456".equals(password)) return null;

        if ("user@hernes.com".equalsIgnoreCase(email)) {
            return new User("U01", "Ali User", email, null, "User");
        }

        if ("expert@hernes.com".equalsIgnoreCase(email)) {
            return new User("E01", "Dr. Sara Expert", email, null, "NutritionExpert");
        }

        if ("admin@hernes.com".equalsIgnoreCase(email)) {
            return new User("A01", "System Admin", email, null, "Admin");
        }

        return null;
    }
}


