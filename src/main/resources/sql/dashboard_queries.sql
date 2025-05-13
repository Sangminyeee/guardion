--------------------------------------------------------------------------------
-- 01. SPLASH / 로딩 화면
--    (별도 데이터 없음)

--------------------------------------------------------------------------------
-- 02. 대시보드(전체 현황)
-- 2-1) 전체 함체 수
SELECT count(*) AS device_count
  FROM device;

-- 2-2) 통신 중인 함체 수
SELECT count(*) AS connected_count
  FROM device
 WHERE is_connected = TRUE;

-- 2-3) 경보(Severity=HIGH) 건수 (최근 1시간)
SELECT count(*) AS high_alerts
  FROM alert
 WHERE severity = 'HIGH'
   AND created_at > now() - interval '1 hour';

--------------------------------------------------------------------------------
-- 03. 드론 리스트 보기
-- 장치 아이디·이름·상태 요약
SELECT
    d.id,
    d.device_name,
    CASE WHEN d.is_connected THEN 'ONLINE' ELSE 'OFFLINE' END AS status,
    dd.internal_temperature,
    dd.internal_humidity
  FROM device d
  LEFT JOIN device_data dd
    ON dd.device_id = d.id
 ORDER BY d.device_name;

--------------------------------------------------------------------------------
-- 04. 배터리 상태
-- 배터리 잔량(배터리 존재 여부) + 내부 온도 + 충전 이력(마지막 업데이트)
SELECT
    d.id             AS device_id,
    dd.battery_exists AS battery_present,
    dd.internal_temperature,
    dd.updated_at AS last_update
  FROM device_data dd
  JOIN device d
    ON d.id = dd.device_id
 ORDER BY d.id;

--------------------------------------------------------------------------------
-- 05. 현재 위치 (GPS)
-- 최근 위치 1건만 가져오기
SELECT DISTINCT ON (dd.id)  -- device_status_id -> dd.id
    dd.id,
    dgl.latitude,
    dgl.longitude,
    dgl.created_at AS recorded_at
  FROM device_data dd
  JOIN device_gps_log dgl
 ORDER BY dd.id, dgl.created_at DESC;

--------------------------------------------------------------------------------
-- 06. 함체 상태 요약
-- cover/light/beep 상태 + 통신 연결 여부
SELECT
    d.id,
    dd.door_status,
    dd.light_status,
    dd.beep_status,
    d.is_connected
  FROM device d
  JOIN device_data dd
    ON dd.device_id = d.id;

--------------------------------------------------------------------------------
-- 07. 계정 정보 (로그인 사용자 프로필)
SELECT
    id,
    username,
    role,
    created_at
  FROM "user"
 ORDER BY username;

--------------------------------------------------------------------------------
-- 08. 경고·이벤트 로그
-- 최근 50건 (디테일 페이지에서 device_id 필터링하여 사용)
SELECT
    a.created_at,
    a.alert_type AS type,
    a.message,
    a.alert_severity AS severity
  FROM alert a
 WHERE a.device_id = $device
 ORDER BY a.created_at DESC
 LIMIT 50;
