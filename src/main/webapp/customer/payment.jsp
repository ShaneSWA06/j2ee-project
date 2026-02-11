<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="Secure Checkout"/></jsp:include>
<jsp:include page="../includes/navbar.jsp"/>

<div class="container secure-payment">
  <div class="page-header animate-in">
    <div class="header-content">
        <span class="badge">Payment Verification</span>
        <h1>Secure Payment</h1>
        <p class="page-subtitle">Your transaction is encrypted and secured by Stripe. Complete your booking payment below.</p>
    </div>
  </div>

  <div class="payment-layout">
    <!-- Left: Payment Form -->
    <div class="payment-column animate-in" style="animation-delay: 100ms;">
      <div class="card payment-card">
        <div class="card-glow"></div>
        <div class="section-title">
            <i class="fas fa-credit-card"></i>
            Payment Selection
        </div>
        
        <form id="payment-form">
          <div id="payment-element">
            <!--Stripe.js injects the Payment Element-->
            <div class="spinner-container">
                <div class="spinner"></div>
                <p>Establishing secure connection...</p>
            </div>
          </div>
          
          <div id="payment-message" class="alert alert-error hidden"></div>

          <button id="submit" class="btn btn-primary btn-pay" disabled>
            <span id="button-text">
                <i class="fas fa-lock"></i> Initialize Security Hub
            </span>
          </button>
        </form>

        <div class="security-footer">
            <div class="security-badges">
                <i class="fab fa-stripe-s"></i>
                <i class="fas fa-shield-alt"></i>
                <span>SSL Secured 256-bit</span>
            </div>
        </div>
      </div>
    </div>

    <!-- Right: Order Summary -->
    <div class="summary-column animate-in" style="animation-delay: 200ms;">
      <div class="card summary-card">
        <h3>Booking Summary</h3>
        <div class="summary-details">
            <div class="summary-row">
                <span>Services Subtotal</span>
                <span>$<%= String.format("%.2f", session.getAttribute("payment_subtotal")) %></span>
            </div>
            <div class="summary-row">
                <span>GST (9%)</span>
                <span>$<%= String.format("%.2f", session.getAttribute("payment_gst")) %></span>
            </div>
            <div class="divider"></div>
            <div class="summary-total">
                <div class="total-label"> Total to Pay </div>
                <div class="total-amount">$<%= String.format("%.2f", session.getAttribute("payment_amount")) %></div>
            </div>
        </div>
        
        <div class="guarantee-box">
            <i class="fas fa-undo-alt"></i>
            <div>
                <strong>Flexible Refund Policy</strong>
                <p>Cancel up to 24 hours before the service for a full refund.</p>
            </div>
        </div>
      </div>

      <a href="${pageContext.request.contextPath}/customer/viewCart.jsp" class="back-link">
          <i class="fas fa-arrow-left"></i> Return to Basket
      </a>
    </div>
  </div>
</div>

