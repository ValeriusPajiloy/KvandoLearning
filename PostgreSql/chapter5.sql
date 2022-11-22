-- Active: 1669116588774@@127.0.0.1@5432@valeriy2000@testSch
create table progress
(
    mark numeric(1) default 5,
    term numeric(1) check(term=1 or term =2),
    mark numeric(1) check(mark>=3 and mark<= 5),
    constraint valid_mark check (mark >=3 and mark<=5)
);
create table progress
(
    mark numeric(1) default 5,
    term numeric(1) check(term=1 or term =2),
    mark numeric(1),
    constraint valid_mark check (mark >=3 and mark<=5)
);
create table student
(
    record_book numeric(5) unique
);
create table student
(
    record_book numeric(5),
    constraint unique_record_book unique(record_book)
);
create table student
(
    doc_ser numeric(4),
    doc_num numeric(6),
    constraint unique_record_book unique(doc_ser, doc_num)
);
create table student
(
    record_book numeric(5) primary key
);
create table student
(
    record_book numeric(5),
    primary key(record_book)
);
create table progress
(
    record_book numeric(5) references students(record_book)
);
create table progress
(
    record_book numeric(5) references students
);
create table progress
(
    record_book numeric(5),
    Foreign Key (record_book) REFERENCES students (record_book)
);
create table progress
(
    record_book numeric(5),
    Foreign Key (record_book) REFERENCES students (record_book)
    on delete cascade
);
create table progress
(
    record_book numeric(5),
    Foreign Key (record_book) REFERENCES students (record_book)
    on delete restrict
);
create table progress
(
    record_book numeric(5),
    Foreign Key (record_book) REFERENCES students (record_book)
    on delete set null
);
create table progress
(
    record_book numeric(5) default 123456,
    Foreign Key (record_book) REFERENCES students (record_book)
    on delete set default
);
create table progress
(
    record_book numeric(5),
    Foreign Key (record_book) REFERENCES students (record_book)
    on update cascade
);

create table students
(
    record_book numeric(5) not null,
    name text not null, 
    doc_ser numeric(4),
    doc_num numeric(6),
    primary key (record_book);
);
create table progress
(
    record_book numeric(5) not null,
    subject text not null,
    acad_year text not null,
    term numeric(1) check(term=1 or term =2),
    mark numeric(1) check(mark>=3 and mark<= 5) default 5,
    foreign key (record_book)
    references students(record_book)
    on delete cascade
    on update cascade
);

create table airports
(
    airport_code char(3) not null, -- код аэропорта
    airport_name text not null, -- название аэропорта
    city text not null, -- город
    longitude float not null, -- координаты аэропорта(долгота)
    latitude float not null, -- координаты аэропорта(широта)
    timezone text not null, -- часовой пояс аэропорта
    primary key (airport_code)
);

create table flights
(
    flight_id serial not null,
    flight_no char(6) not null,
    scheduled_departure timestamptz not null,
    scheduled_arrival timestamptz not null,
    departure_airport char(3) not null,
    arrival_airport char(3) not null,
    status varchar(20) not null,
    aircraft_code char(3) not null,
    actual_departure timestamptz,
    actual_arrival timestamptz,
    check(scheduled_arrival>scheduled_departure),
    check(status in ('On Time', 'Delayed', 'Departed', 'Arrived', 'Scheduled', 'Cancelled')),
    check(actual_arrival is null or
    (
        actual_departure is not null and
        actual_arrival is not null and
        actual_arrival>actual_departure
    )),
    primary key(flight_id),
    unique (flight_no, scheduled_departure),
    Foreign Key (aircraft_code) REFERENCES aircrafts (aircraft_code),
    Foreign Key (departure_airport) REFERENCES airports (airport_code),
    Foreign Key (arrival_airport) REFERENCES airports (airport_code)
);

create table bookings
(
    book_ref char(6) not null,
    book_date timestamptz not null,
    total_amount numeric(10,2) not null,
    primary key (book_ref)
);
create table tickets
(
    ticket_no char(13) not null,
    book_ref char(6) not null,
    passenger_id varchar(20) not null,
    passenger_name text,
    contact_data jsonb,
    primary key (ticket_no),
    Foreign Key (book_ref) REFERENCES bookings (book_ref)
);

