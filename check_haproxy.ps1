#!/usr/bin/env pwsh
$WIUser = ''
$WIPass = ''
$MWarnAt = 0.80
$MCritAt = 0.90
# try to connect haproxy status page
try {
    If ($WIPass){
    $ParaIW = @{
        URI = "https://localhost/lbstatistik;csv"
        SkipCertificateCheck = $true # if you use ssl
        Credential = (New-Object System.Management.Automation.PSCredential($WIUser,(ConvertTo-SecureString $WIPass -AsPlainText -Force)))
        }
    } else {
        $ParaIW = @{
            URI = "https://localhost/lbstatistik;csv"
            SkipCertificateCheck = $true # if you use ssl
        }
    }
    # check if target reachable .. if not exit
    $HAContent = (Invoke-WebRequest @ParaIW)
    $HAArray = (($HAContent).content -split('\n'))
} catch {
    Write-Output "Error to connect to haproxy status page"
    exit 2
}
foreach ($LineInArray in $HAArray){
    try { $LineArrayElements = $LineInArray -split(',') } catch { write-output 'Wrong HAProxy Version ?'}
        if ([string]::IsNullOrEmpty($LineArrayElements[0]) -or $LineArrayElements[0].Substring(0,1) -eq '#'){
            # skip if line starts with an # or the first string is empty or null
            continue
        }
        try {
            $HaStatusName = $LineArrayElements[0]
            $HaStatusElement = $LineArrayElements[1]
            $HAStatusState = $LineArrayElements[17]
            [int]$HASessionsCurrent = [convert]::ToInt32($LineArrayElements[4])
            [int]$HASessionsMax = [convert]::ToInt32($LineArrayElements[5])
            # calc thresholds
            $ThresholdWarning = [math]::Round($HASessionsMax * $MWarnAt)
            $ThresholdCritical = [math]::Round($HASessionsMax * $MCritAt)
        } catch {
            Write-Output 'something went wrong check the output of your haproxy status page - could not declare vars'
            exit 3
        }
        if (($HAStatusState -ne 'UP') -or ($HAStatusState -ne 'OPEN')){
            switch ($HASessionsCurrent){
                {($_ -lt $ThresholdWarning) -and ($_ -lt $ThresholdCritical)}     { $CheckStatus = '0' }
                {($_ -ge $ThresholdWarning) -and ($_ -lt $ThresholdCritical)}     { $CheckStatus = '1' }
                {($_ -ge $ThresholdCritical)}                                     { $Checkstatus = '2' }
                # if session max or session current is 0 then set checkstate to 0
                {($_ -eq '0') -Or ($HASessionsMax -eq '0')}                       { $CheckStatus = '0' }
            }
        } else {
            $CheckStatus = '2'
        }
        Write-Output -InputObject ('{0} {1}-{2} - {2} {3}/{4} Sessions Host is {5}' -f $CheckStatus, $HaStatusName, $HaStatusElement, $HASessionsCurrent, $HASessionsMax, $HAStatusState)
}