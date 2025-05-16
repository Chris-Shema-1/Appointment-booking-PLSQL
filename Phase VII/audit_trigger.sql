-- Trigger to log changes in the appointment table
CREATE OR REPLACE TRIGGER trg_appointment_audit
AFTER INSERT OR UPDATE OR DELETE ON appointment
FOR EACH ROW
DECLARE
  v_user VARCHAR2(150);
BEGIN
  -- Get the current user performing the operation
  SELECT SYS_CONTEXT('USERENV', 'SESSION_USER') INTO v_user FROM DUAL;

  -- INSERT operation
  IF INSERTING THEN
    INSERT INTO appointment_audit (appointment_id, operation_type, performed_by, action_time, new_status, cancel_reason)
    VALUES (:NEW.appointment_id, 'INSERT', v_user, SYSTIMESTAMP, :NEW.status, :NEW.cancel_reason);
  END IF;

  -- UPDATE operation
  IF UPDATING THEN
    INSERT INTO appointment_audit (appointment_id, operation_type, performed_by, action_time, old_status, new_status, cancel_reason)
    VALUES (:OLD.appointment_id, 'UPDATE', v_user, SYSTIMESTAMP, :OLD.status, :NEW.status, :NEW.cancel_reason);
  END IF;

  -- DELETE operation
  IF DELETING THEN
    INSERT INTO appointment_audit (appointment_id, operation_type, performed_by, action_time, old_status, cancel_reason)
    VALUES (:OLD.appointment_id, 'DELETE', v_user, SYSTIMESTAMP, :OLD.status, :OLD.cancel_reason);
  END IF;

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error in trigger: ' || SQLERRM);
END trg_appointment_audit;
/
