-- 👤 사용자 데이터
INSERT INTO "user" ("username", "password_hash", "salt", "organization", "institution", "role")
VALUES 
('admin1', 'hashed_pw_1', 'salt1', 'OrgA', 'InstA', 'ADMIN'),
('user1', 'hashed_pw_2', 'salt2', 'OrgB', 'InstB', 'USER');

-- 📦 디바이스 상태
INSERT INTO "device_status" ("device_id", "internal_temperature", "internal_humidity", "cover_status", "battery_exist", "beep_status", "light_status")
VALUES 
(1, 22.5, 45.0, TRUE, TRUE, FALSE, TRUE),
(2, 18.9, 55.5, FALSE, TRUE, TRUE, FALSE);

-- 📱 디바이스
INSERT INTO "device" ("user_id", "serial_number", "device_name", "device_status_id", "temperature_setting", "beep_setting", "light_setting", "is_connected")
VALUES 
(1, 'SN-001', 'Sensor Alpha', 1, 23, 1, 1, TRUE),
(2, 'SN-002', 'Sensor Beta', 2, 20, 0, 1, FALSE);

-- 📍 디바이스 GPS 로그
INSERT INTO "device_gps_log" ("latitude", "longitude", "device_status_id")
VALUES 
(37.5665, 126.9780, 1),
(35.1796, 129.0756, 2);

-- 📊 디바이스 데이터
INSERT INTO "device_data" ("device_id", "internal_temperature", "internal_humidity", "device_gps_id", "cover_status", "battery_exist", "beep_status", "light_status")
VALUES
(1, 22.7, 44.8, 1, TRUE, TRUE, FALSE, TRUE),
(2, 18.5, 56.0, 2, FALSE, TRUE, TRUE, FALSE);

-- 🚨 경고 알림
INSERT INTO "alert" ("user_id", "type", "device_status_id", "message", "severity", "is_read", "is_resolved")
VALUES 
(1, 'TEMPERATURE', 1, 'Internal temperature exceeded threshold.', 'HIGH', FALSE, FALSE),
(2, 'BATTERY', 2, 'Battery level low.', 'MEDIUM', FALSE, TRUE);

-- 🧾 사용자 활동 로그
INSERT INTO "user_activity_log" ("user_id", "activity_type", "activity_target", "activity_detail", "ip_address", "user_agent", "created_at")
VALUES 
(1, 'LOGIN', 'SYSTEM', 'User logged in', '192.168.0.1', 'Mozilla/5.0', CURRENT_TIMESTAMP),
(2, 'VIEW', 'DEVICE', 'User viewed device status', '192.168.0.2', 'Chrome/90.0', CURRENT_TIMESTAMP);
