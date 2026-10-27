package com.wallet.service;

import com.wallet.dao.NotificationDAO;
import com.wallet.model.Notification;

import java.util.List;

public class NotificationService {

    private final NotificationDAO notificationDAO =
            new NotificationDAO();

    public List<Notification> getUserNotifications(
            int userId) {

        return notificationDAO.findByUserId(userId);
    }

    public void markAsRead(
            int notificationId,
            int userId) {

        notificationDAO.markAsRead(
                notificationId,
                userId);
    }

    public void markAllAsRead(
            int userId) {

        notificationDAO.markAllAsRead(userId);
    }

    public void createNotification(
            Notification notification) {

        notificationDAO.save(notification);
    }
}