-- Cases and Death Rate Current 
select cd.location, sum(cd.new_cases) Cases, max(cd.total_deaths) Deaths, (max(cd.total_deaths) / sum(cd.new_cases))*100 as DeathRate
from CovidDeaths cd
group by cd.location
having cd.location = 'Afghanistan'
order by cd.location


-- Cases and Death Rate Trend
select d.location, d.date, d.total_cases, d.total_deaths, (d.total_deaths/d.total_cases)*100 as DeathRate
from CovidDeaths d
where d.location = 'Afghanistan'
order by d.location, d.date

-- Total cases vs population  pct of population got covid
select d.location, d.date, d.total_cases, d.population, (d.total_cases/d.population)*100 as CaseRate
from CovidDeaths d
where d.location = 'Afghanistan'
order by d.location, d.date

-- Highest infection rate compared to population
select cd.location,  avg(cd.population) Population,
sum(cd.total_cases) Cases,
sum(cd.total_deaths) Deaths,
(sum(cd.new_cases) / avg(cd.population))*100 as InfectionRate,
(sum(cd.new_deaths) / avg(cd.population))*100 as DeathRate
from CovidDeaths cd
where cd.continent is not null
group by cd.location
--having cd.location = 'United States'
order by DeathRate desc

-- deaths grouped by contenent location
select continent, location, max(total_deaths) as td
from CovidDeaths
where continent is not null
group by continent, location
order by continent, td desc

-- deaths grouped by contenent 
select continent, location, max(total_deaths) as td
from CovidDeaths
where continent is null
group by continent, location
order by continent, td desc

-- Global deaths
	select sum(new_deaths) DeathCount
	from CovidDeaths
	where continent is not null

	select SUM(new_deaths) DeathCount
	from CovidDeaths
	where location = 'World'

-- Vaccination information
select location, date, new_vaccinations, total_vaccinations, people_vaccinated, people_fully_vaccinated
from CovidVaccinations
order by 1,2

select *
from CovidDeaths d
join CovidVaccinations v on (d.location = v.location and d.date = v.date)

-- population vs vaccination
select d.location, max(d.population) population, max(v.people_fully_vaccinated) #vaccinated,
(max(v.people_fully_vaccinated) / max(d.population))*100 VaccinationRate
from CovidDeaths d
join CovidVaccinations v on (d.location = v.location and d.date = v.date)
group by d.location
order by VaccinationRate desc


select location, date, new_vaccinations, 
sum(new_vaccinations) over (Partition by location order by location, date) as RunningTotalVaccins  --- VERY COOL
,total_vaccinations, people_vaccinated, people_fully_vaccinated
from CovidVaccinations
order by 1,2

-- CTE example
With MyCTE (continent, location, date, population)
as
	(select d.continent, d.location, d.date, d.population
	from CovidDeaths d)
select * from MyCTE

select location, date, new_vaccinations, 
sum(new_vaccinations) over (Partition by location order by location, date) as RunningTotalVaccins  --- VERY COOL
,total_vaccinations, people_vaccinated, people_fully_vaccinated
from CovidVaccinations
order by 1,2

-- Creating View to store 
create view MyView as
(select location, date, new_vaccinations, 
sum(new_vaccinations) over (Partition by location order by location, date) as RunningTotalVaccins  --- VERY COOL
,total_vaccinations, people_vaccinated, people_fully_vaccinated
from CovidVaccinations
)


select * from MyView