$winSdkFolder = if ($env:WINDOWS_SDK) { $env:WINDOWS_SDK_BIN_X64 } else { "C:\Program Files (x86)\Windows Kits\10\bin\10.0.20348.0\x64" }
$makeAppxPath = Join-Path $winSdkFolder -ChildPath makeappx.exe

& $makeAppxPath pack -d source -p source.msix
