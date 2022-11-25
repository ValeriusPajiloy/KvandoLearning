-- Active: 1669274822137@@127.0.0.1@5432@demo@bookings
create temp table aircrafts_tmp AS
    select * from aircrafts with no data;

alter table aircrafts_tmp
    add PRIMARY key (aircraft_code);

alter table aircrafts_tmp
    add unique (model);

create temp table aircrafts_log AS
    select * from aircrafts with no data;

alter table aircrafts_log
    add column when_add timestamp;
alter table aircrafts_log
    add column operation text;

with add_row as 
(
    insert into aircrafts_tmp
        select * from aircrafts
        returning *
)
insert into aircrafts_log
    SELECT add_row.aircraft_code, add_row.model, add_row.range,
            current_timestamp, 'INSERT'
    from add_row;

select * from aircrafts_tmp order by model;

select * from aircrafts_log order by model;

with add_row as 
(
    insert into aircrafts_tmp
        values ('SU9','Сухой Суперджет-100', 3000)
        on conflict do nothing
        returning *
)
insert into aircrafts_log
    SELECT add_row.aircraft_code, add_row.model, add_row.range,
            current_timestamp, 'INSERT'
    from add_row;

with add_row as 
(
    insert into aircrafts_tmp
        values ('S99','Сухой Суперджет-100', 3000)
        on conflict(aircraft_code) do nothing
        returning *
)
insert into aircrafts_log
    SELECT add_row.aircraft_code, add_row.model, add_row.range,
            current_timestamp, 'INSERT'
    from add_row;

with add_row as 
(
    insert into aircrafts_tmp
        values ('SU9','Сухой Суперджет', 3000)
        on conflict on constraint aircrafts_tmp_pkey
        do update set model = excluded.model,
                      range = excluded.range
        returning *
)
insert into aircrafts_log
    SELECT add_row.aircraft_code, add_row.model, add_row.range,
            current_timestamp, 'INSERT'
    from add_row;

copy aircrafts_tmp from '/home/valeriy2000/Документы/aircrafts.txt';
copy aircrafts_tmp from '/home/valeriy2000/Документы/aircrafts.txt'
    with (format csv);

with update_row as (
    update aircrafts_tmp
        set range = range*1.2
        where model ~ '^Бом'
    RETURNING *
)
insert into aircrafts_log
    select ur.aircraft_code, ur.model, ur.range,
            current_timestamp, 'UPDATE'
    from update_row as ur;
    
select * from aircrafts_log
where model ~ '^Бом'
order by when_add;

create temp table tickets_directions as 
    select distinct departure_city, arrival_city from routes;

alter table tickets_directions
    add column last_ticket_time TIMESTAMP;

alter table tickets_directions
    add column tickets_num integer DEFAULT 0;

create temp table ticket_flights_tmp AS 
    select * from ticket_flights with no data;
    
alter table ticket_flights_tmp
    add primary key (ticket_no, flight_id);

with sell_tickets as (
    insert into ticket_flights_tmp
        (ticket_no, flight_id, fare_conditions, amount)
        values('1234586789012', 30829, 'Economy', 12800)
    returning *
)
update tickets_directions as td
    set last_ticket_time = current_timestamp,
        tickets_num = tickets_num+1
    where (td.departure_city, arrival_city) = (
        select departure_city, arrival_city
        from flights_v
        WHERE flight_id =(select flight_id from sell_tickets)
    );

select * from tickets_directions
where tickets_num>0;

with sell_tickets as (
    insert into ticket_flights_tmp
        (ticket_no, flight_id, fare_conditions, amount)
        values('1234586789012', 7757, 'Economy', 3400)
    returning *
)
update tickets_directions as td
    set last_ticket_time = current_timestamp,
        tickets_num = tickets_num+1
    from flights_v as f
    where td.departure_city = f.departure_city
    and td.arrival_city = f.arrival_city
    and f.flight_id = (select flight_id from sell_tickets);

select * from tickets_directions
where tickets_num>0;

with delete_row as(
    delete from aircrafts_tmp
    where model ~'^Бом'
    returning *
)
insert into aircrafts_log
    select dr.aircraft_code, dr.model, dr.range,
        current_timestamp, 'DELETE'
    from delete_row as dr;

select * from aircrafts_log
where model ~ '^Бом'
order by when_add;

with min_ranges AS(
    select aircraft_code,
        rank() over(
            partition by left(model, 6)
            order by range
        )as rank
    from aircrafts_tmp
    where model ~ '^Аэробус' or model ~ '^Боинг'
)
delete from aircrafts_tmp a
using min_ranges as mr
where a.aircraft_code = mr.aircraft_code
    and mr.rank = 1
returning *;

delete from aircrafts_tmp;
truncate aircrafts_tmp;

--Задание 1
create temp table aircrafts_log AS
    select * from aircrafts with no data;

alter table aircrafts_log
    add column when_add timestamp DEFAULT current_timestamp;
alter table aircrafts_log
    add column operation text;

with add_row as 
(
    insert into aircrafts_tmp
        select * from aircrafts
        returning *
)
insert into aircrafts_log
    (aircraft_code, model, range, operation)
    SELECT add_row.aircraft_code, add_row.model, add_row.range,
            'INSERT'
    from add_row;

