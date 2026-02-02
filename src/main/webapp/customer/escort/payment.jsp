<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="../../includes/header.jsp"><jsp:param name="title" value="Payment"/></jsp:include>
<jsp:include page="../../includes/navbar.jsp"/>

<!-- Stripe JS -->
<script src="https://js.stripe.com/v3/"></script>

<div class="container" style="padding-top: 2rem; padding-bottom: 4rem;">
    <div class="form-container">
        <h1>Payment</h1>
        <p class="form-subtitle">Secure payment via Stripe</p>
        
        <div style="text-align: center; margin-bottom: 2rem;">
            <p style="font-size: 2rem; font-weight: bold; color: var(--text-dark);">$${param.price}</p>
            <p for="description">${param.name}</p>
        </div>

        <!-- Mock Payment Form for UI demo since backend integration requires keys -->
        <form id="payment-form">
            <div class="form-group">
                <label>Card Details</label>
                <!-- Stripe Element will be inserted here -->
                <div id="card-element" class="form-control" style="padding: 12px; border: 2px solid rgba(0,0,0,0.1); border-radius: 12px; background: white;">
                    <!-- A Stripe Element will be inserted here. -->
                </div>
                <div id="card-errors" role="alert" style="color: red; margin-top: 8px; font-size: 0.8rem;"></div>
            </div>

            <button id="submit" class="btn btn-primary" style="width: 100%; margin-top: 1rem;">
                <span id="button-text">Pay Now</span>
            </button>
        </form>
        
        <script>
            // Note: This is client-side only code for demonstration. 
            // Real integration requires a setupIntent or paymentIntent from the server.
            var stripe = Stripe('pk_test_TYooMQauvdEDq54NiTphI7jx'); // Replaced with a dummy mock key or placeholder
            var elements = stripe.elements();
            
            var style = {
                base: {
                    color: "#32325d",
                    fontFamily: '"Nunito", "Helvetica Neue", Helvetica, sans-serif',
                    fontSmoothing: 'antialiased',
                    fontSize: '16px',
                    '::placeholder': {
                        color: '#aab7c4'
                    }
                },
                invalid: {
                    color: '#fa755a',
                    iconColor: '#fa755a'
                }
            };
            
            var card = elements.create('card', {style: style});
            card.mount('#card-element');
            
            card.on('change', function(event) {
                var displayError = document.getElementById('card-errors');
                if (event.error) {
                    displayError.textContent = event.error.message;
                } else {
                    displayError.textContent = '';
                }
            });

            var form = document.getElementById('payment-form');
            form.addEventListener('submit', function(event) {
                event.preventDefault();
                // Simulate processing
                var btn = document.getElementById('submit');
                btn.disabled = true;
                btn.innerHTML = 'Processing...';

                setTimeout(function() {
                     alert("Payment successful! (Simulation)");
                     window.location.href = "${pageContext.request.contextPath}/customer/customerHome.jsp";
                }, 2000);
            });
        </script>
    </div>
</div>

<jsp:include page="../../includes/footer.jsp"/>
