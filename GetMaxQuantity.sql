-- CREATE PROCEDURE GetMaxQuantity
DELIMITER //
CREATE PROCEDURE `GetMaxQuantity`()
BEGIN
    SELECT MAX(`Quantity`) AS `Max Quantity in Orders`
    FROM `orders`
END /
DELIMITER 