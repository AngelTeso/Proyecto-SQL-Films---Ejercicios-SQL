--** 0. Vamos conociendo el esquema de tablas y contenidos ** --

select * from CUSTOMER;
select * from FILM;
select * from film_category fc;
select * from category c ;
select * from inventory i ;
select * from rental r;

--** Query 1. Esquema de la BBDD. Según Diagrama de Tablas del Proyecto. Cargado y en funcionamiento.

	-- * Insertar descriptor del esquema

--** Query 2. Mostramos todos los nombres de las peliculas con una clasificación por edades de 'R' **--

select "title" from FILM where RATING = 'R';

--** Query 3. Encontrar los nombres de los actores que tengan 'actor_id' entre 30 y 40

select * from film_actor fa ;

select * from actor;

select actor_id, first_name as Nombre, last_name as Apellido from actor;

select actor_id, first_name as Nombre, last_name as Apellido from actor where actor_id>=30 and actor_id<=40;

--** Query 4. películas cuyo idioma coincide con el idioma original **--

select * from language; 

select title as Titulo from film f where f.original_language_id = f.language_id; --* Nota: en la BBDD el campo Original Language aparece como NULL en todos los campos y solo aparece la fecha de release en 2006

--** Query 5. Ordena las películas por duración de forma ascendente.

select * from film;

select Title as Titulo, length as Duración from film order by length desc; 

--** Query 6.  Encuentra el nombre y apellido de los actores que tengan ‘Allenʼ en su apellido

select * from actor;

select first_name as Nombre, last_name as Apellido from actor a where a.last_name like '%ALLEN%';

--** Query 7. Encuentra la cantidad total de películas en cada clasificación de la tabla “filmˮ y muestra la clasificación junto con el recuento.  

select * from film;

select rating as Clasificacion, count(*) as Número from film f group by f.rating; 

--** Query 8. Encuentra el título de todas las películas que son ‘PG13ʼ o tienen una duración mayor a 3 horas en la tabla film.

select * from film;

select Title as Titulo, rating as Clasificación, length as Duración from film f
where
 f.rating='PG-13' or f.length>=180;

--** Query 9.  Encuentra la variabilidad de lo que costaría reemplazar las películas.

	-- * Entendemos como variabilidad a la varianza muestral del coste de reemplazo. 

select * from film;

select var_samp(replacement_cost) as Varianza from film f; 

--** Query 10. Encuentra la mayor y menor duración de una película de nuestra BBDD.

select * from film;

select max(length) as Duración_máxima, min(length) as Duración_Mínima from film f; 

--** Query 11. Encuentra lo que costó el antepenúltimo alquiler ordenado por día

select * from rental;

select * from payment p order by p.payment_date desc;

select amount as cantidad_pagada from payment p order by p.payment_date desc limit 1 offset 1; 

--** Query 12.  Encuentra el título de las películas en la tabla “filmˮ que no sean ni ‘NC-17ʼ ni ‘Gʼ en cuanto a su clasificación

select * from film;

select Title as Titulo from film f where f.rating not in ('PG-13','G');

--** Query 13.  Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración

select * from film;

select avg(length) as Promedio_Duración, rating as Clasificación from film f group by f.rating;

--** Query 14. Encuentra el título de todas las películas que tengan una duración mayor a 180 minutos.

select * from film;

select title as Titulo, length as Duración from film f where f.length>=180 order by length DESC ;

--** Query 15.  ¿Cuánto dinero ha generado en total la empresa?

select * from PAYMENT;

select MAX(payment_date), min(payment_date) from Payment;

       --* Entendemos el dinero total facturado en la tabla Payment

select sum(amount) as Total_facturado from  payment;

--** Query 16. Muestra los 10 clientes con mayor valor de id.

select * from customer;

select * from customer c order by c.customer_id desc limit 10;

--** Query 17. Encuentra el nombre y apellido de los actores que aparecen en la película con título ‘Egg Igbyʼ

select * from actor;

select * from film_actor fa;

select * from film;

select first_name as Nombre, last_name as Apellido from actor where actor_id in 
(
select actor_id from film_actor fa where fa.film_id in 
(select FILM_ID from film f where f.title='EGG IGBY')
);

--** Query 18. Selecciona todos los nombres de las películas únicos.

