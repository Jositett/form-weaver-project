# FormWeaver Rebranding Script
# Updates all references from "Form Builder" to "FormWeaver"
# Last Updated: 2025-11-16

# Color output functions
function Write-Success { param($message) Write-Host "✅ $message" -ForegroundColor Green }
function Write-Info { param($message) Write-Host "ℹ️  $message" -ForegroundColor Cyan }
function Write-Warning { param($message) Write-Host "⚠️  $message" -ForegroundColor Yellow }
function Write-Step { param($message) Write-Host "`n🚀 $message" -ForegroundColor Magenta }

Write-Host @"
╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║              FormWeaver Rebranding Script                 ║
║         Updating all references to FormWeaver             ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝
"@ -ForegroundColor Cyan

# Define replacements
$replacements = @(
    @{ Old = "Form Builder"; New = "FormWeaver" },
    @{ Old = "FormBuilder"; New = "FormWeaver" },
    @{ Old = "form-builder"; New = "formweaver" },
    @{ Old = "formbuilder"; New = "formweaver" },
    @{ Old = "formbuilder.app"; New = "formweaver.app" },
    @{ Old = "FORMBUILDER"; New = "FORMWEAVER" },
    @{ Old = "form_builder"; New = "formweaver" },
    @{ Old = "@formbuilder/"; New = "@formweaver/" }
)

# Files to update (recursively search)
$filePatterns = @(
    "*.md",
    "*.ts",
    "*.tsx",
    "*.js",
    "*.jsx",
    "*.json",
    "*.toml",
    "*.html",
    "*.css",
    "*.yaml",
    "*.yml",
    "README*",
    "package.json",
    "wrangler.toml"
)

# Directories to exclude
$excludeDirs = @(
    "node_modules",
    ".git",
    "dist",
    "build",
    ".wrangler",
    ".next",
    "coverage"
)

Write-Step "Step 1: Finding files to update..."

$filesToUpdate = @()
foreach ($pattern in $filePatterns) {
    $files = Get-ChildItem -Path . -Filter $pattern -Recurse -File -ErrorAction SilentlyContinue |
        Where-Object { 
            $path = $_.FullName
            $exclude = $false
            foreach ($excludeDir in $excludeDirs) {
                if ($path -like "*\$excludeDir\*" -or $path -like "*/$excludeDir/*") {
                    $exclude = $true
                    break
                }
            }
            -not $exclude
        }
    $filesToUpdate += $files
}

$filesToUpdate = $filesToUpdate | Select-Object -Unique
Write-Info "Found $($filesToUpdate.Count) files to check"

Write-Step "Step 2: Updating file contents..."

$updatedFiles = 0
$totalReplacements = 0

foreach ($file in $filesToUpdate) {
    try {
        $content = Get-Content -Path $file.FullName -Raw -ErrorAction Stop
        $originalContent = $content
        $fileReplacements = 0
        
        foreach ($replacement in $replacements) {
            $oldValue = $replacement.Old
            $newValue = $replacement.New
            
            # Count occurrences
            $matches = [regex]::Matches($content, [regex]::Escape($oldValue))
            if ($matches.Count -gt 0) {
                $content = $content -replace [regex]::Escape($oldValue), $newValue
                $fileReplacements += $matches.Count
            }
        }
        
        if ($content -ne $originalContent) {
            Set-Content -Path $file.FullName -Value $content -NoNewline
            $updatedFiles++
            $totalReplacements += $fileReplacements
            Write-Success "Updated: $($file.FullName) ($fileReplacements replacements)"
        }
    }
    catch {
        Write-Warning "Skipped: $($file.FullName) - $($_.Exception.Message)"
    }
}

Write-Step "Step 3: Updating package names..."

# Update package.json files
$packageFiles = Get-ChildItem -Path . -Filter "package.json" -Recurse -File |
    Where-Object { $_.FullName -notlike "*node_modules*" }

foreach ($packageFile in $packageFiles) {
    try {
        $packageJson = Get-Content -Path $packageFile.FullName | ConvertFrom-Json
        $changed = $false
        
        # Update name
        if ($packageJson.name -like "*formbuilder*" -or $packageJson.name -like "*form-builder*") {
            $packageJson.name = $packageJson.name -replace "formbuilder", "formweaver"
            $packageJson.name = $packageJson.name -replace "form-builder", "formweaver"
            $changed = $true
        }
        
        # Update description
        if ($packageJson.description) {
            if ($packageJson.description -match "Form Builder|FormBuilder") {
                $packageJson.description = $packageJson.description -replace "Form Builder", "FormWeaver"
                $packageJson.description = $packageJson.description -replace "FormBuilder", "FormWeaver"
                $changed = $true
            }
        }
        
        # Update repository
        if ($packageJson.repository -and $packageJson.repository.url) {
            if ($packageJson.repository.url -match "formbuilder|form-builder") {
                $packageJson.repository.url = $packageJson.repository.url -replace "formbuilder", "formweaver"
                $packageJson.repository.url = $packageJson.repository.url -replace "form-builder", "formweaver"
                $changed = $true
            }
        }
        
        if ($changed) {
            $packageJson | ConvertTo-Json -Depth 10 | Set-Content -Path $packageFile.FullName
            Write-Success "Updated package.json: $($packageFile.FullName)"
        }
    }
    catch {
        Write-Warning "Failed to update package.json: $($packageFile.FullName)"
    }
}

