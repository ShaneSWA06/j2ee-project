package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;

import db.DBUtil;
import model.CartItem;

/**
 * CheckoutServlet processes the shopping cart checkout
 * Converts all cart items into actual bookings using database transaction
 * Demonstrates ArrayList processing and transaction management
 */
@WebServlet("/CheckoutServlet")
public class CheckoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handle both GET and POST requests
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processCheckout(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processCheckout(request, response);
    }

    /**
     * Process the checkout operation
     */
    private void processCheckout(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // Check if user is logged in
        Integer userId = (Integer) session.getAttribute("sessUserId");
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp?err=notLoggedIn");
            return;
        }

        // Get cart from session (ArrayList)
        @SuppressWarnings("unchecked")
        ArrayList<CartItem> cart = (ArrayList<CartItem>) session.getAttribute("shoppingCart");

        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/customer/viewCart.jsp?error=cart_empty");
            return;
        }

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBUtil.getConnection();
            // Start transaction
            conn.setAutoCommit(false);

            String insertSQL = "INSERT INTO booking (user_id, service_id, caregiver_id, booking_date, " +
                              "booking_time, status, notes, created_at) " +
                              "VALUES (?, ?, ?, ?, ?, 'Pending', ?, CURRENT_TIMESTAMP)";

            ps = conn.prepareStatement(insertSQL);

            int successCount = 0;

            // Process each item in the cart (ArrayList iteration)
            for (CartItem item : cart) {
                ps.setInt(1, userId);
                ps.setInt(2, item.getServiceId());

                // Set caregiver ID (null if not selected)
                if (item.getCaregiverId() != null) {
                    ps.setInt(3, item.getCaregiverId());
                } else {
                    ps.setNull(3, java.sql.Types.INTEGER);
                }

                ps.setDate(4, java.sql.Date.valueOf(item.getBookingDate()));
                ps.setTime(5, java.sql.Time.valueOf(item.getBookingTime() + ":00"));
                ps.setString(6, item.getNotes());

                int result = ps.executeUpdate();
                if (result > 0) {
                    successCount++;
                }
            }

            // Commit transaction if all bookings were created
            if (successCount == cart.size()) {
                conn.commit();

                // Clear the cart from session
                session.removeAttribute("shoppingCart");

                // Redirect to bookings page with success message
                response.sendRedirect(request.getContextPath() +
                    "/customer/myBookings.jsp?success=checkout&count=" + successCount);
            } else {
                // Rollback if not all bookings were successful
                conn.rollback();
                response.sendRedirect(request.getContextPath() +
                    "/customer/viewCart.jsp?error=checkout_partial_failure");
            }

        } catch (SQLException e) {
            // Rollback on error
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() +
                "/customer/viewCart.jsp?error=" + e.getMessage());
        } finally {
            // Clean up resources
            if (ps != null) try { ps.close(); } catch (SQLException ignore) {}
            if (conn != null) {
                try {
                    conn.setAutoCommit(true); // Reset auto-commit
                    conn.close();
                } catch (SQLException ignore) {}
            }
        }
    }
}
