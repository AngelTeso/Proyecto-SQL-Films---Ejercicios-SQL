-- ** CORRECCION PROYECTO LÓGICA CONSULTAS SQL- SEGÚN COMENTARIOS TUTOR 21-01-2026 

--** Query 5 - CORRECCION. Ordena las películas por duración de forma ascendente.

select * from film;

select Title as Titulo, length as Duración from film order by length asc; 

--** Query 11 - CORRECCION. Encuentra lo que costó el antepenúltimo alquiler ordenado por día

select * from rental;

select rental_id, rental_date from rental r order by r.rental_date desc limit 1 offset 1;

--** Query 12 - CORRECCION. Encuentra el título de las películas en la tabla “filmˮ que no sean ni ‘NC-17ʼ ni ‘Gʼ en cuanto a su clasificación

select * from film;

select Title as Titulo from film f where f.rating not in ('NC-17','G');

--** Query 19 - CORRECCION. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla “filmˮ

select * from film;

select * from film_category;

select * from category;

select Title as Titulo from film f where f.length > 180 and f.film_id in (select film_id from film_category fc where fc.category_id in (select category_id from category c where c.name='Comedy'));

--** Query 20 - CORRECCION. Encuentra las categorías de películas que tienen un promedio de duración superior a 110 minutos y muestra el nombre de la categoría junto con el promedio de duración

create temp table category_length as select c.category_id, c.name, f.film_id, f.length from category c, film f, film_category fc where fc.category_id=c.category_id and f.film_id=fc.film_id;

with duracion_media as (select cl.category_id as categoria, cl.name as nombre, avg(cl.length) as avg_length from category_length cl group by cl.category_id, cl.name order by avg_Length desc)
select * from duracion_media where avg_length > 110;

--** Query 36 - CORRECCION. Renombra la columna “first_nameˮ como Nombre y “last_nameˮ como Apellido

	-- No entiendo bien el contexto de la corrección. El enunciado dice renombrar. Si no se quiere tocar la estructura, habrá que crear una view, cte o temp table. O simplemente utilizar el 'as' en el select 
	-- ¿va por ahí la resolución?

	alter table "actor" rename column "Nombre" to "first_name";	
	select * from actor;
	alter table "actor" rename column "Apellido" to "last_name";
	select * from actor;

	select actor_id, first_name as "Nombre", last_name as "Apellido" from actor;
		
--** Query 39 - CORRECCION.  Selecciona todos los actores y ordénalos por apellido en orden ascendente.
	
	select * from actor;
	
	select * from actor order by "Apellido" ASC;

--** Query 43 - CORRECCION. Muestra todos los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres.
	
	select * from rental;
	select count(distinct(customer_id)) from customer; -- Tenemnos 599 clientes distintos.
	select count(distinct(customer_id)) from rental; -- Tenemos 599 clientes distintos que alquilan.
	select distinct (customer_id) from customer where customer_id not in (select distinct(customer_id) from rental); --* no hay ningún cliente de la lista que no haya alquilado.
	
	create temp table rental_customer as
	select i.film_id, f.title, r.rental_date, r.customer_id from inventory i join film f on i.film_id = f.film_id join rental r on i.inventory_id=r.inventory_id;
	select rc.film_id, rc.title, rc.rental_date, rc.customer_id, c.first_name, c.last_name from rental_customer rc join customer c on rc.customer_id=c.customer_id;
		
	select  rc.customer_id, c.first_name, c.last_name, rc.film_id, rc.title, rc.rental_date from rental_customer rc left join customer c on rc.customer_id=c.customer_id order by customer_id asc;
	--* técnicamente es la misma consulta que la de la Query 42, dado que existe una relación 1:1 en los customer_id de ambas tablas.
	
	--** Query 52. 	Crea una tabla temporal llamada “peliculas_alquiladasˮ que almacene las películas que han sido alquiladas al menos 10 veces.	
		
		select * from rental;
		select * from inventory;
		
		drop table peliculas_alquiladas;
		
		create temp table peliculas_alquiladas as
		with rental_film as
		(select r.rental_id, i.inventory_id, i.film_id from rental r left join inventory i on r.inventory_id=i.inventory_id)
		select rf.film_id, f.title, count(*) as Núm_Alq from rental_film rf join film f on rf.film_id=f.film_id group by rf.film_id, f.title order by núm_alq desc;
		
		select * from peliculas_alquiladas where num_alq > 10;
	
	--** Query 56.  Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría ‘Musicʼ
	
	--* Apvechamos la query anterior, creando la tabla temporal
	
	select * from category;
	select * from actor;
	
	create temp table actor_categoria as
	select fa.actor_id, fa.film_id, fc.category_id from film_actor fa join film_category fc on fa.film_id=fc.film_id;	

	select * from actor_categoria;
	
	select distinct actor_id from actor_categoria where actor_id not in (select distinct actor_id from actor_categoria where category_id = 12);
	
	select category_id from category where name='Music';
	
	select distinct ac.actor_id, a."Nombre", a."Apellido" from actor_categoria ac join actor a on ac.actor_id=a.actor_id where ac.actor_id in 
		(select distinct actor_id from actor_categoria where actor_id not in 
			(select distinct actor_id from actor_categoria where category_id = (select category_id from category where name='Music')));
	
	--** Query 57.  CORRECCION - Encuentra el titulo de todas las peliculas alquiladas por más de 8 dias
	
	select * from inventory;
	select * from rental;
	select * from film;
	
	-- * CORRECCION --------------------
	
	select * from rental;
	
	alter table RENTAL drop column dias_alquilada;
	
	select film_id, Title from film where film_id in (
	select film_id from inventory where inventory_id in (
	select inventory_id from rental where return_date - rental_date > '8 days'));
	
	--** Query 58 - CORRECCION.  Encuentra el titulo de todas las peliculas que son de la misma categoria que 'Animation'
	
	select * from film_category;
	select * from film;
	select * from category;
		
	select title from film where film_id in 
		(select film_id from film_category where category_id in 
			(select category_id from category where name='Animation')); 
	
-- * Query 62 - CORRECCION. Encuentra el número de películas por categoría estrenadas en 2006.
		
		--* Creamos una vista intermedia con las peliculas por categoria y fechas de estreno
		
		select * from film;
		select * from film_category;
		select * from category;
		
		with pelis_categoria_estreno as 
		(select f.film_id, fc.category_id, c.name, f.release_year from film f join film_category fc on f.film_id=fc.film_id join category c on fc.category_id=c.category_id where f.release_year > 2006)
		select category_id, name, count (*) as num_category from pelis_categoria_estreno group by category_id, name;
		
		
	
	
	
	
		