package com.app.dao;

import java.sql.*;
import java.util.*;
import com.app.model.Student;

public class StudentDAO {

    private static boolean initialized = false;

    private Connection getConnection() throws Exception {
        Class.forName("oracle.jdbc.OracleDriver");
        Connection conn = DriverManager.getConnection(
            "jdbc:oracle:thin:@localhost:1521:xe", "system", "cycle");
        if (!initialized) {
            initDatabaseSchema(conn);
            initialized = true;
        }
        return conn;
    }

    private void initDatabaseSchema(Connection conn) {
        // Ensure student table and sequence exist
        try (Statement st = conn.createStatement()) {
            st.executeUpdate("CREATE TABLE student ("
                + "id NUMBER PRIMARY KEY, "
                + "name VARCHAR2(100) NOT NULL, "
                + "email VARCHAR2(100), "
                + "course VARCHAR2(100), "
                + "gpa NUMBER(3,2) DEFAULT 3.5, "
                + "status VARCHAR2(50) DEFAULT 'Active')"
            );
        } catch (SQLException ignored) {
            // Table already exists or creation failed, ensure columns exist if legacy table
            try (Statement st = conn.createStatement()) {
                st.executeUpdate("ALTER TABLE student ADD (gpa NUMBER(3,2) DEFAULT 3.5, status VARCHAR2(50) DEFAULT 'Active')");
            } catch (SQLException ignoredColumn) {}
        }

        try (Statement st = conn.createStatement()) {
            st.executeUpdate("CREATE SEQUENCE student_seq START WITH 1 INCREMENT BY 1");
        } catch (SQLException ignored) {
            // Sequence already exists
        }
    }

    // CREATE
    public void add(Student s) throws Exception {
        String sql = "INSERT INTO student(id, name, email, course, gpa, status) VALUES(student_seq.NEXTVAL, ?, ?, ?, ?, ?)";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, s.getName());
            ps.setString(2, s.getEmail());
            ps.setString(3, s.getCourse());
            ps.setDouble(4, s.getGpa() > 0 ? s.getGpa() : 3.5);
            ps.setString(5, s.getStatus() != null ? s.getStatus() : "Active");
            ps.executeUpdate();
        }
    }

    // READ (all)
    public List<Student> getAll() throws Exception {
        return search(null, null, null);
    }

    // SEARCH & FILTER
    public List<Student> search(String query, String courseFilter, String statusFilter) throws Exception {
        List<Student> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT id, name, email, course, ");
        sql.append("NVL(gpa, 3.5) AS gpa, NVL(status, 'Active') AS status ");
        sql.append("FROM student WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        if (query != null && !query.trim().isEmpty()) {
            sql.append("AND (LOWER(name) LIKE ? OR LOWER(email) LIKE ? OR LOWER(course) LIKE ?) ");
            String q = "%" + query.trim().toLowerCase() + "%";
            params.add(q);
            params.add(q);
            params.add(q);
        }

        if (courseFilter != null && !courseFilter.trim().isEmpty() && !"All".equalsIgnoreCase(courseFilter)) {
            sql.append("AND course = ? ");
            params.add(courseFilter.trim());
        }

        if (statusFilter != null && !statusFilter.trim().isEmpty() && !"All".equalsIgnoreCase(statusFilter)) {
            sql.append("AND LOWER(status) = ? ");
            params.add(statusFilter.trim().toLowerCase());
        }

        sql.append("ORDER BY id DESC");

        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapStudent(rs));
                }
            }
        }
        return list;
    }

    // READ (one)
    public Student getById(int id) throws Exception {
        String sql = "SELECT id, name, email, course, NVL(gpa, 3.5) AS gpa, NVL(status, 'Active') AS status FROM student WHERE id=?";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapStudent(rs);
                }
            }
        }
        return null;
    }

    // UPDATE
    public void update(Student s) throws Exception {
        String sql = "UPDATE student SET name=?, email=?, course=?, gpa=?, status=? WHERE id=?";
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, s.getName());
            ps.setString(2, s.getEmail());
            ps.setString(3, s.getCourse());
            ps.setDouble(4, s.getGpa() > 0 ? s.getGpa() : 3.5);
            ps.setString(5, s.getStatus() != null ? s.getStatus() : "Active");
            ps.setInt(6, s.getId());
            ps.executeUpdate();
        }
    }

    // DELETE
    public void delete(int id) throws Exception {
        try (Connection c = getConnection();
             PreparedStatement ps = c.prepareStatement("DELETE FROM student WHERE id=?")) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    // BATCH DELETE
    public void deleteBatch(String[] ids) throws Exception {
        if (ids == null || ids.length == 0) return;
        StringBuilder sql = new StringBuilder("DELETE FROM student WHERE id IN (");
        for (int i = 0; i < ids.length; i++) {
            sql.append(i == 0 ? "?" : ", ?");
        }
        sql.append(")");
        try (Connection c = getConnection(); PreparedStatement ps = c.prepareStatement(sql.toString())) {
            for (int i = 0; i < ids.length; i++) {
                ps.setInt(i + 1, Integer.parseInt(ids[i]));
            }
            ps.executeUpdate();
        }
    }

    private Student mapStudent(ResultSet rs) throws SQLException {
        double gpaVal = 3.5;
        try {
            gpaVal = rs.getDouble("gpa");
            if (rs.wasNull()) gpaVal = 3.5;
        } catch (SQLException ignored) {}

        String statusVal = "Active";
        try {
            statusVal = rs.getString("status");
            if (statusVal == null) statusVal = "Active";
        } catch (SQLException ignored) {}

        return new Student(
            rs.getInt("id"),
            rs.getString("name"),
            rs.getString("email"),
            rs.getString("course"),
            gpaVal,
            statusVal
        );
    }
}