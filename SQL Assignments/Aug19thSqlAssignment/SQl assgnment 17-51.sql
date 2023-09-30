CREATE database ineuron;
use ineuron;

CREATE TABLE product( product_id INT, productname VARCHAR(50), unit_price INT, PRIMARY KEY (product_id));
CREATE TABLE sales (seller_id INT,
product_id INT,
buyer_id INT,
sale_date DATE,
quantity INT,
price INT, foreign key(product_id) references product(product_id) );

SHOW TABLES;

INSERT INTO product (product_id, productname, unit_price) VALUES
(1, "S8", 1000),
(2, "G4", 800),
(3, "iPhone" ,1400);

INSERT INTO sales(seller_id,
product_id,
buyer_id,
sale_date,
quantity,
price) VALUES 
(1, 1, 1, "2019-01-21" ,2, 2000),
(1,2,2,"2019-02-17",1,800),
(2,2,3,"2019-06-02",1,800),
(3,3,4,"2019-05-13",2,2800);

SELECT * FROM sales;
SELECT * FROM product;

DESCRIBE sales;
DESCRIBE product;
/*Write an SQL query that reports the products that were only sold in the first quarter of 2019. That is,
between 2019-01-01 and 2019-03-31 inclusive.*/

select distinct p.product_id,p.productname
from product as p
where p.product_id Not in (
select Distinct s.product_id
from sales as s
where sale_date Not Between  "2019-01-01" and  "2019-03-31");

# table views 
/*Write an SQL query to find all the authors that viewed at least one of their own articles.
Return the result table sorted by id in ascending order.*/

Create table Views(
article_id int,
author_id int,
viewer_id int,
view_date date);

Insert Into Views Values
(1,3,5,"2019-08-01"),
(1,3,6,"2019-08-02"),
(2,3,6,"2019-08-01"),
(2,7,7,"2019-08-01"),
(2,7,6,"2019-08-02"),
(4,7,1,"2019-07-22"),
(3,4,4,"2019-07-21"),
(3,4,4,"2019-07-21");

SELECT * FROM Views;

SELECT DISTINCT author_id FROM Views
WHERE author_id=viewer_id ;

/*If the customer's preferred delivery date is the same as the order date, then the order is called
immediately; otherwise, it is called scheduled.
Write an SQL query to find the percentage of immediate orders in the table, rounded to 2 decimal
places.*/
CREATE Table delivery (
delivery_id int,
customer_id int,
order_date date,
customer_pref_delivery_date date);

INSERT INTO delivery (delivery_id,
customer_id ,
order_date,
customer_pref_delivery_date) VALUES
(1 ,1, "2019-08-01", "2019-08-02"),
(2, 5 ,"2019-08-02", "2019-08-02"),
(3, 1 ,"2019-08-11", "2019-08-11"),
(4, 3 ,"2019-08-24", "2019-08-26"),
(5, 4 ,"2019-08-21", "2019-08-22"),
(6, 2 ,"2019-08-11", "2019-08-13");

SELECT * from delivery;
SELECT ROUND((SUM(order_date=customer_pref_delivery_date)/ COUNT (*)*100 ), 2) as immediate_percentage from delivery;

/*Write an SQL query to find the ctr of each Ad. Round ctr to two decimal points.
Return the result table ordered by ctr in descending order and by ad_id in ascending order in case of a
tie.*/
 create table Ads(
 ad_id int,
 user_id int,
 action enum('Clicked','Viewed','Ignored'),
 primary key (ad_id,user_id));
 
 insert into Ads values
 (1,1,"Clicked"),
 (2,2,"Clicked"),
 (3,3,"Viewed"),
 (5,5,"Ignored"),
 (1,7,"Ignored"),
 (2,7,"Viewed"),
 (3,5,"Clicked"),
 (1,4,"Viewed"),
 (2,11,"Viewed"),
 (1,2,"Clicked");

 SELECT * FROM Ads;


 /*WITH cte AS 
 (SELECT ad_id, SUM(CASE  WHEN action ='Clicked' THEN 1 ELSE 0 END ) AS Clicked, 
 SUM(CASE WHEN action ='Viewed' THEN 1 ELSE 0 END ) AS Viewed
 FROM Ads
 GROUP BY ad_id)

  SELECT ad_id, CASE WHEN clicked+viewed=0 THEN  0.00
   ELSE  
 ROUND(((clicked)/((clicked)+(viewed))*100),2) as ctr
 FROM CTE
 ORDER BY ctr,ad_id;*/



