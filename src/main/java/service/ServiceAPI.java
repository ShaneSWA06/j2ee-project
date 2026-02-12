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

import model.Service;

public class ServiceAPI {
    
    private static final String API_BASE_URL = "https://assignmenttwo-fljm.onrender.com/user-ws/api/services";
    private Gson gson = new Gson();
    
    public List<Service> getAllServices() {
        try {
            String json = sendRequest(API_BASE_URL, "GET", null);
            return parseServiceList(json);
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    public Service getServiceById(int id) {
        try {
            String json = sendRequest(API_BASE_URL + "/" + id, "GET", null);
            return parseService(json);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    
    private String sendRequest(String urlString, String method, String jsonBody) throws Exception {
        URL url = new URL(urlString);
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
    
    private Service parseServiceFromJson(JsonObject obj) {
        Service s = new Service();
        if (obj.has("serviceId")) s.setServiceId(obj.get("serviceId").getAsInt());
        if (obj.has("serviceName")) s.setServiceName(obj.get("serviceName").getAsString());
        if (obj.has("description")) s.setDescription(obj.get("description").getAsString());
        if (obj.has("basePrice")) s.setBasePrice(obj.get("basePrice").getAsDouble());
        if (obj.has("durationMinutes")) s.setDurationMinutes(obj.get("durationMinutes").getAsInt());
        if (obj.has("categoryId")) s.setCategoryId(obj.get("categoryId").getAsInt());
        return s;
    }
}
