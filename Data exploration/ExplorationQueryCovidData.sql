SELECT*
FROM CoviData
ORDER BY location, date

-- "We need to work with two different tables: CovidDeaths and CovidVaccinations.
-- 
-- We have two options to create these two tables:
-- 
-- Option 1:
-- We run the following Python scripts in the same folder:
-- 
-- CSV_Export_CovidDeaths.py

-- Using the following query:

-- SELECT iso_code, continent, location, date, population, total_cases, new_cases, total_deaths, new_deaths
-- FROM CoviData
-- ORDER BY location, date


-- CSV_Export_CovidVaccinations.py

-- Using the following query:

-- SELECT iso_code, continent, location, date, population, total_cases, new_cases, total_deaths, new_deaths, new_vaccinations
-- FROM CoviData
-- ORDER BY location, date
-- These will create two different CSV files with the following names:
-- 
-- CovidDeaths.csv
-- CovidVaccinations.csv"


-- Option 2:
-----Creating different tables using VIEW

 
--Covid Deaths View Table 
CREATE VIEW CovidDeaths as
SELECT iso_code, continent, location, date, population, total_cases, new_cases, total_deaths, new_deaths 
FROM CoviData
ORDER BY location, date

-- If you need to delete the view CovidDeaths, here is the code DROP
DROP VIEW CovidDeaths

-- Covid Vaccinations views Table
CREATE VIEW CovidVaccinations as
SELECT iso_code, continent, location, date, population, total_cases, new_cases, total_deaths, new_deaths, new_vaccinations 
FROM CoviData 
ORDER BY location, date

-- If you need to delete the view CovidVaccinations, here is the code DROP
DROP VIEW CovidVaccinations



-- We are going to use the CSV geenrated by the Python programs


--Selecting the data that we are going to use

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths 
ORDER BY location, date

-- Looking total Cases vs Total Deaths
-- Show likelihood of dying if you contract covid in your country 
SELECT location, date, total_cases, total_deaths, population, (total_deaths/total_cases)*100 as DeathPercentage
FROM CovidDeaths 
ORDER BY location, date

-- Looking total Cases vs Total Deaths in my country Venezuela
-- Show likelihood of dying if you contract covid in Venezuela
SELECT location, date, total_cases, total_deaths, population, (total_deaths/total_cases)*100 as DeathPercentage
FROM CovidDeaths
WHERE location like 'Venezuela' 
ORDER BY date

--Looking at Total Cases vs Population (VENEZUELA)
--Show what percentage of Venezuela got covid 
SELECT location, date, total_cases, population, (total_cases/population)*100 as DeathPercentageVEN
FROM CovidDeaths
WHERE location like 'Venezuela' 
ORDER BY date

--Showing countries with highest death count per population


-- Looking at countries with highest infection rate
--important note: many of the data has to be cast as INT
SELECT location, population, MAX((CAST(total_cases as INT)))as highestInfectionCount, max((total_cases/population))*100 as PercentagePopulationInfected
FROM CovidDeaths
GROUP by location, population
ORDER by PercentagePopulationInfected desc 


--Showing countries with highest death count per population

SELECT location, max(CAST(total_deaths as INT)) as TotalDeathCount
FROM CovidDeaths
-- due to incosistence of thee data, we need to put the following line:
WHERE continent is not null
GROUP by location
ORDER by TotalDeathCount desc 

--grouping the data by continent

SELECT continent, max(CAST(total_deaths as INT)) as TotalDeathCount
FROM CovidDeaths
WHERE continent is not null
GROUP by continent
ORDER by TotalDeathCount desc 


----- Showing continents with highest death count per population 

SELECT continent, max(CAST(total_deaths as INT)) as TotalDeathCount
FROM CovidDeaths
WHERE continent is not null
GROUP by continent
ORDER by TotalDeathCount desc 


--Global numbers by date 

SELECT sum( new_cases ) as GlobalNewCases, sum( new_deaths ) as GlobalNewDeaths, sum( new_deaths )/sum( new_cases )*100 as DeathPercentage
FROM CovidDeaths
WHERE continent is not null
GROUP by date
ORDER by 1,2



--Global numbers

SELECT sum( new_cases ) as GlobalNewCases, sum( new_deaths ) as GlobalNewDeaths, sum( new_deaths )/sum( new_cases )*100 as DeathPercentage
FROM CovidDeaths
WHERE continent is not null
ORDER by 1,2


-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date)
From CovidDeaths dea
Join CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3


