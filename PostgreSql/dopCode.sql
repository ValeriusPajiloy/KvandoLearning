-- Active: 1669274822137@@127.0.0.1@5432@demo@bookings
select 'a fat cat sat on a mat and ate a fat rat'::tsvector;
select $$the lexeme '    ' contains spaces$$::tsvector;
select $$the lexeme 'Joe''s' contains a quote$$::tsvector;
select 'a:1 fat:2 cat:3 sat:4 on:5 a:6 mat:7 and:8 ate:9 a:10 fat:11 rat:12'::tsvector;
select 'a:1A fat:2B,4C cat:5D'::tsvector;
select 'The Fat Rats'::tsvector;
select to_tsvector('english', 'The Fat Rats');
select 'fat & rat'::tsquery;
select 'fat & (rat | cat)'::tsquery;
select 'fat & rat & ! cat'::tsquery;
select '(fat | rat) <-> cat'::tsquery;
select 'fat:ab & cat'::tsquery;
select 'super:*'::tsquery;
select to_tsquery('Fat:ab & Cats');
select to_tsvector( 'postgraduate' ) @@ to_tsquery( 'postgres:*' );
select to_tsvector( 'postgraduate' ), to_tsquery( 'postgres:*' );
