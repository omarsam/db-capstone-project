-- Task #1
USE LittleLemonDB;
DROP VIEW IF EXISTS OrdersView;
CREATE VIEW OrdersView AS
    SELECT 
        OrderID, Quantity, TotalCost
    FROM
        Orders;
SELECT 
    *
FROM
    OrdersView;

-- Task #2
SELECT 
    c.CustomerID,
    c.Name,
    o.OrderID,
    o.TotalCost,
    m.Name,
    mi.Course,
    mi.Starter
FROM
    Customers AS c
        INNER JOIN
    Orders AS o ON c.CustomerID = o.CustomerID
        INNER JOIN
    Menus AS m ON o.MenuID = m.MenuID
        INNER JOIN
    MenuContent AS mc ON m.MenuID = mc.MenuID
        INNER JOIN
    MenuItems AS mi ON mc.MenuItemID = mi.MenuItemID
WHERE
    o.TotalCost > 500;

-- Task #3
SELECT 
    Name
FROM
    Menus
WHERE
    MenuID = ANY (SELECT 
            MenuID
        FROM
            Orders
        WHERE
            Quantity > 2);

-- Task #1 :Stored Procedure
DROP PROCEDURE IF EXISTS GetMaxQuantity;
CREATE PROCEDURE GetMaxQuantity() SELECT MAX(Quantity) AS GetMaxQuantity FROM Orders;
CALL GetMaxQuantity();

-- Task #2 :Stored Procedure
PREPARE GetOrderDetail FROM 'select OrderID, Quantity, TotalCost from Orders where OrderID=?';
SET @id = 1;
EXECUTE GetOrderDetail USING @id;

-- Task #3 :Stored Procedure
DROP PROCEDURE IF EXISTS CancelOrder;
DELIMITER \\
CREATE PROCEDURE CancelOrder(Orderid INT) 
BEGIN
DELETE FROM Orders WHERE OrderID=Orderid;
SELECT CONCAT("Order ", OrderID, " is cancelled") AS Confirmation;
END\\
DELIMITER ;

CALL CancelOrder(5);

-- Task #1 :Table Booking System
SET FOREIGN_KEY_CHECKS=0;
INSERT INTO Bookings (BookingID, Date, TableNumber, CustomerID)
VALUES 	(1, "2022-10-10", 5, 1),
		(2, "2022-11-12", 3, 3),
		(3, "2022-10-11", 2, 2),
		(4 ,"2022-10-13", 2, 1);
SELECT 
    *
FROM
    bookings;

-- Task #2 :Table Booking System
DROP PROCEDURE IF EXISTS CheckBooking;
CREATE PROCEDURE CheckBooking(BookingDate DATE,TableNumber INT)
	SELECT CONCAT("Table ", TableNumber, " is already booked")
    WHERE EXISTS (SELECT * FROM Bookings WHERE Date = BookingDate AND TableNumber = TableNumber);
CALL CheckBooking("2022-11-12", 3);

-- Task #3 :Table Booking System
DROP PROCEDURE IF EXISTS AddValidBooking;
DROP FUNCTION IF EXISTS Validate;

DELIMITER $$

CREATE FUNCTION Validate(RecordsFound INTEGER, message VARCHAR(255)) RETURNS INTEGER DETERMINISTIC
BEGIN
    IF RecordsFound IS NOT NULL OR RecordsFound > 0 THEN
        SIGNAL SQLSTATE 'ERR0R' SET MESSAGE_TEXT = message;
    END IF;
    RETURN RecordsFound;
END$$

CREATE PROCEDURE AddValidBooking(IN BookingDate DATE, IN TableNumber INT)
	BEGIN
		DECLARE `_rollback` BOOL DEFAULT 0;
		DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;
		START TRANSACTION;
        
        SELECT Validate(COUNT(*), CONCAT("Table ", TableNumber, " is already booked"))
        FROM bookings
        WHERE date = BookingDate AND table_number = TableNumber;
        
		INSERT INTO bookings (date, table_number)
		VALUES (BookingDate, TableNumber);
		
		IF `_rollback` THEN
			SELECT CONCAT("Table ", TableNumber, " is already booked - booking cancelled") AS "Booking status";
			ROLLBACK;
		ELSE
			COMMIT;
		END IF;
    END$$
    
DELIMITER ;

CALL AddValidBooking("2022-12-17", 6);
DROP PROCEDURE IF EXISTS AddValidBooking;
DROP FUNCTION IF EXISTS Validate;

DELIMITER $$

CREATE FUNCTION Validate(RecordsFound INTEGER, message VARCHAR(255)) RETURNS INTEGER DETERMINISTIC
BEGIN
    IF RecordsFound IS NOT NULL OR RecordsFound > 0 THEN
        SIGNAL SQLSTATE 'ERR0R' SET MESSAGE_TEXT = message;
    END IF;
    RETURN RecordsFound;
END$$

CREATE PROCEDURE AddValidBooking(IN BookingDate DATE, IN TableNumber INT)
	BEGIN
		DECLARE `_rollback` BOOL DEFAULT 0;
		DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET `_rollback` = 1;
		START TRANSACTION;
        
        SELECT Validate(COUNT(*), CONCAT("Table ", TableNumber, " is already booked"))
        FROM bookings
        WHERE date = BookingDate AND table_number = TableNumber;
        
		INSERT INTO bookings (date, table_number)
		VALUES (BookingDate, TableNumber);
		
		IF `_rollback` THEN
			SELECT CONCAT("Table ", TableNumber, " is already booked - booking cancelled") AS "Booking status";
			ROLLBACK;
		ELSE
			COMMIT;
		END IF;
    END$$
    
DELIMITER ;

CALL AddValidBooking("2022-12-17", 6);

-- Task #1 :Add And Update Bookings
DROP PROCEDURE IF EXISTS AddBooking; 
DELIMITER $$ 
CREATE PROCEDURE AddBooking(IN BookingID INT, IN CustomerID INT, IN TableNumber INT, IN BookingDate DATE)
BEGIN 
INSERT INTO bookings (BookingID, CustomerID, TableNumber, date) VALUES (BookingID, CustomerID, TableNumber, BookingDate); 
SELECT "New booking added" AS "Confirmation";
END$$ DELIMITER ; 
CALL AddBooking(9, 3, 4, "2022-12-30");

-- Task #2 :Add And Update Bookings
DROP PROCEDURE IF EXISTS UpdateBooking;
DELIMITER $$ 
CREATE PROCEDURE UpdateBooking(IN BookingID INT, IN BookingDate DATE) 
BEGIN
UPDATE bookings SET date = BookingDate WHERE BookingDate = BookingID; 
SELECT CONCAT("Booking ", BookingID, " updated") AS "Confirmation"; 
END$$ 
DELIMITER ; 
CALL UpdateBooking(9, "2022-12-17");

-- Task #3 :Add And Update Bookings
DROP PROCEDURE IF EXISTS CancelBooking; 
DELIMITER $$ 
CREATE PROCEDURE CancelBooking(IN BookingID INT) 
BEGIN 
DELETE FROM bookings WHERE BookingID = BookingID; SELECT CONCAT("Booking ", BookingID, " cancelled") AS "Confirmation"; 
END$$ 
DELIMITER ; 
CALL CancelBooking(9);