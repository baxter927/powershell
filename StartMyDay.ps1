#command for each program
function Run-ADUC {
    Start-Process powershell.exe -Credential ($myCredentials) -ArgumentList "Start-Process -FilePath $env:SystemRoot\System32\mmc.exe -ArgumentList $env:SystemRoot\system32\dsa.msc -Verb runAs"
}

function Run-ADAC {
    Start-Process powershell.exe $accountName $accountPass -ArgumentList "Start-Process -FilePath $env:windir\System32\dsac.exe"
}

function Run-IEasAdmin {
    Start-Process powershell.exe $accountName $accountPass -ArgumentList "Start-Process -FilePath 'C:\Program Files\internet explorer\iexplore.exe'"
}

function Run-SimpleHelp {
    Start-Process powershell.exe -ArgumentList "Start-Process -FilePath 'C:\Users\BaxterS\Desktop\SimpleHelp Technician-windows64-offline.exe'"
}

#runs selected programs - calls only user selected
#to be added late

#runs all programs - calls all of the programs
function Run-All {
#    Run-ADAC
    Run-ADUC
#    Run-IEasAdmin
#    Run-SimpleHelp
Write-Host Account Name: $global:accountName
Write-Host Account Pass: $global:accountPass
Write-Host Both Creds:  $myCredentials
}

$accountName = "oslan\" + "a" + $env:UserName + "2"
#variables for confirming user's A account dialogue
$accountMessage  = 'Confirm your account'
$accountQuestion = "Is your Admin account: $accountName"
$accountChoice = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
$accountChoice.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Yes'))
$accountChoice.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&No'))

#variables for obtaining user's program launch choice dialogue
$programMessage  = 'Choose the program launch option'
$programQuestion = "Do you want to launch all programs or choose?"
$programChoice = New-Object Collections.ObjectModel.Collection[Management.Automation.Host.ChoiceDescription]
$programChoice.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&All'))
$programChoice.Add((New-Object Management.Automation.Host.ChoiceDescription -ArgumentList '&Choose'))

#gets user input admin account
function Get-userInputAdminAccount {
$accountNameEntered = Read-Host "What is your A account name?" -AsSecureString
$nameBSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($accountNameEntered)
$global:accountName = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($nameBSTR)
Write-Host func-getuserinputadminaccount $global:accountName
}

#gets user input admin password
function Get-userInputAdminPassword {
$accountPasswordEntered = Read-Host "What is your A account password?" -AsSecureString
$passBSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($accountPasswordEntered)
$global:accountPass = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($passBSTR)
Write-Host func-getuserinputadfminpass $global:accountPass
}

#asks if user wants to run all programs or selected ones
function Get-programSelection {
$runDecision = $Host.UI.PromptForChoice($programMessage, $programQuestion, $programChoice, 1)
if ($runDecision -eq 0) {
  Write-Host "Run all progs"
  Run-All
} else {
  Write-Host "Choose progs"
}
}


# A 0 confirms user's A account
$accountDecision = $Host.UI.PromptForChoice($accountMessage, $accountQuestion, $accountChoice, 1)
if ($accountDecision -eq 0) {
  Get-userInputAdminPassword
  Get-programSelection
} else {
  Get-userInputAdminAccount
  Get-userInputAdminPassword
  Get-programSelection
}

# something is not right with this
$myCredentials = New-Object System.Management.Automation.PSCredential -ArgumentList @($global:accountName,(ConvertTo-SecureString -String $global:accountPass -AsPlainText -Force))
