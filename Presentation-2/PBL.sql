DROP DATABASE IF EXISTS EmployeePayrollDB;

CREATE DATABASE EmployeePayrollDB;

USE EmployeePayrollDB;
CREATE TABLE DEPARTMENT (
    Department_ID INT PRIMARY KEY,
    Department_Name VARCHAR(100) NOT NULL,
    Location VARCHAR(100)
);
INSERT INTO DEPARTMENT
(Department_ID, Department_Name, Location)
VALUES
(101, 'Human Resources', 'Hyderabad'),
(102, 'Information Technology', 'Hyderabad'),
(103, 'Finance', 'Bangalore'),
(104, 'Marketing', 'Mumbai');
CREATE TABLE DESIGNATION (
    Designation_ID INT PRIMARY KEY,
    Designation_Name VARCHAR(100) NOT NULL,
    Description VARCHAR(255)
);
INSERT INTO DESIGNATION
(Designation_ID, Designation_Name, Description)
VALUES
(201, 'HR Manager', 'Manages human resource activities'),
(202, 'Software Engineer', 'Develops and maintains software'),
(203, 'Accountant', 'Handles financial records'),
(204, 'Marketing Executive', 'Handles marketing activities');
CREATE TABLE EMPLOYEE (
    Employee_ID INT PRIMARY KEY,
    Employee_Name VARCHAR(100) NOT NULL,
    Date_of_Birth DATE,
    Gender VARCHAR(10),
    Date_of_Joining DATE,
    Department_ID INT,
    Designation_ID INT,
    Phone VARCHAR(15),
    Email VARCHAR(100),
    Address VARCHAR(255),

    FOREIGN KEY (Department_ID)
        REFERENCES DEPARTMENT(Department_ID),

    FOREIGN KEY (Designation_ID)
        REFERENCES DESIGNATION(Designation_ID)
);
INSERT INTO EMPLOYEE
(Employee_ID, Employee_Name, Date_of_Birth, Gender,
 Date_of_Joining, Department_ID, Designation_ID,
 Phone, Email, Address)
VALUES
(1001, 'Rahul Sharma', '1995-05-12', 'Male',
 '2020-06-15', 102, 202,
 '9876543210', 'rahul@gmail.com', 'Hyderabad'),

(1002, 'Priya Reddy', '1996-08-20', 'Female',
 '2021-01-10', 101, 201,
 '9876543211', 'priya@gmail.com', 'Hyderabad'),

(1003, 'Arjun Rao', '1994-03-18', 'Male',
 '2019-07-01', 103, 203,
 '9876543212', 'arjun@gmail.com', 'Bangalore'),

(1004, 'Sneha Patel', '1997-11-25', 'Female',
 '2022-04-05', 104, 204,
 '9876543213', 'sneha@gmail.com', 'Mumbai');
 
 CREATE TABLE ATTENDANCE (
    Attendance_ID INT PRIMARY KEY,
    Employee_ID INT,
    Month VARCHAR(20),
    Working_Days INT,
    Leave_Days INT,
    Absent_Days INT,

    FOREIGN KEY (Employee_ID)
        REFERENCES EMPLOYEE(Employee_ID)
);
INSERT INTO ATTENDANCE
(Attendance_ID, Employee_ID, Month,
 Working_Days, Leave_Days, Absent_Days)
