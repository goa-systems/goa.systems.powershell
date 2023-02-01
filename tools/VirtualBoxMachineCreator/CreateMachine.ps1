[CmdletBinding()]
param (
    # VirtualBox installation directory
    [Parameter()]
    [string]
    $VBox_Home = "C:\Program Files\Oracle\VirtualBox",

    # Name of the new virtual machine
    [Parameter()]
    [string]
    $Name = "vm1",

    # Path to iso file
    [Parameter()]
    [string]
    $IsoFilePath
)

$env:PATH="${VBox_Home};${env:PATH}"

VBoxManage createvm --name "$Name" --ostype "Ubuntu_64" --register
VBoxManage modifyvm "${Name}" `
    --cpus 2 `
    --ioapic on `
    --memory 4096 `
    --vram 16 `
    --chipset ich9 `
    --mouse usbtablet `
    --nic1 nat `
    --firmware efi `
    --graphicscontroller vmsvga `
    --nested-paging on `
    --nested-hw-virt on `
    --audio none `
    --usb-xhci on `
    --rtc-use-utc on

VBoxManage createmedium disk --filename "$env:UserProfile\VirtualBox VMs\${Name}\${Name}_1.vdi" --size 32768 --format VDI --variant Standard
VBoxManage storagectl "${Name}" --name "AHCI" --add sata --controller IntelAhci --portcount 2
VBoxManage storageattach "${Name}" --storagectl "AHCI" --port 0 --device 0 --type hdd --medium "$env:UserProfile\VirtualBox VMs\${Name}\${Name}_1.vdi"
if((-not [string]::IsNullOrEmpty($IsoFilePath)) -and (Test-Path -Path "${IsoFilePath}")){
    VBoxManage storageattach "${Name}" --storagectl "AHCI" --port 1 --device 0 --type dvddrive --medium "${IsoFilePath}"
    VBoxManage modifyvm "${Name}" --boot1 disk --boot2 dvd --boot3 none --boot4 none
} else {
    VBoxManage modifyvm "${Name}" --boot1 disk --boot2 none --boot3 none --boot4 none
}
