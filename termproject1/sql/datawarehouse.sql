-- some sanity checks

select * from coach_stats;

select count(distinct Name) from coach_stats;
select count(Name) from coach_stats;
-- its ok that the name is the key for coach_stats as it is unique

select * from player_stats;

select count(distinct Player) from player_stats;
select count(Player) from player_stats;
-- its not ok that the Player is the key for player_stats as it is not unique

select Player, count(*) from player_stats group by Player having count(*) > 1;

-- after checking the players on https://www.basketball-reference.com/
-- there are no players with the same name just that some players changed teams and then they have multiple rows

select * from players;
select * from team_stats;
select * from teams;



-- datawarehouse

DROP PROCEDURE IF EXISTS CreateTeamCoachPlayerMap;

DELIMITER //

CREATE PROCEDURE CreateTeamCoachPlayerMap()
BEGIN

	DROP TABLE IF EXISTS product_sales;

	CREATE TABLE product_sales AS
	SELECT 
	   orders.orderNumber AS SalesId, 
	   orderdetails.priceEach AS Price, 
	   orderdetails.quantityOrdered AS Unit,
	   products.productName AS Product,
	   products.productLine As Brand,   
	   customers.city As City,
	   customers.country As Country,   
	   orders.orderDate AS Date,
	   WEEK(orders.orderDate) as WeekOfYear
	FROM
		orders
	INNER JOIN
		orderdetails USING (orderNumber)
	INNER JOIN
		products USING (productCode)
	INNER JOIN
		customers USING (customerNumber)
	ORDER BY 
		orderNumber, 
		orderLineNumber;

END //
DELIMITER ;


CALL CreateProductSalesStore();