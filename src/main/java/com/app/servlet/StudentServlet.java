package com.app.servlet;

import java.io.IOException;
import java.util.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.app.dao.StudentDAO;
import com.app.model.Student;

@WebServlet("/students")
public class StudentServlet extends HttpServlet {
    private final StudentDAO dao = new StudentDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {
                case "new":
                    req.getRequestDispatcher("form.jsp").forward(req, res);
                    break;

                case "edit":
                    int id = Integer.parseInt(req.getParameter("id"));
                    req.setAttribute("student", dao.getById(id));
                    req.getRequestDispatcher("form.jsp").forward(req, res);
                    break;

                case "delete":
                    int deleteId = Integer.parseInt(req.getParameter("id"));
                    dao.delete(deleteId);
                    res.sendRedirect("students");
                    break;

                case "deleteBatch":
                    String[] ids = req.getParameterValues("ids");
                    if (ids != null && ids.length > 0) {
                        dao.deleteBatch(ids);
                    }
                    res.sendRedirect("students");
                    break;

                default:
                    String query = req.getParameter("query");
                    String courseFilter = req.getParameter("courseFilter");
                    String statusFilter = req.getParameter("statusFilter");

                    List<Student> students = dao.search(query, courseFilter, statusFilter);
                    List<Student> allStudents = (query != null || courseFilter != null || statusFilter != null)
                            ? dao.getAll() : students;

                    // Calculate metrics
                    int totalStudents = allStudents.size();
                    int activeStudents = 0;
                    double totalGpa = 0.0;
                    Set<String> uniqueCourses = new TreeSet<>();

                    for (Student s : allStudents) {
                        if ("Active".equalsIgnoreCase(s.getStatus())) {
                            activeStudents++;
                        }
                        totalGpa += s.getGpa();
                        if (s.getCourse() != null && !s.getCourse().trim().isEmpty()) {
                            uniqueCourses.add(s.getCourse().trim());
                        }
                    }

                    double avgGpa = totalStudents > 0 ? (totalGpa / totalStudents) : 0.0;

                    req.setAttribute("students", students);
                    req.setAttribute("totalStudents", totalStudents);
                    req.setAttribute("activeStudents", activeStudents);
                    req.setAttribute("courseCount", uniqueCourses.size());
                    req.setAttribute("allCourses", uniqueCourses);
                    req.setAttribute("avgGpa", String.format(Locale.US, "%.2f", avgGpa));

                    req.setAttribute("paramQuery", query != null ? query : "");
                    req.setAttribute("paramCourseFilter", courseFilter != null ? courseFilter : "All");
                    req.setAttribute("paramStatusFilter", statusFilter != null ? statusFilter : "All");

                    req.getRequestDispatcher("list.jsp").forward(req, res);
                    break;
            }
        } catch (Exception e) {
            throw new ServletException("Student processing error: " + e.getMessage(), e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            String idStr = req.getParameter("id");
            String name = req.getParameter("name");
            String email = req.getParameter("email");
            String course = req.getParameter("course");
            String gpaStr = req.getParameter("gpa");
            String status = req.getParameter("status");

            double gpa = 3.5;
            if (gpaStr != null && !gpaStr.trim().isEmpty()) {
                try {
                    gpa = Double.parseDouble(gpaStr.trim());
                } catch (NumberFormatException ignored) {}
            }

            Student s = new Student();
            s.setName(name);
            s.setEmail(email);
            s.setCourse(course);
            s.setGpa(gpa);
            s.setStatus(status != null && !status.trim().isEmpty() ? status : "Active");

            if (idStr == null || idStr.trim().isEmpty()) {
                dao.add(s);
            } else {
                s.setId(Integer.parseInt(idStr.trim()));
                dao.update(s);
            }
            res.sendRedirect("students");
        } catch (Exception e) {
            throw new ServletException("Failed to save student: " + e.getMessage(), e);
        }
    }
}