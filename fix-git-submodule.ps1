# FormWeaver - Fix Git Submodule Issue
# Converts the embedded frontend repo to a proper submodule
# Run this in the project root (C:\Self_Projects\formweaver)

Write-Host @"
╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║         FormWeaver - Fix Git Configuration                ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝
"@ -ForegroundColor Cyan

Write-Host "`n🔍 Checking current setup..." -ForegroundColor Yellow

if (-not (Test-Path ".git")) {
    Write-Host "❌ Not a git repository. Run this from the project root." -ForegroundColor Red
    exit 1
}

if (-not (Test-Path "frontend")) {
    Write-Host "❌ Frontend directory not found." -ForegroundColor Red
    exit 1
}

Write-Host "`n📋 You have two options:" -ForegroundColor Cyan
Write-Host "  1. Convert to Git Submodule (keeps connection to original repo)" -ForegroundColor White
Write-Host "  2. Remove .git from frontend (makes it part of this repo)" -ForegroundColor White

$choice = Read-Host "`nEnter your choice (1 or 2)"

if ($choice -eq "1") {
    Write-Host "`n🔄 Converting to submodule..." -ForegroundColor Yellow
    
    # Remove frontend from git cache
    git rm --cached frontend
    
    # Remove the frontend directory
    Remove-Item -Recurse -Force frontend
    
    # Add as proper submodule
    git submodule add https://github.com/Jositett/form-weaver.git frontend
    git submodule update --init --recursive
    
    # Commit the change
    git add .gitmodules frontend
    git commit -m "Convert frontend to Git submodule"
    
    Write-Host "`n✅ Frontend is now a proper submodule!" -ForegroundColor Green
    Write-Host "`nTo update frontend in the future:" -ForegroundColor Cyan
    Write-Host "  cd frontend" -ForegroundColor White
    Write-Host "  git pull origin main" -ForegroundColor White
    Write-Host "  cd .." -ForegroundColor White
    Write-Host "  git add frontend" -ForegroundColor White
    Write-Host "  git commit -m 'Update frontend submodule'" -ForegroundColor White
    
} elseif ($choice -eq "2") {
    Write-Host "`n🗑️  Removing .git from frontend..." -ForegroundColor Yellow
    
    # Remove frontend from git cache
    git rm --cached frontend
    
    # Remove .git directory from frontend
    Remove-Item -Recurse -Force frontend\.git
    
    # Add frontend files back
    git add frontend
    git commit -m "Integrate frontend into monorepo"
    
    Write-Host "`n✅ Frontend is now part of the main repository!" -ForegroundColor Green
    Write-Host "`nFrontend code is now versioned with the rest of the project." -ForegroundColor Cyan
    
} else {
    Write-Host "`n❌ Invalid choice. Exiting." -ForegroundColor Red
    exit 1
}

Write-Host "`n🎉 Git configuration fixed!" -ForegroundColor Green