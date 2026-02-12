package service;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/**
 * EmailService handles SMTP email communications.
 * <p>
 * What it does:
 * - Reads SMTP configuration from `mail.properties`.
 * - Authenticates with an external mail server (e.g., Gmail, SendGrid).
 * - Constructs and sends MIME HTML emails.
 * <p>
 * Design Intent:
 * - External Configuration: Uses a properties file to decouple email server credentials 
 *   from the compiled code, allowing different configs for Dev/Prod.
 * - Stateless Utility: Designed as a static utility class because email sending 
 *   does not require maintaining object state.
 */
public class EmailService {

    private static Properties properties = new Properties();

    static {
        try (InputStream input = EmailService.class.getClassLoader().getResourceAsStream("mail.properties")) {
            if (input == null) {
                System.out.println("Sorry, unable to find mail.properties");
            } else {
                properties.load(input);
            }
        } catch (IOException ex) {
            ex.printStackTrace();
        }
    }

    /**
     * Sends an account verification email with a unique token link.
     * <p>
     * Implementation Note:
     * - Uses `jakarta.mail` (JavaMail API) to support standardized SMTP protocols.
     * - Sends HTML content to provide a clickable link and better branding.
     */
    public static void sendVerificationEmail(String toEmail, String token, String baseUrl) {
        final String username = properties.getProperty("mail.username");
        final String password = properties.getProperty("mail.password");

        Session session = Session.getInstance(properties, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(username));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Email Verification");

            String verificationLink = baseUrl + "/verify-email?token=" + token;
            String htmlContent = "<h3>Welcome From SilverCare !</h3>"
                    + "<p>Please click the link below to verify your email address:</p>"
                    + "<a href=\"" + verificationLink + "\">Verify Email</a>";

            message.setContent(htmlContent, "text/html; charset=utf-8");

            Transport.send(message);

            System.out.println("Verification email sent to " + toEmail);

        } catch (MessagingException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    /**
     * Sends a password reset verification code email.
     */
    public static void sendPasswordResetEmail(String toEmail, String code, String userName) {
        final String username = properties.getProperty("mail.username");
        final String password = properties.getProperty("mail.password");

        Session session = Session.getInstance(properties, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(username));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Password Reset Request");

            String htmlContent = "<h3>Hello " + userName + ",</h3>"
                    + "<p>We received a request to reset your password. Please use the following verification code:</p>"
                    + "<h2 style=\"color: #5e6ad2;\">" + code + "</h2>"
                    + "<p>If you did not request this, please ignore this email.</p>";

            message.setContent(htmlContent, "text/html; charset=utf-8");

            Transport.send(message);

            System.out.println("Password reset email sent to " + toEmail);

        } catch (MessagingException e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }
}