Write-Step "Step 4: Renaming directories and files..."

# Rename directories (bottom-up to avoid path issues)
$dirsToRename = Get-ChildItem -Path . -Directory -Recurse |
    Where-Object { 
        ($_.Name -like "*formbuilder*" -or $_.Name -like "*form-builder*") -and
        $_.FullName -notlike "*node_modules*"
    } |
    Sort-Object { $_.FullName.Length } -Descending

foreach ($dir in $dirsToRename) {
    $newName = $dir.Name -replace "formbuilder", "formweaver"
    $newName = $newName -replace "form-builder", "formweaver"
    
    if ($newName -ne $dir.Name) {
        $newPath = Join-Path $dir.Parent.FullName $newName
        if (-not (Test-Path $newPath)) {
            Rename-Item -Path $dir.FullName -NewName $newName
            Write-Success "Renamed directory: $($dir.Name) → $newName"
        } else {
            Write-Warning "Skipped directory rename (target exists): $($dir.Name)"
        }
    }
}

# Rename files
$filesToRename = Get-ChildItem -Path . -File -Recurse |
    Where-Object { 
        ($_.Name -like "*formbuilder*" -or $_.Name -like "*form-builder*") -and
        $_.FullName -notlike "*node_modules*"
    }

foreach ($file in $filesToRename) {
    $newName = $file.Name -replace "formbuilder", "formweaver"
    $newName = $newName -replace "form-builder", "formweaver"
    
    if ($newName -ne $file.Name) {
        $newPath = Join-Path $file.Directory.FullName $newName
        if (-not (Test-Path $newPath)) {
            Rename-Item -Path $file.FullName -NewName $newName
            Write-Success "Renamed file: $($file.Name) → $newName"
        } else {
            Write-Warning "Skipped file rename (target exists): $($file.Name)"
        }
    }
}

Write-Step "Step 5: Updating wrangler.toml..."

$wranglerFiles = Get-ChildItem -Path . -Filter "wrangler.toml" -Recurse -File |
    Where-Object { $_.FullName -notlike "*node_modules*" }

foreach ($wranglerFile in $wranglerFiles) {
    try {
        $content = Get-Content -Path $wranglerFile.FullName -Raw
        
        # Update name
        $content = $content -replace 'name = "formbuilder-api"', 'name = "formweaver-api"'
        $content = $content -replace 'name = "formbuilder-.*"', 'name = "formweaver-$1"'
        
        # Update database names
        $content = $content -replace 'database_name = "formbuilder', 'database_name = "formweaver'
        
        # Update bucket names
        $content = $content -replace 'bucket_name = "formbuilder', 'bucket_name = "formweaver'
        
        Set-Content -Path $wranglerFile.FullName -Value $content -NoNewline
        Write-Success "Updated wrangler.toml: $($wranglerFile.FullName)"
    }
    catch {
        Write-Warning "Failed to update wrangler.toml: $($wranglerFile.FullName)"
    }
}

Write-Step "Step 6: Creating branding assets documentation..."

$brandingDoc = @"
# FormWeaver Branding Guidelines

## Logo Usage

