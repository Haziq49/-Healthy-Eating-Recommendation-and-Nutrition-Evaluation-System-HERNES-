<%-- 
    Document   : index
    Created on : 18 Jan 2026, 10:57:41 PM
    Author     : haziq
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Loading HERNES</title>

    <!-- Redirect to login page -->
    <meta http-equiv="refresh" content="0;url=${pageContext.request.contextPath}/login.jsp">

    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/style.css">
    
</head>
<body class="auth-page">
    <div class="loading-message">
        <h1>Loading HERNES...</h1>
        <p>Healthy Eating Recommendation and Nutrition Evaluation System</p>
        <p>You are being redirected to the login page.</p>
        <p>If you are not redirected automatically, please
            <a href="${pageContext.request.contextPath}/login.jsp">click here</a>.
        </p>
    </div>
</body>
</html>
