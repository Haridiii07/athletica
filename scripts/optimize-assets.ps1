# Athletica Asset Optimization Script
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "    Athletica - Asset Optimization" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check for optimization tools
Write-Host "[1/6] Checking optimization tools..." -ForegroundColor Yellow

$tools = @{
    "ImageMagick" = "magick"
    "Node.js" = "node"
    "npm" = "npm"
}

foreach ($tool in $tools.GetEnumerator()) {
    $command = Get-Command $tool.Value -ErrorAction SilentlyContinue
    if ($command) {
        Write-Host "  ✅ $($tool.Key) found" -ForegroundColor Green
    } else {
        Write-Host "  ❌ $($tool.Key) not found" -ForegroundColor Red
    }
}

Write-Host ""

# Analyze current assets
Write-Host "[2/6] Analyzing current assets..." -ForegroundColor Yellow

$imageExtensions = @("*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.svg")
$fontExtensions = @("*.ttf", "*.woff", "*.woff2", "*.eot")

# Check images
$imageFiles = Get-ChildItem -Path "assets" -Recurse -Include $imageExtensions -ErrorAction SilentlyContinue
if ($imageFiles) {
    Write-Host "  📁 Found $($imageFiles.Count) image files:" -ForegroundColor White
    $imageFiles | ForEach-Object {
        $sizeKB = [math]::Round($_.Length / 1KB, 2)
        Write-Host "    $($_.Name): $sizeKB KB" -ForegroundColor Gray
    }
} else {
    Write-Host "  📁 No image files found" -ForegroundColor Gray
}

# Check fonts
$fontFiles = Get-ChildItem -Path "assets" -Recurse -Include $fontExtensions -ErrorAction SilentlyContinue
if ($fontFiles) {
    Write-Host "  📁 Found $($fontFiles.Count) font files:" -ForegroundColor White
    $fontFiles | ForEach-Object {
        $sizeKB = [math]::Round($_.Length / 1KB, 2)
        Write-Host "    $($_.Name): $sizeKB KB" -ForegroundColor Gray
    }
} else {
    Write-Host "  📁 No font files found" -ForegroundColor Gray
}

Write-Host ""

# Font optimization recommendations
Write-Host "[3/6] Font optimization recommendations..." -ForegroundColor Yellow

Write-Host "  🎯 Google Fonts Optimization:" -ForegroundColor Cyan
Write-Host "    Current: https://fonts.googleapis.com/css2?family=Cairo:wght@400;700" -ForegroundColor Gray
Write-Host "    Optimized: https://fonts.googleapis.com/css2?family=Cairo:wght@400;700&subset=arabic&display=swap" -ForegroundColor Green
Write-Host "    Benefits:" -ForegroundColor White
Write-Host "      - Arabic subset only (60% smaller)" -ForegroundColor Gray
Write-Host "      - Display swap for better performance" -ForegroundColor Gray
Write-Host "      - Only required weights (400, 700)" -ForegroundColor Gray

Write-Host ""

# Image optimization recommendations
Write-Host "[4/6] Image optimization recommendations..." -ForegroundColor Yellow

if ($imageFiles) {
    $totalImageSize = ($imageFiles | Measure-Object -Property Length -Sum).Sum
    $totalImageSizeMB = [math]::Round($totalImageSize / 1MB, 2)
    
    Write-Host "  📊 Current image size: $totalImageSizeMB MB" -ForegroundColor White
    
    if ($totalImageSizeMB -gt 1) {
        Write-Host "  ⚠️  Images are large - optimization needed!" -ForegroundColor Red
    } else {
        Write-Host "  ✅ Image size is reasonable" -ForegroundColor Green
    }
    
    Write-Host "  🎯 Optimization strategies:" -ForegroundColor Cyan
    Write-Host "    - Convert to WebP format (25-50% smaller)" -ForegroundColor Gray
    Write-Host "    - Compress with TinyPNG or Squoosh" -ForegroundColor Gray
    Write-Host "    - Use appropriate image sizes" -ForegroundColor Gray
    Write-Host "    - Implement lazy loading" -ForegroundColor Gray
} else {
    Write-Host "  📁 No images to optimize" -ForegroundColor Gray
}

Write-Host ""

# Create optimization commands
Write-Host "[5/6] Generating optimization commands..." -ForegroundColor Yellow

# WebP conversion command (if ImageMagick is available)
$magickCommand = Get-Command "magick" -ErrorAction SilentlyContinue
if ($magickCommand) {
    Write-Host "  🔧 WebP conversion command:" -ForegroundColor Cyan
    Write-Host "    magick input.png -quality 85 output.webp" -ForegroundColor Gray
    Write-Host "    magick input.jpg -quality 85 output.webp" -ForegroundColor Gray
}

# Font subset command (if tools are available)
Write-Host "  🔧 Font subset command:" -ForegroundColor Cyan
Write-Host "    npm install -g font-subset" -ForegroundColor Gray
Write-Host "    font-subset input.ttf --text='أبجدية عربية'" -ForegroundColor Gray

Write-Host ""

# Performance impact estimation
Write-Host "[6/6] Performance impact estimation..." -ForegroundColor Yellow

$estimatedSavings = 0
if ($imageFiles) {
    $imageSavings = [math]::Round($totalImageSize * 0.35 / 1MB, 2) # 35% average savings
    $estimatedSavings += $imageSavings
    Write-Host "  📈 Image optimization: ~$imageSavings MB savings" -ForegroundColor Green
}

$fontSavings = 0.12 # 120KB savings from font subset
$estimatedSavings += $fontSavings
Write-Host "  📈 Font optimization: ~$fontSavings MB savings" -ForegroundColor Green

Write-Host "  📊 Total estimated savings: ~$([math]::Round($estimatedSavings, 2)) MB" -ForegroundColor Cyan

Write-Host ""
Write-Host "🎯 Next steps:" -ForegroundColor Yellow
Write-Host "  1. Use online tools: https://squoosh.app/ or https://tinypng.com/" -ForegroundColor Gray
Write-Host "  2. Convert images to WebP format" -ForegroundColor Gray
Write-Host "  3. Update Google Fonts URL with Arabic subset" -ForegroundColor Gray
Write-Host "  4. Test performance improvements" -ForegroundColor Gray
Write-Host "  5. Run bundle analysis to verify savings" -ForegroundColor Gray

Write-Host ""
Write-Host "✅ Asset optimization analysis complete!" -ForegroundColor Green
