# Phase IV Report: Database Creation & Naming

**Student:** Shema Christian  
**PDB Name:** Thur_26991_ShemaChristian_AppointmentDB 
**Date:** May 16, 2025

---

## 1. create_pdb.sql  
This script creates the pluggable database `Thur_26991_ShemaChristian_AppointmentDB`, opens it, and saves its state.

```sql
-- create_pdb.sql
CREATE PLUGGABLE Thur_26991_ShemaChristian_AppointmentDB
  ADMIN USER admin IDENTIFIED BY Shema;

ALTER PLUGGABLE DATABASE Thur_26991_ShemaChristian_AppointmentDB;
ALTER PLUGGABLE DATABASE Thur_26991_ShemaChristian_AppointmentDB;
---
```

## 2. grant_privileges.sq
After reconnecting as SYSDBA, we switch to the PDB container and grant the `DBA` role to `admin:`
-- grant_privileges.sql
-- Connect as SYSDBA to the CDB root, then:
```sql
ALTER SESSION SET CONTAINER = Thur_26991_ShemaChristian_AppointmentDB;
GRANT DBA TO admin;
```
## 3. OEM Dashboard Screenshot
Below is the OEM console view showing our new PDB target and key metrics:
