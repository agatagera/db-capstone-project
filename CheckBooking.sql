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