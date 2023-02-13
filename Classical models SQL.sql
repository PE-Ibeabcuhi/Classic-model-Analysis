USE Classicmodels;

-- Total number of product lines and products
Select Count(Distinct productline) as 'product lines',
Count(Distinct ProductName) as 'products'
From Products;

-- Listing all the productlines and their products
Select Distinct Productline, Productname
From Products
Order by Productline;

-- Top 10 performing products
Select p.productName, 
sum(OD.priceEach) as 'Unit price', 
sum(OD.quantityOrdered) as 'total quantity', 
sum( OD.priceEach * OD.quantityOrdered) as 'Revenue'
From Products as p
Left Join OrderDetails as OD
on p.productCode= OD.productCode
Group by p.productName
Order by total_qty Desc
Limit 10;

-- Best performing productline
Select p.productline as 'Product lines',
sum(OD.quantityOrdered) as 'total quantity', 
sum( OD.priceEach * OD.quantityOrdered) as 'Revenue'
From Products as p
Left Join OrderDetails as OD
on p.productCode= OD.productCode
Group by p.productline
Order by total_qty Desc;

-- Best Peforming Employees for the current year
Select employeeNumber, concat(e.firstname ," ", e.lastname) as Employee,
sum(p.amount) as 'Total revenue generated'
From employees as e
Left Join customers as c
on e.employeeNumber=c.salesrepemployeenumber
Left Join payments as p
on c.customerNumber = p.customerNumber
Where Year(p.paymentdate)=2005
Group By 1
Order By Sum(p.amount) DESC;

-- Listing the names of all the managers
select concat(e.firstname ," ", e.lastname) as Managers,
employeeNumber
From employees as e
Where e.jobtitle like '%Manager%';

-- Best Peforming manager for the current year
Select reportsto as 'Managers ID',
sum(p.amount) as 'Total revenue generated'
From employees as e
Left Join customers as c
on e.employeeNumber=c.salesrepemployeenumber
Left Join payments as p
on c.customerNumber = p.customerNumber
Where reportsto in (1088,1102,1143) and year(paymentdate)=2005
Group By 1
Order By 1 DESC;

-- Most profitable customers
Select 
CustomerName, 
Count(OD.quantityordered) as 'Number of times Ordered', 
sum(OD.quantityordered) as 'Total Qty orders',
sum( OD.priceEach * OD.quantityOrdered) as Revenue
From customers as c
Left join orders as o
on c.customerNumber = o.customernumber
Left join orderdetails as OD
on od.ordernumber = OD.ordernumber
Group By CustomerName
order by 4 DESC
Limit 10;

-- Monthly Revenue generated
Select Year(paymentdate) As Year,
Month(paymentdate) AS Month,
sum(amount) as 'Revenue',
-- calculating Y.o.y change
Round((sum(amount) - LAG(Sum(amount),12) OVER (ORDER BY year(paymentdate), month(paymentdate)))/
LAG(Sum(amount),12) OVER (ORDER BY year(paymentdate), month(paymentdate))*100,2) AS 'Y.O.Y'
From payments
Where Year(paymentdate) = 2005 or Year(paymentdate)= 2004
Group By Year(paymentdate),Month(paymentdate)
Order By year(paymentdate) DESC
Limit 6;

-- The distribution of ferraris
Select p.productname, 
c.city,
sum(od.quantityordered)as 'total qty ordered',
sum(p.buyprice*od.quantityordered) as 'total amount paid',
sum(p.quantityinstock - od.quantityordered) as 'Current Quantity in stock'
From customers as c
Left join orders as o
on c.customernumber =o.customernumber
Left join orderdetails as od
on o.ordernumber= od.ordernumber
Left join products as p
on od.productcode = p.productcode
Where p.productname like '%ferrari%'
Group by p.productname,c.city
Order by 3 DESC;

-- Average no of days it takes to ship each product
Select p.productName,  
Round(Avg(o.shippeddate - o.orderdate)) as 'Avg No days to deliver'
From Products as p
Left Join OrderDetails as OD
on p.productCode= OD.productCode
Left Join Orders as O
on OD.OrderNumber= O.OrderNumber
Group by p.productName;