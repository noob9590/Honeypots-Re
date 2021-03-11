
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName PresentationCore,PresentationFramework

$HoneypotsForm = New-Object System.Windows.Forms.Form
$HoneypotsForm.Text = "Honeypots Options"
$HoneypotsForm.Size = New-Object System.Drawing.Size(400,400)
$HoneypotsForm.StartPosition = 'CenterScreen'
$HoneypotsForm.Topmost = $true

$SetKerberostedUser = New-Object System.Windows.Forms.Button
$SetKerberostedUser.Location = New-Object System.Drawing.Point(120, 250)
$SetKerberostedUser.Size = New-Object System.Drawing.Size(137, 35)
$SetKerberostedUser.TabIndex = 2
$SetKerberostedUser.Text = "Set Kerberosting Attack"
$SetKerberostedUser.UseVisualStyleBackColor = $true
$SetKerberostedUser.Add_Click({

    $HoneypotsForm.Hide()

    $KerberostingForm = New-Object System.Windows.Forms.Form
    $KerberostingForm.Text = "Kerberosting"
    $KerberostingForm.Size = New-Object System.Drawing.Size(400, 400)
    $KerberostingForm.StartPosition = 'CenterScreen'

    $ChooseADUserLabel = New-Object System.Windows.Forms.Label 
    $ChooseADUserLabel.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $ChooseADUserLabel.Font = New-Object System.Drawing.Font("Calibri Light", 12.0, ([System.Drawing.FontStyle]([System.Drawing.FontStyle]::Italic -bor [System.Drawing.FontStyle]::Underline)), [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
    $ChooseADUserLabel.Location = New-Object System.Drawing.Point(95, 50)
    $ChooseADUserLabel.Size = New-Object System.Drawing.Size(201, 23)
    $ChooseADUserLabel.Text = "Active Directory Users"
    $ChooseADUserLabel.TextAlign = [System.Drawing.ContentAlignment]::TopCenter

    $ADUsersListBox = New-Object System.Windows.Forms.ListBox
    $ADUsersListBox.Location = New-Object System.Drawing.Point(95, 100)
    $ADUsersListBox.Size = New-Object System.Drawing.Size(201, 150)
    $ADUsersListBox.Font = New-Object System.Drawing.Font("Calibri Light Font",11)

    $Users = Get-ADUser -Filter * | select -Property samaccountname 

    foreach($User in $Users) {
        if($User.samaccountname -ne 'krbtgt' -and $User.samaccountname -ne 'Guest') {
            [void] $ADUsersListBox.Items.Add($User.samaccountname)
        }
    }




    $NewUserButton = New-Object System.Windows.Forms.Button
    $NewUserButton.Size = New-Object System.Drawing.Size(75, 23)
    $NewUserButton.Text = "New User"
    $NewUserButton.Location = New-Object System.Drawing.Point(165, 270)
    $NewUserButton.Add_Click({

        $KerberostingForm.Hide()

        $NewUserForm = New-Object System.Windows.Forms.Form
        $NewUserForm.ClientSize = New-Object System.Drawing.Size(277, 393)
        $NewUserForm.Text = "New User"
        $NewUserForm.StartPosition = 'CenterScreen'
        $NewUserForm.Topmost = $true

        $KrbUserPathComboBox = New-Object System.Windows.Forms.ComboBox
        $KrbUserPathComboBox.FormattingEnabled = $true
        $KrbUserPathComboBox.Location = New-Object System.Drawing.Point(103, 163)
        $KrbUserPathComboBox.SelectedIndex = -1
        $KrbUserPathComboBox.Size = New-Object System.Drawing.Size(137, 21)
        $KrbUserPathComboBox.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
        
        $KrbUserPathComboBox.Text = ""

        $OUs = Get-ADOrganizationalUnit -Filter * | select -Property DistinguishedName
        foreach($OU in $OUs) {
        
        $KrbUserPathComboBox.Items.Add($OU.DistinguishedName)

        }

        $Largest = $KrbUserPathComboBox.Items | %{ $_.length } | sort -Descending | select -First 1
        $Maxlength = $Largest*6
        $KrbUserPathComboBox.DropDownWidth =$Maxlength

        $KrbLastnameLabel = New-Object System.Windows.Forms.Label
        $KrbLastnameLabel.Location = New-Object System.Drawing.Point(29, 248)
        $KrbLastnameLabel.Size = New-Object System.Drawing.Size(68, 23)
        $KrbLastnameLabel.Text = "Last Name"
        $KrbLastnameLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter

        $KrbLastnameTextBox = New-Object System.Windows.Forms.TextBox
        $KrbLastnameTextBox.Location = New-Object System.Drawing.Point(103, 250)
        $KrbLastnameTextBox.Size = New-Object System.Drawing.Size(137, 20)
        $KrbLastnameTextBox.Text = ""

        $KrbNameLabel = New-Object System.Windows.Forms.Label
        $KrbNameLabel.Location = New-Object System.Drawing.Point(29, 204)
        $KrbNameLabel.Size = New-Object System.Drawing.Size(68, 23)
        $KrbNameLabel.Text = "Name"
        $KrbNameLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter

        $KrbNameTextBox = New-Object System.Windows.Forms.TextBox
        $KrbNameTextBox.Location = New-Object System.Drawing.Point(103, 206)
        $KrbNameTextBox.Size = New-Object System.Drawing.Size(137, 20)
        $KrbNameTextBox.Text = ""

        $UserPAth = New-Object System.Windows.Forms.ComboBox
        $UserPAth.FormattingEnabled = $true
        $UserPAth.Location = New-Object System.Drawing.Point(103, 163)
        $UserPAth.SelectedIndex = -1
        $UserPAth.Size = New-Object System.Drawing.Size(137, 21)
        $UserPAth.Text = ""

        $KrbUserPathLabel = New-Object System.Windows.Forms.Label
        $KrbUserPathLabel.Location = New-Object System.Drawing.Point(29, 161)
        $KrbUserPathLabel.Size = New-Object System.Drawing.Size(68, 23)
        $KrbUserPathLabel.Text = "User Path"
        $KrbUserPathLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter

        $KrbUserPassLabel = New-Object System.Windows.Forms.Label
        $KrbUserPassLabel.Location = New-Object System.Drawing.Point(29, 116)
        $KrbUserPassLabel.Size = New-Object System.Drawing.Size(68, 23)
        $KrbUserPassLabel.Text = "Password"
        $KrbUserPassLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter

        $KrbUsernameLabel = New-Object System.Windows.Forms.Label
        $KrbUsernameLabel.Location = New-Object System.Drawing.Point(29, 74)
        $KrbUsernameLabel.Size = New-Object System.Drawing.Size(68, 23)
        $KrbUsernameLabel.Text = "Username"
        $KrbUsernameLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter

        $KrbUsernameTextBox = New-Object System.Windows.Forms.TextBox
        $KrbUsernameTextBox.Location = New-Object System.Drawing.Point(103, 76)
        $KrbUsernameTextBox.Size = New-Object System.Drawing.Size(137, 20)
        $KrbUsernameTextBox.Text = ""

        $KrbPassTextBox = New-Object System.Windows.Forms.TextBox
        $KrbPassTextBox.Location = New-Object System.Drawing.Point(103, 119)
        $KrbPassTextBox.PasswordChar = '*'
        $KrbPassTextBox.Size = New-Object System.Drawing.Size(137, 20)
        $KrbPassTextBox.Text = ""

        $NewUserLabel = New-Object System.Windows.Forms.Label
        $NewUserLabel.Font = New-Object System.Drawing.Font("Microsoft Sans Serif", 9.75, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
        $NewUserLabel.Location = New-Object System.Drawing.Point(57, 31)
        $NewUserLabel.Size = New-Object System.Drawing.Size(183, 29)
        $NewUserLabel.Text = "New User"
        $NewUserLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter

        $NewUserOkButton = New-Object System.Windows.Forms.Button
        $NewUserOkButton.Location = New-Object System.Drawing.Point(103, 339)
        $NewUserOkButton.Size = New-Object System.Drawing.Size(75, 23)
        $NewUserOkButton.Text = "OK"
        $NewUserOkButton.UseVisualStyleBackColor = $true
        $NewUserOkButton.Add_Click({

            
            $NewUserForm.Hide()
            $Password = $KrbPassTextBox.Text | ConvertTo-SecureString -AsPlainText -Force
            New-ADUser -AccountPassword $Password -Name $KrbNameTextBox.Text -Path $KrbUserPathComboBox.SelectedItem -SamAccountName $KrbUsernameTextBox.Text -Surname $KrbLastnameTextBox.Text -ServicePrincipalNames $KrbSPNTextBox.Text -Enabled 1
            Add-ADGroupMember -Identity "Domain Admins" -Members $KrbUsernameTextBox.Text
            $HoneypotsForm.Show()
        
        })

        $KrbSPNTextBox = New-Object System.Windows.Forms.TextBox
        $KrbSPNTextBox.Location = New-Object System.Drawing.Point(103, 291)
        $KrbSPNTextBox.Size = New-Object System.Drawing.Size(137, 20)
        $KrbSPNTextBox.Text = ""

        $KrbSPNLabel = New-Object System.Windows.Forms.Label
        $KrbSPNLabel.Location = New-Object System.Drawing.Point(29, 288)
        $KrbSPNLabel.Size = New-Object System.Drawing.Size(68, 23)
        $KrbSPNLabel.Text = "SPN"
        $KrbSPNLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter

        $NewUserForm.Controls.Add($KrbUserPathComboBox)
        $NewUserForm.Controls.Add($KrbLastnameLabel)
        $NewUserForm.Controls.Add($KrbLastnameTextBox)
        $NewUserForm.Controls.Add($KrbNameLabel)
        $NewUserForm.Controls.Add($KrbNameTextBox)
        $NewUserForm.Controls.Add($KrbUserPathLabel)
        $NewUserForm.Controls.Add($NewUserOkButton)
        $NewUserForm.Controls.Add($NewUserLabel)
        $NewUserForm.Controls.Add($KrbUserPassLabel)
        $NewUserForm.Controls.Add($KrbUsernameLabel)
        $NewUserForm.Controls.Add($KrbUsernameTextBox)
        $NewUserForm.Controls.Add($KrbPassTextBox)
        $NewUserForm.Controls.Add($KrbSPNTextBox)
        $NewUserForm.Controls.Add($KrbSPNLabel)
        $NewUserForm.ShowDialog()
    })




$KerberostingForm.Controls.Add($NewUserButton)
$KerberostingForm.Controls.Add($ADUsersListBox)
$KerberostingForm.Controls.Add($ChooseADUserLabel)
$KerberostingForm.ShowDialog()


})

$InjectUserToLSASS = New-Object System.Windows.Forms.Button
$InjectUserToLSASS.Location = New-Object System.Drawing.Point(120, 150)
$InjectUserToLSASS.Size = New-Object System.Drawing.Size(137, 35)
$InjectUserToLSASS.TabIndex = 1
$InjectUserToLSASS.Text = "Inject User To LSASS"
$InjectUserToLSASS.AutoSize = $true
$InjectUserToLSASS.UseVisualStyleBackColor = $true
$InjectUserToLSASS.Add_Click({

    $HoneypotsForm.Hide()
    $ADComputersListBox.SelectionMode = 'MultiExtended'

    $UserSessionCreds = Get-Credential -Message "Eneter credintials for the user's session"

    $UserFakePassForm = New-Object System.Windows.Forms.Form
    $UserFakePassForm.Text = "Fake Password"
    $UserFakePassForm.Size = New-Object System.Drawing.Size(290, 290)
    $UserFakePassForm.StartPosition = 'CenterScreen'
    $UserFakePassForm.Topmost = $true

    $FakeOKButton = New-Object System.Windows.Forms.Button
    $FakeOKButton.Location = New-Object System.Drawing.Point(100, 196)
    $FakeOKButton.Size = New-Object System.Drawing.Size(75, 23)
    $FakeOKButton.Text = "OK"
    $FakeOKButton.UseVisualStyleBackColor = $true
    $FakeOKButton.Add_Click({

        [string]$FakeUser = $UserTextBox.Text
        [string]$FakePass = $PassTextBox.Text

        foreach($Computer in $SelectedComputers) {

        $Session = New-PSSession -ComputerName $Computer -Credential $UserSessionCreds -Authentication Negotiate
            Invoke-Command -Session $Session -ScriptBlock{ param(
            		[Parameter(Mandatory = $True)]
		            [string]$FakeUser,
		            [Parameter(Mandatory = $True)]
		            [string]$FakePass
                    )
                function Invoke-Runas {

<#
.SYNOPSIS
    Overview:
    
    Functionally equivalent to Windows "runas.exe", using Advapi32::CreateProcessWithLogonW (also used
	by runas under the hood).
    
    Parameters:
     -User              Specifiy username.
     
     -Password          Specify password.
     
     -Domain            Specify domain. Defaults to localhost if not specified.
     
     -LogonType         dwLogonFlags:
                          0x00000001 --> LOGON_WITH_PROFILE
                                           Log on, then load the user profile in the HKEY_USERS registry
                                           key. The function returns after the profile is loaded.
                                           
                          0x00000002 --> LOGON_NETCREDENTIALS_ONLY (= /netonly)
                                           Log on, but use the specified credentials on the network only.
                                           The new process uses the same token as the caller, but the
                                           system creates a new logon session within LSA, and the process
                                           uses the specified credentials as the default credentials.
     
     -Binary            Full path of the module to be executed.
                       
     -Args              Arguments to pass to the module, e.g. "/c calc.exe". Defaults
                        to $null if not specified.
                       
.DESCRIPTION
	Author: Ruben Boonen (@FuzzySec)
	License: BSD 3-Clause
	Required Dependencies: None
	Optional Dependencies: None
.EXAMPLE
	Start cmd with a local account
	C:\PS> Invoke-Runas -User SomeAccount -Password SomePass -Binary C:\Windows\System32\cmd.exe -LogonType 0x1
	
.EXAMPLE
	Start cmd with remote credentials. Equivalent to "/netonly" in runas.
	C:\PS> Invoke-Runas -User SomeAccount -Password SomePass -Domain SomeDomain -Binary C:\Windows\System32\cmd.exe -LogonType 0x2
#>

	param (
		[Parameter(Mandatory = $True)]
		[string]$User,
		[Parameter(Mandatory = $True)]
		[string]$Password,
		[Parameter(Mandatory = $False)]
		[string]$Domain=".",
		[Parameter(Mandatory = $True)]
		[string]$Binary,
		[Parameter(Mandatory = $False)]
		[string]$Args=$null,
		[Parameter(Mandatory = $True)]
		[int][ValidateSet(1,2)]
		[string]$LogonType
	)  

	Add-Type -TypeDefinition @"
	using System;
	using System.Diagnostics;
	using System.Runtime.InteropServices;
	using System.Security.Principal;
	
	[StructLayout(LayoutKind.Sequential)]
	public struct PROCESS_INFORMATION
	{
		public IntPtr hProcess;
		public IntPtr hThread;
		public uint dwProcessId;
		public uint dwThreadId;
	}
	
	[StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
	public struct STARTUPINFO
	{
		public uint cb;
		public string lpReserved;
		public string lpDesktop;
		public string lpTitle;
		public uint dwX;
		public uint dwY;
		public uint dwXSize;
		public uint dwYSize;
		public uint dwXCountChars;
		public uint dwYCountChars;
		public uint dwFillAttribute;
		public uint dwFlags;
		public short wShowWindow;
		public short cbReserved2;
		public IntPtr lpReserved2;
		public IntPtr hStdInput;
		public IntPtr hStdOutput;
		public IntPtr hStdError;
	}
	
	public static class Advapi32
	{
		[DllImport("advapi32.dll", SetLastError=true, CharSet=CharSet.Unicode)]
		public static extern bool CreateProcessWithLogonW(
			String userName,
			String domain,
			String password,
			int logonFlags,
			String applicationName,
			String commandLine,
			int creationFlags,
			int environment,
			String currentDirectory,
			ref  STARTUPINFO startupInfo,
			out PROCESS_INFORMATION processInformation);
	}
	
	public static class Kernel32
	{
		[DllImport("kernel32.dll")]
		public static extern uint GetLastError();
	}
"@
	
	# StartupInfo Struct
	$StartupInfo = New-Object STARTUPINFO
	$StartupInfo.dwFlags = 0x00000001
	$StartupInfo.wShowWindow = 0x0001
	$StartupInfo.cb = [System.Runtime.InteropServices.Marshal]::SizeOf($StartupInfo)
	
	# ProcessInfo Struct
	$ProcessInfo = New-Object PROCESS_INFORMATION
	
	# CreateProcessWithLogonW --> lpCurrentDirectory
	$GetCurrentPath = (Get-Item -Path ".\" -Verbose).FullName
	
	echo "`n[>] Calling Advapi32::CreateProcessWithLogonW"
	$CallResult = [Advapi32]::CreateProcessWithLogonW(
		$User, $Domain, $Password, $LogonType, $Binary,
		$Args, 0x04000000, $null, $GetCurrentPath,
		[ref]$StartupInfo, [ref]$ProcessInfo)
	
	if (!$CallResult) {
		echo "`n[!] Mmm, something went wrong! GetLastError returned:"
		echo "==> $((New-Object System.ComponentModel.Win32Exception([int][Kernel32]::GetLastError())).Message)`n"
	} else {
		echo "`n[+] Success, process details:"
		Get-Process -Id $ProcessInfo.dwProcessId
	}
}
                Invoke-Runas -User $FakeUser -Password $FakePass -Domain $env:USERDOMAIN -Binary C:\Windows\System32\cmd.exe -LogonType 0x2
            } -ArgumentList ($FakeUser, $FakePass)
        }
        $UserFakePassForm.Hide()
        $HoneypotsForm.Show()
    })

    $FakeUserPassLabel = New-Object System.Windows.Forms.Label
    $FakeUserPassLabel.Font = New-Object System.Drawing.Font("Microsoft Sans Serif", 9.0, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
    $FakeUserPassLabel.Location = New-Object System.Drawing.Point(52, 36)
    $FakeUserPassLabel.Size = New-Object System.Drawing.Size(183, 29)
    $FakeUserPassLabel.Text = "Fake Username and Password"
    $FakeUserPassLabel.TextAlign = [System.Drawing.ContentAlignment]::TopCenter

    $PassLabel = New-Object System.Windows.Forms.Label
    $PassLabel.Location = New-Object System.Drawing.Point(29, 141)
    $PassLabel.Size = New-Object System.Drawing.Size(83, 23)
    $PassLabel.Text = "Password"
    $PassLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter

    $UserLabel = New-Object System.Windows.Forms.Label
    $UserLabel.Location = New-Object System.Drawing.Point(29, 86)
    $UserLabel.Size = New-Object System.Drawing.Size(83, 23)
    $UserLabel.Text = "Username"
    $UserLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter

    $UserTextBox = New-Object System.Windows.Forms.TextBox
    $UserTextBox.Location = New-Object System.Drawing.Point(118, 88)
    $UserTextBox.Size = New-Object System.Drawing.Size(100, 20)
    $UserTextBox.Text = ""

    $PassTextBox = New-Object System.Windows.Forms.TextBox
    $PassTextBox.Location = New-Object System.Drawing.Point(118, 143)
    $PassTextBox.PasswordChar = '*'
    $PassTextBox.Size = New-Object System.Drawing.Size(100, 20)
    $PassTextBox.Text = ""

    $UserFakePassForm.Controls.Add($FakeOKButton)
    $UserFakePassForm.Controls.Add($FakeUserPassLabel)
    $UserFakePassForm.Controls.Add($PassLabel)
    $UserFakePassForm.Controls.Add($UserLabel)
    $UserFakePassForm.Controls.Add($UserTextBox)
    $UserFakePassForm.Controls.Add($PassTextBox)

    $OkButton.TabIndex = 0

    $LsassForm.Controls.Add($OkButton)
    $LsassForm.ShowDialog()

})



$LsassForm = New-Object System.Windows.Forms.Form
$LsassForm.Text = "Lsass Honeypot"
$LsassForm.Size = New-Object System.Drawing.Size(400,400)
$LsassForm.StartPosition = 'CenterScreen'
$LsassForm.Topmost = $true

$OkButton = New-Object System.Windows.Forms.Button
$OkButton.Size = New-Object System.Drawing.Size(75, 23)
$OkButton.Text = "OK"
$OkButton.Location = New-Object System.Drawing.Point(165, 270)
$OkButton.Add_Click({

    $LsassForm.Hide()
    if($OkButton.TabIndex -eq 0) {
        $UserFakePassForm.ShowDialog()
    }
    else {
        $ServiceForm.ShowDialog()
    }
})

$ChooseADUserComputer = New-Object System.Windows.Forms.Label 
$ChooseADUserComputer.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$ChooseADUserComputer.Font = New-Object System.Drawing.Font("Calibri Light", 12.0, ([System.Drawing.FontStyle]([System.Drawing.FontStyle]::Italic -bor [System.Drawing.FontStyle]::Underline)), [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$ChooseADUserComputer.Location = New-Object System.Drawing.Point(95, 50)
$ChooseADUserComputer.Size = New-Object System.Drawing.Size(201, 23)
$ChooseADUserComputer.Text = "Active Directory Computers"
$ChooseADUserComputer.TextAlign = [System.Drawing.ContentAlignment]::TopCenter

$ADComputersListBox = New-Object System.Windows.Forms.ListBox
$ADComputersListBox.Location = New-Object System.Drawing.Point(95, 100)
$ADComputersListBox.Size = New-Object System.Drawing.Size(201, 150)
$ADComputersListBox.Font = New-Object System.Drawing.Font("Calibri Light Font",11)
$SelectedComputers = $ADComputersListBox.SelectedItems

$Computers = Get-ADComputer -Filter * | select -Property Name
foreach($Computer in $Computers) {

    $ADComputersListBox.Items.Add($Computer.Name)

}

$LsassForm.Controls.Add($ADComputersListBox)
$LsassForm.Controls.Add($ChooseADUserComputer)


$ServiceForm = New-Object System.Windows.Forms.Form
$ServiceForm.Size = New-Object System.Drawing.Size(290, 290)
$ServiceForm.Text = "Service Arguments"
$ServiceForm.Topmost = $true
$ServiceForm.StartPosition = 'CenterScreen'

$ServiceDetailsLabel = New-Object System.Windows.Forms.Label
$ServiceDetailsLabel.Font = New-Object System.Drawing.Font("Microsoft Sans Serif", 9.75, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Point, ([System.Byte](0)))
$ServiceDetailsLabel.Location = New-Object System.Drawing.Point(51, 36)
$ServiceDetailsLabel.Size = New-Object System.Drawing.Size(183, 29)
$ServiceDetailsLabel.Text = "Service Details"
$ServiceDetailsLabel.TextAlign = [System.Drawing.ContentAlignment]::TopCenter

$BinaryPathLabel = New-Object System.Windows.Forms.Label
$BinaryPathLabel.Location = New-Object System.Drawing.Point(29, 141)
$BinaryPathLabel.Size = New-Object System.Drawing.Size(68, 23)
$BinaryPathLabel.Text = "Binary Path"
$BinaryPathLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter

$NameLabel = New-Object System.Windows.Forms.Label
$NameLabel.Location = New-Object System.Drawing.Point(29, 86)
$NameLabel.Size = New-Object System.Drawing.Size(68, 23)
$NameLabel.Text = "Name"
$NameLabel.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter

$NameTextBox = New-Object System.Windows.Forms.TextBox
$NameTextBox.Location = New-Object System.Drawing.Point(103, 88)
$NameTextBox.Size = New-Object System.Drawing.Size(100, 20)
$NameTextBox.Text = ""

$PathTextBox = New-Object System.Windows.Forms.TextBox
$PathTextBox.Location = New-Object System.Drawing.Point(103, 143)
$PathTextBox.Size = New-Object System.Drawing.Size(100, 20)
$PathTextBox.TabIndex = 0
$PathTextBox.Text = ""

$ServiceOKButton = New-Object System.Windows.Forms.Button
$ServiceOKButton.Location = New-Object System.Drawing.Point(103, 198)
$ServiceOKButton.Size = New-Object System.Drawing.Size(75, 23)
$ServiceOKButton.Text = "OK"
$ServiceOKButton.UseVisualStyleBackColor = $true
$ServiceOKButton.Add_Click({


    $Path = $PathTextBox.Text
    $Name = $NameTextBox.Text
    $ServiceForm.Hide()
    $UserCreds = Get-Credential -Message "Enter credentials for PSSession"
    $FakeLSACres = Get-Credential -Message "Enter fake password for an AD user" -UserName $env:USERDOMAIN'\'
    $Session = New-PSSession -ComputerName $ADComputersListBox.SelectedItem -Credential $UserCreds -Authentication Negotiate
                Invoke-Command -Session $Session -ScriptBlock{ param(
            		[Parameter(Mandatory = $True)]
		            [string]$Path,
		            [Parameter(Mandatory = $True)]
		            [string]$Name,
		            [Parameter(Mandatory = $True)]
		            [PSCredential]$FakeLSACres
                    )
                New-Service -Name $Name -BinaryPathName $Path -Credential $FakeLSACres
                Set-Service $Name -StartupType Disabled
            } -ArgumentList ($Path, $Name, $FakeLSACres)
    Remove-PSSession -Session $Session
    $HoneypotsForm.Show()

})

$ServiceForm.Controls.Add($ServiceDetailsLabel)
$ServiceForm.Controls.Add($BinaryPathLabel)
$ServiceForm.Controls.Add($NameLabel)
$ServiceForm.Controls.Add($NameTextBox)
$ServiceForm.Controls.Add($PathTextBox)
$ServiceForm.Controls.Add($ServiceOKButton)

$InjectUserToLSASecretsButton = New-Object System.Windows.Forms.Button
$InjectUserToLSASecretsButton.Location = New-Object System.Drawing.Point(120, 50)
$InjectUserToLSASecretsButton.Size = New-Object System.Drawing.Size(137, 35)
$InjectUserToLSASecretsButton.Text = "LSASecrets User"
$InjectUserToLSASecretsButton.UseVisualStyleBackColor = $true
$InjectUserToLSASecretsButton.Add_Click({
    
    $OkButton.TabIndex = 1
    $HoneypotsForm.Hide()
    $ADComputersListBox.SelectionMode = 'One'
    $LsassForm.Controls.Add($OkButton)
    $LsassForm.Text = "LSASecrets Honeypot"
    $LsassForm.ShowDialog()

})



$HoneypotsForm.Controls.Add($InjectUserToLSASecretsButton)
$HoneypotsForm.Controls.Add($InjectUserToLSASS)
$HoneypotsForm.Controls.Add($SetKerberostedUser)

$result = $HoneypotsForm.ShowDialog();





