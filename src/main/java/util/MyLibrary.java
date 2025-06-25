package util;

public class MyLibrary {
    public static boolean validateEmail(String email) {
        // Split email by '@' and ensure exactly one '@'
        String[] parts = email.trim().split("@");
        if (parts.length != 2) {
            return false;
        }

        // Validate local part
        String localPart = parts[0];
        if (!isValidLocalPart(localPart)) {
            return false;
        }

        // Validate domain part
        String domainPart = parts[1];
        if (!isValidDomainPart(domainPart)) {
            return false;
        }

        return true;
    }


    public static boolean isValidLocalPart(String localPart) {
        if (localPart.isEmpty()) {
            return false;
        }

        // Check the first and last characters are alphanumeric
        if (!Character.isLetterOrDigit(localPart.charAt(0))
                || !Character.isLetterOrDigit(localPart.charAt(localPart.length() - 1))) {
            return false;
        }

        // Check for consecutive special characters and valid characters
        char lastChar = ' ';
        for (char c : localPart.toCharArray()) {
            if (!Character.isLetterOrDigit(c) && c != '.' && c != '-' && c != '_') {
                return false;
            }
            if ((c == '.' || c == '-' || c == '_') && (lastChar == '.' || lastChar == '-' || lastChar == '_')) {
                return false; // No consecutive special characters
            }
            lastChar = c;
        }

        return true;
    }


    public static boolean isValidDomainPart(String domainPart) {
        String[] domainSections = domainPart.split("\\.");
        if (domainSections.length < 2) {
            return false;
        }

        // Validate each section of the domain
        for (String section : domainSections) {
            if (section.isEmpty() || !section.matches("[a-zA-Z0-9-]+")) {
                return false;
            }
            if (section.startsWith("-") || section.endsWith("-")) {
                return false; // No hyphen at start or end of section
            }
            if (section.contains("--")) {
                return false; // No consecutive hyphens allowed
            }
        }

        // Validate the top-level domain (TLD) section (the last section)
        String tld = domainSections[domainSections.length - 1];
        if (tld.length() < 2 || !tld.matches("[a-zA-Z]+")) {
            return false;
        }

        return true;
    }

}
