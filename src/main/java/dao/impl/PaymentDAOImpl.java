package dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import dao.PaymentDAO;
import db.DBUtil;
import model.Payment;

public class PaymentDAOImpl implements PaymentDAO {

    @Override
    public Payment createPayment(Payment payment) throws SQLException {
        String sql = "INSERT INTO payment (booking_id, amount, tax_amount, currency, payment_method, transaction_id, status, created_at) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, payment.getBookingId());
            ps.setDouble(2, payment.getAmount());
            ps.setDouble(3, payment.getTaxAmount());
            ps.setString(4, payment.getCurrency());
            ps.setString(5, payment.getPaymentMethod());
            ps.setString(6, payment.getTransactionId());
            ps.setString(7, payment.getStatus());
            
            if (payment.getCreatedAt() != null) {
                ps.setTimestamp(8, payment.getCreatedAt());
            } else {
                ps.setTimestamp(8, new java.sql.Timestamp(System.currentTimeMillis()));
            }

            int affectedRows = ps.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("Creating payment failed, no rows affected.");
            }

            try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    payment.setPaymentId(generatedKeys.getInt(1));
                } else {
                    throw new SQLException("Creating payment failed, no ID obtained.");
                }
            }
        }
        return payment;
    }

    @Override
    public Payment getPaymentByBookingId(int bookingId) throws SQLException {
        String sql = "SELECT * FROM payment WHERE booking_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractPaymentFromResultSet(rs);
                }
            }
        }
        return null;
    }

    @Override
    public Payment getPaymentByTransactionId(String transactionId) throws SQLException {
        String sql = "SELECT * FROM payment WHERE transaction_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, transactionId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractPaymentFromResultSet(rs);
                }
            }
        }
        return null;
    }

    @Override
    public List<Payment> getAllPayments() throws SQLException {
        String sql = "SELECT * FROM payment ORDER BY created_at DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            List<Payment> payments = new ArrayList<>();
            while (rs.next()) {
                payments.add(extractPaymentFromResultSet(rs));
            }
            return payments;
        }
    }

    @Override
    public boolean updatePaymentStatus(String transactionId, String status) throws SQLException {
        String sql = "UPDATE payment SET status = ? WHERE transaction_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, transactionId);
            return ps.executeUpdate() > 0;
        }
    }

    private Payment extractPaymentFromResultSet(ResultSet rs) throws SQLException {
        Payment p = new Payment();
        p.setPaymentId(rs.getInt("payment_id"));
        p.setBookingId(rs.getInt("booking_id"));
        p.setAmount(rs.getDouble("amount"));
        try {
            p.setTaxAmount(rs.getDouble("tax_amount"));
        } catch (SQLException e) {
            // Ignore if column doesn't exist yet
        }
        p.setCurrency(rs.getString("currency"));
        p.setPaymentMethod(rs.getString("payment_method"));
        p.setTransactionId(rs.getString("transaction_id"));
        p.setStatus(rs.getString("status"));
        p.setCreatedAt(rs.getTimestamp("created_at"));
        return p;
    }
}