<style>
  .secure-payment {
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
  .payment-layout {
      display: grid;
      grid-template-columns: 1fr 340px;
      gap: 2.5rem;
      align-items: start;
  }

  @media (max-width: 992px) {
      .payment-layout {
          grid-template-columns: 1fr;
      }
      .summary-column {
          order: -1;
      }
  }

  /* Payment Card */
  .payment-card {
      padding: 2.5rem;
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

  #payment-element {
      margin-bottom: 1.5rem;
      min-height: 200px;
  }

  .spinner-container {
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      padding: 3rem;
      color: var(--foreground-muted);
      font-size: 0.9rem;
  }

  .spinner {
      width: 32px;
      height: 32px;
      border: 3px solid var(--surface);
      border-top-color: var(--accent);
      border-radius: 50%;
      animation: spin 0.8s linear infinite;
      margin-bottom: 1rem;
  }

  @keyframes spin {
      to { transform: rotate(360deg); }
  }

  .btn-pay {
      width: 100%;
      padding: 1.1rem;
      font-size: 1.1rem;
      margin-top: 1rem;
  }

  .btn-pay:disabled {
      opacity: 0.5;
      cursor: not-allowed;
      box-shadow: none;
      transform: none;
  }

  .security-footer {
      margin-top: 2rem;
      padding-top: 1.5rem;
      border-top: 1px solid var(--border-default);
  }

  .security-badges {
      display: flex;
      align-items: center;
      gap: 1.5rem;
      color: var(--foreground-muted);
      font-size: 0.8rem;
  }

  .security-badges i {
      font-size: 1.2rem;
      opacity: 0.6;
  }

  /* Summary Column */
  .summary-card {
      padding: 2rem;
  }

  .summary-row {
      display: flex;
      justify-content: space-between;
      margin-bottom: 0.75rem;
      color: var(--foreground-muted);
      font-size: 0.95rem;
  }

  .divider {
      height: 1px;
      background: var(--border-default);
      margin: 1.25rem 0;
  }

  .summary-total {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 1.5rem;
  }

  .total-label {
      font-weight: 600;
      color: var(--foreground);
  }

  .total-amount {
      font-size: 1.5rem;
      font-weight: 700;
      color: var(--accent-bright);
  }

  .guarantee-box {
      background: rgba(255, 255, 255, 0.03);
      border-radius: var(--radius-lg);
      padding: 1rem;
      display: flex;
      gap: 1rem;
      align-items: flex-start;
  }

  .guarantee-box i {
      color: var(--accent);
      margin-top: 0.25rem;
  }

  .guarantee-box strong {
      display: block;
      font-size: 0.85rem;
      margin-bottom: 0.2rem;
  }

  .guarantee-box p {
      margin: 0;
      font-size: 0.75rem;
      color: var(--foreground-muted);
      line-height: 1.4;
  }

  .back-link {
      display: block;
      margin-top: 1.5rem;
      text-align: center;
      font-size: 0.9rem;
      color: var(--foreground-muted);
      text-decoration: none;
  }

  .back-link:hover {
      color: var(--accent);
  }

  .hidden {
      display: none;
  }
</style>

<script src="https://js.stripe.com/v3/"></script>
<script>
    document.addEventListener("DOMContentLoaded", async () => {
        const publicKey = '<%= session.getAttribute("payment_stripePublicKey") %>';
        const clientSecret = '<%= session.getAttribute("payment_clientSecret") %>';
        
        if (!publicKey || publicKey === 'null' || publicKey.trim() === '') {
            showMessage("Error: Missing Stripe Public Key.");
            return;
        }

        let stripe;
        try {
            stripe = Stripe(publicKey);
        } catch (e) {
            showMessage("Error initializing Stripe: " + e.message);
            return;
        }

        // Custom Appearance Theme for Dark Mode
        const appearance = {
            theme: 'night',
            variables: {
                colorPrimary: '#5e6ad2',
                colorBackground: '#0a0a0c',
                colorText: '#ededef',
                colorDanger: '#ff4d4d',
                fontFamily: 'Inter, system-ui, sans-serif',
                spacingUnit: '4px',
                borderRadius: '8px',
            },
            elements: {
                card: {
                    border: '1px solid rgba(255, 255, 255, 0.1)',
                }
            }
        };
        
        let elements;
        try {
            elements = stripe.elements({ appearance, clientSecret });
            const paymentElement = elements.create("payment");
            
            paymentElement.on('ready', function() {
                setLoading(false); 
            });

            paymentElement.on('loaderror', function(event) {
                showMessage("Failed to load payment form: " + (event.error ? event.error.message : "Unknown error"));
            });

            paymentElement.mount("#payment-element");
        } catch (e) {
            showMessage("Error creating payment element: " + e.message);
            return;
        }

        const form = document.getElementById("payment-form");
        setLoading(true);
        document.querySelector("#button-text").innerHTML = `<i class="fas fa-spinner fa-spin"></i> Securing Payment Session...`;

        form.addEventListener("submit", async (event) => {
            event.preventDefault();
            setLoading(true);

            try {
                const { error } = await stripe.confirmPayment({
                    elements,
                    confirmParams: {
                        return_url: window.location.origin + "<%= request.getContextPath() %>/PaymentSuccessServlet",
                    },
                });

                if (error) {
                    showMessage(error.message);
                    setLoading(false);
                }
            } catch (e) {
                showMessage("An unexpected error occurred: " + e.message);
                setLoading(false);
            }
        });
    });

    function showMessage(messageText) {
        const messageContainer = document.querySelector("#payment-message");
        messageContainer.classList.remove("hidden");
        messageContainer.innerHTML = `<i class="fas fa-exclamation-circle"></i> ${messageText}`;
    }

    function setLoading(isLoading) {
        const submitBtn = document.querySelector("#submit");
        const btnText = document.querySelector("#button-text");
        
        if (isLoading) {
            submitBtn.disabled = true;
            btnText.innerHTML = `<i class="fas fa-spinner fa-spin"></i> Processing...`;
        } else {
            submitBtn.disabled = false;
            btnText.innerHTML = `<i class="fas fa-lock"></i> Pay Now`;
        }
    }
</script>

<jsp:include page="../includes/footer.jsp"/>
