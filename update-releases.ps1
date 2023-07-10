. $PSScriptRoot\_common.ps1

Get-ChildItem -Path .\packages -Filter "*.product.json" | ForEach-Object {
    $json_in = Get-Content -Path "$_" | ConvertFrom-Json

    $repo = $json_in.PackageUrl -replace "https://github.com/",""
    $name = ($_.BaseName -replace '.product','')

    "$name ($repo)" | Out-Host

    $assets =  Get-ProductReleases $repo | Select-Object -ExpandProperty Assets | Sort-Object -Property PackageVersionObject
    $json_out = ($assets | Select-Object PackageVersion,InstallerUrl,InstallerSha256,ProductCode,UpgradeCode | ConvertTo-Json)
    $json_out | Out-File -Encoding default -FilePath ".\packages\$name.releases.json"

    $jsonnet = @"
local wg = import "winget_package.libsonnet";

local product =  std.parseJson(importstr "./packages/$name.product.json");
local releases = std.parseJson(importstr "./packages/$name.releases.json");

wg.Files(product, releases)
"@
    $jsonnet | Out-File -Encoding default -FilePath ".\packages\$name.jsonnet"
}
