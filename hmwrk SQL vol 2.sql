--Задание 1 

CREATE TABLE authors (
	id int primary key,
	first_name varchar(50),
	second_name varchar (50)
);

create table books (
	id int primary key,
	title varchar(70),
	author_id int,
	publication_year int,
	constraint fk_author
	foreign key (author_id) references authors(id)
);

create table sales (
	id int primary key,
	book_id int,
	quantity int,
	constraint fk_book
	foreign key (book_id) references books(id)
);

insert into authors (id, first_name, second_name)
values (1, 'Ryu', 'Murakami'),
		(2, 'Yukio', 'Mishima'),
		(3, 'Vladimir', 'Sorokin'),
		(4, 'Vladimir', 'Nabokov'),
		(5, 'Timothy', 'lirey');

insert into books (id, title, author_id, publication_year)
values (1, 'piercing', 1, 2020),
		(2, 'The book of the samurai', 2, 1965),
		(3, 'Norma', 3, 1983),
		(4, 'Lolita', 4, 1955),
		(5, 'Pale fire', 4, 1962),
		(6, 'bible', null, 1400);

insert into books (id, title, author_id, publication_year)
values (1, 'piercing', 1, 2020),
		(2, 'The book of the samurai', 2, 1965),
		(3, 'Norma', 3, 1983),
		(4, 'Lolita', 4, 1955),
		(5, 'Pale fire', 4, 1962),
		(6, 'bible', null, 1400);

--Задание 2

SELECT books.title, authors.first_name, authors.last_name 
FROM books
INNER JOIN authors
ON books.author_id = authors.id;

SELECT authors.first_name, authors.last_name, books.title
FROM books
INNER JOIN authors
ON books.author_id = authors.id;

SELECT books.title, authors.first_name, authors.last_name
FROM books
RIGHT JOIN authors
ON books.author_id = authors.id;

--Задание 3 

SELECT  authors.first_name, authors.last_name, books.title,  sales.quantity
FROM authors
INNER JOIN books
ON books.author_id = authors.id
INNER JOIN sales
ON books.id = sales.book_id;

SELECT authors.first_name, authors.last_name, books.title, SUM(sales.quantity)
FROM authors
LEFT JOIN books
ON books.author_id = authors.id
LEFT JOIN sales
ON sales.book_id = books.id
GROUP BY authors.first_name, authors.last_name, books.title

--Задание 4

SELECT authors.first_name, authors.last_name, SUM(sales.quantity) AS sum_sales
FROM authors
INNER JOIN books
ON books.author_id = authors.id
INNER JOIN sales
ON sales.book_id = books.id
GROUP BY authors.first_name, authors.last_name
ORDER BY sum_sales

SELECT authors.first_name, authors.last_name, SUM(sales.quantity) AS sum_sales
FROM authors
LEFT JOIN books
ON books.author_id = authors.id
LEFT JOIN sales
ON sales.book_id = books.id
GROUP BY authors.first_name, authors.last_name
ORDER BY sum_sales

-- Задание 5

SELECT authors.first_name, authors.last_name
FROM authors
WHERE authors.id = (
    SELECT author_id
    FROM (
        SELECT books.author_id, SUM(sales.quantity) AS total_sales
        FROM books
        INNER JOIN sales ON books.id = sales.book_id
		WHERE sales.quantity IS NOT NULL
        GROUP BY books.author_id
        ORDER BY total_sales DESC
        LIMIT 1
    ) AS top_author
);


SELECT b.title, SUM(s.quantity) AS total_sales
FROM books b
JOIN sales s ON b.id = s.book_id
GROUP BY b.id
HAVING SUM(s.quantity) > (
    SELECT AVG(total_sales)
    FROM (
        SELECT SUM(s2.quantity) AS total_sales
        FROM sales s2
        GROUP BY s2.book_id
    ) AS avg_sales
);