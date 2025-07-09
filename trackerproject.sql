-- Project: Personal Finance Tracker

-- Step 1: Create the Database Schema


CREATE TABLE Users (
    user_id INTEGER PRIMARY KEY AUTOINCREMENT,
    username VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    join_date DATE DEFAULT CURRENT_TIMESTAMP,
    last_activity_date DATE
);

CREATE TABLE Categories (
    category_id INTEGER PRIMARY KEY AUTOINCREMENT,
    category_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Income (
    income_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    amount REAL NOT NULL,
    source_of_income VARCHAR(100),
    date_received DATE NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Expenses (
    expense_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    category_id INTEGER NOT NULL,
    amount REAL NOT NULL,
    date_of_expense DATE NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);


-- Step 2: Insert and Update Data

-- Insert initial users and categories
INSERT INTO Users (username, email) VALUES ('Aisha', 'aisha@email.com'), ('Sameer', 'sameer@email.com');
INSERT INTO Users (username, email) VALUES ('Priya', 'priya@email.com'), ('Rohan', 'rohan@email.com'), ('Ananya', 'ananya@email.com'), ('Vikram', 'vikram@email.com'), ('Meera', 'meera@email.com'), ('Arjun', 'arjun@email.com'), ('Sana', 'sana@email.com'), ('Kabir', 'kabir@email.com');

INSERT INTO Categories (category_name) VALUES ('Salary'), ('Groceries'), ('Rent'), ('Utilities'), ('Transport'), ('Entertainment');

-- Insert income and expense records
INSERT INTO Income (user_id, amount, source_of_income, date_received) VALUES (1, 3000.00, 'Salary', '2025-06-01'),(2, 2500.00, 'Salary', '2025-06-05'),(1, 500.00, 'Freelance', '2025-06-15'),(3, 3200.00, 'Salary', '2025-06-03'),(4, 4500.00, 'Salary', '2025-06-01'),(5, 1500.00, 'Part-time Job', '2025-06-10'),(6, 2800.00, 'Salary', '2025-06-05'),(7, 3100.00, 'Salary', '2025-06-02'),(8, 2200.00, 'Freelance', '2025-06-15'),(8, 950.00, 'Contract', '2025-06-25'),(9, 2900.00, 'Salary', '2025-06-04'),(10, 3300.00, 'Salary', '2025-06-01');
INSERT INTO Expenses (user_id, category_id, amount, date_of_expense) VALUES (1, 3, 1200.00, '2025-06-02'),(1, 2, 150.50, '2025-06-05'),(1, 4, 75.25, '2025-06-10'),(1, 6, 50.00, '2025-06-18'),(1, 2, 80.75, '2025-06-20'),(2, 3, 1000.00, '2025-06-06'),(2, 5, 60.00, '2025-06-12'),(2, 2, 210.00, '2025-06-22'),(3, 3, 1150.00, '2025-06-05'),(3, 5, 85.00, '2025-06-15'),(3, 2, 120.00, '2025-06-20'),(4, 3, 1500.00, '2025-06-02'),(4, 6, 200.00, '2025-06-18'),(5, 3, 700.00, '2025-06-11'),(5, 2, 250.00, '2025-06-15'),(6, 3, 1000.00, '2025-06-06'),(6, 4, 90.00, '2025-06-10'),(7, 3, 1100.00, '2025-06-03'),(7, 2, 180.00, '2025-06-09'),(8, 3, 900.00, '2025-06-20'),(8, 5, 75.00, '2025-06-22'),(9, 3, 1050.00, '2025-06-05'),(9, 6, 100.00, '2025-06-19'),(10, 3, 1250.00, '2025-06-03'),(10, 2, 160.00, '2025-06-12');


-- Step 3: Analysis Queries

-- Query 1: Summarize Expenses Monthly
SELECT
    u.username,
    strftime('%Y-%m', e.date_of_expense) AS expense_month,
    SUM(e.amount) AS total_monthly_expenses
FROM Expenses e
JOIN Users u ON e.user_id = u.user_id
GROUP BY u.username, expense_month
ORDER BY u.username, expense_month;

-- Query 2: Spending by Category
SELECT
    u.username,
    c.category_name,
    SUM(e.amount) AS total_spent
FROM Expenses e
JOIN Users u ON e.user_id = u.user_id
JOIN Categories c ON e.category_id = c.category_id
GROUP BY u.username, c.category_name
ORDER BY u.username, total_spent DESC;


-- Step 4: Create View and Trigger

-- Create a view for a summary balance report
CREATE VIEW UserBalance AS
SELECT
    u.username,
    (SELECT SUM(amount) FROM Income WHERE user_id = u.user_id) AS total_income,
    (SELECT SUM(amount) FROM Expenses WHERE user_id = u.user_id) AS total_expenses,
    (SELECT SUM(amount) FROM Income WHERE user_id = u.user_id) - (SELECT SUM(amount) FROM Expenses WHERE user_id = u.user_id) AS current_balance
FROM Users u;

-- Query to see the view's results
SELECT * FROM UserBalance;

-- Create a trigger to update last_activity_date on new expenses
CREATE TRIGGER update_last_activity
AFTER INSERT ON Expenses
FOR EACH ROW
BEGIN
    UPDATE Users
    SET last_activity_date = CURRENT_TIMESTAMP
    WHERE user_id = NEW.user_id;
END;

-- One-time update to back-fill existing data
UPDATE Users
SET last_activity_date = (
    SELECT MAX(date_of_expense)
    FROM Expenses
    WHERE Expenses.user_id = Users.user_id
)
WHERE
    user_id IN (SELECT DISTINCT user_id FROM Expenses);