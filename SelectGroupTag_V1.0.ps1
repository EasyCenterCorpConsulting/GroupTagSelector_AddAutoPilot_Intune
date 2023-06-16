# SelectGroupTag V1.0
# Created by Easy Center Corp Consulting
# Christophe Ruiz
# Jim Marley     -  External consultant. 
# Florent NOSARI -  econocom | Partner
# https://github.com/EasyCenterCorpConsulting/GroupTagSelector_AddAutoPilot_Intune/blob/main/README.md



# Customizing the Microsoft Script "Get-WindowsAutoPilotInfo.ps1" 
# https://techcommunity.microsoft.com/t5/windows-management/get-windowsautopilotinfo-a-quicker-way/m-p/212393

# GUI interface with a list selector for Group Tag via PowerShell. 
# After you have selected your Group Tag, the script will manage your CSV file containing 
# the hash of your device associated with the Group Tag you have selected.

# Update 12/06/23. 
# We have renamed fichier.txt to GroupTagList.txt, and temp.txt to SelectedGroupTag.txt for a better understanding.

Begin
{
	# Self-elevate the script if required
	if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
		if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
			$CommandLine = '-ExecutionPolicy Bypass  -File "' + $($PSCommandPath) + '" '+$(Get-Location)
            Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine 
			Exit
		}
	}




# Interface Gui

# Importing System.Windows.Forms assembly
Add-Type -AssemblyName System.Windows.Forms

# Importing System.Drawing assembly
Add-Type -AssemblyName System.Drawing

# Creating the main window
$form = New-Object System.Windows.Forms.Form
$form.Text = "Group Tag Selection"
$form.Size = New-Object System.Drawing.Size(350, 200)
$form.StartPosition = "CenterScreen"
$form.BackColor = [System.Drawing.Color]::Black
$form.Opacity = 0.8

# Creating the selector
$selector = New-Object System.Windows.Forms.ComboBox
$selector.Location = New-Object System.Drawing.Point(15,30)
$selector.Size = New-Object System.Drawing.Size(300, 20)
$selector.BackColor = [System.Drawing.Color]::Gray

# Change font size
$selector.Font = New-Object System.Drawing.Font("Arial", 12) 

# Reading the text file
$filePath = Join-Path -Path $PSScriptRoot -ChildPath "GroupTagList.txt"
$lines = Get-Content $filePath

# Adding records to the selector
$selector.Items.AddRange($lines)

# Creating the "Validate" button
$button = New-Object System.Windows.Forms.Button
$button.Location = New-Object System.Drawing.Point(120, 80)
$button.Size = New-Object System.Drawing.Size(100, 30)
$button.Text = "Valider"
$button.BackColor = [System.Drawing.Color]::Gray

# Creating the variable to store the selected value
$selectedValue = ""

# Function triggered when clicking the "Validate" button
$button.Add_Click({
    $selectedValue = $selector.SelectedItem
    $form.Close()

    # Displaying the result in the console
    Write-Host "$selectedValue"
    Set-Content -Path .\SelectedGroupTag.txt -Value $selectedValue
})

# Adding controls to the main window
$form.Controls.Add($selector)
$form.Controls.Add($button)

# Displaying the window
$result = $form.ShowDialog()

# Checking if the "Validate" button was clicked
if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
    # Incrementing the variable with the selected value
    # Assuming you want to concatenate another string
    $variable = $selectedValue + "1"

    Write-Host "The variable has been incremented. New value: $variable"
    Start-Sleep -Seconds 20
}

		

# Create the file if it doesn't exist
if (-not (Test-Path -Path .\SelectedGroupTag.txt)) {
    Set-Content -Path .\SelectedGroupTag.txt -Value ""
}

$scriptDirectory = Split-Path $script:MyInvocation.MyCommand.Path
$GroupTag = Get-Content -Path ".\SelectedGroupTag.txt"


	if ($args[0]) {
		Set-Location -Path $args[0]
	}

}

	

Process
{
	# Get a CIM session
	$comp ="localhost"
	$session = New-CimSession

	# Get the common properties.
	Write-Verbose "Checking $comp"
	$serial = (Get-CimInstance -CimSession $session -Class Win32_BIOS).SerialNumber

	# Get the hash (if available)
	$devDetail = (Get-CimInstance -CimSession $session -Namespace root/cimv2/mdm/dmmap -Class MDM_DevDetail_Ext01 -Filter "InstanceID='Ext' AND ParentID='./DevDetail'")
	if ($devDetail -and (-not $Force))
	{
		$hash = $devDetail.DeviceHardwareData
	}
	else
	{
		throw "Unable to retrieve device hardware data (hash) from computer $comp"		
	}

    # Getting the PKID is generally problematic for anyone other than OEMs, so let's skip it here
    $product = ""

	# Create a pipeline object
		$deviceInfo = New-Object psobject -Property @{
			"Device Serial Number" = $serial
            "Windows Product ID" = $product
			"Hardware Hash" = $hash
			"Group Tag" = $GroupTag
            
		}


	# Remove CIM session
	Remove-CimSession $session
}

End
{
	# Create file
	Write-Output $deviceInfo | Select-Object "Device Serial Number","Windows Product ID", "Hardware Hash", "Group Tag" | ConvertTo-CSV -NoTypeInformation | % {$_ -replace '"',''} | Out-File "AutoPilotHWID-$serial.csv"
	Write-Output "Success ! Press Enter to shutdown the computer"
    Pause
    Stop-Computer -ComputerName localhost

}
