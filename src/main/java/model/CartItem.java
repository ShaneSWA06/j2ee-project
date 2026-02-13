package model;

import java.io.Serializable;

/**
 * CartItem - Session-based Shopping Cart Entity
 * <p>
 * Purpose:
 * - Represents a temporary holding object for a service booking before checkout.
 * - Stored in the HttpSession (within a List or Map) rather than the database.
 * - Allows users to accumulate multiple bookings before making a single payment.
 * <p>
 * Key Features:
 * - Contains service details (snapshot at time of addition).
 * - Holds user selections like booking date, time, and preferred caregiver.
 * - Generates a unique UUID (`cartItemId`) to manage duplicates or updates in the session.
 */
public class CartItem implements Serializable {
    private static final long serialVersionUID = 1L;

    private int serviceId;
    private String serviceName;
    private String description;
    private double basePrice;
    private int durationMinutes;
    private String categoryName;

    // Booking details
    private String bookingDate;
    private String bookingTime;
    private Integer caregiverId;
    private String caregiverName;
    private String notes;
    private String pickupAddress;
    private String destinationAddress;

    // Unique identifier for this cart item (to handle duplicates)
    private String cartItemId;

    public CartItem() {
        this.cartItemId = java.util.UUID.randomUUID().toString();
    }

    public CartItem(int serviceId, String serviceName, String description,
                    double basePrice, int durationMinutes, String categoryName) {
        this();
        this.serviceId = serviceId;
        this.serviceName = serviceName;
        this.description = description;
        this.basePrice = basePrice;
        this.durationMinutes = durationMinutes;
        this.categoryName = categoryName;
    }

    // Getters and Setters
    public int getServiceId() {
        return serviceId;
    }

    public void setServiceId(int serviceId) {
        this.serviceId = serviceId;
    }

    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public double getBasePrice() {
        return basePrice;
    }

    public void setBasePrice(double basePrice) {
        this.basePrice = basePrice;
    }

    public int getDurationMinutes() {
        return durationMinutes;
    }

    public void setDurationMinutes(int durationMinutes) {
        this.durationMinutes = durationMinutes;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public String getBookingDate() {
        return bookingDate;
    }

    public void setBookingDate(String bookingDate) {
        this.bookingDate = bookingDate;
    }

    public String getBookingTime() {
        return bookingTime;
    }

    public void setBookingTime(String bookingTime) {
        this.bookingTime = bookingTime;
    }

    public Integer getCaregiverId() {
        return caregiverId;
    }

    public void setCaregiverId(Integer caregiverId) {
        this.caregiverId = caregiverId;
    }

    public String getCaregiverName() {
        return caregiverName;
    }

    public void setCaregiverName(String caregiverName) {
        this.caregiverName = caregiverName;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public String getPickupAddress() {
        return pickupAddress;
    }

    public void setPickupAddress(String pickupAddress) {
        this.pickupAddress = pickupAddress;
    }

    public String getDestinationAddress() {
        return destinationAddress;
    }

    public void setDestinationAddress(String destinationAddress) {
        this.destinationAddress = destinationAddress;
    }

    public String getCartItemId() {
        return cartItemId;
    }

    public void setCartItemId(String cartItemId) {
        this.cartItemId = cartItemId;
    }

    @Override
    public String toString() {
        return "CartItem{" +
                "serviceId=" + serviceId +
                ", serviceName='" + serviceName + '\'' +
                ", basePrice=" + basePrice +
                ", bookingDate='" + bookingDate + '\'' +
                ", bookingTime='" + bookingTime + '\'' +
                '}';
    }
}
