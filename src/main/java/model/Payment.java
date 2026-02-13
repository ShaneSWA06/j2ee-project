package model;

import java.sql.Timestamp;

/**
 * Payment - Financial Transaction Record
 * <p>
 * Purpose:
 * - Represents a processed payment for a booking.
 * - Maps to the `payments` table.
 * - Stores transaction details from payment gateways (e.g., Stripe).
 * <p>
 * usage:
 * - Created after a successful checkout process.
 * - Used for financial reporting and order history verification.
 */
public class Payment implements Serializable {
    private int paymentId;
    private int bookingId;
    private double amount;
    private double taxAmount;
    private String currency;
    private String paymentMethod;
    private String transactionId;
    private String status;
    private Timestamp createdAt;

    public Payment() {}

    public Payment(int bookingId, double amount, String currency, String paymentMethod, String transactionId, String status) {
        this.bookingId = bookingId;
        this.amount = amount;
        this.currency = currency;
        this.paymentMethod = paymentMethod;
        this.transactionId = transactionId;
        this.status = status;
    }

    public int getPaymentId() { return paymentId; }
    public void setPaymentId(int paymentId) { this.paymentId = paymentId; }

    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }

    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }

    public double getTaxAmount() { return taxAmount; }
    public void setTaxAmount(double taxAmount) { this.taxAmount = taxAmount; }

    public String getCurrency() { return currency; }
    public void setCurrency(String currency) { this.currency = currency; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public String getTransactionId() { return transactionId; }
    public void setTransactionId(String transactionId) { this.transactionId = transactionId; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
