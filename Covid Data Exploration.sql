/*
Covid Data Exploration

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types, Updating Tables

*/

-- Updating Tables to remove nulls and replace with zero in value fields
UPDATE PortfolioProject.dbo.CovidDeaths$
SET total_cases=0
WHERE total_cases IS NULL;

UPDATE PortfolioProject..CovidVaccinations$
SET tests_units=0
WHERE tests_units is null;


--Updating multiple tables and multiple columns to replace nulls with zero.
--Converting data types to work when replacing

UPDATE PortfolioProject.dbo.CovidDeaths$
SET
	new_deaths = COALESCE(CONVERT(float, new_deaths), 0),
	new_deaths_smoothed = COALESCE(CONVERT(float, new_deaths_smoothed), 0),
	total_cases_per_million = COALESCE(total_cases_per_million, 0),
	new_cases_per_million = COALESCE(new_cases_per_million, 0),
	new_cases_smoothed_per_million = COALESCE(new_cases_smoothed_per_million, 0),
	total_deaths_per_million = COALESCE(CONVERT(float, total_deaths_per_million), 0),
	new_deaths_per_million = COALESCE(CONVERT(float, new_deaths_per_million), 0),
	new_deaths_smoothed_per_million = COALESCE(CONVERT(float, new_deaths_smoothed_per_million), 0),
	reproduction_rate = COALESCE(CONVERT(float, reproduction_rate), 0),
	icu_patients = COALESCE(CONVERT(float, icu_patients), 0),
	icu_patients_per_million = COALESCE(CONVERT(float, icu_patients_per_million), 0),
	hosp_patients = COALESCE(CONVERT(float, hosp_patients), 0),
	hosp_patients_per_million = COALESCE(CONVERT(float, hosp_patients_per_million), 0),
	weekly_icu_admissions = COALESCE(CONVERT(float, weekly_icu_admissions), 0),
	weekly_icu_admissions_per_million = COALESCE(CONVERT(float, weekly_icu_admissions_per_million), 0),
	weekly_hosp_admissions = COALESCE(CONVERT(float, weekly_hosp_admissions), 0),
	weekly_hosp_admissions_per_million = COALESCE(CONVERT(float, weekly_hosp_admissions_per_million), 0)

UPDATE PortfolioProject..CovidVaccinations$
SET 
	new_tests = COALESCE(CONVERT(float, new_tests), 0),
	total_tests = COALESCE(CONVERT(float, total_tests), 0),
	total_tests_per_thousand = COALESCE(CONVERT(float, total_tests_per_thousand), 0),
	new_tests_per_thousand = COALESCE(CONVERT(float, new_tests_per_thousand), 0),
	new_tests_smoothed = COALESCE(CONVERT(float, new_tests_smoothed), 0),
	new_tests_smoothed_per_thousand = COALESCE(CONVERT(float, new_tests_smoothed_per_thousand), 0),
	positive_rate = COALESCE(CONVERT(float, positive_rate), 0),
	tests_per_case = COALESCE(CONVERT(float, tests_per_case), 0),
	total_vaccinations = COALESCE(CONVERT(float, total_vaccinations), 0),
	people_vaccinated = COALESCE(CONVERT(float, people_vaccinated), 0),
	people_fully_vaccinated = COALESCE(CONVERT(float, people_fully_vaccinated), 0),
	total_boosters = COALESCE(CONVERT(float, total_boosters), 0),
	new_vaccinations = COALESCE(CONVERT(float, new_vaccinations), 0),
	new_vaccinations_smoothed = COALESCE(CONVERT(float, new_vaccinations_smoothed), 0),
	total_vaccinations_per_hundred = COALESCE(CONVERT(float, total_vaccinations_per_hundred), 0),
	people_vaccinated_per_hundred = COALESCE(CONVERT(float, people_vaccinated_per_hundred), 0),
	people_fully_vaccinated_per_hundred = COALESCE(CONVERT(float, people_fully_vaccinated_per_hundred), 0),
	total_boosters_per_hundred = COALESCE(CONVERT(float, total_boosters_per_hundred), 0),
	new_vaccinations_smoothed_per_million = COALESCE(CONVERT(float, new_vaccinations_smoothed_per_million), 0),
	new_people_vaccinated_smoothed = COALESCE(CONVERT(float, new_people_vaccinated_smoothed), 0),
	new_people_vaccinated_smoothed_per_hundred = COALESCE(CONVERT(float, new_people_vaccinated_smoothed_per_hundred), 0),
	stringency_index = COALESCE(stringency_index, 0),
	population_density = COALESCE(population_density, 0),
	median_age = COALESCE(median_age, 0),
	aged_65_older = COALESCE(aged_65_older, 0),
	aged_70_older = COALESCE(aged_70_older, 0),
	gdp_per_capita = COALESCE(gdp_per_capita, 0),
	extreme_poverty = COALESCE(CONVERT(float, extreme_poverty), 0),
	cardiovasc_death_rate = COALESCE(cardiovasc_death_rate, 0),
	diabetes_prevalence = COALESCE(diabetes_prevalence, 0),
	female_smokers = COALESCE(CONVERT(float, female_smokers), 0),
	male_smokers = COALESCE(CONVERT(float, male_smokers), 0),
	handwashing_facilities = COALESCE(handwashing_facilities, 0),
	hospital_beds_per_thousand = COALESCE(hospital_beds_per_thousand, 0),
	life_expectancy = COALESCE(life_expectancy, 0),
	human_development_index = COALESCE(human_development_index, 0),
	excess_mortality_cumulative_absolute = COALESCE(CONVERT(float, excess_mortality_cumulative_absolute), 0),
	excess_mortality_cumulative = COALESCE(CONVERT(float, excess_mortality_cumulative), 0),
	excess_mortality = COALESCE(CONVERT(float, excess_mortality), 0),
	excess_mortality_cumulative_per_million = COALESCE(CONVERT(float, excess_mortality_cumulative_per_million), 0)