VALUES
(301, 1001, 'August', 26, 2, 0),
(302, 1002, 'August', 26, 1, 1),
(303, 1003, 'August', 26, 3, 0),
(304, 1004, 'August', 26, 2, 1);
CREATE TABLE SALARY_COMPONENT (
    Component_ID INT PRIMARY KEY,
    Component_Name VARCHAR(100) NOT NULL,
    Component_Type VARCHAR(50),
    Description VARCHAR(255)
);
INSERT INTO SALARY_COMPONENT
(Component_ID, Component_Name, Component_Type, Description)
VALUES
(401, 'Basic Salary', 'Earning', 'Basic monthly salary'),
(402, 'HRA', 'Earning', 'House Rent Allowance'),
(403, 'DA', 'Earning', 'Dearness Allowance'),
(404, 'PF', 'Deduction', 'Provident Fund'),
(405, 'Professional Tax', 'Deduction', 'Professional tax deduction');
CREATE TABLE SALARY (
    Salary_ID INT PRIMARY KEY,
    Employee_ID INT,
    Component_ID INT,
    Basic_Salary DECIMAL(10,2),
    HRA DECIMAL(10,2),
    DA DECIMAL(10,2),
    Other_Allowances DECIMAL(10,2),
    Overtime_Amount DECIMAL(10,2),

    FOREIGN KEY (Employee_ID)
        REFERENCES EMPLOYEE(Employee_ID),

    FOREIGN KEY (Component_ID)
        REFERENCES SALARY_COMPONENT(Component_ID)
);
INSERT INTO SALARY
(Salary_ID, Employee_ID, Component_ID,
 Basic_Salary, HRA, DA, Other_Allowances, Overtime_Amount)
VALUES
(501, 1001, 401, 50000, 10000, 5000, 3000, 2000),
(502, 1002, 401, 45000, 9000, 4500, 2500, 1500),
(503, 1003, 401, 55000, 11000, 5500, 3500, 2500),
(504, 1004, 401, 40000, 8000, 4000, 2000, 1000);
CREATE TABLE DEDUCTION (
    Deduction_ID INT PRIMARY KEY,
    Employee_ID INT,
    Component_ID INT,
    Deduction_Type VARCHAR(100),
    Amount DECIMAL(10,2),

    FOREIGN KEY (Employee_ID)
        REFERENCES EMPLOYEE(Employee_ID),

    FOREIGN KEY (Component_ID)
        REFERENCES SALARY_COMPONENT(Component_ID)
);
INSERT INTO DEDUCTION
(Deduction_ID, Employee_ID, Component_ID,
 Deduction_Type, Amount)
VALUES
(601, 1001, 404, 'Provident Fund', 5000),
(602, 1001, 405, 'Professional Tax', 200),
(603, 1002, 404, 'Provident Fund', 4500),
(604, 1002, 405, 'Professional Tax', 200),
(605, 1003, 404, 'Provident Fund', 5500),
(606, 1004, 405, 'Professional Tax', 200);
CREATE TABLE PAYROLL (
    Payroll_ID INT PRIMARY KEY,
    Employee_ID INT,
    Payroll_Month VARCHAR(20),
    Payroll_Year INT,
    Gross_Salary DECIMAL(10,2),
    Total_Deductions DECIMAL(10,2),
    Net_Salary DECIMAL(10,2),
    Payment_ID INT NULL,

    FOREIGN KEY (Employee_ID)
        REFERENCES EMPLOYEE(Employee_ID)
);
INSERT INTO PAYROLL
(Payroll_ID, Employee_ID, Payroll_Month, Payroll_Year,
 Gross_Salary, Total_Deductions, Net_Salary, Payment_ID)
VALUES
(701, 1001, 'August', 2026, 70000, 5200, 64800, NULL),
(702, 1002, 'August', 2026, 62000, 4700, 57300, NULL),
(703, 1003, 'August', 2026, 77000, 5500, 71500, NULL),
(704, 1004, 'August', 2026, 55000, 200, 54800, NULL);
CREATE TABLE PAYMENT (
    Payment_ID INT PRIMARY KEY,
    Payroll_ID INT,
    Payment_Mode VARCHAR(50),
    Transaction_ID VARCHAR(100),
    Payment_Date DATE,
    Payment_Status VARCHAR(50),

    FOREIGN KEY (Payroll_ID)
        REFERENCES PAYROLL(Payroll_ID)
);
INSERT INTO PAYMENT
(Payment_ID, Payroll_ID, Payment_Mode,
 Transaction_ID, Payment_Date, Payment_Status)
