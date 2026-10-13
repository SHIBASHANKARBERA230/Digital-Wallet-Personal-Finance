package com.wallet.controller;

import com.wallet.model.User;
import com.wallet.service.ReportService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.Map;

@WebServlet("/reports")
public class ReportServlet extends HttpServlet {

    private final ReportService reportService =
            new ReportService();

