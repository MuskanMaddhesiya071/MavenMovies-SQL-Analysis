USE mavenmovies; -- Making the database as Default Schema

/*
Assignment: 1
Pull the list of first_name, last_name and email of each of our customers
*/ 

-- Solution: 1
select first_name, last_name, email
from customer;

/*
Assignment: 2
Pull the record of the films and see if there are rental duations other then: 3,5 or 7 days
*/ 

-- Solution: 2
select distinct rental_duration from film
where rental_duration not in (3,5, 7);

/*
Assignment: 3
Pull the list of all payments from our first 100 customers
*/ 

-- Solution: 3
select customer_id, rental_id, amount, payment_date  from payment
where customer_id between 1 and 100;

/*
Assignment: 4
Pull the list of payments over $5 for those same customers, since Jan-1-2006
*/ 

-- Solution: 4
select customer_id, rental_id, amount, payment_date  from payment
where customer_id between 1 and 100 and amount>5 and payment_date>'2006-01-01';


/*
Assignment: 5
Pull payments from those specific customers along with payments above $5 from any customer
*/ 

-- Solution: 5
select customer_id, rental_id, amount, payment_date  from payment
where  amount>5 or customer_id in (42, 53, 60, 75);

/*
Assignment: 6
To understand the special feature in the film record, pull the list of all the films
which include 'Behind the Scenes' as special features
*/ 

-- Solution: 6
select title, special_features from film
where special_features like '%Behind the Scenes%';

/*
Assignment: 7
Count of all film titles sliced by rental duration
*/ 

-- Solution: 7
select rental_duration ,count(title) as title_count
from film
group by rental_duration
order by 2 desc;

/*
Assignment: 8
Pull count of films, along with avg, min and max of rental rate grouped by replacement cost
*/ 

-- Solution: 8
select replacement_cost, count(film_id) number_of_films, avg(rental_rate) average_rental, min(rental_rate)	cheapest_rental, max(rental_rate) expensive_rental
from film
group by replacement_cost
order by 1 desc;

/*
Assignment: 9
Pull the list of customer_id with less then 15 rentals all time
*/ 

-- Solution: 9
select customer_id, count(rental_id) total_rental_all_time from rental
group by customer_id
having total_rental_all_time<15
order by 2 desc;

/*
Assignment: 10
Pull list of all film titles along with there length and rental rate and sort from longest to shortest
*/ 

-- Solution: 10
select title, length, rental_rate
from film
order by length desc;

/*
Assignment: 11
Find out the names of all customers along with there store they prefer and are they active on them or not
*/ 

-- Solution: 11

select concat(first_name, last_name) name,
case 
    when store_id=1 and active=1 then 'store 1 Active'
    when store_id=1 and active=0 then 'store 1 Inactive'
    when store_id=2 and active=1 then 'store 2 Active'
    when store_id=2 and active=0 then 'store 2 Inactive'
end as 'Store_&_Status'
from customer;

/*
Assignment: 12
How many inactive customers we have at each store
*/ 

-- Solution: 12
select store_id, count(case when active=0 then customer_id else null end) as inactive_customer from customer
group by store_id;

/*
Assignment: 13
How many active and inactive customers we have at each store
*/ 

-- Solution: 13
select store_id, count(case when active=1 then customer_id else null end) as Active_customer, 
count(case when active=0 then customer_id else null end) as Inactive_customer
from customer
group by store_id;


    