select * from film;

select distinct Title as Nombre_unico from film;

--** Query 19. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla “filmˮ

select * from film;

select * from film_category;

select * from category;

select Title as Titulo from film f where f.film_id in (
select film_id from film_category fc where fc.category_id in (select category_id from category c where c.name='Comedy'));

--** Query 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 110 minutos y muestra el nombre de la categoría junto con el promedio de duración

select * from film;

select * from film_category;

select * from category;

--**

select avg(length) as duracion from film f;

select * from film f where f.length >= (select avg (length) from film) ;

select film_id from film f where f.length >= (select avg (length) from film);

select film_id, category_id as Categoria from film_category where film_id in (

select film_id from film f where f.length >= (select avg (length) from film)); 

--**

select fc.category_id as Categoria_id, c.name as Nombre from film_category fc
join
category c
on fc.category_id = c.category_id
where fc.film_id in (
select film_id from film f where f.length >= 110);

--** Query 21.  ¿Cuál es la media de duración del alquiler de las películas?

select * from rental;

select (return_date - rental_date) as dias from rental;

select avg(return_date - rental_date) as dias from rental;

--** Query 22.  Crea una columna con el nombre y apellidos de todos los actores y actrices.

select * from film_actor;

select * from actor;

select CONCAT (a.first_name,' ',a.last_name) as nombre from actor a;

--** Query 23. Números de alquiler por día, ordenados por cantidad de alquiler de forma descendente.

select * from rental;

select rental_date::date as fecha from rental;

select count(*) as Número from rental group by (rental_date::date) order  by número DESC;

--** Query 24. Encuentra las películas con una duración superior al promedio

select fc.film_id, f.title as Titulo, f.length as Duración, fc.category_id  as Categoria_id, c.name as Nombre from film_category fc
join
category c
on fc.category_id = c.category_id
join
film f
on fc.film_id = f.film_id
where fc.film_id in (
select film_id from film f where f.length >= (select avg (length) from film));

--** Query 25. Averigua el número de alquileres registrados por mes

select * from rental;

select rental_date::month as mes from rental;

select count(*) as Numero, extract(month from rental_date) as MES from RENTAL group by MES;

--** Query 26.  Encuentra el promedio, la desviación estándar y varianza del total pagado.

select * from PAYMENT;

select avg(amount) as Promedio, stddev(amount) as Desviación_Estándar, variance(amount) as Varianza from Payment;

--** Query 27.  ¿Qué películas se alquilan por encima del precio medio?

select * from payment;

select * from rental;

select * from inventory;

select * from film;

	--** Entendemos que estamos hablando de aquellas peliculas que superan el valor medio de alquiler (no el precio medio por dia)
	--** voy a desagregar la select en partes.

	--* primero voy a averiguar aquellas operaciones que superan el volumen medio por operación

		select rental_id from payment where amount>=(select avg(amount) from payment);

	--* Obtengo el Inventory_id con los rental_id anteriores de la tabla rental
		
		select inventory_id from rental where rental_id in (select rental_id from payment where amount>= (select avg(amount) from payment));

	--* obtengo el film_id con los Inventory_id anteriores de la tabla inventory
		
		select film_id from inventory where inventory_id in (select inventory_id from rental where rental_id in (select rental_id from payment where amount>= (select avg(amount) from payment)));
		
	--* obtengo el nombre de la pelicula de la tabla film con los film_id anteriores de la tabla inventory
	
		select film_id, title as Nombre from film where film_id in (select film_id from inventory where inventory_id in (select inventory_id from rental where rental_id in (select rental_id from payment where amount>= (select avg(amount) from payment))))
		
--** Query 28.  Muestra el id de los actores que hayan participado en más de 40 películas.
		
	select * from actor;
	
	select * from film_actor;
	
	select 	actor_id as Actor, count(*) as Numero from film_actor group by actor_id;

	--** Construyo un CTE
	
	with CONTEO_PELIS as (select actor_id as Actor, count(*) as Numero from film_actor group by actor_id)
	select conteo_pelis.actor from conteo_pelis where conteo_pelis.numero>40;
		
		--* Ahora con un Join junto el Actor_id con el nombre en la tabla actor

	with CONTEO_PELIS as (select actor_id as Actor, count(*) as Numero from film_actor group by actor_id)
	select conteo_pelis.actor, a.first_name, a last_name from conteo_pelis 
	join actor a
		on conteo_pelis.actor=a.actor_id
	where conteo_pelis.numero>40;

