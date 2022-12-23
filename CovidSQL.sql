select *
from CovidPortfolio..CovidDeath
where continent is not null
order by 3,4

--select *
--from CovidPortfolio..CovidVaccination
--order by 3,4





-- Select Data that we are going to be starting with

Select Location, date, total_cases, new_cases, total_deaths, population
From CovidPortfolio..CovidDeath
Where continent is not null 
order by 1,2




-- Total Cases vs Total Deaths

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From CovidPortfolio..CovidDeath
--where location like '%India%'
Where continent is not null 
order by 1,2




-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

Select Location, date, total_cases,Population,(total_cases/population)*100 as PercentPopulationInfected
From CovidPortfolio..CovidDeath
--Where location like '%India%'
Where continent is not null 
order by 1,2





-- Countries with Highest Infection Rate compared to Population

Select Location, Population, MAX(total_cases) as HighestInfectionCount,Max((total_cases/population))*100 as PercentPopulationInfected
From CovidPortfolio..CovidDeath
--Where location like '%India%'
Where continent is not null 
Group by Location, Population
order by 4 desc




-- Countries with Highest Death Count per Population

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
-- casting Total_deaths from varchar255 to int
From CovidPortfolio..CovidDeath
--Where location like '%India%'
Where continent is not null 
Group by Location
order by 2 desc




-- Showing contintents with the highest death count per population

Select continent, Max(cast(Total_deaths as int)) as TotalDeathCount
From CovidPortfolio..CovidDeath
--Where location like '%India%'
Where continent is not null 
Group by continent
order by 2 desc




--Overall record for total_cases, total_deaths, Death_percentage

Select SUM(new_cases) as Total_cases, SUM(cast(new_deaths as int)) as Total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
-- in above query we cast the data type from varchar to int
From CovidPortfolio..CovidDeath
--Where location like '%India%'
Where continent is not null 
--Group By date
order by 1,2




-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as numeric)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingTotalVaccinated
From CovidPortfolio..CovidDeath dea
join CovidPortfolio..CovidVaccination vac
	on dea.location=vac.location 
	and dea.date=vac.date
where dea.continent is not null
order by 2,3




--using CTE to perform calculation on partition by in previous query

With PopulationVaccinate (continent,location,date,population,new_vaccinations,RollingTotalVaccinated)
as
(Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as numeric)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingTotalVaccinated
From CovidPortfolio..CovidDeath dea
join CovidPortfolio..CovidVaccination vac
	on dea.location=vac.location 
	and dea.date=vac.date
where dea.continent is not null
--and dea.location='India'
--order by 2,3
)
select *,(RollingTotalVaccinated/Population)*100 as RollingPercentage
from PopulationVaccinate



-- Creating View to store data

Create view  FirstView as 
-- Total Cases vs Total Deaths
Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From CovidPortfolio..CovidDeath
--where location like '%India%'
Where continent is not null 
--order by 1,2