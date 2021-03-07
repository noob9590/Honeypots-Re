Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName PresentationCore,PresentationFramework

$List = [System.Collections.Generic.List[System.Object]]::new()


 $f = {

    $form2 = New-Object Windows.Forms.Form
    $form2.StartPosition = 'CenterScreen'
    $form.Hide()

    $ComboBox1 = New-Object System.Windows.Forms.ComboBox
    $ComboBox1.AccessibleDescription = ""
    $ComboBox1.FormattingEnabled = $true
    $ComboBox1.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
    $ComboBox1.Location = New-Object System.Drawing.Point(157, 34)
    $ComboBox1.Size = New-Object System.Drawing.Size(92, 21)
    $ComboBox1.TabIndex = 5
    $ComboBox1.Text = ""
    $ComboBox1.ForeColor = [System.Drawing.SystemColors]::HotTrack
    $ComboBox1.Items.AddRange([System.Object[]](@("One Hour", "Three Hours", "Five Hours")))
    $ComboBox1.SelectedIndex = 0
    
    $ComboLabel = New-Object System.Windows.Forms.Label
    $ComboLabel.Location = New-Object System.Drawing.Point(7, 34)
    $ComboLabel.Size = New-Object System.Drawing.Size(180, 23)
    $ComboLabel.TabIndex = 7
    $ComboLabel.Text = "Time Interval for Login"

  
    $password = New-Object Windows.Forms.MaskedTextBox
    $password.PasswordChar = '*'
    $password.Top  = 120
    $password.Left = 90

    $PassLabel = New-Object System.Windows.Forms.Label
    $PassLabel.Location = New-Object System.Drawing.Point(15, 122)
    $PassLabel.Size = New-Object System.Drawing.Size(100, 23)
    $PassLabel.TabIndex = 0
    $PassLabel.Text = "Password"

    $UserLabel = New-Object System.Windows.Forms.Label
    $UserLabel.Location = New-Object System.Drawing.Point(15, 82)
    $UserLabel.Size = New-Object System.Drawing.Size(100, 23)
    $UserLabel.TabIndex = 1
    $UserLabel.Text = "Username"

    $TextBoxUsername = New-Object System.Windows.Forms.TextBox
    $TextBoxUsername.Location = New-Object System.Drawing.Point(90, 80)
    $TextBoxUsername.Size = New-Object System.Drawing.Size(100, 23)
    $TextBoxUsername.TabIndex = 3
    $TextBoxUsername.ReadOnly = $true
    $TextBoxUsername.Text = $listBox.SelectedItem

    $NewPassword = New-Object Windows.Forms.MaskedTextBox
    $NewPassword.PasswordChar = '*'
    $NewPassword.Top  = 187
    $NewPassword.Left = 130
    $NewPassword.Enabled = $false

    $CheckBoxNewPass = New-Object System.Windows.Forms.CheckBox
    $CheckBoxNewPass.Location = New-Object System.Drawing.Point(45, 154)
    $CheckBoxNewPass.Size = New-Object System.Drawing.Size(250, 24)
    $CheckBoxNewPass.TabIndex = 4
    $CheckBoxNewPass.Text = "Change Password"
    $CheckBoxNewPass_OnClick = {
        
        $NewPassword.Enabled = $CheckBoxNewPass.Checked
    }
    $CheckBoxNewPass.Add_Click($CheckBoxNewPass_OnClick)


    $NewPassLabel = New-Object System.Windows.Forms.Label
    $NewPassLabel.Location = New-Object System.Drawing.Point(25, 187)
    $NewPassLabel.Size = New-Object System.Drawing.Size(200, 23)
    $NewPassLabel.TabIndex = 5
    $NewPassLabel.Text = "New Password"


    $OKButton = New-Object System.Windows.Forms.Button
    $OKButton.Location = New-Object System.Drawing.Point(65,220)
    $OKButton.Size = New-Object System.Drawing.Size(75,23)
    $OKButton.Text = 'OK'
    $OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK


    $CancelButton = New-Object System.Windows.Forms.Button
    $CancelButton.Location = New-Object System.Drawing.Point(150,220)
    $CancelButton.Size = New-Object System.Drawing.Size(75,23)
    $CancelButton.Text = 'Cancel'
    $CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel


    $form2.Controls.Add($TextBoxUsername)
    $form2.Controls.Add($password)
    $form2.Controls.Add($PassLabel)
    $form2.Controls.Add($UserLabel)
    $form2.Controls.Add($CheckBoxNewPass)
    $form2.Controls.Add($NewPassword)
    $form2.Controls.Add($NewPassLabel)
    $form2.Controls.Add($OKButton)
    $form2.AcceptButton = $OKButton
    $form2.CancelButton = $CancelButton
    $form2.Controls.Add($CancelButton)
    $form2.Controls.Add($ComboBox1)
    $form2.Controls.Add($ComboLabel)

    $Res = $form2.ShowDialog()
 

    if($Res -eq [System.Windows.Forms.DialogResult]::OK) {

        $Username = $TextBoxUsername.Text
        $UserPass = ConvertTo-SecureString -AsPlainText $password.Text -Force

        if($CheckBoxNewPass.Checked -eq $true -and $NewPassword.Text.Length -gt 7) {

            Try {
                Set-ADAccountPassword -Re -Identity $TextBoxUsername.Text -OldPassword (ConvertTo-SecureString -AsPlainText $password.Text -Force) -NewPassword (ConvertTo-SecureString -AsPlainText $NewPassword.Text -Force)
                [System.Windows.MessageBox]::Show("$UserPass Password Has Been Changed")
                $UserPass = ConvertTo-SecureString -AsPlainText $NewPassword.Text -Force
            }
            Catch {
                
                [System.Windows.MessageBox]::Show("$UserPass Password Has not changed")
            }
        }

        $list.Add(@($Username, $UserPass, $ComboBox1.SelectedItem))
        
        
    }
    $form.Show()
}

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Data Entry Form'
$form.Size = New-Object System.Drawing.Size(400,300)
$form.StartPosition = 'CenterScreen'

