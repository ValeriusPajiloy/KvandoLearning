-- Active: 1669116588774@@127.0.0.1@5432@valeriy2000@testSch

select * from aircrafts where model like 'Airbus%';

select * from aircrafts
where model not like 'Airbus%'
  and model not like 'Boeing%';

select * from airports;
select * from airports where airport_name like '___';

select * from aircrafts where model ~ '(A|Boe)';

select * from aircrafts where model !~ '300$';

select * from aircrafts where range between 3000 and 6000;

select 
    model,
    range,
    range / 1.609 as miles
from aircrafts;

select 
    model,
    range,
    round(range / 1.609, 2) as miles
from aircrafts;

select * from aircrafts
order by range desc;

select timezone from airports;

select distinct timezone from airports order by 1;

select 
    airport_name,
    city,
    longitude
from airports
order by longitude DESC
limit 3;

select 
    airport_name,
    city,
    longitude
from airports
order by longitude DESC
limit 3
offset 3;

select 
    model, 
    range,
    case when range<2000 then 'ближнемагистральный'
         when range<5000 then 'среднемагистральный'
         else 'дальнемагистральный'
         end as n
from aircrafts
order by model;

select 
    a.aircraft_code,
    a.model,
    s.seat_no,
    s.fare_conditions_code
from seats as s
join aircrafts as a on s.aircraft_code = a.aircraft_code
where a.model ~ '^Cessna'
order by s.seat_no; 

select 
    s.seat_no as seat_no,
    s.fare_conditions_code as fare_conditions_code
from seats as s
join aircrafts as a on s.aircraft_code = a.aircraft_code
where a.model ~'^Cessna'
ORDER BY s.seat_no;  

select 
    a.aircraft_code as aircraft_code,
    a.model as model,
    s.seat_no as seat_no,
    s.fare_conditions_code as fare_conditions_code
from seats s, aircrafts a
where s.aircraft_code = a.aircraft_code and a.model ~'^Cessna'
ORDER BY s.seat_no;  

drop view flights_v;
create or replace view flights_v as 
select 
    f.flight_id,
    f.flight_no,
    f.scheduled_departure,
    timezone(dep.timezone, f.scheduled_departure) as scheduled_departure_local,
    f.scheduled_arrival,
    timezone(dep.timezone, f.scheduled_arrival) as scheduled_arrival_local, 
    f.scheduled_arrival - f.actual_departure as scheduled_duration,
    f.departure_airport,
    dep.airport_name as departure_airport_name,
    dep.city as departure_city,
    f.arrival_airport,
    arr.airport_name as arrival_airport_name,
    arr.city as arrival_city,
    f.status,
    f.aircraft_code,
    f.actual_departure,
    timezone(dep.timezone, f.actual_departure) as actual_departure_local,
    f.actual_arrival,
    timezone(dep.timezone, f.actual_arrival) as actual_arrival_local,
    f.actual_arrival - f.actual_departure as actual_duration
from flights f, airports dep, airports arr
where f.departure_airport = dep.airport_code
  and f.arrival_airport = arr.airport_code;

select * from flights_v;

select count(*)
    from airports a1, airports a2
    where a1.city <> a2.city;

select count(*)
    from airports a1
    join airports a2 on a1.city <> a2.city;

select count(*)
    from airports a1 cross join airports a2
    where a1.city <> a2.city;


select count(*)
from (ticket_flights t 
        join flights f on t.flight_id = f.flight_id
        )
    left JOIN boarding_passes b on t.ticket_no = b.ticket_no and t.flight_id = b.flight_id
where f.actual_departure is not null and b.flight_id is null;

select 
    f.flight_no,
    f.scheduled_departure,
    f.flight_id,
    f.departure_airport,
    f.arrival_airport,
    f.aircraft_code,
    t.passenger_name,
    tf.fare_conditions_code as fc_to_be,
    s.fare_conditions_code as fc_to_fact,
    b.seat_no
