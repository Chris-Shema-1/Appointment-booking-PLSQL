-- Connect as admin to Mon_123456_Shema_AppointmentDB
-- DDL: Adding a new column to track cancellation reason in the appointment table
ALTER TABLE appointment 
  ADD cancel_reason VARCHAR2(255);

-- DML: Update an appointment status
UPDATE appointment 
SET status = 'Completed' 
WHERE appointment_id = 1;

-- DML: Delete a test user (if needed)
DELETE FROM app_user 
WHERE email = 'testuser@example.com';

-- DDL: Drop a column (if required)
ALTER TABLE appointment 
  DROP COLUMN cancel_reason;

-- DML: Insert a new appointment
INSERT INTO appointment (appointment_date, appointment_time, status, patient_id, provider_id, service_id)
VALUES (
  TRUNC(SYSDATE + 1),
  TRUNC(SYSDATE + 1) + 15/24,
  'Scheduled',
  4,  -- Updated to reference a patient ID
  2,  -- Updated to reference a provider ID
  1
);

COMMIT;