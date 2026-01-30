package dao.impl;

import dao.BookingDAO;
import db.DBUtil;
import model.Booking;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * BookingDAOImpl - Implementation of BookingDAO using JDBC
 */
public class BookingDAOImpl implements BookingDAO {

    @Override
    public Booking getBookingById(int bookingId) throws SQLException {
        String sql = "SELECT b.booking_id, b.user_id, b.service_id, b.caregiver_id, b.booking_date, b.booking_time, " +
                     "b.status, b.notes, b.created_at, " +
                     "u.name as user_name, s.service_name, c.name as caregiver_name " +
                     "FROM booking b " +
                     "LEFT JOIN app_user u ON b.user_id = u.user_id " +
                     "LEFT JOIN service s ON b.service_id = s.service_id " +
                     "LEFT JOIN caregiver c ON b.caregiver_id = c.caregiver_id " +
                     "WHERE b.booking_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractBookingFromResultSet(rs);
                }
            }
        }
        return null;
    }

    @Override
    public List<Booking> getBookingsByUser(int userId) throws SQLException {
        String sql = "SELECT b.booking_id, b.user_id, b.service_id, b.caregiver_id, b.booking_date, b.booking_time, " +
                     "b.status, b.notes, b.created_at, " +
                     "u.name as user_name, s.service_name, c.name as caregiver_name " +
                     "FROM booking b " +
                     "LEFT JOIN app_user u ON b.user_id = u.user_id " +
                     "LEFT JOIN service s ON b.service_id = s.service_id " +
                     "LEFT JOIN caregiver c ON b.caregiver_id = c.caregiver_id " +
                     "WHERE b.user_id = ? " +
                     "ORDER BY b.booking_date DESC, b.booking_time DESC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                List<Booking> bookings = new ArrayList<>();
                while (rs.next()) {
                    bookings.add(extractBookingFromResultSet(rs));
                }
                return bookings;
            }
        }
    }

    @Override
    public List<Booking> getAllBookings() throws SQLException {
        String sql = "SELECT b.booking_id, b.user_id, b.service_id, b.caregiver_id, b.booking_date, b.booking_time, " +
                     "b.status, b.notes, b.created_at, " +
                     "u.name as user_name, s.service_name, c.name as caregiver_name " +
                     "FROM booking b " +
                     "LEFT JOIN app_user u ON b.user_id = u.user_id " +
                     "LEFT JOIN service s ON b.service_id = s.service_id " +
                     "LEFT JOIN caregiver c ON b.caregiver_id = c.caregiver_id " +
                     "ORDER BY b.booking_date DESC, b.booking_time DESC";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            List<Booking> bookings = new ArrayList<>();
            while (rs.next()) {
                bookings.add(extractBookingFromResultSet(rs));
            }
            return bookings;
        }
    }

    @Override
    public Booking createBooking(Booking booking) throws SQLException {
        String sql = "INSERT INTO booking (user_id, service_id, caregiver_id, booking_date, booking_time, status, notes) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setInt(1, booking.getUserId());
            ps.setInt(2, booking.getServiceId());
            
            if (booking.getCaregiverId() != null) {
                ps.setInt(3, booking.getCaregiverId());
            } else {
                ps.setNull(3, Types.INTEGER);
            }
            
            ps.setDate(4, booking.getBookingDate());
            ps.setTime(5, booking.getBookingTime());
            ps.setString(6, booking.getStatus());
            ps.setString(7, booking.getNotes());
            
            int rowsAffected = ps.executeUpdate();
            
            if (rowsAffected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        booking.setBookingId(rs.getInt(1));
                        return booking;
                    }
                }
            }
        }
        return null;
    }

    @Override
    public boolean updateBooking(Booking booking) throws SQLException {
        String sql = "UPDATE booking SET service_id = ?, caregiver_id = ?, booking_date = ?, " +
                     "booking_time = ?, status = ?, notes = ? WHERE booking_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, booking.getServiceId());
            
            if (booking.getCaregiverId() != null) {
                ps.setInt(2, booking.getCaregiverId());
            } else {
                ps.setNull(2, Types.INTEGER);
            }
            
            ps.setDate(3, booking.getBookingDate());
            ps.setTime(4, booking.getBookingTime());
            ps.setString(5, booking.getStatus());
            ps.setString(6, booking.getNotes());
            ps.setInt(7, booking.getBookingId());
            
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public boolean updateBookingStatus(int bookingId, String status) throws SQLException {
        String sql = "UPDATE booking SET status = ? WHERE booking_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ps.setInt(2, bookingId);
            
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public boolean deleteBooking(int bookingId) throws SQLException {
        String sql = "DELETE FROM booking WHERE booking_id = ?";
        
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, bookingId);
            return ps.executeUpdate() > 0;
        }
    }

    /**
     * Helper method to extract Booking object from ResultSet
     */
    private Booking extractBookingFromResultSet(ResultSet rs) throws SQLException {
        Booking booking = new Booking();
        booking.setBookingId(rs.getInt("booking_id"));
        booking.setUserId(rs.getInt("user_id"));
        booking.setServiceId(rs.getInt("service_id"));
        
        int caregiverId = rs.getInt("caregiver_id");
        if (!rs.wasNull()) {
            booking.setCaregiverId(caregiverId);
        }
        
        booking.setBookingDate(rs.getDate("booking_date"));
        booking.setBookingTime(rs.getTime("booking_time"));
        booking.setStatus(rs.getString("status"));
        booking.setNotes(rs.getString("notes"));
        booking.setCreatedAt(rs.getTimestamp("created_at"));
        booking.setUserName(rs.getString("user_name"));
        booking.setServiceName(rs.getString("service_name"));
        booking.setCaregiverName(rs.getString("caregiver_name"));
        
        return booking;
    }
}
