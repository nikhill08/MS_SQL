create database Covid

use Covid;


-- Step 1: Create the table

create table covid_vaccine_statewise(
UpdatedOn DATE,
    State VARCHAR(100),
    TotalDosesAdministered FLOAT,
    Sessions FLOAT,
    Sites FLOAT,
    FirstDoseAdministered FLOAT,
    SecondDoseAdministered FLOAT,
    MaleDosesAdministered FLOAT,
    FemaleDosesAdministered FLOAT,
    TransgenderDosesAdministered FLOAT,
    CovaxinDosesAdministered FLOAT,
    CoviShieldDosesAdministered FLOAT,
    SputnikVDosesAdministered FLOAT,
    AEFI FLOAT,
    Age18To44YearsDosesAdministered FLOAT,
    Age45To60YearsDosesAdministered FLOAT,
    Age60PlusYearsDosesAdministered FLOAT,
    Age18To44YearsIndividualsVaccinated FLOAT,
    Age45To60YearsIndividualsVaccinated FLOAT,
    Age60PlusYearsIndividualsVaccinated FLOAT,
    MaleIndividualsVaccinated FLOAT,
    FemaleIndividualsVaccinated FLOAT,
    TransgenderIndividualsVaccinated FLOAT,
    TotalIndividualsVaccinated FLOAT
);


-- Step 2: Bulk insert data from CSV

BULK INSERT VaccinationData
FROM 'C:\covid_vaccine_statewise.csv'
WITH (
    FIELDTERMINATOR = ',',  -- Specify the field delimiter
    ROWTERMINATOR = '\r\n',   -- Specify the row delimiter
    FIRSTROW = 2            -- Skip the header row 
);


select * from covid_vaccine_statewise


-- Step 1: Create the table
CREATE TABLE covid_19_india (
    Sno INT PRIMARY KEY,
    Date DATE,
    Time TIME,
    State NVARCHAR(100),
    ConfirmedIndianNational INT,
    ConfirmedForeignNational INT,
    Cured INT,
    Deaths INT,
    Confirmed INT
);

select * from covid_19_india

-- Step 2: Bulk insert data from CSV
BULK INSERT covid_19_india
FROM 'D:\BridgeLabz\MS_SQL\Covid_Problem\Covid_Problem\covid_19_india.csv'  -- Path to your CSV file
WITH (
    FIELDTERMINATOR = ',',   -- Field delimiter
    ROWTERMINATOR = '\n',    -- Row delimiter
    FIRSTROW = 2,            -- Skip header row
    TABLOCK                   -- Lock the table during bulk insert
);
 
  
select * from covid_19_india



-- Step 1: Create the table
CREATE TABLE StatewiseTestingDetails (
    Date DATE,
    State NVARCHAR(100),
    TotalSamples FLOAT,
    Negative INT,
    Positive FLOAT
);

select * from StatewiseTestingDetails


-- Step 2: Bulk insert data from CSV
BULK INSERT StatewiseTestingDetails
FROM 'D:\BridgeLabz\MS_SQL\Covid_Problem\Covid_Problem\StatewiseTestingDetails.csv'  
WITH (
    FIELDTERMINATOR = ',',   
    ROWTERMINATOR = '\n',    
    FIRSTROW = 2,           
    TABLOCK                  
);

 select * from StatewiseTestingDetails

 select * from covid_19_clean_complete

select * from covid_vaccine_statewise


 -----------------------------------   QUERIES   -------------------------------------------------


 -- Query 1: Total number of vaccine doses administered per day across all states
SELECT 
    Updated_On AS Date, 
    SUM(Total_Doses_Administered) AS Total_Doses_Admistered
FROM 
    covid_vaccine_statewise
GROUP BY 
    Updated_On
ORDER BY 
    Updated_On;


-- Query 2: States with the highest number of people vaccinated
SELECT 
    State, 
    SUM(Total_Individuals_Vaccinated) AS Total_Vaccinated
FROM 
    covid_vaccine_statewise
GROUP BY 
    State
ORDER BY 
    Total_Vaccinated DESC;


--Query 3 : States with the highest testing rates
SELECT 
    State, 
    SUM(TotalSamples) AS Total_Tests
FROM 
    StatewiseTestingDetails
GROUP BY 
    State
ORDER BY 
    Total_Tests DESC;


-- Query 4 : Percentage of positive cases per state
SELECT 
    State, 
    SUM(Positive) / SUM(TotalSamples) * 100 AS Positive_Percentage
FROM 
    StatewiseTestingDetails
GROUP BY 
    State
ORDER BY 
    Positive_Percentage DESC;


