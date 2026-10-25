package com.wallet.util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    private static final String URL =
            "jdbc:mysql://localhost:3306/digital_wallet";

    private static final String USER =
            "root";

    private static final String PASSWORD =
            System.getenv("DIGITAL_WALLET_DB_PASSWORD");

    public static Connection getConnection() {

        try {

            Class.forName(
                    "com.mysql.cj.jdbc.Driver");

            if (PASSWORD == null ||
                    PASSWORD.isEmpty()) {

                throw new RuntimeException(
                        "Database password environment variable "
                                + "DIGITAL_WALLET_DB_PASSWORD is not set.");
            }

            return DriverManager.getConnection(
                    URL,
                    USER,
                    PASSWORD);

        } catch (Exception e) {

            throw new RuntimeException(
                    "Database connection failed.",
                    e);
        }
    }
}