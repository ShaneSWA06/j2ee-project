package service;

import com.stripe.Stripe;
import com.stripe.model.PaymentIntent;
import com.stripe.param.PaymentIntentCreateParams;

/**
 * Service class for handling Stripe Payment Processing.
 * <p>
 * What it does:
 * - Encapsulates all direct interactions with the Stripe API library.
 * - Manages API authentication using credentials from a property file.
 * - Provides methods to create and retrieve PaymentIntents.
 * <p>
 * Design Intent:
 * - Singleton Configuration: Uses a static block to ensure the Stripe API key is loaded 
 *   only once when the class is first accessed, preventing redundant I/O operations.
 * - Security: API keys are loaded from a properties file (classpath resource) rather 
 *   than hardcoded, ensuring secrets aren't exposed in the source code.
 */
public class StripeService {
    // API Key loaded from stripe.properties
    private static String API_KEY;

    static {
        try {
            java.util.Properties props = new java.util.Properties();
            // We use getClassLoader().getResourceAsStream to ensure we can read the file
            // regardless of whether we are running in a local IDE or a packaged WAR file.
            try (java.io.InputStream input = StripeService.class.getClassLoader().getResourceAsStream("stripe.properties")) {
                if (input != null) {
                    props.load(input);
                    API_KEY = props.getProperty("stripe.secret.key");
                    if (API_KEY != null) {
                        API_KEY = API_KEY.trim();
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (API_KEY != null) {
            Stripe.apiKey = API_KEY;
        } else {
            // Critical failure logging: Payment processing cannot proceed without this key.
            System.err.println("ERROR: Stripe Secret Key not found in stripe.properties");
        }
    }

    public static void setApiKey(String key) {
        Stripe.apiKey = key;
    }

    /**
     * Creates a PaymentIntent to initiate a transaction.
     * <p>
     * Why PaymentIntent?
     * Unlike the older "Charge" API, PaymentIntent is designed for Strong Customer Authentication (SCA).
     * It handles the complex state machine of a payment (RequiresConfirmation -> Processing -> Succeeded),
     * which is required for modern European and Asian payment standards.
     *
     * @param amountCents Amount in smallest currency unit (e.g., cents) to avoid floating point errors.
     * @param currency Currency code (e.g., "sgd").
     * @param bookingIds Metadata to link this payment to specific bookings in the Stripe Dashboard.
     */
    public PaymentIntent createPaymentIntent(long amountCents, String currency, String bookingIds) throws Exception {
        PaymentIntentCreateParams params =
          PaymentIntentCreateParams.builder()
            .setAmount(amountCents)
            .setCurrency(currency)
            .putMetadata("integration_check", "accept_a_payment")
            .putMetadata("Bookings", bookingIds)
            // Automatic Payment Methods enabled to support Apple Pay, Google Pay, and Cards 
            // without changing backend code.
            .setAutomaticPaymentMethods(
              PaymentIntentCreateParams.AutomaticPaymentMethods.builder()
                .setEnabled(true)
                .build()
            )
            .build();

        return PaymentIntent.create(params);
    }

    public PaymentIntent retrievePaymentIntent(String id) throws Exception {
        return PaymentIntent.retrieve(id);
    }
}