select
ad_id,round(avg(case when action='Clicked' then 1 else 0 end)*100,2) ctr
from Ads
group by ad_id
order by ad_id,ctr desc


/*Q.22-Write an SQL query to find the type of weather in each country for November 2019.
The type of weather is:
● Cold if the average weather_state is less than or equal 15,
● Hot if the average weather_state is greater than or equal to 25, and
● Warm otherwise.
Return result table in any order.*/

create table Countries(
country_id int,
country_name varchar(25),
primary Key (country_id));



create table Weather(
country_id int,
weather_state int,
day date,
primary key(Country_id,day));

insert into Countries values(2,"USA"),
(3,"Australia"),
(7,"Peru"),
(5,"China"),
(8,"Morocco"),
(9,"Spain");

insert into Weather values(2,15,"2019-11-01"),
(2,12,"2019-10,28"),
(2,12,"2019-10-27"),
(3,-2,"2019-11-10"),
(3,0,"2019-11-11"),
(3,3,"2019-11-12"),
(5,16,"2019-11-07"),
(5,18,"2019-11-09"),
(5,21,"2019-11-23"),
(7,25,"2019-11-28"),
(7,22,"2019-12-01"),
(7,20,"2019-12-02"),
(8,25,"2019-11-05"),
(8,27,"2019-11-15"),
(8,31,"2019-11-25"),
(9,7,"2019-10-23"),
(9,3,"2019-12-23");


SELECT * FROM Weather;
SELECT * FROM Countries;

SELECT cn.country_name, avg(w.weather_state) as average_weather ,
(CASE 
   WHEN avg(w.weather_state)<=15 THEN 'cold'
   WHEN avg(w.weather_state)>=25 THEN 'hot'
   ELSE "warm"
END) as weather_type
from Countries as cn
RIGHT JOIN
Weather as w
ON cn.country_id=w.country_id
WHERE day BETWEEN "2019-11-01" AND "2019-11-30"
GROUP BY w.country_id
ORDER BY weather_type ASC;

/*Q.23- Write an SQL query to find the average selling price for each product. average_price should be
rounded to 2 decimal places.*/
CREATE Table Prices (product_id int,
start_date date,
end_date date,
price int,
PRIMARY KEY (product_id, start_date, end_date));

CREATE Table UnitesSold (product_id int,
purchase_date date,
units int);

insert into Prices values(1,"2019-02-17","2019-02-28",5),
(1,"2019-03-01","2019-03-22",20),
(2,"2019-02-01","2019-02-20",15),
(2,"2019-02-21","2019-03-31",30);

insert into UnitesSold values(1,"2019-02-25",100),
(1,"2019-03-01",15),
(2,"2019-02-10",200),
(2,"2019-03-22",30);

select * FROM UnitesSold;
SELECT * FROM Prices;

/*Q.24-Write an SQL query to report the first login date for each player.
Return the result table in any order.*/

SELECT p.product_id, ROUND( (SUM(p.price*u.units)/SUM(u.units)),2) as average_price FROM UnitesSold as u
INNER JOIN Prices as p
ON p.product_id=u.product_id
WHERE u.purchase_date BETWEEN p.start_date and p.end_date
GROUP BY p.product_id;

create table Activity(
player_id int,
device_id int,
event_date date,
games_played int,
primary key (player_id,event_date));