--** Query 29. Obtener todas las películas y, si están disponibles en el inventario, mostrar la cantidad disponible. 

	select * from inventory;
	
	select * from rental;
	
	select distinct(store_id) from inventory;
	
	select * from store;
	
	--* Vamos a crear un CTE con los Films_id y las cantidades de peliculas disponibles a partir de la tabla inventory
	
	select film_id, count(*) as Numero_dispo from inventory where store_id=2 group by film_id;
	
	with pelis_dispo as (select film_id, count(*) as Numero_dispo from inventory where store_id=2 group by film_id)
	select f.film_id, f.title as Titulo, numero_dispo from pelis_dispo d
	join film f on d.film_id=f.film_id;
	
--** Query 30. Obtener los actores y el numero de peliculas en las que han actuado. 
	
	select * from film_actor;
	select * from actor;
	
	with Numero_Pelis as  
	(select fa.actor_id, count(*) as Numero from film_actor fa group by fa.actor_id)
	select a.actor_id, a.first_name as Nombre, a.last_name as Apellido, Numero from actor a 
	join Numero_pelis np on a.actor_id=np.actor_id;
	
--** Query 31. Obtener todas las películas y mostrar los actores que han actuado en ellas, incluso si algunas películas no tienen actores asociados

	select * from film_actor;
	select * from actor;
	select * from film; --** Hay 1000 pelis
	select * from film_actor fa join actor a on a.actor_id=fa.actor_id; --** Hay 997 pelis distintas con actores identificados.
	select * from film f where film_id not in (select distinct fa.film_id from film_actor fa); --** Me da las 3 pelis que no tienen actor asignado
	select f.film_id, f.title, fa.actor_id from film f left join film_actor fa on fa.film_id=f.film_id;
	
	create temp table pelis_actores as
		select f.film_id, f.title, fa.actor_id from film f left join film_actor fa on fa.film_id=f.film_id;
	select pa.film_id, pa.title, pa.actor_id, a.first_name, a.last_name from pelis_actores pa join actor a on a.actor_id=pa.actor_id order by pa.film_id ;
	
--** Query 32. 	Obtener todos los actores y mostrar las películas en las que han actuado, incluso si algunos actores que no han actuado en ninguna película
	
	select * from film_actor;
	select * from actor; -- * Hay 200 actores.
	select * from film; -- * Hay 1000 peliculas
	
	select a.actor_id, a.first_name, a.last_name, fa.film_id from actor a left join film_actor fa on fa.actor_id=a.actor_id where a.actor_id in (select distinct fa.actor_id from film_actor fa); -- son todos los que estan en pelis. Todos han actuado.

	with Pelis_byactor as 
	(select a.actor_id, a.first_name, a.last_name, fa.film_id from actor a left join film_actor fa on fa.actor_id=a.actor_id where a.actor_id in (select distinct fa.actor_id from film_actor fa))
	select pba.actor_id, pba.first_name, pba.last_name, f.title from Pelis_byactor pba left join film f on f.film_id=pba.film_id;
	
--** Query 33.Obtener todas las películas que tenemos y todos los registros de alquiler
	
	select * from inventory;
	select * from rental;
	select * from film;
	
	select i.film_id, f.title, i.store_id, i.inventory_id, r.rental_date, r.customer_id, r.return_date, r.staff_id from inventory i join film f on i.film_id = f.film_id join rental r on i.inventory_id=r.inventory_id;
	
--** Query 34. Encuentra los 5 clientes que más dinero se hayan gastado con nosotros
	
	select * from customer;
	select distinct(customer_id) from customer; --** Hay 599 clientes distintos.
	select * from payment;
	
	 
	create temp table clientes_gasto as	
	select p.customer_id, sum(p.amount) as monto_total from payment p join customer c on p.customer_id=c.customer_id group by p.customer_id;
	
	select cg.customer_id, c.first_name, c.last_name, cg.monto_total from clientes_gasto cg left join customer c on cg.customer_id=c.customer_id order by monto_total desc limit 5;
	
