CREATE DATABASE ineuron;
use ineuron;

CREATE table productinfo ( productid INT, productname varchar(50));
CREATE TABLE product_info_likes (userid INT, productid INT, liked_date DATE);
INSERT INTO productinfo VALUES (1001, 'blog');
INSERT INTO productinfo VALUES (1002, 'youtube');

INSERT INTO product_info_likes (userid, productid, liked_date)
VALUES
    (1, 1001, '2023-08-19'),
    (2, 1003, '2023-01-18');

SELECT * FROM productinfo;
SELECT * from product_info_likes;

SELECT pi.productid
FROM productinfo as pi
LEFT JOIN product_info_likes as pif ON pi.productid = pif.productid
GROUP BY pi.productid
HAVING COUNT(pif.productid) = 0;

