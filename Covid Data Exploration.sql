/*
Covid Data Exploration

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/

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