--** Query 35. Selecciona todos los actores cuyo primer nombre es 'Johnny'.
	
	select * from actor;
	Select * from actor where first_name like 'JOHNNY%';
	
--** Query 36. Renombra la columna “first_nameˮ como Nombre y “last_nameˮ como Apellido
	
	alter table "actor" rename column "first_name" to "Nombre";	
	select * from actor;
	alter table "actor" rename column "last_name" to "Apellido";
	select * from actor;
	
--** Query 37.  Encuentra el ID del actor más bajo y más alto en la tabla actor
	
	select min(actor_id) as Más_bajo, max(actor_id) as Más_alto from actor;
	
--** Query 38.  Cuenta cuántos actores hay en la tabla “actorˮ
	
	select count(distinct(actor_id)) from actor; -- * Hay 200 actores.
	
--** Query 39. Selecciona todos los actores y ordénalos por apellido en orden ascendente.
	
	select * from actor;
	
	select * from actor order by "Apellido" desc ;
	
--** Query 40. Selecciona las primeras 5 peliculas de la tabla "film".

	select * from film;
		
	select * from film limit 5;
	
--** Query 41. Agrupa los actores por su nombre y cuenta cuántos actores tienen el mismo nombre. ¿Cuál es el nombre más repetido?
	
	select * from actor;
	
	select "Nombre", count(*) as Número_nombre from actor group by "Nombre" order by Número_nombre Desc; --* Los Nombres más repetidos son Kenneth, Penelope y Julia.
	
--** Query 42. Encuentra todos los alquileres y los nombres de los clientes que los realizaron.	
	
	select * from rental;
	select * from customer;
	
	create temp table rental_customer as
	select i.film_id, f.title, r.rental_date, r.customer_id from inventory i join film f on i.film_id = f.film_id join rental r on i.inventory_id=r.inventory_id;
	select rc.film_id, rc.title, rc.rental_date, rc.customer_id, c.first_name, c.last_name from rental_customer rc join customer c on rc.customer_id=c.customer_id;
	
--** Query 43. Muestra todos los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres.
	
	select * from rental;
	select count(distinct(customer_id)) from customer; -- Tenemnos 599 clientes distintos.
	select count(distinct(customer_id)) from rental; -- Tenemos 599 clientes distintos que alquilan.
	select distinct (customer_id) from customer where customer_id not in (select distinct(customer_id) from rental); --* no hay ningún cliente de la lista que no haya alquilado.
	
	select  rc.customer_id, c.first_name, c.last_name, rc.film_id, rc.title, rc.rental_date from rental_customer rc join customer c on rc.customer_id=c.customer_id order by customer_id asc;
	--* técnicamente es la misma consulta que la de la Query 42, dado que existe una relación 1:1 en los customer_id de ambas tablas.
	
--** Query 44.  Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor esta consulta? ¿Por qué? Deja después de la consulta la contestación
	
	select * from film;
	
	select * from category;
	
	select * from film cross join category;
	
	--** A mi modo de ver no aporta nada esta consulta. No entiendo que valor puede apoartar repetir el registro 16 veces, salvo que se vaya an a modificar algunos registros posteriormente sobre la misma pelicula 
	--** o que se vayan a filtrar mediante alguna cláusula. No se realiza ningún match entre las 2 tablas porque no tienen ningún elemento común. Además, ya tenemos una tabla con film_category
	
--** Query 45.  Encuentra los actores que han participado en películas de la categoría 'Action'.  
	
	select * from film_actor;
	select * from film_category;
	select * from category;
	select * from actor;
	
	select count(distinct(film_id)) from film_actor; --* Hay 997 pelis con actores.
	select count(distinct(film_id)) from film_category; -- * Hay 1000 pelis inventariadas con categorías. 
	
	--* Nos centramos en la tabla de los actores que hay hecho película. Creamos una tabla temporal de actores-categorías
	create temp table actor_categoria as
	select fa.actor_id, fa.film_id, fc.category_id from film_actor fa join film_category fc on fa.film_id=fc.film_id;
	
	--* Aprovechando la tabla y haciendo 2 join 1:1 con las tablas de actores (para nombre) y categorías (para acción) seleccionamos aquella que nos interesa. Hay varios registros con el mismo contenido
	select distinct(ac.actor_id, a."Nombre", a."Apellido"), c.name from actor_categoria ac join actor a on ac.actor_id=a.actor_id join category c on ac.category_id=c.category_id where c.name='Action';
	
