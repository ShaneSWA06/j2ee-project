package dao;

import model.Booking;
import java.sql.SQLException;
import java.util.List;

/**
 * BookingDAO - Data Access Object interface for Booking operations
 */
public interface BookingDAO {
    
    /**
     * Get booking by ID
     */
    Booking getBookingById(int bookingId) throws SQLException;
    
    /**
     * Get all bookings for a specific user
     */
    List<Booking> getBookingsByUser(int userId) throws SQLException;
    
    /**
     * Get all bookings (admin view)
     */
    List<Booking> getAllBookings() throws SQLException;
    
    /**
     * Create a new booking
     * @return the created booking with generated ID
     */
    Booking createBooking(Booking booking) throws SQLException;
    
    /**
     * Update existing booking
     */
    boolean updateBooking(Booking booking) throws SQLException;
    
    /**
     * Update booking status
     */
    boolean updateBookingStatus(int bookingId, String status) throws SQLException;
    
    /**
     * Update booking payment status
     */
    boolean updatePaymentStatus(int bookingId, String paymentStatus) throws SQLException;

    /**
     * Delete booking by ID
     */
    boolean deleteBooking(int bookingId) throws SQLException;
}
