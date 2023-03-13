Set-ExecutionPolicy bypass -Force
$allGroups = Get-LocalGroup #Gets all groups 
$admins = Get-LocalGroupMember -Group 'Administrators' #Gets all members of the 'Administrators' Group
$currentDomainandUser = "$($env:UserDomain)\$($env:UserName)" #Gets current user Domain and Username

try{

    #34 **Passed Test**Needs testing at physical PC!**

    $netAdapterList = Get-NetAdapter | Format-List

    foreach($item in $netAdapterList){
        
        if($item.Name -like "*Bluetooth*" -or $item.Name -like "*Wifi*"){
        
            Disable-NetAdapter -Name $item.Name
        
        }
    
    }

    Write-Host -ForegroundColor Green `n"The Following Action has Successfully Completed: ....Bluetooth and WiFi have been disabled."`n


}catch{ 

    Throw "A fatal error has occurred.[ --Could not turn off either Boothtooth or Wifi Adapters.-- #34 ]" 
    
}

Start-Sleep -s 4

try{

    #35*Passed Test*

    New-Item -Path "HKCU:\Software\Policies\Microsoft\Windows" -Name "Explorer" -force
    New-ItemProperty -Path "HKCU:\Software\Policies\Microsoft\Windows\Explorer" -Name "DisableNotificationCenter" -PropertyType "DWord" -Value 1
    New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\PushNotifications" -Name "ToastEnabled" -PropertyType "DWord" -Value 0

    Write-Host -ForegroundColor Green `n"The Following Action has Successfully Completed: ....Notifications have been disabled."`n

}catch{ 

    Throw "A fatal error has occurred.[ --Could not disable notifications.-- #35 ]" 
    
}

Start-Sleep -s 4

try{

    #36*Passed Test*

    $pageFile = Get-WmiObject Win32_ComputerSystem -EnableAllPrivileges
    $pageFile.AutomaticManagedPagefile = $true #SET TO $FALSE TO DISABLE automatic swap file management
    $pageFile.put() | Out-Null

    Write-Host -ForegroundColor Green `n"The Following Action has Successfully Completed: ....Automatic Swap File Management has been Enabled"`n
    
}catch{

    Throw "Inadequate permissions to perform this action.[ --Unable to enable automatic swap file management.-- #36 ]" 
}

Start-Sleep -s 10

try{
    #37*Passed Test*

    $disableIndex = Get-WmiObject -Class Win32_Volume -Filter "DriveLetter='C:'"
    $disableIndex.IndexingEnabled = $false
    $disableIndex.Put()

    Write-Host -ForegroundColor Green `n"The Following Action has Successfully Completed: '....Allow Indexing Service to index this disk for fast file searching' has been turned off for all hard drives."`n
    
}catch{

    Throw "Inadequate permissions to perform this action.[ --Disable automatic indexing of hard drive letter C:.-- #37 ]"
  
}

Start-Sleep -s 10

try{

    #38*Passed Test*

    Write-Host -ForegroundColor Yellow `n"This step will be skipped in this script due to the rarity of its use."`n
    
}catch{ 

    Throw "A fatal error has occurred.[ --Unknown Error.-- #38 ]" 
    
}

Start-Sleep -s 4

    #Unpin-App Function: Function accepts $appname (name of application) argument to unpin from the Taskbar.

    function Unpin-App($appname) {

    ((New-Object -Com Shell.Application).NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').Items() |
        ?{$_.Name -eq $appname}).Verbs() | ?{$_.Name.replace('&','') -match 'Unpin from taskbar'} | %{$_.DoIt()}
}

