<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="../layouts/header.jsp"/>

<div class="row mb-4">
    <div class="col">
        <h2 class="mb-4"><i class="bi bi-grid-3x3-gap me-2"></i>Articles</h2>
        <div class="btn-toolbar">
            <a href="<c:url value='/articles/create'/>" class="btn btn-primary">
                <i class="bi bi-plus-lg me-1"></i>New Article
            </a>
            <a href="<c:url value='/articles/search'/>" class="btn btn-outline-secondary ms-2">
                <i class="bi bi-search me-1"></i>Advanced Search
            </a>
        </div>
    </div>
</div>

<div class="card shadow">
    <div class="card-body">
        <div class="table-responsive">
            <table class="table table-striped table-hover">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Description</th>
                        <th>Category</th>
                        <th>Price</th>
                        <th>Stock</th>
                        <th>Last Updated</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty articles}">
                            <tr>
                                <td colspan="7" class="text-center">No articles found</td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="article" items="${articles}">
                                <tr>
                                    <td>${article.id}</td>
                                    <td>${article.description}</td>
                                    <td>
                                        <c:if test="${not empty article.category}">
                                            <span class="badge bg-secondary">${article.category}</span>
                                        </c:if>
                                    </td>
                                    <td>
                                        <fmt:formatNumber value="${article.price}" type="currency" currencySymbol="$" />
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${article.stockQuantity > 10}">
                                                <span class="badge bg-success">${article.stockQuantity}</span>
                                            </c:when>
                                            <c:when test="${article.stockQuantity > 0}">
                                                <span class="badge bg-warning">${article.stockQuantity}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-danger">Out of stock</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <fmt:formatDate value="${article.updatedAt}" pattern="yyyy-MM-dd HH:mm" />
                                    </td>
                                    <td>
                                        <div class="btn-group" role="group">
                                            <a href="<c:url value='/articles/edit?id=${article.id}'/>" class="btn btn-sm btn-outline-primary">
                                                <i class="bi bi-pencil"></i>
                                            </a>
                                            <button type="button" class="btn btn-sm btn-outline-danger" 
                                                    data-bs-toggle="modal" data-bs-target="#deleteModal${article.id}">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </div>
                                        
                                        <!-- Delete Confirmation Modal -->
                                        <div class="modal fade" id="deleteModal${article.id}" tabindex="-1" aria-hidden="true">
                                            <div class="modal-dialog">
                                                <div class="modal-content">
                                                    <div class="modal-header">
                                                        <h5 class="modal-title">Confirm Delete</h5>
                                                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                    </div>
                                                    <div class="modal-body">
                                                        Are you sure you want to delete article "${article.description}"?
                                                    </div>
                                                    <div class="modal-footer">
                                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                                        <form action="<c:url value='/articles/delete'/>" method="post">
                                                            <input type="hidden" name="id" value="${article.id}">
                                                            <button type="submit" class="btn btn-danger">Delete</button>
                                                        </form>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>
</div>

<jsp:include page="../layouts/footer.jsp"/>