insert into Activity values(1,2,"2016-03-01",5),
(1,2,"2016-05-02",6),
(2,3,"2017-06-25",1),
(3,1,"2016-03-02",0),
(3,4,"2018-07-03",5);

SELECT * from Activity;

SELECT player_id, MIN(event_date) as first_login from Activity
group by player_id;

/*Q.25- Write an SQL query to report the device that is first logged in for each player.
Return the result table in any order.*/

CREATE TABLE activity_table (player_id int,
device_id int,
event_date date,
games_played int,
PRIMARY KEY (player_id, event_date));

INSERT INTO activity_table (player_id, device_id,event_date, games_played)
VALUES (1 ,2 ,'2016-03-01', 5),
(1, 2 ,'2016-05-02' ,6),
(2, 3, '2017-06-25', 1),
(3 ,1 ,'2016-03-02', 0),
(3 ,4 ,'2018-07-03' ,5);

SELECT * FROM activity_table;

#using window fucntion Rank()
SELECT player_id, device_id FROM
(
SELECT player_id, device_id, event_date ,
	RANK() OVER(PARTITION BY (player_id) ORDER BY event_date asc) as rnk
FROM activity_table ) x WHERE x.rnk=1;

/*Q.26-Write an SQL query to get the names of products that have at least 100 units ordered in February 2020
and their amount.*/
CREATE TABLE Products (product_id int,
product_name varchar(50),
product_category varchar(50), PRIMARY KEY (product_id));

create table Orders(
 product_id int,
 order_date date,
 unit int,
 foreign key (product_id) references Products(product_id));

INSERT into Products (product_id,
product_name ,
product_category) VALUES 
(1,"Leetcode Solutions","Book"),
 (2,"Jewels of Stringology","Book"),
 (3,"HP","Laptop"),
 (4,"Lenovo","Laptop"),
 (5,"Leetcode Kit","T-shirt");

 insert into Orders values(1,"2020-02-05",60),
 (1,"2020-02-10",70),
 (2,"2020-01-18",30),
 (2,"2020-02-11",80),
 (3,"2020-02-17",2),
 (3,"2020-02-24",3),
 (4,"2020-03-01",20),
 (4,"2020-03-04",30),
 (4,"2020-03-04",60),
 (5,"2020-02-25",50),
 (5,"2020-02-27",50),
 (5,"2020-03-01",50);
 
 SELECT * FROM Products;
 SELECT * FROM Orders;

 SELECT p.product_name, sum(o.unit)as tot FROM Products as p 
 RIGHT JOIN Orders as o 
 ON p.product_id=o.product_id
 WHERE  order_date BETWEEN "2020-02-01"  AND "2020-02-29" 
 GROUP BY o.product_id
 HAVING tot>=100;

/*Q.27-Write an SQL query to find the users who have valid emails.*/
create table Users(
 user_id int,
 name varchar(25),
 mail varchar(35),
 primary key(user_id));
 
 insert into Users Values(1,"Winston","winston@leetcode.com"),
 (2,"Jonathan","jonathanisgreat"),
 (3,"Annabelle","bella-@leetcode.com"),
 (4,"Sally","sally.come@leetcode.com"),
 (5,"Marwan","quarz#2020@leetcode.com"),
 (6,"David","david69@gmail.com"),
 (7,"Shapiro",".shapo@leetcode.com");

 select * FROM Users;
 SELECT user_id, name, mail FROM Users WHERE REGEXP_LIKE (mail,'^[a-zA-Z][a-zA-Z0-9\_\.\-]*@leetcode.com');

 /*Q.28- Write an SQL query to report the customer_id and customer_name of customers who have spent at
least $100 in each month of June and July 2020.*/

 create table Customers(
 customer_id int,
name varchar(25),
country varchar(35),
primary key(customer_id));


create table Product(
product_id int,
description varchar(25),
price int,
primary key(product_id));


