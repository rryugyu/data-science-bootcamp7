.open restaurant.db
.mode column
.header on

-- สร้าง TABLE
CREATE TABLE IF NOT EXISTS employees (
  EmployeeId INT UNIQUE PRIMARY KEY,
  Name TEXT,
  Level TEXT,
  ManagerId INT,
  Salary REAL
);

INSERT INTO employees VALUES
  (1, 'Gyu', 'Owner', NULL, NULL),
  (2, 'Baiyok', 'Administrator', 1, 35000),
  (3, 'Gus', 'Exec Chef', 1, 35000),
  (4, 'Change', 'Waiter', 1, 12000),
  (5, 'Benz', 'Sous Chef', 3, 27000),
  (6, 'Pun', 'Cook', 5, 18000),
  (7, 'Noey', 'Cook', 5, 18000),
  (8, 'Deer', 'Cashier', 2, 17000),
  (9, 'Leo', 'Cleaning staff', 4, 12000);

CREATE TABLE IF NOT EXISTS menus (
  MenuId INT UNIQUE PRIMARY KEY,
  Name TEXT,
  OrderId INT
);

INSERT INTO menus VALUES
  (1, 'Stirfried Rice Noodles with Chicken', 2),
  (2, 'Fried Rice', 2),
  (3, 'Salad', 1),
  (4, 'Pineapple Carpaccio', 3);

CREATE TABLE IF NOT EXISTS customers (
  CustomerId INT UNIQUE PRIMARY KEY,
  Name TEXT,
  Country TEXT,
  Age INT,
  Gender TEXT,
  MenuId TEXT
);

INSERT INTO customers VALUES
  (1, 'Josh', 'USA', 37, 'Male', 1),
  (2, 'Ken', 'Laos', 30, 'Male', 1),
  (3, 'Bank', 'Thailand', 27, 'Male', 2),
  (4, 'Pim', 'Thailand', 22, 'Female',1),
  (5, 'Kendal', 'USA', 29, 'Female', 1),
  (6, 'Gigi', 'USA', 29, 'Female', 1),
  (7, 'Justin', 'Canada', 29, 'Male', 3),
  (8, 'Garfield', 'Thailand', 17, 'Male', 4),
  (9, 'Cartoon', 'Thailand', 14, 'Male', 4),
  (10, 'Udom', 'Thailand', 71, 'Male', 1),
  (11, 'Parada', 'Thailand', 47, 'Female', 1),
  (12, 'Haaland', 'Norway', 22, 'Male', 1),
  (13, 'Grealish', 'United Kingdom', 27, 'Male', 2),
  (14, 'Messi', 'Argentina', 35, 'Male', 2),
  (15, 'Aguero', 'Argentina', 34, 'Male', 1),
  (16, 'Phoden', 'United Kingdom', 22, 'Male', 2),
  (17, 'Adele', 'United Kingdom', 34, 'Female', 3),
  (18, 'Mahrez', 'France', 32, 'Male', 4),
  (19, 'Mbappe', 'France', 23, 'Male', 4),
  (20, 'Gabi', 'Spain', 19, 'Male', 2);

CREATE TABLE IF NOT EXISTS ingredients (
  IngredientId INT UNIQUE PRIMARY KEY,
  Name TEXT,
  MenuId INT
);

INSERT INTO ingredients VALUES
  (1, 'rice', 2),
  (2, 'wide rice noodles', 1),
  (3, 'tomatos', 3),
  (4, 'garlics', 1),
  (5, 'cream', 4),
  (6, 'pork', 1),
  (7, 'egg', 2),
  (8, 'tofu', 1),
  (9, 'sausage', 1),
  (10, 'dried shrimp', 1),
  (11, 'Parmesan cheese', 3),
  (12, 'romaine heart', 3),
  (13, 'leafy lettuce', 3),
  (14, 'sugar', 4),
  (15, 'lemon grass', 4),
  (16, 'gelatin', 4),
  (17, 'lemon zest', 4);
  
CREATE TABLE IF NOT EXISTS orders (
  OrderId INT PRIMARY KEY,
  Type TEXT
);

INSERT INTO orders VALUES
  (1, 'Appitizer'),
  (2, 'Main course'),
  (3, 'Desserts');

-- พนักงานคนไหนทำงานขึ้นกับใคร
SELECT 
  e1.name AS Staff,
  e1.level as Staff_Level,
  e2.name AS Manager,
  e2.level AS Manager_Level,
  e1.name || ' reports to ' || e2.name AS comment
FROM employees e1, employees e2
WHERE e1.managerid = e2.employeeid;

-- Gyu ต้องจ่ายเงินเดือนพนักงานทั้งหมด เดือนละเท่าไหร่
SELECT 
	SUM(salary) as personnel_expense
from employees;

-- TOP3 ลูกค้าที่มาทานอาหารที่ร้านเรา มาจากประเทศอะไร และมีค่าเฉลี่ยอายุเท่าไหร่
SELECT
		country,
    COUNT(country) as n_country,
    AVG(age) as ageAverage
from customers
group by country
order by n_country DESC
limit 3;

--แต่ละเมนูจัดอยู่ใน order ชนิดไหน และแต่ละเมนูใช้วัตถุดิบอะไรบ้าง
SELECT * FROM (
	SELECT 
		menus.Name menu,
   		orders.Type orderType,
   		ingredients.Name ingredientName
	from menus, orders, ingredients
	WHERE orders.OrderId = menus.OrderId
	  and menus.MenuId = ingredients.MenuId
) as sub
order by menu;

--แต่ละช่วงอายุ ชอบทานเมนูไหนมากที่สุด
with sub as 
	(
    SELECT 
	  		customerid,
	  		menus.name as menu,
      	age,
		case when age BETWEEN 12 and 20 then 'Teenager'
	       when age BETWEEN 21 and 60 then 'Adult'
         ELSE 'Old'
         end as span_of_age
	from customers, menus
  	WHERE menus.menuid = customers.menuid
  	)
SELECT 
		span_of_age,
    COUNT(span_of_age),
    menu
from sub
group by span_of_age
order by COUNT(span_of_age) DESC;
