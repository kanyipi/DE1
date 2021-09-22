SHOW VARIABLES LIKE "local_infile";
SHOW VARIABLES LIKE "secure_file_priv";
show tables;
describe birdstrikes.birdstrikes;
select * from birdstrikes;
select airline,cost from birdstrikes;

INSERT INTO employee (id,employee_name) VALUES(1,'Student1');
INSERT INTO employee (id,employee_name) VALUES(2,'Student2');
INSERT INTO employee (id,employee_name) VALUES(3,'Student3');

CREATE TABLE employee
(id INTEGER NOT NULL,
employee_name VARCHAR(32) NOT NULL,
PRIMARY KEY(id));
	 
SELECT * FROM birdstrikes LIMIT 144,1;

-- 147		2000-01-19	No damage	UNKNOWN	Washington		2002-07-14	Medium	0	

SELECT flight_date FROM birdstrikes ORDER BY flight_date ASC LIMIT 1;

-- 2000-04-18

SELECT DISTINCT cost FROM birdstrikes ORDER BY cost ASC LIMIT 50,1;

-- 93546

SELECT state FROM birdstrikes WHERE state IS NOT NULL AND bird_size IS NOT NULL LIMIT 2,1;

-- Colorado

SELECT datediff(now(),date(flight_date)) FROM birdstrikes where WEEKOFYEAR(flight_date)=52 AND state="COLORADO";

-- 7935
