<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/components/header.jsp"/>
<jsp:include page="/components/hero.jsp"/>
<p>EVENT SIZE = ${events.size()}</p>
<jsp:include page="/components/event-list.jsp"/>
<jsp:include page="/components/footer.jsp"/>