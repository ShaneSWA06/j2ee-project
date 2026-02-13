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
    medical_history TEXT,
    allergies TEXT,
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
    status VARCHAR(50) DEFAULT 'Pending', -- Pending, Confirmed, In-Progress, Completed, Cancelled
    caregiver_status VARCHAR(50) DEFAULT 'Pending', -- Pending, Accepted, Rejected
    payment_status VARCHAR(50) DEFAULT 'Unpaid',
    notes TEXT,
    clock_in_time TIMESTAMP,
    clock_out_time TIMESTAMP,
    clock_in_location TEXT,
    clock_out_location TEXT,
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
    tax_amount DECIMAL(10,2) DEFAULT 0.00,
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
    admin_reply TEXT,
    admin_reply_at TIMESTAMP,
    caregiver_reply TEXT,
    caregiver_reply_at TIMESTAMP,
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
('Anglo Caregivers', 'Professional live-in care for elderly. Specialize in providing trained caregivers from Indonesia with nursing and eldercare experience.', '123 Care Street, Singapore', '6646-0000', 'contact@anglocaregivers.com', 'http://www.anglocaregivers.com', 4.9),
('Rapid Clinic Support', 'Focusing on efficient and safe transport for dialysis and outpatient treatments.', '202 Hospital Way, Singapore', '6555-5678', 'info@rapidsupport.sg', 'http://www.rapidsupport.sg', 4.7);

-- =====================================================
-- SAMPLE DATA - Company Admin
-- =====================================================
-- Password: admin123 (BCrypt hashed)
INSERT INTO app_user (username, email, password, name, role, verified, company_id) VALUES
('anglo.admin', 'admin@anglocaregivers.com', 'admin123', 'Anglo Administrator', 'COMPANY_ADMIN', TRUE, 1);

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

INSERT INTO caregiver (name, email, phone, qualifications, specialties, experience, bio, available, available_hours, rating, company_id) VALUES
('Rohana', 'rohana@anglocaregivers.com', '6646-0000', 'Ex-Sgp, Ex-Tw, Indonesia, Mandarin and Indonesian', 'Diabetes, Dementia, Tracheostomy, Kidney Problem, NG Tube Feeding, Blood Glucose Monitoring', 15, 'She has 15 years of eldercare experience in Singapore and Taiwan. Experienced in diabetes, dementia, and tracheostomy care. Specialized in NG Tube Feeding, suctioning, and catheter care.', TRUE, 'Mon-Sun 24/7', 4.9, 1),
('Nur', 'nur@anglocaregivers.com', '6646-0000', 'Ex-Sgp, Indonesia, English and Indonesian', 'Dementia, Stroke, Kidney Problem, Diabetes, Edema, Injections, Blood Glucose Monitoring', 3, 'Nearly 3 years of eldercare experience in Singapore. Experienced with patients having dementia, stroke, and kidney problems. Skilled in giving injections and blood glucose monitoring.', TRUE, 'Mon-Sun 24/7', 4.8, 1),
('Elysa', 'elysa@anglocaregivers.com', '6646-0000', 'New, Indonesia, Indonesian and Basic English, Trained, Certified', 'Elderly Care, Mobility Assistance, Wheelchair Support', 2, 'Trained and certified elderly care maid. Holds a certificate in caregiving. Previously cared for her own wheelchair-bound grandmother for a year.', TRUE, 'Mon-Sun 24/7', 4.7, 1),
('Rina', 'rina@anglocaregivers.com', '6646-0000', 'Ex-Tw, Indonesia, Mandarin and Indonesian', 'Diabetes, Lung Cancer, Blood Glucose Monitoring', 5, '5 years of eldercare experience in Taiwan caring for elderly with diabetes and lung cancer. Skilled in Blood Glucose Monitoring.', TRUE, 'Mon-Sun 24/7', 4.8, 1),
('Ismi', 'ismi@anglocaregivers.com', '6646-0000', 'Ex-Sgp, Ex-Tw, Indonesia, Mandarin and Indonesian', 'Diabetes, Injections, Blood Glucose Monitoring', 6, '6 years of eldercare experience in Taiwan. Good employment history in Singapore. Skilled in giving injections and monitoring blood glucose.', TRUE, 'Mon-Sun 24/7', 4.9, 1),
('Ayu', 'ayu@anglocaregivers.com', '6646-0000', 'New, Indonesia, Indonesian and basic English, Trained, Certified', 'Elderly Care, Diabetes Support', 4, 'Trained, certified elderly care maid. Worked in Indonesia for 4 years caring for patient with diabetes.', TRUE, 'Mon-Sun 24/7', 4.7, 1);

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
('rohana', 'rohana@anglocaregivers.com', 'admin123', 'Rohana', '6646-0000', 'CAREGIVER', TRUE),
('nur', 'nur@anglocaregivers.com', 'admin123', 'Nur', '6646-0000', 'CAREGIVER', TRUE),
('elysa', 'elysa@anglocaregivers.com', 'admin123', 'Elysa', '6646-0000', 'CAREGIVER', TRUE),
('rina', 'rina@anglocaregivers.com', 'admin123', 'Rina', '6646-0000', 'CAREGIVER', TRUE),
('ismi', 'ismi@anglocaregivers.com', 'admin123', 'Ismi', '6646-0000', 'CAREGIVER', TRUE),
('ayu', 'ayu@anglocaregivers.com', 'admin123', 'Ayu', '6646-0000', 'CAREGIVER', TRUE);

