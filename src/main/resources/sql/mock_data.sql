-- 👤 사용자 데이터
INSERT INTO "user" ("username", "password", "organization_name", "institution_name", "role")
VALUES 
('admin1', 'hashed_pw_1', 'OrgA', 'InstA', 'ADMIN'),
('user1', 'hashed_pw_2', 'OrgB', 'InstB', 'USER');

-- 📍 디바이스 GPS 로그 (다른 테이블이 참조하므로 먼저 생성)
INSERT INTO "device_gps_log" ("latitude", "longitude")
VALUES 
(37.5665, 126.9780),
(35.1796, 129.0756);

-- 📱 디바이스
INSERT INTO "device" ("user_id", "serial_number", "device_name", "temperature_setting", "beep_setting", "light_setting", "is_connected", "data_last_recorded_at")
VALUES 
(1, 'SN-001', 'Sensor Alpha', 23, 1, 1, TRUE, CURRENT_TIMESTAMP),
(2, 'SN-002', 'Sensor Beta', 20, 0, 1, FALSE, CURRENT_TIMESTAMP);

-- 📊 디바이스 데이터
INSERT INTO "device_data" ("device_id", "internal_temperature", "internal_humidity", "device_gps_id", "door_status", "battery_exists", "beep_status", "light_status")
VALUES
(1, 22.7, 44.8, 1, TRUE, TRUE, FALSE, TRUE),
(2, 18.5, 56.0, 2, FALSE, TRUE, TRUE, FALSE);

-- 🚨 경고 알림
INSERT INTO "alert" ("user_id", "device_id", "alert_code", "alert_type", "device_data_id", "message", "alert_severity", "is_read", "is_resolved")
VALUES 
(1, 1, 'TEMP-001', 'TEMPERATURE_WARNING', 1, 'Internal temperature exceeded threshold.', 'CRITICAL', FALSE, FALSE),
(2, 2, 'BAT-001', 'BATTERY_LOW', 2, 'Battery level low.', 'WARNING', FALSE, TRUE);

-- 🧾 사용자 활동 로그
INSERT INTO "user_activity_log" ("user_id", "activity_type")
VALUES 
(1, 'LOGIN'),
(2, 'UPDATE_DEVICE');