try{

    #39*Passed Test*

    #Remove all shortcuts from the desktop

    $desktop = Get-ChildItem -path C:\Users\$env:UserName\Desktop\

    foreach($item in $desktop){

        if($item -notlike "*Recycling Bin*" -or $item -notlike "*Adobe Reader*"){Remove-Item C:\Users\$env:UserName\Desktop\$item}

        Write-Host -ForegroundColor Green `n"The Following Action has Successfully Completed: ....All Desktop items excluding Adobe Reader & Recycling Bin have been removed."`n

}
    #___________________________________________________________________________________________________________________________________
    
    #Unpin all items from the taskbar

    $toolbar = Get-ChildItem -Exclude ".lnk" "C:\Users\$env:UserName\AppData\Roaming\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar"

    foreach($item in $toolbar){
    
        if($item.Name -notlike "*File Explorer*" -or $item.Name -notlike "*Task View*"){
           
            Unpin-App($item.Name.Replace(".lnk",""))
            Unpin-App("Microsoft Store")
            Unpin-App("Mail")

        }
    
    }
        Write-Host -ForegroundColor Green `n"The Following Action has Successfully Completed: ....All Taskbar items excluding File Explorer & Task View have been removed."`n

    #___________________________________________________________________________________________________________________________________
    
    #Unpin all items from the start menu, **Cannot be done do to GPO**
<#
    (New-Object -Com Shell.Application).
    NameSpace('shell:::{4234d49b-0245-4df3-b780-3893943456e1}').
    Items() |
    %{ $_.Verbs() } |
    ?{$_.Name -match 'Un.*pin from Start'} |
    %{$_.DoIt()}

   
    Write-Host -ForegroundColor Green `n"The Following Action has Successfully Completed: ....All Start Menu items have been removed."`n
    #>

    Write-Host -ForegroundColor Yellow `n"Cannot unpin items from start menu due to GPO, will be addressed later."`n
}catch{ 

    Throw "A fatal error has occurred.[ --Either could not unpin items from Taskbar\Start Menu or delete items from the Desktop.-- #39 ]" 
    
}

Start-Sleep -s 4

try{

    #40

}catch{ 

    Throw "A fatal error has occurred.[ --.-- ]" 
    
}

try{

    #41*Passed Test*

    msfeedssync disable
    
    Write-Host -ForegroundColor Green `n"The Following Action has Successfully Completed: ....Msfeedssync.exe has been disabled."`n

}catch{ 

    Throw "A fatal error has occurred.[ --Could not disable Msfeedssync.exe.-- #41 ]" 
    
}

try{

    #42

    Write-Host -ForegroundColor Yellow `n"This step is not included in this program due to the rarity of its use."`n


}catch{ 

    Throw "A fatal error has occurred.[ --Unknown Error.-- #42 ]" 
    
}

try{

    #43

}catch{ 

    Throw "A fatal error has occurred.[ --.-- ]" 
    
}

try{

    #44/#45

    Write-Host -ForegroundColor Magenta `n"Please wait 24 hours for this PC to update.Then perform a Windows search for 'Check for updates'. Apply updates until computer says it's up to date... Restarting now..."`n 
    shutdown -r -t 10

}catch{ 

    Throw "A fatal error has occurred.[ --This PC could not be shutdown/restarted. Uknown Error.-- #44/#45 ]" 
    
}

Start-Sleep -s 4


#***___________________________Code below this point is for testing only... Disregard all code beyond this point...___________________________***#

<#

try{

    #46

}catch{ 

    Throw "A fatal error has occurred.[ --.-- ]" 
    
}

try{

    #47

}catch{ 

    Throw "A fatal error has occurred.[ --.-- ]" 
    
}

try{

    #48

}catch{ 

    Throw "A fatal error has occurred.[ --.-- ]" 
    
}

try{

    #49

}catch{ 

    Throw "A fatal error has occurred.[ --.-- ]" 
    
}

Stop



try{
    #10
    $Username = Read-Host -Prompt "Please enter your username."
    $Password = Read-Host -Prompt "Please enter your password." | ConvertTo-SecureString -AsPlainText -Force
    $CurrentPCName = Read-Host -Prompt "Please enter your computers CURRENT name."
    $NewPCName = Read-Host -Prompt "Please enter your computers NEW name."
    $Domain = Read-Host -Prompt "Please enter your required domain."
    $Creds = New-Object System.Management.Automation.PSCredential($Username ,$Password)


    Rename-Computer -NewName $NewPCName -ComputerName $CurrentPCName -Restart -DomainCredential $Creds
    
         
}catch{
    
    Throw "A fatal error has occurred.[ --Invalid Credentials or Computer Name/Domain.-- ]"
}

try{
    #11
    Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -name "fDenyTSConnections" -value 0
    
         
}catch{

    Throw "Error... Command Failed."
}

Write-host "TEST"

#if((Get-ScheduledTask -TaskName -like "o")){Write-Host Get-ScheduledTask -TaskName}

#>