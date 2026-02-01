package service;

import com.stripe.Stripe;
import com.stripe.model.PaymentIntent;
import com.stripe.param.PaymentIntentCreateParams;

public class StripeService {
    // API Key loaded from stripe.properties
    private static String API_KEY;

    static {
        try {
            java.util.Properties props = new java.util.Properties();
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
            System.err.println("ERROR: Stripe Secret Key not found in stripe.properties");
        }
    }

    public static void setApiKey(String key) {
        Stripe.apiKey = key;
    }

    public PaymentIntent createPaymentIntent(long amountCents, String currency, String bookingIds) throws Exception {
        PaymentIntentCreateParams params =
          PaymentIntentCreateParams.builder()
            .setAmount(amountCents)
            .setCurrency(currency)
            .putMetadata("integration_check", "accept_a_payment")
            .putMetadata("Bookings", bookingIds)
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