from boarding_passes as b
join ticket_flights as tf on b.ticket_no = tf.ticket_no and b.flight_id = tf.flight_id
join tickets as t on tf.ticket_no = t.ticket_no
join flights as f on tf.flight_id = f.flight_id
join seats as s on b.seat_no = s.seat_no and f.aircraft_code = s.aircraft_code
where tf.fare_conditions_code <> s.fare_conditions_code
order by f.flight_no, f.scheduled_departure;

update boarding_passes
    set seat_no = '1A'
    where flight_id = 1 and seat_no = '17A';

select r.min_sum, r.max_sum, count(b.*)
from bookings as b 
right join (values (0, 100000),
                   (100000, 200000),
                   (200000, 300000),
                   (300000, 400000),
                   (400000, 500000),
                   (500000, 600000),
                   (600000, 700000),
                   (700000, 800000),
                   (800000, 900000),
                   (900000, 1000000),
                   (1000000, 1100000),
                   (110000, 1200000),
                   (1200000, 1300000)
)as r(min_sum, max_sum)
on b.total_amount>= r.min_sum and b.total_amount<r.max_sum
group by r.min_sum, r.max_sum
order by r.min_sum;

select avg(total_amount) from bookings;
select max(total_amount) from bookings;
select min(total_amount) from bookings;

select departure_city, count(*)
from routes
group by departure_city
having count(*) >= 15
order by count desc;

select city, count(*)
from airports
group by city
having count(*) > 1;

select 
    b.book_ref,
    b.book_date,
    extract('month' from b.book_date) as month,
    extract('day' from b.book_date) as day,
    count(*) over (
        partition by date_trunc('month', b.book_date)
        order by b.book_date
    )as count
from ticket_flights as tf
join tickets as t on tf.ticket_no = t.ticket_no
join bookings as b on t.book_ref = b.book_ref
where tf.flight_id = 1
order by b.book_date;

select 
    airport_name,
    city,
    latitude,
    timezone,
    first_value(latitude) over tz as first_in_timezone,
    latitude - first_value(latitude) over tz as delta,
    rank() over tz
from airports
where timezone in ('Asia/Irkutsk', 'Asia/Krasnoyarsk')
window tz as (partition by timezone order by latitude desc)
order by timezone, rank;

select 
    airport_name,
    city,
    longitude
from airports
where longitude in (
    (select max(longitude) from airports),
    (select min(longitude) from airports)
)
order by longitude;
SELECT * from fare_conditions;
select a.model,
    (select count(*) from seats as s
     where s.aircraft_code = a.aircraft_code
       and s.fare_conditions_code = 2) as business,
    (select count(*) from seats as s
     where s.aircraft_code = a.aircraft_code
       and s.fare_conditions_code = 3) as comfort,
    (select count(*) from seats as s
     where s.aircraft_code = a.aircraft_code
       and s.fare_conditions_code = 1) as economy
from aircrafts as a
order by 1;


select
    s2.model,
    string_agg(
        fc.fare_conditions_name || '('|| s2.num || ')',
        ', '
    ) 
from(
    select a.model,
        s.fare_conditions_code,
        count(*) as num
    from aircrafts as a
    join seats as s on a.aircraft_code = s.aircraft_code
    group by 1, 2
    order by 1, 2) AS s2
join fare_conditions as fc on fc.fare_conditions_code = s2.fare_conditions_code
group by s2.model
order by s2.model;

select aa.city, aa.airport_code, aa.airport_name
from (
    select city, count(*)
    from airports
    group by city 
    having count(*) > 1
)as a
join airports as aa on a.city = aa.city
order by aa.city, aa.airport_name;

select 
    ts.flight_id,
    ts.flight_no,
    ts.scheduled_departure_local,
    ts.departure_city,
    ts.arrival_city,
    a.model,
    ts.fact_passengers,
    ts.total_seats,
    round(ts.fact_passengers::numeric / ts.total_seats::numeric, 2) as fraction
