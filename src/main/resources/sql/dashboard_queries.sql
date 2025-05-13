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
    ds.internal_temperature,
    ds.internal_humidity
  FROM device d
  LEFT JOIN device_status ds
    ON ds.device_id = d.id
 ORDER BY d.device_name;

--------------------------------------------------------------------------------
-- 04. 배터리 상태
-- 배터리 잔량(배터리 존재 여부) + 내부 온도 + 충전 이력(마지막 업데이트)
SELECT
    d.id             AS device_id,
    ds.battery_exist AS battery_present,
    ds.internal_temperature,
    ds.last_updated_at AS last_update
  FROM device_status ds
  JOIN device d
    ON d.id = ds.device_id
 ORDER BY d.id;

--------------------------------------------------------------------------------
-- 05. 현재 위치 (GPS)
-- 최근 위치 1건만 가져오기
SELECT DISTINCT ON (device_status_id)
    device_status_id,
    latitude,
    longitude,
    recorded_at
  FROM device_gps_log
 ORDER BY device_status_id, recorded_at DESC;

--------------------------------------------------------------------------------
-- 06. 함체 상태 요약
-- cover/light/beep 상태 + 통신 연결 여부
SELECT
    d.id,
    ds.cover_status,
    ds.light_status,
    ds.beep_status,
    d.is_connected
  FROM device d
  JOIN device_status ds
    ON ds.device_id = d.id;

--------------------------------------------------------------------------------
-- 07. 계정 정보 (로그인 사용자 프로필)
SELECT
    id,
    username,
    role,
    last_login_at,
    created_at
  FROM "user"
 ORDER BY username;

--------------------------------------------------------------------------------
-- 08. 경고·이벤트 로그
-- 최근 50건 (디테일 페이지에서 device_id 필터링하여 사용)
SELECT
    a.created_at,
    a.type,
    a.message,
    a.severity
  FROM alert a
 WHERE a.device_status_id IN (
      SELECT id FROM device_status WHERE device_id = $device
    )
 ORDER BY a.created_at DESC
 LIMIT 50;
