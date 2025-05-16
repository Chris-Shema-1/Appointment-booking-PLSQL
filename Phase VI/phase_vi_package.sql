-- phase_vi_package.sql

CREATE OR REPLACE PACKAGE AppointmentPackage AS
  PROCEDURE BookAppointment(
    p_patient_id NUMBER,
    p_provider_id NUMBER,
    p_service_id NUMBER,
    p_date DATE,
    p_time TIMESTAMP
  );

  PROCEDURE FetchProviderAppointments(p_provider_id NUMBER);
END AppointmentPackage;
/

CREATE OR REPLACE PACKAGE BODY AppointmentPackage AS

  PROCEDURE BookAppointment(
    p_patient_id NUMBER,
    p_provider_id NUMBER,
    p_service_id NUMBER,
    p_date DATE,
    p_time TIMESTAMP
  ) IS
    v_slot_available NUMBER;
  BEGIN
    SELECT COUNT(*) INTO v_slot_available
    FROM appointment
    WHERE provider_id = p_provider_id
      AND appointment_date = p_date
      AND appointment_time = p_time;

    IF v_slot_available > 0 THEN
      RAISE_APPLICATION_ERROR(-20001, 'Time slot is already booked.');
    ELSE
      INSERT INTO appointment (appointment_date, appointment_time, status, patient_id, provider_id, service_id)
      VALUES (p_date, p_time, 'Scheduled', p_patient_id, p_provider_id, p_service_id);

      DBMS_OUTPUT.PUT_LINE('Appointment successfully booked.');
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
  END BookAppointment;

  PROCEDURE FetchProviderAppointments(p_provider_id NUMBER) IS
    CURSOR appt_cursor IS 
      SELECT appointment_id, appointment_date, appointment_time 
      FROM appointment 
      WHERE provider_id = p_provider_id AND status = 'Scheduled';

    v_appt_id NUMBER;
    v_date    DATE;
    v_time    TIMESTAMP;
  BEGIN
    OPEN appt_cursor;

    LOOP
      FETCH appt_cursor INTO v_appt_id, v_date, v_time;
      EXIT WHEN appt_cursor%NOTFOUND;

      DBMS_OUTPUT.PUT_LINE('Appt ID: ' || v_appt_id || 
                           ', Date: ' || v_date || 
                           ', Time: ' || v_time);
    END LOOP;

    CLOSE appt_cursor;
  END FetchProviderAppointments;

END AppointmentPackage;
/
