-- Oracle Database Initial Schema Script for StudentApp

-- 1. Create Student Table
CREATE TABLE student (
    id NUMBER PRIMARY KEY,
    name VARCHAR2(100) NOT NULL,
    email VARCHAR2(100) NOT NULL,
    course VARCHAR2(100) NOT NULL,
    gpa NUMBER(3,2) DEFAULT 3.50,
    status VARCHAR2(50) DEFAULT 'Active'
);

-- 2. Create Sequence for Auto Increment Primary Keys
CREATE SEQUENCE student_seq
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- 3. Optional Seed Data
INSERT INTO student (id, name, email, course, gpa, status)
VALUES (student_seq.NEXTVAL, 'Alex Morgan', 'alex.morgan@university.edu', 'Computer Science', 3.85, 'Active');

INSERT INTO student (id, name, email, course, gpa, status)
VALUES (student_seq.NEXTVAL, 'Samantha Reed', 'samantha.reed@university.edu', 'Business Administration', 3.92, 'Active');

INSERT INTO student (id, name, email, course, gpa, status)
VALUES (student_seq.NEXTVAL, 'Marcus Vance', 'marcus.vance@university.edu', 'Data Science', 3.40, 'On-Leave');

COMMIT;
