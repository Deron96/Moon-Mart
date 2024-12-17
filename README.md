# Moon-Mart Project

## Overview
Moon-Mart is a fictional retail store database designed to demonstrate advanced SQL skills, data generation, analysis, and visualization.
It started from a desire I had to randomly generate a database in which the the employees and customers had actual names.
In previous random generations, I had identified individuals as "Employee1" or "Customer1", but I now wanted it to be more realistic.

I had the simple idea of extracting a list of first and last names from the internet and assigning them numbers.
These I would use to match with my RANDOM() function in order to provide everyone with not only unique IDs, but also unique first and last names.
The format of each transaction in SalesTransactions2023 is a unique transaction_id, a date and customer_id, and the amount spent in each individual department. From this table the individual Department tables are generated, not vice-versa.

This enabled me to keep the average departments involved per transaction in the 3 to 4 range (I have a built in check to ensure this), and it allowed me to base the demographics of the customer and the time of the year to determine the probability that he or she made a purchase on any given date for each individual department.

Although this method may seem a bit counterintuitive, it allowed me to seamlessly integrate desired gender-based, age-based, and seasonal trends into my SalesTransactions2023 dataset. Throughout this database generation script I have placed multiple DO $$ blocks, such as one with with loops to make sure that a minimum of 5 employees are assigned to each department. Checks such as this have proved quite useful due to the random nature of this dataset (despite it having trends) and have promoted logical consistency throughout its tables.

This project includes:
- A complete database generation script for ~70,000 transactions, ~800 customers, and 9 departments with realistic customer spending habits and employee compensation patterns.
- Analytical SQL queries for customer behavior, department performance, and forecasting.
- Visualizations created in PostgreSQL.
- A spreadsheet for adjusting sales-levels, number of customers, and number of transactions.

## Project Highlights
- **Custom Data Generation**:
  - Designed a script to generate realistic customer demographics and transactions.
  - Created ~70,000 transactions using randomized data with adjustable coefficients.
  - Populated ~800 customers with first and last names pulled from `.csv` files.
  - Script is reusable, with built in mechanisms for repeated generation of unique datasets to analyze
  - Includes built in checks to ensure certain conditions are met, such as total payroll being between 15 and 30% of total sales, and each department having a supervisor.

- **Key Analyses**:
  - Customer segmentation by age groups (e.g., highest spenders in the 30-40 range).
  - Department performance analysis, including payroll-to-sales ratios.
  - Forecasting sales trends using a 7-day moving average and calculating MAPE.
  - Employee data reveals a strong correlation between seniority and rate of pay.

- **Visualizations**:
  - Charts and graphs created in PostgreSQL, showcasing department performance and customer demographics.
 
- **Tools Used**:
  - PostgreSQL
  - SQL
  - Randomized data generation
  - Excel for coefficient adjustments

----------------------------------------------------------------------------------------------------------------------------------------

## How to Use the Project

1. Download the script: "Moon-Mart Script (Official).sql" from the "Moon-Mart Generation Script" folder.

2. This project requires two .csv files for generating random first and last names:

     	 "first_names.csv"
     	 "last_names.csv"

These files are included in the Moon-Mart-Names folder of this repository. You must download these files and ensure they are accessible locally before running the script.

3. The SQL script includes COPY commands to import data from the .csv files into the database. The commands are as follows:

     	 COPY FirstNames(year, name, gender, births, rank)
     	 FROM '/Users/gregorylester/Documents/Moon-Mart/Moon-Mart Names/first_names.csv'
      	 DELIMITER ',' CSV HEADER;

     	 COPY LastNames(name, rank, count)
    	 FROM '/Users/gregorylester/Documents/Moon-Mart/Moon-Mart Names/last_names.csv'
     	 DELIMITER ',' CSV HEADER;

You need to update the FROM paths to match the location of these .csv files on your computer. Here's how to do it:
Locate where you saved the "first_names.csv" and "last_names.csv" files on your computer.
Replace the FROM path with the actual path on your machine. 
Save the updated script after replacing the paths.

4. Run the Database Generation Script:
        Open PostgreSQL or your preferred SQL tool.
        Run the script from "Moon-Mart Script (Official).sql".   

5. Explore the Analysis Queries:
        Navigate to the Moon-Mart-SQL folder.
        Open and run the analysis_queries.sql file to reproduce the analyses and insights.

----------------------------------------------------------------------------------------------------------------------------------------

## Project Files
- Moon-Mart-Generation-Script: SQL script to generate the entire database.
- Moon-Mart-Names: CSV files of first and last names for customer and employee generation.
- Moon-Mart-Spreadsheets: An Excel file for adjusting data generation coefficients.
- Moon-Mart-SQL: Analytical SQL queries and observations.
- Moon-Mart-Visualizations: PNG files of visualizations created in PostgreSQL.
