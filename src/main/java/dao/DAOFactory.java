package dao;

import dao.impl.FeedbackDAOImpl;
import dao.impl.PaymentDAOImpl;
import dao.impl.UserDAOImpl;

/**
 * DAOFactory - Data Access Object Factory
 * <p>
 * Purpose:
 * - Centralizes the creation of DAO instances.
 * - Decouples the service layer from specific DAO implementations (Dependency Injection principle).
 * - Makes it easier to swap implementations (e.g., from JDBC to JPA) without changing client code.
 */
public class DAOFactory {

    /**
     * Get UserDAO instance
     */
    public static UserDAO getUserDAO() {
        return new UserDAOImpl();
    }

    /**
     * Get FeedbackDAO instance
     */
    public static FeedbackDAO getFeedbackDAO() {
        return new FeedbackDAOImpl();
    }

    /**
     * Get PaymentDAO instance
     */
    public static PaymentDAO getPaymentDAO() {
        return new PaymentDAOImpl();
    }
}
