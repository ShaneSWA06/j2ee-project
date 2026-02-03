package service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import model.Service;

public class MedicalEscortServiceAPI {

    private static final String API_BASE_URL = "http://localhost:8081/user-ws";

    /**
     * Fetch all medical escort services from the Spring Boot API
     * Falls back to mock data if API is unavailable
     */
    public List<Service> getMedicalEscorts() {
        try {
            return fetchFromAPI();
        } catch (Exception e) {
            System.out.println("Warning: Could not connect to API, using mock data. Error: " + e.getMessage());
            return getMockEscorts();
        }
    }

    /**
     * Fetch medical escort services from the real Spring Boot API
     */
    private List<Service> fetchFromAPI() throws Exception {
        URL url = new java.net.URI(API_BASE_URL + "/medical-escorts").toURL();
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Accept", "application/json");
        conn.setConnectTimeout(5000); // 5 second timeout
        conn.setReadTimeout(5000);

        int responseCode = conn.getResponseCode();
        if (responseCode != 200) {
            throw new RuntimeException("Failed : HTTP error code : " + responseCode);
        }

        BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        StringBuilder response = new StringBuilder();
        String line;
        while ((line = br.readLine()) != null) {
            response.append(line);
        }
        br.close();
        conn.disconnect();

        // Parse JSON response manually (simple parsing without external libraries)
        return parseJsonResponse(response.toString());
    }

    /**
     * Simple JSON parser for medical escort services
     * Parses the JSON array response from the API
     */
    private List<Service> parseJsonResponse(String json) {
        List<Service> escorts = new ArrayList<>();
        
        // Remove outer array brackets
        json = json.trim();
        if (json.startsWith("[")) json = json.substring(1);
        if (json.endsWith("]")) json = json.substring(0, json.length() - 1);
        
        // Split by objects
        String[] objects = json.split("\\},\\{");
        
        for (String obj : objects) {
            obj = obj.replace("{", "").replace("}", "");
            
            Integer serviceId = null;
            String serviceName = null;
            String description = null;
            Double price = null;
            Integer duration = null;
            Integer maxBookings = null;
            Boolean available = null;
            
            // Parse each field
            String[] fields = obj.split(",(?=\\\"[^\\\"]*\\\":)");
            for (String field : fields) {
                String[] keyValue = field.split(":", 2);
                if (keyValue.length == 2) {
                    String key = keyValue[0].trim().replace("\"", "");
                    String value = keyValue[1].trim().replace("\"", "");
                    
                    switch (key) {
                        case "serviceId":
                            serviceId = Integer.parseInt(value);
                            break;
                        case "serviceName":
                            serviceName = value;
                            break;
                        case "description":
                            description = value;
                            break;
                        case "price":
                            price = Double.parseDouble(value);
                            break;
                        case "duration":
                            duration = Integer.parseInt(value);
                            break;
                        case "maxBookings":
                            maxBookings = Integer.parseInt(value);
                            break;
                        case "available":
                            available = Boolean.parseBoolean(value);
                            break;
                    }
                }
            }
            
            if (serviceId != null && serviceName != null) {
                escorts.add(new Service(serviceId, serviceName, description, 
                                       price != null ? price : 0.0, 
                                       duration != null ? duration : 0, 
                                       maxBookings != null ? maxBookings : 0, 
                                       available != null ? available : true));
            }
        }
        
        return escorts;
    }

    /**
     * Fallback mock data when API is unavailable
     */
    private List<Service> getMockEscorts() {
        List<Service> escorts = new ArrayList<>();
        escorts.add(new Service(101, "Basic Medical Escort", "Transport and company to medical appointments.", 50.00, 120, 99, true));
        escorts.add(new Service(102, "Nurse Escort", "Professional nurse accompaniment for dialysis/chemo.", 120.00, 120, 99, true));
        escorts.add(new Service(103, "Wheelchair Transport", "Specialized transport with trained medical staff.", 80.00, 60, 99, true));
        return escorts;
    }
}
