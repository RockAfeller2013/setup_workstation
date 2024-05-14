Vagrant.configure("2") do |config|
  config.vm.hostname = "myhostname"
  config.vm.network :private_network, ip: "192.168.193.141"

# Windows
config.vm.provison "shell", inline; <<=SHELL
    w32tm /config /syncfromflags:manual /manualpeerlist:ntp_server_address /reliable:YES /update
    w32tm /resync
    w32tm /query /status
    echo "192.168.193.141     cbresponse cbresponse.local" | Out-File -FilePath 'C:\Windows\System32\drivers\etc\hosts' -Append
  SHELL
end

# LINUX
config.vm.provison "shell", inline; <<=SHELL
    echo "192.168.193.141     cbresponse cbresponse.local" | sudo tee -a /etc/hosts
    sudo hostnamectl set-hostname cbresponse
    sudo systemctl restart systemd-hostnamed
    sudo timedatectl set-ntp true
  SHELL
end
