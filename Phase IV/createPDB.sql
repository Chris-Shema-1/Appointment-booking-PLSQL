-- create_pdb.sql

CREATE PLUGGABLE DATABASE Thur_26991_ShemaChristian_AppointmentDB
  ADMIN USER admin IDENTIFIED BY Shema;

ALTER PLUGGABLE Thur_26991_ShemaChristian_AppointmentDB OPEN;
ALTER PLUGGABLE Thur_26991_ShemaChristian_AppointmentDB SAVE STATE;
