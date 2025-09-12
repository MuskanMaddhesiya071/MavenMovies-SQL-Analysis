use mavenmovies; 
-- Write a SQL query to count the number of characters except the spaces for each actor. Return first 10 actors name length along with their name.
select concat(first_name, last_name) Fullname, length(concat(first_name, last_name)) name_length
from actor
order by name_length desc
limit 10;

-- List all Oscar awardees(Actors who received Oscar award) with their full names and length of their names.
select concat(first_name, last_name) oscar_awardees, length(concat(first_name, last_name)) NameLength
from actor_award
where awards like '%Oscar%';
 
-- Find the actors who have acted in the film ‘Frost Head’.
select concat(first_name, last_name) 'Actor of film Frost Head'
from actor a 
join film_actor fa
on a.actor_id=fa.actor_id
join film f
on f.film_id=fa.film_id
where f.title like '%frost%head%';

-- Pull all the films acted by the actor ‘Will Wilson’.
select f.title 'Will Wilson Films'
from actor a
join film_actor fa
on a.actor_id=fa.actor_id
join film f
on fa.film_id=f.film_id
where concat(first_name, ' ', last_name) ='Will Wilson';
