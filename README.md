# matpam-admin
matpam admin system

## 테스트 실행 시 Maven Central(403) 오류 대응

로컬/사설 네트워크에서 `repo.maven.apache.org` 접근이 403으로 차단될 수 있습니다. 아래 단계로 우회하거나 캐시를 활용해 테스트를 진행하세요.

1. **대체 미러 설정**: 접근 가능한 미러가 있다면 `~/.m2/settings.xml`(또는 프로젝트 로컬 `.mvn/settings.xml`)에 추가합니다. 예시는 다음과 같습니다.
   ```xml
   <settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
             xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
             xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0
                                 https://maven.apache.org/xsd/settings-1.0.0.xsd">
     <mirrors>
       <mirror>
         <id>central-mirror</id>
         <name>Accessible mirror</name>
         <url>https://repo1.maven.org/maven2</url>
         <mirrorOf>central</mirrorOf>
       </mirror>
     </mirrors>
   </settings>
   ```
   사용할 미러 URL은 사내 아티팩트 저장소나 방화벽에서 허용한 주소로 교체합니다.

2. **오프라인 캐시 활용**: 한 번 미러를 통해 의존성을 내려받은 뒤 `mvn -o test`로 오프라인 테스트를 실행합니다. 캐시 준비가 안 되었다면 먼저 `mvn dependency:go-offline`을 실행해 의존성을 미리 내려받습니다.

3. **프록시/방화벽 확인**: 사내 프록시가 필요한 경우 `~/.m2/settings.xml`의 `<proxies>` 섹션에 프록시 정보를 추가하고, 방화벽에서 Maven 트래픽이 허용되는지 점검합니다.

위 단계를 적용해도 해결되지 않으면 네트워크 관리자에게 Maven Central 접근 정책을 문의하거나, 내부 Nexus/Artifactory에 필요한 플러그인과 의존성을 미리 미러링해 테스트를 수행하세요.
