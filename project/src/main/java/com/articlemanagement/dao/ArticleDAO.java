package com.articlemanagement.dao;

import com.articlemanagement.model.Article;
import com.articlemanagement.util.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import jakarta.persistence.criteria.CriteriaBuilder;
import jakarta.persistence.criteria.CriteriaQuery;
import jakarta.persistence.criteria.Predicate;
import jakarta.persistence.criteria.Root;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class ArticleDAO {
    
    public void create(Article article) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(article);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }
    
    public List<Article> findAll() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            TypedQuery<Article> query = em.createQuery("SELECT a FROM Article a ORDER BY a.id", Article.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    public Article findById(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.find(Article.class, id);
        } finally {
            em.close();
        }
    }
    
    public void update(Article article) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.merge(article);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }
    
    public void delete(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            Article article = em.find(Article.class, id);
            if (article != null) {
                em.remove(article);
            }
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }
    
    public List<Article> search(Map<String, Object> criteria) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            CriteriaBuilder cb = em.getCriteriaBuilder();
            CriteriaQuery<Article> cq = cb.createQuery(Article.class);
            Root<Article> root = cq.from(Article.class);
            
            List<Predicate> predicates = new ArrayList<>();
            
            if (criteria.containsKey("description") && criteria.get("description") != null) {
                String description = (String) criteria.get("description");
                if (!description.isEmpty()) {
                    predicates.add(cb.like(root.get("description"), "%" + description + "%"));
                }
            }
            
            if (criteria.containsKey("minPrice") && criteria.get("minPrice") != null) {
                BigDecimal minPrice = new BigDecimal(criteria.get("minPrice").toString());
                predicates.add(cb.greaterThanOrEqualTo(root.get("price"), minPrice));
            }
            
            if (criteria.containsKey("maxPrice") && criteria.get("maxPrice") != null) {
                BigDecimal maxPrice = new BigDecimal(criteria.get("maxPrice").toString());
                predicates.add(cb.lessThanOrEqualTo(root.get("price"), maxPrice));
            }
            
            if (criteria.containsKey("minStock") && criteria.get("minStock") != null) {
                Integer minStock = Integer.parseInt(criteria.get("minStock").toString());
                predicates.add(cb.greaterThanOrEqualTo(root.get("stockQuantity"), minStock));
            }
            
            if (criteria.containsKey("category") && criteria.get("category") != null) {
                String category = (String) criteria.get("category");
                if (!category.isEmpty()) {
                    predicates.add(cb.equal(root.get("category"), category));
                }
            }
            
            if (!predicates.isEmpty()) {
                cq.where(predicates.toArray(new Predicate[0]));
            }
            
            cq.orderBy(cb.asc(root.get("id")));
            TypedQuery<Article> query = em.createQuery(cq);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
}