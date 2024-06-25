# db-captone-project

## Create an ER diagram data model 

![LittleLemonDM](https://github.com/agatagera/db-capstone-project/assets/165961165/c11013c5-8739-4fd9-a928-13c18472fe2e)

## Implement the Little Lemon data model inside MySQL server
```
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema LittleLemonDB
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema LittleLemonDB
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `LittleLemonDB` DEFAULT CHARACTER SET utf8 ;
USE `LittleLemonDB` ;

-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Order Delivery Status`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Order Delivery Status` (
  `StatusID` INT NOT NULL,
  `DeliveryDate` DATE NOT NULL,
  `DeliverySatus` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`StatusID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Menu`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Menu` (
  `MenuID` INT NOT NULL,
  `Starters` VARCHAR(255) NOT NULL,
  `Cuisines` VARCHAR(255) NOT NULL,
  `Courses` VARCHAR(255) NOT NULL,
  `Drinks` VARCHAR(255) NOT NULL,
  `Desserts` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`MenuID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Bookings`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Bookings` (
  `BookingID` INT NOT NULL,
  `Date` DATE NOT NULL,
  `TableNumber` INT NOT NULL,
  PRIMARY KEY (`BookingID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Staff`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Staff` (
  `StaffID` INT NOT NULL,
  `Name` VARCHAR(255) NOT NULL,
  `Role` VARCHAR(255) NOT NULL,
  `Salary` INT NOT NULL,
  PRIMARY KEY (`StaffID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Customer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Customer` (
  `CustomerID` INT NOT NULL,
  `Contacts` VARCHAR(255) NOT NULL,
  `Names` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`CustomerID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Orders` (
  `OrderID` INT NOT NULL,
  `OrderDate` DATE NOT NULL,
  `Quantity` INT NOT NULL,
  `TotalCost` DECIMAL NOT NULL,
  `StatusID` INT NOT NULL,
  `MenuID` INT NOT NULL,
  `BookingID` INT NOT NULL,
  `StaffID` INT NOT NULL,
  `CustomerID` INT NOT NULL,
  PRIMARY KEY (`OrderID`),
  INDEX `fk_Orders_Order Delivery Status_idx` (`StatusID` ASC) VISIBLE,
  INDEX `fk_Orders_Menu1_idx` (`MenuID` ASC) VISIBLE,
  INDEX `fk_Orders_Bookings1_idx` (`BookingID` ASC) VISIBLE,
  INDEX `fk_Orders_Staff1_idx` (`StaffID` ASC) VISIBLE,
  INDEX `fk_Orders_Customer1_idx` (`CustomerID` ASC) VISIBLE,
  CONSTRAINT `fk_Orders_Order Delivery Status`
    FOREIGN KEY (`StatusID`)
    REFERENCES `LittleLemonDB`.`Order Delivery Status` (`StatusID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Orders_Menu1`
    FOREIGN KEY (`MenuID`)
    REFERENCES `LittleLemonDB`.`Menu` (`MenuID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Orders_Bookings1`
    FOREIGN KEY (`BookingID`)
    REFERENCES `LittleLemonDB`.`Bookings` (`BookingID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Orders_Staff1`
    FOREIGN KEY (`StaffID`)
    REFERENCES `LittleLemonDB`.`Staff` (`StaffID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Orders_Customer1`
    FOREIGN KEY (`CustomerID`)
    REFERENCES `LittleLemonDB`.`Customer` (`CustomerID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
```
##  Create a virtual table called OrdersView
```
-- CREATE VIEW OrdersView
CREATE VIEW OrdersView AS SELECT OrderID, Quantity, TotalCost FROM orders WHERE Quantity > 2;
select * from orders;
Select * from OrdersView;
```
## Display recors where TotalCost is more than 150$ using JOIN clause
```

-- DISPLAY RECORDS WHERE TOTALCOAST IS MORE THAN 150$
SELECT c.CustomerID, c.Names, o.OrderID, o.TotalCost, m.MenuName, m.Courses
FROM orders o
INNER JOIN customer c ON o.CustomerID = c.CustomerID
INNER JOIN menu m ON o.MenuID = m.MenuID
WHERE o.TotalCost > 150;
```
## Display items for which there are more than 2 orders

```
-- DISPLAY ITEMS FOR WHICH HAVE MORE THAN 2 ORDERS 
SELECT m.MenuName
FROM menu m
WHERE m.MenuID = ANY (
    SELECT o.MenuID
    FROM orders o
    GROUP BY o.MenuID
    HAVING COUNT(*) > 2
);
```

## Create store procedure called GetMaxQuantity 
```
-- CREATE PROCEDURE GetMaxQuantity
DELIMITER //
CREATE PROCEDURE `GetMaxQuantity`()
BEGIN
    SELECT MAX(`Quantity`) AS `Max Quantity in Orders`
    FROM `orders`
END /
DELIMITER
```
## Create a prepared statement called GetOrderDetail

```
-- CREATE GetOrderDetail 
PREPARE GetOrderDetail FROM 
'SELECT OrderID, Quantity, TotalCost FROM Orders WHERE CustomerID = ?';
SET @id = 1;
EXECUTE GetOrderDetail USING @id;
```

## Create a stored procedure called CancelOrder
```
-- CREATE PROCEDURE CancelOrder
DELIMITER //

CREATE PROCEDURE `CancelOrder` (IN `idorder` INT)
BEGIN
    DELETE FROM `orders` WHERE `OrderID` = `idorder`;
END //

DELIMITER ;
CALL CancelOrder (5);
```
## Insert data into bookings table

```
-- INSERT VALUES INTO bookings
INSERT INTO bookings (BookingID, `Date`, TableNumber, CustomerID)
VALUES 
(1, '2022-10-10', 5, 1),
(2, '2022-11-12', 3, 3),
(3, '2022-10-11', 2, 2),
(4, '2022-10-13', 2, 1);
```

## Create a stored procedure called CheckBooking 
```
-- CREATE PROCEDURE CheckBooking
DELIMITER //

CREATE PROCEDURE `CheckBooking` (IN booking_date DATE, IN table_number INT)
BEGIN
    DECLARE bookedCount INT DEFAULT 0;
    SELECT COUNT(*) INTO bookedCount
    FROM Bookings 
    WHERE `Date` = booking_date AND `TableNumber` = table_number;

    IF bookedCount > 0 THEN
        SELECT CONCAT("Table ", table_number, " is already booked") AS `Booking status`;
    ELSE
        SELECT CONCAT("Table ", table_number, " is not booked") AS `Booking status`;
    END IF;
    END;//

DELIMITER ;
```

## Create a new procedure called AddValidBooking

```

-- CREATE PROCEDURE AddValidBooking
DELIMITER //

CREATE PROCEDURE `AddValidBooking` (IN booking_date DATE, IN table_number INT)
BEGIN
    DECLARE bookedCount INT DEFAULT 0;
    SELECT COUNT(*) INTO bookedCount
    FROM Bookings
    WHERE `Date` = booking_date AND `TableNumber` = table_number;

    START TRANSACTION;
    IF bookedCount > 0 THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Table is already booked for this date.';
    ELSE
        INSERT INTO Bookings (`Date`, TableNumber, CustomerName)
        VALUES (booking_date, table_number, customer_name);
        COMMIT;
    END IF;
END//

DELIMITER ;
```