create table Orders(
order_id int,
customer_id int,
product_id int,
order_date date,
quantity int,
primary key(order_id));

insert into Customers values(1,"Winston","USA"),
(2,"Jonathan","Peru"),
(3,"Moustafa","Egypt");

insert into Product values(10,"LC Phone",300),
(20,"LC T-Shirt",10),
(30,"LC Book",45),
(40,"LC Keychain",2);


insert into Orders values(1,1,10,"2020-06-10",1),
(2,1,20,"2020-07-01",1),
(3,1,30,"2020-07-08",2),
(4,2,10,"2020-06-15",2),
(5,2,40,"2020-07-01",10),
(6,3,20,"2020-06-24",2),
(7,3,20,"2020-06-25",2),
(9,3,30,"2020-05-08",3);

SELECT * FROM Customers;
SELECT * FROM Product;
SELECT * FROM Orders;

WITH result as (
SELECT 
    o.customer_id,
    c.name,
    DATE_FORMAT(o.order_date, '%Y-%m') as order_date, 
    SUM(quantity * price) as total_spend
FROM Orders as o JOIN Product as p
ON o.product_id = p.product_id
JOIN Customers as c
ON o.customer_id = c.customer_id
GROUP BY 1, 2, 3
ORDER BY 1
)
SELECT
    DISTINCT 
    customer_id,
    name
FROM result 
WHERE customer_id IN (SELECT customer_id FROM result 
		      WHERE order_date = '2020-06' 
                      AND total_spend >= 100)
AND customer_id IN (SELECT customer_id FROM result 
		    WHERE order_date = '2020-07' 
                    AND total_spend >= 100);

/* Q.29- Write an SQL query to report the distinct titles of the kid-friendly movies streamed in June 2020.
Return the result table in any order.
The query result format is in the following example.*/

create table TVProgram(
 program_date date,
 content_id int,
 channel varchar(25),
 primary key(program_date,content_id));
 
 create table Content(
 content_id int,
 title varchar(25),
 Kids_content enum("Y","N"),
 content_type varchar(25));
 
 insert into TVProgram values("2020-06-10",1,"LC-Channel"),
 ("2020-05-11",2,"LC-Channel"),
 ("2020-05-12",3,"LC-Channel"),
 ("2020-05-13",4,"Disney Ch"),
 ("2020-06-18",4,"Disney Ch"),
 ("2020-07-15",5,"Disney Ch");
 
 insert into Content values(1,"Leetcode Movie","N","Movies"),
(2,"Alg. for kids","Y","Series"),
(3,"Database Sols","N","Series"),
(4,"Alladin","Y","Series"),
(5,"Cinderrella","Y","Movies");

SELECT * FROM TVProgram;
SELECT * from Content;

SELECT DISTINCT c.title FROM Content as c
left JOIN 
TVProgram as t  
ON c.content_id=t.content_id
WHERE c.Kids_content="Y" and t.program_date BETWEEN "2020-06-01" and "2020-06-30";

/* Q.30- Write an SQL query to find the npv of each query of the Queries table.
Return the result table in any order.*/
 create table NPV(
 id int,
 year int,
 npv int default NULL,
 primary key(id,year));
 
 create table Queries(
 id int,
 year int,
 primary key(id,year));
 
 insert into NPV values(1,2018,100),
 (7,2020,30),
 (13,2019,40),
 (1,2019,113),
 (2,2008,121),
 (3,2009,12),
 (11,2020,99),
 (7,2019,0);

  
 insert into Queries values(1,2019),
 (2,2008),
 (3,2009),
 (7,2018),
 (7,2019),
 (7,2020),
 (13,2019);

 SELECT * from NPV;
 select * from Queries; 

 select distinct q.id, q.year,  sum(n.npv) FROM NPV as n  
 RIGHT join 
 Queries as q 
 on n.id=q.id and n.year=q.year
 GROUP BY q.id, q.year ;

 /*Q.31- Write an SQL query to find the npv of each query of the Queries table.
Return the result table in any order.*/

