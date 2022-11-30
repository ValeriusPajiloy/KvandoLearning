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

EXPLAIN SELECT count(*)
    from seats
where aircraft_code = 'SU9';

explain select avg(total_amount)
from bookings;

EXPLAIN select a.aircraft_code
    a.model,
    s.seat_no,
    s.fdare_cpnditions
from seats as s
join aircrafts as a on s.aircraft_code = a.aircraft_code
where a.model ~ '^Аэр'
order by s.seat_no; 

EXPLAIN select 
    r.flight_no,
    r.departure_airport_name,
    r.arrival_airport_name,
    a.model
from routes as r
join aircrafts as a on r.aircraft_code = a.aircraft_code
order by flight_no;

explain select 
    t.ticket_no,
    t.passenger_name,
    tf.flight_id,
    tf.amount
from tickets as t
join ticket_flights as tf on t.ticket_no = tf.ticket_no
order by t.ticket_no;

set enable_hashjoin = off;
set enable_mergejoin = off;
set enable_nestloop = off;
set enable_mergejoin = off;
set enable_nestloop = on;
set enable_hashjoin = on;

explain select 
    t.ticket_no,
    t.passenger_name,
    tf.flight_id,
    tf.amount
from tickets as t
join ticket_flights as tf on t.ticket_no = tf.ticket_no
order by t.ticket_no;

set enable_mergejoin = on;

explain analyze
select 
    t.ticket_no,
    t.passenger_name,
    tf.flight_id,
    tf.amount
from tickets as t
join ticket_flights as tf on t.ticket_no = tf.ticket_no
order by t.ticket_no;

explain 
select 
    t.ticket_no,
    t.passenger_name,
    tf.flight_id,
    tf.amount
from tickets as t
join ticket_flights as tf on t.ticket_no = tf.ticket_no
where amount > 50000
order by t.ticket_no;

EXPLAIN (analyze, costs off) 
select 
    a.aircraft_code,
    a.model,
    s.seat_no,
    s.fare_conditions
from seats as s
join aircrafts as a on s.aircraft_code = a.aircraft_code
where a.model ~ '^Аэр'
order by s.seat_no; 

begin;

EXPLAIN (analyze, costs off)
    update aircrafts
        set range = range + 100
        where model ~ '^Аэр';

ROLLBACK;

analyze aircrafts;

explain analyze
select num_tickets, count(*) as num_bookings
from (
    select b.book_ref,
    (
        select count(*)from tickets as t
        where t.book_ref = b.book_ref
    )
    from bookings as b
    where date_trunc('mon', book_date) = '2016-09-01'
) as count_tickets (book_ref, num_tickets)
group by num_tickets
order by num_tickets desc;

create index tickets_book_ref_key
on tickets (book_ref);

explain analyze
select num_tickets, count(*) as num_bookings
from (
    select b.book_ref, count(*)
    from bookings as b, tickets as t
    where date_trunc('mon', book_date) = '2016-09-01'
    and t.book_ref = b.book_ref
    group by b.book_ref
) as count_tickets (book_ref, num_tickets)
group by num_tickets
order by num_tickets desc;

