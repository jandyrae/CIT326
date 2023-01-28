-- Sales Orders Database
/*1. “List customers and the dates they placed an order, sorted in order date sequence.”
(Hint: The solution requires a JOIN of two tables.)
You can find the solution in CH08_Customers_And_OrderDates (944 rows).*/
use SalesOrdersExample;
select c.CustFirstName, c.CustLastName, o.OrderDate
	from Customers c inner join Orders o 
		on c.CustomerID = o.CustomerID
	order by o.OrderDate; 
    
/*2. “List employees and the customers for whom they booked an order.”
(Hint: The solution requires a JOIN of more than two tables.)
You can find the solution in CH08_Employees_And_Customers (211 rows).*/
use SalesOrdersExample;
select distinct e.EmployeeID, e.EmpFirstName, e.EmpLastName, c.CustFirstName, c.CustLastName
	from ((Customers c inner join Orders o 
		on c.CustomerID = o.CustomerID)
	inner join Employees e 
		on e.EmployeeID = o.EmployeeID)
	order by e.EmployeeID;

/*3. “Display all orders, the products in each order, and the amount owed for each product, in order number sequence.”
(Hint: The solution requires a JOIN of more than two tables.)
You can find the solution in CH08_Orders_With_Products (3,973 rows).*/
use SalesOrdersExample;
select o.OrderNumber, p.ProductName, p.RetailPrice, od.QuantityOrdered, (od.QuantityOrdered*p.RetailPrice) as amount_owed
	from ((Orders o inner join Order_Details od
		on o.OrderNumber = od.OrderNumber)
	inner join Products p on p.ProductNumber= od.ProductNumber)
	where o.OrderNumber = od.OrderNumber
	order by o.OrderNumber;

/*4. “Show me the vendors and the products they supply to us for products that cost less than $100.”
(Hint: The solution requires a JOIN of more than two tables.)
You can find the solution in CH08_Vendors_And_Products_Less_Than_100 (66 rows).*/
use SalesOrdersExample;
select v.VendName, p.ProductName, pv.WholesalePrice, p.RetailPrice
	from ((Vendors v inner join Product_Vendors pv
		on v.VendorID = pv.VendorID)
	inner join Products p on p.ProductNumber = pv.ProductNumber)
	where pv.WholesalePrice < '100.00'
	order by v.VendName;

/*5. “Show me customers and employees who have the same last name.”
(Hint: The solution requires a JOIN on matching values.)
You can find the solution in CH08_Customers_Employees_Same_LastName (16 rows).*/
use SalesOrdersExample;
select c.CustFirstName, c.CustLastName, e.EmpFirstName, e.EmpLastName 
	from Employees e inner join Customers c 
		on e.EmpLastName = c.CustLastName
	where c.CustLastName = e.EmpLastName
	order by e.EmpLastName;

/*6. “Show me customers and employees who live in the same city.”*/
use SalesOrdersExample;
select c.CustFirstName, c.CustLastName, c.CustCity, e.EmpCity, e.EmpFirstName, e.EmpLastName
	from Employees e inner join Customers c 
		on e.EmpCity = c.CustCity
	order by c.CustCity;
		

-- ************************************************************************************************

/*Bowling League Database
1. “List the bowling teams and all the team members.”
(Hint: The solution requires a JOIN of two tables.)
You can find the solution in CH08_Teams_And_Bowlers (32 rows).*/
use BowlingLeagueExample;
select t.TeamName, b.BowlerLastName, b.BowlerFirstName
	from Bowlers b inner join Teams t
		on b.TeamID = t.TeamID
	order by t.TeamName, b.BowlerLastName;

/*2. “Display the bowlers, the matches they played in, and the bowler game scores.”
(Hint: The solution requires a JOIN of more than two tables.)
You can find the solution in CH08_Bowler_Game_Scores (1,344 rows).*/
use BowlingLeagueExample;
select t.TeamName, b.BowlerLastName, b.BowlerFirstName, s.GameNumber, s.RawScore
	from Bowlers b inner join Bowler_Scores s
		on b.BowlerID = s.BowlerID
		join Teams t on t.TeamID = b.TeamID
	order by t.TeamName, b.BowlerLastName, b.BowlerFirstName;

/*3. “Find the bowlers who live in the same ZIP Code.”
(Hint: The solution requires a JOIN on matching values, and be sure to not match bowlers with themselves.)
You can find the solution in CH08_Bowlers_Same_ZipCode (92 rows).	*/	
use BowlingLeagueExample;
select b.BowlerFirstName, b.BowlerLastName, b.BowlerCity, b.BowlerZip, b.TeamID
	from Bowlers b join Bowlers bowler
		on b.BowlerID <> bowler.BowlerID
		where b.BowlerZip = bowler.BowlerZip
	order by b.BowlerZip;

