-- a
SELECT DISTINCT P1.maker FROM Product AS P1 
LEFT JOIN Product AS P2 ON P1.maker = P2.maker AND P2.type='pc' 
WHERE P1.type='laptop' AND P2.type IS NULL;
-- b
SELECT maker FROM
 (SELECT DISTINCT maker, type FROM Product
  WHERE type IN ('pc', 'laptop')) AS T 
GROUP BY maker HAVING COUNT(*) = 1 AND MIN(type) = 'laptop';
-- c
SELECT DISTINCT maker FROM Product AS P1 
WHERE type = 'laptop' AND NOT EXISTS 
(SELECT maker FROM Product WHERE type = 'pc' AND maker = P1.maker);
-- d
SELECT P1.model FROM Printer P1 
INNER JOIN (SELECT price FROM Printer WHERE model='3002') P2 
ON P1.price < P2.price;
-- e
select model from Printer as P1 where P1.price < (select price from Printer as P2 where P2.model=3002);

-- f
SELECT model FROM Printer P1 
WHERE EXISTS
 (SELECT * FROM Printer P2 
  WHERE P2.model='3002' AND P1.price < P2.price);
-- g
SELECT PC1.model
FROM PC PC1 LEFT OUTER JOIN PC PC2 ON (PC1.speed < PC2.speed)
WHERE PC2.model IS NULL;
-- h
SELECT model FROM PC
WHERE speed IN (SELECT MAX(speed) FROM PC);

-- i
SELECT DISTINCT maker FROM Product AS P1 
LEFT JOIN PC AS P2 ON P1.model = P2.model
WHERE P2.speed IS NOT NULL
GROUP BY speed HAVING COUNT(speed) >= 3;

-- j
SELECT model FROM PC
WHERE speed >= ALL (SELECT speed FROM PC);

-- k
SELECT model FROM PC PC1
WHERE NOT EXISTS (SELECT * FROM PC PC2 WHERE PC2.speed > PC1.speed);
-- l
select distinct A.maker from ((Product join PC using(model)) as A join (Product join PC using(model)) as B on A.speed != B.speed and A.maker = B.maker) join (Product join PC using(model)) as C on A.speed != C.speed and B.speed != C.speed and A.maker = C.maker;

-- m
SELECT maker FROM 
(SELECT DISTINCT maker, speed FROM Product, PC 
WHERE Product.model = PC.model) AS P1 
GROUP BY maker HAVING COUNT(speed) >= 3;
-- n
select maker from (select maker, count(distinct speed) as cnt from Product join PC using(model) group by maker) as A where A.cnt >=3;

-- o
UPDATE PC SET price = price - price * 0.1 
WHERE 'A' = (SELECT maker FROM Product WHERE Product.model = PC.model);
-- p
UPDATE PC SET price = price - price * 0.1
WHERE model IN 
(SELECT model FROM Product WHERE maker = 'A');
-- q
update PC set price = price*0.90 where exists(select * from Product where maker = 'A' and model = PC.model);



