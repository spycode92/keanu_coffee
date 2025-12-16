# ☕ Keanu_Coffee - 커피 체인점 WMS & 배송 시스템

커피 체인점을 상정하여 매장·창고 간 재고 관리와 배송 프로세스를 웹 애플리케이션으로 구현한 프로젝트입니다.  
물류센터 근무 경험을 바탕으로 실제 현장의 입·출고 및 재고 흐름을 반영한 창고관리 시스템을 목표로 개발했습니다.

## Team & Role

- 팀 구성 : 백엔드/프론트엔드 협업 팀 프로젝트(5인)
- 이름 : 신필용
- 역할 : 팀장 / 백엔드 & 인프라 총괄

### 담당 업무

- 권한 관리 및 보안 관리
- 통계 및 대시보드 화면 구현
- WebSocket 기반 실시간 알림 기능 개발
- AOP 사용 작업자의 로그 추적 기능 개발
- 테이블 설계 및 물류 흐름을 반영한 ERD 작성
- CI/CD 파이프라인 구축 (AWS EC2, CodeDeploy)
- 전반적인 프로젝트 구조 설계 및 코드 리뷰

## 🛠 Tech Stack

- Language : Java, JavaScript
- Frontend : HTML5, CSS3, JSP, Thymeleaf, jQuery
- Backend : Spring Framework, Spring Boot
- DB : MySQL, Oracle
- Infra & DevOps : AWS EC2, CodeDeploy
- Tools : Git, GitHub, IntelliJ IDEA, VS Code

## 📦 주요 기능

- 창고·매장 재고 관리
  - 입·출고 등록, 재고 이동, 재고 조회
- 배송/요청 관리
  - 매장별 배송 요청 및 처리 상태 관리
- 권한/보안
  - 관리자 / 작업자 등 역할 기반 권한 제어
  - 권한에 따른 메뉴 및 기능 접근 제한
- 대시보드 & 통계
  - 매장별 재고 현황, 입·출고 추이 시각화
- 실시간 알림
  - WebSocket을 활용한 주요 이벤트 알림
