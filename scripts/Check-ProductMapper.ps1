Write-Host "===== ProductMapper 자동 검사 시작 =====" -ForegroundColor Cyan

# 1) 경로 설정
$mapperPath = "C:\Users\abclab-3\matpam-admin\src\main\resources\egovframework\mapper\matpam\product\ProductMapper.xml"
$deployPath = "C:\Users\abclab-3\matpam-admin\target\matpam-admin\WEB-INF\classes\egovframework\mapper\matpam\product\ProductMapper.xml"

# 2) 파일 존재 확인
if (!(Test-Path $mapperPath)) {
    Write-Host "❌ 소스 ProductMapper.xml 이 없습니다: $mapperPath" -ForegroundColor Red
    exit
}

if (!(Test-Path $deployPath)) {
    Write-Host "❌ 배포본 ProductMapper.xml 이 없습니다: $deployPath" -ForegroundColor Red
    exit
}

# 3) 내용 비교
$srcText    = Get-Content $mapperPath -Raw
$deployText = Get-Content $deployPath -Raw

Write-Host "`n[1] 소스 vs 배포본 비교" -ForegroundColor Yellow
if ($srcText -eq $deployText) {
    Write-Host "✅ 내용이 완전히 동일합니다." -ForegroundColor Green
}
else {
    Write-Host "⚠️ 내용이 서로 다릅니다. war 재배포가 안 되었을 수 있습니다." -ForegroundColor DarkYellow
}

# 4) insertProduct 블록 검사
Write-Host "`n[2] insertProduct 블록 구조 검사" -ForegroundColor Yellow

$pattern = '<insert[^>]+id\s*=\s*"insertProduct"[\s\S]*?</insert>'
$insertBlock = [regex]::Match($deployText, $pattern).Value

if (-not $insertBlock) {
    Write-Host "❌ 배포본에 id='insertProduct' 블록이 없습니다." -ForegroundColor Red
    exit
}

# 4-1) PRODUCT_NAME 컬럼 존재 여부
if ($insertBlock -match 'PRODUCT_NAME') {
    Write-Host "✔ INSERT 컬럼 목록에 PRODUCT_NAME 이 포함되어 있습니다." -ForegroundColor Green
}
else {
    Write-Host "❌ INSERT 컬럼 목록에 PRODUCT_NAME 이 없습니다." -ForegroundColor Red
}

# 4-2) #{productName} 파라미터 존재 여부
if ($insertBlock -match '#\{productName\}') {
    Write-Host "✔ VALUES 쪽에 #{productName} 파라미터가 포함되어 있습니다." -ForegroundColor Green
}
else {
    Write-Host "❌ VALUES 쪽에 #{productName} 파라미터가 없습니다." -ForegroundColor Red
}

# 5) insertProduct 블록 미리보기
Write-Host "`n--- insertProduct 블록 미리보기 (앞 30줄) ---" -ForegroundColor Cyan
$insertBlock.Split("`n") |
    Select-Object -First 30 |
    ForEach-Object { "  " + $_ }

Write-Host "`n===== ProductMapper 자동 검사 끝 =====" -ForegroundColor Cyan
