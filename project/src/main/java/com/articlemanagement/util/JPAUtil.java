package com.articlemanagement.util;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

public class JPAUtil {
    private static final EntityManagerFactory emFactory;
    
    static {
        try {
            emFactory = Persistence.createEntityManagerFactory("articlePU");
        } catch (Throwable ex) {
            System.err.println("Initial EntityManagerFactory creation failed: " + ex);
            throw new ExceptionInInitializerError(ex);
        }
    }
    
    public static EntityManager getEntityManager() {
        return emFactory.createEntityManager();
    }
    
    public static void close() {
        emFactory.close();
    }
}