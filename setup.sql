-- if students.db is not already populated.
-- create dummy data using:
-- sqlite3 students.db < setup.sql
CREATE TABLE users (
    student_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    age INTEGER,
    class TEXT
);

INSERT INTO users (student_id, name, age, class) VALUES
(1, 'John Doe', 15, '10A'),
(2, 'Jane Smith', 16, '11B'),
(3, 'Mike Johnson', 14, '9C'),
(4, 'Emily Brown', 15, '10B'),
(5, 'David Lee', 16, '11A'),
(6, 'Sarah Wilson', 14, '9A'),
(7, 'Tom Anderson', 15, '10C'),
(8, 'Lisa Taylor', 16, '11C'),
(9, 'James Martin', 14, '9B'),
(10, 'Emma Garcia', 15, '10A');
