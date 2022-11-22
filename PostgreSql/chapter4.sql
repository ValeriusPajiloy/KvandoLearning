-- Active: 1669116588774@@127.0.0.1@5432@valeriy2000@public
create table databases (is_open_source boolean, dbms_name text);
 
insert into databases values (true, 'PostgreSQL');
insert into databases values(false, 'Oracle');
insert into databases values (true, 'MySql');
insert into databases values(false, 'Ms SQL Server');

select * from databases where is_open_source;

create table pilots
(
    pilot_name text,
    schedule integer[]
);

insert into pilots
    values ('Ivan', '{1,3,5,6,7}'::integer[]),
           ('Petr', '{1,2,5,7}'::integer[]),
           ('Pavel', '{2,5}'::integer[]),
           ('Boris', '{3,5,6}'::integer[]);

update pilots   
    set schedule = schedule || 7 
    where pilot_name = 'Boris';

update pilots
    set schedule = array_append(schedule, 6)
    where pilot_name = 'Pavel';

update pilots
    set schedule = array_prepend(1, schedule)
    where pilot_name = 'Pavel';
    

update pilots
    set schedule = array_remove(schedule, 5)
    where pilot_name = 'Ivan';
 
update pilots
    set schedule[1] = 2, schedule[2] = 3
    where pilot_name = 'Petr'; 

update pilots
    set schedule[1:2] = array[2,3]
    where pilot_name = 'Petr'; 

select * from pilots
where array_position(schedule, 3) is not null;

select * from pilots
    where schedule @> '{1,7}'::integer[];

select * from pilots
    where schedule && array[2, 5];

select * from pilots
    where not (schedule && array[2, 5]);
    
 
select unnest( schedule ) as days_of_week
    from pilots
    where pilot_name = 'Ivan';

create table pilot_hobbies
(
    pilot_name text,
    hobbies jsonb
);

insert into pilot_hobbies
    values
        ( 'Ivan',
          '{"sports": ["футбол", "плавание"]}, "home_lib": true, "trips": 3}'::jsonb
        ),
        ( 'Petr',
          '{"sports": ["теннис", "плавание"]}, "home_lib": true, "trips": 2}'::jsonb
        ),
        ( 'Pavel',
          '{"sports": ["плавание"]}, "home_lib": false, "trips": 4}'::jsonb
        ),
        ( 'Boris',
          '{"sports": ["футбол", "плавание", "теннис"]}, "home_lib": true, "trips": 0}'::jsonb
        );

select * from pilot_hobbies
    where hobbies @> '{"sports": ["футбол"]}'::jsonb;


select pilot_name, hobbies->'sports' as sports
    from pilot_hobbies
    where hobbies->'sports' @> '["футбол"]'::jsonb;

update pilot_hobbies
    set hobbies = hobbies ||'{"sports":["хоккей"]}'
    where pilot_name = 'Boris';

--задание 1
create table test_numeric
(
    measurement numeric(5,2),
    description text
);
insert into test_numeric
    values (999.9999, 'Some numeric ');
insert into test_numeric
    values (999.9009, 'Someone else numeric ');
insert into test_numeric
    values (999.1111, 'Some numeric new');
insert into test_numeric
    values (999.9999, 'and some one');
insert into test_numeric
    values (123456.123, 'wrong');

--задание 2
drop table test_numeric
create table test_numeric
(
    measurement numeric,
    description text
);
insert into test_numeric
    values (1234567890.0987654321, 'Точность 20, масштаб 10');
insert into test_numeric
    values (0.12345678900987654321, 'Точность 21, масштаб 1');
insert into test_numeric
    values (1.5, 'Точность 2, масштаб 1');
insert into test_numeric
    values (1234567890, 'Точность 10, масштаб 0');

select * from test_numeric;

--задание 3
select 'NaN'::numeric = 'NaN'::numeric;
select 'NaN'::numeric > 9999999999.9999999999; 

--задание 7
create table test_serial
(
    id serial,
    name text
);
insert into test_serial(name) values("test1");
insert into test_serial(name) values("test2");
insert into test_serial(name) values("test3");
insert into test_serial(id, name) values(10, "test3");
insert into test_serial(name) values("test4");

--задание 8
drop table test_serial;
create table test_serial
(
    id serial PRIMARY KEY,
    name text
);
insert into test_serial(name) values("test1");
insert into test_serial(name) values("test2");
insert into test_serial(name) values("test3");
insert into test_serial(id, name) values(10, "test4");
insert into test_serial(name) values("test5");
