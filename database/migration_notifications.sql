-- Run once on existing skillswap_campus database
USE skillswap_campus;
ALTER TABLE notifications ADD COLUMN reference_id INT DEFAULT NULL AFTER type;
