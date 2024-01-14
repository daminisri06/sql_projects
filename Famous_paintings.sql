Create database Famous_Paintings

select * from artist
select * from canvas_size
select * from image_link
select * from museum
select * from museum_hours
select * from product_size
select * from subject
select * from work

-- 1) Fetch all the paintings which are not displayed on any museums?

select * from work where museum_id is null;

-- 2) Are there museums without any paintings?
select m.museum_id, m.name from museum m 
Left Join work w on m.museum_id = w.museum_id 
where w.museum_id is null

-- 3) How many paintings have an asking price of more than their regular price? 

select * from product_size
where sale_price > regular_price

-- 4) Identify the paintings whose asking price is less than 50% of its regular price

select * from product_size
where sale_price < regular_price * 50/100

-- 5) Which canva size costs the most?

select Top 1 c.size_id, p.sale_price, p.regular_price, c.label from canvas_size c
Join Product_size p on c.size_id = p.size_id
Order by p.sale_price desc, p.regular_price desc

-- 6) Delete duplicate records from work, product_size, subject and image_link tables

delete from work
where work_id not in (select min(work_id) 
                       from work
					   group by name, artist_id)

delete from product_size
where work_id not in (select min(work_id) 
                       from product_size
					   group by work_id)

delete from subject
where work_id not in (select min(work_id) 
                       from subject
					   group by work_id, subject)


delete from image_link
where work_id not in (select min(work_id) 
                       from image_link
					   group by work_id)

-- 7) Identify the museums with invalid city information in the given dataset

select museum_id,name, city from museum
where try_cast(city as int) is not null;

-- 8) Museum_Hours table has 1 invalid entry. Identify it and remove it.

select * from museum_hours 
where day not in ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday')

delete from museum_hours 
where day in ('Thusday')

-- 9) Fetch the top 10 most famous painting subject

select top 10 subject, count(1) as top_subjects from subject s
join work w on s.work_id = w.work_id
Group by subject
order by top_subjects desc

-- 10) Identify the museums which are open on both Sunday and Monday. Display museum name, city.

select md.museum_id, md.city, md.name 
from museum md
join museum_hours mh on md.museum_id = mh.museum_id
where mh.day in ('Sunday', 'Monday')
group by md.museum_id, md.city, md.name 
having count(distinct mh.day) = 2

-- 11) How many museums are open every single day?

select md.museum_id, md.name 
from museum md
join museum_hours mh on md.museum_id = mh.museum_id
where mh.day in ('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday')
group by md.museum_id, md.name 
having count(distinct mh.day) = 7

-- 12) Which are the top 5 most popular museum? (Popularity is defined based on most no of paintings in a museum)

select top 5 md.museum_id, md.name as museum_name, count(w.name) as no_of_paintings
from museum md
join work w on md.museum_id = w.museum_id
group by md.museum_id, md.name 
Order by count(w.name) desc


-- 13) Who are the top 5 most popular artist? (Popularity is defined based on most no of paintings done by an artist)

select top 5 a.artist_id, a.full_name, count(w.name) as no_of_paintings
from artist a
join work w on a.artist_id = w.artist_id
group by a.artist_id, a.full_name 
Order by count(w.name) desc

-- 14) Display the 3 least popular canva sizes

select label, rnk, no_of_paintings
    from (
	     select c.size_id, c.label, count(1) as no_of_paintings,
		 dense_rank() over(order by count(1)) as rnk
		 from work w
		 join product_size p on w.work_id = p.work_id
		 join canvas_size c on c.size_id = p.work_id
		 group by c.size_id, c.label) x
		 where x.rnk <= 3

-- 15) Which museum has the most no of most popular painting style?

select top 1 md.museum_id, w.style, md.name as museum_name, count(1) as no_of_paintings
from museum md
join work w on md.museum_id = w.museum_id
group by md.museum_id, w.style, md.name 
Order by count(1) desc

-- 16) Identify the artists whose paintings are displayed in multiple countries

with cte as(
select distinct a.full_name, m.country
from artist a
Join work w on a.artist_id = w.artist_id
Join museum m on m.museum_id = w.museum_id
)

select full_name, count(1) as countries from cte
group by full_name
having count(1) > 1
order by countries desc

/* 17) Display the country and the city with most no of museums. Output 2 seperate columns to 
mention the city and country. If there are multiple value, seperate them with comma.*/

With museum_counts as(
   select city, country, count(*) as mus_counts,
   rank() over(order by count(*) desc) as rnk
   from museum
   group by city, country)

select city, country from museum_counts
where rnk = 1

-- 18) Which country has the 5th highest no of paintings?


Select top 5 m.country, count(1) as no_of_paintings
from museum m
Join work w on m.museum_id = w.museum_id
Group by m.country 
Order by count(1) desc

-- or

with cte_country as 
     (select m.country, count(1) as no_of_paintings,
	 rank() over (order by count(1) desc) rnk
	 from museum m
     Join work w on m.museum_id = w.museum_id
     Group by m.country) 

Select country, no_of_paintings from cte_country
where rnk = 5 

-- 19) Which are the 3 most popular and 3 least popular painting styles?

with pop as(
   select style, count(1) as counts,
   rank() over (Order by count(1) desc) rnk,
   count(1) over () as records
   from work
   where style is not null
   group by style
   )
select style,
case when rnk <= 3 then 'Most popular' else 'Least popular'
end as popularity
from pop 
where rnk <= 3 or rnk > records - 3;

-- 20) Which artist has the most no of Portraits paintings outside USA?. Display artist name, no of paintings and the artist nationality.

Select top 1 a.artist_id, a.full_name, a.nationality, count(1) as no_of_paintings
from work w
join artist a on a.artist_id=w.artist_id
join subject s on s.work_id=w.work_id
join museum m on m.museum_id=w.museum_id
where s.subject = 'Portraits' and m.country <> 'USA'
Group by a.artist_id, a.full_name, a.nationality
Order by count(1) desc
