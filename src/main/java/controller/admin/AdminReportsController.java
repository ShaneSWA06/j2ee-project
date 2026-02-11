package controller.admin;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import db.DBUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * AdminReportsController - Handles data fetching for reports dashboard
 */
@WebServlet("/admin/reports")
public class AdminReportsController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdminLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp?err=unauthorised");
            return;
        }

        try (Connection conn = DBUtil.getConnection()) {
            // 1. fetch summary stats
            fetchSummaryStats(conn, request);

            // 2. fetch upcoming schedule
            fetchUpcomingSchedule(conn, request);

            // 3. fetch popular services
            fetchPopularServices(conn, request);

            // 4. fetch caregiver ratings
            fetchCaregiverRatings(conn, request);

            // 5. fetch top clients
            fetchTopClients(conn, request);

            // Forward to JSP
            request.getRequestDispatcher("/admin/adminReports.jsp").forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Database error generating reports", e);
        }
    }

    private void fetchSummaryStats(Connection conn, HttpServletRequest request) throws SQLException {
        int totalCustomers = 0;
        int totalBookings = 0;
        int totalCaregivers = 0;
        int totalServices = 0;
        int pendingBookings = 0;
        int confirmedBookings = 0;
        int completedBookings = 0;
        double avgRating = 0.0;

        // Total customers
        try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM app_user WHERE role='CUSTOMER'");
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
				totalCustomers = rs.getInt(1);
			}
        }

        // Total bookings
        try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM booking");
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
				totalBookings = rs.getInt(1);
			}
        }

        // Bookings by status
        try (PreparedStatement ps = conn.prepareStatement("SELECT status, COUNT(*) FROM booking GROUP BY status");
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String status = rs.getString("status");
                int count = rs.getInt(2);
                if ("Pending".equals(status)) {
					pendingBookings = count;
				} else if ("Confirmed".equals(status)) {
					confirmedBookings = count;
				} else if ("Completed".equals(status)) {
					completedBookings = count;
				}
            }
        }

        // Total caregivers
        try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM caregiver WHERE available=TRUE");
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
				totalCaregivers = rs.getInt(1);
			}
        }

        // Total services
        try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM service WHERE is_active=TRUE");
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
				totalServices = rs.getInt(1);
			}
        }

        // Average rating
        try (PreparedStatement ps = conn.prepareStatement("SELECT AVG(rating) FROM feedback");
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
				avgRating = rs.getDouble(1);
			}
        }

        request.setAttribute("totalCustomers", totalCustomers);
        request.setAttribute("totalBookings", totalBookings);
        request.setAttribute("totalCaregivers", totalCaregivers);
        request.setAttribute("totalServices", totalServices);
        request.setAttribute("pendingBookings", pendingBookings);
        request.setAttribute("confirmedBookings", confirmedBookings);
        request.setAttribute("completedBookings", completedBookings);
        request.setAttribute("avgRating", avgRating);
    }

    private void fetchUpcomingSchedule(Connection conn, HttpServletRequest request) throws SQLException {
        String sql = "SELECT b.booking_id, b.booking_date, b.booking_time, b.status, " +
                     "s.service_name, s.duration_minutes, " +
                     "c.name AS customer_name, c.phone AS customer_phone, " +
                     "cg.name AS caregiver_name " +
                     "FROM booking b " +
                     "JOIN service s ON b.service_id = s.service_id " +
                     "JOIN app_user c ON b.user_id = c.user_id " +
                     "LEFT JOIN caregiver cg ON b.caregiver_id = cg.caregiver_id " +
                     "WHERE b.booking_date >= CURRENT_DATE AND b.status IN ('Pending', 'Confirmed') " +
                     "ORDER BY b.booking_date, b.booking_time " +
                     "LIMIT 10";

        List<Map<String, Object>> schedule = new ArrayList<>();

        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> item = new HashMap<>();
                item.put("booking_id", rs.getInt("booking_id"));
                item.put("booking_date", rs.getDate("booking_date"));
                item.put("booking_time", rs.getTime("booking_time"));
                item.put("status", rs.getString("status"));
                item.put("service_name", rs.getString("service_name"));
                item.put("duration_minutes", rs.getInt("duration_minutes"));
                item.put("customer_name", rs.getString("customer_name"));
                item.put("customer_phone", rs.getString("customer_phone"));
                item.put("caregiver_name", rs.getString("caregiver_name"));
                schedule.add(item);
            }
        }
        request.setAttribute("upcomingSchedule", schedule);
    }

    private void fetchPopularServices(Connection conn, HttpServletRequest request) throws SQLException {
        String sql = "SELECT s.service_name, COUNT(b.booking_id) as booking_count " +
                     "FROM service s " +
                     "LEFT JOIN booking b ON s.service_id = b.service_id " +
                     "WHERE s.is_active = TRUE " +
                     "GROUP BY s.service_id, s.service_name " +
                     "ORDER BY booking_count DESC " +
                     "LIMIT 5";

        List<Map<String, Object>> popularServices = new ArrayList<>();

        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> item = new HashMap<>();
                item.put("service_name", rs.getString("service_name"));
                item.put("booking_count", rs.getInt("booking_count"));
                popularServices.add(item);
            }
        }
        request.setAttribute("popularServices", popularServices);
    }

    private void fetchCaregiverRatings(Connection conn, HttpServletRequest request) throws SQLException {
        String sql = "SELECT c.name, AVG(f.rating) as avg_rating, COUNT(f.feedback_id) as review_count " +
                     "FROM caregiver c " +
                     "JOIN booking b ON c.caregiver_id = b.caregiver_id " +
                     "JOIN feedback f ON b.booking_id = f.booking_id " +
                     "GROUP BY c.caregiver_id, c.name " +
                     "ORDER BY avg_rating DESC " +
                     "LIMIT 5";

        List<Map<String, Object>> caregiverRatings = new ArrayList<>();

        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> item = new HashMap<>();
                item.put("name", rs.getString("name"));
                item.put("avg_rating", rs.getDouble("avg_rating"));
                item.put("review_count", rs.getInt("review_count"));
                caregiverRatings.add(item);
            }
        }
        request.setAttribute("caregiverRatings", caregiverRatings);
    }

    private void fetchTopClients(Connection conn, HttpServletRequest request) throws SQLException {
        String sql = "SELECT u.name, u.email, COUNT(b.booking_id) as booking_count " +
                     "FROM app_user u " +
                     "JOIN booking b ON u.user_id = b.user_id " +
                     "WHERE u.role='CUSTOMER' " +
                     "GROUP BY u.user_id, u.name, u.email " +
                     "ORDER BY booking_count DESC " +
                     "LIMIT 5";

        List<Map<String, Object>> topClients = new ArrayList<>();

        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> item = new HashMap<>();
                item.put("name", rs.getString("name"));
                item.put("email", rs.getString("email"));
                item.put("booking_count", rs.getInt("booking_count"));
                topClients.add(item);
            }
        }
        request.setAttribute("topClients", topClients);
    }

    private boolean isAdminLoggedIn(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
			return false;
		}
        Integer userId = (Integer) session.getAttribute("sessUserId");
        String role = (String) session.getAttribute("sessUserRole");
        return userId != null && "ADMIN".equals(role);
    }
}
