# Database Audit Trail System - Test Logs

## Project Information
- **Student:** Shema Christian
- **Date:** May 16, 2025
- **Phase:** VII - System Testing

## Test Scenarios & Results

### Scenario 1: Insert New Appointment
**DBMS Output:**
```
Inserted a new scheduled appointment.
```

**Query Output:**
| APPOINTMENT_ID | OPERATION_TYPE | PERFORMED_BY | ACTION_TIME | OLD_STATUS | NEW_STATUS | CANCEL_REASON |
|----------------|----------------|--------------|-------------|------------|------------|---------------|
| 1 | INSERT | ADMIN | 16-MAY-25 10:30:00 | - | Scheduled | - |

---

### Scenario 2: Update Appointment to Canceled
**DBMS Output:**
```
Updated appointment to Canceled.
```

**Query Output:**
| APPOINTMENT_ID | OPERATION_TYPE | PERFORMED_BY | ACTION_TIME | OLD_STATUS | NEW_STATUS | CANCEL_REASON |
|----------------|----------------|--------------|-------------|------------|------------|---------------|
| 1 | UPDATE | ADMIN | 16-MAY-25 11:00:00 | Scheduled | Canceled | Patient unavailable due to emergency |

---

### Scenario 3: Attempt to Cancel Within 24 Hours
**DBMS Output:**
```
Error: ORA-20002: Cannot cancel appointments within 24 hours of the scheduled time.
```

---

### Scenario 4: Delete Appointment
**DBMS Output:**
```
Deleted appointment with ID 1.
```

**Query Output:**
| APPOINTMENT_ID | OPERATION_TYPE | PERFORMED_BY | ACTION_TIME | OLD_STATUS | NEW_STATUS | CANCEL_REASON |
|----------------|----------------|--------------|-------------|------------|------------|---------------|
| 1 | DELETE | ADMIN | 16-MAY-25 11:15:00 | Canceled | - | Patient unavailable due to emergency |