--** Query 46. Encuentra todos los actores que no han participado en películas.
	
		select * from actor;
		select * from film_actor;
	
		select distinct(actor_id) from actor; --* Hay 200 actores distintos en registro de actores.
		select distinct(actor_id) from film_actor; --* Hay 200 actores distintos en registro de peliculas. Pero seran losmismos?
		
		select distinct(a.actor_id) from actor a where a.actor_id not in (select distinct(fa.actor_id) from film_actor fa);	--* No hay ningun actor inventariado que no haya participado en las pelis inventariadas.alter 
		select distinct(fa.actor_id) from film_actor fa where fa.actor_id not in (select distinct(a.actor_id) from actor a); -- * No hay ningún actor inventariado en peliculas que no esté inventariado en el registro de actores
	
		--* Por lo tanto según este análisis todos los actores han participado en las películas inventariadas.
	
--** Query 47. Selecciona el nombre de los actores y la cantidad de películas en las que han participado
		
		select * from actor;
		select * from film_actor;
		
		--* Ojo que renombramos los campos de la tabla Actor
		
		with Numero_Pelis as  
		(select fa.actor_id, count(*) as Numero from film_actor fa group by fa.actor_id)
		select a.actor_id, a."Nombre" as Nombre, a."Apellido" as Apellido, Numero from actor a 
		join Numero_pelis np on a.actor_id=np.actor_id;
		
--** Query 48. Selecciona el nombre de los actores y la cantidad de películas en las que han participado
		
		create temp table Numero_Pelis as  
		select fa.actor_id, count(*) as Numero from film_actor fa group by fa.actor_id;
		
		create view Numero_pelis_view (Id_actor, Nom_actor, Apell_actor, Núm_pelis) as
		select a.actor_id, a."Nombre" as Nombre, a."Apellido" as Apellido, Numero from actor a 
		join Numero_pelis np on a.actor_id=np.actor_id;
		
		select * from Numero_pelis_view;
		
--** Query 49. Calcula el número total de alquileres realizados por cada cliente.	
		
		select * from rental;
		select * from customer;
		select r.customer_id, c.first_name, c.last_name, count(*) as Num_ALquileres from rental r join customer c on r.customer_id=c.customer_id group by r.customer_id, c.first_name, c.last_name order by Num_Alquileres Desc;
		
--** Query 50. Calcula la duración total de las películas en la categoría 'Action'.
		
		select * from film;
		select * from film_category;
		
		select sum(length) from film f where f.film_id in (select fc.film_id from film_category fc where fc.category_id=1) ; --* La duración total es de 7.143 minutos.
		
--** Query 51. Crea una tabla temporal llamada “cliente_rentas_temporalˮ para almacenar el total de alquileres por cliente.	
		
		create temp table cliente_rentas_temporal as 
		select r.customer_id, c.first_name, c.last_name, count(*) as Num_ALquileres from rental r join customer c on r.customer_id=c.customer_id group by r.customer_id, c.first_name, c.last_name order by Num_Alquileres Desc;
		
		select * from cliente_rentas_temporal;
		
--** Query 52. 	Crea una tabla temporal llamada “peliculas_alquiladasˮ que almacene las películas que han sido alquiladas al menos 10 veces.	
		
		select * from rental;
		select * from inventory;
		
		create temp table peliculas_alquiladas as
		with rental_film as
		(select r.rental_id, i.inventory_id, i.film_id from rental r left join inventory i on r.inventory_id=i.inventory_id)
		select rf.film_id, f.title, count(*) as Núm_Alq from rental_film rf join film f on rf.film_id=f.film_id group by rf.film_id, f.title order by núm_alq desc limit 10;
		
		select * from peliculas_alquiladas ;
		
