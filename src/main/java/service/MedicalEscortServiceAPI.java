package service;

import java.util.ArrayList;
import java.util.List;
import model.Service;

public class MedicalEscortServiceAPI {

    // private static final String API_URL = "http://localhost:8081/api/medical-escorts";

    public List<Service> getMedicalEscorts() {
        // Since we don't have org.json library in the classpath, 
        // and the API is not running yet, we will return the mock data directly.
        // In a real implementation, we would add the Jackson or Gson library to pom.xml/classpath.
        return getMockEscorts();
    }

    private List<Service> getMockEscorts() {
        List<Service> escorts = new ArrayList<>();
        escorts.add(new Service(101, "Basic Medical Escort", "Transport and company to medical appointments.", 50.00, 120, 99, true));
        escorts.add(new Service(102, "Nurse Escort", "Professional nurse accompaniment for dialysis/chemo.", 120.00, 120, 99, true));
        escorts.add(new Service(103, "Wheelchair Transport", "Specialized transport with trained medical staff.", 80.00, 60, 99, true));
        return escorts;
    }
}
