package util;

/**
 * TestPasswordHashing - Simple test to verify BCrypt is working correctly
 * 
 * Run this class to test password hashing functionality
 */
public class TestPasswordHashing {

    public static void main(String[] args) {
        System.out.println("=== BCrypt Password Hashing Test ===\n");

        // Test 1: Hash a password
        String plainPassword = "MySecurePassword123!";
        System.out.println("Test 1: Hashing a password");
        System.out.println("Plain text: " + plainPassword);
        
        String hash1 = PasswordUtil.hashPassword(plainPassword);
        System.out.println("BCrypt hash: " + hash1);
        System.out.println("Hash length: " + hash1.length() + " characters");
        System.out.println();

        // Test 2: Verify the same password produces different hashes (due to different salts)
        System.out.println("Test 2: Same password, different hashes (unique salts)");
        String hash2 = PasswordUtil.hashPassword(plainPassword);
        System.out.println("Hash 1: " + hash1);
        System.out.println("Hash 2: " + hash2);
        System.out.println("Are they different? " + (!hash1.equals(hash2) ? "✓ YES (Good!)" : "✗ NO (Bad!)"));
        System.out.println();

        // Test 3: Verify correct password
        System.out.println("Test 3: Verify correct password");
        boolean isValid = PasswordUtil.checkPassword(plainPassword, hash1);
        System.out.println("Password matches hash1? " + (isValid ? "✓ YES" : "✗ NO"));
        
        isValid = PasswordUtil.checkPassword(plainPassword, hash2);
        System.out.println("Password matches hash2? " + (isValid ? "✓ YES" : "✗ NO"));
        System.out.println();

        // Test 4: Verify incorrect password
        System.out.println("Test 4: Verify incorrect password");
        String wrongPassword = "WrongPassword123!";
        isValid = PasswordUtil.checkPassword(wrongPassword, hash1);
        System.out.println("Wrong password matches? " + (isValid ? "✗ YES (Bad!)" : "✓ NO (Good!)"));
        System.out.println();

        // Test 5: Check if hash is BCrypt format
        System.out.println("Test 5: Verify BCrypt hash format");
        System.out.println("Is BCrypt hash? " + (PasswordUtil.isBCryptHash(hash1) ? "✓ YES" : "✗ NO"));
        
        String oldSHA256Hash = "5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8";
        System.out.println("Is old SHA-256 hash BCrypt? " + (PasswordUtil.isBCryptHash(oldSHA256Hash) ? "✗ YES (Bad!)" : "✓ NO (Good!)"));
        System.out.println();

        // Test 6: Performance test
        System.out.println("Test 6: Performance (BCrypt is intentionally slow for security)");
        long startTime = System.currentTimeMillis();
        PasswordUtil.hashPassword("TestPassword");
        long endTime = System.currentTimeMillis();
        System.out.println("Time to hash one password: " + (endTime - startTime) + "ms");
        System.out.println("(Normal range: 200-400ms depending on your CPU)");
        System.out.println();

        // Test 7: Edge cases
        System.out.println("Test 7: Edge cases");
        try {
            PasswordUtil.hashPassword(null);
            System.out.println("✗ Null password accepted (Bad!)");
        } catch (IllegalArgumentException e) {
            System.out.println("✓ Null password rejected (Good!)");
        }

        try {
            PasswordUtil.hashPassword("");
            System.out.println("✗ Empty password accepted (Bad!)");
        } catch (IllegalArgumentException e) {
            System.out.println("✓ Empty password rejected (Good!)");
        }

        boolean nullCheck = PasswordUtil.checkPassword(null, hash1);
        System.out.println("Null password check returns false? " + (!nullCheck ? "✓ YES" : "✗ NO"));

        boolean nullHashCheck = PasswordUtil.checkPassword(plainPassword, null);
        System.out.println("Null hash check returns false? " + (!nullHashCheck ? "✓ YES" : "✗ NO"));
        System.out.println();

        System.out.println("=== All Tests Complete ===");
        System.out.println("\nIf all tests show ✓, your password hashing is working correctly!");
    }
}
