--exploring covid data for kenya showing new cases and total deaths compared to the population density.

SELECT location,date,new_cases,total_deaths,population_density
FROM dbo.coviddatadeaths
where location like 'kenya'

--looking at total cases versus total deaths, this shows likelihood of dying if infected

SELECT location,date,total_cases,total_deaths,(cast(total_deaths as int) /total_cases)*100 as percentagedeath
FROM dbo.coviddatadeaths
where location like 'kenya'

--total global total deaths vs total cases


SELECT location,date,total_cases,total_deaths,population_density
FROM dbo.coviddatadeaths
order by 1,2


--looking at total cases vs population in kenya.

SELECT location,date,total_cases,total_deaths,(total_cases/CAST(total_deaths AS INT)) as percentagedeath
FROM dbo.coviddatadeaths
where location like 'kenya'


--maximum cases reported in kenya

SELECT location,max(cast(total_cases as int))as highest_total_cases,max(new_cases)as highest_new_cases
FROM portfolioproject.dbo.coviddatadeaths
where location like 'kenya'
group  by location,population_density


SELECT*
FROM coviddatadeaths
where location like 'kenya'



SELECT location, date, population_density, total_cases,new_cases, total_deaths 
FROM coviddatadeaths
where location like 'kenya'

--percentage change in new cases in kenya

SELECT location, date, population_density,new_cases, total_cases, ( new_cases/total_cases)*100 as percentage_change 
FROM coviddatadeaths
where location like 'kenya'

--showing countries with highest death count per population


select location, max(total_deaths)as totaldeathcount
from coviddatadeaths
group by location
order by totaldeathcount desc

--covid data vaccination table

select*
from coviddatavaccination

--global vaccination data 

select location, date,new_cases,total_cases,new_vaccinations, total_vaccinations
from coviddatavaccination


--kenya vaccination

select continent,location, date,new_cases,total_cases,new_vaccinations, total_vaccinations
from coviddatavaccination
where location like 'Africa'
order by 1,2

--vaccination versus population in africa


select continent,location, date,population_density, new_cases,total_cases,new_vaccinations, total_vaccinations
from coviddatavaccination
where location like 'Africa'


--looking for total population vs new vaccination



select dea.continent, dea.population_density,dea.location,dea.date,vac.new_vaccinations
from coviddatadeaths dea
join coviddatavaccination vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
order by 1,2,3

--Rolling count

select dea.continent, dea.population_density,dea.location,dea.date,vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over( partition by dea.location Order by dea.location, dea.date)as Rollingpeoplevaccinated
from coviddatadeaths dea
join coviddatavaccination vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
order by 2,3

---we create a CTE in order to find the ralationship between the poulation and total vaccination

with PopvsVac (continent, population_density, location, date,Rollingpeoplevaccinated, new_vaccinations)
as
(
select dea.continent, dea.population_density,dea.location,dea.date,vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over( partition by dea.location Order by dea.location, dea.date)as Rollingpeoplevaccinated
from coviddatadeaths dea
join coviddatavaccination vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3
)
select*,(Rollingpeoplevaccinated/population_density)*100
from PopvsVac

--Temp Table
Drop Table if exists #percentpopulationvaccinated
create Table #percentpopulationvaccinated
(
continent nvarchar(255),
population_density numeric,
location nvarchar(255),
date datetime,
new_vaccinations numeric,
Rollingpeoplevaccinated numeric
)
insert into #percentpopulationvaccinated
select dea.continent, dea.population_density,dea.location,dea.date,vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over( partition by dea.location Order by dea.location, dea.date)as Rollingpeoplevaccinated
from coviddatadeaths dea
join coviddatavaccination vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3

select*,(Rollingpeoplevaccinated/population_density)*100
from #percentpopulationvaccinated


--Creating a View to store Data for later visualization.

create view percentpopulationvaccinated as
select dea.continent, dea.population_density,dea.location,dea.date,vac.new_vaccinations,
sum(convert(int,vac.new_vaccinations)) over( partition by dea.location Order by dea.location, dea.date)as Rollingpeoplevaccinated
from coviddatadeaths dea
join coviddatavaccination vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3

select*
from percentpopulationvaccinated
