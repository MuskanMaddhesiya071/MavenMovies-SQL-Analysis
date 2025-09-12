USE mavenmovies; -- Making the database as Default Schema
/*
Assignment: 1
Pull list of film title, description, store id along with there inventory id
*/

-- Solution: 1
select  f.title, f.description, i.store_id, i.inventory_id
from film f
inner join inventory i
on f.film_id=i.film_id;

/*
Assignment: 2
How many actors for each film -  top 5 films from the list
*/

-- Solution: 2
select f.title, count(fa.actor_id) as number_of_actors
from film f
left join film_actor fa
on f.film_id=fa.film_id
group by 1
order by 2 desc
limit 5;

/*
Assignment: 3
List of all actors with each title they appear in 
*/

-- Solution: 3
select concat(a.first_name,' ', a.last_name) name, f.title as name
from actor a
join film_actor fa on a.actor_id=fa.actor_id
join film f on f.film_id=fa.film_id
order by 1,2;

/*
Assignment: 4
Unique titles and description available at store 2 inventory 
*/

-- Solution: 
select distinct f.title, f.description 
from film f
join inventory i
on f.film_id=i.film_id
where i.store_id=2;

/*
Assignment: 5
first_name and last_name of all staff memebers and advisors with there type
*/
-- Solution: 5
select 'staff' type ,first_name, last_name 
from staff
union
select 'advisor' type, first_name, last_name 
from advisor;


