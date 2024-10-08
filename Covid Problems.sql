use Covid;

CREATE TABLE covid_19_data (
    Province_State VARCHAR(100),
    Country_Region VARCHAR(100),
    Lat FLOAT,
    Long FLOAT,
    Date DATE,
    Confirmed INT,
    Deaths INT,
    Recovered INT,
    Active INT,
    WHO_Region VARCHAR(100)
);


BULK INSERT covid_19_data
FROM 'D:\BridgeLabz\MS_SQL\Covid_Problem\Covid_Problem\covid_19_clean_complete.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);



CREATE TABLE worldometer_data (
    Country_Region VARCHAR(100),
    Continent VARCHAR(50),
    Population INT,
    TotalCases INT,
    NewCases INT,
    TotalDeaths INT,
    NewDeaths INT,
    TotalRecovered INT,
    NewRecovered INT, 
    ActiveCases INT,
    Serious_Critical INT,
    CasesPerMillion FLOAT,
    DeathsPerMillion FLOAT,
    TotalTests INT,
    TestsPerMillion FLOAT,
    WHO_Region VARCHAR(100)
);


BULK INSERT worldometer_data
FROM 'D:\BridgeLabz\MS_SQL\Covid_Problem\Covid_Problem\worldometer_data.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);


CREATE TABLE covid_vaccine_statewise (
    UpdatedOn DATE,
    State NVARCHAR(100),
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
    Age18_44DosesAdministered FLOAT,
    Age45_60DosesAdministered FLOAT,
    Age60PlusDosesAdministered FLOAT,
    Age18_44IndividualsVaccinated FLOAT,
    Age45_60IndividualsVaccinated FLOAT,
    Age60PlusIndividualsVaccinated FLOAT,
    MaleIndividualsVaccinated FLOAT,
    FemaleIndividualsVaccinated FLOAT,
    TransgenderIndividualsVaccinated FLOAT,
    TotalIndividualsVaccinated FLOAT
);


BULK INSERT covid_vaccine_statewise
FROM 'D:\BridgeLabz\MS_SQL\Covid_Problem\Covid_Problem\covid_vaccine_statewise.csv'
WITH (
    FIELDTERMINATOR = ',',  
    ROWTERMINATOR = '\n',  
    FIRSTROW = 2,           
    TABLOCK
);


------------------------------- Queries -------------------------------


--Query 1 : To find out the death percentage locally and globally

------------ Local death percentage
SELECT 
    Country_Region,
    SUM(Deaths) * 100.0 / SUM(Confirmed) AS DeathPercentage
FROM 
    covid_19_data
WHERE 
    Confirmed > 0
GROUP BY 
    Country_Region
ORDER BY 
    DeathPercentage DESC;


------------ Global death percentage
SELECT 
    SUM(Deaths) * 100.0 / SUM(Confirmed) AS GlobalDeathPercentage
FROM 
    covid_19_data
WHERE 
    Confirmed > 0;



--Query 2 : To find out the infected population percentage locally and globally

------------Local Infected percentage
SELECT 
    c.Country_Region,
    SUM(c.Confirmed) * 100.0 / wd.Population AS InfectedPercentage
FROM 
    covid_19_data c
JOIN 
    worldometer_data wd ON c.Country_Region = wd.Country_Region
WHERE 
    Confirmed > 0
GROUP BY 
    c.Country_Region, wd.Population
ORDER BY 
    InfectedPercentage DESC;


------------ Global infected percentage
SELECT 
	(CAST(SUM(CAST(wd.TotalCases AS BIGINT)) AS DECIMAL(38, 2)) / CAST(SUM(CAST(wd.Population AS BIGINT)) 
	AS DECIMAL(38, 2))) * 100
	AS Global_Infected_Population_Percentage
FROM worldometer_data wd;



--Query 3 : To find out the countries with the highest infection rates.

