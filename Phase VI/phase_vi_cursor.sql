-- phase_vi_cursor.sql

DECLARE
  CURSOR appt_cursor IS 
    SELECT appointment_id, appointment_date, appointment_time 
    FROM appointment 
    WHERE provider_id = 11 AND status = 'Scheduled';
    
  v_appt_id NUMBER;
  v_date    DATE;
  v_time    TIMESTAMP;
BEGIN
  OPEN appt_cursor;
  
  LOOP
    FETCH appt_cursor INTO v_appt_id, v_date, v_time;
    EXIT WHEN appt_cursor%NOTFOUND;

    DBMS_OUTPUT.PUT_LINE('Appointment ID: ' || v_appt_id || 
                         ' Date: ' || v_date || 
                         ' Time: ' || v_time);
  END LOOP;
  
  CLOSE appt_cursor;
END;
/
