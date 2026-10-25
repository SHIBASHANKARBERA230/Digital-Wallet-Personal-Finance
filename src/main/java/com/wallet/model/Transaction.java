package com.wallet.model;

import java.sql.Timestamp;

import com.wallet.enums.TransactionStatus;
import com.wallet.enums.TransactionType;

public class Transaction {

    private int id;
    private int senderId;
    private int receiverId;
    private double amount;
    private TransactionType transactionType;
    private TransactionStatus status;
    private Timestamp transactionDate;

    public Transaction() {
    }

    public Transaction(int id, int senderId, int receiverId,
                       double amount,
                       TransactionType transactionType,
                       TransactionStatus status,
                       Timestamp transactionDate) {

        this.id = id;
        this.senderId = senderId;
        this.receiverId = receiverId;
        this.amount = amount;
        this.transactionType = transactionType;
        this.status = status;
        this.transactionDate = transactionDate;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getSenderId() {
        return senderId;
    }

    public void setSenderId(int senderId) {
        this.senderId = senderId;
    }

    public int getReceiverId() {
        return receiverId;
    }

    public void setReceiverId(int receiverId) {
        this.receiverId = receiverId;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public TransactionType getTransactionType() {
        return transactionType;
    }

    public void setTransactionType(TransactionType transactionType) {
        this.transactionType = transactionType;
    }

    public TransactionStatus getStatus() {
        return status;
    }

    public void setStatus(TransactionStatus status) {
        this.status = status;
    }

    public Timestamp getTransactionDate() {
        return transactionDate;
    }

    public void setTransactionDate(Timestamp transactionDate) {
        this.transactionDate = transactionDate;
    }
}