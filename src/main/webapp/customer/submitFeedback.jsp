<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="Share Experience"/></jsp:include>
<jsp:include page="../includes/navbar.jsp"/>

<div class="container feedback-portal">
  <div class="page-header animate-in">
    <div class="header-content">
        <span class="badge">Your Opinion Matters</span>
        <h1>Share Your Experience</h1>
        <p class="page-subtitle">Your feedback helps us provide better care.</p>
    </div>
  </div>

  <div class="form-layout animate-in" style="animation-delay: 100ms;">
    <div class="form-card-wrapper">
        <div class="card feedback-card">
            <div class="card-glow"></div>
            
            <c:if test="${not empty param.err}">
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-triangle"></i> Please check your information and try again.
                </div>
            </c:if>

            <form method="post" action="${pageContext.request.contextPath}/customer/feedback?action=submit" class="modern-form">
                <div class="section-title">
                    <i class="fas fa-star-half-alt"></i>
                    Rate Your Experience
                </div>

                <div class="form-group">
                    <label>Overall Satisfaction Rating *</label>
                    <div class="rating-picker">
                        <select id="rating" name="rating" required>
                            <option value="" selected disabled>Choose your rating</option>
                            <option value="5">Excellent — ⭐⭐⭐⭐⭐ (5)</option>
                            <option value="4">Good — ⭐⭐⭐⭐ (4)</option>
                            <option value="3">Vebal — ⭐⭐⭐ (3)</option>
                            <option value="2">Subpar — ⭐⭐ (2)</option>
                            <option value="1">Poor — ⭐ (1)</option>
                        </select>
                        <i class="fas fa-chevron-down select-icon"></i>
                    </div>
                </div>

                <div class="form-group">
                    <label for="caregiver_id">Dedicated Professional (Optional)</label>
                    <div class="input-wrapper">
                        <i class="fas fa-user-nurse"></i>
                        <select id="caregiver_id" name="caregiver_id">
                            <option value="">General Service Experience</option>
                            <c:forEach var="caregiver" items="${caregivers}">
                                <option value="${caregiver.caregiverId}">${caregiver.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <span class="hint">Select a specific caregiver to route your feedback directly.</span>
                </div>

                <div class="form-group">
                    <label for="comment">Detailed Testimonial *</label>
                    <div class="input-wrapper align-top">
                        <i class="fas fa-pen-nib"></i>
                        <textarea id="comment" name="comment" rows="5" required placeholder="Describe your experience with our services..."></textarea>
                    </div>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn btn-primary btn-submit">
                        <i class="fas fa-paper-plane"></i> Submit Feedback
                    </button>
                    <a href="${pageContext.request.contextPath}/customer/feedback" class="btn btn-secondary">
                        Discard
                    </a>
                </div>
            </form>
        </div>
    </div>

    <!-- Feedback Tip -->
    <div class="tip-column animate-in" style="animation-delay: 200ms;">
        <div class="card tip-card">
            <i class="fas fa-lightbulb"></i>
            <h3>Why Feedback Matters</h3>
            <p>We use your insights to provide tailored training to our caregivers and improve our platform responsiveness.</p>
            <div class="divider"></div>
            <p class="small">Positive testimonials may be featured anonymously to help other families find the right care.</p>
        </div>
    </div>
  </div>
</div>

<style>
  .feedback-portal {
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
      text-align: center;
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
     margin: 0.5rem auto 0;
  }

  /* Layout */
  .form-layout {
      display: grid;
      grid-template-columns: 1fr 300px;
      gap: 2.5rem;
      align-items: start;
      max-width: 900px;
      margin: 0 auto;
  }

  @media (max-width: 768px) {
      .form-layout {
          grid-template-columns: 1fr;
      }
      .tip-column {
          order: -1;
      }
  }

  .feedback-card {
      padding: 3rem;
      position: relative;
      overflow: hidden;
  }

  .card-glow {
    position: absolute;
    top: -40px;
    right: -40px;
    width: 150px;
    height: 150px;
    background: var(--accent-glow);
    filter: blur(60px);
    border-radius: 50%;
  }

  .section-title {
      font-size: 1.1rem;
      font-weight: 600;
      margin-bottom: 2rem;
      display: flex;
      align-items: center;
      gap: 0.75rem;
      color: var(--foreground);
  }

  .section-title i {
      color: var(--accent);
  }

  .form-group {
      margin-bottom: 1.75rem;
  }

  .form-group label {
      display: block;
      font-size: 0.85rem;
      font-weight: 600;
      color: var(--foreground-muted);
      margin-bottom: 0.75rem;
      text-transform: uppercase;
      letter-spacing: 0.05em;
  }

  .rating-picker {
      position: relative;
  }

  .rating-picker select {
      width: 100%;
      padding: 1rem 1.25rem;
      appearance: none;
      background: rgba(255, 255, 255, 0.03);
      border: 1px solid var(--border-default);
      border-radius: var(--radius-lg);
      color: var(--foreground);
      font-size: 1rem;
      cursor: pointer;
      transition: all 0.2s;
  }

  .rating-picker select:focus {
      outline: none;
      border-color: var(--accent);
      background: rgba(255, 255, 255, 0.05);
      box-shadow: 0 0 0 4px var(--accent-glow);
  }

  .rating-picker select option,
  .input-wrapper select option {
      background: #0a0a0c;
      color: #ededef;
  }

  .select-icon {
      position: absolute;
      right: 1.25rem;
      top: 50%;
      transform: translateY(-50%);
      pointer-events: none;
      color: var(--foreground-subtle);
  }

  .input-wrapper {
      position: relative;
      display: flex;
      align-items: center;
  }

  .input-wrapper i {
      position: absolute;
      left: 1.25rem;
      color: var(--foreground-subtle);
      font-size: 0.9rem;
      pointer-events: none;
  }

  .input-wrapper input,
  .input-wrapper select,
  .input-wrapper textarea {
      padding-left: 3rem;
      background: rgba(255, 255, 255, 0.03);
      border: 1px solid var(--border-default);
  }

  .input-wrapper.align-top i {
      top: 1.25rem;
  }

  .hint {
      display: block;
      font-size: 0.75rem;
      color: var(--foreground-subtle);
      margin-top: 0.5rem;
      padding-left: 0.5rem;
  }

  .form-actions {
      display: flex;
      gap: 1rem;
      margin-top: 2.5rem;
  }

  .btn-submit {
      flex: 1;
      padding: 1rem;
      font-size: 1rem;
  }

  /* Tip Card */
  .tip-card {
      padding: 2rem;
      background: linear-gradient(135deg, rgba(94, 106, 210, 0.1), transparent);
      border-color: var(--border-accent);
  }

  .tip-card i {
      font-size: 1.5rem;
      color: var(--accent-bright);
      margin-bottom: 1.25rem;
  }

  .tip-card h3 {
      font-size: 1rem;
      margin-bottom: 0.75rem;
  }

  .tip-card p {
      font-size: 0.85rem;
      color: var(--foreground-muted);
      line-height: 1.5;
      margin: 0;
  }

  .divider {
      height: 1px;
      background: var(--border-default);
      margin: 1.25rem 0;
  }

  .small {
      font-size: 0.75rem !important;
      opacity: 0.7;
  }
</style>

<jsp:include page="../includes/footer.jsp"/>
