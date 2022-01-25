function Check-LastCommand {
    param (
        $Msg = "ERROR!"
    )
    if ($lastexitcode -ne 0)
    {
        throw $Msg
    }
}

function Invoke-Git {
    param(
        [Parameter(
            ValueFromRemainingArguments=$true
        )][string[]]
        $listArgs
    )

    & "git" @listArgs
    Check-LastCommand "git call failed! $listArgs"
}

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
