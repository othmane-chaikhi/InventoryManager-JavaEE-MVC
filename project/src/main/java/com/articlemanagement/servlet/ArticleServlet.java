package com.articlemanagement.servlet;

import com.articlemanagement.dao.ArticleDAO;
import com.articlemanagement.model.Article;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/articles/*")
public class ArticleServlet extends HttpServlet {
    
    private final ArticleDAO articleDAO = new ArticleDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }
        
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/")) {
            List<Article> articles = articleDAO.findAll();
            request.setAttribute("articles", articles);
            request.getRequestDispatcher("/WEB-INF/views/article/list.jsp").forward(request, response);
            return;
        }
        
        switch (pathInfo) {
            case "/create":
                request.getRequestDispatcher("/WEB-INF/views/article/form.jsp").forward(request, response);
                break;
            case "/edit":
                String idParam = request.getParameter("id");
                if (idParam != null && !idParam.isEmpty()) {
                    try {
                        Long id = Long.parseLong(idParam);
                        Article article = articleDAO.findById(id);
                        if (article != null) {
                            request.setAttribute("article", article);
                            request.getRequestDispatcher("/WEB-INF/views/article/form.jsp").forward(request, response);
                        } else {
                            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Article not found");
                        }
                    } catch (NumberFormatException e) {
                        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid article ID");
                    }
                } else {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Article ID is required");
                }
                break;
            case "/search":
                request.getRequestDispatcher("/WEB-INF/views/article/search.jsp").forward(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }
        
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        
        switch (pathInfo) {
            case "/create":
            case "/update":
                handleSaveOrUpdate(request, response);
                break;
            case "/delete":
                handleDelete(request, response);
                break;
            case "/search":
                handleSearch(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    private void handleSaveOrUpdate(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String idParam = request.getParameter("id");
        String description = request.getParameter("description");
        String priceStr = request.getParameter("price");
        String stockQuantityStr = request.getParameter("stockQuantity");
        String category = request.getParameter("category");
        
        if (description == null || priceStr == null || stockQuantityStr == null || 
            description.trim().isEmpty() || priceStr.trim().isEmpty() || stockQuantityStr.trim().isEmpty()) {
            
            request.setAttribute("error", "All fields are required");
            request.getRequestDispatcher("/WEB-INF/views/article/form.jsp").forward(request, response);
            return;
        }
        
        try {
            BigDecimal price = new BigDecimal(priceStr);
            Integer stockQuantity = Integer.parseInt(stockQuantityStr);
            
            if (price.compareTo(BigDecimal.ZERO) <= 0) {
                request.setAttribute("error", "Price must be greater than zero");
                request.getRequestDispatcher("/WEB-INF/views/article/form.jsp").forward(request, response);
                return;
            }
            
            if (stockQuantity < 0) {
                request.setAttribute("error", "Stock quantity cannot be negative");
                request.getRequestDispatcher("/WEB-INF/views/article/form.jsp").forward(request, response);
                return;
            }
            
            Article article;
            
            if (idParam != null && !idParam.isEmpty()) {
                Long id = Long.parseLong(idParam);
                article = articleDAO.findById(id);
                
                if (article == null) {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Article not found");
                    return;
                }
            } else {
                article = new Article();
            }
            
            article.setDescription(description);
            article.setPrice(price);
            article.setStockQuantity(stockQuantity);
            article.setCategory(category);
            
            if (article.getId() == null) {
                articleDAO.create(article);
            } else {
                articleDAO.update(article);
            }
            
            response.sendRedirect(request.getContextPath() + "/articles");
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid price or stock quantity");
            request.getRequestDispatcher("/WEB-INF/views/article/form.jsp").forward(request, response);
        }
    }
    
    private void handleDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idParam = request.getParameter("id");
        
        if (idParam != null && !idParam.isEmpty()) {
            try {
                Long id = Long.parseLong(idParam);
                articleDAO.delete(id);
                response.sendRedirect(request.getContextPath() + "/articles");
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid article ID");
            }
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Article ID is required");
        }
    }
    
    private void handleSearch(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Map<String, Object> criteria = new HashMap<>();
        
        String description = request.getParameter("description");
        String minPriceStr = request.getParameter("minPrice");
        String maxPriceStr = request.getParameter("maxPrice");
        String minStockStr = request.getParameter("minStock");
        String category = request.getParameter("category");
        
        if (description != null && !description.trim().isEmpty()) {
            criteria.put("description", description);
        }
        
        if (minPriceStr != null && !minPriceStr.trim().isEmpty()) {
            try {
                BigDecimal minPrice = new BigDecimal(minPriceStr);
                criteria.put("minPrice", minPrice);
            } catch (NumberFormatException ignored) {
                // Invalid price format, ignore this criterion
            }
        }
        
        if (maxPriceStr != null && !maxPriceStr.trim().isEmpty()) {
            try {
                BigDecimal maxPrice = new BigDecimal(maxPriceStr);
                criteria.put("maxPrice", maxPrice);
            } catch (NumberFormatException ignored) {
                // Invalid price format, ignore this criterion
            }
        }
        
        if (minStockStr != null && !minStockStr.trim().isEmpty()) {
            try {
                Integer minStock = Integer.parseInt(minStockStr);
                criteria.put("minStock", minStock);
            } catch (NumberFormatException ignored) {
                // Invalid stock format, ignore this criterion
            }
        }
        
        if (category != null && !category.trim().isEmpty()) {
            criteria.put("category", category);
        }
        
        List<Article> articles = articleDAO.search(criteria);
        request.setAttribute("articles", articles);
        request.setAttribute("searchCriteria", criteria);
        request.getRequestDispatcher("/WEB-INF/views/article/search.jsp").forward(request, response);
    }
}