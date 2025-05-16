-- phase_vi_procedures.sql
CREATE OR REPLACE PROCEDURE BookAppointment(
  p_patient_id    NUMBER,
  p_provider_id   NUMBER,
  p_service_id    NUMBER,
  p_date          DATE,
  p_time          TIMESTAMP
) IS
  v_slot_available NUMBER;
  v_appointment_id NUMBER;
  v_provider_exists NUMBER;
  v_patient_exists NUMBER;
  v_service_exists NUMBER;
BEGIN
  -- Check if provider exists
  SELECT COUNT(*) INTO v_provider_exists
  FROM app_user
  WHERE user_id = p_provider_id AND role = 'Provider';
  
  IF v_provider_exists = 0 THEN
    RAISE_APPLICATION_ERROR(-20002, 'Provider does not exist.');
  END IF;
  
  -- Check if patient exists
  SELECT COUNT(*) INTO v_patient_exists
  FROM app_user
  WHERE user_id = p_patient_id AND role = 'Patient';
  
  IF v_patient_exists = 0 THEN
    RAISE_APPLICATION_ERROR(-20003, 'Patient does not exist.');
  END IF;
  
  -- Check if service exists
  SELECT COUNT(*) INTO v_service_exists
  FROM service
  WHERE service_id = p_service_id;
  
  IF v_service_exists = 0 THEN
    RAISE_APPLICATION_ERROR(-20004, 'Service does not exist.');
  END IF;
  
  -- Check if the slot is available
  SELECT COUNT(*) INTO v_slot_available
  FROM appointment
  WHERE provider_id = p_provider_id
    AND appointment_date = p_date
    AND appointment_time = p_time;
    
  IF v_slot_available > 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Time slot is already booked.');
  ELSE
    -- Insert the appointment
    INSERT INTO appointment (appointment_date, appointment_time, status, patient_id, provider_id, service_id)
    VALUES (p_date, p_time, 'Scheduled', p_patient_id, p_provider_id, p_service_id)
    RETURNING appointment_id INTO v_appointment_id;
    
    -- Create a reminder for 24 hours before the appointment
    INSERT INTO reminder (reminder_date, appointment_id)
    VALUES (p_time - INTERVAL '1' DAY, v_appointment_id);
    
    -- Commit the transaction
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Appointment booked with ID: ' || v_appointment_id);
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    -- Rollback in case of error
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END BookAppointment;
/