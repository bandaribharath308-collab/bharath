# PowerShell script to add images to all state attraction cards

$statesPath = ".vscode\Python-Django-Blog-Website-main\templates\states"
$stateFiles = Get-ChildItem -Path $statesPath -Filter "*.html"

Write-Host "Found $($stateFiles.Count) state files" -ForegroundColor Green

foreach ($file in $stateFiles) {
    $stateName = $file.BaseName
    Write-Host "Processing: $stateName" -ForegroundColor Cyan
    
    $content = Get-Content $file.FullName -Raw
    
    # Skip if already has images
    if ($content -match 'class="attraction-image"') {
        Write-Host "  ✓ Already has images, skipping" -ForegroundColor Yellow
        continue
    }
    
    # Pattern to find attraction items without images
    $pattern = '(<div class="attraction-item">)\s*(<h3>)'
    
    # Count matches
    $matches = [regex]::Matches($content, $pattern)
    $count = $matches.Count
    
    if ($count -eq 0) {
        Write-Host "  ✗ No attraction items found" -ForegroundColor Red
        continue
    }
    
    Write-Host "  Found $count attraction items" -ForegroundColor White
    
    # Add images to each attraction item
    $imageIndex = 1
    $newContent = $content
    
    # Replace each occurrence
    $newContent = [regex]::Replace($newContent, $pattern, {
        param($match)
        $imageNum = $script:imageIndex
        $script:imageIndex++
        
        # Determine which image to use (cycle through attraction-1, 2, 3, then culture-1, 2, 3)
        if ($imageNum -le 3) {
            $imgPath = "attraction-$imageNum.jpg"
        } else {
            $cultureNum = $imageNum - 3
            $imgPath = "culture-$cultureNum.jpg"
        }
        
        $imgTag = [string]::Format('{0}          <img src="/assets/images/{1}/{2}" alt="Attraction" class="attraction-image" loading="lazy">', "`n", $stateName, $imgPath)
        return $match.Groups[1].Value + $imgTag + "`n          " + $match.Groups[2].Value
    })
    
    # Reset counter for next file
    $script:imageIndex = 1
    
    # Write back to file
    Set-Content -Path $file.FullName -Value $newContent -NoNewline
    Write-Host "  ✓ Added images successfully" -ForegroundColor Green
}

Write-Host "`nDone! Processed all state files." -ForegroundColor Green
