<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="/WEB-INF/views/layouts/header.jsp"/>

<div class="jumbotron bg-light p-5 rounded-3 shadow-sm mb-4">
    <h1 class="display-4">Article Management System</h1>
    <p class="lead">( Mini projet partie 2) web application for managing articles and inventory.</p>
    <hr class="my-4">
    <p>Use this system to create, edit, delete, and search for articles in your inventory.</p>
    <a class="btn btn-primary btn-lg" href="<c:url value='/articles'/>" role="button">
        <i class="bi bi-grid me-1"></i>View Articles
    </a>
</div>

<div class="row">
    <div class="col-md-4 mb-4">
        <div class="card h-100 shadow-sm">
            <div class="card-body text-center">
                <i class="bi bi-grid-3x3-gap display-4 text-primary mb-3"></i>
                <h3 class="card-title">Manage Articles</h3>
                <p class="card-text">Create, view, edit, and delete articles in your inventory.</p>
                <a href="<c:url value='/articles'/>" class="btn btn-outline-primary">Go to Articles</a>
            </div>
        </div>
    </div>
    
    <div class="col-md-4 mb-4">
        <div class="card h-100 shadow-sm">
            <div class="card-body text-center">
                <i class="bi bi-search display-4 text-primary mb-3"></i>
                <h3 class="card-title">Search Articles</h3>
                <p class="card-text">Use our advanced search functionality to find specific articles.</p>
                <a href="<c:url value='/articles/search'/>" class="btn btn-outline-primary">Search Articles</a>
            </div>
        </div>
    </div>
    
    <div class="col-md-4 mb-4">
        <div class="card h-100 shadow-sm">
            <div class="card-body text-center">
                <i class="bi bi-plus-circle display-4 text-primary mb-3"></i>
                <h3 class="card-title">Add New Article</h3>
                <p class="card-text">Quickly add a new article to your inventory.</p>
                <a href="<c:url value='/articles/create'/>" class="btn btn-outline-primary">Add Article</a>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/views/layouts/footer.jsp"/>