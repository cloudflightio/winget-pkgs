Get-ChildItem ".\manifests" -Recurse -Directory | % {
    $dotCount = ($_.BaseName.ToCharArray() | Where-Object {$_ -eq '.'} | Measure-Object).Count
    if ($dotCount -ge 2) {
        Write-Host $_.FullName
        winget validate --manifest $_.FullName
    }
}
