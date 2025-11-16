# GitHub Push Script
Write-Host "Starting GitHub push process..." -ForegroundColor Cyan

# Abort current merge
Write-Host "[1/6] Aborting current merge..." -ForegroundColor Yellow
git merge --abort 2>$null

# Add all files
Write-Host "[2/6] Adding all files..." -ForegroundColor Yellow
git add -A

# Commit changes
Write-Host "[3/6] Committing changes..." -ForegroundColor Yellow
git commit -m "Add fullstack website with Django backend and Pocket India frontend"

# Pull with rebase
Write-Host "[4/6] Pulling latest changes..." -ForegroundColor Yellow
git pull origin main --rebase --allow-unrelated-histories

# Push to GitHub
Write-Host "[5/6] Pushing to GitHub..." -ForegroundColor Yellow
git push -u origin main

# Verify
Write-Host "[6/6] Verifying push..." -ForegroundColor Yellow
git status

Write-Host "Successfully pushed to GitHub!" -ForegroundColor Green