--** Query 53. 	Encuentra el título de las películas que han sido alquiladas por el cliente con el nombre ‘Tammy Sandersʼ y que aún no se han devuelto. Ordena los resultados alfabéticamente por título de película.
		
		select * from customer; 
		select * from inventory;
		
		select r.inventory_id, r.customer_id, i.film_id, f.title from rental r join inventory i on r.inventory_id=i.inventory_id join film f on f.film_id=i.film_id where return_date is null; 
		--** Hay 183 entradas de inventario en peliculas no devueltas.
	
		--** ahora hacemos la subconsulta
		
		select r.inventory_id, r.customer_id, i.film_id, f.title from rental r 
		join inventory i on r.inventory_id=i.inventory_id 
		join film f on f.film_id=i.film_id 
		where return_date is null and 
		r.customer_id=(select c.customer_id from customer c where c.first_name='TAMMY');
		
		--** DEVUELVE RESULTADO NULO. NO EXISTE NINGÚN CLIENTE CON ESE NOMBRE. SI CAMBIAMOS EL NOMBRE A POR EJEMPLO 'WENDY' SI ARROJA RESULTADOS
		
		select r.inventory_id, r.customer_id, i.film_id, f.title from rental r 
		join inventory i on r.inventory_id=i.inventory_id 
		join film f on f.film_id=i.film_id 
		where return_date is null and 
		r.customer_id=(select c.customer_id from customer c where c.first_name='WENDY');
	
		--** PODEMOS INCLUIR EL APELLIDO EN LA BÚSQUEDA POR SI HAY VARIOS NOMBRES IGUALES. 
		
--** Query 54. Encuentra los nombres de los actores que han actuado en al menos una película que pertenece a la categoría ‘Sci-Fiʼ. Ordena los resultados alfabéticamente por apellido	
		
		
		--* Aprovechamos una tabla temporal creada anteriormente en la Query nº 45
		
		select distinct(a."Apellido", a."Nombre"), c.name from actor_categoria ac join actor a on ac.actor_id=a.actor_id join category c on ac.category_id=c.category_id where c.name='Sci-Fi' order by row ;
		
--** Query 55.  Encuentra el nombre y apellido de los actores que han actuado en películas que se alquilaron después de que la película ‘Spartacus Cheaperʼ se alquilara por primera vez. Ordena los resultados alfabéticamente por apellido.
		
	select * from rental;
	select * from inventory;
	select * from film; 
	select * from film_actor;
	select * from actor;
		
	select film_id from film where title='SPARTACUS CHEAPER';
	
	select i.inventory_id from inventory i where i.film_id=(select f.film_id from film f where f.title='SPARTACUS CHEAPER');
		
	select min(r.rental_date) as Espartacus_first from rental r where r.inventory_id in (select i.inventory_id from inventory i where i.film_id=(select f.film_id from film f where f.title='SPARTACUS CHEAPER'));
	
	--* Creo una tabla temporal con el valor
	
	create temp table spartacus_first as 
	select min(r.rental_date) as Espartacus_first from rental r where r.inventory_id in (select i.inventory_id from inventory i where i.film_id=(select f.film_id from film f where f.title='SPARTACUS CHEAPER'));
	
	--*Me apoyo en dicho valor para sacar las pelis alquiladas despues, encadenando varias subconsultas
	
	select * from spartacus_first;
	
	select i.film_id from inventory i where i.inventory_id in (select r.inventory_id from rental r where r.rental_date > (select espartacus_first from spartacus_first));
	
	select distinct(fa.actor_id) from film_actor fa where fa.film_id in (select i.film_id from inventory i where i.inventory_id in (select r.inventory_id from rental r where r.rental_date >
	(select espartacus_first from spartacus_first)));
	
	select a."Nombre", a."Apellido" from actor a where a.actor_id in (select distinct(fa.actor_id) from film_actor fa where fa.film_id in 
	(select i.film_id from inventory i where i.inventory_id in (select r.inventory_id from rental r where r.rental_date >
	(select espartacus_first from spartacus_first)))) order by a."Apellido";
	
--** Query 56.  Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría ‘Musicʼ
	
	--* Apvechamos la query anterior, creando la tabla temporal
	
	create temp table actor_categoria as
	select fa.actor_id, fa.film_id, fc.category_id from film_actor fa join film_category fc on fa.film_id=fc.film_id;	
	select a."Nombre", a."Apellido", c.name from actor_categoria ac join actor a on ac.actor_id=a.actor_id join category c on ac.category_id=c.category_id where c.name <> 'Music' order by a."Nombre";
	
