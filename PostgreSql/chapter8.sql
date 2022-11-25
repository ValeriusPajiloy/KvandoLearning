-- Active: 1669274822137@@127.0.0.1@5432@demo@bookings
 create index on airports (airport_name);

 SELECT count(*) from tickets
 where passenger_name = 'IVAN IVANOV';
 create index passenger_name on tickets (passenger_name);

 drop index passenger_name;

 create index tickets_book_ref
 on tickets(book_ref); 

SELECT *
from tickets
order by book_ref
limit 5;

drop index tickets_book_ref;

create unique index aircrafts_unique_model_key on aircrafts(lower(model));

select *
    from bookings
    where total_amount > 1000000
    order by book_date desc;

create index bookings_book_date_part_key
    on bookings (book_date)
    where total_amount > 1000000;