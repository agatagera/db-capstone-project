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