--** Query 57.  Encuentra el titulo de todas las peliculas alquiladas por más de 8 dias
	
	select * from inventory;
	select * from rental;
	select * from film;
	
	
	--*creamos un campo nuevo con el número de dias de alquiler
	
	alter table rental add column dias_alquilada interval;
	update rental set dias_alquilada = return_date - rental_date;
	
	select film_id, Title from film where film_id in (
	select film_id from inventory where inventory_id in (
	select inventory_id from rental where dias_alquilada > '8 days'));
	
--** Query 58.  Encuentra el titulo de todas las peliculas que son de la misma categoria que 'Animation'
	
	select * from film_category;
	select film_id from film where title = 'ANIMATION'; --* No hay ninguna pelicula con ese nombre
	select * from film order by title;
	
	select title from film where film_id in 
	(select film_id from film_category where category_id in (
	(select category_id from FILM_CATEGORY where film_id in
	(select film_id from film where title = 'CAUSE DATE'))));
	
--* Query 59.  Encuentra los nombres de las películas que tienen la misma duración que la película con el título ‘Dancing Feverʼ. Ordena los resultados alfabéticamente por título de película.
	
	select LENGTH from film where Title = 'DANCING FEVER';
	
	select film_id, title from film where length in (	select LENGTH from film where Title = 'DANCING FEVER') order by title asc;
	
--* Query 60.  Encuentra los nombres de los clientes que han alquilado al menos 7 películas distintas. Ordena los resultados alfabéticamente por apellido.
	
	select * from customer;
	
	select * from rental;
	
	select * from customer;
	
		create temp table peliculas_alquiladas as
		with rental_film as
		(select r.rental_id, r.customer_id, i.inventory_id, i.film_id from rental r left join inventory i on r.inventory_id=i.inventory_id)
		select rf.film_id, f.title, rf.customer_id, count(*) as Núm_Alq from rental_film rf join film f on rf.film_id=f.film_id group by rf.film_id, f.title, rf.customer_id;
		
		select * from peliculas_alquiladas where Núm_alq > 1 order by customer_id ; --* Hay algunos clientes que han alquilado peliculas 2 veces, por lo que el indice va a ser el film_id
		
		select * from peliculas_alquiladas;
		
		create temp table total_alquileres as
		(select customer_id, count(*) as Num_pelis from peliculas_alquiladas group by customer_id);
		
		select * from total_alquileres order by num_pelis asc; -- todos los clientes han alquilado más de 7 pelis distintas. Modificamos el ratio a 20
		select first_name, last_name from customer where customer_id in (select ta.customer_id from total_alquileres ta where num_pelis>20);
		
--*Query 61.  Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.

	
		select * from peliculas_alquiladas;
		
		select * from film_category;
		
		select * from category;
		
		
		create view peliculas_alquiladas_categoria (film_id,title,customer_id,num_alq,category_id) as 
		select pa.film_id,pa.title,pa.customer_id,pa.núm_alq,fc.category_id from peliculas_alquiladas pa join film_category fc on pa.film_id=fc.film_id;
		
		select pac.category_id, c.name, count(*) as conteo_pelis from peliculas_alquiladas_categoria pac join category c on pac.category_id=c.category_id group by pac.category_id, c.name ;
		
-- * Query 62. Encuentra el número de películas por categoría estrenadas en 2006.
		
		--* Creamos una vista intermedia con las peliculas por categoria y fechas de estreno
		
		select * from film;
		select * from film_category;
		select * from category;
		
		with pelis_categoria_estreno as 
		(select f.film_id, fc.category_id, c.name, f.release_year from film f join film_category fc on f.film_id=fc.film_id join category c on fc.category_id=c.category_id)
		select category_id, name, count (*) as num_category from pelis_categoria_estreno group by category_id, name;
		
-- * Query 63. Obtén todas las combinaciones posibles de trabajadores con las tiendas que tenemos
		
		select * from staff s ;
		select * from store; 
		
		select * from staff cross join store;
		
-- * Query 64. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas
		
		select * from inventory;
		select * from rental;
		select * from customer;
		
		select r.customer_id, c.first_name, c.last_name, count (*) as Número_alquileres from inventory i left join rental r on i.inventory_id=r.inventory_id left join customer c on c.customer_id=r.customer_id group by r.customer_id, c.first_name, c.last_name;
		
		
		
		