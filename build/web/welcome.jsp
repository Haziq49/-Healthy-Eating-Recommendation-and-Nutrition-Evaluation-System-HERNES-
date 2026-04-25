<%-- 
    Document   : welcome
    Created on : 18 Jan 2026, 11:04:44 PM
    Author     : haziq
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Welcome to HERNES</title>
        <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">
    </head>
    <body>

        <jsp:include page="/common/header.jsp" />

        <div class="container">
            <main class="main-content welcome-page">
                <div class="welcome-section">
                    <h1>Welcome to HERNES!</h1>
                    <p>
                        The Healthy Eating Recommendation and Nutrition Evaluation System helps users
                        discover nutritious recipes, receive personalized meal recommendations,
                        and make informed dietary choices with expert-verified nutrition data.
                    </p>

                    <div class="welcome-actions">
                        <a href="${pageContext.request.contextPath}/login.jsp"
                           class="btn btn-primary">Login</a>

                        <a href="${pageContext.request.contextPath}/register.jsp"
                           class="btn btn-secondary">Register</a>
                    </div>
                </div>
            </main>
        </div>

        <jsp:include page="/common/footer.jsp" />

    </body>
</html>

