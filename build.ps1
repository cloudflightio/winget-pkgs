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

Invoke-Git checkout main
Invoke-Git checkout -b "update-$version"

Remove-Item -Recurse -Force -Path .\manifests -ErrorAction SilentlyContinue
Remove-Item -Force -Path .\source.msix -ErrorAction SilentlyContinue

((Get-Content -path .\source\AppxManifest.xml -Raw) -replace ' Version="[0-9\.]+" />'," Version=`"$version`" />") | Set-Content -Encoding Default -Path .\source\AppxManifest.xml

.\generate.ps1
Check-LastCommand "generate failed"

py .\build-index.py
Check-LastCommand "index-db build failed"

.\Build-Index-Package.ps1
.\Sign-Index-Package.ps1

Invoke-Git add source.msix
Invoke-Git add manifests/
Invoke-Git commit -m "new index published"
Invoke-Git reset --hard
Invoke-Git checkout gh-pages

Remove-Item -Recurse -Force -Path .\manifests -ErrorAction SilentlyContinue
Remove-Item -Force -Path .\source.msix -ErrorAction SilentlyContinue

Invoke-Git checkout "update-$version" manifests\
Invoke-Git checkout "update-$version" source.msix
Invoke-Git add source.msix
Invoke-Git add manifests/
Invoke-Git commit -m "new index published"

Invoke-Git branch -D "update-$version"