package service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.sql.Date;
import java.sql.Time;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import db.DBUtil;
import model.Booking;

/**
 * BookingServiceAPI - Client for Spring Boot Booking REST API
 */
public class BookingServiceAPI {

    private static final String API_BASE_URL = "https://assignmenttwo-fljm.onrender.com/user-ws/api/bookings";

    public List<Booking> getUnassignedBookings() {
        try {
            String json = sendRequest(API_BASE_URL + "/unassigned", "GET", null);
            return parseBookingList(json);
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public List<Booking> getBookingsByCaregiver(int caregiverId) {
        try {
            String json = sendRequest(API_BASE_URL + "/caregiver/" + caregiverId, "GET", null);
            return parseBookingList(json);
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    public List<Booking> getAllBookings() {
        try {
            String json = sendRequest(API_BASE_URL, "GET", null);
            return parseBookingList(json);
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    public List<Booking> getBookingsByUser(int userId) {
        try {
            String json = sendRequest(API_BASE_URL + "/user/" + userId, "GET", null);
            return parseBookingList(json);
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    public Booking getBookingById(int bookingId) {
        try {
            String json = sendRequest(API_BASE_URL + "/" + bookingId, "GET", null);
            return parseBooking(json);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public boolean assignCaregiver(int bookingId, int caregiverId) {
        try {
            // Use the dedicated assign-caregiver endpoint with POST method (updated from PATCH)
            sendRequest(API_BASE_URL + "/" + bookingId + "/assign-caregiver?caregiverId=" + caregiverId, "POST", null);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean updateBooking(int bookingId, Booking booking) {
        try {
            // Convert Date and Time to String format (ISO format)
            String bookingDateStr = booking.getBookingDate() != null ? booking.getBookingDate().toString() : "";
            String bookingTimeStr = booking.getBookingTime() != null ? booking.getBookingTime().toString() : "";
            
            // Escape special characters in string fields
            String notesStr = escapeJson(booking.getNotes());
            
            // Build JSON manually
            StringBuilder json = new StringBuilder("{");
            
            if (booking.getServiceId() != 0) {
                json.append("\"serviceId\":").append(booking.getServiceId()).append(",");
            }
            if (booking.getCaregiverId() != null) {
                json.append("\"caregiverId\":").append(booking.getCaregiverId()).append(",");
            }
            if (!bookingDateStr.isEmpty()) {
                json.append("\"bookingDate\":\"").append(bookingDateStr).append("\",");
            }
            if (!bookingTimeStr.isEmpty()) {
                json.append("\"bookingTime\":\"").append(bookingTimeStr).append("\",");
            }
            if (booking.getStatus() != null) {
                json.append("\"status\":\"").append(booking.getStatus()).append("\",");
            }
            if (booking.getCaregiverStatus() != null) {
                json.append("\"caregiverStatus\":\"").append(booking.getCaregiverStatus()).append("\",");
            }
            if (notesStr != null && !notesStr.isEmpty()) {
                json.append("\"notes\":\"").append(notesStr).append("\",");
            }
            
            // Remove trailing comma if exists
            String jsonStr = json.toString();
            if (jsonStr.endsWith(",")) {
                jsonStr = jsonStr.substring(0, jsonStr.length() - 1);
            }
            jsonStr += "}";
            
            sendRequest(API_BASE_URL + "/" + bookingId, "PUT", jsonStr);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean deleteBooking(int bookingId) {
        try {
            sendRequest(API_BASE_URL + "/" + bookingId, "DELETE", null);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean updateBookingStatus(int bookingId, String status) {
        try {
            sendRequest(API_BASE_URL + "/" + bookingId + "/status?status=" + java.net.URLEncoder.encode(status, "UTF-8"), "POST", null);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean updatePaymentStatus(int bookingId, String paymentStatus) {
        try {
            sendRequest(API_BASE_URL + "/" + bookingId + "/payment-status?paymentStatus=" + java.net.URLEncoder.encode(paymentStatus, "UTF-8"), "POST", null);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean clockIn(int bookingId, String location) {
        try {
            String url = API_BASE_URL + "/" + bookingId + "/clock-in?location=" + java.net.URLEncoder.encode(location, "UTF-8");
            System.out.println("DEBUG - Calling Clock-In API: " + url);
            // Sending "{}" instead of null to be more compatible with strict POST handlers
            String response = sendRequest(url, "POST", "{}");
            System.out.println("DEBUG - Clock-In API Response: " + response);
            return true;
        } catch (Exception e) {
            System.out.println("DEBUG - Clock-In API Failed: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean clockOut(int bookingId, String location) {
        try {
            String url = API_BASE_URL + "/" + bookingId + "/clock-out?location=" + java.net.URLEncoder.encode(location, "UTF-8");
            System.out.println("DEBUG - Calling Clock-Out API: " + url);
            String response = sendRequest(url, "POST", "{}");
            System.out.println("DEBUG - Clock-Out API Response: " + response);
            return true;
        } catch (Exception e) {
            System.out.println("DEBUG - Clock-Out API Failed: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public Booking createBooking(Booking booking) {
        try {
            // Convert Date and Time to String format (ISO format)
            String bookingDateStr = booking.getBookingDate() != null ? booking.getBookingDate().toString() : "";
            String bookingTimeStr = booking.getBookingTime() != null ? booking.getBookingTime().toString() : "";
            
            // Escape special characters in string fields
            String pickupAddr = escapeJson(booking.getPickupAddress());
            String destAddr = escapeJson(booking.getDestinationAddress());
            String notesStr = escapeJson(booking.getNotes());
            
            // Build JSON manually
            StringBuilder json = new StringBuilder("{");
            json.append("\"userId\":").append(booking.getUserId()).append(",");
            json.append("\"serviceId\":").append(booking.getServiceId()).append(",");
            json.append("\"bookingDate\":\"").append(bookingDateStr).append("\",");
            json.append("\"bookingTime\":\"").append(bookingTimeStr).append("\",");
            json.append("\"status\":\"Pending\",");
            json.append("\"caregiverStatus\":\"Pending\",");
            json.append("\"paymentStatus\":\"").append(booking.getPaymentStatus() != null ? booking.getPaymentStatus() : "Unpaid").append("\"");
            
            if (pickupAddr != null && !pickupAddr.isEmpty()) {
                json.append(",\"pickupAddress\":\"").append(pickupAddr).append("\"");
            }
            if (destAddr != null && !destAddr.isEmpty()) {
                json.append(",\"destinationAddress\":\"").append(destAddr).append("\"");
            }
            if (notesStr != null && !notesStr.isEmpty()) {
                json.append(",\"notes\":\"").append(notesStr).append("\"");
            }
            if (booking.getTotalPrice() != null) {
                json.append(",\"totalPrice\":").append(booking.getTotalPrice());
            }
            if (booking.getCaregiverId() != null) {
                json.append(",\"caregiverId\":").append(booking.getCaregiverId());
            }
            
            json.append("}");
            
            String jsonInputString = json.toString();
            
            // Debug: Print the JSON being sent
            System.out.println("DEBUG - Sending JSON to API: " + jsonInputString);
            
            String responseBody = sendRequest(API_BASE_URL, "POST", jsonInputString);
            return parseBooking(responseBody);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    private String escapeJson(String value) {
        if (value == null) return null;
        return value.replace("\\", "\\\\")
                    .replace("\"", "\\\"")
                    .replace("\n", "\\n")
                    .replace("\r", "\\r")
                    .replace("\t", "\\t");
    }

    private String sendRequest(String urlStr, String method, String jsonBody) throws Exception {
        System.out.println("DEBUG - API Request: " + method + " " + urlStr);
        URL url = new java.net.URI(urlStr).toURL();
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod(method);
        conn.setRequestProperty("Accept", "application/json");
        conn.setRequestProperty("Content-Type", "application/json");
        
        if (jsonBody != null || "POST".equals(method) || "PUT".equals(method) || "PATCH".equals(method)) {
            conn.setDoOutput(true);
            if (jsonBody != null) {
                try (OutputStream os = conn.getOutputStream()) {
                    byte[] input = jsonBody.getBytes(StandardCharsets.UTF_8);
                    os.write(input, 0, input.length);
                }
            }
        }

        int responseCode = conn.getResponseCode();
        System.out.println("DEBUG - API Response Code: " + responseCode + " for " + urlStr);
        if (responseCode >= 400) {
            String errorBody = "";
            try {
                java.io.InputStream es = conn.getErrorStream();
                if (es != null) {
                    try (BufferedReader br = new BufferedReader(new InputStreamReader(es))) {
                        StringBuilder errorResponse = new StringBuilder();
                        String line;
                        while ((line = br.readLine()) != null) {
                            errorResponse.append(line);
                        }
                        errorBody = errorResponse.toString();
                    }
                }
            } catch (Exception e) {
                errorBody = "Unable to read error response: " + e.getMessage();
            }
            System.out.println("DEBUG - API Error Body: " + errorBody);
            throw new RuntimeException("HTTP Error " + responseCode + ": " + errorBody);
        }

        BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        StringBuilder response = new StringBuilder();
        String line;
        while ((line = br.readLine()) != null) {
            response.append(line);
        }
        return response.toString();
    }
    
    // Manual JSON Parsing (Simple regex/string manipulation as per project pattern)
    private List<Booking> parseBookingList(String json) {
        List<Booking> bookings = new ArrayList<>();
        json = json.trim();
        if (json.startsWith("[")) json = json.substring(1);
        if (json.endsWith("]")) json = json.substring(0, json.length() - 1);
        if (json.isEmpty()) return bookings;

        // Split objects by "},{"
        String[] objects = json.split("(?<=\\}),(?=\\{)");
        
        for (String obj : objects) {
            try {
                bookings.add(parseBooking(obj));
            } catch (Exception e) {
                System.out.println("Error parsing booking JSON: " + e.getMessage());
            }
        }
        return bookings;
    }

    private Booking parseBooking(String json) {
        Booking booking = new Booking();
        json = json.replace("{", "").replace("}", "");
        
        // Split fields carefully (approximate parser)
        String[] fields = json.split(",(?=\\\"[^\\\"]*\\\":)");
        
        for (String field : fields) {
            String[] parts = field.split(":", 2);
            if (parts.length < 2) continue;
            
            String key = parts[0].trim().replace("\"", "");
            String value = parts[1].trim().replace("\"", "");
            
            if (value.equals("null")) continue;

            switch (key) {
                case "booking_id":
                case "bookingId":
                    booking.setBookingId(Integer.parseInt(value));
                    break;
                case "service_id":
                case "serviceId":
                    booking.setServiceId(Integer.parseInt(value));
                    booking.setServiceName(resolveServiceName(booking.getServiceId()));
                    break;
                case "user_id":
                case "userId":
                    try {
                        booking.setUserId(Integer.parseInt(value));
                    } catch (NumberFormatException e) {
                        booking.setUserId(0); 
                    }
                    booking.setUserName("Client #" + value); // Placeholder
                    break;
                case "caregiver_id":
                case "caregiverId":
                    booking.setCaregiverId(Integer.parseInt(value));
                    break;
                case "booking_date":
                case "bookingDate":
                    booking.setBookingDate(Date.valueOf(value));
                    break;
                case "booking_time":
                case "bookingTime":
                    // Format might be HH:mm:ss or HH:mm
                    if (value.length() == 5) value += ":00";
                    booking.setBookingTime(Time.valueOf(value));
                    break;
                case "status":
                    booking.setStatus(value);
                    break;
                case "caregiver_status":
                case "caregiverStatus":
                    booking.setCaregiverStatus(value);
                    break;
                case "payment_status":
                case "paymentStatus":
                    booking.setPaymentStatus(value);
                    break;
                case "notes":
                    booking.setNotes(value);
                    break;
                case "pickup_address":
                case "pickupAddress":
                    booking.setPickupAddress(value);
                    break;
                case "destination_address":
                case "destinationAddress":
                    booking.setDestinationAddress(value);
                    break;
                case "total_price":
                case "totalPrice":
                    booking.setTotalPrice(Double.parseDouble(value));
                    break;
                case "created_at":
                case "createdAt":
                    booking.setCreatedAt(parseTimestamp(value));
                    break;
                case "updated_at":
                case "updatedAt":
                    booking.setUpdatedAt(parseTimestamp(value));
                    break;
                case "clock_in_time":
                case "clockInTime":
                    booking.setClockInTime(parseTimestamp(value));
                    break;
                case "clock_out_time":
                case "clockOutTime":
                    booking.setClockOutTime(parseTimestamp(value));
                    break;
                case "clock_in_location":
                case "clockInLocation":
                    booking.setClockInLocation(value);
                    break;
                case "clock_out_location":
                case "clockOutLocation":
                    booking.setClockOutLocation(value);
                    break;
            }
        }
        return booking;
    }

    private java.sql.Timestamp parseTimestamp(String value) {
        if (value == null || value.equals("null") || value.isEmpty()) return null;
        try {
            // Spring Boot usually returns ISO 8601: "yyyy-MM-ddTHH:mm:ss.SSSSSS"
            // Simple parsing to java.sql.Timestamp
            String timestampStr = value.replace("T", " ");
            if (timestampStr.length() > 19) {
                timestampStr = timestampStr.substring(0, 19);
            }
            return java.sql.Timestamp.valueOf(timestampStr);
        } catch (Exception e) {
            System.err.println("Error parsing timestamp: " + value);
            return null;
        }
    }

    private String resolveServiceName(int serviceId) {
        String serviceName = null;
        String serviceSql = "SELECT service_name FROM service WHERE service_id = ?";
        String escortSql = "SELECT service_name FROM medical_escort_service WHERE service_id = ?";

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement serviceStmt = conn.prepareStatement(serviceSql)) {
            serviceStmt.setInt(1, serviceId);
            try (ResultSet rs = serviceStmt.executeQuery()) {
                if (rs.next()) {
                    serviceName = rs.getString("service_name");
                }
            }

            if (serviceName == null) {
                try (PreparedStatement escortStmt = conn.prepareStatement(escortSql)) {
                    escortStmt.setInt(1, serviceId);
                    try (ResultSet rs = escortStmt.executeQuery()) {
                        if (rs.next()) {
                            serviceName = rs.getString("service_name");
                        }
                    }
                }
            }
        } catch (SQLException e) {
            serviceName = null;
        }

        return serviceName != null ? serviceName : "Service #" + serviceId;
    }
}
