function Invoke-GithubApi {
    param(
        [Parameter(
            ValueFromRemainingArguments=$true
        )][string[]]
        $listArgs
    )
    $headers = $null
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

function Get-Property ($Object, $PropertyName, [object[]]$ArgumentList) {
    return $Object.GetType().InvokeMember($PropertyName, 'Public, Instance, GetProperty', $null, $Object, $ArgumentList)
}

function Get-MsiInfo {
    param (
        [Parameter(Position = 0, Mandatory = $true)]$Url
    )
    try {
    $windowsInstaller = New-Object -ComObject WindowsInstaller.Installer

    $urlHashStream = [IO.MemoryStream]::new([byte[]][char[]]$Url)
    $urlHash = (Get-FileHash -InputStream $urlHashStream -Algorithm MD5).Hash

    $FileName = $urlHash + "-" + $Url.Split('/')[-1]
    $FilePath = ".tmp\$FileName"
    New-Item -ItemType Directory -Path ".tmp" -ErrorAction SilentlyContinue
    if(-not (Test-Path -Path $FilePath)) {
        Start-BitsTransfer -Source $Url -Destination $FilePath
    }

    $MSI = $windowsInstaller.OpenDatabase($FilePath, 0)

    $View = $MSI.OpenView("SELECT * FROM Property")
    $View.Execute()

    $hash = @{}
    while ($Record = $View.Fetch()) {
        $name = Get-Property $Record StringData 1
        $value = Get-Property $Record StringData 2
        $hash.Add($name,$value)
    }
    $View.Close()
    [System.GC]::Collect()
    
    $checksum = (Get-FileHash -Path $FilePath -Algorithm SHA256).Hash
    } catch {
        $_ | Format-List * -Force | Write-Output
        throw $_
    }
    return  [pscustomobject]@{
        Version = $hash.ProductVersion
        ProductCode = $hash.ProductCode
        UpgradeCode = $hash.UpgradeCode
        Hashsum =     $checksum
    }
}

function Get-ProductReleases {
    param (
        [Parameter(Position = 0, Mandatory = $true)]$Repo,
        [Switch]$WithPrerelease
    )

    @(
        Get-GithubReleases -Repo $Repo | 
        Where-Object { (-not $_.prerelease) -or ($_.prerelease -eq $WithPrerelease) } | 
        ForEach-Object {
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
