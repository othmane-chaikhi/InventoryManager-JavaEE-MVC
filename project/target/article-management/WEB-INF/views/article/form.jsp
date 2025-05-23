<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="../layouts/header.jsp"/>

<div class="row mb-4">
    <div class="col">
        <h2>
            <c:choose>
                <c:when test="${empty article.id}">
                    <i class="bi bi-plus-circle me-2"></i>Create Article
                </c:when>
                <c:otherwise>
                    <i class="bi bi-pencil-square me-2"></i>Edit Article
                </c:otherwise>
            </c:choose>
        </h2>
    </div>
</div>

<div class="row">
    <div class="col-md-8 col-lg-6">
        <div class="card shadow">
            <div class="card-body">
                <form action="<c:url value='${empty article.id ? "/articles/create" : "/articles/update"}'/>" method="post">
                    <c:if test="${not empty article.id}">
                        <input type="hidden" name="id" value="${article.id}">
                    </c:if>
                    
                    <div class="mb-3">
                        <label for="description" class="form-label">Description</label>
                        <textarea class="form-control" id="description" name="description" rows="3" required>${article.description}</textarea>
                    </div>
                    
                    <div class="mb-3">
                        <label for="category" class="form-label">Category</label>
                        <select class="form-select" id="category" name="category">
                            <option value="">-- Select Category --</option>
                            <option value="Electronics" ${article.category == 'Electronics' ? 'selected' : ''}>Electronics</option>
                            <option value="Clothing" ${article.category == 'Clothing' ? 'selected' : ''}>Clothing</option>
                            <option value="Home & Garden" ${article.category == 'Home & Garden' ? 'selected' : ''}>Home & Garden</option>
                            <option value="Books" ${article.category == 'Books' ? 'selected' : ''}>Books</option>
                            <option value="Sports" ${article.category == 'Sports' ? 'selected' : ''}>Sports</option>
                            <option value="Toys" ${article.category == 'Toys' ? 'selected' : ''}>Toys</option>
                            <option value="Food" ${article.category == 'Food' ? 'selected' : ''}>Food</option>
                            <option value="Other" ${article.category == 'Other' ? 'selected' : ''}>Other</option>
                        </select>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label for="price" class="form-label">Price</label>
                            <div class="input-group">
                                <span class="input-group-text">$</span>
                                <input type="number" class="form-control" id="price" name="price" step="0.01" min="0" 
                                       value="${empty article.price ? '' : article.price}" required>
                            </div>
                        </div>
                        
                        <div class="col-md-6 mb-3">
                            <label for="stockQuantity" class="form-label">Stock Quantity</label>
                            <input type="number" class="form-control" id="stockQuantity" name="stockQuantity" min="0" 
                                   value="${empty article.stockQuantity ? '' : article.stockQuantity}" required>
                        </div>
                    </div>
                    
                    <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                        <a href="<c:url value='/articles'/>" class="btn btn-outline-secondary me-md-2">Cancel</a>
                        <button type="submit" class="btn btn-primary">
                            <c:choose>
                                <c:when test="${empty article.id}">
                                    <i class="bi bi-plus-lg me-1"></i>Create
                                </c:when>
                                <c:otherwise>
                                    <i class="bi bi-save me-1"></i>Save Changes
                                </c:otherwise>
                            </c:choose>
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../layouts/footer.jsp"/>