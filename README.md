
# Project Title

Swiggy Data Warehouse & Sales Analysis using PostgreSQL

## Project Overview

This project demonstrates the complete data analytics workflow using PostgreSQL. The raw Swiggy dataset was cleaned, transformed, and modeled into a Star Schema consisting of dimension and fact tables. The project focuses on data cleaning, data warehousing, SQL analysis, and business insights generation.

## Dataset

The dataset contains:

* State
* City
* Order Date
* Restaurant Name
* Location
* Category
* Dish Name
* Price (INR)
* Rating
* Rating Count

## Data Cleaning Performed

* Identified NULL values
* Removed duplicate records using CTE and ROW_NUMBER()
* Checked blank values
* Standardized data structure
* Validated data quality

## Data Warehouse Design

### Dimension Tables

* d_date
* d_location
* d_restaurant
* d_category
* dim_dish

### Fact Table

* fact_table_swiggy

### Schema Type

### Star Schema 

## SQL Concepts Used

* CTE (Common Table Expressions)
* Window Functions
* ROW_NUMBER()
* CASE WHEN
* COALESCE()
* Aggregate Functions
* JOINs
* Data Cleaning Techniques
* Star Schema Modeling

## Sample Business Analysis

* Total Revenue
* Top Restaurants
* Category-wise Revenue
* Location-wise Sales
* Monthly Revenue Trends
* Rating Analysis

## Tools Used

* PostgreSQL
* pgAdmin
* VS Code
* GitHub

## Learning Outcomes

Through this project, I learned:

* Data Cleaning
* SQL Query Optimization
* Data Warehousing
* Star Schema Design
* Fact & Dimension Modeling
* Business Data Analysis

## Author
Mohit Kumar

Aspiring Data Analyst

Skills: SQL | PostgreSQL | Excel | Power BI | AI