-- Link caregivers to users
UPDATE caregiver SET user_id = (SELECT user_id FROM app_user WHERE email = 'rohana@anglocaregivers.com') WHERE email = 'rohana@anglocaregivers.com';
UPDATE caregiver SET user_id = (SELECT user_id FROM app_user WHERE email = 'nur@anglocaregivers.com') WHERE email = 'nur@anglocaregivers.com';
UPDATE caregiver SET user_id = (SELECT user_id FROM app_user WHERE email = 'elysa@anglocaregivers.com') WHERE email = 'elysa@anglocaregivers.com';
UPDATE caregiver SET user_id = (SELECT user_id FROM app_user WHERE email = 'rina@anglocaregivers.com') WHERE email = 'rina@anglocaregivers.com';
UPDATE caregiver SET user_id = (SELECT user_id FROM app_user WHERE email = 'ismi@anglocaregivers.com') WHERE email = 'ismi@anglocaregivers.com';
UPDATE caregiver SET user_id = (SELECT user_id FROM app_user WHERE email = 'ayu@anglocaregivers.com') WHERE email = 'ayu@anglocaregivers.com';

-- =====================================================
-- SAMPLE DATA - Bookings
-- =====================================================
INSERT INTO booking (user_id, service_id, caregiver_id, booking_date, booking_time, pickup_address, total_price, status, payment_status, notes) VALUES
((SELECT user_id FROM app_user WHERE username = 'john.doe'), 1, (SELECT caregiver_id FROM caregiver WHERE name = 'Rohana'), CURRENT_DATE, '09:00:00', '123 Marina Bay Sands, Singapore', 120.00, 'In-Progress', 'Paid', 'Patient needs assistance with NG Tube feeding.'),
((SELECT user_id FROM app_user WHERE username = 'mary.tan'), 2, (SELECT caregiver_id FROM caregiver WHERE name = 'Nur'), CURRENT_DATE + INTERVAL '1 day', '10:30:00', '456 Orchard Road, Singapore', 55.00, 'Confirmed', 'Paid', 'Regular doctor appointment escort.'),
((SELECT user_id FROM app_user WHERE username = 'john.doe'), 3, (SELECT caregiver_id FROM caregiver WHERE name = 'Elysa'), CURRENT_DATE - INTERVAL '2 days', '14:00:00', '789 Geylang Rd, Singapore', 40.00, 'Completed', 'Paid', 'Mobility assistance for a walk in the park.'),
((SELECT user_id FROM app_user WHERE username = 'mary.tan'), 1, (SELECT caregiver_id FROM caregiver WHERE name = 'Ismi'), CURRENT_DATE + INTERVAL '3 days', '08:00:00', '101 Woodlands St, Singapore', 120.00, 'Pending', 'Unpaid', 'Full day hospital escort for surgery.');

-- Add sample clock-in timing for the in-progress job
UPDATE booking SET clock_in_time = CURRENT_TIMESTAMP - INTERVAL '1 hour', clock_in_location = '1.3521,103.8198' WHERE status = 'In-Progress';

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
  Username: admin / Password: admin123
  Username: anglo.admin / Password: admin123

CUSTOMERS:
  Username: john.doe / Password: admin123
  Username: mary.tan / Password: admin123
  
CAREGIVERS:
  Username: rohana / Password: admin123
  Username: nur / Password: admin123
  Username: elysa / Password: admin123
  Username: rina / Password: admin123
  Username: ismi / Password: admin123
  Username: ayu / Password: admin123
*/

-- =====================================================
-- SCRIPT COMPLETE
-- =====================================================
-- Database: silvercare
-- Total Tables: 8
-- Sample Bookings Added: 4
-- =====================================================