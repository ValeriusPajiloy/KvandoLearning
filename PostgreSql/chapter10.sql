-- Active: 1669274822137@@127.0.0.1@5432@demo@bookings
explain (costs off) select * 
from aircrafts;

explain (costs off) select * 
from aircrafts
where model ~ '^Аэр';

explain (costs off) select * 
from aircrafts
where model ~ '^Аэр'
order by aircraft_code;

explain select *
from bookings
order by book_ref;

explain select *
from bookings
where book_ref > '0000FF' and book_ref<'000FF'
order by book_ref;
