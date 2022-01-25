
function Invoke-GithubApi {
    param(
        [Parameter(
            ValueFromRemainingArguments=$true
        )][string[]]
        $listArgs
    )
    $headers = {}
    if ($env:GITHUB_TOKEN) {
        $headers = @{ Authorization = "Bearer "+ $env:GITHUB_TOKEN }
    } elseif ($env:GITHUB_USER -and $env:GITHUB_PASS) {
        $headers = @{ Authorization = "Basic "+ [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes("$($env:GITHUB_USER):$($env:GITHUB_PASS)")) }
    }
    Invoke-WebRequest @listArgs -Headers $headers
}

function Get-GithubReleases {
    param (
        [Parameter(Position = 0, Mandatory = $true)]$Repo
    )
    
    $releases = "https://api.github.com/repos/$repo/releases"
    return (Invoke-GithubApi $releases | ConvertFrom-Json)
}

function Get-GithubAssets {
    param (
        [Parameter(Position = 0, Mandatory = $true)]$Repo,
        [Parameter(Position = 1, Mandatory = $true)]$ReleaseId
    )

    $assets = "https://api.github.com/repos/$Repo/releases/$ReleaseId/assets"
    return (Invoke-GithubApi $assets | ConvertFrom-Json)
}

function Get-MsiInfo {
    param (
        [Parameter(Position = 0, Mandatory = $true)]$Url
    )

    $urlHashStream = [IO.MemoryStream]::new([byte[]][char[]]$Url)
    $urlHash = (Get-FileHash -InputStream $urlHashStream -Algorithm MD5).Hash

    $FileName = $urlHash + "-" + $Url.Split('/')[-1]
    $FilePath = ".tmp\$FileName"
    if(-not (Test-Path -Path $FilePath)) {
        Start-BitsTransfer -Source $Url -Destination $FilePath
    }

    $WindowsInstaller = New-Object -ComObject WindowsInstaller.Installer
    $MSIDatabase = $WindowsInstaller.GetType().InvokeMember('OpenDatabase', 'InvokeMethod', $Null, $WindowsInstaller, @($FilePath, 0))
    $Query = 'SELECT * FROM Property'
    $View = $MSIDatabase.GetType().InvokeMember('OpenView', 'InvokeMethod', $null, $MSIDatabase, ($Query))
    $View.GetType().InvokeMember('Execute', 'InvokeMethod', $null, $View, $null) | Out-Null

    $hash = @{}
    while ($Record = $View.GetType().InvokeMember('Fetch', 'InvokeMethod', $null, $View, $null)) {
        $name = $Record.GetType().InvokeMember('StringData', 'GetProperty', $null, $Record, 1)
        $value = $Record.GetType().InvokeMember('StringData', 'GetProperty', $null, $Record, 2)
        $hash.Add($name,$value)
    }
    $checksum = (Get-FileHash -Path $FilePath -Algorithm SHA256).Hash

    return  [pscustomobject]@{
        Version = $hash.ProductVersion
        ProductCode = $hash.ProductCode
        UpgradeCode = $hash.UpgradeCode
        Hashsum =     $checksum
    }
}

function Get-ProductReleases {
    param (
        [Parameter(Position = 0, Mandatory = $true)]$Repo
    )

    @(Get-GithubReleases -Repo $Repo | ForEach-Object {
        [pscustomobject]@{
            Release = $_
            Assets = (Get-GithubAssets -Repo $Repo -ReleaseId $_.id | 
                Where-Object { $_.name -like "*.msi" } |
                ForEach-Object {
                    $msi = (Get-MsiInfo -Url $_.browser_download_url)
                    [pscustomobject]@{
                        PackageVersionObject = [System.Version]$msi.Version
                        PackageVersion = $msi.Version
                        InstallerUrl = $_.browser_download_url
                        InstallerSha256 = $msi.Hashsum
                        ProductCode = $msi.ProductCode
                    }
                })
        }
    })
}

Get-ChildItem -Path .\packages -Filter "*.product.json" | ForEach-Object {
    $json_in = Get-Content -Path ".\packages\$_" | ConvertFrom-Json

    $repo = $json_in.PackageUrl -replace "https://github.com/",""
    $name = ($_.BaseName -replace '.product','')

    "$name ($repo)" | Out-Host

    $assets =  Get-ProductReleases $repo | Select-Object -ExpandProperty Assets | Sort-Object -Property PackageVersionObject
    $json_out = ($assets | Select-Object PackageVersion,InstallerUrl,InstallerSha256,ProductCode | ConvertTo-Json)
    $json_out | Out-File -Encoding default -FilePath ".\packages\$name.releases.json"

    $jsonnet = @"
local wg = import "winget_package.libsonnet";

local product =  std.parseJson(importstr "./packages/$name.product.json");
local releases = std.parseJson(importstr "./packages/$name.releases.json");

wg.Files(product, releases)
"@
    $jsonnet | Out-File -Encoding default -FilePath ".\packages\$name.jsonnet"
}
