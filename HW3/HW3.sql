use birdstrikes;
select * from birdstrikes;
SELECT aircraft, airline, cost, speed,
    IF(speed is null or speed < 100,'LOW SPEED','HIGH SPEED') as speed_category
FROM  birdstrikes
ORDER BY speed_category;

SELECT COUNT(DISTINCT aircraft) FROM birdstrikes;

-- 3

SELECT MIN(speed) from birdstrikes WHERE aircraft LIKE 'H%';

-- 9

SELECT phase_of_flight,COUNT(flight_date) from birdstrikes GROUP BY phase_of_flight;

/*Take-off run	114
	234
Climb	169
Approach	306
En Route	23
Landing Roll	121
Descent	30
Taxi	2 */

SELECT MAX(averagespeed) FROM (SELECT ROUND(AVG(cost)) as averagespeed FROM birdstrikes GROUP BY phase_of_flight) as t;

-- 54673

SELECT MAX(averagespeed) FROM (SELECT AVG(speed) AS averagespeed, state FROM birdstrikes GROUP BY state) AS  T where LENGTH(state) < 5;

-- 2862.5000