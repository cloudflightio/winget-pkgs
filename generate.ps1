
$tmpPath = (Resolve-Path .tmp).Path

Get-ChildItem .\packages | % {
    jsonnet -m $tmpPath -c .\packages\$_
}

Get-ChildItem .tmp -Recurse -Include '*.json' | % {
    $item = (Get-Content -Path "$_" | ConvertFrom-Json)
    Set-Content -Path (Join-Path -Path $_.Directoryname -ChildPath ([System.IO.Path]::GetFileNameWithoutExtension("$_") + ".yaml")) -Value ($item | ConvertTo-Yaml).TrimEnd()
    Remove-Item $_
}

Copy-Item -Path ".tmp\*" -Recurse -Force -Destination .\manifests
