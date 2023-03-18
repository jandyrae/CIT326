/*
*	Jandy Kiger
*	week 5 Stepping Stone Part 1
*/

use SalesOrdersExample;
select o.OrderNumber, s.ProductName, s.RetailPrice, o.QuotedPrice 
	from office.Order_Details o
	join supplychain.Products s
		on o.ProductNumber = s.ProductNumber;

-- create view from above join
CREATE VIEW office.order_retail_vs_quoted AS
(select o.OrderNumber, s.ProductName, s.RetailPrice, o.QuotedPrice 
	from office.Order_Details o
	join supplychain.Products s
		on o.ProductNumber = s.ProductNumber);

select * from office.order_retail_vs_quoted;