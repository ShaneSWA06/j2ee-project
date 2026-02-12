package service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import model.Caregiver;

/**
 * API Client for Spring Boot Caregiver REST API
 * Handles communication between J2EE frontend and Spring Boot backend
 */
public class CaregiverServiceAPI {
    
    private static final String API_BASE_URL = "https://assignmenttwo-fljm.onrender.com/user-ws/api/caregivers";
    private Gson gson = new Gson();
    
    /**
     * Get all caregivers
     */
    public List<Caregiver> getAllCaregivers() {
        try {
            String json = sendRequest(API_BASE_URL, "GET", null);
            return parseCaregiverList(json);
        } catch (Exception e) {
            System.err.println("Error fetching caregivers: " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    /**
     * Get caregiver by ID
     */
    public Caregiver getCaregiverById(int id) {
        try {
            String json = sendRequest(API_BASE_URL + "/" + id, "GET", null);
            return parseCaregiver(json);
        } catch (Exception e) {
            System.err.println("Error fetching caregiver: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * Get caregiver by User ID
     */
    public Caregiver getCaregiverByUserId(int userId) {
        try {
            String json = sendRequest(API_BASE_URL + "/user/" + userId, "GET", null);
            return parseCaregiver(json);
        } catch (Exception e) {
            System.err.println("Error fetching caregiver by user ID: " + e.getMessage());
            return null;
        }
    }
    
    /**
     * Search caregivers by specialty
     */
    public List<Caregiver> searchBySpecialty(String specialty) {
        try {
            String url = API_BASE_URL + "/search?specialty=" + java.net.URLEncoder.encode(specialty, "UTF-8");
            String json = sendRequest(url, "GET", null);
            return parseCaregiverList(json);
        } catch (Exception e) {
            System.err.println("Error searching caregivers: " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    /**
     * Search caregivers by name
     */
    public List<Caregiver> searchByName(String name) {
        try {
            String url = API_BASE_URL + "/search?name=" + java.net.URLEncoder.encode(name, "UTF-8");
            String json = sendRequest(url, "GET", null);
            return parseCaregiverList(json);
        } catch (Exception e) {
            System.err.println("Error searching caregivers: " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    /**
     * Get available caregivers
     */
    public List<Caregiver> getAvailableCaregivers() {
        try {
            String json = sendRequest(API_BASE_URL + "/available", "GET", null);
            return parseCaregiverList(json);
        } catch (Exception e) {
            System.err.println("Error fetching available caregivers: " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    /**
     * Create a new caregiver
     */
    public Caregiver createCaregiver(Caregiver caregiver) {
        try {
            String jsonBody = gson.toJson(caregiver);
            String json = sendRequest(API_BASE_URL, "POST", jsonBody);
            return parseCaregiver(json);
        } catch (Exception e) {
            System.err.println("Error creating caregiver: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * Update caregiver
     */
    public Caregiver updateCaregiver(int id, Caregiver caregiver) {
        try {
            String jsonBody = gson.toJson(caregiver);
            String json = sendRequest(API_BASE_URL + "/" + id, "PUT", jsonBody);
            return parseCaregiver(json);
        } catch (Exception e) {
            System.err.println("Error updating caregiver: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * Delete caregiver
     */
    public boolean deleteCaregiver(int id) {
        try {
            sendRequest(API_BASE_URL + "/" + id, "DELETE", null);
            return true;
        } catch (Exception e) {
            System.err.println("Error deleting caregiver: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Update caregiver availability
     */
    public boolean updateAvailability(int id, boolean available, String availableHours) {
        try {
            JsonObject json = new JsonObject();
            json.addProperty("available", available);
            json.addProperty("availableHours", availableHours);
            
            String jsonBody = gson.toJson(json);
            sendRequest(API_BASE_URL + "/" + id + "/availability", "PUT", jsonBody);
            return true;
        } catch (Exception e) {
            System.err.println("Error updating availability: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Assign caregiver to booking
     */
    public boolean assignToBooking(int caregiverId, int bookingId) {
        try {
            JsonObject json = new JsonObject();
            json.addProperty("bookingId", bookingId);
            
            String jsonBody = gson.toJson(json);
            sendRequest(API_BASE_URL + "/" + caregiverId + "/assign", "POST", jsonBody);
            return true;
        } catch (Exception e) {
            System.err.println("Error assigning caregiver: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Send HTTP request to Spring Boot API
     */
    private String sendRequest(String urlString, String method, String jsonBody) throws Exception {
        URL url = new URL(urlString);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod(method);
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setRequestProperty("Accept", "application/json");
        conn.setConnectTimeout(5000);
        conn.setReadTimeout(5000);
        
        // Send request body if present
        if (jsonBody != null && !jsonBody.isEmpty()) {
            conn.setDoOutput(true);
            try (OutputStream os = conn.getOutputStream()) {
                byte[] input = jsonBody.getBytes(StandardCharsets.UTF_8);
                os.write(input, 0, input.length);
            }
        }
        
        // Read response
        int responseCode = conn.getResponseCode();
        BufferedReader br;
        
        if (responseCode >= 200 && responseCode < 300) {
            br = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8));
        } else {
            br = new BufferedReader(new InputStreamReader(conn.getErrorStream(), StandardCharsets.UTF_8));
        }
        
        StringBuilder response = new StringBuilder();
        String line;
        while ((line = br.readLine()) != null) {
            response.append(line);
        }
        br.close();
        conn.disconnect();
        
        if (responseCode >= 400) {
            throw new RuntimeException("HTTP Error " + responseCode + ": " + response.toString());
        }
        
        return response.toString();
    }
    
    /**
     * Parse JSON array to list of caregivers
     */
    private List<Caregiver> parseCaregiverList(String json) {
        List<Caregiver> caregivers = new ArrayList<>();
        
        try {
            JsonArray jsonArray = JsonParser.parseString(json).getAsJsonArray();
            
            for (int i = 0; i < jsonArray.size(); i++) {
                JsonObject obj = jsonArray.get(i).getAsJsonObject();
                Caregiver caregiver = parseCaregiverFromJson(obj);
                if (caregiver != null) {
                    caregivers.add(caregiver);
                }
            }
        } catch (Exception e) {
            System.err.println("Error parsing caregiver list: " + e.getMessage());
            e.printStackTrace();
        }
        
        return caregivers;
    }
    
    /**
     * Parse JSON string to single caregiver
     */
    private Caregiver parseCaregiver(String json) {
        try {
            JsonObject obj = JsonParser.parseString(json).getAsJsonObject();
            return parseCaregiverFromJson(obj);
        } catch (Exception e) {
            System.err.println("Error parsing caregiver: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * Parse JsonObject to Caregiver model
     */
    private Caregiver parseCaregiverFromJson(JsonObject obj) {
        Caregiver caregiver = new Caregiver();
        
        if (obj.has("caregiverId")) caregiver.setCaregiverId(obj.get("caregiverId").getAsInt());
        if (obj.has("userId") && !obj.get("userId").isJsonNull()) 
            caregiver.setUserId(obj.get("userId").getAsInt());
        if (obj.has("name") && !obj.get("name").isJsonNull()) 
            caregiver.setName(obj.get("name").getAsString());
        if (obj.has("email") && !obj.get("email").isJsonNull()) 
            caregiver.setEmail(obj.get("email").getAsString());
        if (obj.has("phone") && !obj.get("phone").isJsonNull()) 
            caregiver.setPhone(obj.get("phone").getAsString());
        if (obj.has("qualifications") && !obj.get("qualifications").isJsonNull()) 
            caregiver.setQualifications(obj.get("qualifications").getAsString());
        if (obj.has("specialties") && !obj.get("specialties").isJsonNull()) 
            caregiver.setSpecialties(obj.get("specialties").getAsString());
        if (obj.has("experienceYears") && !obj.get("experienceYears").isJsonNull()) 
            caregiver.setExperienceYears(obj.get("experienceYears").getAsInt());
        else if (obj.has("experience") && !obj.get("experience").isJsonNull()) 
            caregiver.setExperienceYears(obj.get("experience").getAsInt());
        if (obj.has("bio") && !obj.get("bio").isJsonNull()) 
            caregiver.setBio(obj.get("bio").getAsString());
        if (obj.has("isAvailable") && !obj.get("isAvailable").isJsonNull()) 
            caregiver.setAvailable(obj.get("isAvailable").getAsBoolean());
        else if (obj.has("available") && !obj.get("available").isJsonNull()) 
            caregiver.setAvailable(obj.get("available").getAsBoolean());
        if (obj.has("availableHours") && !obj.get("availableHours").isJsonNull()) 
            caregiver.setAvailableHours(obj.get("availableHours").getAsString());
        if (obj.has("rating") && !obj.get("rating").isJsonNull()) 
            caregiver.setRating(obj.get("rating").getAsBigDecimal());
        if (obj.has("profileImage") && !obj.get("profileImage").isJsonNull()) 
            caregiver.setProfileImage(obj.get("profileImage").getAsString());
        if (obj.has("companyId") && !obj.get("companyId").isJsonNull()) 
            caregiver.setCompanyId(obj.get("companyId").getAsInt());
        
        return caregiver;
    }
}
