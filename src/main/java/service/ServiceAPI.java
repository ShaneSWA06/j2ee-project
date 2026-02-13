package service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import model.Category;
import model.Service;

public class ServiceAPI {
    
    private static final String SERVICE_API_URL = "https://assignmenttwo-fljm.onrender.com/user-ws/api/services";
    private static final String CATEGORY_API_URL = "https://assignmenttwo-fljm.onrender.com/user-ws/api/categories";
    
    private com.google.gson.Gson gson = new com.google.gson.Gson();
    
    public List<Service> getAllServices() {
        try {
            String json = sendRequest(SERVICE_API_URL, "GET", null);
            return parseServiceList(json);
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    public Service getServiceById(int id) {
        try {
            String json = sendRequest(SERVICE_API_URL + "/" + id, "GET", null);
            return parseService(json);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public Service createService(Service service) {
        try {
            String jsonBody = gson.toJson(service);
            String json = sendRequest(SERVICE_API_URL, "POST", jsonBody);
            return parseService(json);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public Service updateService(int id, Service service) {
        try {
            String jsonBody = gson.toJson(service);
            String json = sendRequest(SERVICE_API_URL + "/" + id, "PUT", jsonBody);
            return parseService(json);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public boolean deleteService(int id) {
        try {
            sendRequest(SERVICE_API_URL + "/" + id, "DELETE", null);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public Category getCategoryById(int id) {
        try {
            String json = sendRequest(CATEGORY_API_URL + "/" + id, "GET", null);
            return parseCategory(json);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public Category createCategory(Category category) {
        try {
            String jsonBody = gson.toJson(category);
            String json = sendRequest(CATEGORY_API_URL, "POST", jsonBody);
            return parseCategory(json);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public Category updateCategory(int id, Category category) {
        try {
            String jsonBody = gson.toJson(category);
            String json = sendRequest(CATEGORY_API_URL + "/" + id, "PUT", jsonBody);
            return parseCategory(json);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public boolean deleteCategory(int id) {
        try {
            sendRequest(CATEGORY_API_URL + "/" + id, "DELETE", null);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    private String sendRequest(String urlString, String method, String jsonBody) throws Exception {
        java.net.URL url = java.net.URI.create(urlString).toURL();
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod(method);
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setRequestProperty("Accept", "application/json");
        
        if (jsonBody != null) {
            conn.setDoOutput(true);
            try (OutputStream os = conn.getOutputStream()) {
                os.write(jsonBody.getBytes(StandardCharsets.UTF_8));
            }
        }
        
        int responseCode = conn.getResponseCode();
        BufferedReader br = new BufferedReader(new InputStreamReader(
            (responseCode >= 200 && responseCode < 300) ? conn.getInputStream() : conn.getErrorStream(), 
            StandardCharsets.UTF_8));
        
        StringBuilder response = new StringBuilder();
        String line;
        while ((line = br.readLine()) != null) response.append(line);
        br.close();
        
        if (responseCode >= 400) throw new RuntimeException("HTTP Error " + responseCode);
        return response.toString();
    }
    
    private List<Service> parseServiceList(String json) {
        List<Service> services = new ArrayList<>();
        JsonArray array = JsonParser.parseString(json).getAsJsonArray();
        for (int i = 0; i < array.size(); i++) {
            services.add(parseServiceFromJson(array.get(i).getAsJsonObject()));
        }
        return services;
    }
    
    private Service parseService(String json) {
        return parseServiceFromJson(JsonParser.parseString(json).getAsJsonObject());
    }
    
    public List<Category> getAllCategories() {
        try {
            String json = sendRequest(CATEGORY_API_URL, "GET", null);
            return parseCategoryList(json);
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public List<Service> searchServices(String query, Integer categoryId) {
        try {
            // Since the Spring Boot API doesn't have a dedicated /search endpoint,
            // we fetch all services and filter them on the client side to provide 
            // the AJAX search functionality to the J2EE frontend.
            List<Service> allServices = getAllServices();
            if (allServices == null) return new ArrayList<>();

            String lowerQuery = query.toLowerCase();
            return allServices.stream()
                .filter(s -> {
                    // Category filter
                    if (categoryId != null && s.getCategoryId() != categoryId) {
                        return false;
                    }
                    // Keyword filter
                    if (query.isEmpty()) return true;
                    
                    boolean matchName = s.getServiceName() != null && s.getServiceName().toLowerCase().contains(lowerQuery);
                    boolean matchDesc = s.getDescription() != null && s.getDescription().toLowerCase().contains(lowerQuery);
                    boolean matchCat = s.getCategoryName() != null && s.getCategoryName().toLowerCase().contains(lowerQuery);
                    
                    return matchName || matchDesc || matchCat;
                })
                .collect(java.util.stream.Collectors.toList());
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    private Category parseCategory(String json) {
        return parseCategoryFromJson(com.google.gson.JsonParser.parseString(json).getAsJsonObject());
    }

    private List<Category> parseCategoryList(String json) {
        List<Category> categories = new ArrayList<>();
        com.google.gson.JsonArray array = com.google.gson.JsonParser.parseString(json).getAsJsonArray();
        for (int i = 0; i < array.size(); i++) {
            categories.add(parseCategoryFromJson(array.get(i).getAsJsonObject()));
        }
        return categories;
    }

    private Category parseCategoryFromJson(JsonObject obj) {
        Category c = new Category();
        if (obj.has("categoryId")) c.setCategoryId(obj.get("categoryId").getAsInt());
        
        if (obj.has("categoryName")) {
            c.setCategoryName(obj.get("categoryName").getAsString());
        } else if (obj.has("name")) {
            c.setCategoryName(obj.get("name").getAsString());
        }
        
        if (obj.has("description")) c.setDescription(obj.get("description").getAsString());
        return c;
    }

    private Service parseServiceFromJson(JsonObject obj) {
        Service s = new Service();
        if (obj.has("serviceId")) s.setServiceId(obj.get("serviceId").getAsInt());
        if (obj.has("serviceName")) s.setServiceName(obj.get("serviceName").getAsString());
        if (obj.has("description")) s.setDescription(obj.get("description").getAsString());
        if (obj.has("basePrice")) s.setBasePrice(obj.get("basePrice").getAsDouble());
        if (obj.has("durationMinutes")) s.setDurationMinutes(obj.get("durationMinutes").getAsInt());
        
        // Handle Category information (can be nested or flat)
        if (obj.has("category") && !obj.get("category").isJsonNull()) {
            JsonObject catObj = obj.getAsJsonObject("category");
            if (catObj.has("categoryId")) s.setCategoryId(catObj.get("categoryId").getAsInt());
            
            // Check for categoryName or name
            if (catObj.has("categoryName")) {
                s.setCategoryName(catObj.get("categoryName").getAsString());
            } else if (catObj.has("name")) {
                s.setCategoryName(catObj.get("name").getAsString());
            }
        }
        
        // Fallback or override for flat properties
        if (obj.has("categoryId") && s.getCategoryId() == 0) {
            s.setCategoryId(obj.get("categoryId").getAsInt());
        }
        if (s.getCategoryName() == null) {
            if (obj.has("categoryName")) {
                s.setCategoryName(obj.get("categoryName").getAsString());
            } else if (obj.has("name")) {
                s.setCategoryName(obj.get("name").getAsString());
            }
        }
        
        return s;
    }
}
