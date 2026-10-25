package com.wallet.dao;

import com.wallet.model.Wallet;

import java.sql.Connection;

public interface WalletDAO {

    boolean createWallet(int userId);

    Wallet getWalletByUserId(int userId);

    boolean updateBalance(int userId,
                          double balance);

    double getBalance(int userId);

    boolean updateBalance(Connection con,
                          int userId,
                          double balance);
}