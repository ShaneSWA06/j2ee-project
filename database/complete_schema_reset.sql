-- =====================================================
-- SILVER CAREGIVERS - COMPLETE DATABASE SCHEMA
-- Fresh Start with All Features
-- =====================================================

-- Drop existing tables (in correct order to handle foreign keys)
DROP TABLE IF EXISTS feedback CASCADE;
DROP TABLE IF EXISTS payment CASCADE;
DROP TABLE IF EXISTS booking CASCADE;
DROP TABLE IF EXISTS medical_escort_service CASCADE;
DROP TABLE IF EXISTS service CASCADE;
DROP TABLE IF EXISTS service_category CASCADE;
DROP TABLE IF EXISTS caregiver CASCADE;
DROP TABLE IF EXISTS app_user CASCADE;
DROP TABLE IF EXISTS company CASCADE;

-- =====================================================
-- 0. COMPANY TABLE (Agency Partners)
-- =====================================================
CREATE TABLE company (
    company_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    address TEXT,
    phone VARCHAR(20),
    email VARCHAR(255),
    website VARCHAR(255),
    logo_url VARCHAR(500),
    rating DECIMAL(3,2) DEFAULT 0.00,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- 1. APP_USER TABLE (Main User Authentication)
-- =====================================================
CREATE TABLE app_user (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(100) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL, -- BCrypt hashed
    name VARCHAR(255),
    phone VARCHAR(20),
    address TEXT,
    relationship VARCHAR(100),
    care_notes TEXT,
    role VARCHAR(20) NOT NULL DEFAULT 'CUSTOMER', -- ADMIN, CUSTOMER, CAREGIVER, COMPANY_ADMIN
    verified BOOLEAN DEFAULT FALSE,
    verification_token VARCHAR(255),
    reset_token VARCHAR(255),
    reset_token_expiry TIMESTAMP,
    company_id INTEGER REFERENCES company(company_id) ON DELETE SET NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- 2. CAREGIVER TABLE (Caregiver Profiles)
-- =====================================================
CREATE TABLE caregiver (
    caregiver_id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES app_user(user_id) ON DELETE SET NULL,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    phone VARCHAR(20),
    qualifications TEXT,
    specialties TEXT, -- e.g., "Dementia Care, Elderly Care, Mobility Assistance"
    experience INTEGER, -- Years of experience
    bio TEXT,
    available BOOLEAN DEFAULT TRUE,
    available_hours VARCHAR(255), -- e.g., "Mon-Fri 9AM-5PM"
    rating DECIMAL(3,2) DEFAULT 0.00, -- Average rating 0.00-5.00
    profile_image VARCHAR(500),
    company_id INTEGER REFERENCES company(company_id) ON DELETE SET NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- 3. SERVICE_CATEGORY TABLE
-- =====================================================
CREATE TABLE service_category (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(255) NOT NULL,
    description TEXT,
    image_url VARCHAR(500),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- 4. SERVICE TABLE (Care Services)
-- =====================================================
CREATE TABLE service (
    service_id SERIAL PRIMARY KEY,
    category_id INTEGER REFERENCES service_category(category_id) ON DELETE CASCADE,
    service_name VARCHAR(255) NOT NULL,
    description TEXT,
    base_price DECIMAL(10,2) NOT NULL,
    duration_minutes INTEGER, -- Duration in minutes
    max_bookings INTEGER DEFAULT 99,
    is_active BOOLEAN DEFAULT TRUE,
    image_url VARCHAR(500),
    company_id INTEGER REFERENCES company(company_id) ON DELETE SET NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- 5. MEDICAL_ESCORT_SERVICE TABLE (Special Services)
-- =====================================================
CREATE TABLE medical_escort_service (
    service_id SERIAL PRIMARY KEY,
    service_name VARCHAR(255) NOT NULL,
    description TEXT,
    base_price DECIMAL(10,2) NOT NULL,
    duration_minutes INTEGER, -- Duration in minutes
    max_bookings INTEGER DEFAULT 99,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- 6. BOOKING TABLE (Service Bookings)
-- =====================================================
CREATE TABLE booking (
    booking_id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES app_user(user_id) ON DELETE CASCADE,
    service_id INTEGER REFERENCES service(service_id) ON DELETE SET NULL,
    caregiver_id INTEGER REFERENCES caregiver(caregiver_id) ON DELETE SET NULL,
    booking_date DATE NOT NULL,
    booking_time TIME NOT NULL,
    pickup_address TEXT,
    destination_address TEXT,
    total_price DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) DEFAULT 'PENDING', -- PENDING, CONFIRMED, COMPLETED, CANCELLED
    notes TEXT,
    payment_status VARCHAR(50) DEFAULT 'Unpaid',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- 7. PAYMENT TABLE (Payment Records)
-- =====================================================
CREATE TABLE payment (
    payment_id SERIAL PRIMARY KEY,
    booking_id INTEGER REFERENCES booking(booking_id) ON DELETE CASCADE,
    user_id INTEGER REFERENCES app_user(user_id) ON DELETE CASCADE,
    amount DECIMAL(10,2) NOT NULL,
    currency VARCHAR(10) DEFAULT 'SGD',
    payment_method VARCHAR(50), -- STRIPE, CASH, BANK_TRANSFER
    transaction_id VARCHAR(255), -- Global transaction reference (e.g. Stripe PaymentIntent ID)
    status VARCHAR(20) DEFAULT 'PENDING', -- PENDING, COMPLETED, FAILED, REFUNDED
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- 8. FEEDBACK TABLE (Customer Feedback & Ratings)
-- =====================================================
CREATE TABLE feedback (
    feedback_id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES app_user(user_id) ON DELETE CASCADE,
    caregiver_id INTEGER REFERENCES caregiver(caregiver_id) ON DELETE CASCADE,
    booking_id INTEGER REFERENCES booking(booking_id) ON DELETE CASCADE,
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- INDEXES for Performance
-- =====================================================
CREATE INDEX idx_app_user_email ON app_user(email);
CREATE INDEX idx_app_user_username ON app_user(username);
CREATE INDEX idx_app_user_role ON app_user(role);
CREATE INDEX idx_caregiver_user_id ON caregiver(user_id);
CREATE INDEX idx_caregiver_available ON caregiver(available);
CREATE INDEX idx_service_category_name ON service_category(category_name);
CREATE INDEX idx_service_is_active ON service(is_active);
CREATE INDEX idx_booking_user_id ON booking(user_id);
CREATE INDEX idx_booking_caregiver_id ON booking(caregiver_id);
CREATE INDEX idx_booking_status ON booking(status);
CREATE INDEX idx_booking_date ON booking(booking_date);
CREATE INDEX idx_payment_booking_id ON payment(booking_id);
CREATE INDEX idx_feedback_caregiver_id ON feedback(caregiver_id);

-- =====================================================
-- SAMPLE DATA - Admin User
-- =====================================================
-- Password: admin123 (BCrypt hashed)
INSERT INTO app_user (username, email, password, name, role, verified) VALUES
('admin', 'system@shalommedcare.sg', 'admin123', 'System Admin', 'ADMIN', TRUE);

-- =====================================================
-- SAMPLE DATA - Companies (Agencies)
-- =====================================================
INSERT INTO company (name, description, address, phone, email, website, rating) VALUES
('Shalom Medcare', 'Professional and compassionate medical escort service providing accompaniment for hospital and clinic visits.', '101 Medical Lane, Singapore', '6555-1234', 'contact@shalommedcare.sg', 'http://www.shalommedcare.sg', 4.9),
('Rapid Clinic Support', 'Focusing on efficient and safe transport for dialysis and outpatient treatments.', '202 Hospital Way, Singapore', '6555-5678', 'info@rapidsupport.sg', 'http://www.rapidsupport.sg', 4.7);

-- =====================================================
-- SAMPLE DATA - Company Admin
-- =====================================================
-- Password: admin123 (BCrypt hashed)
INSERT INTO app_user (username, email, password, name, role, verified, company_id) VALUES
('shalom.admin', 'admin@shalommedcare.sg', 'admin123', 'Agency Manager', 'COMPANY_ADMIN', TRUE, 1);

-- =====================================================
-- SAMPLE DATA - Service Categories
-- =====================================================
INSERT INTO service_category (category_name, description) VALUES
('Hospital Escorts', 'Accompaniment to Government or Private Hospitals'),
('Clinic & Specialist', 'Assistance with polyclinic and specialized clinic visits'),
('Regular Treatments', 'Ongoing support for Dialysis, Chemotherapy, or Physiotherapy'),
('Home-to-Home', 'End-to-end escort for transfers between residences');

-- =====================================================
-- SAMPLE DATA - Services
-- =====================================================
INSERT INTO service (category_id, service_name, description, base_price, duration_minutes, is_active, company_id) VALUES
(1, 'Full-Day Hospital Escort', 'Complete сопровождение for day-long hospital procedures', 120.00, 480, TRUE, 1),
(1, 'Outpatient Doc-Appt', '2-3 hour assistance for doctor consultations', 55.00, 180, TRUE, 1),
(2, 'Clinic Visit Basic', 'Simple escort to nearby polyclinics', 40.00, 120, TRUE, 1),
(2, 'Health Screening Escort', 'Assistance during long diagnostic health screenings', 75.00, 240, TRUE, 1),
(3, 'Recurring Dialysis Support', 'Standard 4-hour dialysis session accompaniment', 60.00, 240, TRUE, 2),
(3, 'Monthly Chemo Escort', 'Supportive care during chemotherapy sessions', 90.00, 360, TRUE, 2),
(4, 'Inter-Hospital Transfer', 'Safe escort during hospital-to-hospital movements', 100.00, 180, TRUE, 2);

-- =====================================================
-- SAMPLE DATA - Medical Escort Services
-- =====================================================
INSERT INTO medical_escort_service (service_name, description, base_price, duration_minutes, is_active) VALUES
('Basic Medical Escort', 'Transport and company to medical appointments', 50.00, 120, TRUE),
('Nurse Escort', 'Professional nurse accompaniment for dialysis/chemo', 120.00, 180, TRUE),
('Wheelchair Transport', 'Specialized transport with trained medical staff', 80.00, 60, TRUE);

-- =====================================================
-- SAMPLE DATA - Caregivers
-- =====================================================
INSERT INTO caregiver (name, email, phone, qualifications, specialties, experience, bio, available, available_hours, rating, company_id) VALUES
('Jane Smith', 'jane.smith@shalommedcare.sg', '555-0101', 'Registered Nurse, CPR Certified', 'Elderly Care, Dementia Care, Medical Escort', 8, 'Experienced caregiver specializing in elderly and dementia care with over 8 years of professional experience.', TRUE, 'Mon-Fri 8AM-6PM', 4.8, 1),
('Michael Chen', 'michael.chen@shalommedcare.sg', '555-0102', 'Certified Nursing Assistant, First Aid', 'Personal Care, Mobility Assistance, Companionship', 5, 'Compassionate caregiver focused on personal care and mobility assistance.', TRUE, 'Mon-Sun 9AM-5PM', 4.9, 1),
('Emily Rodriguez', 'emily.rodriguez@shalommedcare.sg', '555-0103', 'Licensed Practical Nurse', 'Post-Surgery Care, Medication Management, Wound Care', 10, 'Highly experienced in post-operative care and medical procedures.', TRUE, 'Mon-Fri 7AM-7PM', 5.0, 2),
('David Williams', 'david.williams@shalommedcare.sg', '555-0104', 'Dementia Care Specialist', 'Dementia Care, Alzheimer''s Care, Memory Care', 6, 'Specialized in dementia and Alzheimer''s care with patience and understanding.', TRUE, 'Tue-Sat 10AM-6PM', 4.7, 2);

-- =====================================================
-- SAMPLE DATA - Customer Users
-- =====================================================
-- Password: admin123 (BCrypt hashed)
INSERT INTO app_user (username, email, password, name, phone, address, role, verified) VALUES
('john.doe', 'john.doe@example.com', 'admin123', 'John Doe', '555-1001', '123 Main St, Singapore', 'CUSTOMER', TRUE),
('mary.tan', 'mary.tan@example.com', 'admin123', 'Mary Tan', '555-1002', '456 Oak Ave, Singapore', 'CUSTOMER', TRUE);

-- =====================================================
-- SAMPLE DATA - Caregiver Users (linked to caregivers)
-- =====================================================
-- Password: admin123 (BCrypt hashed)
INSERT INTO app_user (username, email, password, name, phone, role, verified) VALUES
('jane.smith', 'jane.smith@shalommedcare.sg', 'admin123', 'Jane Smith', '555-0101', 'CAREGIVER', TRUE),
('michael.chen', 'michael.chen@shalommedcare.sg', 'admin123', 'Michael Chen', '555-0102', 'CAREGIVER', TRUE),
('emily.rodriguez', 'emily.rodriguez@shalommedcare.sg', 'admin123', 'Emily Rodriguez', '555-0103', 'CAREGIVER', TRUE),
('david.williams', 'david.williams@shalommedcare.sg', 'admin123', 'David Williams', '555-0104', 'CAREGIVER', TRUE);

-- Link caregivers to users
UPDATE caregiver SET user_id = (SELECT user_id FROM app_user WHERE email = 'jane.smith@shalommedcare.sg') WHERE email = 'jane.smith@shalommedcare.sg';
UPDATE caregiver SET user_id = (SELECT user_id FROM app_user WHERE email = 'michael.chen@shalommedcare.sg') WHERE email = 'michael.chen@shalommedcare.sg';
UPDATE caregiver SET user_id = (SELECT user_id FROM app_user WHERE email = 'emily.rodriguez@shalommedcare.sg') WHERE email = 'emily.rodriguez@shalommedcare.sg';
UPDATE caregiver SET user_id = (SELECT user_id FROM app_user WHERE email = 'david.williams@shalommedcare.sg') WHERE email = 'david.williams@shalommedcare.sg';

-- =====================================================
-- SAMPLE DATA - Bookings
-- =====================================================
-- Note: user_id 2 = john.doe, user_id 3 = mary.tan
-- caregiver_id 1 = Jane Smith, 2 = Michael Chen, 3 = Emily Rodriguez, 4 = David Williams
INSERT INTO booking (user_id, service_id, caregiver_id, booking_date, booking_time, total_price, status, notes) VALUES
(2, 1, 1, CURRENT_DATE + INTERVAL '2 days', '10:00:00', 120.00, 'CONFIRMED', 'Assistance for full-day surgery accompaniment'),
(2, 3, 2, CURRENT_DATE + INTERVAL '3 days', '14:00:00', 40.00, 'PENDING', 'Routine polyclinic checkup escort'),
(3, 5, 4, CURRENT_DATE + INTERVAL '5 days', '09:00:00', 60.00, 'CONFIRMED', 'Weekly dialysis session support');

-- =====================================================
-- VERIFICATION QUERIES
-- =====================================================
-- Run these to verify the setup:

-- SELECT COUNT(*) as total_users FROM app_user;
-- SELECT COUNT(*) as total_caregivers FROM caregiver;
-- SELECT COUNT(*) as total_services FROM service;
-- SELECT COUNT(*) as total_bookings FROM booking;

-- SELECT * FROM app_user ORDER BY user_id;
-- SELECT * FROM caregiver ORDER BY caregiver_id;
-- SELECT * FROM service_category ORDER BY category_id;
-- SELECT * FROM service ORDER BY service_id;

-- =====================================================
-- DEFAULT LOGIN CREDENTIALS
-- =====================================================
/*
ADMIN:
  Username: admin
  Password: admin123

CUSTOMERS:
  Username: john.doe
  Password: admin123
  
  Username: mary.tan
  Password: admin123

CAREGIVERS:
  Username: jane.smith
  Password: admin123
  
  Username: michael.chen
  Password: admin123
  
  Username: emily.rodriguez
  Password: admin123
  
  Username: david.williams
  Password: admin123
*/

-- =====================================================
-- SCRIPT COMPLETE
-- =====================================================
-- Database: silvercare (or your database name)
-- Total Tables: 8
-- Sample Users: 7 (1 admin, 2 customers, 4 caregivers)
-- Sample Caregivers: 4
-- Sample Services: 10
-- Sample Categories: 4
-- Sample Bookings: 3
-- =====================================================
