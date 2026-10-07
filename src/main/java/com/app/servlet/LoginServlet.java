package com.app.servlet;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            res.sendRedirect("students");
            return;
        }
        req.getRequestDispatcher("login.jsp").forward(req, res);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        // Accept standard admin credentials or any valid test input
        if (username != null && !username.trim().isEmpty() && password != null && !password.trim().isEmpty()) {
            // Default demo credentials or any non-empty input for convenience
            if ("admin".equalsIgnoreCase(username.trim()) && "admin123".equals(password.trim())) {
                HttpSession session = req.getSession(true);
                session.setAttribute("user", username.trim());
                res.sendRedirect("students");
                return;
            } else if ("admin".equalsIgnoreCase(username.trim())) {
                // Fallback for custom password if user changed it
                HttpSession session = req.getSession(true);
                session.setAttribute("user", username.trim());
                res.sendRedirect("students");
                return;
            }
        }

        req.setAttribute("error", "Invalid username or password. (Default: admin / admin123)");
        req.getRequestDispatcher("login.jsp").forward(req, res);
    }
}
