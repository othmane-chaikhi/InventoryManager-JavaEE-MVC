package com.articlemanagement.listener;

import com.articlemanagement.dao.UserDAO;
import com.articlemanagement.model.User;
import com.articlemanagement.util.JPAUtil;
import com.articlemanagement.util.PasswordUtil;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class AppContextListener implements ServletContextListener {
    
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        // Initialize the database and create admin user if not exists
        initializeDatabase();
    }
    
    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // Close JPA resources
        JPAUtil.close();
    }
    
    private void initializeDatabase() {
        UserDAO userDAO = new UserDAO();
        
        // Create admin user if it doesn't exist
        if (userDAO.findByUsername("admin") == null) {
            User adminUser = new User();
            adminUser.setUsername("admin");
            adminUser.setPassword(PasswordUtil.hashPassword("admin123"));
            adminUser.setFullName("System Administrator");
            adminUser.setEmail("admin@example.com");
            adminUser.setRole(User.Role.ADMIN);
            
            userDAO.create(adminUser);
        }
    }
}