Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# software name
$software1 = "Wire Guard With Office Connection"
$software2 = "Notepad++"
$software3 = "Visual Studio Code"

# installation status
$software1status = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where {$_.DisplayName -like "*$software1*"}
$software2status = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where {$_.DisplayName -like "*$software2*"}
$software3status = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where {$_.DisplayName -like "*$software3*"}

# set form size
$Form = New-Object System.Windows.Forms.Form
$Form.width = 500
$Form.height = 500
$Form.Text = 'Install Software'

# set font
$Font = New-Object System.Drawing.Font("Verdana",10)
$Form.Font = $Font

# results textbox
$ResultsTextBox = New-Object System.Windows.Forms.TextBox
$ResultsTextBox.Location = New-Object System.Drawing.Size(200,30)
$ResultsTextBox.Size = New-Object System.Drawing.Size(250,350)
$ResultsTextBox.Multiline = $true
$ResultsTextBox.Text = "make your selections on the left"
$Form.Controls.Add($ResultsTextBox)

# checkbox software1
$checkbox1 = new-object System.Windows.Forms.checkbox
$checkbox1.Location = new-object System.Drawing.Size(30,30)
$checkbox1.Size = new-object System.Drawing.Size(120,20)
$checkbox1.Text = "$software1"
if ($software1status -eq $null) {$checkbox1.Checked = $false} Else {$checkbox1.Checked = $true}
$Form.Controls.Add($checkbox1)

# checkbox software2
$checkbox2 = new-object System.Windows.Forms.checkbox
$checkbox2.Location = new-object System.Drawing.Size(30,50)
$checkbox2.Size = new-object System.Drawing.Size(120,20)
$checkbox2.Text = "$software2"
if ($software2status -eq $null) {$checkbox2.Checked = $false} Else {$checkbox2.Checked = $true}
$Form.Controls.Add($checkbox2)

# checkbox software3
$checkbox3 = new-object System.Windows.Forms.checkbox
$checkbox3.Location = new-object System.Drawing.Size(30,70)
$checkbox3.Size = new-object System.Drawing.Size(120,20)
$checkbox3.Text = "$software3"
if ($software3status -eq $null) {$checkbox3.Checked = $false} Else {$checkbox3.Checked = $true}
$Form.Controls.Add($checkbox3)

# ok button
$OKButton = new-object System.Windows.Forms.Button
$OKButton.Location = new-object System.Drawing.Size(130,400)
$OKButton.Size = new-object System.Drawing.Size(100,40)
$OKButton.Text = "OK"
$Form.Controls.Add($OKButton)

# close button
$CloseButton = new-object System.Windows.Forms.Button
$CloseButton.Location = new-object System.Drawing.Size(255,400)
$CloseButton.Size = new-object System.Drawing.Size(100,40)
$CloseButton.Text = "Close"
$CloseButton.Add_Click({$Form.Close()})
$Form.Controls.Add($CloseButton)


$OKButton.Add_Click{

if($checkbox1.Checked -and $software1status -eq $null) {Start-Process -FilePath "choco install wireguard -y" ; $ResultsTextBox.Text += "installing WireGuard"}
if($checkbox1.Checked -eq $false -and $software1status -ne $null ) {Start-Process MsiExec.exe "/x{23170F69-40C1-2702-1900-000001000000} /passive" ; $ResultsTextBox.Text += "removing 7-zip"}

if($checkbox2.Checked -and $software2status -eq $null) {Start-Process -FilePath $PSScriptRoot\software\npp.7.8.1.Installer.x64.exe /S ; $ResultsTextBox.Text += "installing notepad ++"}
if($checkbox2.Checked -eq $false -and $software2status -ne $null ) {Start-Process -FilePath "${env:ProgramFiles}\Notepad++\uninstall.exe" /S ; $ResultsTextBox.Text += "removing notepad ++"}

if($checkbox3.Checked -and $software3status -eq $null) {Start-Process -FilePath $PSScriptRoot\software\VSCodeSetup-x64-1.40.2.exe "/SILENT /NORESTART /MERGETASKS=!runcode" ; $ResultsTextBox.Text += "installing visual studio code"}
if($checkbox3.Checked -eq $false -and $software3status -ne $null ) {Start-Process -FilePath "${env:ProgramFiles}\Microsoft VS Code\unins000.exe" /SILENT ; $ResultsTextBox.Text += "removing visual studio code"}

}

# activate form
$Form.Add_Shown({$Form.Activate()})
[void] $Form.ShowDialog()