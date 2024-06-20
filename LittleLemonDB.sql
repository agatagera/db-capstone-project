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
-- Table `LittleLemonDB`.`Bookings`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Bookings` (
  `idBooking` INT NOT NULL,
  `BookingDate` DATE NOT NULL,
  `TableNumber` INT NOT NULL,
  PRIMARY KEY (`idBooking`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Order Delivery Status`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Order Delivery Status` (
  `idOrder Delivery Status` INT NOT NULL AUTO_INCREMENT,
  `DeliveryDate` DATE NOT NULL,
  `DeveliryStatus` VARCHAR(255) NULL,
  PRIMARY KEY (`idOrder Delivery Status`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Menu`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Menu` (
  `idMenu` INT NOT NULL,
  `CourseName` VARCHAR(255) NOT NULL,
  `CuisineName` VARCHAR(255) NOT NULL,
  `StarterName` VARCHAR(255) NOT NULL,
  `DesertName` VARCHAR(255) NOT NULL,
  `Drink` VARCHAR(255) NOT NULL,
  `Sides` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`idMenu`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Customer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Customer` (
  `idCustomer` INT NOT NULL,
  `Name` VARCHAR(255) NOT NULL,
  `Contact` INT NULL,
  PRIMARY KEY (`idCustomer`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Staff`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Staff` (
  `idStaff` INT NOT NULL,
  `Role` VARCHAR(255) NOT NULL,
  `Salary` DECIMAL NOT NULL,
  PRIMARY KEY (`idStaff`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LittleLemonDB`.`Orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LittleLemonDB`.`Orders` (
  `idOrders` INT NOT NULL,
  `OrderDate` DATE NOT NULL,
  `Quantity` INT NOT NULL,
  `TotalCost` DECIMAL NOT NULL,
  `Order Delivery Status_idOrder Delivery Status` INT NOT NULL,
  `Menu_idMenu` INT NOT NULL,
  `Customer_idCustomer` INT NOT NULL,
  `Bookings_idBooking` INT NOT NULL,
  `Staff_idStaff` INT NOT NULL,
  PRIMARY KEY (`idOrders`),
  INDEX `fk_Orders_Order Delivery Status_idx` (`Order Delivery Status_idOrder Delivery Status` ASC) VISIBLE,
  INDEX `fk_Orders_Menu1_idx` (`Menu_idMenu` ASC) VISIBLE,
  INDEX `fk_Orders_Customer1_idx` (`Customer_idCustomer` ASC) VISIBLE,
  INDEX `fk_Orders_Bookings1_idx` (`Bookings_idBooking` ASC) VISIBLE,
  INDEX `fk_Orders_Staff1_idx` (`Staff_idStaff` ASC) VISIBLE,
  CONSTRAINT `fk_Orders_Order Delivery Status`
    FOREIGN KEY (`Order Delivery Status_idOrder Delivery Status`)
    REFERENCES `LittleLemonDB`.`Order Delivery Status` (`idOrder Delivery Status`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Orders_Menu1`
    FOREIGN KEY (`Menu_idMenu`)
    REFERENCES `LittleLemonDB`.`Menu` (`idMenu`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Orders_Customer1`
    FOREIGN KEY (`Customer_idCustomer`)
    REFERENCES `LittleLemonDB`.`Customer` (`idCustomer`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Orders_Bookings1`
    FOREIGN KEY (`Bookings_idBooking`)
    REFERENCES `LittleLemonDB`.`Bookings` (`idBooking`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Orders_Staff1`
    FOREIGN KEY (`Staff_idStaff`)
    REFERENCES `LittleLemonDB`.`Staff` (`idStaff`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
