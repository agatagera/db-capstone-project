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
    SELECT COUNT(*) INTO v_count
    FROM bookings
    WHERE `BookingID` = p_booking_id;

    IF v_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Booking ID already exists. Cannot insert.';
    ELSE
        INSERT INTO bookings (`BookingID`, `Date`, `TableNumber`, `CustomerID`)
        VALUES (p_booking_id, p_booking_date, p_table_number, p_customer_id);

        SELECT CONCAT('Booking ', p_booking_id, ' added successfully.') AS message;
    END IF;
END;//

DELIMITER ;
