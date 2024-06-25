-- CREATE PROCEDURE CancelOrder
DELIMITER //

CREATE PROCEDURE `CancelOrder` (IN `idorder` INT)
BEGIN
    DELETE FROM `orders` WHERE `OrderID` = `idorder`;
END //

DELIMITER ;
CALL CancelOrder (5);