### Primary Logo
- Icon: Modern 'F' with network/weaving pattern
- Colors: Cyan (#00E5FF) on dark navy (#0A1628)
- Background: Grid pattern with connected nodes

### Logo Variations
1. **Full Logo**: Icon + "FormWeaver" text
2. **Icon Only**: For small spaces (favicons, app icons)
3. **Badge**: "Built with FormWeaver" for embeds

## Color Palette

### Primary Colors
- **Cyan**: #00E5FF (RGB: 0, 229, 255)
- **Navy**: #0A1628 (RGB: 10, 22, 40)
- **Dark Blue**: #0F2942 (RGB: 15, 41, 66)

### Secondary Colors
- **Light Cyan**: #4DFBFF (RGB: 77, 251, 255)
- **Gray**: #6B7280 (RGB: 107, 114, 128)
- **White**: #FFFFFF

### Usage
- Primary buttons: Cyan gradient
- Backgrounds: Navy with grid pattern
- Text: White on navy, Navy on white
- Accents: Light cyan for highlights

## Typography

### Primary Font
- **Headings**: Inter Bold (700)
- **Body**: Inter Regular (400)
- **Code**: JetBrains Mono

### Sizes
- H1: 48px / 3rem
- H2: 32px / 2rem
- Body: 16px / 1rem
- Small: 14px / 0.875rem

## Icon Design

### Style
- Geometric, modern, tech-focused
- Network/weaving theme (connected nodes)
- Clean lines, 3D depth
- Grid background pattern

### Export Sizes
- 16x16 (favicon)
- 32x32 (favicon)
- 180x180 (Apple touch icon)
- 192x192 (Android)
- 512x512 (PWA)
- 1024x1024 (App stores)

## Badge ("Built with FormWeaver")

### Styles
1. **Dark**: Cyan text on navy background
2. **Light**: Navy text on white background
3. **Minimal**: Text only, no background

### Sizes
- Small: 100x30px
- Medium: 150x40px
- Large: 200x50px

### HTML
\`\`\`html
<a href="https://formweaver.app" target="_blank" rel="noopener">
  <img src="https://cdn.formweaver.app/badge.svg" alt="Built with FormWeaver" />
</a>
\`\`\`

## Social Media

### Profile Images
- Use icon-only logo
- Navy background with cyan 'F'

### Cover Images
- Full logo with tagline
- Grid pattern background
- Dimensions: Twitter 1500x500, Facebook 820x312

### Hashtags
- #FormWeaver
- #EdgeForms
- #CloudflareForms

## Dos and Don'ts

### ✅ Do
- Use official logo files
- Maintain aspect ratio
- Use on contrasting backgrounds
- Follow color palette

### ❌ Don't
- Stretch or distort logo
- Change colors
- Add effects (shadows, gradients on logo)
- Use outdated versions

## File Locations

- Logo files: \`/assets/branding/logo/\`
- Icons: \`/assets/branding/icons/\`
- Badges: \`/assets/branding/badges/\`
- Templates: \`/assets/branding/templates/\`

## Contact

For branding questions or custom assets:
- Email: brand@formweaver.app
- Press Kit: https://formweaver.app/press

---

**Last Updated:** 2025-11-16
**Version:** 1.0
"@

$brandingPath = "docs/BRANDING.md"
if (Test-Path "docs") {
    Set-Content -Path $brandingPath -Value $brandingDoc
    Write-Success "Created branding documentation: $brandingPath"
} else {
    Write-Warning "docs/ directory not found. Create it first, then run this script again."
}

Write-Step "Rebranding Complete! 🎨"

Write-Host @"

╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║            ✅ Rebranding Successful!                      ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝

📊 Summary:
   - Files updated: $updatedFiles
   - Total replacements: $totalReplacements
   - Branding guide created: docs/BRANDING.md

🎨 Brand Identity:
   - Name: FormWeaver
   - Domain: formweaver.app
   - Colors: Cyan (#00E5FF) + Navy (#0A1628)
   - Theme: Network/weaving with connected nodes

📝 Next Steps:

1. Review changes:
   git status
   git diff

2. Update environment variables:
   - VITE_APP_URL=https://formweaver.app
   - Update API URLs in .env files

3. Update external services:
   - Domain registrar
   - Cloudflare DNS
   - GitHub repository name
   - NPM package names
   - Social media profiles

4. Commit changes:
   git add .
   git commit -m "Rebrand to FormWeaver"
   git push

5. Deploy:
   cd frontend && npm run build
   cd backend && npm run deploy

📚 Documentation:
   - Branding guidelines: docs/BRANDING.md
   - Logo assets: Add to /assets/branding/

🔗 URLs to Update:
   - Website: formweaver.app
   - API: api.formweaver.app
   - Forms: forms.formweaver.app
   - CDN: cdn.formweaver.app
   - Docs: docs.formweaver.app

Happy weaving! 🕸️✨

"@ -ForegroundColor Green

# Create summary file
@"
# FormWeaver Rebranding Summary
Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

## Changes Made
- Files updated: $updatedFiles
- Total replacements: $totalReplacements

## Brand Identity
- Name: FormWeaver
- Domain: formweaver.app
- Primary Color: Cyan (#00E5FF)
- Secondary Color: Navy (#0A1628)

## Files Updated
$(foreach ($file in $filesToUpdate | Where-Object { $_.FullName -in ($filesToUpdate | Select-Object -First 50).FullName }) {
    "- $($file.FullName)"
})

## Action Items
- [ ] Update domain DNS records
- [ ] Update GitHub repository name
- [ ] Update NPM packages
- [ ] Update social media profiles
- [ ] Update email addresses
- [ ] Deploy to production

For full branding guidelines, see: docs/BRANDING.md
"@ | Out-File -FilePath "REBRAND_SUMMARY.txt" -Encoding UTF8

Write-Success "Summary saved to REBRAND_SUMMARY.txt"