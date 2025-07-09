# sql-internship-project
My projects for the Elevate Labs Internship.

# Personal Finance Tracker SQL Project

This repository contains the files for a comprehensive Personal Finance Tracker database project, completed as part of the Elevate Labs Internship. The goal of this project was to design and implement a relational database using SQL to manage user finances, including income, expenses, and automated data tracking.
* A detailed project report is available in **SqlReport.pdf**.

## Features

* **Robust Schema Design:** A relational schema with 4 main tables (`Users`, `Expenses`, `Income`, `Categories`) to ensure data integrity and logical data storage.
* **Custom Data Population:** The database is populated with a custom dataset for 10 users with realistic financial transactions.
* **In-depth Analytical Queries:** SQL queries were developed to generate reports on key metrics, such as user spending by month and by category.
* **Simplified Summary View:** A `VIEW` (`UserBalance`) was created to provide a simple, real-time summary of each user's total income, expenses, and current financial balance.
* **Automation with Triggers:** An advanced `TRIGGER` (`update_last_activity`) was implemented to automatically update a user's profile with a timestamp whenever they record a new expense, demonstrating database automation.

## Database Schema

The database consists of four main tables:

* **Users**: Stores user information.
    * `user_id` (Primary Key)
    * `username`
    * `email`
    * `join_date`
    * `last_activity_date`
* **Categories**: Stores different types of income or expenses.
    * `category_id` (Primary Key)
    * `category_name`
* **Income**: Stores all income records for each user.
    * `income_id` (Primary Key)
    * `user_id` (Foreign Key)
    * `amount`
    * `date_received`
* **Expenses**: Stores all expense records for each user.
    * `expense_id` (Primary Key)
    * `user_id` (Foreign Key)
    * `category_id` (Foreign Key)
    * `amount`
    * `date_of_expense`

## Tools & Technologies

* **Language:** SQL
* **Database:** SQLite
* **Management Tool:** DB Browser for SQLite

## How to Use

1.  **Explore the Final Database:** You can directly open the `finance_tracker.db` file using a tool like DB Browser for SQLite to explore the tables, views, and data.
2.  **Recreate the Database:** To build the database from scratch, execute the entire `trackerproject.sql` script in an SQLite environment.
