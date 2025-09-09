# Athletica Bundle Size Analysis Script
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "    Athletica - Bundle Size Analysis" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if build directory exists
if (-not (Test-Path "build\web")) {
    Write-Host "❌ Build directory not found. Building first..." -ForegroundColor Red
    Write-Host ""
    Write-Host "[1/3] Building web app..." -ForegroundColor Yellow
    flutter build web --release --web-renderer html --base-href /athletica/
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Build failed!" -ForegroundColor Red
        exit 1
    }
}

Write-Host "[2/3] Analyzing bundle size..." -ForegroundColor Yellow

# Get file sizes
$files = Get-ChildItem -Path "build\web" -Recurse -File | Sort-Object Length -Descending

Write-Host ""
Write-Host "📊 Bundle Size Analysis:" -ForegroundColor Green
Write-Host "========================" -ForegroundColor Green
Write-Host ""

# Top 10 largest files
Write-Host "🔝 Top 10 Largest Files:" -ForegroundColor Yellow
Write-Host "------------------------" -ForegroundColor Yellow
$files | Select-Object -First 10 | ForEach-Object {
    $sizeKB = [math]::Round($_.Length / 1KB, 2)
    $sizeMB = [math]::Round($_.Length / 1MB, 2)
    if ($sizeMB -ge 1) {
        Write-Host "  $($_.Name): $sizeMB MB" -ForegroundColor White
    } else {
        Write-Host "  $($_.Name): $sizeKB KB" -ForegroundColor White
    }
}

Write-Host ""

# File type analysis
Write-Host "📁 Files by Type:" -ForegroundColor Yellow
Write-Host "-----------------" -ForegroundColor Yellow

$jsFiles = $files | Where-Object { $_.Extension -eq ".js" }
$cssFiles = $files | Where-Object { $_.Extension -eq ".css" }
$imageFiles = $files | Where-Object { $_.Extension -match "\.(png|jpg|jpeg|gif|svg|webp)$" }
$fontFiles = $files | Where-Object { $_.Extension -match "\.(ttf|woff|woff2|eot)$" }
$otherFiles = $files | Where-Object { $_.Extension -notmatch "\.(js|css|png|jpg|jpeg|gif|svg|webp|ttf|woff|woff2|eot)$" }

$jsSize = ($jsFiles | Measure-Object -Property Length -Sum).Sum
$cssSize = ($cssFiles | Measure-Object -Property Length -Sum).Sum
$imageSize = ($imageFiles | Measure-Object -Property Length -Sum).Sum
$fontSize = ($fontFiles | Measure-Object -Property Length -Sum).Sum
$otherSize = ($otherFiles | Measure-Object -Property Length -Sum).Sum

Write-Host "  JavaScript: $([math]::Round($jsSize / 1MB, 2)) MB ($($jsFiles.Count) files)" -ForegroundColor White
Write-Host "  CSS: $([math]::Round($cssSize / 1KB, 2)) KB ($($cssFiles.Count) files)" -ForegroundColor White
Write-Host "  Images: $([math]::Round($imageSize / 1MB, 2)) MB ($($imageFiles.Count) files)" -ForegroundColor White
Write-Host "  Fonts: $([math]::Round($fontSize / 1KB, 2)) KB ($($fontFiles.Count) files)" -ForegroundColor White
Write-Host "  Other: $([math]::Round($otherSize / 1KB, 2)) KB ($($otherFiles.Count) files)" -ForegroundColor White

Write-Host ""

# Total size
$totalSize = ($files | Measure-Object -Property Length -Sum).Sum
Write-Host "📊 Total Bundle Size:" -ForegroundColor Green
Write-Host "  $([math]::Round($totalSize / 1MB, 2)) MB ($($files.Count) files)" -ForegroundColor White

Write-Host ""

# Optimization recommendations
Write-Host "🎯 Optimization Recommendations:" -ForegroundColor Yellow
Write-Host "===============================" -ForegroundColor Yellow

if ($jsSize -gt 2MB) {
    Write-Host "  ⚠️  JavaScript bundle is large ($([math]::Round($jsSize / 1MB, 2)) MB)" -ForegroundColor Red
    Write-Host "     - Consider code splitting with deferred imports" -ForegroundColor Gray
    Write-Host "     - Remove unused dependencies" -ForegroundColor Gray
}

if ($imageSize -gt 1MB) {
    Write-Host "  ⚠️  Images are large ($([math]::Round($imageSize / 1MB, 2)) MB)" -ForegroundColor Red
    Write-Host "     - Optimize images (WebP format, compression)" -ForegroundColor Gray
    Write-Host "     - Use appropriate image sizes" -ForegroundColor Gray
}

if ($fontSize -gt 500KB) {
    Write-Host "  ⚠️  Fonts are large ($([math]::Round($fontSize / 1KB, 2)) KB)" -ForegroundColor Red
    Write-Host "     - Use font subsets" -ForegroundColor Gray
    Write-Host "     - Consider system fonts" -ForegroundColor Gray
}

if ($totalSize -lt 5MB) {
    Write-Host "  ✅ Bundle size is good ($([math]::Round($totalSize / 1MB, 2)) MB)" -ForegroundColor Green
} elseif ($totalSize -lt 10MB) {
    Write-Host "  ⚠️  Bundle size is moderate ($([math]::Round($totalSize / 1MB, 2)) MB)" -ForegroundColor Yellow
} else {
    Write-Host "  ❌ Bundle size is large ($([math]::Round($totalSize / 1MB, 2)) MB)" -ForegroundColor Red
}

Write-Host ""
Write-Host "[3/3] Analysis complete!" -ForegroundColor Green
Write-Host ""
Write-Host "💡 Next steps:" -ForegroundColor Cyan
Write-Host "  - Run 'flutter build web --analyze-size' for detailed analysis" -ForegroundColor Gray
Write-Host "  - Check build\web\flutter_service_worker.js for chunk analysis" -ForegroundColor Gray
Write-Host "  - Use the optimization scripts in scripts\ folder" -ForegroundColor Gray
