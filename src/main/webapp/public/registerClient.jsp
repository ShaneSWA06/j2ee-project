<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="Join SilverCare"/></jsp:include>
<jsp:include page="../includes/navbar.jsp" />

<div class="auth-container">
  <div class="auth-card animate-in">
    <div class="auth-glow"></div>
    <div class="auth-header">
        <div class="auth-icon-box">
            <i class="fas fa-user-plus"></i>
        </div>
        <h1>Create Account</h1>
        <p class="auth-subtitle">Join our community of families and caregivers.</p>
    </div>
    
    <% 
      String error = (String) session.getAttribute("error"); 
      String success = (String) session.getAttribute("success"); 
      if (error != null) { 
    %>
      <div class="alert alert-error">
          <i class="fas fa-exclamation-circle"></i> <%= error %>
      </div>
    <% 
      session.removeAttribute("error"); 
      } 
      if (success != null) { 
    %>
      <div class="alert alert-success">
          <i class="fas fa-check-circle"></i> <%= success %>
      </div>
    <% 
      session.removeAttribute("success"); 
      }
    %>
    
    <form method="post" action="${pageContext.request.contextPath}/RegisterServlet" class="auth-form">
      <div class="form-grid">
          <div class="form-group">
            <label for="username">Username</label>
            <div class="input-wrapper">
                <i class="fas fa-at"></i>
                <input type="text" id="username" name="username" placeholder="johndoe" required />
            </div>
          </div>
          
          <div class="form-group">
            <label for="name">Full Name</label>
            <div class="input-wrapper">
                <i class="fas fa-user"></i>
                <input type="text" id="name" name="name" placeholder="John Doe" required />
            </div>
          </div>
      </div>
      
      <div class="form-group">
        <label for="email">Email Address</label>
        <div class="input-wrapper">
            <i class="fas fa-envelope"></i>
            <input type="email" id="email" name="email" placeholder="john@example.com" required />
        </div>
      </div>
      
      <div class="form-grid">
          <div class="form-group">
            <label for="password">Password</label>
            <div class="input-wrapper">
                <i class="fas fa-lock"></i>
                <input type="password" id="password" name="password" placeholder="••••••••" required />
            </div>
          </div>
          
          <div class="form-group">
            <label for="phone">Phone Number</label>
            <div class="input-wrapper">
                <i class="fas fa-phone"></i>
                <input type="tel" id="phone" name="phone" placeholder="+65 ...." required />
            </div>
          </div>
      </div>
      
      <div class="form-group">
        <label for="relationship">Role / Relationship</label>
        <div class="input-wrapper">
            <i class="fas fa-users"></i>
            <select id="relationship" name="relationship" required>
              <option value="" selected disabled>Select relationship</option>
              <option value="self">Self</option>
              <option value="spouse">Spouse</option>
              <option value="child">Child</option>
              <option value="parent">Parent</option>
              <option value="sibling">Sibling</option>
              <option value="friend">Friend</option>
              <option value="other">Other</option>
            </select>
        </div>
      </div>
      
      <div class="form-group">
        <label for="address">Residential Address</label>
        <div class="input-wrapper">
            <i class="fas fa-home"></i>
            <input type="text" id="address" name="address" placeholder="123 Silver Street" required />
        </div>
      </div>
      
      <div class="form-group">
        <label for="careNotes">Initial Care Notes (Optional)</label>
        <div class="input-wrapper align-top">
            <i class="fas fa-notes-medical"></i>
            <textarea id="careNotes" name="care_notes" rows="2" placeholder="Tell us about special requirements..."></textarea>
        </div>
      </div>
      
      <button type="submit" class="btn btn-primary btn-auth">
          Complete Registration
          <i class="fas fa-check"></i>
      </button>
      
      <div class="auth-footer">
        <span>Already have an account?</span>
        <a href="${pageContext.request.contextPath}/auth/login.jsp">Log In</a>
      </div>
    </form>
  </div>
</div>

<style>
  .auth-container {
      margin: 4rem auto;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 0 1.5rem;
  }

  @keyframes fadeInUp {
    from { opacity: 0; transform: translateY(20px); }
    to { opacity: 1; transform: translateY(0); }
  }

  .animate-in {
    opacity: 0;
    animation: fadeInUp 0.6s cubic-bezier(0.16, 1, 0.3, 1) forwards;
  }

  .auth-card {
      width: 100%;
      max-width: 540px;
      padding: 3rem;
      background: rgba(10, 10, 12, 0.7);
      backdrop-filter: blur(20px);
      border: 1px solid var(--border-default);
      border-radius: var(--radius-2xl);
      box-shadow: var(--shadow-xl);
      position: relative;
      overflow: hidden;
  }

  .auth-glow {
    position: absolute;
    top: -60px;
    right: -60px;
    width: 200px;
    height: 200px;
    background: var(--accent-glow);
    filter: blur(80px);
    border-radius: 50%;
  }

  .auth-header {
      text-align: center;
      margin-bottom: 2.5rem;
  }

  .auth-icon-box {
      width: 56px;
      height: 56px;
      background: var(--accent);
      border-radius: var(--radius-xl);
      display: flex;
      align-items: center;
      justify-content: center;
      margin: 0 auto 1.25rem;
      box-shadow: 0 0 30px var(--accent-glow);
  }

  .auth-icon-box i {
      font-size: 1.5rem;
      color: white;
  }

  .form-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 1.25rem;
  }

  @media (max-width: 500px) {
      .form-grid {
          grid-template-columns: 1fr;
      }
      .auth-card {
          padding: 2rem 1.5rem;
      }
  }

  .form-group {
      margin-bottom: 1.25rem;
  }

  .input-wrapper {
      position: relative;
      display: flex;
      align-items: center;
  }

  .input-wrapper i {
      position: absolute;
      left: 1rem;
      color: var(--foreground-subtle);
      font-size: 0.9rem;
  }

  .input-wrapper input,
  .input-wrapper select,
  .input-wrapper textarea {
      padding-left: 2.8rem;
      background: rgba(255, 255, 255, 0.03);
      border: 1px solid var(--border-default);
  }

  .input-wrapper.align-top i {
      top: 1rem;
  }

  .btn-auth {
      width: 100%;
      padding: 1.1rem;
      margin-top: 1rem;
      display: flex;
      gap: 0.75rem;
  }

  .auth-footer {
      margin-top: 2rem;
      text-align: center;
      font-size: 0.9rem;
      color: var(--foreground-muted);
      display: flex;
      gap: 0.5rem;
      justify-content: center;
  }

  .auth-footer a {
      font-weight: 600;
  }
</style>

<jsp:include page="../includes/footer.jsp" />
