-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema littlelemondb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema littlelemondb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `littlelemondb` DEFAULT CHARACTER SET utf8mb3 ;
USE `littlelemondb` ;

-- -----------------------------------------------------
-- Table `littlelemondb`.`customer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `littlelemondb`.`customer` (
  `CustomerID` INT NOT NULL,
  `CustomerName` VARCHAR(45) NOT NULL,
  `CustomerPhone` VARCHAR(45) NOT NULL,
  `CustomerBirthdate` DATE NOT NULL,
  `CustomerEmail` VARCHAR(45) NOT NULL,
  `CustomerAddress` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`CustomerID`),
  UNIQUE INDEX `CustomerEmail_UNIQUE` (`CustomerEmail` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `littlelemondb`.`booking`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `littlelemondb`.`booking` (
  `BookingID` INT NOT NULL AUTO_INCREMENT,
  `BookingTable` INT NOT NULL,
  `BookingDate` DATE NOT NULL,
  `CustomerID` INT NOT NULL,
  PRIMARY KEY (`BookingID`),
  INDEX `fk_Booking_Customer1_idx` (`CustomerID` ASC) VISIBLE,
  CONSTRAINT `fk_Booking_Customer1`
    FOREIGN KEY (`CustomerID`)
    REFERENCES `littlelemondb`.`customer` (`CustomerID`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `littlelemondb`.`menuitem`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `littlelemondb`.`menuitem` (
  `MenuItemID` INT NOT NULL,
  `MenuItemCourse` VARCHAR(45) NOT NULL,
  `MenuItemStarter` VARCHAR(45) NOT NULL,
  `MenuItemDessert` VARCHAR(45) NOT NULL,
  `MenuItemDrink` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`MenuItemID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `littlelemondb`.`menu`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `littlelemondb`.`menu` (
  `MenuID` INT NOT NULL,
  `MenuCuisine` VARCHAR(45) NOT NULL,
  `MenuName` VARCHAR(45) NOT NULL,
  `MenuItemID` INT NOT NULL,
  PRIMARY KEY (`MenuID`),
  INDEX `fk_Menu_MenuItem1_idx` (`MenuItemID` ASC) VISIBLE,
  CONSTRAINT `fk_Menu_MenuItem1`
    FOREIGN KEY (`MenuItemID`)
    REFERENCES `littlelemondb`.`menuitem` (`MenuItemID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `littlelemondb`.`order`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `littlelemondb`.`order` (
  `OrderID` INT NOT NULL AUTO_INCREMENT,
  `OrderDate` DATE NOT NULL,
  `OrderQty` INT NOT NULL,
  `OrderCost` DECIMAL(10,0) NOT NULL,
  `MenuID` INT NOT NULL,
  `BookingID` INT NOT NULL,
  PRIMARY KEY (`OrderID`),
  INDEX `fk_Orders_Menu1_idx` (`MenuID` ASC) VISIBLE,
  INDEX `fk_Order_Booking1_idx` (`BookingID` ASC) VISIBLE,
  CONSTRAINT `fk_Order_Booking1`
    FOREIGN KEY (`BookingID`)
    REFERENCES `littlelemondb`.`booking` (`BookingID`),
  CONSTRAINT `fk_Orders_Menu1`
    FOREIGN KEY (`MenuID`)
    REFERENCES `littlelemondb`.`menu` (`MenuID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `littlelemondb`.`role`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `littlelemondb`.`role` (
  `RoleID` INT NOT NULL,
  `Title` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`RoleID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `littlelemondb`.`staff`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `littlelemondb`.`staff` (
  `StaffID` INT NOT NULL,
  `StaffName` VARCHAR(45) NOT NULL,
  `StaffEmail` VARCHAR(255) NOT NULL,
  `StaffSalary` DECIMAL(10,0) NOT NULL,
  `StaffRole` INT NOT NULL,
  PRIMARY KEY (`StaffID`),
  UNIQUE INDEX `StaffEmail_UNIQUE` (`StaffEmail` ASC) VISIBLE,
  INDEX `fk_Staff_Role1_idx` (`StaffRole` ASC) VISIBLE,
  CONSTRAINT `fk_Staff_Role1`
    FOREIGN KEY (`StaffRole`)
    REFERENCES `littlelemondb`.`role` (`RoleID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `littlelemondb`.`orderdelivery`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `littlelemondb`.`orderdelivery` (
  `DeliveryID` INT NOT NULL,
  `DeliveryDate` DATE NOT NULL,
  `DeliveryStatus` VARCHAR(45) NOT NULL,
  `StaffID` INT NOT NULL,
  `OrderID` INT NOT NULL,
  PRIMARY KEY (`DeliveryID`),
  INDEX `fk_OrdersDelivery_Staff1_idx` (`StaffID` ASC) VISIBLE,
  INDEX `fk_OrderDelivery_Order1_idx` (`OrderID` ASC) VISIBLE,
  CONSTRAINT `fk_OrderDelivery_Order1`
    FOREIGN KEY (`OrderID`)
    REFERENCES `littlelemondb`.`order` (`OrderID`),
  CONSTRAINT `fk_OrdersDelivery_Staff1`
    FOREIGN KEY (`StaffID`)
    REFERENCES `littlelemondb`.`staff` (`StaffID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb3;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
