package dao;

import model.Service;
import java.sql.SQLException;
import java.util.List;

/**
 * ServiceDAO - Data Access Object interface for Service operations
 */
public interface ServiceDAO {
    
    /**
     * Get service by ID
     */
    Service getServiceById(int serviceId) throws SQLException;
    
    /**
     * Get all services (active and inactive)
     */
    List<Service> getAllServices() throws SQLException;
    
    /**
     * Get only active services
     */
    List<Service> getActiveServices() throws SQLException;
    
    /**
     * Get services by category ID
     */
    List<Service> getServicesByCategory(int categoryId) throws SQLException;
    
    /**
     * Create a new service
     * @return the created service with generated ID
     */
    Service createService(Service service) throws SQLException;
    
    /**
     * Update existing service
     */
    boolean updateService(Service service) throws SQLException;
    
    /**
     * Delete service by ID
     */
    boolean deleteService(int serviceId) throws SQLException;
}
