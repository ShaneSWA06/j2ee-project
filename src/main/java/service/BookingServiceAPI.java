package service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import model.Booking;

/**
 * BookingServiceAPI - Client for Spring Boot Booking REST API
 */
public class BookingServiceAPI {

    private static final String API_BASE_URL = "http://localhost:8081/user-ws/api/bookings";

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

    public boolean assignCaregiver(int bookingId, int caregiverId) {
        try {
            // We need to fetch the booking first to get current details, or just send a patch.
            // Using the generic update endpoint since we don't have a specific PATCH/assign endpoint yet
            // that accepts just one field in the standard way, BUT we added updateBooking in controller
            // which accepts a Booking object.
            
            // Construct JSON for update
            String jsonInputString = String.format("{\"caregiver_id\": %d, \"status\": \"CONFIRMED\"}", caregiverId);
            
            // This assumes the API update endpoint merges fields or handles partial updates.
            // If the Spring Boot controller uses @RequestBody Booking, it might expect a full object
            // or overwrite nulls.
            // The BookingDAO.updateBooking in Spring Boot checks for nulls! casting partial updates is supported.
            
            sendRequest(API_BASE_URL + "/" + bookingId, "PUT", jsonInputString);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean createBooking(Booking booking) {
        try {
            // Convert userId from int to String for API compatibility
            String userIdStr = String.valueOf(booking.getUserId());
            
            // Convert Date and Time to String format
            String bookingDateStr = booking.getBookingDate() != null ? booking.getBookingDate().toString() : "";
            String bookingTimeStr = booking.getBookingTime() != null ? booking.getBookingTime().toString() : "";
            
            // Escape special characters in string fields
            String pickupAddr = booking.getPickupAddress() != null ? booking.getPickupAddress().replace("\"", "\\\"") : "";
            String destAddr = booking.getDestinationAddress() != null ? booking.getDestinationAddress().replace("\"", "\\\"") : "";
            String notesStr = booking.getNotes() != null ? booking.getNotes().replace("\"", "\\\"") : "";
            
            // Construct JSON for creation
            String jsonInputString;
            if (booking.getCaregiverId() != null) {
                jsonInputString = String.format(
                    "{\"service_id\": %d, \"user_id\": \"%s\", \"booking_date\": \"%s\", \"booking_time\": \"%s\", " +
                    "\"pickup_address\": \"%s\", \"destination_address\": \"%s\", \"total_price\": %.2f, \"status\": \"PENDING\", " +
                    "\"notes\": \"%s\", \"caregiver_id\": %d}",
                    booking.getServiceId(), userIdStr, bookingDateStr, bookingTimeStr,
                    pickupAddr, destAddr, booking.getTotalPrice(), notesStr, booking.getCaregiverId()
                );
            } else {
                jsonInputString = String.format(
                    "{\"service_id\": %d, \"user_id\": \"%s\", \"booking_date\": \"%s\", \"booking_time\": \"%s\", " +
                    "\"pickup_address\": \"%s\", \"destination_address\": \"%s\", \"total_price\": %.2f, \"status\": \"PENDING\", \"notes\": \"%s\"}",
                    booking.getServiceId(), userIdStr, bookingDateStr, bookingTimeStr,
                    pickupAddr, destAddr, booking.getTotalPrice(), notesStr
                );
            }
            
            // Debug: Print the JSON being sent
            System.out.println("DEBUG - Sending JSON to API: " + jsonInputString);
            
            sendRequest(API_BASE_URL, "POST", jsonInputString);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private String sendRequest(String urlStr, String method, String jsonBody) throws Exception {
        URL url = new java.net.URI(urlStr).toURL();
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod(method);
        conn.setRequestProperty("Accept", "application/json");
        conn.setRequestProperty("Content-Type", "application/json");
        
        if (jsonBody != null) {
            conn.setDoOutput(true);
            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = jsonBody.getBytes(StandardCharsets.UTF_8);
                os.write(input, 0, input.length);
            }
        }

        int responseCode = conn.getResponseCode();
        if (responseCode >= 400) {
            // Read error response body for better debugging
            String errorBody = "";
            try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getErrorStream()))) {
                StringBuilder errorResponse = new StringBuilder();
                String line;
                while ((line = br.readLine()) != null) {
                    errorResponse.append(line);
                }
                errorBody = errorResponse.toString();
            } catch (Exception e) {
                errorBody = "Unable to read error response";
            }
            throw new RuntimeException("HTTP Error: " + responseCode + " - " + errorBody);
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
                    booking.setBookingId(Integer.parseInt(value));
                    break;
                case "service_id":
                    booking.setServiceId(Integer.parseInt(value));
                    // Mock service name based on ID for display
                    if (booking.getServiceId() == 101) booking.setServiceName("Medical Escort");
                    else if (booking.getServiceId() == 102) booking.setServiceName("Nurse Escort");
                    else if (booking.getServiceId() == 103) booking.setServiceName("Wheelchair Transport");
                    else booking.setServiceName("Service #" + value);
                    break;
                case "user_id":
                    try {
                        booking.setUserId(Integer.parseInt(value));
                    } catch (NumberFormatException e) {
                        // userId in Spring is String, but in J2EE model it's int.
                        // Ideally we fix J2EE model to String, but for now parse if possible.
                        booking.setUserId(0); 
                    }
                    booking.setUserName("Client #" + value); // Placeholder
                    break;
                case "caregiver_id":
                    booking.setCaregiverId(Integer.parseInt(value));
                    break;
                case "booking_date":
                    booking.setBookingDate(Date.valueOf(value));
                    break;
                case "booking_time":
                    // Format might be HH:mm:ss or HH:mm
                    if (value.length() == 5) value += ":00";
                    booking.setBookingTime(Time.valueOf(value));
                    break;
                case "status":
                    booking.setStatus(value);
                    break;
                case "notes":
                    booking.setNotes(value);
                    break;
                case "pickup_address":
                    booking.setPickupAddress(value);
                    break;
                case "destination_address":
                    booking.setDestinationAddress(value);
                    break;
                case "total_price":
                    booking.setTotalPrice(Double.parseDouble(value));
                    break;
                case "created_at":
                    // Simplified timestamp parsing or ignore
                    break;
            }
        }
        return booking;
    }
}
