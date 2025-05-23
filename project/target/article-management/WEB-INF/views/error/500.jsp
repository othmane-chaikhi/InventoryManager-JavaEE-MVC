<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="../layouts/header.jsp"/>

<div class="row justify-content-center my-5">
    <div class="col-md-6 text-center">
        <div class="card shadow border-danger">
            <div class="card-body">
                <h1 class="display-1 text-danger">500</h1>
                <h2 class="mb-4">Internal Server Error</h2>
                <p class="lead mb-4">Sorry, something went wrong on our end. Please try again later.</p>
                <a href="<c:url value='/'/>" class="btn btn-primary">
                    <i class="bi bi-house-door me-1"></i>Go to Home
                </a>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../layouts/footer.jsp"/>