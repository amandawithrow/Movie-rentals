USE sakila; #choose database

SELECT * from actor LIMIT 10; #examine table

#HW item 1A
SELECT first_name, last_name FROM actor; #display first and last name from table

#HW item 1B
ALTER TABLE actor ADD COLUMN actor_name VARCHAR(50); #add new column
UPDATE actor SET actor_name = CONCAT(first_name, " ", last_name); #combine first and last name into column
SELECT actor_name from actor LIMIT 10; #view column to make sure it worked

#HW item 2A
SELECT actor_id, first_name, last_name FROM actor #find ID, first and last name of "joe"
WHERE first_name = "Joe";

#HW item 2B
SELECT actor_id, first_name, last_name FROM actor #find ID, first and last name for actors with "gen" in last name
WHERE last_name LIKE '%gen%';

#HW item 2C
SELECT last_name, first_name FROM actor #find first and last name for actors with 'li' in last name
WHERE last_name LIKE '%li%';

#HW item 2D
SELECT country_id, country FROM country
WHERE country IN ("Afghanistan", "bangladesh", "china");

#HW item 3A add new column
ALTER TABLE actor ADD COLUMN description BLOB; 

#HW item 3B drop description column
ALTER TABLE actor DROP COLUMN description; 

#HW item 4A list number of actors with that last name
SELECT last_name, COUNT(*) 
FROM actor
GROUP BY last_name;

#HW item 4B find and display actor last names where >=2 actors
SELECT last_name, COUNT(*) 
FROM actor
GROUP BY last_name
HAVING COUNT(*)>1;

#HW item 4C change Groucho Williams to Harpo Williams
UPDATE actor 
SET 
	actor_name = "Harpo Williams", first_name = "Harpo"
WHERE actor_name = "Groucho Williams";

#HW item 4D change it back to Groucho
UPDATE actor 
SET
	actor_name = "Groucho Williams", first_name = "Groucho"
WHERE actor_name = "Harpo Williams";

#HW item 5a to re-create address table
SHOW CREATE TABLE address; 
#can copy syntax under Create table in result grid and execute to re-create address table

#HW 6A join staff names and addresses
SELECT 
	staff.first_name,
    staff.last_name,
    address.address
FROM staff
INNER JOIN address ON staff.address_id = address.address_id;
    
#HW 6B total amount rung up by each staff in 8/2005
SELECT
    staff.last_name,
    SUM(payment.amount)
FROM staff
INNER JOIN payment ON staff.staff_id = payment.staff_id
	WHERE payment_date LIKE "2005-08%"
GROUP BY last_name;

#HW 6C film and number of actors
SELECT 
    film.title,
    COUNT(film_actor.actor_id)
FROM film_actor
INNER JOIN film on film.film_id = film_actor.film_id
GROUP BY title;

#HW 6D number of copies of Hunchback Impossible
SELECT COUNT(film_id) 
FROM inventory
WHERE
	film_id = (SELECT film_id FROM film WHERE title = "Hunchback Impossible");

#HW 6E - total paid by each customer listed alphabetically
SELECT 
	customer.last_name,
    customer.first_name,
    SUM(payment.amount)
FROM payment
LEFT JOIN customer on customer.customer_id = payment.customer_id
GROUP BY last_name, first_name
ORDER BY last_name; 

#HW 7A - film titles starting with K or Q that are in english
SELECT title 
FROM film
WHERE
	language_id = (SELECT language_id FROM language WHERE name = "English") AND
    (title like "K%" OR title like "Q%");

#HW 7B - display actors in Alone Trip
SELECT actor_name FROM actor 
WHERE
	actor_id IN (SELECT actor_id FROM film_actor WHERE
		film_id = (SELECT film_id FROM film WHERE title = "Alone Trip"));

#HW 7C email list of all Canadian customers
SELECT customer.first_name, customer.last_name, customer.email 
FROM customer
	INNER JOIN address ON customer.address_id = address.address_id
    INNER JOIN city ON address.city_id = city.city_id
    INNER JOIN country ON city.country_id = country.country_id
WHERE country = "Canada";

#HW 7D identify all movies that are categorized as family films
SELECT title FROM film #subqueries to find list of family films
WHERE
	film_id IN (SELECT film_id FROM film_category WHERE
		category_id = (SELECT category_id FROM category WHERE name = "Family"));

#HW 7E list of most frequently rented movies  in descending order
SELECT film.title, COUNT(rental.rental_date)
FROM film
	INNER JOIN inventory ON film.film_id = inventory.film_id
    INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY title
ORDER BY COUNT(rental_date) DESC;

#HW 7F display how much business in dollars each store brought in
SELECT staff.store_id, SUM(payment.amount)
FROM payment
	LEFT JOIN staff ON payment.staff_id = staff.staff_id
GROUP BY store_id;

#HW 7G display store ID, city and country
SELECT store.store_id, city.city, country.country
FROM store
	INNER JOIN address ON store.address_id = address.address_id
    INNER JOIN city ON address.city_id = city.city_id
    INNER JOIN country ON city.country_id = country.country_id;

#HW 7h find top 5 genres in gross revenue in descending order
SELECT category.name, SUM(payment.amount)
FROM category
	INNER JOIN film_category ON category.category_id = film_category.category_id
    INNER JOIN inventory ON film_category.film_id = inventory.film_id
    INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
    INNER JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY category.name 
ORDER BY SUM(payment.amount) DESC LIMIT 5;

#HW 8A create view of above query
CREATE VIEW top_genres AS
	SELECT category.name, SUM(payment.amount)
	FROM category
		INNER JOIN film_category ON category.category_id = film_category.category_id
		INNER JOIN inventory ON film_category.film_id = inventory.film_id
		INNER JOIN rental ON inventory.inventory_id = rental.inventory_id
		INNER JOIN payment ON rental.rental_id = payment.rental_id
	GROUP BY category.name 
	ORDER BY SUM(payment.amount) DESC LIMIT 5;
    
#HW 8B display view
SELECT * FROM top_genres;

#HW 8C delete view
DROP VIEW top_genres;