# same solution as above

/*Q.32- Write an SQL query to show the unique ID of each user, If a user does not have a unique ID replace just
show null.*/

create table EMployees(
 id int,
 name varchar(25),
 primary key(id));
 
 create table EmployeeUNI(
 id int,
 unique_id int,
 primary key(id,unique_id));

insert into EMployees values(1,"Alice"),
(7,"Bob"),
(11,"Meir"),
(90,"Winston"),
(3,"Jonathan");

insert into EmployeeUNI values(3,1),
(11,2),
(90,3);

select * from EMployees ;
SELECT * from EmployeeUNI;

select eu.unique_id, e.name from EMployees as e
left join EmployeeUNI as eu 
on e.id = eu.id ;

/*Q.33- Write an SQL query to report the distance travelled by each user.
Return the result table ordered by travelled_distance in descending order, if two or more users
travelled the same distance, order them by their name in ascending order.*/

create table Users(
id int,
name varchar(25),
primary key (id));

create table rides(
id int,
user_id int,
distance int,
primary key (id));

insert into Users values(1,"Alice"),
(2,"Bob"),
(3,"Alex"),
(4,"Donald"),
(7,"Lee");
insert into Users values(13,"Jonathan"),
(19,"Elvis");

insert into rides values (1,1,120),
(2,2,317),
(3,3,222),
(4,7,100),
(5,13,312),
(6,19,50),
(7,7,120),
(8,19,400),
(9,7,230);

select * from Users;
select * from rides;

select u.name , sum(r.distance) as travelled_distance from Users as u 
left join rides as r 
on u.id=r.user_id
group by u.name
order by travelled_distance desc, name ;

DROP table Users;
DROP table rides;

/*Q.34- Write an SQL query to:
● Find the name of the user who has rated the greatest number of movies. In case of a tie,
return the lexicographically smaller user name.
● Find the movie name with the highest average rating in February 2020. In case of a tie, return
the lexicographically smaller movie name. */

create table Movies(
movie_id int,
title varchar(25),
primary key(movie_id));


create table Users(
user_id int,
name varchar(25),
primary key(user_id));

create table MovieRating(
movie_id int,
user_id int,
rating int,
create_at date,
primary key(movie_id,user_id));


Insert into Movies values(1,"Daniel"),
(2,"Frozen 2"),
(3,"Joker");

insert into Users values(1,"Daniel"),
(2,"Monica"),
(3,"Maria"),
(4,"James");

insert into MovieRating values
(1,1,3,"2020-01-12"),
(1,2,4,"2020-02-11"),
(1,3,2,"2020-02-12"),
(1,4,1,"2020-02-17"),
(2,1,5,"2020-02-17"),
(2,2,2,"2020-02-01"),
(2,3,2,"2020-03-01"),
(3,1,3,"2020-02-22"),
(3,2,4,"2020-02-25");

SELECT * FROM Movies;
SELECT * FROM Users;
SELECT * FROM MovieRating;

select u.name from MovieRating as mr
left join Users as u 
on mr.user_id=u.user_id 
GROUP BY u.name
HAVING max(mr.movie_id) 
ORDER BY u.name 
limit 1;

select m.title from MovieRating as mi
left join Movies as m
on mi.movie_id = m.movie_id;

/*Q.36- Write an SQL query to report the distance travelled by each user.
Return the result table ordered by travelled_distance in descending order, if two or more users
travelled the same distance, order them by their name in ascending order.*/

create table Users(
id int,
name varchar(25),
primary key (id));

create table rides(
id int,
user_id int,
distance int,
primary key (id));

insert into Users values(1,"Alice"),
(2,"Bob"),
(3,"Alex"),
(4,"Donald"),
(7,"Lee"),
(13,"Jonathan"),
(19,"Elvis");

