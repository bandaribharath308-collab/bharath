# Add images to state HTML files
$statesPath = ".vscode\Python-Django-Blog-Website-main\templates\states"
$files = Get-ChildItem -Path $statesPath -Filter "*.html"

Write-Host "Processing $($files.Count) state files..." -ForegroundColor Green

foreach ($file in $files) {
    $stateName = $file.BaseName
    $content = Get-Content $file.FullName -Raw -Encoding UTF8
    
    # Skip if already has images
    if ($content -like '*attraction-image*') {
        Write-Host "$stateName - Already has images" -ForegroundColor Yellow
        continue
    }
    
    # Add images before each <h3> in attraction-item divs
    $imageNum = 1
    $updated = $content -replace '(<div class="attraction-item">)\s*\n\s*(<h3>)', {
        param($m)
        $num = $script:imageNum
        $script:imageNum++
        
        if ($num -le 3) {
            $img = "attraction-$num.jpg"
        } else {
            $img = "culture-$($num - 3).jpg"
        }
        
        $imgLine = "          <img src=`"/assets/images/$stateName/$img`" alt=`"Attraction`" class=`"attraction-image`" loading=`"lazy`">`n"
        return $m.Groups[1].Value + "`n" + $imgLine + "          " + $m.Groups[2].Value
    }
    
    $script:imageNum = 1
    
    if ($updated -ne $content) {
        Set-Content -Path $file.FullName -Value $updated -NoNewline -Encoding UTF8
        Write-Host "$stateName - Images added" -ForegroundColor Green
    } else {
        Write-Host "$stateName - No changes" -ForegroundColor Gray
    }
}

Write-Host "`nComplete!" -ForegroundColor Green