VALUES
(801, 701, 'Bank Transfer', 'TXN10001', '2026-08-31', 'Completed'),
(802, 702, 'Bank Transfer', 'TXN10002', '2026-08-31', 'Completed'),
(803, 703, 'Bank Transfer', 'TXN10003', '2026-08-31', 'Completed'),
(804, 704, 'UPI', 'TXN10004', '2026-08-31', 'Completed');
UPDATE PAYROLL
SET Payment_ID = 801
WHERE Payroll_ID = 701;

UPDATE PAYROLL
SET Payment_ID = 802
WHERE Payroll_ID = 702;

UPDATE PAYROLL
SET Payment_ID = 803
WHERE Payroll_ID = 703;

UPDATE PAYROLL
SET Payment_ID = 804
WHERE Payroll_ID = 704;
ALTER TABLE PAYROLL
ADD CONSTRAINT fk_payroll_payment
FOREIGN KEY (Payment_ID)
REFERENCES PAYMENT(Payment_ID);
INSERT INTO DEPARTMENT
(Department_ID, Department_Name, Location)
VALUES
(105, 'Operations', 'Chennai'),
(106, 'Research and Development', 'Pune'),
(107, 'Sales', 'Delhi'),
(108, 'Legal', 'Hyderabad'),
(109, 'Customer Support', 'Kolkata'),
(110, 'Administration', 'Bangalore');
INSERT INTO DESIGNATION
(Designation_ID, Designation_Name, Description)
VALUES
(205, 'Team Leader', 'Leads and coordinates a team'),
(206, 'Data Analyst', 'Analyzes organizational data'),
(207, 'Project Manager', 'Manages projects and teams'),
(208, 'Business Analyst', 'Analyzes business requirements'),
(209, 'System Administrator', 'Manages IT systems and infrastructure'),
(210, 'Senior Software Engineer', 'Develops and supervises software projects');
INSERT INTO EMPLOYEE
(Employee_ID, Employee_Name, Date_of_Birth, Gender,
Date_of_Joining, Department_ID, Designation_ID,
Phone, Email, Address)
VALUES
(1005, 'Kiran Kumar', '1995-02-14', 'Male',
'2021-05-20', 105, 205,
'9876543214', 'kiran@gmail.com', 'Chennai'),

(1006, 'Ananya Singh', '1998-07-09', 'Female',
'2022-02-15', 106, 206,
'9876543215', 'ananya@gmail.com', 'Pune'),

(1007, 'Vikram Mehta', '1993-12-11', 'Male',
'2018-09-10', 107, 207,
'9876543216', 'vikram@gmail.com', 'Delhi'),

(1008, 'Divya Nair', '1997-04-23', 'Female',
'2023-01-12', 108, 208,
'9876543217', 'divya@gmail.com', 'Hyderabad'),

(1009, 'Rohit Verma', '1996-10-30', 'Male',
'2020-11-18', 109, 209,
'9876543218', 'rohit@gmail.com', 'Kolkata'),

(1010, 'Aisha Khan', '1995-06-17', 'Female',
'2019-03-25', 110, 210,
'9876543219', 'aisha@gmail.com', 'Bangalore');
INSERT INTO ATTENDANCE
(Attendance_ID, Employee_ID, Month,
Working_Days, Leave_Days, Absent_Days)
VALUES
(305, 1005, 'August', 26, 1, 0),
(306, 1006, 'August', 26, 2, 0),
(307, 1007, 'August', 26, 0, 1),
(308, 1008, 'August', 26, 2, 0),
(309, 1009, 'August', 26, 3, 1),
(310, 1010, 'August', 26, 1, 0);
INSERT INTO SALARY_COMPONENT
(Component_ID, Component_Name, Component_Type, Description)
VALUES
(406, 'Medical Allowance', 'Earning', 'Monthly medical allowance'),
(407, 'Travel Allowance', 'Earning', 'Transportation allowance'),
(408, 'Bonus', 'Earning', 'Performance based bonus'),
(409, 'Income Tax', 'Deduction', 'Income tax deduction'),
(410, 'Insurance', 'Deduction', 'Employee insurance deduction'),
(411, 'Loan Recovery', 'Deduction', 'Monthly employee loan recovery');
INSERT INTO SALARY
(Salary_ID, Employee_ID, Component_ID,
Basic_Salary, HRA, DA, Other_Allowances, Overtime_Amount)
VALUES
(505, 1005, 401, 48000, 9600, 4800, 3000, 1800),

