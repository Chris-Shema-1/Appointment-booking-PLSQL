# 🦷 Appointment Scheduling System - Final Report

**Student:** Shema Christian  
**Course:** INSY 8311 – Database Development with PL/SQL  
**Date:** May 16, 2025  

---

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
- [`PhaseI/presentation.pptx`](../PhaseI/PL-SQL.pptx)

---

### **Phase II: Business Process Modeling**  
- Developed a **swimlane diagram** to map the flow of appointment booking and rescheduling.  
- Identified key actors: Patient, System, Provider, Admin.

**Files:**  
- [`PhaseII/process_modeling_diagram.png`](../PhaseII/Swimlane Diagram_diagram.png)

---

### **Phase III: Logical Model Design**  
- Designed the **ER diagram** to represent key entities and their relationships.  
- Ensured 3NF compliance to minimize data redundancy.

**Files:**  
- [`PhaseIII/er_diagram.png`](../PhaseIII/ER_Diagram.png)

---

### **Phase IV: Database Creation & Naming**  
- Created the pluggable database `Mon_123456_Shema_AppointmentDB`.  
- Configured OEM monitoring and captured key metrics.

**Files:**  
- [`PhaseIV/create_pdb.sql`](../PhaseIV/createPDB.sql)  
- [`PhaseIV/OEM_screenshot.png`](../PhaseIV/OEM_screenshot.png)  
- [`PhaseIV/PhaseIV_Report.md`](../PhaseIV/PhaseIV_Report.md)

---

### **Phase V: Table Implementation & Data Insertion**  
- Implemented tables for **users, services, appointments, availability, and reminders**.  
- Inserted seed data for testing purposes.  
- Created a detailed data dictionary.

**Files:**  
- [`PhaseV/phase_v_tables_and_data.sql`](../PhaseV/Creating Tables.JPG)  
- [`PhaseV/data_dictionary.md`](../PhaseV/data_dictionary.md)

---

### **Phase VI: Database Interaction & Transactions**  
- Implemented PL/SQL procedures and functions including:  
  - `BookAppointment`: Inserts a new appointment while checking for time conflicts.  
  - `FetchProviderAppointments`: Lists upcoming appointments for a specific provider.  
- Applied window functions and exception handling for data validation.

**Files:**  
- [`PhaseVI/phase_vi_procedures.sql`](../PhaseVI/phase_vi_procedures.sql)  
- [`PhaseVI/phase_vi_cursor.sql`](../PhaseVI/phase_vi_cursor.sql)  
- [`PhaseVI/data_dictionary_phase_vi.md`](../PhaseVI/data_dictionary_phase_vi.md)

---

### **Phase VII: Advanced Programming & Auditing**  
- Developed audit logs to track `INSERT`, `UPDATE`, and `DELETE` operations on appointments.  
- Implemented a trigger to **prevent cancellations within 24 hours** of the scheduled time.

**Test Scenarios:**  
- 📦 **Insert Appointment:** Verified successful insert and audit log entry.  
- 🛠️ **Update Appointment to Canceled:** Ensured audit log captures both old and new status.  
- 🔒 **Attempted Cancellation Within 24 Hours:** Trigger successfully prevents the action and raises an exception.  

**Files:**  
- [`PhaseVII/audit_table.sql`](../PhaseVII/audit_table.sql)  
- [`PhaseVII/audit_trigger.sql`](../PhaseVII/audit_trigger.sql)  
- [`PhaseVII/prevent_cancel_trigger.sql`](../PhaseVII/prevent_cancel_trigger.sql)  
- [`PhaseVII/test_log.txt`](../PhaseVII/test_log.txt)

---

### 📝 **4. Testing and Verification**

- **Scenario 1:** Inserted a new appointment and verified its entry in the `appointment_audit` table.  
- **Scenario 2:** Updated an appointment status to `Canceled` and checked that the `cancel_reason` was logged.  
- **Scenario 3:** Attempted to cancel within 24 hours, expecting a **custom error message**.  
- **Scenario 4:** Deleted an appointment and confirmed the audit log captured the deletion.

📂 **Test Log:**  
- All testing outputs and exception messages are documented in [`PhaseVII/test_log.txt`](../PhaseVII/test_log.txt).

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

- ER Diagram: [PhaseIII/er_diagram.png](../PhaseIII/ER_Diagram.png)  
- PDB Creation Script: [PhaseIV/create_pdb.sql](../PhaseIV/createPDB.sql)  
- Test Log: [PhaseVII/test_log.txt](../PhaseVII/test_log.txt)  
- Presentation: [PhaseVIII/presentation.pptx](../PhaseVIII/presentation.pptx)

---

Thank you for reviewing this report! 🚀💻  
For any questions or clarifications, feel free to reach out. 👍🙂  
