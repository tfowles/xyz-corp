if ((Get-PSRepository -Name PSGallery).InstallationPolicy -ne 'Trusted'){
    Set-PSRepository -Name 'PSGallery' -InstallationPolicy 'Trusted'
}
Install-Module -Name SqlServer -Repository PSGallery -RequiredVersion 21.1.18256 -Scope CurrentUser -AllowClobber
Import-Module -Name SqlServer -RequiredVersion 21.1.18256

$json = Get-Content -Raw -Path "..\config\local.settings.json" | ConvertFrom-Json

$ServerName = $json.'connection-string'.'server-name'
$DatabaseName = $json.'connection-string'.'database-name'

[System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SMO") | out-null
$SMOserver = New-Object ('Microsoft.SqlServer.Management.Smo.Server') -argumentlist $ServerName

$DatabaseList = $SMOserver.Databases | Select-Object -Property "Name"

if ($DatabaseList.Contains($DatabaseName)){
    $SMOserver.KillDatabase($DatabaseName)
}

$Database = New-Object Microsoft.SqlServer.Management.Smo.Database($SMOserver, $DatabaseName)
$Database.Create()