SELECT
    Country_Region,
    SUM(Confirmed) AS TotalInfectionRate
FROM 
    covid_19_data
GROUP BY 
    Country_Region
ORDER BY 
    TotalInfectionRate DESC;


--Query 4 : To find out the countries and continents with the highest death counts.

------------ For Countries

SELECT 
    Country_Region,
    SUM(Deaths) AS TotalDeaths
FROM 
    covid_19_data
GROUP BY 
    Country_Region
ORDER BY 
    TotalDeaths DESC;

------------ For Continents

SELECT 
    WHO_Region,
    SUM(Deaths) AS TotalDeaths
FROM 
    covid_19_data
GROUP BY 
    WHO_Region
ORDER BY 
    TotalDeaths DESC;


--Query 5 : Average number of deaths by day (Continents and Countries).

------------ For Countries

SELECT 
    Country_Region,
    AVG(Deaths) AS AvgDeaths
FROM 
    covid_19_data
GROUP BY 
    Country_Region
ORDER BY 
    AvgDeaths DESC;

------------ For Continents

SELECT 
    WHO_Region,
    AVG(Deaths) AS AvgDeaths
FROM 
    covid_19_data
GROUP BY 
    WHO_Region
ORDER BY 
    AvgDeaths DESC;


-- Query 6 : Average of cases divided by the number of population of each country (TOP 10).

SELECT TOP 10
    c.Country_Region,
    AVG(c.Confirmed) * 1.0 / wd.Population AS AvgCasesPerPopulation
FROM 
    covid_19_data c
JOIN 
    worldometer_data wd ON c.Country_Region = wd.Country_Region
GROUP BY 
    c.Country_Region, wd.Population
ORDER BY 
    AvgCasesPerPopulation DESC;


--Query 7 : Considering the highest value of total cases, which countries have the highest rate of infection in relation to population?

SELECT 
    c.Country_Region,
    SUM(c.Confirmed) * 1.0 / wd.Population AS InfectionRate
FROM 
    covid_19_data c
JOIN 
    worldometer_data wd ON c.Country_Region = wd.Country_Region
GROUP BY 
    c.Country_Region, wd.Population
ORDER BY 
    InfectionRate DESC;



------------------------------- Joins -------------------------------

--Query 1 : To find out the population vs the number of people vaccinated.
SELECT 
    w.Country_Region,
    w.Population,
    c.Total_Individuals_Vaccinated,
    (CAST(c.Total_Individuals_Vaccinated AS FLOAT) / w.Population) * 100 AS VaccinationPercentage
FROM 
    worldometer_data w
JOIN 
    covid_vaccine_statewise c
ON 
    w.Country_Region = c.State
WHERE 
    c.Total_Individuals_Vaccinated IS NOT NULL;



--Query 2 : To find out the percentage of different vaccine taken by people in a country
SELECT 
    c.State,
    c.Covaxin_Doses_Administered,
    c.CoviShield_Doses_Administered,
    c.Sputnik_V_Doses_Administered,
    c.Total_Doses_Administered,
    (c.Covaxin_Doses_Administered / c.Total_Doses_Administered) * 100 AS CovaxinPercentage,
    (c.CoviShield_Doses_Administered / c.Total_Doses_Administered) * 100 AS CoviShieldPercentage,
    (c.Sputnik_V_Doses_Administered / c.Total_Doses_Administered) * 100 AS SputnikVPercentage
FROM 
    covid_vaccine_statewise c
WHERE 
    c.Total_Doses_Administered > 0;



--Query 3 : To find out percentage of people who took both the doses
SELECT 
    c.State,
    c.Total_Individuals_Vaccinated,
    c.Second_Dose_Administered,
    (c.Second_Dose_Administered / c.Total_Individuals_Vaccinated) * 100 AS SecondDosePercentage
FROM 
    covid_vaccine_statewise c
WHERE 
    c.Total_Individuals_Vaccinated > 0;


