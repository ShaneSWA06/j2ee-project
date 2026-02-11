package servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import db.DBUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.CartItem;

/**
 * AddToCartServlet handles adding service bookings to the shopping cart
 * Demonstrates ArrayList usage and session management
 */
@WebServlet("/AddToCartServlet")
public class AddToCartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /**
     * Handle GET requests - redirect to services page
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/public/serviceDetails.jsp");
    }

    /**
     * Handle POST requests - add item to cart
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // Check if user is logged in
        if (session.getAttribute("sessUserId") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp?err=notLoggedIn");
            return;
        }

        // Get form parameters
        String serviceIdParam = request.getParameter("serviceId");
        String bookingDate = request.getParameter("bookingDate");
        String bookingTime = request.getParameter("bookingTime");
        String caregiverIdParam = request.getParameter("caregiverId");
        String notes = request.getParameter("notes");
        String pickupAddress = request.getParameter("pickupAddress");
        String destinationAddress = request.getParameter("destinationAddress");

        // Validate required fields
        if (serviceIdParam == null || bookingDate == null || bookingTime == null) {
            response.sendRedirect(request.getContextPath() +
                "/public/serviceDetails.jsp?err=missing_fields");
            return;
        }

        int serviceId;
        try {
            serviceId = Integer.parseInt(serviceIdParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() +
                "/public/serviceDetails.jsp?err=invalid_input");
            return;
        }

        // Get the cart from session (or create new ArrayList)
        @SuppressWarnings("unchecked")
        ArrayList<CartItem> cart = (ArrayList<CartItem>) session.getAttribute("shoppingCart");
        if (cart == null) {
            cart = new ArrayList<>();
        }

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();

            // Fetch service details from database
            ps = conn.prepareStatement(
                "SELECT s.service_id, s.service_name, s.description, s.base_price, s.duration_minutes, c.category_name " +
                "FROM service s LEFT JOIN service_category c ON s.category_id = c.category_id " +
                "WHERE s.service_id = ? AND s.is_active = TRUE");
            ps.setInt(1, serviceId);
            rs = ps.executeQuery();

            if (rs.next()) {
                // Create new cart item
                CartItem item = new CartItem(
                    rs.getInt("service_id"),
                    rs.getString("service_name"),
                    rs.getString("description"),
                    rs.getDouble("base_price"),
                    rs.getInt("duration_minutes"),
                    rs.getString("category_name")
                );

                // Set booking details
                item.setBookingDate(bookingDate);
                item.setBookingTime(bookingTime);
                item.setNotes(notes);
                item.setPickupAddress(pickupAddress);
                item.setDestinationAddress(destinationAddress);

                // Handle caregiver selection
                if (caregiverIdParam != null && !caregiverIdParam.trim().isEmpty()) {
                    try {
                        int caregiverId = Integer.parseInt(caregiverIdParam);
                        item.setCaregiverId(caregiverId);

                        // Fetch caregiver name
                        PreparedStatement psCg = null;
                        ResultSet rsCg = null;
                        try {
                            psCg = conn.prepareStatement(
                                "SELECT name FROM caregiver WHERE caregiver_id = ?");
                            psCg.setInt(1, caregiverId);
                            rsCg = psCg.executeQuery();
                            if (rsCg.next()) {
                                item.setCaregiverName(rsCg.getString("name"));
                            }
                        } finally {
                            if (rsCg != null) {
								try { rsCg.close(); } catch (Exception ignore) {}
							}
                            if (psCg != null) {
								try { psCg.close(); } catch (Exception ignore) {}
							}
                        }
                    } catch (NumberFormatException ignore) {
                        // Invalid caregiver ID, just skip
                    }
                }

                // Add item to cart (ArrayList)
                cart.add(item);

                // Save cart back to session
                session.setAttribute("shoppingCart", cart);

                // Redirect to cart page with success message
                response.sendRedirect(request.getContextPath() + "/customer/viewCart.jsp?success=added");
            } else {
                // Service not found
                response.sendRedirect(request.getContextPath() +
                    "/public/serviceDetails.jsp?err=service_not_found");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() +
                "/public/serviceDetails.jsp?err=" + e.getMessage());
        } finally {
            // Clean up resources
            if (rs != null) {
				try { rs.close(); } catch (SQLException ignore) {}
			}
            if (ps != null) {
				try { ps.close(); } catch (SQLException ignore) {}
			}
            if (conn != null) {
				try { conn.close(); } catch (SQLException ignore) {}
			}
        }
    }
}
