<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="Profile Settings"/></jsp:include>
<jsp:include page="../includes/navbar.jsp"/>

<div class="container user-settings">
  <div class="page-header animate-in">
    <div class="header-content">
        <span class="badge">Account Control</span>
        <h1>Profile Management</h1>
        <p class="page-subtitle">Update your personal details, secure your account, and manage medical preferences.</p>
    </div>
  </div>

  <c:if test="${not empty success}">
    <div class="alert alert-success animate-in">
        <i class="fas fa-check-circle"></i> ${success}
    </div>
  </c:if>
  <c:if test="${not empty error}">
    <div class="alert alert-error animate-in">
        <i class="fas fa-exclamation-triangle"></i> ${error}
    </div>
  </c:if>

  <form action="${pageContext.request.contextPath}/settings" method="post" class="settings-layout animate-in" style="animation-delay: 100ms;">
    <!-- Sidebar / Tabs Navigation (Visual only for now) -->
    <div class="settings-sidebar">
        <div class="account-profile">
            <div class="avatar-placeholder">
                <i class="fas fa-user-circle"></i>
            </div>
            <div class="profile-info">
                <h3>${user.name}</h3>
                <span class="username">@${user.username}</span>
            </div>
        </div>
        
        <div class="nav-menu">
            <a href="#profile" class="nav-item active"><i class="fas fa-user-edit"></i> Profile Details</a>
            <a href="#medical" class="nav-item"><i class="fas fa-heartbeat"></i> Medical Records</a>
            <a href="#security" class="nav-item"><i class="fas fa-shield-alt"></i> Security</a>
        </div>
    </div>

    <!-- Main Settings Form -->
    <div class="settings-content">
        <!-- Section: Profile -->
        <div class="card settings-section">
            <div class="section-title">
                <i class="fas fa-id-card"></i>
                Personal Identity
            </div>
            <div class="form-grid">
                <div class="form-group">
                    <label>Unique Username</label>
                    <div class="input-wrapper readonly">
                        <i class="fas fa-at"></i>
                        <input type="text" value="${user.username}" readonly />
                    </div>
                </div>
                <div class="form-group">
                    <label>Full Legal Name</label>
                    <div class="input-wrapper">
                        <i class="fas fa-user"></i>
                        <input type="text" name="name" value="${user.name}" required />
                    </div>
                </div>
            </div>
            <div class="form-grid">
                <div class="form-group">
                    <label>Email Address</label>
                    <div class="input-wrapper">
                        <i class="fas fa-envelope"></i>
                        <input type="email" name="email" value="${user.email}" required />
                    </div>
                </div>
                <div class="form-group">
                    <label>Contact Number</label>
                    <div class="input-wrapper">
                        <i class="fas fa-phone"></i>
                        <input type="tel" name="phone" value="${user.phone}" />
                    </div>
                </div>
            </div>
            <div class="form-group">
                <label>Primary Residential Address</label>
                <div class="input-wrapper">
                    <i class="fas fa-map-marker-alt"></i>
                    <input type="text" name="address" value="${user.address}" />
                </div>
            </div>
        </div>

        <!-- Section: Medical -->
        <div class="card settings-section">
            <div class="section-title">
                <i class="fas fa-notes-medical"></i>
                Healthcare Parameters
            </div>
            <div class="form-group">
                <label>Relationship to Care Recipient</label>
                <div class="input-wrapper">
                    <i class="fas fa-users"></i>
                    <select name="relationship">
                        <option value="Self" ${user.relationship == 'Self' ? 'selected' : ''}>Self</option>
                        <option value="Child" ${user.relationship == 'Child' ? 'selected' : ''}>Child</option>
                        <option value="Parent" ${user.relationship == 'Parent' ? 'selected' : ''}>Parent</option>
                        <option value="Spouse" ${user.relationship == 'Spouse' ? 'selected' : ''}>Spouse</option>
                        <option value="Other" ${user.relationship == 'Other' ? 'selected' : ''}>Other</option>
                    </select>
                </div>
            </div>
            <div class="form-group">
                <label>Active Allergies or Sensitivities</label>
                <div class="input-wrapper align-top">
                    <i class="fas fa-vial"></i>
                    <textarea name="allergies" rows="2" placeholder="List food, medication, or environmental allergies...">${user.allergies}</textarea>
                </div>
            </div>
            <div class="form-group">
                <label>Integrated Medical History</label>
                <div class="input-wrapper align-top">
                    <i class="fas fa-history"></i>
                    <textarea name="medical_history" rows="3" placeholder="Document past conditions, surgeries, or chronic illnesses...">${user.medicalHistory}</textarea>
                </div>
            </div>
            <div class="form-group">
                <label>Personalized Care Notes</label>
                <div class="input-wrapper align-top">
                    <i class="fas fa-comment-medical"></i>
                    <textarea name="care_notes" rows="3" placeholder="Special requirements, lifestyle preferences, etc...">${user.careNotes}</textarea>
                </div>
            </div>
        </div>

        <!-- Section: Security -->
        <div class="card settings-section">
            <div class="section-title">
                <i class="fas fa-lock"></i>
                Security Hub
            </div>
            <div class="form-group">
                <label>Rotate Password</label>
                <div class="input-wrapper">
                    <i class="fas fa-key"></i>
                    <input type="password" name="password" placeholder="•••••••• (Leave blank to keep current)" />
                </div>
                <span class="hint">Use a strong, unique password for improved security.</span>
            </div>
        </div>

        <div class="form-actions">
            <button type="submit" class="btn btn-primary btn-save">Synchronize Profile</button>
            <a href="${pageContext.request.contextPath}/customer/customerHome.jsp" class="btn btn-secondary">Discard Changes</a>
        </div>
    </div>
  </form>
