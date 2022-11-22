-- Active: 1669116588774@@127.0.0.1@5432@valeriy2000@testSch
create table aircrafts(
    aircraft_code char(3) not null,
    model text not null, 
    range integer not null,
    check (range >0),
    primary key (aircraft_code)
);

drop table aircrafts;

insert into aircrafts(
    aircraft_code,
    model,
    range
) values(
    'SU9',
    'Sukhi SuperJet-100',
    3000
);

select * from aircrafts;

insert into aircrafts
    (aircraft_code, model, range)
    values
    ('773', 'Boeing 777-300', 11100),
    ('763', 'Boeing 767-300', 7900),
    ('733', 'Boeing 737-300', 4200),
    ('320', 'Airbus A320-200', 5700),
    ('321', 'Airbus A321-200', 5600),
    ('319', 'Airbus A319-200', 6700),
    ('CN1', 'Cessna 208 Caravan', 1200),
    ('CR2', 'Bombardier CRJ-200', 2700);

select model, aircraft_code, range
from aircrafts
order by model;

select model, aircraft_code, range
from aircrafts
where range>=4000 and range <=6000;

update aircrafts set range = 3500
where aircraft_code = 'SU9';

select * from aircrafts where aircraft_code = 'SU9';

delete from aircrafts where aircraft_code = 'CN1'

delete from aircrafts where range > 10000 and range < 3000;

delete from aircrafts;

create table seats(
    aircraft_code char(3) not null,
    seat_no char(4) not null,
    fare_conditions text not null,
    check ( fare_conditions in ('Economy', 'Comfort', 'Business')),
    primary key (aircraft_code, seat_no),
    foreign key (aircraft_code)
        references aircrafts(aircraft_code)
        on delete cascade
);

insert into seats values ('123', '1A', 'Business');

insert into seats values 
    ('SU9', '1A', 'Business'),
    ('SU9', '1B', 'Business'),
    ('SU9', '10A', 'Economy'),
    ('SU9', '10B', 'Economy'),
    ('SU9', '10F', 'Economy'),
    ('SU9', '20F', 'Economy');

select count(*) from seats where aircraft_code = 'SU9';

select count(*) from seats where aircraft_code = 'CN1';

select aircraft_code, count(*) from seats
group by aircraft_code;

select aircraft_code, count(*) from seats
group by aircraft_code
order by count;

select aircraft_code, fare_conditions, count(*)
from seats 
group by aircraft_code, fare_conditions
order by aircraft_code, fare_conditions;

-- 2 задание
select * from aircrafts
order by range desc

-- 3 задание
update aircrafts set range = range * 2
where model = 'Sukhoi SuperJet';
-- 4 задание
delete from aircrafts
where model = "None";