create table ticket_flights
(
    ticket_no char(13) not null,
    flight_id integer not null,
    fare_conditions varchar(10) not null,
    amount numeric(10, 2) not null,
    check (amount >=0 ),
    check (fare_conditions in ('Economy','Comfort','Business')),
    primary key (ticket_no, flight_id),
    Foreign Key (flight_id) REFERENCES flights (flight_id),
    Foreign Key (ticket_no) REFERENCES tickets (ticket_no)
);

create table boarding_passes
(
    ticket_no char(13) not null,
    flight_id integer not null,
    boarding_no integer not null,
    seat_no varchar(4) not null,
    primary key (ticket_no, flight_id),
    unique (flight_id, boarding_no),
    unique (flight_id, seat_no),
    Foreign Key (ticket_no, flight_id) REFERENCES ticket_flights (ticket_no, flight_id)
);

alter table aircrafts
    add column speed integer;

update aircrafts set speed = 807 where aircraft_code = '733';
update aircrafts set speed = 851 where aircraft_code = '763';
update aircrafts set speed = 905 where aircraft_code = '773';
update aircrafts set speed = 840 where aircraft_code in ('319','320','321');

update aircrafts set speed = 786 where aircraft_code = 'CR2';
update aircrafts set speed = 341 where aircraft_code = 'CN1';
update aircrafts set speed = 830 where aircraft_code = 'SU9';
SELECT * FROM aircrafts;

alter table aircrafts alter COLUMN speed set not null;
alter table aircrafts add check (speed>=300);

alter table aircrafts alter column speed drop not null;
alter table aircrafts drop constraint aircrafts_speed_check;
alter table aircrafts drop column speed;

alter table airports
    alter column longitude set data type numeric(5,2),
    alter column latitude set data type numeric(5,2);

create table fare_conditions
(
    fare_conditions_code integer,
    fare_conditions_name varchar(10) not null,
    primary key (fare_conditions_code)
);
SELECT * FROM fare_conditions;
insert into fare_conditions 
    values (1, 'Economy'),
           (2, 'Business'),
           (3, 'Comfort');

alter table seats
    drop constraint seats_fare_conditions_check,
    alter column fare_conditions set data type INTEGER
    using ( case when fare_conditions = 'Economy' then 1
                 when fare_conditions = 'Business' then 2
                 else 3
            end);

alter table seats
    add foreign key (fare_conditions) REFERENCES fare_conditions(fare_conditions_code);

alter table seats
    rename column fare_conditions to fare_conditions_code;

alter table seats
    rename constraint seats_fare_conditions_fkey
    to seats_fare_conditions_code_fkey;

alter table fare_conditions add unique (fare_conditions_name);

create view seat_by_fare_cond as
    select aircraft_code,
           fare_conditions_code,
           count(*) as num_seats
    from seats
    GROUP BY aircraft_code, fare_conditions_code
    ORDER BY aircraft_code, fare_conditions_code;

SELECT * from seat_by_fare_cond;

drop view seat_by_fare_cond;
create or replace view seat_by_fare_cond (code, fare_cond, num_seats) 
as
    select aircraft_code,
           fare_conditions_code,
           count(*)
    from seats
    GROUP BY aircraft_code, fare_conditions_code
    ORDER BY aircraft_code, fare_conditions_code;

--Задание 1
create table students
(
    record_book numeric(5) not null,
    name text not null, 
    doc_ser numeric(4),
    doc_num numeric(6),
    who_adds_row text DEFAULT current_user,
    primary key (record_book)
);
alter table students
    add column when_adds_row text default current_time::text;

insert into students(record_book, name, doc_ser, doc_num)
    values(12300, 'Лебедев В.В.', 0402, 534281);
SELECT * FROM students;

