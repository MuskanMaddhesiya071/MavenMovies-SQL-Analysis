use mavenmovies;
-- 1. Advanced SQL Queries for Maven Movies Database

-- 2. Running Total of Revenue Per Store (Cumulative Sum)
select st.store_id, p.payment_date, p.amount , sum(p.amount) over (partition by store_id order by p.payment_Date) as running_total
from store st
left join staff s on st.store_id=s.store_id
left join payment p on p.staff_id=s.staff_id;

-- 3. Identifying High-Value Customers (Customers Who Spent More than 500)
select c.customer_id, c.first_name, c.last_name , sum(p.amount) 'Total Spent'
from customer c
join payment p on p.customer_id=c.customer_id 
group by c.customer_id 
having sum(p.amount)>500
order by 'Total Spent' desc;

-- 4. Monthly Revenue Trends for the Past Year
select date_format(payment_date, '%y-%m') 'Month', sum(amount) 'Total Amount'
from payment
where payment_date >=date_sub(curdate(), interval 1 year)
group by month
order by month;

-- Find Customers Who Rented More Than Once in the Same Day
select customer_id, rental_date, count(rental_id) 'rental_per_day'
from rental
group by 1,2
having count(rental_id)>1;

-- 5. Optimizing Query Performance: Indexing Example
CREATE INDEX idx_customer_rental ON RENTAL(CUSTOMER_ID, RENTAL_DATE);

-- 6. Dynamic Query: Stored Procedure to Get Rentals for a Given Month
DELIMITER //
create procedure getMonthlyRental(in RentalMonth varchar(7))
begin
     select * from rental
     where date_format(rental_date, '%Y-%M')=RentalMonth;
end//
DELIMITER ;

CALL getMonthlyRental('2005-05');

-- 7. Find Customers Who Have Never Rented a Movie
select c.customer_id, c.first_name
from customer c
left join rental r on c.customer_id=r.customer_id
where r.customer_id is null;

-- 8. Common Table Expressions (CTEs) for Complex Queries
with HighSpendingCustomers as(
select c.customer_id, c.first_name, c.last_name , sum(p.amount) as totalSpent
from customer c
join payment p on c.customer_id=p.customer_id
group by c.customer_id, c.first_name, c.last_name
having sum(p.amount)>300
)
select * from HighSpendingCustomers;

-- 9. Advanced Window Functions: Using NTILE to Segment Customers by Spending
select c.customer_id, c.first_name, c.last_name, sum(p.amount)  total_spent,
ntile(4)  over(order by sum(amount) desc)  spending_quartile
from payment p
join customer c on p.customer_id=c.customer_id
group by c.customer_id, c.first_name, c.last_name;

-- 10. Query Performance Tuning: Analyzing Execution Plan
EXPLAIN ANALYZE SELECT * FROM RENTAL WHERE CUSTOMER_ID = 10;

-- 11. Time-Series Analysis: Rolling Averages for Revenue
SELECT DATE_FORMAT(PAYMENT_DATE, '%Y-%m') AS Month,
       SUM(AMOUNT) AS Total_Revenue,
       AVG(sum(AMOUNT)) OVER (ORDER BY DATE_FORMAT(PAYMENT_DATE, '%Y-%m') ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS Rolling_Avg
FROM PAYMENT
GROUP BY Month;

-- 12. Top 5 Customers Who Spent the Most
select c.customer_id, c.first_name, c.last_name, sum(p.amount)  total_spent
from payment p
join customer c on p.customer_id=c.customer_id
group by c.customer_id, c.first_name, c.last_name
order by total_spent desc
limit 5;

-- 13. Advanced Window Function: Dense Rank with Conditional Aggregation
-- Best Use Case: Ranking customers based on total spending while maintaining ranking gaps in case of ties.
select c.customer_id, c.first_name, c.last_name, sum(p.amount) total_spent, 
dense_rank() over(order by sum(p.amount) desc) as spending_rank
from payment p
join customer c on p.customer_id=c.customer_id
group by c.customer_id, c.first_name, c.last_name;



-- 14. Dynamic SQL Query: Building Queries on the Fly
-- Best Use Case: When table names or filters need to be decided at runtime (e.g., handling multi-tenant databases).
delimiter  //
create procedure GenerateDynamicQuery(in TableName varchar(50))
begin
    set @sql_query = CONCAT('SELECT * FROM ', TableName, ' LIMIT 10');
    prepare stmt from @sql_query;
    execute stmt;
    deallocate prepare stmt;
end;
//
DELIMITER ;

-- Call Procedure Example:
call GenerateDynamicQuery('Film_category');

-- 15. Indexing and Performance Optimization
-- Best Use Case: Speeding up search queries on frequently used columns.
create index idx_customer_email on customer(email);
explain select * from customer where email='MARY.SMITH@sakilacustomer.org';


-- 16. Pivoting Data Using Conditional Aggregation
-- Best Use Case: Transforming row-based data into a columnar format (e.g., sales by region).
select customer_id,
sum(case when month(rental_date)=1 then 1 else 0 end) 'january rentals',
sum(case when month(rental_date)=2 then 1 else 0 end) 'february rentals'
from rental
group by customer_id;

-- 17. Advanced Date & Time Functions
-- Best Use Case: Comparing time intervals and trends over time.
select CUSTOMER_ID, RENTAL_DATE,
       lag(RENTAL_DATE) over (partition by  CUSTOMER_ID order by RENTAL_DATE)  Previous_Rental,
       DATEDIFF(RENTAL_DATE, lag(RENTAL_DATE) over (partition by  CUSTOMER_ID order by  RENTAL_DATE)) as Days_Between_Rentals
from RENTAL;






