-- Query 5: Gender-wise distribution of vaccine doses administered
SELECT 
    State,
    SUM(Male_Doses_Administered) AS Total_Male_Doses,
    SUM(Female_Doses_Administered) AS Total_Female_Doses,
    SUM(Transgender_Doses_Administered) AS Total_Transgender_Doses
FROM 
    covid_vaccine_statewise
GROUP BY 
    State;


-- Query 6 : Top 5 states with the highest number of second doses administered
SELECT Top 5
    State, 
    SUM(Second_Dose_Administered) AS Total_Second_Dose
FROM 
    covid_vaccine_statewise
GROUP BY 
    State
ORDER BY 
    Total_Second_Dose DESC;


-- Query 7 : 
SELECT 
    State, 
    SUM(Covaxin_Doses_Administered) AS Covaxin_Doses,
    SUM(CoviShield_Doses_Administered) AS CoviShield_Doses,
    SUM(Sputnik_V_Doses_Administered) AS Sputnik_Doses
FROM 
    covid_vaccine_statewise
GROUP BY 
    State;


-- Query 8 : States with no reported positive cases
SELECT 
    State,
	SUM(Positive) AS Cases
FROM 
    StatewiseTestingDetails
GROUP BY 
    State
HAVING 
    SUM(Positive) = 0;


-- Query 9 : Infected Population Percentage Locally and Globally
SELECT 
    State,
    (SUM(Positive) / 1380004385.0) * 100 AS Infected_Percentage 
FROM 
    StatewiseTestingDetails
GROUP BY 
    State;


-- Query 10 : States with the Highest Infection Rates
SELECT 
    State,
    (SUM(Positive) / 1380004385.0) * 100 AS Infection_Rate 
FROM 
    StatewiseTestingDetails
GROUP BY 
    State
ORDER BY 
    Infection_Rate DESC;

--Query 11 : Countries with the highest infection rates
SELECT 
    State, 
    SUM(Positive) AS Total_Positive
FROM 
    StatewiseTestingDetails
GROUP BY 
    State
ORDER BY 
    Total_Positive DESC;


----------------------------Queries with Joins----------------------------
 
 --Query 1 : Population vs the number of people vaccinated

SELECT 
    a.State, 
    SUM(a.Total_Individuals_Vaccinated) AS Total_Vaccinated, 
    SUM(b.TotalSamples) AS Total_Tested
FROM 
    covid_vaccine_statewise a
JOIN 
    StatewiseTestingDetails b
ON 
    a.State = b.State
GROUP BY 
    a.State;


-- Query 2 : Percentage of different vaccines taken by people in a country

SELECT 
    State,
    (SUM(Covaxin_Doses_Administered) / SUM(Total_Doses_Administered)) * 100 AS Covaxin_Percentage,
    (SUM(CoviShield_Doses_Administered) / SUM(Total_Doses_Administered)) * 100 AS CoviShield_Percentage,
    (SUM(Sputnik_V_Doses_Administered) / SUM(Total_Doses_Administered)) * 100 AS Sputnik_V_Percentage
FROM 
    covid_vaccine_statewise
GROUP BY 
    State;


-- Query 3 : Percentage of people who took both doses.

SELECT 
    State, 
    (SUM(Second_Dose_Administered) / SUM(First_Dose_Administered)) * 100 AS Both_Doses_Percentage
FROM 
    covid_vaccine_statewise
GROUP BY 
    State;


-- Query 4 : Find total doses administered and positive cases per state using INNER JOIN

SELECT 
    c.State,
    c.Updated_On AS Date, 
    SUM(c.Total_Doses_Administered) AS Total_Doses_Administered,
    SUM(s.Positive) AS Total_Positive_Cases
FROM 
    covid_vaccine_statewise c
INNER JOIN 
    StatewiseTestingDetails s
ON 
    c.State = s.State AND c.Updated_On = s.Date
GROUP BY 
    c.State, c.Updated_On;


-- Query 5 : Show states that have administered vaccine doses but have no testing data using LEFT JOIN

SELECT 
    c.State,
    c.Updated_On AS Date,
    c.Total_Doses_Administered,
    s.TotalSamples
FROM 
    covid_vaccine_statewise c
LEFT JOIN 
    StatewiseTestingDetails s
ON 
    c.State = s.State AND c.Updated_On = s.Date
WHERE 
    s.State IS NULL;


-- Query 6 : Show states with vaccine data but no confirmed COVID-19 cases using LEFT JOIN

SELECT 
    v.State,
    v.Updated_On AS Date,
    v.Total_Doses_Administered,
    co.Confirmed AS Total_Confirmed_Cases
FROM 
    covid_vaccine_statewise v
LEFT JOIN 
    covid_19_clean_complete co 
ON 
   v.Updated_On = co.Date
WHERE 
    co.Confirmed IS NULL;





