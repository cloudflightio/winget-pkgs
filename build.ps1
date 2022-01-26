. $PSScriptRoot\_common.ps1

$ValidationErrors = @()
if (-not (Test-Path env:PFX_THUMBPRINT)) { $ValidationErrors += @("PFX_THUMBPRINT envvar not set") }
if (-not (Test-Path env:PFX_PASSPHRASE)) { $ValidationErrors += @("PFX_PASSPHRASE envvar not set") }
if ($ValidationErrors.Count -gt 0) { throw "Validation Failed!`n" + ($ValidationErrors -join "`n") }

$patchVersion = [int](git rev-list --count gh-pages main)
$version = "1.0.$patchVersion.0"

if((git diff --stat)){
    throw "Working dir is dirty!"
}

Invoke-Git checkout gh-pages
Invoke-Git checkout -b "update-$version"

Invoke-Git checkout main *.ps1 *.py *.sql *.libsonnet *.pfx
Invoke-Git checkout main packages/ source/
Invoke-Git restore --staged *

Remove-Item -Recurse -Force -Path .\manifests -ErrorAction SilentlyContinue
Remove-Item -Force -Path .\source.msix -ErrorAction SilentlyContinue

((Get-Content -path .\source\AppxManifest.xml -Raw) -replace ' Version="[0-9\.]+" />'," Version=`"$version`" />") | Set-Content -Encoding Default -Path .\source\AppxManifest.xml

.\01-generate-manifests.ps1
Check-LastCommand "generate failed"

py .\02-build-index-db.py
Check-LastCommand "index-db build failed"

.\03-build-index-package.ps1
.\04-sign-index-package.ps1

Invoke-Git add source.msix
Invoke-Git add manifests/
Invoke-Git commit -m "new index published"
Invoke-Git reset --hard
