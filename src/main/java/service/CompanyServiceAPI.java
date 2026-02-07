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
import com.google.gson.JsonParser;

import model.Caregiver;
import model.Company;

/**
 * API Client for Spring Boot Company REST API
 */
public class CompanyServiceAPI {
    
    private static final String API_BASE_URL = "http://localhost:8081/user-ws/api/companies";
    private Gson gson = new Gson();
    
    public Company getCompanyById(int id) {
        try {
            String json = sendRequest(API_BASE_URL + "/" + id, "GET", null);
            return gson.fromJson(json, Company.class);
        } catch (Exception e) {
            System.err.println("Error fetching company: " + e.getMessage());
            return null;
        }
    }
    
    public List<Caregiver> getCaregiversByCompany(int id) {
        try {
            String json = sendRequest(API_BASE_URL + "/" + id + "/caregivers", "GET", null);
            return parseCaregiverList(json);
        } catch (Exception e) {
            System.err.println("Error fetching company caregivers: " + e.getMessage());
            return new ArrayList<>();
        }
    }
    
    private String sendRequest(String urlString, String method, String jsonBody) throws Exception {
        URL url = new URL(urlString);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod(method);
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setRequestProperty("Accept", "application/json");
        
        if (jsonBody != null && !jsonBody.isEmpty()) {
            conn.setDoOutput(true);
            try (OutputStream os = conn.getOutputStream()) {
                os.write(jsonBody.getBytes(StandardCharsets.UTF_8));
            }
        }
        
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
            throw new RuntimeException("HTTP Error " + responseCode);
        }
        
        return response.toString();
    }
    
    private List<Caregiver> parseCaregiverList(String json) {
        List<Caregiver> caregivers = new ArrayList<>();
        try {
            JsonArray jsonArray = JsonParser.parseString(json).getAsJsonArray();
            for (int i = 0; i < jsonArray.size(); i++) {
                caregivers.add(gson.fromJson(jsonArray.get(i), Caregiver.class));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return caregivers;
    }
}
