/*

Queries used for Tableau Project

*/

-- 1. 

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..coviddatadeaths
where continent is not null 
order by 1,2



-- 2. 
-- we include European Union as part of Europe

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From PortfolioProject..coviddatadeaths
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc


-- 3.

Select Location, population_density, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population_density))*100 as PercentPopulationInfected
From PortfolioProject..coviddatadeaths
Group by Location, population_density
order by PercentPopulationInfected desc


-- 4.


Select Location, Population_density,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population_density))*100 as PercentPopulationInfected
From PortfolioProject..coviddatadeaths
Group by Location, Population_density, date
order by PercentPopulationInfected desc

--more queries


-- 1.

Select dea.continent, dea.location, dea.date, dea.population_density
, MAX(vac.total_vaccinations) as RollingPeopleVaccinated
From PortfolioProject..coviddatadeaths dea
Join PortfolioProject..coviddatavaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
group by dea.continent, dea.location, dea.date, dea.population_density
order by 1,2,3




-- 2.
--death percentage for kenya

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..coviddatadeaths
Where location like '%kenya%'
order by 1,2


-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From PortfolioProject..coviddatadeaths
--Where location like '%kenya%
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc



-- 4.highest infection for kenya on percentagepopulationinfected

Select Location, Population_density, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population_density))*100 as PercentPopulationInfected
From PortfolioProject..coviddatadeaths
Where location like '%kenya%'
Group by Location, population_density
order by PercentPopulationInfected desc



-- 5.


-- took the above query and added population_density

Select Location, date, population_density, total_cases, total_deaths
From PortfolioProject..coviddatadeaths
Where location like '%kenya%' 
order by 1,2


-- 6. 


With PopvsVac (Continent, Location, Date, Population_density, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population_density, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..coviddatadeaths dea
Join PortfolioProject..coviddatavaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population_density)*100 as PercentPeopleVaccinated
From PopvsVac


-- 7. 

Select Location, Population_density,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population_density))*100 as PercentPopulationInfected
From PortfolioProject..coviddatadeaths
Where location like '%kenya%'
Group by Location, population_density, date
order by PercentPopulationInfected desc




