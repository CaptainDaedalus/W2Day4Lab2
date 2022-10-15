use sakila;
/*
1. Write a query to display for each store its store ID, city, and country.
2. Write a query to display how much business, in dollars, each store brought in.
3. Which film categories are longest?
4. Display the most frequently rented movies in descending order.
5. List the top five genres in gross revenue in descending order.
6. Is "Academy Dinosaur" available for rent from Store 1?
7. Get all pairs of actors that worked together.
8. Get all pairs of customers that have rented the same film more than 3 times.
9. Get for every actor: actor_id, first_name, last_name and in how many films the actor has appeared, sorted in descending order of 
    number of films.
*/

-- 1. Write a query to display for each store its store ID, city, and country
SELECT s.store_id, ci.city, co.country
	from sakila.store as s
join sakila.address as a
	on s.address_id = a.address_id
join sakila.city as ci
	on a.city_id = ci.city_id
join sakila.country as co
	on ci.country_id = co.country_id;

-- 2. Write a query to display how much business, in dollars, each store brought in.
select * from store;
select * from payment;
select * from statff; -- > table "staff" to bridge the tables of "store" and "payment"

SELECT s.store_id as "Store ID", concat('$',count(p.amount)) as total_amount
	from sakila.store as s
join sakila.staff as st
	on s.store_id = st.store_id  -- > I originally connceted over address_id, but that didnt give me the same output (blank columns)
join sakila.payment as p
	on p.staff_id = st.staff_id
group by s.store_id;

-- 3. Which film categories are longest?
select * from category; -- > name, category_id
select * from film_category; -- > film_id, category_id
select * from film; -- > film_id, length

SELECT c.name as "Categories", avg(f.length) as "Avg length in mins"
	from sakila.category as c
join sakila.film_category as fc
	on c.category_id = fc.category_id
join sakila.film as f
	on fc.film_id = f.film_id
group by c.name
order by avg(f.length) DESC;

-- 4. Display the most frequently rented movies in descending order.
select * from film; -- > film_id, length, title, rental_rate
select * from rental; -- > inventory_id, staff_id, rental_id
select * from inventory; -- > inventory_id, film_id, store_id

SELECT f.title as "Film Name", count(r.rental_id) as "Times Rented"
	from sakila.film as f
join sakila.inventory as i
	on f.film_id = i.film_id
join sakila.rental as r
	on i.inventory_id = r.inventory_id
group by f.title
order by count(r.rental_id) DESC;

-- 5. List the top five genres in gross revenue in descending order.
select * from category; -- > Category_id, name
select * from film_category; -- >  Category_id, Film_id
select * from film; -- > Film_id, title, rental_rate

select c.name as "Category", concat("$",count(f.rental_rate)) as "Gross Revenue"
	from sakila.category as c
join sakila.film_category as fc
	on c.category_id = fc.category_id
join sakila.film as f
	on fc.film_id = f.film_id
group by c.name
order by count(f.rental_rate) DESC;

-- 6. Is "Academy Dinosaur" available for rent from Store 1?
select * from STORE; -- > store_id, address_id, manager_staff_id
select * from inventory; -- > inventory_id, film_id, store_id
select * from film; -- > film_id, title, rental_rate

select f.title as "Title", s.store_id as "Available in Store Nr."
	from sakila.store as s
join sakila.inventory as i
	on s.store_id = i.store_id
join sakila.film as f
	on i.film_id = f.film_id
where f.title like "Academy Dinosaur"
group by f.title
order by s.store_id;   

-- 7. Get all pairs of actors that worked together. I WASNT ABLE TO DO THIS ONE!

select * from film_actor; -- > actor_id, film_id......this is all I need as far as I can tell.

select fa1.film_id as "Shared Film ID", fa1.actor_id as "Actor 1 ID", fa2.actor_id as "Actor 2 ID" 
	from sakila.film_actor as fa1
join sakila.film_actor as fa2
	on fa1.film_id = fa2.film_id
and fa1.actor_id <> fa2.actor_id
group by fa1.actor_id and fa2.actor_id
order by fa1.film_id;

-- 8. Get all pairs of customers that have rented the same film more than 3 times.



/* 9. Get for every actor: actor_id, first_name, last_name and in how many films the actor has appeared, sorted in descending order of 
    number of films. */
select * from actor; -- > actor_id, first_name, last_name
select * from film_actor; -- > actor_id, film_id
select * from film; -- > film_id, title, rental_rate
-- > too many movies, something really wrong
SELECT fa.actor_id as "Actor ID", concat(a.first_name, " ", a.last_name) as "Actor Name", count(fa.actor_id) as "Number of Movies"
	from sakila.actor as a
join sakila.film_actor as fa
	on a.actor_id = a.actor_id
join sakila.film as f
	on fa.film_id = f.film_id
group by fa.actor_id
order by "Actor Name", count(fa.actor_id) DESC;