$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Point(125,200)
$OKButton.Size = New-Object System.Drawing.Size(75,23)
$OKButton.Text = 'OK'
$OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $OKButton
$form.Controls.Add($OKButton)

$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Point(200,200)
$CancelButton.Size = New-Object System.Drawing.Size(75,23)
$CancelButton.Text = 'Cancel'
$CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $CancelButton
$form.Controls.Add($CancelButton)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(280,20)
$label.Text = 'Please make a selection from the list:'
$form.Controls.Add($label)


$listBox = New-Object System.Windows.Forms.Listbox
$Configuration = $listbox.add_MouseDoubleClick($f)
$listBox.Location = New-Object System.Drawing.Point(10,40)
$listBox.Size = New-Object System.Drawing.Size(250,150)
$listBox.Font = New-Object System.Drawing.Font("Arial Font",12,[System.Drawing.FontStyle]::Regular)

$listBox.SelectionMode = 'MultiExtended'

$Users = Get-ADUser -Filter * | select -Property samaccountname | Where-Object {$_.samaccountname -ne 'Guest' -and $_.samaccountname -ne 'krbtgt'}


For ($User = 0; $User -lt $Users.samaccountname.Count; $User++) {

    [void] $listBox.Items.Add($Users.samaccountname[$User])

}

$form.Controls.Add($listBox)
$form.Topmost = $true
$result = $form.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
    
    foreach($node in $list) {

            Start-Job -ScriptBlock {
                $rand 
                $Domain = $env:USERDOMAIN
                Add-Type -AssemblyName System.DirectoryServices.AccountManagement
                $ct = [System.DirectoryServices.AccountManagement.ContextType]::Domain
                $pc = New-Object System.DirectoryServices.AccountManagement.PrincipalContext $ct,$Domain
                if($node[2] -eq 'One Hour') { $rand = Get-Random -Minimum 3000 -Maximum 3600 }
                elseif($node[2] -eq 'Three Hours') { $rand = Get-Random -Minimum 9000 -Maximum 10800 }
                else { $rand = Get-Random -Minimum 15000 -Maximum 18000 }
                while($true) {
                    Start-Sleep -Seconds $rand
                    $pc.ValidateCredentials($node[0],$node[1])
                }
            }
    }

}



