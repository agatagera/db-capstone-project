-- CREATE VIEW OrdersView
CREATE VIEW OrdersView AS SELECT OrderID, Quantity, TotalCost FROM orders WHERE Quantity > 2;
select * from orders;
Select * from OrdersView;