# استخراج السلاسل العربية الفريدة من مشروع دوائي وتحويلها إلى ملف JSON
# للاستخدام: powershell -ExecutionPolicy Bypass -File tools\extract_arabic.ps1
$ErrorActionPreference = 'Stop'

$root = (Get-Location).Path
$libDir = Join-Path $root 'lib'
$outDir = Join-Path $root 'tools'
if (-not (Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir | Out-Null }

# جمع النتائج: سلسلة -> { count, files: { file: count } }
$strings = @{}

$files = Get-ChildItem -Path $libDir -Recurse -Filter *.dart |
    Where-Object { $_.FullName -notlike '*generated*' -and $_.FullName -notlike '*l10n*' }

foreach ($f in $files) {
    $content = [Text.Encoding]::UTF8.GetString([IO.File]::ReadAllBytes($f.FullName))
    $rel = $f.FullName.Replace($root + '\', '')

    # سلاسل مفردة: '...' أو "..." تحتوي على حرفين عربيين متتاليين على الأقل
    $pattern = "(['""])((?:(?!\1).)*[\u0600-\u06FF][\u0600-\u06FF]{1,}(?:(?!\1).)*)\1"
    $matches = [regex]::Matches($content, $pattern)

    foreach ($m in $matches) {
        $s = $m.Groups[2].Value
        # تجاهل السلاسل الكبيرة جدا أو التي تبدو رموز مسار
        if ($s.Length -gt 500) { continue }
        if ($s -match '^\s*$') { continue }

        if (-not $strings.ContainsKey($s)) {
            $strings[$s] = @{ count = 0; files = @{} }
        }
        $strings[$s].count++
        $fileMap = $strings[$s].files
        if ($fileMap.ContainsKey($rel)) { $fileMap[$rel]++ } else { $fileMap[$rel] = 1 }
    }
}

# ترتيب حسب الشهرة ثم النص
$sorted = $strings.GetEnumerator() |
    Sort-Object @{ Expression = { -$_.Value.count } }, Name

$result = foreach ($e in $sorted) {
    [pscustomobject]@{
        text  = $e.Key
        count = $e.Value.count
        files = $e.Value.files
    }
}

$jsonPath = Join-Path $outDir 'arabic_strings.json'
$result | ConvertTo-Json -Depth 4 | Set-Content -Path $jsonPath -Encoding UTF8

Write-Output ("Extracted {0} unique Arabic strings across {1} files." -f $result.Count, ($files.Count))
Write-Output ("Output: {0}" -f $jsonPath)