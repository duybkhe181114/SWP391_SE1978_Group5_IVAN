<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>IVAN - Home</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/base.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/layout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
</head>
<body>
<jsp:include page="/components/header.jsp"/>
<jsp:include page="/components/hero.jsp"/>
<jsp:include page="/components/event-list.jsp"/>
<jsp:include page="/components/footer.jsp"/>
</body>
</html>