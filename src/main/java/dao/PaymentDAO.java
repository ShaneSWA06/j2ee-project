package dao;

import model.Payment;
import java.sql.SQLException;
import java.util.List;

public interface PaymentDAO {
    Payment createPayment(Payment payment) throws SQLException;
    Payment getPaymentByBookingId(int bookingId) throws SQLException;
    Payment getPaymentByTransactionId(String transactionId) throws SQLException;
    List<Payment> getAllPayments() throws SQLException;
    boolean updatePaymentStatus(String transactionId, String status) throws SQLException;
}
