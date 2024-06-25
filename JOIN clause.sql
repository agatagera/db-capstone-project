
-- DISPLAY RECORDS WHERE TOTALCOAST IS MORE THAN 150$
SELECT c.CustomerID, c.Names, o.OrderID, o.TotalCost, m.MenuName, m.Courses
FROM orders o
INNER JOIN customer c ON o.CustomerID = c.CustomerID
INNER JOIN menu m ON o.MenuID = m.MenuID
WHERE o.TotalCost > 150;