--Задание 2
create table progress
(
    record_book numeric(5) not null,
    subject text not null,
    acad_year text not null,
    term numeric(1) check(term=1 or term =2),
    mark numeric(1) check(mark>=3 and mark<= 5) default 5,
    foreign key (record_book)
    references students(record_book)
    on delete cascade
    on update cascade
);

alter table progress
    drop constraint progress_mark_check,
    add column test_form text not null default 'экзамен',
    add check(
        (test_form = 'экзамен' and mark in (3,4,5))
        or
        (test_form = 'зачет' and mark in (0,1))
    );

insert into progress (record_book, subject, acad_year, term, test_form, mark)
    values(12300, 'math', '1', 1, 'зачет', 1);

insert into progress (record_book, subject, acad_year, term, test_form, mark)
    values(12300, 'math', '1', 1, 'зачет', 3);--нарушает условие

--Задание 3

alter table progress 
    alter COLUMN term drop not null,
    alter COLUMN mark drop not null;

insert into progress (record_book, subject, acad_year, test_form, mark)
    values(12300, 'math', '1', 'зачет', 1);

select * from progress;

--Задание 5
alter table students
    alter COLUMN doc_ser drop not null,
    alter COLUMN doc_num drop not null,
    add unique(doc_ser, doc_num);

insert into students(record_book, name, doc_ser)
    values(12301, 'Лебедев В.В. 2', 0402),
          (12302, 'Лебедев В.В. 2', 0402);
    
insert into students(record_book, name, doc_num)
    values(12303, 'Лебедев В.В. 3', 534281),
          (12304, 'Лебедев В.В. 3', 534281); 

SELECT * FROM students;
--Задание 6
drop table progress;
drop table students;

create table students(
    record_book numeric(5) not null UNIQUE,
    name text not null,
    doc_ser numeric(4),
    doc_num numeric(6),
    primary key (doc_ser, doc_num)
);

create table progress(
    doc_ser numeric(4),
    doc_num numeric(6),
    subject text not null,
    acad_year text not null,
    term numeric(1) not null check(term=1 or term =2),
    mark numeric(1) not null,
    test_form text not null default 'экзамен' check(
        (test_form = 'экзамен' and mark in (3,4,5))
        or
        (test_form = 'зачет' and mark in (0,1))
    ),
    Foreign Key (doc_ser, doc_num) REFERENCES students (doc_ser, doc_num)
    on delete CASCADE
    on update CASCADE
);

insert into students(record_book, name, doc_ser, doc_num)
    values(12301, 'Лебедев В.В. ', 0402, 123456),
          (12302, 'Лебедев В.В. 2', 7894, 123456),
          (12303, 'Лебедев В.В. 3', 4562, 123456),
          (12304, 'Лебедев В.В. 4', 5361, 123456),
          (12305, 'Лебедев В.В. 5', 0402, 321654);
          (79846, 'Лебедев В.В. 5', 1597, 321654);

insert into progress  (doc_ser, doc_num, subject, acad_year, term, test_form, mark)
    values(0402, 123456, 'math', '1', 1, 'зачет', 1),
          (7894, 123456, 'math', '2', 1, 'экзамен', 5),
          (4562, 123456, 'math', '3', 1, 'экзамен', 4),         
          (5361, 123456, 'math', '4', 1, 'зачет', 0),
          (0402, 321654, 'math', '5', 1, 'экзамен', 3);

SELECT * FROM students;
SELECT * FROM progress;
--Задание 8
create table subject(
    subject_id integer,
    subject_name text,
    primary key(subject_id)
);
insert into subject
values (1,'math');
alter table progress
    drop constraint progress_subject_fkey,
    alter column subject set data type INTEGER
    using ( case when subject = 'math' then 1
            end),
    rename column subject to subject_id,
    add foreign key (subject_id) REFERENCES subject(subject_id);

--Задание 9
alter table students add check(name<>'');
alter table students add check(trim(name)<>'');
insert into students
    values (84354, '', 6734, 321654);

--Задание 10

alter table students
    alter column doc_ser set data type char(4);
--Задание 11


--Задание 12
--Задание 13
--Задание 14
--Задание 15
--Задание 16
--Задание 17
--Задание 18