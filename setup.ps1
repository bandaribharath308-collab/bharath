# Fullstack Website Setup Script for Windows
# Run this with: powershell -ExecutionPolicy Bypass -File setup.ps1

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Fullstack Authentication Website Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check Python version
Write-Host "Checking Python version..." -ForegroundColor Yellow
$pythonVersion = python --version 2>&1
Write-Host "Found: $pythonVersion" -ForegroundColor Green

if ($pythonVersion -match "3\.13") {
    Write-Host ""
    Write-Host "WARNING: Python 3.13 detected!" -ForegroundColor Red
    Write-Host "Django 5.0 requires Python 3.11 or 3.12" -ForegroundColor Red
    Write-Host "Please install Python 3.11 or 3.12 from:" -ForegroundColor Yellow
    Write-Host "https://www.python.org/downloads/" -ForegroundColor Yellow
    Write-Host ""
    $continue = Read-Host "Continue anyway? (y/n)"
    if ($continue -ne "y") {
        exit
    }
}

Write-Host ""
Write-Host "Setting up Django backend..." -ForegroundColor Yellow

# Navigate to Django directory
Set-Location ".vscode\Python-Django-Blog-Website-main"

# Create virtual environment
Write-Host "Creating virtual environment..." -ForegroundColor Yellow
python -m venv venv

# Activate virtual environment
Write-Host "Activating virtual environment..." -ForegroundColor Yellow
& ".\venv\Scripts\Activate.ps1"

# Install dependencies
Write-Host "Installing dependencies..." -ForegroundColor Yellow
pip install -r requirements.txt

# Run migrations
Write-Host "Running database migrations..." -ForegroundColor Yellow
python manage.py makemigrations
python manage.py migrate

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  Setup Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "To start your website:" -ForegroundColor Cyan
Write-Host "1. Make sure you're in the Django directory" -ForegroundColor White
Write-Host "2. Activate virtual environment: venv\Scripts\activate" -ForegroundColor White
Write-Host "3. Run server: python manage.py runserver" -ForegroundColor White
Write-Host "4. Open browser: http://localhost:8000/login.html" -ForegroundColor White
Write-Host ""
Write-Host "First user will automatically become admin!" -ForegroundColor Yellow
Write-Host ""

# Ask if user wants to start server now
$startNow = Read-Host "Start server now? (y/n)"
if ($startNow -eq "y") {
    Write-Host ""
    Write-Host "Starting Django server..." -ForegroundColor Green
    Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Yellow
    Write-Host ""
    python manage.py runserver
}