insert into rides values (1,1,120),
(2,2,317),
(3,3,222),
(4,7,100),
(5,13,312),
(6,19,50),
(7,7,120),
(8,19,400),
(9,7,230);

Select u.name, sum(r.distance) as travelled_distance from Users as u 
left join rides as r on u.id=r.user_id
GROUP BY u.name
ORDER BY travelled_distance DESC, u.name;

/*Q.37- Write an SQL query to show the unique ID of each user, If a user does not have a unique ID replace just
show null.*/

create table EMployees(
 id int,
 name varchar(25),
 primary key(id));
 
 create table EmployeeUNI(
 id int,
 unique_id int,
 primary key(id,unique_id));

insert into EMployees values(1,"Alice"),
(7,"Bob"),
(11,"Meir"),
(90,"Winston"),
(3,"Jonathan");

insert into EmployeeUNI values(3,1),
(11,2),
(90,3);

SELECT eu.unique_id , e.name FROM EMployees as e left join 
EmployeeUNI as eu 
on e.id = eu.id 
GROUP BY eu.unique_id ,e.name
ORDER BY eu.unique_id ;

/*Q.38- Write an SQL query to find the id and the name of all students who are enrolled in departments that no
longer exist.
Return the result table in any order.*/

create table Departments(
id int,
name varchar(25),
primary key(id));

create table Students(id int,
name varchar(25),
derpartment_id int,
primary key(id));

insert into Departments values(1,"Electrical Engeneering"),
(7,"Computer Engineering"),
(13,"Business Administration");

insert into Students values (23,"Alice",1),
(1,"Bob",7),
(5,"Jennifer",13),
(2,"John",14),
(4,"Jasmine",77),
(3,"Steve",74),
(6,"Luis",1),
(8,"Jonathan",7),
(7,"Daiana",33),
(11,"Madelynn",1); 


SELECT s.id, s.name
FROM Students as s
LEFT JOIN Departments as d 
ON s.department_id =d.id
WHERE d.id IS NULL;

/*Q.39- Write an SQL query to report the number of calls and the total call duration between each pair of
distinct persons (person1, person2) where person1 < person2.*/

create table Calls(
from_id int,
to_id int,
duration int);

insert into Calls values(1,2,59),
(2,1,11),
(1,3,20),
(3,4,100),
(3,4,200),
(3,4,200),
(4,3,499);

select * from Calls;

select from_id as person1, to_id as person2,
count(duration) as call_count, sum(duration) as total_duration
from (select * from Calls Union all
(select to_id, from_id, duration from Calls)) t1
where from_id < to_id group by person1,person2;

/*Q.40- Write an SQL query to find the average selling price for each product. average_price should be
rounded to 2 decimal places.*/

create table Prices(
product_id int,
start_date date,
end_date date,
price int,
primary key (product_id,start_date,end_date));

create table UnitSold(
product_id int,
purchase_date date,
units int);

insert into Prices values(1,"2019-02-17","2019-02-28",5),
(1,"2019-03-01","2019-03-22",20),
(2,"2019-02-01","2019-02-20",15),
(2,"2019-02-21","2019-03-31",30);

insert into UnitSold values(1,"2019-02-25",100),
(1,"2019-03-01",15),
(2,"2019-02-10",200),
(2,"2019-03-22",30);

SELECT p.product_id, ROUND((SUM(p.price*u.units)/SUM(u.units)),2) as average_price from Prices as p Left join 
UnitSold as u 
on p.product_id=u.product_id
group by p.product_id;

/*Q41- Write an SQL query to report the number of cubic feet of volume the inventory occupies in each
warehouse.*/
create table Warehouse(
name varchar(25),
product_id int,
units int,
primary key(name,product_id));


create table Products(
product_id int,
product_name varchar(25),
Width int,
Length int,
Height int,
primary key(product_id));

insert into Warehouse Values("LCHouse1",1,1),
("LCHouse1",2,10),
("LCHouse1",3,5),
("LCHouse2",1,2),
("LCHouse2",2,2),
("LCHouse3",4,1);



