Write-Host "Pushing changes to GitHub to trigger deployment..." -ForegroundColor Green

git add .
git commit -m "Trigger GitHub Actions deployment"
git push origin main

Write-Host "Changes pushed! Check GitHub Actions tab in 1-2 minutes." -ForegroundColor Yellow
Write-Host "Go to: https://github.com/Haridiii07/athletica/actions" -ForegroundColor Cyan
