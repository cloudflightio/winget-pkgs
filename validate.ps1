Get-ChildItem ".\manifests" -Recurse -Directory | % {
    $dotCount = ($_.BaseName.ToCharArray() | Where-Object {$_ -eq '.'} | Measure-Object).Count
    if ($dotCount -ge 2) {
        Get-ChildItem $_.FullName -Filter "*.yaml" | Where-Object { $_.BaseName -match "[0-9a-z]{4}-" } | % {
            Remove-Item $_.FullName
        }
        Write-Host $_.FullName
        winget validate --manifest $_.FullName
    }
}
