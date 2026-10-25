package com.wallet.service;

import com.wallet.model.Wallet;

public interface WalletService {

    Wallet getWallet(int userId);

    boolean addMoney(
            int userId,
            double amount);

    boolean withdrawMoney(
            int userId,
            double amount);
}