insert into Products values(1,"LC-TV",5,50,40),
(2,"LC-KeyChain",5,5,5),
(3,"LC-Phone",2,10,10),
(4,"LC-T-Shirt",4,10,20);

SELECT w.name , sum(p.Width*p.Length*p.Height*w.units) as volume from Warehouse as w
left join 
Products as p 
on w.product_id=p.product_id
GROUP BY w.name;

/*Q.42- Write an SQL query to report the difference between the number of apples and oranges sold each day.
Return the result table ordered by sale_date.*/

create table Sales(
 sale_date date,
 fruit enum("apples","oranges"),
 sold_num int,
 primary key (sale_date, fruit));
 
 insert into Sales Values("2020-05-01","apples",10),
 ("2020-05-01","oranges",8),
 ("2020-05-02","apples",15),
 ("2020-05-02","oranges",15),
 ("2020-05-03","apples",20),
 ("2020-05-03","oranges",0),
 ("2020-05-04","apples",15),
 ("2020-05-04","oranges",16);

SELECT * FROM Sales;

With cte1 as 
(SELECT sale_date, fruit, COALESCE (sold_num, 'null') as c FROM Sales)
SELECT * FROM cte1;

select * , Lag(sold_num,1, 0) OVER (order by sale_date) as b , sold_num-Lag(sold_num,1, 0) OVER (order by sale_date) as diff FROM Sales
;
SELECT Lag(b,1) OVER (order by sale_date) as diff FROM cte1;

SELECT
    sale_date,
    SUM(CASE WHEN fruit = 'apples' THEN sold_num ELSE 0 END) -
    SUM(CASE WHEN fruit = 'oranges' THEN sold_num ELSE 0 END) AS diff
FROM Sales
GROUP BY sale_date
ORDER BY sale_date;


/*Q. 42: Write an SQL query to report the fraction of players that logged in again on the day after the day they
first logged in, rounded to 2 decimal places. In other words, you need to count the number of players
that logged in for at least two consecutive days starting from their first login date, then divide that
number by the total number of players.*/

create table Activity(
player_id int,
device_id int,
event_date date,
games_played int,
primary key (player_id,event_date));

insert into Activity values(1,2,"2016-03-01",5),
(1,2,"2016-05-02",6),
(2,3,"2017-06-25",1),
(3,1,"2016-03-02",0),
(3,4,"2018-07-03",5);

SELECT * from Activity;

select round(t.player_id/(select count(distinct player_id) from Activity),2) as
fraction
from
(
select distinct player_id,
datediff(event_date, lead(event_date, 1) over(partition by player_id order by
event_date)) as diff
from Activity ) t
where diff = -1;

/*Q.45-*/

create table Department(
dept_id int,
dept_name varchar(25),
primary key(dept_id));

Create table Student(
student_id int,
student_name varchar(25),
gender varchar(8),
dept_id int,
primary key(student_id),
foreign key(dept_id) references Department(dept_id));

insert into Department values(1,"Engineering"),
(2,"Science"),
(3,"Law");

insert into Student values(1,"Jack","M",1),
(2,"Jane","F",1),
(3,"Mark","M",2);

select * from Department;
SELECT * from Student;

select d.dept_name, count(distinct s.student_id) as student_number from Student as s right join Department as d 
on s.dept_id=d.dept_id
group by d.dept_name
ORDER BY student_number desc;

/*Q.46- Write an SQL query to report the customer ids from the Customer table that bought all the products in
the Product table.
Return the result table in any order.*/

create table Customer(
customer_id int,
product_key int);

create table Product(
product_key int,
primary key(product_key));

insert into Customer values(1,5),
(2,6),
(3,5),
(3,6),
(1,6);

insert into Product values(5),(6);

SELECT * from Customer;
SELECT * from Product;

select count(distinct product_key) from Product;


