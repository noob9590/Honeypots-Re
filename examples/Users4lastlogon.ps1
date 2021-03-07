Param(
[Parameter(Mandatory=$true)]
[String[]] $Users
)
$List = [System.Collections.Generic.List[System.Object]]::new()
For ($i=0; $i -lt $Users.Length; $i++) {

Try {
    $t = Get-ADUser -Identity $Users[$i]
    $List.Add($(Get-Credential -Message "Enter $($Users[$i]) password" -UserName $Users[$i]))
}


Catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException] {
    Write-Host "There is no such User: $($Users[$i]) in CHIP domain" `
    `n"Would you like to add a domain user?"

    $Answer = Read-Host [Y]Yes, [N]No

    if($Answer -eq 'y' -or $Answer -eq 'yes' ) {
        $Users[$i] = Read-Host New username
        $i-- 
    }
    else {
        $Users = $Users | Where-Object {$_ -ne $Users[$i]}
        $i--
    }
}

}


Try {
    foreach($Element in $List) {



        Start-Job -ScriptBlock { 
            $Domain = $env:USERDOMAIN
            Add-Type -AssemblyName System.DirectoryServices.AccountManagement
            $ct = [System.DirectoryServices.AccountManagement.ContextType]::Domain
            $pc = New-Object System.DirectoryServices.AccountManagement.PrincipalContext $ct,$Domain
            while($true) {
                $rand = Get-Random -Minimum 6 -Maximum 108
                Start-Sleep -Seconds $rand
                $pc.ValidateCredentials($Element)
            }
            }
            Get-Job | Wait-Job
    }
}

Finally {
    Get-Job | Remove-Job -Force
}

