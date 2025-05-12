# guardion
This is a project for industrial drone ev battery management solution.

## DB 초기화
psql -U postgres -d yourdb -f src/main/resources/schema.sql
psql -U postgres -d yourdb -f src/main/resources/mock_data.sql

## Grafana 대시보드 import
dashboard-front 브랜치의
grafana-dashboard.json 파일을 Import해서 시각화 UI 구성