select customer_id from Customer
group by customer_id
having count(distinct product_key) = (select count(distinct product_key) from Product);

/*Q.47 - Write an SQL query that reports the most experienced employees in each project. In case of a tie,
report all employees with the maximum number of experience years.*/

create table Project(
project_id int,
employee_id int,
primary key(project_id,employee_id));

create table Employee(
employee_id int,
name varchar(25),
experience_years int,
primary key(employee_id));

insert into Project values(1,1),
(1,2),
(1,3),
(2,1),
(2,4);


insert into Employee values(1,"Khaled",3),
(2,"Ali",2),
(3,"John",3),
(4,"Doe",2);

SELECT * FROM Project;
SELECT * from Employee;


select t.project_id, t.employee_id
from
(select p.project_id, e.employee_id, dense_rank() over(partition by p.project_id 
order by e.experience_years desc) as r
from
Project p
left join
Employee e
on p.employee_id = e.employee_id) t
where r = 1
order by t.project_id

#Q48

create table Books(
book_id int,
name varchar(35),
available_form date,
primary key(book_id));

create table Orders(
order_id int,
book_id int,
quantity int,
dispatch_date date,
primary key(order_id),
foreign key(book_id) references Books(book_id));


insert into Books values(1,"Kalila and Demna","2010-01-01"),
(2,"28 letters","2012-05-12"),
(3,"The Hobbit","2019-06-10"),
(4,"13 Reasons Why","2019-06-01"),
(5,"The Hunger Games","2008-09-21");


insert into Orders values
(1,1,2,"2018-07-26"),
(2,1,1,"2018-11-25"),
(3,3,8,"2019-06-11"),
(4,4,6,"2019-06-05"),
(5,4,5,"2019-06-20"),
(6,5,9,"2009-02-02"),
(7,5,8,"2010-04-13");

select book_id, name from Books
where book_id not in(select book_id from Orders
where(dispatch_date between date_sub('2019-06-23',interval 1 year) and '2019-06-23')
group by (book_id) having sum(quantity) >= 10) and
available_form < date_sub('2019-06-23', interval 1 month);


#Q49

create table Enrollments(
student_id int,
course_id int,
grade int,
primary key(student_id,course_id));

insert into Enrollments values(2,2,95),
(2,3,95),
(1,1,90),
(1,2,99),
(3,1,80),
(3,2,75),
(3,3,82);

select e1.student_id, min(e1.course_id) as course_id, e1.grade
from Enrollments e1
where e1.grade = (select max(grade) as max_grade
from Enrollments e2 where e1.student_id = e2.student_id)
group by e1.student_id 
order by e1.student_id;


#Q50 
create table Teams(
team_id int,
team_name varchar(20),
primary key(team_id));

create table Matches(
match_id int,
host_team int,
guest_team int,
host_goals int,
guest_goals int,
primary key(match_id));

insert into Teams values
(15,1),
(25,1),
(30,1),
(45,1),
(10,2),
(35,2),
(50,2),
(20,3),
(40,3);

insert into Matches values(1,15,45,3,0),
(2,30,25,1,2),
(3,30,15,2,0),
(4,40,20,5,2),
(5,35,50,1,1);
 
select t.team_id, t.team_name, ifnull(sum(case when t.team_id = m.host_team and m.host_goals > m.guest_goals then 3
when t.team_id = m.host_team and m.host_goals = m.guest_goals then 1
 when t.team_id = m.host_team and m.host_goals < m.guest_goals then 3
 when t.team_id = m.host_team and m.host_goals = m.guest_goals then 1  else 0 end),0) as points
 from Matches m
 right join Teams t
 on m.host_team = t.team_id or m.guest_team = t.team_id
 group by team_id, team_name
 order by points desc, team_id;
 
 
 select t.team_name as group_id, t.team_id  , m.host_goals + m.guest_goals goal
 from Teams t right join Matches m 
 on t.team_id = m.host_team
 group by t.team_name
 order by goal asc;




