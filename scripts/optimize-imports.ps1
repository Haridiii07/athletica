# Athletica Import Optimization Script
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "    Athletica - Import Optimization" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Find all Dart files
Write-Host "[1/4] Scanning Dart files..." -ForegroundColor Yellow

$dartFiles = Get-ChildItem -Path "lib" -Recurse -File -Name "*.dart"
Write-Host "  Found $($dartFiles.Count) Dart files" -ForegroundColor White

Write-Host ""

# Analyze imports in each file
Write-Host "[2/4] Analyzing imports..." -ForegroundColor Yellow

$importIssues = @()
$totalImports = 0

foreach ($file in $dartFiles) {
    $content = Get-Content "lib\$file" -Raw
    $lines = $content -split "`n"
    
    $fileImports = @()
    $unusedImports = @()
    
    # Find all imports
    for ($i = 0; $i -lt $lines.Length; $i++) {
        $line = $lines[$i]
        if ($line -match "^\s*import\s+['\"]([^'\"]+)['\"]") {
            $importPath = $matches[1]
            $fileImports += @{Line = $i + 1; Import = $importPath; Content = $line}
            $totalImports++
        }
    }
    
    # Check for unused imports
    foreach ($import in $fileImports) {
        $importName = ""
        if ($import.Import -match "package:([^/]+)") {
            $importName = $matches[1]
        } elseif ($import.Import -match "dart:([^/]+)") {
            $importName = $matches[1]
        }
        
        if ($importName -and $importName -ne "flutter" -and $importName -ne "dart:core") {
            # Check if the import is actually used in the file
            $isUsed = $false
            $contentWithoutImports = $content -replace "import\s+['\"][^'\"]+['\"];?\s*", ""
            
            # Look for usage patterns
            $usagePatterns = @(
                $importName,
                $importName -replace "_", "",
                $importName -replace "package:", ""
            )
            
            foreach ($pattern in $usagePatterns) {
                if ($contentWithoutImports -match "\b$pattern\b") {
                    $isUsed = $true
                    break
                }
            }
            
            if (-not $isUsed) {
                $unusedImports += $import
            }
        }
    }
    
    if ($unusedImports.Count -gt 0) {
        $importIssues += @{File = $file; UnusedImports = $unusedImports}
    }
}

Write-Host "  Total imports found: $totalImports" -ForegroundColor White
Write-Host "  Files with unused imports: $($importIssues.Count)" -ForegroundColor White

Write-Host ""

# Report unused imports
Write-Host "[3/4] Unused import analysis..." -ForegroundColor Yellow

if ($importIssues.Count -gt 0) {
    Write-Host "  🗑️  Unused imports found:" -ForegroundColor Red
    foreach ($issue in $importIssues) {
        Write-Host "    File: $($issue.File)" -ForegroundColor White
        foreach ($unused in $issue.UnusedImports) {
            Write-Host "      Line $($unused.Line): $($unused.Import)" -ForegroundColor Gray
        }
        Write-Host ""
    }
} else {
    Write-Host "  ✅ No unused imports found" -ForegroundColor Green
}

Write-Host ""

# Check for wildcard imports
Write-Host "[4/4] Wildcard import analysis..." -ForegroundColor Yellow

$wildcardImports = @()
foreach ($file in $dartFiles) {
    $content = Get-Content "lib\$file" -Raw
    if ($content -match "import\s+['\"][^'\"]+\*['\"]") {
        $wildcardImports += @{File = $file; Matches = [regex]::Matches($content, "import\s+['\"][^'\"]+\*['\"]")}
    }
}

if ($wildcardImports.Count -gt 0) {
    Write-Host "  ⚠️  Wildcard imports found:" -ForegroundColor Yellow
    foreach ($wildcard in $wildcardImports) {
        Write-Host "    File: $($wildcard.File)" -ForegroundColor White
        foreach ($match in $wildcard.Matches) {
            Write-Host "      $($match.Value)" -ForegroundColor Gray
        }
    }
    Write-Host ""
    Write-Host "  💡 Consider using specific imports instead of wildcards" -ForegroundColor Cyan
} else {
    Write-Host "  ✅ No wildcard imports found" -ForegroundColor Green
}

Write-Host ""

# Generate optimization recommendations
Write-Host "🎯 Optimization recommendations:" -ForegroundColor Yellow
Write-Host "  1. Remove unused imports to reduce bundle size" -ForegroundColor Gray
Write-Host "  2. Use specific imports instead of wildcard imports" -ForegroundColor Gray
Write-Host "  3. Consider deferred imports for large packages" -ForegroundColor Gray
Write-Host "  4. Group imports by type (dart:, package:, relative)" -ForegroundColor Gray

Write-Host ""
Write-Host "📊 Potential improvements:" -ForegroundColor Green
$unusedCount = ($importIssues | ForEach-Object { $_.UnusedImports.Count } | Measure-Object -Sum).Sum
Write-Host "  Unused imports: $unusedCount" -ForegroundColor White
Write-Host "  Estimated bundle reduction: ~$($unusedCount * 2) KB" -ForegroundColor White

Write-Host ""
Write-Host "✅ Import optimization analysis complete!" -ForegroundColor Green
