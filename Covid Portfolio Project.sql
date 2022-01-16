Select *
From PortfolioProject.dbo.CovidDeaths$
WHERE continent is not null
Order By 3,4

--Select *
--FROM PortfolioProject.dbo.CovidVaccinations$ AS CVaccinations
--Order by 3,4

-- Select Data that we are going to be using

Select location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject.dbo.CovidDeaths$
WHERE continent is not null
Order by location, date

--Looking at total cases vs total deaths
--Shows likelihood of dying if you contract covid in your country
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM PortfolioProject.dbo.CovidDeaths$
Where location like '%states%'
AND continent is not null
Order by location, date DESC

--Looking at total cases vs population
--Shows what percentage of population got covid
Select location, date, total_cases, population, (total_cases/population)*100 AS PercentPopulationInfected
FROM PortfolioProject.dbo.CovidDeaths$
Where location like '%states%'
AND continent is not null
Order by location, date DESC

--Looking at countries with highest infection rate compared to population
Select location, MAX(total_cases) as HighestInfectionCount, population, (Max(total_cases)/population)*100 AS PercentPopulationInfected
FROM PortfolioProject.dbo.CovidDeaths$
WHERE continent is not null
Group by location, population
Order by PercentPopulationInfected desc

-- Showing Countries with Highest Death Count per Population
Select location, MAX(cast(total_deaths as bigint)) as TotalDeathCount
FROM PortfolioProject.dbo.CovidDeaths$
WHERE continent is not null
Group by location
Order by TotalDeathCount desc

--Let's break things down by continent
--Showing continents with highest death count per population
Select continent, MAX(cast(total_deaths as bigint)) as TotalDeathCount
FROM PortfolioProject.dbo.CovidDeaths$
WHERE continent is not null
Group by continent
Order by TotalDeathCount desc


--Correct way below
--Select location, MAX(cast(total_deaths as bigint)) as TotalDeathCount
--FROM PortfolioProject.dbo.CovidDeaths$
--WHERE continent is null
--Group by location
--Order by TotalDeathCount desc

--Global Numbers

Select SUM(new_cases) as TotalCases, SUM(cast(new_deaths as bigint)) as TotalDeaths, SUM(cast(new_deaths as bigint))/SUM(new_cases)*100 as DeathPercentage
FROM PortfolioProject.dbo.CovidDeaths$
WHERE continent is not null
--Group by date
Order by 1

--Looking at Total Population vs Vaccinations

--USE CTE
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

--TEMP Table
-- add section below if editing below section
--DROP Table if exists #PercentPopulationVaccinated
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
WHERE dea.continent is not null
--order by 2, 3

Select *, (RollingPeopleVaccinated/population)*100
FROM #PercentPopulationVaccinated

--Creating View to store data for later vizualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--order by 2, 3