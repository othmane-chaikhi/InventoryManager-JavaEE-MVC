<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<jsp:include page="../layouts/header.jsp"/>

<div class="row mb-4">
    <div class="col">
        <h2 class="mb-4"><i class="bi bi-search me-2"></i>Search Articles</h2>
    </div>
</div>

<div class="row">
    <div class="col-lg-4 mb-4">
        <div class="card shadow h-100">
            <div class="card-header bg-primary text-white">
                <h5 class="mb-0">Search Criteria</h5>
            </div>
            <div class="card-body">
                <form action="<c:url value='/articles/search'/>" method="post">
                    <div class="mb-3">
                        <label for="description" class="form-label">Description</label>
                        <input type="text" class="form-control" id="description" name="description" 
                               value="${searchCriteria.description}">
                    </div>
                    
                    <div class="mb-3">
                        <label for="category" class="form-label">Category</label>
                        <select class="form-select" id="category" name="category">
                            <option value="">-- Any Category --</option>
                            <option value="Electronics" ${searchCriteria.category == 'Electronics' ? 'selected' : ''}>Electronics</option>
                            <option value="Clothing" ${searchCriteria.category == 'Clothing' ? 'selected' : ''}>Clothing</option>
                            <option value="Home & Garden" ${searchCriteria.category == 'Home & Garden' ? 'selected' : ''}>Home & Garden</option>
                            <option value="Books" ${searchCriteria.category == 'Books' ? 'selected' : ''}>Books</option>
                            <option value="Sports" ${searchCriteria.category == 'Sports' ? 'selected' : ''}>Sports</option>
                            <option value="Toys" ${searchCriteria.category == 'Toys' ? 'selected' : ''}>Toys</option>
                            <option value="Food" ${searchCriteria.category == 'Food' ? 'selected' : ''}>Food</option>
                            <option value="Other" ${searchCriteria.category == 'Other' ? 'selected' : ''}>Other</option>
                        </select>
                    </div>
                    
                    <div class="row">
                        <div class="col-6 mb-3">
                            <label for="minPrice" class="form-label">Min Price</label>
                            <div class="input-group">
                                <span class="input-group-text">$</span>
                                <input type="number" class="form-control" id="minPrice" name="minPrice" step="0.01" min="0"
                                       value="${searchCriteria.minPrice}">
                            </div>
                        </div>
                        
                        <div class="col-6 mb-3">
                            <label for="maxPrice" class="form-label">Max Price</label>
                            <div class="input-group">
                                <span class="input-group-text">$</span>
                                <input type="number" class="form-control" id="maxPrice" name="maxPrice" step="0.01" min="0"
                                       value="${searchCriteria.maxPrice}">
                            </div>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label for="minStock" class="form-label">Min Stock Quantity</label>
                        <input type="number" class="form-control" id="minStock" name="minStock" min="0"
                               value="${searchCriteria.minStock}">
                    </div>
                    
                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-search me-1"></i>Search
                        </button>
                        <button type="reset" class="btn btn-outline-secondary">
                            <i class="bi bi-arrow-counterclockwise me-1"></i>Reset
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <div class="col-lg-8">
        <div class="card shadow">
            <div class="card-header bg-light">
                <h5 class="mb-0">Search Results</h5>
            </div>
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
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty articles}">
                                    <tr>
                                        <td colspan="6" class="text-center">No articles found matching your criteria</td>
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
                                                <div class="btn-group" role="group">
                                                    <a href="<c:url value='/articles/edit?id=${article.id}'/>" class="btn btn-sm btn-outline-primary">
                                                        <i class="bi bi-pencil"></i>
                                                    </a>
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
            <div class="card-footer">
                <div class="d-flex justify-content-between align-items-center">
                    <span>Total: ${articles.size()} article(s)</span>
                    <a href="<c:url value='/articles'/>" class="btn btn-outline-primary btn-sm">
                        <i class="bi bi-grid me-1"></i>View All Articles
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../layouts/footer.jsp"/>