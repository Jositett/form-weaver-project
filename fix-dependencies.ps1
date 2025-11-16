# FormWeaver - Fix Dependencies Script
# Resolves the zod version conflict
# Run this in the project root

Write-Host "🔧 Fixing dependency conflicts..." -ForegroundColor Cyan

$backendPath = "backend"

if (-not (Test-Path $backendPath)) {
    Write-Host "❌ Backend directory not found. Run setup.ps1 first." -ForegroundColor Red
    exit 1
}

Set-Location $backendPath

Write-Host "`n📦 Removing conflicting packages..." -ForegroundColor Yellow
npm uninstall zod @hono/zod-validator 2>$null

Write-Host "`n✅ Installing compatible versions..." -ForegroundColor Green
npm install zod@^3.23.8
npm install @hono/zod-validator

Write-Host "`n🎉 Dependencies fixed!" -ForegroundColor Green
Write-Host "`nYou can now run: npm run dev" -ForegroundColor Cyan

Set-Location ..