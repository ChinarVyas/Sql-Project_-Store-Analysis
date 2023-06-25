--Q1: Who is the most senior most employee in the table?
select* from employee 
order by levels desc
limit 1

--Q2: which country has most invoices?
select count(*) as c, billing_country from invoice 
group by billing_country
order by c desc
--Q3: what are top 3 valuesof total invoices.

select total from invoice
order by total desc
limit 3

--Q4 : which city has the best customers? the music store would like to throw a party as they made most money. write a query 
--that return the one city return city name and the sum of all invoices?
Select sum(total) as invoice_total, billing_city 
from invoice
group by billing_city
order by invoice_total desc

select* from customer

--Q5: Who is the best customer? the customer who has spent the most will be declared the bet customer. 
--Write a query that returns the person who has spent most money?

select customer.customer_id, customer.first_name, customer.last_name, sum(invoice.total) as total
from customer
join invoice on customer.customer_Id = invoice.customer_id
group by customer.customer_id
order by total desc
limit 1 


--Q6 write a query to return the email, firstname, last name, genre of all rock music lovers.
--return your list alphabetically by email starting with A

select distinct email,first_name, last_name from customer
join invoice on customer.customer_id  = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
where track_id IN(
	select track_id from track
	join genre on track.genre_id = genre.genre_id
	where genre.name like 'Rock'
)
order by email;

--Q7. Lets invite the artist who has written most rock music in our dataset.
--write a query that returns the artist name and the total track count of the top 10 rock bands

select artist.artist_id, artist.name, count(artist.artist_id) As number_of_songs
from track
join album on album.album_id = track.album_id
join artist on artist.artist_id = album.artist_id
join genre on genre.genre_id = track.genre_id
where genre.name = 'Rock'
group by artist.artist_id
order by number_of_songs desc
limit 10

--08 return all track names that have a song length longer than the average song length. return name, milliseconds for the track
-- order by song length with longest song listed 1st?

select * from track

select name, milliseconds 
from track 
where milliseconds > ( 
	select avg(milliseconds) as avg_time 
	from track)
order by milliseconds desc;

--09find out how much amt spend by each customer on the artist write a query to return customer name,artist name,total spent.

with best_selling_artist as(
select artist.artist_id as artist_id, artist.name as artist_name,  sum(invoice_line.unit_price * invoice_line.quantity)as total_sales
from invoice_line
join track on track.track_id = invoice_line.track_id
join album on album.album_id = track.album_id
join artist on artist.artist_id = album.artist_id
group by 1
order by 3 desc
limit 1
)
select c.customer_id,c.first_name, c.last_name,bsa.artist_name,
sum (il.unit_price * il.quantity) as amount_spent
from invoice i
join customer c on c.customer_id = i.customer_id
join invoice_line il on il.invoice_id = i.invoice_id
join track t on t.track_id = il.track_id
join album alb on alb.album_id = t.album_id
join best_selling_artist bsa on bsa.artist_id = alb.artist_id
group by 1,2,3,4
order by 5 desc;
