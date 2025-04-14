# 파일 경로
$versionFile = "version.h"
$rcFile = "VersionInfoTest.rc"

# 읽기
$content = Get-Content $versionFile

for ($i = 0; $i -lt $content.Length; $i++) {
    if ($content[$i] -match '#define VERSION_BUILD (\d+)') {
        $oldValue = [int]$matches[1]
        $newValue = $oldValue + 1
        $content[$i] = "#define VERSION_BUILD $newValue"
        break
    }
}

# 다시 저장
Set-Content $versionFile $content

Write-Host "VERSION_BUILD updated."

# 버전 정보 읽기
$major = 0
$minor = 0
$patch = 0
$build = 0

# version.h에서 가져오기
foreach ($line in $content) {
    if ($line -match "#define VERSION_MAJOR (\d+)") { $major = $matches[1] }
    if ($line -match "#define VERSION_MINOR (\d+)") { $minor = $matches[1] }
    if ($line -match "#define VERSION_PATCH (\d+)") { $patch = $matches[1] }
    if ($line -match "#define VERSION_BUILD (\d+)") { $build = $matches[1] }
}

# 버전 문자열 만들기
$versionString = "$major.$minor.$patch.$build" + '\0'

# MyApp.rc 업데이트
$rcContent = Get-Content $rcFile
$rcContent = $rcContent -replace '(?<=VALUE "FileVersion", ")[^"]+', $versionString
$rcContent = $rcContent -replace '(?<=VALUE "ProductVersion", ")[^"]+', $versionString
Set-Content "VersionInfoTest.rc" $rcContent

Write-Host "Updated version strings in VersionInfoTest.rc to $versionString"
