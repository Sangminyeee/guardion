-- 데이터베이스 초기화 전에 기존 데이터 확인
BEGIN;

-- 📍 디바이스 GPS 로그 (다른 테이블에 참조되므로 먼저 생성)
INSERT INTO "device_gps_log" ("latitude", "longitude")
VALUES 
(37.5665, 126.9780),
(35.1796, 129.0756);

-- 새로 생성된 디바이스 GPS 로그 ID 확인
SELECT id FROM device_gps_log ORDER BY id DESC LIMIT 2;

-- 👤 새 사용자 생성 (이미 존재하는 사용자는 건너뛰기)
INSERT INTO "user" ("username", "password", "organization_name", "institution_name", "role")
SELECT 'user2', 'hashed_pw_2', 'OrgB', 'InstB', 'USER'
WHERE NOT EXISTS (SELECT 1 FROM "user" WHERE username = 'user2');

-- 📱 디바이스 데이터 (새 사용자 ID를 사용)
INSERT INTO "device" ("user_id", "serial_number", "device_name", "temperature_setting", 
                    "beep_setting", "light_setting", "is_connected")
SELECT 
  (SELECT id FROM "user" WHERE username = 'user2'), 
  'SN-003', 
  'Sensor Charlie', 
  22, 1, 1, TRUE
WHERE NOT EXISTS (SELECT 1 FROM device WHERE serial_number = 'SN-003');

-- 새로 생성된 디바이스 ID 확인
SELECT id FROM device WHERE serial_number = 'SN-003';

-- 📊 디바이스 데이터
INSERT INTO "device_data" ("device_id", "internal_temperature", "internal_humidity", 
                         "device_gps_id", "door_status", "battery_exists", 
                         "beep_status", "light_status")
SELECT
  (SELECT id FROM device WHERE serial_number = 'SN-003'),
  22.7, 44.8,
  (SELECT id FROM device_gps_log ORDER BY id LIMIT 1),
  TRUE, TRUE, FALSE, TRUE;

-- 🚨 경고 알림
INSERT INTO "alert" ("user_id", "device_id", "alert_code", "alert_type", 
                   "device_data_id", "message", "alert_severity", 
                   "is_read", "is_resolved")
SELECT
  (SELECT id FROM "user" WHERE username = 'user2'),
  (SELECT id FROM device WHERE serial_number = 'SN-003'),
  'TEMP-001', 'TEMPERATURE_WARNING',
  (SELECT id FROM device_data ORDER BY id DESC LIMIT 1),
  'Internal temperature exceeded threshold.', 'CRITICAL',
  FALSE, FALSE;

-- 🧾 사용자 활동 로그
INSERT INTO "user_activity_log" ("user_id", "activity_type")
SELECT
  (SELECT id FROM "user" WHERE username = 'user2'),
  'LOGIN';

COMMIT;