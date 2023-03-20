select * from CovidDeaths 
where continent is not null
order by 3,4
-- select data that we are  going to use
select location,date total_cases,new_cases,total_deaths,population 
from coviddeaths 
where continent is not null
order by 1,2

--Looking at Total cases Vs Total deaths in Percentage
select location,date, total_cases,total_deaths,(total_deaths/total_cases)*100 as Death_Percentage
from coviddeaths 
where location ='India'
and continent is not null
order by 1,2

--Loking at Total Cases Vs Population
select location,date, total_cases,population,(total_deaths/population)*100 as Percentage_Population
from coviddeaths 
where location ='India' 
and continent is not null
order by 1,2

--Looking at countries with highest Infection Rate Compared to population
select location,population, max(total_cases) as Highest_Infection_Count,max((total_cases/population))*100 as Percentage_Population_Infected
from coviddeaths  
where continent is not null
group by location,population
order by Percentage_Population_Infected desc

--Showing contries with highest death count per population
select location,MAX(cast(total_deaths as int)) as Death_Count
from coviddeaths  
group by location
order by Death_Count desc

--Lets break things By continent
select continent,MAX(cast(total_deaths as int)) as Death_Count
from coviddeaths 
where continent is not null
group by continent
order by Death_Count desc


--Showing Continent with Highest Death count per population
select continent,MAX(cast(total_deaths as int)) as Death_Count,(total_deaths/population)*100 as DeathPercentage
from coviddeaths 
where continent is not null
group by continent
order by Death_Count desc 


--Global Numbers
select SUM(new_cases) as TotalCases,sum(cast(new_deaths as int))as TotalDeaths,sum(cast(new_deaths as int))/SUM(new_cases)*100 as Death_Percentage
from coviddeaths 
--where location ='India'
where  continent is not null
--group by date
order by 1,2


--Looking at Total Population Vs Vaccination
Select CD.continent,CD.location,CD.date,CD.population,CV.new_vaccinations
,sum(convert (int,CV.new_vaccinations)) over (partition by CD.location order by CD.location,CD.date) as RollingPeopleVaccinated
--,(RollinfPopleVaccinated/population)*100
from CovidDeaths CD
join CovidVaccinations CV
on CD.location=CV.location
and CD.date=CV.date where CD.continent is not null
order by 2,3

 
--Use CTE

with PopVsVac (continent,location,date,population,new_vaccinations,RollingPeopleVaccinated)
as
(
Select CD.continent,CD.location,CD.date,CD.population,CV.new_vaccinations
,sum(convert (int,CV.new_vaccinations)) over (partition by CD.location order by CD.location,CD.date) as RollingPeopleVaccinated
--,(RollingfPopleVaccinated/population)*100
from CovidDeaths CD
join CovidVaccinations CV
on CD.location=CV.location
and CD.date=CV.date 
where CD.continent is not null
--order by 2,3
)
select  *,(RollingPeopleVaccinated/population)*100 from PopVsVac

--Temp Table


Drop table if exists #PercentPopulationVaccinated
Create table #PercentPopulationVaccinate
(
Continent varchar(255),
location varchar(255),
date datetime,
population numeric, 
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinate
Select CD.continent,CD.location,CD.date,CD.population,CV.new_vaccinations
,sum(convert (int,CV.new_vaccinations)) over (partition by CD.location order by CD.location,CD.date) as RollingPeopleVaccinated
--,(RollingfPopleVaccinated/population)*100
from CovidDeaths CD
join CovidVaccinations CV
on CD.location=CV.location
and CD.date=CV.date 
--where CD.continent is not null
--order by 2,3

select  *,(RollingPeopleVaccinated/population)*100 from #PercentPopulationVaccinate

--Creating view for store data for Later visualisation

Create view PercentPopulationVaccinate
 as 
Select CD.continent,CD.location,CD.date,CD.population,CV.new_vaccinations
,sum(convert (int,CV.new_vaccinations)) over (partition by CD.location order by CD.location,CD.date) as RollingPeopleVaccinated
--,(RollingfPopleVaccinated/population)*100
from CovidDeaths CD
join CovidVaccinations CV
on CD.location=CV.location
and CD.date=CV.date 
where CD.continent is not null
--order by 2,3

	select * from PercentPopulationVaccinate