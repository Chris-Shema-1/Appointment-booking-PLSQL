# 🦷 Appointment Scheduling System - Final Report

**Student:** Shema Christian  
**Course:** INSY 8311 – Database Development with PL/SQL  
**Date:** May 16, 2025  

---

![Image](https://github.com/user-attachments/assets/f69bbea9-a16d-4a37-9f0a-e29b768ad508)

## 🌟 **1. Introduction**

In today’s fast-paced world, managing appointments efficiently is crucial for service-based businesses. This project focuses on developing a comprehensive **Appointment Scheduling System** for a dental clinic, enabling smooth booking, rescheduling, and cancellation of appointments while ensuring data integrity and maintaining audit logs for accountability.

---

## 🎯 **2. Project Objectives**

- ✅ Automate the booking, rescheduling, and cancellation of appointments.  
- ✅ Implement business rules to enforce a **24-hour cancellation policy**.  
- ✅ Maintain audit logs for every change made to appointments.  
- ✅ Develop PL/SQL procedures, functions, and triggers to handle key operations.

---

## 🏗️ **3. Implementation Phases**

### **Phase I: Problem Statement & Presentation**  
- Defined the project scope, target users, and system objectives.  
- Created a PowerPoint presentation outlining the key features and objectives.

**Files:**   
- [`PhaseI/presentation.pptx`](https://github.com/Chris-Shema-1/Appointment-booking-PLSQL/blob/main/Phase%20I/PL-SQL.pptx)

---

### **Phase II: Business Process Modeling**  
- Developed a **swimlane diagram** to map the flow of appointment booking and rescheduling.  
- Identified key actors: Patient, System, Provider, Admin.

**Files:**  
- [`PhaseII/process_modeling_diagram.png`](https://github.com/Chris-Shema-1/Appointment-booking-PLSQL/blob/main/Phase%20II/Swimlane%20Diagram.png)

---

### **Phase III: Logical Model Design**  
- Designed the **ER diagram** to represent key entities and their relationships.  
- Ensured 3NF compliance to minimize data redundancy.

**Files:**  
- [`PhaseIII/er_diagram.png`](https://github.com/Chris-Shema-1/Appointment-booking-PLSQL/blob/main/Phase%20II/Swimlane%20Diagram.png)
![Image](https://github.com/user-attachments/assets/e23beea0-157f-4fb8-a8c3-1642fef0d7da)

---

### **Phase IV: Database Creation & Naming**  
- Created the pluggable database `Thur_26991_ShemaChristian_AppointmentDB`.  
- Configured OEM monitoring and captured key metrics.

**Files:**  
- [`PhaseIV/create_pdb.sql`](https://github.com/Chris-Shema-1/Appointment-booking-PLSQL/blob/main/Phase%20IV/createPDB.sql)  
- [`PhaseIV/OEM_screenshot.png`](https://github.com/Chris-Shema-1/Appointment-booking-PLSQL/blob/main/Phase%20IV/OEM_screenshot.png)  
- [`PhaseIV/PhaseIV_Report.md`](https://github.com/Chris-Shema-1/Appointment-booking-PLSQL/blob/main/Phase%20IV/PhaseIV_Report.md)

---

### **Phase V: Table Implementation & Data Insertion**  
- Implemented tables for **users, services, appointments, availability, and reminders**.  
- Inserted seed data for testing purposes.  
- Created a detailed data dictionary.

**Files:**   
- [`PhaseV/data_dictionary.md`](https://github.com/Chris-Shema-1/Appointment-booking-PLSQL/blob/main/Phase%20V/data_dictionary.md)
  
- ![Image](https://github.com/user-attachments/assets/070c302f-7a40-441e-8437-77dddb3c889f)

---

### **Phase VI: Database Interaction & Transactions**  
- Implemented PL/SQL procedures and functions including:  
  - `BookAppointment`: Inserts a new appointment while checking for time conflicts.  
  - `FetchProviderAppointments`: Lists upcoming appointments for a specific provider.  
- Applied window functions and exception handling for data validation.

**Files:**  
- [`PhaseVI/phase_vi_procedures.sql`](https://github.com/Chris-Shema-1/Appointment-booking-PLSQL/blob/main/Phase%20VI/phase_vi_procedures.sql) 

  # SQL Procedure: BookAppointment

```sql
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
```

- [`PhaseVI/phase_vi_cursor.sql`](https://github.com/Chris-Shema-1/Appointment-booking-PLSQL/blob/main/Phase%20VI/phase_vi_cursor.sql)


# SQL Cursor Example: Appointment Retrieval

```sql
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

```

- [`PhaseVI/data_dictionary_phase_vi.md`](https://github.com/Chris-Shema-1/Appointment-booking-PLSQL/blob/main/Phase%20VI/data_dictionary_phase_vi.md)

---

### **Phase VII: Advanced Programming & Auditing**  
- Developed audit logs to track `INSERT`, `UPDATE`, and `DELETE` operations on appointments.  
- Implemented a trigger to **prevent cancellations within 24 hours** of the scheduled time.

**Test Scenarios:**  
- 📦 **Insert Appointment:** Verified successful insert and audit log entry.  
- 🛠️ **Update Appointment to Canceled:** Ensured audit log captures both old and new status.  
- 🔒 **Attempted Cancellation Within 24 Hours:** Trigger successfully prevents the action and raises an exception.  

**Files:**  
- [`PhaseVII/audit_table.sql`](https://github.com/Chris-Shema-1/Appointment-booking-PLSQL/blob/main/Phase%20VII/audit_table.sql)  
- [`PhaseVII/audit_trigger.sql`](https://github.com/Chris-Shema-1/Appointment-booking-PLSQL/blob/main/Phase%20VII/audit_trigger.sql)  
- [`PhaseVII/prevent_cancel_trigger.sql`](https://github.com/Chris-Shema-1/Appointment-booking-PLSQL/blob/main/Phase%20VII/prevent_cancel_trigger.sql)  
- [`PhaseVII/test_log.txt`](https://github.com/Chris-Shema-1/Appointment-booking-PLSQL/blob/main/Phase%20VII/test_log.md)

---

### 📝 **4. Testing and Verification**

- **Scenario 1:** Inserted a new appointment and verified its entry in the `appointment_audit` table.  
- **Scenario 2:** Updated an appointment status to `Canceled` and checked that the `cancel_reason` was logged.  
- **Scenario 3:** Attempted to cancel within 24 hours, expecting a **custom error message**.  
- **Scenario 4:** Deleted an appointment and confirmed the audit log captured the deletion.

📂 **Test Log:**  
- All testing outputs and exception messages are documented in [`PhaseVII/test_log.txt`](https://github.com/Chris-Shema-1/Appointment-booking-PLSQL/blob/main/Phase%20VII/test_log.md).

---

### 📊 **5. Summary of Database Structure:**

| Table          | Purpose                      | Key Columns        |
|----------------|------------------------------|--------------------|
| **app_user**   | Stores patients, providers  | `user_id`, `role`  |
| **service**    | Service catalog             | `service_id`, `price` |
| **availability** | Tracks provider availability | `avail_id`, `day_of_week` |
| **appointment** | Manages bookings and cancellations | `appointment_id`, `status`, `cancel_reason` |
| **reminder**   | Sends reminders 24 hours before the appointment | `reminder_id`, `appointment_id` |
| **appointment_audit** | Logs all changes to appointments | `audit_id`, `operation_type`, `performed_by` |

---

### 🚀 **6. Conclusion & Future Enhancements**

The Appointment Scheduling System successfully integrates business rules, auditing, and exception handling to maintain data integrity and provide operational transparency.  

**Potential Enhancements:**  
- Implement **email notifications** for upcoming appointments.  
- Develop a front-end interface for easier user interaction.  
- Expand the auditing system to track login/logout actions.

---

### 📎 **7. References & Appendix**

- ER Diagram: [PhaseIII/er_diagram.png](https://github.com/Chris-Shema-1/Appointment-booking-PLSQL/blob/main/Phase%20III/ER_Diagram.png)  
- PDB Creation Script: [PhaseIV/create_pdb.sql](https://github.com/Chris-Shema-1/Appointment-booking-PLSQL/blob/main/Phase%20IV/createPDB.sql)  
- Test Log: [PhaseVII/test_log.txt](https://github.com/Chris-Shema-1/Appointment-booking-PLSQL/blob/main/Phase%20VII/test_log.md)  
- Presentation: [PhaseVIII/presentation.pptx](https://github.com/Chris-Shema-1/Appointment-booking-PLSQL/blob/main/Phase%20VIII%20%5B%20final%20%5D/Appointment-Scheduling-System.pptx)

---

Thank you for reviewing this report! 🚀💻  
For any questions or clarifications, feel free to reach out. 👍🙂  
