package dao;

import dao.impl.FeedbackDAOImpl;
import dao.impl.PaymentDAOImpl;
import dao.impl.UserDAOImpl;

/**
 * DAOFactory - Factory class for creating DAO instances
 * Centralizes DAO instantiation and makes it easier to swap implementations
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
