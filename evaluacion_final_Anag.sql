-- EVALUACIÓN FINAL, SAKILA.

USE `sakila`;

-- EJERCICIO 1: Selecciona todos los nombres de las películas sin que aparezcan duplicados.

SELECT DISTINCT`title`
FROM `film`;

-- EJERCICIO 2: Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".

SELECT `title`
FROM `film`
WHERE `rating`= 'PG-13';

-- EJERCICIO 3: Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.

SELECT `title`, `description`
FROM `film`
WHERE `description` LIKE '%amazing%';

-- EJERCICIO 4: Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.

SELECT `title`
FROM `film`
WHERE `length`> 120;

 -- EJERCICIO 5: Recupera los nombres de todos los actores.
 
 SELECT `first_name`, `last_name`
 FROM `actor`;
 
 -- EJERCICIO 6: Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.
 
SELECT `first_name`, `last_name`
FROM `actor`
WHERE `last_name` LIKE '%Gibson%';

-- EJERCICIO 7: Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20.

SELECT `first_name`, `last_name`
FROM `actor`
WHERE `actor_id` BETWEEN 10 AND 20;

-- EJERCICIO 8: Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.

SELECT `title`
FROM `film`
WHERE `rating` <> 'PG-13' AND `rating` <> 'R';

-- EJERCICIO 9: Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.

SELECT `rating`, COUNT(`title`) AS `recuento`
FROM `film`
GROUP BY `rating`;

-- EJERCICIO 10: Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.

SELECT `c`.`customer_id`, `c`. `first_name`, `c`.`last_name`, COUNT(`r`.`inventory_id`) AS `peliculas_alquiladas`
FROM `customer` AS `c`
INNER JOIN `rental` AS `r`
ON `c`.`customer_id` = `r`.`customer_id`
GROUP BY `c`.`customer_id`;

-- EJERCICIO 11: Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.

SELECT `c`. `name` , COUNT( `r`.`inventory_id`) AS `recuento_alquileres`
FROM `category` AS c
INNER JOIN `film_category` AS `fc`
ON `c`.`category_id` = `fc`.`category_id`
INNER JOIN `film` AS f
ON `fc`.`film_id` = `f`.`film_id`
INNER JOIN `inventory` AS `i`
ON `f`.`film_id` = `i`.`film_id`
INNER JOIN `rental` AS `r`
ON `i`.`inventory_id `= `r`.`inventory_id`
GROUP BY `c`.`name`;

-- EJERCICIO 12: Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.

SELECT `rating`, AVG(`length`) AS `promedio_duracion`
FROM `film`
GROUP BY `rating`;

-- EJERCICIO 13: Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".

SELECT `a`.`first_name`, `a`.`last_name`
FROM `actor` AS `a`
INNER JOIN `film_actor` AS `fa`
ON `a`.`actor_id` = `fa`.`actor_id`
INNER JOIN `film` as `f`
ON `fa`.`film_id` = `f`.`film_id`
WHERE `f`.`title` = 'Indian Love';

-- EJERCICIO 14: Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción.

SELECT `title`, `description`
FROM `film`
WHERE `description` LIKE '%dog%' OR `description` LIKE '%cat%';

-- EJERCICIO 15: Hay algún actor/actriz que no aparecen en ninguna película en la tabla film_actor.

	SELECT `actor_id`, `first_name`, `last_name`
    FROM `actor`
    WHERE `actor_id` NOT IN (
			SELECT DISTINCT `actor_id`
            FROM `film_actor`);
            
-- EJERCICIO 16: Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.

SELECT `title`, `release_year`
FROM `film`
WHERE `release_year` BETWEEN 2005 AND 2010; 

-- EJERCICIO 17: Encuentra el título de todas las películas que son de la misma categoría que "Family".

SELECT `title`
FROM `film`
WHERE `film_id` IN (
    SELECT `film_id`
    FROM `film_category`
    WHERE `category_id` = (
        SELECT `category_id`
        FROM `category`
        WHERE name = 'Family'));

-- EJERCICIO 18: Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.

SELECT `a`.`first_name`, `a`.`last_name`
FROM `actor` AS a
INNER JOIN `film_actor` AS fa
ON `fa`.`actor_id`= `a`.`actor_id`
GROUP BY `a`.`actor_id`
HAVING COUNT(`fa`.`film_id`)> 10;

-- EJERCICIO 19: Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film.

SELECT `title`
FROM `film`
WHERE `rating` = 'R' AND `length` > 120; 

-- EJERCICIO 20: Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de la categoría junto con el promedio de duración.

WITH `duracion_categoria` AS (
    SELECT `c`.`name` AS `categoria`, AVG(`f`.`length`) AS `promedio_duracion`
    FROM `category`AS `c`
    INNER JOIN `film_category` AS `fc` 
    ON `c`.`category_id` = `fc`.`category_id`
    INNER JOIN `film` AS `f` 
    ON `fc`.`film_id` = `f`.`film_id`
    GROUP BY `c`.`name`)
SELECT `categoria`, `promedio_duracion`
FROM `duracion_categoria`
WHERE `promedio_duracion` > 120;


-- EJERCICIO 21: Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas en las que han actuado.

SELECT `a`.`first_name`, `a`.`last_name`, COUNT(`fa`.`film_id`) AS `cantidad_peliculas`
FROM `actor`AS `a`
INNER JOIN `film_actor` AS `fa` 
ON `a`.`actor_id` = `fa`.`actor_id`
GROUP BY `a`.`actor_id`
HAVING COUNT(`fa`.`film_id`) >= 5;

/*EJERCICIO 22: Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Utiliza una subconsulta para encontrar los rental_ids con una duración 
superior a 5 días y luego selecciona las películas correspondientes.*/

SELECT `f`.`title`
FROM `film` AS `f`
WHERE `f`.`film_id` IN (
    SELECT `r`.`inventory_id`
    FROM `rental` AS `r`
    GROUP BY `r`.`inventory_id`
    HAVING SUM(DATEDIFF(`r`.`return_date`, `r`.`rental_date`)) > 5);

/*EJERCICIO 23: Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror". 
Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego exclúyelos de la lista de actores.*/

SELECT `first_name`, `last_name`
FROM `actor`
WHERE `actor_id` NOT IN(
	SELECT `fa`.`actor_id`
	FROM `film_actor` AS `fa`
    INNER JOIN `film_category` AS `fc` 
    ON `fa`.`film_id` = `fc`.`film_id`
    INNER JOIN `category` AS `c` 
    ON `fc`.`category_id` = `c`.`category_id`
    WHERE `c`.`name` = 'Horror');

-- EJERCICIO 24: Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla film.

SELECT `f`.`title` 
FROM `film` AS `f`
INNER JOIN `film_category` AS `fc` 
ON `f`.`film_id` = `fc`.`film_id`
INNER JOIN `category` AS `c` 
ON `fc`.`category_id` = `c`.`category_id`
WHERE `c`.`name` = 'Comedy' AND `f`.`length` > 180;








