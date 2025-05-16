-- Trigger to prevent cancellation within 24 hours
CREATE OR REPLACE TRIGGER trg_prevent_cancel
BEFORE UPDATE ON appointment
FOR EACH ROW
BEGIN
  -- Ensure that the status is being changed to 'Canceled'
  IF :NEW.status = 'Canceled' THEN
    -- Check if the appointment is within 24 hours
    IF :OLD.appointment_date <= SYSDATE + INTERVAL '1' DAY THEN
      RAISE_APPLICATION_ERROR(-20002, 'Cannot cancel appointments within 24 hours of the scheduled time.');
    END IF;
  END IF;

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error in cancellation prevention: ' || SQLERRM);
END trg_prevent_cancel;
/
