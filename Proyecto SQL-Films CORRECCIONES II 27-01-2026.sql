-- ** CORRECCION PROYECTO LÓGICA CONSULTAS SQL- SEGÚN COMENTARIOS TUTOR 27-01-2026 

--** Query 11 - CORRECCION. Encuentra lo que costó el antepenúltimo alquiler ordenado por día. Trabajar sobre la tabla payment y coger el antepenúltimo pago por fechas. 

select * from rental;

select * from PAYMENT where rental_id in (select rental_id from rental r order by r.rental_date desc limit 1 offset 2);

--** Query 36 - CORRECCION. Renombra la columna “first_nameˮ como Nombre y “last_nameˮ como Apellido

	-- No entiendo bien el contexto de la corrección. El enunciado dice renombrar. Si no se quiere tocar la estructura, habrá que crear una view, cte o temp table. O simplemente utilizar el 'as' en el select 
	-- ¿va por ahí la resolución?...

	-- LOS 'ALTER TABLE' SE UTILIZAN PARA DEVOLVER LA TABLA AL ESTADO ORIGINAL Y NO MODIFICAR SU ESTRUCTURA. RENOMBRO LOS CAMPOS CON EL ALIAS 'AS'. SUPONGO QUE ESTO VA ASÍ. 

	alter table "actor" rename column "Nombre" to "first_name";	
	select * from actor;
	alter table "actor" rename column "Apellido" to "last_name";
	select * from actor;

	select actor_id, first_name as "Nombre", last_name as "Apellido" from actor;
		
--** Query 39 - CORRECCION.  Selecciona todos los actores y ordénalos por apellido en orden ascendente.
	
	--- cierto, al devolver la tabla a su estructura orginal, ese campo se ppama "last_name"
	
	select * from actor;
	
	select * from actor order by last_name ASC;

--** Query 43 - CORRECCION. Muestra todos los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres.
	
	select * from rental;
	select count(distinct(customer_id)) from customer; -- Tenemnos 599 clientes distintos.
	select count(distinct(customer_id)) from rental; -- Tenemos 599 clientes distintos que alquilan.
	select distinct (customer_id) from customer where customer_id not in (select distinct(customer_id) from rental); --* no hay ningún cliente de la lista que no haya alquilado.
	
	create temp table rental_customer as
	select i.film_id, f.title, r.rental_date, r.customer_id from inventory i join film f on i.film_id = f.film_id join rental r on i.inventory_id=r.inventory_id;
	select rc.film_id, rc.title, rc.rental_date, rc.customer_id, c.first_name, c.last_name from rental_customer rc join customer c on rc.customer_id=c.customer_id;
		
	select  c.customer_id, c.first_name, c.last_name, rc.film_id, rc.title, rc.rental_date from customer c left join rental_customer rc on rc.customer_id=c.customer_id order by customer_id asc;

	
	--** Query 52. 	Crea una tabla temporal llamada “peliculas_alquiladasˮ que almacene las películas que han sido alquiladas al menos 10 veces.
	
	-- Metemos en la creación de la tabla la cláusula where de más de 10 películas alquiladas, partiendo de la creación del campo de conteo en el CTE
		
		select * from rental;
		select * from inventory;
		
		drop table peliculas_alquiladas;
		
		create temp table peliculas_alquiladas as
		with rental_film as
		(select i.film_id, count(*) as Núm_Alq from rental r left join inventory i on r.inventory_id=i.inventory_id group by i.film_id)
		select rf.film_id, f.title, Núm_Alq from rental_film rf join film f on rf.film_id=f.film_id where Núm_alq >=10 group by rf.film_id, f.title, rf.Núm_alq order by Núm_alq desc;
		
		select * from peliculas_alquiladas;
	
	-- * Query 62 - CORRECCION. Encuentra el número de películas por categoría estrenadas en 2006.
		
		--* Creamos una vista intermedia con las peliculas por categoria y fechas de estreno EN 2006 (=)
		
		select * from film;
		select * from film_category;
		select * from category;
		
		with pelis_categoria_estreno as 
		(select f.film_id, fc.category_id, c.name, f.release_year from film f join film_category fc on f.film_id=fc.film_id join category c on fc.category_id=c.category_id where f.release_year = 2006)
		select category_id, name, count (*) as num_category from pelis_categoria_estreno group by category_id, name;
		