SELECT new_tests
FROM PortfolioProject..CovidVaccinations$
WHERE new_tests is null
	

Select *
From PortfolioProject.dbo.CovidDeaths$
WHERE continent is not null
Order By 3,4


-- Select Data that we are going to be starting with

Select location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject.dbo.CovidDeaths$
WHERE continent is not null
Order by 1, 2

-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM PortfolioProject.dbo.CovidDeaths$
Where location like '%states%'
AND continent is not null
Order by 1, 2

-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

Select location, date, total_cases, population, (total_cases/population)*100 AS PercentPopulationInfected
FROM PortfolioProject.dbo.CovidDeaths$
--Where location like '%states%'
AND continent is not null
Order by 1, 2

--	Countries with Highest Infection Rate compared to Population

Select location, population, MAX(total_cases) as HighestInfectionCount, (Max(total_cases)/population)*100 AS PercentPopulationInfected
FROM PortfolioProject.dbo.CovidDeaths$
WHERE continent is not null
Group by location, population
Order by PercentPopulationInfected desc


-- Countries with Highest Death Count per Population

Select location, MAX(cast(total_deaths as bigint)) as TotalDeathCount
FROM PortfolioProject.dbo.CovidDeaths$
WHERE continent is not null
Group by location
Order by TotalDeathCount desc


-- BREAKING THINGS DOWN BY CONTINENT

-- Showing continents with highest death count per population

Select continent, MAX(cast(total_deaths as bigint)) as TotalDeathCount
FROM PortfolioProject.dbo.CovidDeaths$
WHERE continent is not null
Group by continent
Order by TotalDeathCount desc


-- GLOBAL NUMBERS

Select SUM(new_cases) as TotalCases, SUM(cast(new_deaths as bigint)) as TotalDeaths, SUM(cast(new_deaths as bigint))/SUM(new_cases)*100 as DeathPercentage
FROM PortfolioProject.dbo.CovidDeaths$
WHERE continent is not null
--Group by date
Order by 1, 2


-- Total Population vs Vaccinations
-- Shows Percentage of Popultion that has received at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
order by 2, 3


-- Using CTE to perform Calculation on Partition B in previous query

With PopvsVac(continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--order by 2, 3
)
Select *, (RollingPeopleVaccinated/population)*100
FROM PopvsVac



--Using Temp Table to perform Calculations on Partition By in previous query

Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)


Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
--WHERE dea.continent is not null
--order by 2, 3

Select *, (RollingPeopleVaccinated/population)*100
FROM #PercentPopulationVaccinated

-- Creating View to store data for later vizualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
