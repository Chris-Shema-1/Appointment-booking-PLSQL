# Updated Data Dictionary - Appointment Scheduling System

**Project:** Appointment Scheduling System  
**Student:** Shema Christian  
**Date:** May 16, 2025  

---

## 1. app_user

**Description:** Stores all system users including patients, providers, and admin users.  

| Column    | Data Type       | Constraints          | Description             |
|-----------|-----------------|----------------------|-------------------------|
| user_id   | NUMBER         | PRIMARY KEY, NOT NULL | Unique user identifier. |
| name      | VARCHAR2(100)  | NOT NULL              | Full name of the user.  |
| email     | VARCHAR2(150)  | UNIQUE, NOT NULL      | User email address.     |
| role      | VARCHAR2(20)   | CHECK ('Patient', 'Provider', 'Admin'), NOT NULL | User role (Patient, Provider, Admin). |

---

## 2. service

**Description:** Defines dental services offered by the clinic (e.g., checkups, braces).  

| Column        | Data Type       | Constraints          | Description             |
|---------------|-----------------|----------------------|-------------------------|
| service_id    | NUMBER         | PRIMARY KEY, NOT NULL | Unique service ID.      |
| service_name  | VARCHAR2(100)  | NOT NULL              | Name of the service.    |
| duration_minutes | NUMBER      | CHECK (duration_minutes > 0), NOT NULL | Duration of the service in minutes. |
| price         | NUMBER(8,2)    | CHECK (price >= 0), NOT NULL | Cost of the service.   |

---

## 3. availability

**Description:** Tracks provider availability for each day and time slot.  

| Column      | Data Type       | Constraints         | Description              |
|-------------|-----------------|---------------------|--------------------------|
| avail_id    | NUMBER         | PRIMARY KEY, NOT NULL | Unique availability ID.  |
| provider_id | NUMBER         | FOREIGN KEY → app_user(user_id), NOT NULL | Provider's user ID. |
| day_of_week | VARCHAR2(10)   | CHECK ('MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY'), NOT NULL | Day of the week. |
| start_time  | TIMESTAMP      | NOT NULL             | Start time for availability. |
| end_time    | TIMESTAMP      | NOT NULL             | End time for availability. |

---

## 4. appointment

**Description:** Records patient appointments with providers for specific services.  

| Column         | Data Type       | Constraints         | Description               |
|----------------|-----------------|---------------------|---------------------------|
| appointment_id | NUMBER         | PRIMARY KEY, NOT NULL | Unique appointment ID.    |
| appointment_date | DATE         | NOT NULL             | Date of the appointment.  |
| appointment_time | TIMESTAMP    | NOT NULL             | Time of the appointment.  |
| status         | VARCHAR2(20)   | CHECK ('Scheduled', 'Completed', 'Canceled'), NOT NULL | Appointment status. |
| cancel_reason  | VARCHAR2(255)  | NULL                 | Reason for cancellation (if applicable). |
| patient_id     | NUMBER         | FOREIGN KEY → app_user(user_id), NOT NULL | Patient's user ID. |
| provider_id    | NUMBER         | FOREIGN KEY → app_user(user_id), NOT NULL | Provider's user ID. |
| service_id     | NUMBER         | FOREIGN KEY → service(service_id), NOT NULL | Service ID. |

---

## 5. reminder

**Description:** Stores reminders for scheduled appointments, sent 24 hours before the appointment time.  

| Column        | Data Type       | Constraints          | Description             |
|---------------|-----------------|----------------------|-------------------------|
| reminder_id   | NUMBER         | PRIMARY KEY, NOT NULL | Unique reminder ID.     |
| reminder_date | TIMESTAMP      | NOT NULL              | Time to send the reminder. |
| appointment_id | NUMBER        | FOREIGN KEY → appointment(appointment_id), UNIQUE, NOT NULL | Associated appointment ID. |

---

## Relationships & Constraints

- **app_user → availability:** A provider can have multiple availability slots (`1-to-many`).  
- **app_user → appointment (as patient):** A patient can have multiple appointments (`1-to-many`).  
- **app_user → appointment (as provider):** A provider can handle multiple appointments (`1-to-many`).  
- **service → appointment:** A service can be associated with multiple appointments (`1-to-many`).  
- **appointment → reminder:** Each appointment has exactly one reminder (`1-to-1`).  

---

## New Additions in Phase VI

- **`cancel_reason` Column in `appointment` Table:**  
  - Allows for tracking reasons for canceled appointments.  
  - Nullable to maintain backward compatibility with older records.  

---
