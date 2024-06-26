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
