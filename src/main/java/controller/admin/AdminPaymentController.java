package controller.admin;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import dao.DAOFactory;
import dao.PaymentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Payment;

/**
 * AdminPaymentController - Handles payment history viewing for admins
 * <p>
 * Purpose:
 * - Lists all payment transactions recorded in the system.
 * - Provides financial overview for administrators.
 * <p>
 * Integration:
 * - Uses PaymentDAO to fetch payment records.
 */
@WebServlet("/admin/payments")
public class AdminPaymentController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PaymentDAO paymentDAO;

    @Override
    public void init() throws ServletException {
        paymentDAO = DAOFactory.getPaymentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            List<Payment> payments = paymentDAO.getAllPayments();
            request.setAttribute("payments", payments);
            request.getRequestDispatcher("/admin/adminPaymentList.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?error=" + e.getMessage());
        }
    }
}
