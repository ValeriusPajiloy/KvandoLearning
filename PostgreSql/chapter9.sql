-- Active: 1669274822137@@127.0.0.1@5432@demo@bookings
create temp table aircrafts_tmp AS
    select * from aircrafts with no data;
insert into aircrafts_tmp
    select * from aircrafts;

update aircrafts_tmp
set range = 100
where aircraft_code = 'SU9';

create table modes(
    num integer,
    mode text
);

insert into modes values (1, 'LOW'), (2, 'HIGH');

update modes
    set mode = 'HIGH'
    where mode = 'LOW'
    returning *;
update modes
    set mode = 'LOW'
    where mode = 'HIGH'
    returning *;

insert into  bookings (book_ref, book_date, total_amount)
    values ('ABC123', bookings.now(), 0);


insert into tickets (ticket_no, book_ref,passenger_id, passenger_name)
    values ('9991234567890','ABC123', '1234 123456', 'IVAN PETROV');

insert into tickets (ticket_no, book_ref,passenger_id, passenger_name)
    values ('9991234567891','ABC123', '4321 654321', 'PETR IVANOV');

insert into ticket_flights
    (ticket_no, flight_id, fare_conditions, amount)
values ('9991234567890', 5572, 'Business', 12500),
       ('9991234567891', 13881, 'Economy', 8500);

update bookings 
    set total_amount = (
        select sum(amount)
        from ticket_flights
        where ticket_no in (
            SELECT ticket_no 
            from tickets
            where book_ref = 'ABC123'
        )
    )
where book_ref = 'ABC123';

select *
from bookings
where book_ref = 'ABC123';

select * 
from aircrafts_tmp
where model ~ '^Аэр'
for update;

update aircrafts_tmp
    set range = 5800
    where aircraft_code = '320';

begin transaction isolation level serializable;

lock table aircrafts_tmp 
    in access exclusive mode;

end;
commit;
