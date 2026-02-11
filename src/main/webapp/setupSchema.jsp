<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="db.DBUtil" %>
<jsp:include page="includes/header.jsp"><jsp:param name="title" value="Setup Schema"/></jsp:include>
<jsp:include page="includes/navbar.jsp"/>
<div class="container">
<h1>Initialize Database</h1>
<%
Connection conn = null;
Statement stmt = null;
try {
  conn = DBUtil.getConnection();
  stmt = conn.createStatement();
  stmt.execute("CREATE TABLE IF NOT EXISTS app_user ("+
               "user_id SERIAL PRIMARY KEY, "+
               "username VARCHAR(100) UNIQUE NOT NULL, "+
               "email VARCHAR(150) UNIQUE NOT NULL, "+
               "password VARCHAR(255) NOT NULL, "+
               "role VARCHAR(20) NOT NULL DEFAULT 'CUSTOMER' CHECK (role IN ('ADMIN', 'CUSTOMER')), "+
               "name VARCHAR(120), "+
               "phone VARCHAR(50), "+
               "relationship VARCHAR(40), "+
               "address TEXT, "+
               "care_notes TEXT, "+
               "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, "+
               "updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");
  stmt.execute("CREATE TABLE IF NOT EXISTS service_category ("+
               "category_id SERIAL PRIMARY KEY, "+
               "category_name VARCHAR(120) NOT NULL, "+
               "description TEXT)");
  stmt.execute("CREATE TABLE IF NOT EXISTS service ("+
               "service_id SERIAL PRIMARY KEY, "+
               "service_name VARCHAR(150) NOT NULL, "+
               "category_id INTEGER REFERENCES service_category(category_id) ON DELETE SET NULL, "+
               "description TEXT, "+
               "base_price NUMERIC(10,2), "+
               "duration_minutes INTEGER, "+
               "is_active BOOLEAN DEFAULT TRUE)");

  stmt.execute("CREATE TABLE IF NOT EXISTS caregiver ("+
               "caregiver_id SERIAL PRIMARY KEY, "+
               "name VARCHAR(120) NOT NULL, "+
               "qualifications TEXT, "+
               "specialties TEXT, "+
               "experience_years INTEGER, "+
               "bio TEXT, "+
               "phone VARCHAR(50), "+
               "email VARCHAR(150), "+
               "is_active BOOLEAN DEFAULT TRUE, "+
               "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");
  stmt.execute("CREATE TABLE IF NOT EXISTS booking ("+
               "booking_id SERIAL PRIMARY KEY, "+
               "user_id INTEGER NOT NULL REFERENCES app_user(user_id) ON DELETE CASCADE, "+
               "service_id INTEGER NOT NULL REFERENCES service(service_id) ON DELETE CASCADE, "+
               "caregiver_id INTEGER REFERENCES caregiver(caregiver_id) ON DELETE SET NULL, "+
               "booking_date DATE NOT NULL, "+
               "booking_time TIME NOT NULL, "+
               "status VARCHAR(20) DEFAULT 'Pending' CHECK (status IN ('Pending', 'Confirmed', 'Completed', 'Cancelled')), "+
               "notes TEXT, "+
               "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");

  stmt.execute("CREATE TABLE IF NOT EXISTS feedback ("+
               "feedback_id SERIAL PRIMARY KEY, "+
               "user_id INTEGER NOT NULL REFERENCES app_user(user_id) ON DELETE CASCADE, "+
               "caregiver_id INTEGER REFERENCES caregiver(caregiver_id) ON DELETE SET NULL, "+
               "booking_id INTEGER REFERENCES booking(booking_id) ON DELETE SET NULL, "+
               "star_rating INTEGER NOT NULL CHECK (star_rating >= 1 AND star_rating <= 5), "+
               "comment TEXT, "+
               "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");

  // Add image columns if not exist
  try {
      stmt.execute("ALTER TABLE service ADD COLUMN IF NOT EXISTS image_url VARCHAR(255)");
  } catch(Exception e) { /* ignore if exists */ }
  
  try {
      stmt.execute("ALTER TABLE caregiver ADD COLUMN IF NOT EXISTS profile_image VARCHAR(255)");
  } catch(Exception e) { /* ignore if exists */ }

  try {
      stmt.execute("ALTER TABLE app_user ADD COLUMN IF NOT EXISTS medical_history TEXT");
  } catch(Exception e) { /* ignore if exists */ }
  
  try {
      stmt.execute("ALTER TABLE app_user ADD COLUMN IF NOT EXISTS allergies TEXT");
  } catch(Exception e) { /* ignore if exists */ }


  stmt.executeUpdate("INSERT INTO app_user(username, email, password, role, name) "+
                     "SELECT 'admin', 'admin@silvercare.com', 'admin123', 'ADMIN', 'Administrator' "+
                     "WHERE NOT EXISTS(SELECT 1 FROM app_user WHERE username='admin')");
  stmt.executeUpdate("INSERT INTO service_category(category_name, description) "+
                     "SELECT 'Personal Care', 'Bathing, dressing, toileting' "+
                     "WHERE NOT EXISTS(SELECT 1 FROM service_category WHERE category_name='Personal Care')");
  stmt.executeUpdate("INSERT INTO service_category(category_name, description) "+
                     "SELECT 'Home Cleaning & Chores', 'General cleaning and tidying' "+
                     "WHERE NOT EXISTS(SELECT 1 FROM service_category WHERE category_name='Home Cleaning & Chores')");
  stmt.executeUpdate("INSERT INTO service_category(category_name, description) "+
                     "SELECT 'Medical Escort & Mobility Support', 'Clinic visits and assistance' "+
                     "WHERE NOT EXISTS(SELECT 1 FROM service_category WHERE category_name='Medical Escort & Mobility Support')");
  stmt.executeUpdate("INSERT INTO service_category(category_name, description) "+
                     "SELECT 'Companionship & Social Visits', 'Friendly visits and chats' "+
                     "WHERE NOT EXISTS(SELECT 1 FROM service_category WHERE category_name='Companionship & Social Visits')");
  stmt.executeUpdate("INSERT INTO service_category(category_name, description) "+
                     "SELECT 'Meal Preparation', 'Healthy meals and assistance' "+
                     "WHERE NOT EXISTS(SELECT 1 FROM service_category WHERE category_name='Meal Preparation')");
  stmt.executeUpdate("INSERT INTO service(service_name, category_id, description, base_price, duration_minutes, is_active) "+
                     "SELECT 'Weekly Home Cleaning (2 hrs)', c.category_id, 'General cleaning for seniors', 60.00, 120, TRUE "+
                     "FROM service_category c WHERE c.category_name='Home Cleaning & Chores' "+
                     "AND NOT EXISTS(SELECT 1 FROM service s WHERE s.service_name='Weekly Home Cleaning (2 hrs)')");
  stmt.executeUpdate("INSERT INTO service(service_name, category_id, description, base_price, duration_minutes, is_active) "+
                     "SELECT 'Medical Escort', c.category_id, 'Escort to clinic visits', 40.00, 90, TRUE "+
                     "FROM service_category c WHERE c.category_name='Medical Escort & Mobility Support' "+
                     "AND NOT EXISTS(SELECT 1 FROM service s WHERE s.service_name='Medical Escort')");
  stmt.executeUpdate("INSERT INTO caregiver(name, qualifications, specialties, experience_years, bio, phone, email, is_active) "+
                     "SELECT 'Sarah Johnson', 'Certified Nursing Assistant (CNA), First Aid Certified', 'Personal Care, Mobility Assistance', 5, "+
                     "'Sarah has been providing compassionate care for seniors for over 5 years. She specializes in personal care and helping with daily activities.', "+
                     "'555-0101', 'sarah.j@silvercare.com', TRUE "+
                     "WHERE NOT EXISTS(SELECT 1 FROM caregiver WHERE email='sarah.j@silvercare.com')");
  stmt.executeUpdate("INSERT INTO caregiver(name, qualifications, specialties, experience_years, bio, phone, email, is_active) "+
                     "SELECT 'Michael Chen', 'Licensed Practical Nurse (LPN), CPR Certified', 'Medical Support, Medication Management', 8, "+
                     "'Michael brings 8 years of nursing experience to home care. He is skilled in medication management and medical escort services.', "+
                     "'555-0102', 'michael.c@silvercare.com', TRUE "+
                     "WHERE NOT EXISTS(SELECT 1 FROM caregiver WHERE email='michael.c@silvercare.com')");
  stmt.executeUpdate("INSERT INTO caregiver(name, qualifications, specialties, experience_years, bio, phone, email, is_active) "+
                     "SELECT 'Emily Rodriguez', 'Home Health Aide Certificate, Dementia Care Specialist', 'Companionship, Meal Preparation', 3, "+
                     "'Emily is passionate about providing companionship and preparing nutritious meals for seniors. She has special training in dementia care.', "+
                     "'555-0103', 'emily.r@silvercare.com', TRUE "+
                     "WHERE NOT EXISTS(SELECT 1 FROM caregiver WHERE email='emily.r@silvercare.com')");
  out.print("<div class='card'><p>Schema initialized successfully.</p></div>");
} catch (Exception e) {
  out.print("<div class='card'><p>Setup error: "+e.getMessage()+"</p></div>");
} finally {
  try { if (stmt!=null) stmt.close(); } catch(Exception ignore){}
  try { if (conn!=null) conn.close(); } catch(Exception ignore){}
}
%>
</div>
<jsp:include page="includes/footer.jsp"/>