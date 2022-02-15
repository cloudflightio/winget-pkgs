$DescriptionURL = "https://github.com/cloudflightio/dockerinwsl"
$AzureKeyVaultURL = "https://cloudflight-code-signing.vault.azure.net"
$AzureKeyVaultTenantId = "e21ebe2c-3b5b-4d4c-8d0e-c1ca0e8ea14b"
$AzureKeyVaultClientId = "18462f44-aee3-42ac-aba8-bdfd3d4d8c23"
$AzureKeyVaultCertificate = "globalsign-ev-code-signing"
$TimestampService = "http://timestamp.digicert.com"

& AzureSignTool sign `
    -du "$DescriptionURL" `
    -fd sha256 `
    -kvu "$AzureKeyVaultURL" `
    -kvi "$AzureKeyVaultClientId" `
    -kvt "$AzureKeyVaultTenantId" `
    -kvs "$env:AZURE_SIGN_CLIENT_SECRET" `
    -kvc "$AzureKeyVaultCertificate" `
    -tr "$TimestampService" `
    -td sha384 `
    -v `
    "$PSScriptRoot\source.msix"