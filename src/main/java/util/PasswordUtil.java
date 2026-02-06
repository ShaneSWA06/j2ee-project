package util;

import org.mindrot.jbcrypt.BCrypt;

/**
 * PasswordUtil - Secure password hashing using BCrypt
 * 
 * BCrypt is the industry standard for password hashing because:
 * - Automatically generates and stores unique salts for each password
 * - Computationally expensive to slow down brute-force attacks
 * - Has a configurable work factor (default: 12)
 */
public class PasswordUtil {

    // Work factor (cost): 12 is a good balance between security and performance
    // Higher values = more secure but slower (2^12 = 4096 rounds)
    private static final int WORK_FACTOR = 12;

    /**
     * Hash a plain text password using BCrypt
     * @param password Plain text password
     * @return BCrypt hashed password with salt
     */
    public static String hashPassword(String password) {
        if (password == null || password.isEmpty()) {
            throw new IllegalArgumentException("Password cannot be null or empty");
        }
        return BCrypt.hashpw(password, BCrypt.gensalt(WORK_FACTOR));
    }

    /**
     * Verify a plain text password against a stored BCrypt hash
     * @param plainPassword Plain text password to check
     * @param storedHash BCrypt hash from database
     * @return true if password matches, false otherwise
     */
    public static boolean checkPassword(String plainPassword, String storedHash) {
        if (storedHash == null || plainPassword == null) {
            return false;
        }
        
        try {
            // BCrypt.checkpw handles the comparison securely
            return BCrypt.checkpw(plainPassword, storedHash);
        } catch (IllegalArgumentException e) {
            // Invalid hash format (e.g., old SHA-256 hashes)
            return false;
        }
    }
    
    /**
     * Check if a hash is a BCrypt hash
     * @param hash Hash to check
     * @return true if it's a BCrypt hash, false otherwise
     */
    public static boolean isBCryptHash(String hash) {
        // BCrypt hashes start with $2a$, $2b$, or $2y$
        return hash != null && hash.matches("^\\$2[aby]\\$\\d{2}\\$.{53}$");
    }
}
