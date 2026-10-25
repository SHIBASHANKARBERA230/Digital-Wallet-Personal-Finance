package com.wallet.util;

import java.util.regex.Pattern;

public class ValidationUtil {

    private static final String EMAIL_REGEX =
            "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$";

    private static final String PHONE_REGEX =
            "^[0-9]{10}$";

    private ValidationUtil() {
    }

    public static boolean isValidEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }

        return Pattern.matches(EMAIL_REGEX, email.trim());
    }

    public static boolean isValidPassword(String password) {
        return password != null && password.length() >= 6;
    }

    public static boolean isValidName(String name) {
        return name != null && !name.trim().isEmpty();
    }

    public static boolean isValidPhone(String phone) {
        if (phone == null || phone.trim().isEmpty()) {
            return true;
        }

        return Pattern.matches(PHONE_REGEX, phone.trim());
    }
}