package com.wallet.service;

import com.wallet.dao.WalletDAOImpl;
import com.wallet.model.Wallet;

public class WalletServiceImpl
        implements WalletService {

    private final WalletDAOImpl walletDAO =
            new WalletDAOImpl();

    private final TransactionServiceImpl transactionService =
            new TransactionServiceImpl();

    @Override
    public Wallet getWallet(int userId) {

        if (userId <= 0) {
            return null;
        }

        return walletDAO.getWalletByUserId(
                userId);
    }

    @Override
    public boolean addMoney(
            int userId,
            double amount) {

        if (userId <= 0 ||
                amount <= 0) {

            return false;
        }

        /*
         * TransactionService handles:
         *
         * 1. Wallet balance update
         * 2. DEPOSIT transaction creation
         * 3. Database transaction / rollback
         */
        return transactionService.addIncome(
                userId,
                amount);
    }

    @Override
    public boolean withdrawMoney(
            int userId,
            double amount) {

        if (userId <= 0 ||
                amount <= 0) {

            return false;
        }

        /*
         * TransactionService handles:
         *
         * 1. Balance validation
         * 2. Wallet balance update
         * 3. WITHDRAW transaction creation
         * 4. Database transaction / rollback
         */
        return transactionService.addExpense(
                userId,
                amount);
    }
}