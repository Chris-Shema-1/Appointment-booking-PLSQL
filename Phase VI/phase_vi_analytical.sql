-- Identify the most booked service type in the past 14 days
SELECT 
  service.service_name,
  COUNT(appointment.service_id) AS booking_count,
  RANK() OVER (ORDER BY COUNT(appointment.service_id) DESC) AS rank
FROM appointment 
JOIN service ON appointment.service_id = service.service_id
WHERE appointment_date >= SYSDATE - 14
GROUP BY service.service_name;