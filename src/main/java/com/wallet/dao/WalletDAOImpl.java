package com.wallet.dao;

import com.wallet.model.Wallet;
import com.wallet.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class WalletDAOImpl implements WalletDAO {

    @Override
    public boolean createWallet(int userId) {

        String sql =
                "INSERT INTO wallets(user_id,balance) VALUES(?,0)";

        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)
        ) {

            ps.setInt(1, userId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public Wallet getWalletByUserId(int userId) {

        String sql =
                "SELECT * FROM wallets WHERE user_id=?";

        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)
        ) {

            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                Wallet wallet = new Wallet();

                wallet.setId(rs.getInt("id"));
                wallet.setUserId(rs.getInt("user_id"));
                wallet.setBalance(rs.getDouble("balance"));

                return wallet;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    @Override
    public boolean updateBalance(int userId,
                                 double balance) {

        String sql =
                "UPDATE wallets SET balance=? WHERE user_id=?";

        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)
        ) {

            ps.setDouble(1, balance);
            ps.setInt(2, userId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // New Method
    @Override
    public double getBalance(int userId) {

        String sql =
                "SELECT balance FROM wallets WHERE user_id=?";

        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)
        ) {

            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getDouble("balance");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    // New Method for JDBC Transactions
    @Override
    public boolean updateBalance(Connection con,
                                 int userId,
                                 double balance) {

        String sql =
                "UPDATE wallets SET balance=? WHERE user_id=?";

        try (
                PreparedStatement ps =
                        con.prepareStatement(sql)
        ) {

            ps.setDouble(1, balance);
            ps.setInt(2, userId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}