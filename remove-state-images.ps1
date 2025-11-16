# Remove images from state HTML files
$statesPath = ".vscode\Python-Django-Blog-Website-main\templates\states"
$files = Get-ChildItem -Path $statesPath -Filter "*.html"

Write-Host "Removing images from $($files.Count) state files..." -ForegroundColor Cyan

foreach ($file in $files) {
    $stateName = $file.BaseName
    $content = Get-Content $file.FullName -Raw -Encoding UTF8
    
    # Skip if no images
    if ($content -notlike '*attraction-image*') {
        Write-Host "$stateName - No images to remove" -ForegroundColor Gray
        continue
    }
    
    # Remove image tags
    $updated = $content -replace '\s*<img src="/assets/images/[^"]+"\s+alt="[^"]*"\s+class="attraction-image"\s+loading="lazy">\s*\n', ''
    
    if ($updated -ne $content) {
        Set-Content -Path $file.FullName -Value $updated -NoNewline -Encoding UTF8
        Write-Host "$stateName - Images removed" -ForegroundColor Green
    } else {
        Write-Host "$stateName - No changes" -ForegroundColor Yellow
    }
}

Write-Host "`nComplete! All images removed." -ForegroundColor Green
