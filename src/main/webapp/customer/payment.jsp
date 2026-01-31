<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<jsp:include page="../includes/header.jsp"><jsp:param name="title" value="Secure Payment"/></jsp:include>
<jsp:include page="../includes/navbar.jsp"/>

<div class="container" style="max-width: 600px; margin-top: 40px;">
    <div class="card">
        <h2 style="text-align: center; color: #1f4a7c;">Secure Payment</h2>
        
        <div style="margin: 20px 0; padding: 15px; background-color: #f8f9fa; border-radius: 5px;">
            <div style="display: flex; justify-content: space-between; margin-bottom: 8px;">
                <span>Subtotal:</span>
                <span>$<%= String.format("%.2f", request.getAttribute("subtotal")) %></span>
            </div>
            <div style="display: flex; justify-content: space-between; margin-bottom: 8px;">
                <span>GST (9%):</span>
                <span>$<%= String.format("%.2f", request.getAttribute("gst")) %></span>
            </div>
            <hr>
            <div style="display: flex; justify-content: space-between; font-weight: bold; font-size: 1.2em;">
                <span>Total to Pay:</span>
                <span>$<%= String.format("%.2f", request.getAttribute("amount")) %></span>
            </div>
        </div>

        <!-- Stripe Elements Placeholder -->
        <form id="payment-form">
            <div id="payment-element">
                <!--Stripe.js injects the Payment Element-->
            </div>
            
            <button id="submit" class="btn btn-primary" style="width: 100%; margin-top: 20px;">
                <div class="spinner hidden" id="spinner"></div>
                <span id="button-text">Pay Now</span>
            </button>
            <div id="payment-message" class="hidden" style="color: red; margin-top: 10px; text-align: center;"></div>
        </form>
    </div>
</div>

<script src="https://js.stripe.com/v3/"></script>
<script>
    // Initialize Stripe
    const stripe = Stripe('<%= request.getAttribute("stripePublicKey") %>');
    const clientSecret = '<%= request.getAttribute("clientSecret") %>';

    const appearance = {
        theme: 'stripe',
    };
    
    // Pass the clientSecret to the elements instance
    const elements = stripe.elements({ appearance, clientSecret });
    const paymentElement = elements.create("payment");
    paymentElement.mount("#payment-element");

    const form = document.getElementById("payment-form");

    form.addEventListener("submit", async (event) => {
        event.preventDefault();
        setLoading(true);

        const { error } = await stripe.confirmPayment({
            elements,
            confirmParams: {
                // Return URL where Stripe redirects after payment
                return_url: window.location.origin + "<%= request.getContextPath() %>/PaymentSuccessServlet",
            },
        });

        if (error) {
            // Show error to your customer
            showMessage(error.message);
            setLoading(false);
        } else {
            // Your customer will be redirected to your `return_url`
        }
    });

    // Helper functions
    function showMessage(messageText) {
        const messageContainer = document.querySelector("#payment-message");
        messageContainer.classList.remove("hidden");
        messageContainer.textContent = messageText;
    }

    function setLoading(isLoading) {
        if (isLoading) {
            document.querySelector("#submit").disabled = true;
            document.querySelector("#button-text").textContent = "Processing...";
        } else {
            document.querySelector("#submit").disabled = false;
            document.querySelector("#button-text").textContent = "Pay Now";
        }
    }
</script>

<jsp:include page="../includes/footer.jsp"/>
