
$tmpPath = Join-Path -Path (Resolve-Path .tmp).Path -ChildPath .\manifests

New-Item -Path $tmpPath -Force -ItemType Directory

Get-ChildItem .\packages -Filter '*.jsonnet' | % {
    jsonnet -m $tmpPath -c ".\packages\$($_.Name)"
}

Get-ChildItem .tmp -Recurse -Include '*.json' | % {
    $item = (Get-Content -Path "$_" | ConvertFrom-Json)
    Set-Content -Path (Join-Path -Path $_.Directoryname -ChildPath ([System.IO.Path]::GetFileNameWithoutExtension("$_") + ".yaml")) -Value ($item | ConvertTo-Yaml).TrimEnd()
    Remove-Item $_
}

Copy-Item -Path "$tmpPath\*" -Recurse -Force -Destination .\manifests
