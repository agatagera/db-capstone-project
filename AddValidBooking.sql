
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