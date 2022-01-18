param (
    [Parameter(Position = 0, Mandatory = $true)]$Url
)

$FileName = $Url.Split('/')[-1]
$FilePath = ".tmp\$FileName"
Start-BitsTransfer -Source $Url -Destination $FilePath

$WindowsInstaller = New-Object -ComObject WindowsInstaller.Installer
$MSIDatabase = $WindowsInstaller.GetType().InvokeMember('OpenDatabase', 'InvokeMethod', $Null, $WindowsInstaller, @($FilePath, 0))
$Query = 'SELECT * FROM Property'
$View = $MSIDatabase.GetType().InvokeMember('OpenView', 'InvokeMethod', $null, $MSIDatabase, ($Query))
$View.GetType().InvokeMember('Execute', 'InvokeMethod', $null, $View, $null)

$hash = @{}
$MSIResult = while ($Record = $View.GetType().InvokeMember('Fetch', 'InvokeMethod', $null, $View, $null)) {
	$name = $Record.GetType().InvokeMember('StringData', 'GetProperty', $null, $Record, 1)
	$value = $hashMSIValue = $Record.GetType().InvokeMember('StringData', 'GetProperty', $null, $Record, 2)
	$hash.Add($name,$value)
}
$msiProperties = [pscustomobject]$hash

$checksum = (Get-FileHash -Path $FilePath -Algorithm SHA256).Hash

return @{
ProductCode = $msiProperties.ProductCode
UpgradeCode = $msiProperties.UpgradeCode
Hashsum =     $checksum
}