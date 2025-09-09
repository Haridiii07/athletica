# Athletica Dependency Analysis Script
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "    Athletica - Dependency Analysis" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check current dependencies
Write-Host "[1/4] Analyzing current dependencies..." -ForegroundColor Yellow

$pubspecContent = Get-Content "pubspec.yaml" -Raw
$dependencies = @()

# Extract dependencies from pubspec.yaml
$lines = $pubspecContent -split "`n"
$inDependencies = $false
$inDevDependencies = $false

foreach ($line in $lines) {
    if ($line -match "^dependencies:") {
        $inDependencies = $true
        $inDevDependencies = $false
        continue
    }
    if ($line -match "^dev_dependencies:") {
        $inDependencies = $false
        $inDevDependencies = $true
        continue
    }
    if ($line -match "^[a-zA-Z]" -and ($inDependencies -or $inDevDependencies)) {
        $inDependencies = $false
        $inDevDependencies = $false
        continue
    }
    
    if ($inDependencies -and $line -match "^\s+(\w+):") {
        $packageName = $matches[1]
        $dependencies += @{Name = $packageName; Type = "Production"}
    }
    if ($inDevDependencies -and $line -match "^\s+(\w+):") {
        $packageName = $matches[1]
        $dependencies += @{Name = $packageName; Type = "Development"}
    }
}

Write-Host "  📦 Found $($dependencies.Count) dependencies:" -ForegroundColor White
foreach ($dep in $dependencies) {
    Write-Host "    $($dep.Name) ($($dep.Type))" -ForegroundColor Gray
}

Write-Host ""

# Check for unused dependencies
Write-Host "[2/4] Checking for unused dependencies..." -ForegroundColor Yellow

$unusedDependencies = @()
$usedDependencies = @()

foreach ($dep in $dependencies) {
    if ($dep.Name -eq "flutter" -or $dep.Name -eq "flutter_test" -or $dep.Name -eq "flutter_lints") {
        $usedDependencies += $dep
        continue
    }
    
    # Search for package usage in lib directory
    $searchPattern = "import.*$($dep.Name)"
    $usage = Get-ChildItem -Path "lib" -Recurse -File -Name "*.dart" | ForEach-Object {
        $content = Get-Content "lib\$_" -Raw -ErrorAction SilentlyContinue
        if ($content -match $searchPattern) { $true }
    }
    
    if ($usage -contains $true) {
        $usedDependencies += $dep
        Write-Host "  ✅ $($dep.Name) - Used" -ForegroundColor Green
    } else {
        $unusedDependencies += $dep
        Write-Host "  ❌ $($dep.Name) - Unused" -ForegroundColor Red
    }
}

Write-Host ""

# Analyze import optimization opportunities
Write-Host "[3/4] Analyzing import optimization..." -ForegroundColor Yellow

$dartFiles = Get-ChildItem -Path "lib" -Recurse -File -Name "*.dart"
$importAnalysis = @()

foreach ($file in $dartFiles) {
    $content = Get-Content "lib\$file" -Raw
    $imports = [regex]::Matches($content, "import\s+['\"]([^'\"]+)['\"]")
    
    foreach ($import in $imports) {
        $importPath = $import.Groups[1].Value
        if ($importPath -match "package:") {
            $packageName = ($importPath -split "/")[0] -replace "package:", ""
            $importAnalysis += @{File = $file; Package = $packageName; Import = $importPath}
        }
    }
}

# Group by package
$packageUsage = $importAnalysis | Group-Object Package

Write-Host "  📊 Package usage analysis:" -ForegroundColor White
foreach ($group in $packageUsage) {
    $usageCount = $group.Count
    Write-Host "    $($group.Name): $usageCount imports" -ForegroundColor Gray
}

Write-Host ""

# Generate optimization recommendations
Write-Host "[4/4] Optimization recommendations..." -ForegroundColor Yellow

if ($unusedDependencies.Count -gt 0) {
    Write-Host "  🗑️  Remove unused dependencies:" -ForegroundColor Red
    foreach ($dep in $unusedDependencies) {
        Write-Host "    - $($dep.Name)" -ForegroundColor Gray
    }
    Write-Host ""
}

Write-Host "  🎯 Import optimization strategies:" -ForegroundColor Cyan
Write-Host "    - Use specific imports instead of wildcard imports" -ForegroundColor Gray
Write-Host "    - Remove unused imports" -ForegroundColor Gray
Write-Host "    - Use deferred imports for large packages" -ForegroundColor Gray
Write-Host "    - Consider lighter alternatives for heavy packages" -ForegroundColor Gray

Write-Host ""

# Calculate potential savings
$removedPackages = $unusedDependencies.Count
$estimatedSavings = $removedPackages * 50 # Rough estimate: 50KB per package

Write-Host "📊 Estimated savings:" -ForegroundColor Green
Write-Host "  Removed packages: $removedPackages" -ForegroundColor White
Write-Host "  Estimated bundle reduction: ~$estimatedSavings KB" -ForegroundColor White

Write-Host ""
Write-Host "✅ Dependency analysis complete!" -ForegroundColor Green
Write-Host ""
Write-Host "💡 Next steps:" -ForegroundColor Yellow
Write-Host "  1. Remove unused dependencies from pubspec.yaml" -ForegroundColor Gray
Write-Host "  2. Run 'flutter pub get' to update dependencies" -ForegroundColor Gray
Write-Host "  3. Test the application to ensure nothing breaks" -ForegroundColor Gray
Write-Host "  4. Run bundle analysis to verify improvements" -ForegroundColor Gray
