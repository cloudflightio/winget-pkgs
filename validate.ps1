New-Item -Path ".tmp" -Force -ItemType Directory | Out-Null
Remove-Item -Path ".tmp\validate\" -Recurse -Force -ErrorAction SilentlyContinue
Copy-Item -Path ".\manifests" -Destination ".tmp\validate\manifests" -Recurse

$failed = $false

Get-ChildItem ".tmp\validate\manifests" -Recurse -Directory | % {
    $dotCount = ($_.BaseName.ToCharArray() | Where-Object {$_ -eq '.'} | Measure-Object).Count
    if ($dotCount -ge 2) {
        Get-ChildItem $_.FullName -Filter "*.yaml" | Where-Object { $_.BaseName -match "[0-9a-z]{4}-" } | % {
            Remove-Item $_.FullName
        }
        Write-Host $_.FullName
        winget validate --manifest $_.FullName
        if($LASTEXITCODE -ne 0) {
            $failed = $true
        }
    }
}

if($failed) {
    throw "Validation failed"
}
