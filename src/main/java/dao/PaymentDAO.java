package dao;

import java.sql.SQLException;
import java.util.List;

import model.Payment;

/**
 * PaymentDAO - Data Access Interface for Payments
 * <p>
 * Purpose:
 * - Defines the contract for accessing and modifying `payment` data.
 * - Handles CRUD operations for financial transactions.
 */
public interface PaymentDAO {
    Payment createPayment(Payment payment) throws SQLException;
    Payment getPaymentByBookingId(int bookingId) throws SQLException;
    Payment getPaymentByTransactionId(String transactionId) throws SQLException;
    List<Payment> getAllPayments() throws SQLException;
    boolean updatePaymentStatus(String transactionId, String status) throws SQLException;
}
