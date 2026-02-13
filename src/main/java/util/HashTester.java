package util;
import org.mindrot.jbcrypt.BCrypt;

/**
 * HashTester - Simple utility to generate a quick BCrypt hash
 * <p>
 * Purpose:
 * - Used for development/testing to generate a hash for a known password.
 * - Prints the hash to stdout.
 */
public class HashTester {
    public static void main(String[] args) {
        System.out.println(BCrypt.hashpw("admin123", BCrypt.gensalt(12)));
    }
}
