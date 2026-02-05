package service;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

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
}
