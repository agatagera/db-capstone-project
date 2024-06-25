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



use `littlelemondb`;

-- CREATE VIEW
CREATE VIEW OrdersView AS SELECT OrderID, Quantity, TotalCost FROM orders WHERE Quantity > 2;
select * from orders;
Select * from OrdersView;
-- DISPLAY RECORDS WHERE TOTALCOAST IS MORE THAN 150$
SELECT c.CustomerID, c.Names, o.OrderID, o.TotalCost, m.MenuName, m.Courses
FROM orders o
INNER JOIN customer c ON o.CustomerID = c.CustomerID
INNER JOIN menu m ON o.MenuID = m.MenuID
WHERE o.TotalCost > 150;

-- DISPLAY ITEMS FOR WHICH MORE THAN 2 ORDERS 
SELECT m.MenuName
FROM menu m
WHERE m.MenuID = ANY (
    SELECT o.MenuID
    FROM orders o
    GROUP BY o.MenuID
    HAVING COUNT(*) > 2
);

-- CREATE PROCEDURE GetMaxQuantity
DELIMITER //
CREATE PROCEDURE `GetMaxQuantity`()
BEGIN
    SELECT MAX(`Quantity`) AS `Max Quantity in Orders`
    FROM `orders`
END /
DELIMITER 

CALL GetMaxQuantity;

-- CREATE GetOrderDetail 
PREPARE GetOrderDetail FROM 
'SELECT OrderID, Quantity, TotalCost FROM Orders WHERE CustomerID = ?';
SET @id = 1;
EXECUTE GetOrderDetail USING @id;

-- CREATE PROCEDURE CancelOrder
DELIMITER //

CREATE PROCEDURE `CancelOrder` (IN `idorder` INT)
BEGIN
    DELETE FROM `orders` WHERE `OrderID` = `idorder`;
END //

DELIMITER ;
CALL CancelOrder (5);



-- INSERT VALUES INTO bookings
INSERT INTO bookings (BookingID, `Date`, TableNumber, CustomerID)
VALUES 
(1, '2022-10-10', 5, 1),
(2, '2022-11-12', 3, 3),
(3, '2022-10-11', 2, 2),
(4, '2022-10-13', 2, 1);


SELECT * FROM bookings;

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

CALL CheckBooking('2022-11-12', 3);


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
CALL AddValidBooking('2022-12-17', 6);


-- CREATE PROCEDURE AddBooking
DELIMITER //

CREATE PROCEDURE `AddBooking` (
    IN p_booking_id INT,
    IN p_booking_date DATE,
    IN p_table_number INT,
    IN p_customer_id INT
)
BEGIN
    DECLARE v_count INT;

    -- Check if the booking id already exists
    SELECT COUNT(*) INTO v_count
    FROM bookings
    WHERE `BookingID` = p_booking_id;

    IF v_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Booking ID already exists. Cannot insert.';
    ELSE
        -- Insert the new booking record
        INSERT INTO bookings (`BookingID`, `Date`, `TableNumber`, `CustomerID`)
        VALUES (p_booking_id, p_booking_date, p_table_number, p_customer_id);

        -- Optionally, you can return a success message or the inserted booking_id
        SELECT CONCAT('Booking ', p_booking_id, ' added successfully.') AS message;
    END IF;
END;//

DELIMITER ;

CALL AddBooking(9,3, '2022-12-30',4 );


-- CREATE PROCEDURE UpdateBooking
DELIMITER //

CREATE PROCEDURE `UpdateBooking` (
    IN p_booking_id INT,
    IN p_booking_date DATE
)
BEGIN
    DECLARE v_count INT;
    SELECT COUNT(*) INTO v_count
    FROM bookings
    WHERE BookingID = p_booking_id;

    IF v_count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Booking ID does not exist. Cannot update.';
    ELSE
        -- Update the booking record
        UPDATE bookings 
        SET `Date` = p_booking_date 
        WHERE BookingID = p_booking_id;

        SELECT CONCAT('Booking ', p_booking_id, ' updated successfully.') AS Confirmation;
    END IF;
END;//

DELIMITER ;

CALL UpdateBooking(9, '2022-12-17');


-- CREATE PROCEDURE CancelBooking
DELIMITER //

CREATE PROCEDURE `CancelBooking` (
    IN p_booking_id INT
)
BEGIN
    DECLARE v_count INT;
    SELECT COUNT(*) INTO v_count
    FROM bookings
    WHERE BookingID = p_booking_id;

    IF v_count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Booking ID does not exist. Cannot cancel.';
    ELSE
        DELETE FROM bookings
        WHERE BookingID = p_booking_id;
        SELECT CONCAT('Booking ', p_booking_id, ' cancelled successfully.') AS Confirmation;
    END IF;
END;//

DELIMITER ;


CALL CancelBooking(9);









