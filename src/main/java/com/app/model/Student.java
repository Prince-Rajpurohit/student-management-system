package com.app.model;

public class Student {
    private int id;
    private String name;
    private String email;
    private String course;
    private double gpa;
    private String status;

    public Student() {
        this.gpa = 3.5;
        this.status = "Active";
    }

    public Student(int id, String name, String email, String course) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.course = course;
        this.gpa = 3.5;
        this.status = "Active";
    }

    public Student(int id, String name, String email, String course, double gpa, String status) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.course = course;
        this.gpa = gpa > 0 ? gpa : 3.5;
        this.status = (status != null && !status.isEmpty()) ? status : "Active";
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getCourse() { return course; }
    public void setCourse(String course) { this.course = course; }

    public double getGpa() { return gpa; }
    public void setGpa(double gpa) { this.gpa = gpa; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getInitial() {
        if (name == null || name.trim().isEmpty()) return "S";
        return name.trim().substring(0, 1).toUpperCase();
    }
}