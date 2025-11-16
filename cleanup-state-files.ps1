# Clean up PowerShell code that was accidentally inserted into HTML files
$statesPath = ".vscode\Python-Django-Blog-Website-main\templates\states"
$files = Get-ChildItem -Path $statesPath -Filter "*.html"

Write-Host "Cleaning up $($files.Count) state files..." -ForegroundColor Cyan

foreach ($file in $files) {
    $stateName = $file.BaseName
    $content = Get-Content $file.FullName -Raw -Encoding UTF8
    
    # Check if file has PowerShell code
    if ($content -notlike '*param($m)*') {
        Write-Host "$stateName - Already clean" -ForegroundColor Gray
        continue
    }
    
    # Remove PowerShell script blocks
    $updated = $content -replace '(?s)\s*param\(\$m\).*?return \$m\.Groups\[1\]\.Value.*?\n', ''
    
    # Remove any remaining script fragments
    $updated = $updated -replace '\s*\$num = \$script:imageNum.*?\n', ''
    $updated = $updated -replace '\s*\$script:imageNum\+\+.*?\n', ''
    $updated = $updated -replace '\s*if \(\$num -le 3\).*?\n', ''
    $updated = $updated -replace '\s*\$img = "attraction-\$num\.jpg".*?\n', ''
    $updated = $updated -replace '\s*} else {.*?\n', ''
    $updated = $updated -replace '\s*\$img = "culture-\$\(\$num - 3\)\.jpg".*?\n', ''
    $updated = $updated -replace '\s*}.*?\n', ''
    $updated = $updated -replace '\s*\$imgLine = ".*?attraction-image.*?\n', ''
    
    # Remove image tags if any
    $updated = $updated -replace '\s*<img src="/assets/images/[^"]+"\s+alt="[^"]*"\s+class="attraction-image"\s+loading="lazy">\s*\n', ''
    
    if ($updated -ne $content) {
        Set-Content -Path $file.FullName -Value $updated -NoNewline -Encoding UTF8
        Write-Host "$stateName - Cleaned up" -ForegroundColor Green
    } else {
        Write-Host "$stateName - No changes needed" -ForegroundColor Yellow
    }
}

Write-Host "`nComplete! All files cleaned." -ForegroundColor Green