</div>

<style>
  .user-settings {
      margin-top: 3rem;
      margin-bottom: 6rem;
  }

  @keyframes fadeInUp {
    from { opacity: 0; transform: translateY(20px); }
    to { opacity: 1; transform: translateY(0); }
  }

  .animate-in {
    opacity: 0;
    animation: fadeInUp 0.6s cubic-bezier(0.16, 1, 0.3, 1) forwards;
  }

  .page-header {
      margin-bottom: 3rem;
  }

  .badge {
    background: var(--accent-glow);
    color: var(--accent-bright);
    padding: 0.25rem 0.75rem;
    border-radius: var(--radius-full);
    font-size: 0.75rem;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 0.1em;
    border: 1px solid var(--border-accent);
    margin-bottom: 1rem;
    display: inline-block;
  }

  .page-subtitle {
     color: var(--foreground-muted);
     font-size: 1.1rem;
     max-width: 600px;
  }

  /* Layout */
  .settings-layout {
      display: grid;
      grid-template-columns: 280px 1fr;
      gap: 3rem;
      align-items: start;
  }

  @media (max-width: 992px) {
      .settings-layout {
          grid-template-columns: 1fr;
      }
      .settings-sidebar {
          position: relative;
          top: 0;
      }
      .nav-menu {
          display: flex;
          flex-wrap: wrap;
          gap: 0.5rem;
      }
  }

  .settings-sidebar {
      position: sticky;
      top: 100px;
  }

  .account-profile {
      display: flex;
      align-items: center;
      gap: 1.25rem;
      margin-bottom: 2.5rem;
      padding-bottom: 2rem;
      border-bottom: 1px solid var(--border-default);
  }

  .avatar-placeholder {
      font-size: 3rem;
      color: var(--accent);
      opacity: 0.8;
  }

  .profile-info h3 {
      font-size: 1.1rem;
      margin: 0;
  }

  .username {
      font-size: 0.8rem;
      color: var(--foreground-muted);
      font-family: var(--font-mono);
  }

  .nav-menu {
      display: flex;
      flex-direction: column;
      gap: 0.5rem;
  }

  .nav-item {
      padding: 0.75rem 1.25rem;
      border-radius: var(--radius-md);
      color: var(--foreground-muted);
      display: flex;
      align-items: center;
      gap: 1rem;
      font-size: 0.95rem;
      font-weight: 500;
      transition: all 0.2s;
  }

  .nav-item:hover {
      background: var(--surface);
      color: var(--foreground);
  }

  .nav-item.active {
      background: var(--accent-glow);
      color: var(--accent-bright);
      border: 1px solid var(--border-accent);
  }

  /* Content Sections */
  .settings-section {
      padding: 2.5rem;
      margin-bottom: 2rem;
  }

  .section-title {
      font-size: 1.1rem;
      font-weight: 600;
      margin-bottom: 2rem;
      display: flex;
      align-items: center;
      gap: 0.8rem;
      color: var(--foreground);
  }

  .section-title i {
      color: var(--accent);
      opacity: 0.8;
  }

  .form-grid {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 1.5rem;
  }

  @media (max-width: 600px) {
      .form-grid {
          grid-template-columns: 1fr;
      }
  }

  .form-group {
      margin-bottom: 1.5rem;
  }

  .form-group label {
      display: block;
      font-size: 0.85rem;
      font-weight: 600;
      color: var(--foreground-muted);
      margin-bottom: 0.6rem;
      text-transform: uppercase;
      letter-spacing: 0.05em;
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
      pointer-events: none;
  }

  .input-wrapper input,
  .input-wrapper select,
  .input-wrapper textarea {
      padding-left: 2.8rem;
      background: rgba(255, 255, 255, 0.03);
      border: 1px solid var(--border-default);
  }

  .input-wrapper.readonly input {
      background: rgba(255, 255, 255, 0.01);
      color: var(--foreground-muted);
      cursor: not-allowed;
  }

  .input-wrapper.align-top i {
      top: 1rem;
  }

  .hint {
      display: block;
      font-size: 0.75rem;
      color: var(--foreground-subtle);
      margin-top: 0.5rem;
  }

  .form-actions {
      display: flex;
      gap: 1.25rem;
      margin-top: 2rem;
  }

  .btn-save {
      padding: 1rem 2rem;
      font-size: 1rem;
  }
</style>

<jsp:include page="../includes/footer.jsp"/>
