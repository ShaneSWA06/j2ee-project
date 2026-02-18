<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="includes/header.jsp"><jsp:param name="title" value="Home - Silver Caregivers"/></jsp:include>
<jsp:include page="includes/navbar.jsp"/>
<%
  boolean returning = false;
  jakarta.servlet.http.Cookie[] cookies = request.getCookies();
  if (cookies != null) {
    for (jakarta.servlet.http.Cookie c : cookies) {
      if ("silvercare_visit".equals(c.getName())) { returning = true; break; }
    }
  }
  if (!returning) {
    jakarta.servlet.http.Cookie c = new jakarta.servlet.http.Cookie("silvercare_visit", "1");
    c.setMaxAge(60*60*24*365);
    c.setPath("/");
    response.addCookie(c);
  }
%>
<div class="hero">
  <div class="container">
    <h1>Welcome to Silver Caregivers</h1>
    <p>Professional, compassionate care services for seniors and their families. Experience quality home care that brings peace of mind and comfort to your loved ones.</p>
    <p style="margin-top: 2rem;">
      <a class="btn btn-primary btn-lg" href="${pageContext.request.contextPath}/mvc/public/serviceCategories">Browse Services</a>
      <a class="btn btn-secondary btn-lg" href="${pageContext.request.contextPath}/public/registerClient.jsp">Get Started Today</a>
    </p>
  </div>
</div>

<div class="container" style="margin-top: 5rem;">
  <div class="section-title">
    <h2>Our Care Services</h2>
    <p>Comprehensive support tailored to meet the unique needs of every client</p>
  </div>
  
  <div class="grid grid-cols-3">
    <div class="card feature-card">
      <div class="service-icon">
        <span>🏠</span>
      </div>
      <h3>Personal Care</h3>
      <p>Assistance with daily activities, grooming, bathing, and personal hygiene with dignity and respect</p>
    </div>
    
    <div class="card feature-card">
      <div class="service-icon">
        <span>💊</span>
      </div>
      <h3>Health Wellness</h3>
      <p>Medication reminders, health monitoring, and coordination with healthcare providers</p>
    </div>
    
    <div class="card feature-card">
      <div class="service-icon">
        <span>🧠</span>
      </div>
      <h3>Memory Support</h3>
      <p>Specialized care for clients with Alzheimer's, dementia, and other memory-related conditions</p>
    </div>
  </div>

  <div class="section-title" style="margin-top: 5rem;">
    <h2>Why Choose Us</h2>
    <p>Trusted by families across the community for exceptional care and service</p>
  </div>
  
  <div class="grid grid-cols-4">
    <div class="card">
      <h3>✓ Experienced</h3>
      <p>Trained and certified caregivers with years of experience</p>
    </div>
    <div class="card">
      <h3>✓ Flexible</h3>
      <p>Custom schedules to fit your family's needs</p>
    </div>
    <div class="card">
      <h3>✓ Reliable</h3>
      <p>24/7 support and backup caregivers available</p>
    </div>
    <div class="card">
      <h3>✓ Trusted</h3>
      <p>Background-checked and insured professionals</p>
    </div>
  </div>
</div>

<jsp:include page="includes/footer.jsp"/>