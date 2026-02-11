package dao;

import dao.impl.BookingDAOImpl;
import dao.impl.CaregiverDAOImpl;
import dao.impl.CategoryDAOImpl;
import dao.impl.FeedbackDAOImpl;
import dao.impl.PaymentDAOImpl;
import dao.impl.ServiceDAOImpl;
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
     * Get CategoryDAO instance
     */
    public static CategoryDAO getCategoryDAO() {
        return new CategoryDAOImpl();
    }

    /**
     * Get ServiceDAO instance
     */
    public static ServiceDAO getServiceDAO() {
        return new ServiceDAOImpl();
    }

    /**
     * Get BookingDAO instance
     */
    public static BookingDAO getBookingDAO() {
        return new BookingDAOImpl();
    }

    /**
     * Get CaregiverDAO instance
     */
    public static CaregiverDAO getCaregiverDAO() {
        return new CaregiverDAOImpl();
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
