/* 
1. My partner and I want to come by each of the stores in person and meet the managers. 
Please send over the managers’ names at each store, with the full address 
of each property (street address, district, city, and country please).  
*/ 
select  st.first_name manager_first_name, st.last_name manager_last_name,
a.address, a.district, c.city,  cou.country
from store s
left join staff st on s.manager_staff_id=st.staff_id
left join address a on st.address_id=a.address_id
left join city c on a.city_id=c.city_id
left join country cou on c.country_id=cou.country_id;


/*
2.	I would like to get a better understanding of all of the inventory that would come along with the business. 
Please pull together a list of each inventory item you have stocked, including the store_id number, 
the inventory_id, the name of the film, the film’s rating, its rental rate and replacement cost. 
*/
select i.store_id, i.inventory_id, f.title, f.rating, f.rental_rate, f.replacement_cost
from inventory i
left join film f
on i.film_id=f.film_id;

/* 
3.	From the same list of films you just pulled, please roll that data up and provide a summary level overview 
of your inventory. We would like to know how many inventory items you have with each rating at each store. 
*/
select i.store_id, f.rating, count(i.inventory_id) inventory_items
from inventory i
left join film f
on i.film_id=f.film_id
group by 1,2;

/* 
4. Similarly, we want to understand how diversified the inventory is in terms of replacement cost. We want to 
see how big of a hit it would be if a certain category of film became unpopular at a certain store.
We would like to see the number of films, as well as the average replacement cost, and total replacement cost, 
sliced by store and film category. 
*/ 
select i.store_id, c.name category, count(i.inventory_id) films, avg(f.replacement_cost) average_replacement_cost, sum(f.replacement_cost) total_replacement_cost
from inventory i
left join film f on i.film_id = f.film_id
left join film_category fc on f.film_id = fc.film_id
left join category c on c.category_id = fc.category_id
group by 1,2
order by 5 desc;


/*
5.	We want to make sure you folks have a good handle on who your customers are. Please provide a list 
of all customer names, which store they go to, whether or not they are currently active, 
and their full addresses – street address, city, and country. 
*/
select lower(concat(c.first_name,' ', c.last_name)) customer_name , c.store_id, c.active, a.address, ci.city, cou.country
from customer c
left join address a on c.address_id=a.address_id
left join city ci on a.city_id=ci.city_id
left join country cou on ci.country_id = cou.country_id;

/*
6.	We would like to understand how much your customers are spending with you, and also to know 
who your most valuable customers are. Please pull together a list of customer names, their total 
lifetime rentals, and the sum of all payments you have collected from them. It would be great to 
see this ordered on total lifetime value, with the most valuable customers at the top of the list. 
*/
select lower(concat(c.first_name,' ', c.last_name)) customer_name, count(r.rental_id) total_rentals, sum(p.amount) total_payment_amount
from customer c
left join rental r on c.customer_id=r.customer_id
left join payment p on c.customer_id=p.customer_id
group by 1
order by 3;
select * from payment;

/*
7. My partner and I would like to get to know your board of advisors and any current investors.
Could you please provide a list of advisor and investor names in one table? 
Could you please note whether they are an investor or an advisor, and for the investors, 
it would be good to include which company they work with. 
*/
select 'investor' type, first_name, last_name, company_name
from investor
union
select 'advisor' type, first_name, last_name, null
from advisor;

/*
8. We're interested in how well you have covered the most-awarded actors. 
Of all the actors with three types of awards, for what % of them do we carry a film?
And how about for actors with two types of awards? Same questions. 
Finally, how about actors with just one award? 
*/

SELECT
	CASE 
		WHEN actor_award.awards = 'Emmy, Oscar, Tony ' THEN '3 awards'
        WHEN actor_award.awards IN ('Emmy, Oscar','Emmy, Tony', 'Oscar, Tony') THEN '2 awards'
		ELSE '1 award'
	END AS number_of_awards, 
    AVG(CASE WHEN actor_award.actor_id IS NULL THEN 0 ELSE 1 END) AS pct_w_one_film
	
FROM actor_award
	

GROUP BY 
	CASE 
		WHEN actor_award.awards = 'Emmy, Oscar, Tony ' THEN '3 awards'
        WHEN actor_award.awards IN ('Emmy, Oscar','Emmy, Tony', 'Oscar, Tony') THEN '2 awards'
		ELSE '1 award'
	END;

