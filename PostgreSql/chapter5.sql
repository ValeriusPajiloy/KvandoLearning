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
    check(actual_arrival in null or
    (
        actual_departure is not null and
        actual_arrival is not null and
        actual_arrival>actual_departure
    )),
    primary key(flight_id),
    unique (flight_no, scheduled_departure),
    Foreign Key (aircraft_code) REFERENCES aircrafts (aircraft_code),
    Foreign Key (departure_airport) REFERENCES airports (airport_code),
    Foreign Key (arrival_airport) REFERENCES airports (airport_code),
);