with update_row as (
    update aircrafts_tmp
        set range = range*1.2
        where model ~ '^Бом'
    RETURNING *
)
insert into aircrafts_log
    (aircraft_code, model, range, operation)
    select ur.aircraft_code, ur.model, ur.range,
            'UPDATE'
    from update_row as ur;

with delete_row as(
    delete from aircrafts_tmp
    --where model ~'^Бом'
    returning *
)
insert into aircrafts_log
    (aircraft_code, model, range, operation)
    select dr.aircraft_code, dr.model, dr.range,
        'DELETE'
    from delete_row as dr;

--Задание 2
with add_row as 
(
    insert into aircrafts_tmp
        select * from aircrafts
        returning aircraft_code, model, range,
            current_timestamp, 'INSERT'
)
insert into aircrafts_log
    SELECT * from add_row;

--Задание 3
insert into aircrafts_tmp select * from aircrafts;
insert into aircrafts_tmp select * from aircrafts returning *;

--Задание 8

select  flight_no, flight_id, departure_city, arrival_city,scheduled_departure
from flights_v
where scheduled_departure BETWEEN bookings.now() and bookings.now() + interval '15 days'
and (departure_city, arrival_city) in (
    ('Красноярск','Москва'),
    ('Москва','Сочи'),
    ('Сочи','Москва'),
    ('Сочи','Красноярск')
)
order by departure_city, arrival_city, scheduled_departure;

with sell_tickets as(
    insert into ticket_flights_tmp
        (ticket_no, flight_id, fare_conditions, amount)
     values ('1234586789012', 27477, 'Economy', 3400),
            ('1234586789012', 60715, 'Economy', 3400),
            ('1234586789012', 61123, 'Economy', 3400),
            ('1234586789012', 60649, 'Economy', 3400),
            ('1234586789012', 61131, 'Economy', 3400)
    returning *
)
update tickets_directions as td
    set last_ticket_time = current_timestamp,
        tickets_num = tickets_num +
        (
            select count(*)
            from sell_tickets as st, flights_v as f
            WHERE st.flight_id = f.flight_id
            and f.departure_city = td.departure_city
            and f.arrival_city = td.arrival_city
        )
    WHERE (departure_city, arrival_city) in (
        SELECT departure_city, arrival_city
        from flights_v
        where flight_id in (select flight_id from sell_tickets)
    );

select 
    departure_city as dep_city,
    arrival_city as arr_city,
    last_ticket_time,
    tickets_num as num
from tickets_directions
where tickets_num>0
order by 1,2;

select * from ticket_flights_tmp;

--Задание 9

with aircrafts_seats as (
    select aircraft_code, model, seats_num,
    rank() over(
        partition by left(model, strpos(model, ' ')-1)
        order by seats_num
    )
    from (
        select a.aircraft_code, a.model, count(*) as seats_num
        from aircrafts_tmp as a, seats as s
        where a.aircraft_code = s.aircraft_code
        group by 1, 2
    ) as seats_numbers
)
delete from aircrafts_tmp as a
    using aircrafts_seats as a_s
    where a.aircraft_code = a_s.aircraft_code
        and left(a.model, strpos(a.model, ' ')-1) in ('Боинг', 'Аэробус')
        and a_s.rank = 1
    returning *;

create view aircrafts_seats as (
    select 
        a.aircraft_code,
        a.model,
        left(model, strpos(model, ' ')-1) as company,
        count(*) as seats_num
    from aircrafts as a, seats as s
    where a.aircraft_code = s.aircraft_code
    group by 1,2,3;
);
select * from aircrafts_seats;

with aircrafts_seats as (
    select aircraft_code, model, seats_num,
    rank() over( partition by company order by seats_num)
    from (
        select a.aircraft_code, a.model, count(*) as seats_num
        from aircrafts_tmp as a, seats as s
        where a.aircraft_code = s.aircraft_code
        group by 1, 2
    ) as seats_numbers
)
delete from aircrafts_tmp as a
    using aircrafts_seats as a_s
    where a.aircraft_code = a_s.aircraft_code
        and left(a.model, strpos(a.model, ' ')-1) in ('Боинг', 'Аэробус')
        and a_s.rank = 1
    returning *;


--Задание 10

create table seats_tmp as select * from seats;

insert into seats_tmp (aircraft_code, seat_no, fare_conditions)
    select aircraft_code, seat_row || letter, fare_conditions
    from (
        values
            ('SU9', 3, 20, 'F'),
            ('773', 5, 30, 'I'),
            ('763', 4, 25, 'H'),
            ('733', 3, 20, 'F'),
            ('320', 5, 25, 'F'),
            ('321', 4, 20, 'F'),
            ('319', 3, 20, 'F'),
            ('CN1', 0, 10, 'B'),
            ('CR2', 2, 15, 'D')
    )as aircraft_info (aircraft_code, max_seat_row_business,
                        max_seat_row_economy, max_letter)
    cross join 
        (values('Business'), ('Economy')) 
            as fare_conditions(fare_condition)
    cross join
        generate_series(1, 30) as seat_rows(seat_row)
    cross join 
        (values ('A'),('B'),('C'),('D'),('E'),('F'),('G'),('H'),('I')) 
        as letters( letter )
    where
        case when fare_condition = 'Business'
                then seat_row::integer<=max_seat_row_business
             when fare_condition = 'Economy'
                then seat_row::integer>max_seat_row_business
                and seat_row::integer>max_seat_row_economy
        end
        and letter <= max_letter;