(506, 1006, 401, 52000, 10400, 5200, 3500, 2200),

(507, 1007, 401, 75000, 15000, 7500, 5000, 3000),

(508, 1008, 401, 46000, 9200, 4600, 2800, 1500),

(509, 1009, 401, 43000, 8600, 4300, 2500, 1200),

(510, 1010, 401, 68000, 13600, 6800, 4500, 2500);
INSERT INTO DEDUCTION
(Deduction_ID, Employee_ID, Component_ID,
Deduction_Type, Amount)
VALUES
(607, 1005, 404, 'Provident Fund', 4800),

(608, 1005, 405, 'Professional Tax', 200),

(609, 1006, 404, 'Provident Fund', 5200),

(610, 1006, 409, 'Income Tax', 2500),

(611, 1007, 404, 'Provident Fund', 7500),

(612, 1007, 409, 'Income Tax', 6500),

(613, 1008, 404, 'Provident Fund', 4600),

(614, 1008, 410, 'Insurance', 1000),

(615, 1009, 404, 'Provident Fund', 4300),

(616, 1009, 411, 'Loan Recovery', 2000),

(617, 1010, 404, 'Provident Fund', 6800),

(618, 1010, 409, 'Income Tax', 4500);
INSERT INTO PAYROLL
(Payroll_ID, Employee_ID, Payroll_Month, Payroll_Year,
Gross_Salary, Total_Deductions, Net_Salary, Payment_ID)
VALUES
(705, 1005, 'August', 2026, 67200, 5000, 62200, NULL),

(706, 1006, 'August', 2026, 73300, 7700, 65600, NULL),

(707, 1007, 'August', 2026, 100500, 14000, 86500, NULL),

(708, 1008, 'August', 2026, 64100, 5600, 58500, NULL),

(709, 1009, 'August', 2026, 59600, 6300, 53300, NULL),

(710, 1010, 'August', 2026, 92800, 11300, 81500, NULL);
INSERT INTO PAYMENT
(Payment_ID, Payroll_ID, Payment_Mode,
Transaction_ID, Payment_Date, Payment_Status)
VALUES
(805, 705, 'Bank Transfer', 'TXN10005', '2026-08-31', 'Completed'),

(806, 706, 'UPI', 'TXN10006', '2026-08-31', 'Completed'),

(807, 707, 'Bank Transfer', 'TXN10007', '2026-08-31', 'Completed'),

(808, 708, 'Bank Transfer', 'TXN10008', '2026-08-31', 'Completed'),

(809, 709, 'UPI', 'TXN10009', '2026-08-31', 'Completed'),

(810, 710, 'Bank Transfer', 'TXN10010', '2026-08-31', 'Completed');
UPDATE PAYROLL
SET Payment_ID = 805
WHERE Payroll_ID = 705;

UPDATE PAYROLL
SET Payment_ID = 806
WHERE Payroll_ID = 706;

UPDATE PAYROLL
SET Payment_ID = 807
WHERE Payroll_ID = 707;

UPDATE PAYROLL
SET Payment_ID = 808
WHERE Payroll_ID = 708;

UPDATE PAYROLL
SET Payment_ID = 809
WHERE Payroll_ID = 709;

UPDATE PAYROLL
SET Payment_ID = 810
WHERE Payroll_ID = 710;
SELECT COUNT(*) AS Total_Employees
FROM EMPLOYEE;
SHOW TABLES;
SELECT * FROM DEPARTMENT;
