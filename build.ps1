param(
    [Switch]$Release,
    [Switch]$NoGit
)

. $PSScriptRoot\_common.ps1

$ValidationErrors = @()
if(-not $Release) {
    if (-not (Test-Path env:PFX_THUMBPRINT)) { $ValidationErrors += @("PFX_THUMBPRINT envvar not set") }
    if (-not (Test-Path env:PFX_PASSPHRASE)) { $ValidationErrors += @("PFX_PASSPHRASE envvar not set") }
}
if ($ValidationErrors.Count -gt 0) { throw "Validation Failed!`n" + ($ValidationErrors -join "`n") }

$patchVersion = [int](git rev-list --count gh-pages main)
$version = "1.1.$patchVersion.0"

if((git diff --stat) -and -not $NoGit){
    throw "Working dir is dirty!"
}

if(-not $NoGit) {
    Invoke-Git checkout gh-pages
    Invoke-Git checkout -b "update-$version"

    Invoke-Git checkout main *.ps1 *.py *.sql *.libsonnet *.pfx
    Invoke-Git checkout main packages/ source/
    Invoke-Git restore --staged *

    Remove-Item -Recurse -Force -Path .\manifests -ErrorAction SilentlyContinue
    Remove-Item -Force -Path .\source.msix -ErrorAction SilentlyContinue
}

Remove-Item -Recurse -Force -Path .\.tmp\ -ErrorAction SilentlyContinue
New-Item -Path ".tmp" -Force -ItemType Directory | Out-Null
Copy-Item -Recurse -Path .\source -Destination .\.tmp\source

function Set-ManifestAttribute($AttributeName, $Value) {
    ((Get-Content -path .\.tmp\source\AppxManifest.xml -Raw) -replace "  $AttributeName=`".+?`"","  $AttributeName=`"$Value`"") | Set-Content -Encoding Default -Path .\.tmp\source\AppxManifest.xml
}

Set-ManifestAttribute -AttributeName "Version" -Value "$version"
if($Release) {
    Set-ManifestAttribute -AttributeName "Publisher" -Value "CN=Cloudflight GmbH, O=Cloudflight GmbH, STREET=Kaiser-Ludwig-Platz 5, L=Munich, S=Bavaria, C=DE, OID.1.3.6.1.4.1.311.60.2.1.1=Munich, OID.1.3.6.1.4.1.311.60.2.1.2=Bavaria, OID.1.3.6.1.4.1.311.60.2.1.3=DE, SERIALNUMBER=HRB 250832, OID.2.5.4.15=Private Organization"
} else {
    Set-ManifestAttribute -AttributeName "Publisher" -Value "CN=Cloudflight Operate Code Signing (TEST), O=Cloudflight Austria GmbH, C=AT"
}

.\01-generate-manifests.ps1
Check-LastCommand "generate failed"

py .\02-build-index-db.py
Check-LastCommand "index-db build failed"

.\03-build-index-package.ps1

if($Release) {
    .\04-sign-index-package-release.ps1
} else {
    .\04-sign-index-package-test.ps1
}

if(-not $NoGit) {
    Invoke-Git add source.msix
    Invoke-Git add manifests/
    Invoke-Git commit -m "new index published"
    Invoke-Git reset --hard
}
