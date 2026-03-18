Netflix Data Analysis & ETL Project

Project Overview:
A comprehensive project for analyzing Netflix library data. It aims to clean and transform the data (ETL) using Excel and SQL Server, then perform exploratory analysis using Python, culminating in the development of an interactive dashboard in Power BI.

Tools Used:
Excel: For initial cleaning and addressing missing values.
SQL Server (SQL): For data modeling and decompiling text arrays.
Python (Pandas): For exploratory statistical analysis (EDA) (coming soon).
Power BI: For data visualization and building indicators (coming soon).

Completed Stages (Work Log):
1. Data Cleaning Stage (Excel):
Processing the date column and standardizing formatting.
Creating a diff_of_year column to calculate the gap between the production date and the date added.
Processing the rating column and classifying content by age group.

2. Data Engineering and Modeling (SQL Server)
Importing data and building Fact Tables and Dimension Tables.
Using CROSS APPLY with STRING_SPLIT to decompose columns (actors, directors, countries, genres) to ensure accurate analysis.
Addressing the issue of extra spaces using TRIM and WHERE to prevent empty cells.
Creating SQL Views ready for export to other analysis tools.

Key Code Completions:
Decomposing the Dim_Countries column.
Decomposing the Dim_MovieClassification column.
Separating the Duration column into minutes (for movies) and seasons (for TV series).

Upcoming Analyses:
Performing advanced EDA analysis using Python to detect patterns.
Building a Star Schema model in Power BI.
Designing an interactive dashboard to answer business questions.