from (
    select 
        f.flight_id,
        f.flight_no,
        f.scheduled_departure_local,
        f.departure_city,
        f.arrival_city,
        f.aircraft_code,
        count( tf.ticket_no ) as fact_passengers,
        (select count(s.seat_no)
         from seats as s
         where s.aircraft_code = f.aircraft_code
        ) as total_seats
    from flights_v as f
    join ticket_flights as tf on f.flight_id = tf.flight_id
    where f.status = 'Arrived'
    group by 1, 2, 3, 4, 5, 6 
) as ts
join aircrafts as a on ts.aircraft_code = a.aircraft_code
order by ts.scheduled_departure_local;

with ts as (
select 
    f.flight_id,
    f.flight_no,
    f.scheduled_departure_local,
    f.departure_city,
    f.arrival_city,
    f.aircraft_code,
    count( tf.ticket_no ) as fact_passengers,
    (select count(s.seat_no)
        from seats as s
        where s.aircraft_code = f.aircraft_code
    ) as total_seats
from flights_v as f
join ticket_flights as tf on f.flight_id = tf.flight_id
where f.status = 'Arrived'
group by 1,2,3,4,5,6
)
select 
    ts.flight_id,
    ts.flight_no,
    ts.scheduled_departure_local,
    ts.departure_city,
    ts.arrival_city,
    ts.aircraft_code,
    ts.fact_passengers,
    ts.total_seats,
    round(ts.fact_passengers::numeric / ts.total_seats::numeric, 2) as fraction
from ts
join aircrafts as a on ts.aircraft_code = a.aircraft_code
order by ts.scheduled_departure_local;

with recursive ranges (min_sum, max_sum) as 
(values (0, 100000)
    union ALL
    select min_sum + 100000, max_sum + 100000
    from ranges
    where max_sum < (select max(total_amount) from bookings)
)
select * from ranges;

with recursive ranges (min_sum, max_sum) as 
(values (0, 100000)
    union ALL
    select min_sum + 100000, max_sum + 100000
    from ranges
    where max_sum < (select max(total_amount) from bookings)
)
select 
    r.min_sum, r.max_sum, count(b.*)
from bookings as b
right join ranges as r on b.total_amount >= r.min_sum
                    and b.total_amount < r.max_sum
GROUP BY r.min_sum, r.max_sum
order by r.min_sum;

create materialized view routes as 
    with f3 as (
        select 
            f2.flight_no,
            f2.departure_airport,
            f2.arrival_airport,
            f2.aircraft_code,
            f2.duration,
            array_agg(f2.days_of_week)as days_of_week
        from (
            select 
                f1.flight_no,
                f1.departure_airport,
                f1.arrival_airport,
                f1.aircraft_code,
                f1.duration,
                f1.days_of_week
            from (
                select 
                    flights.flight_no,
                    flights.departure_airport,
                    flights.arrival_airport,
                    flights.aircraft_code,
                    (flights.scheduled_arrival - flights.scheduled_departure)as duration,
                    (to_char(flights.scheduled_departure, 'ID'::text))::integer as days_of_week
                from flights
            ) as f1
            group by f1.flight_no, f1.departure_airport, f1.arrival_airport, f1.aircraft_code, f1.duration, f1.days_of_week            
            order by f1.flight_no, f1.departure_airport, f1.arrival_airport, f1.aircraft_code, f1.duration, f1.days_of_week            
        ) as f2
        group by f2.flight_no, f2.departure_airport, f2.arrival_airport, f2.aircraft_code, f2.duration            
    )
    select 
        f3.flight_no,
        f3.departure_airport,
        dep.airport_name as departure_airport_name,
        dep.city as departure_city,
        f3.arrival_airport,
        arr.airport_name as arrival_airport_name,
        arr.city as arrival_city,
        f3.aircraft_code,
        f3.duration,
        f3.days_of_week
    from f3, airports as dep, airports as arr
    where f3.departure_airport = dep.airport_code
    and f3.arrival_airport   = arr.airport_code;

    refresh MATERIALIZED view routes;
    SELECT * from routes;