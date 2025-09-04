# --- Disable services (exact names) ---
$svcExact = @(
    # Updates/Store
    "wuauserv","UsoSvc","WaaSMedicSvc","DoSvc","BITS","InstallService",
    # Defender/Security
    "WdNisSvc","WinDefend","SecurityHealthService",
    # Telemetry/Diag
    "DiagTrack","dmwappushservice","diagnosticshub.standardcollector.service","WerSvc","RemoteRegistry",
    # Networking
    "SharedAccess","lfsvc","RemoteAccess",
    # RDP
    "TermService","UmRdpService","SessionEnv",
    # Printing/Bluetooth
    "Spooler","PrintNotify","Fax","BTAGService","bthserv","BthHFSrv",
    # Hyper-V/Compute
    "vmms","HvHost","vmcompute","hns",
    # Performance tweaks
    "SysMain"
)
foreach ($s in $svcExact) {
    Write-Output "Disabling service: $s"
    Stop-Service -Name $s -ErrorAction SilentlyContinue
    Set-Service -Name $s -StartupType Disabled -ErrorAction SilentlyContinue
}

# --- Disable services (wildcards for per-user services) ---
$svcWild = @("OneSyncSvc*","PimIndexMaintenanceSvc*","CDPUserSvc*","DevicesFlowUserSvc*")
foreach ($pattern in $svcWild) {
    Get-Service -Name $pattern -ErrorAction SilentlyContinue | ForEach-Object {
        Write-Output "Disabling service: $($_.Name)"
        Stop-Service -Name $_.Name -ErrorAction SilentlyContinue
        Set-Service -Name $_.Name -StartupType Disabled -ErrorAction SilentlyContinue
    }
}

# Disable Xbox-related services
Stop-Service XblAuthManager -Force
Set-Service XblAuthManager -StartupType Disabled

Stop-Service XblGameSave -Force
Set-Service XblGameSave -StartupType Disabled

Stop-Service XboxGipSvc -Force
Set-Service XboxGipSvc -StartupType Disabled

Stop-Service XboxNetApiSvc -Force
Set-Service XboxNetApiSvc -StartupType Disabled

# Disable Diagnostics / Troubleshooting if not needed
Stop-Service diagnosticshub.standardcollector.service -Force
Set-Service diagnosticshub.standardcollector.service -StartupType Disabled

Stop-Service DiagTrack -Force
Set-Service DiagTrack -StartupType Disabled

Stop-Service TroubleshootingSvc -Force
Set-Service TroubleshootingSvc -StartupType Disabled

# Disable Remote Registry
Stop-Service RemoteRegistry -Force
Set-Service RemoteRegistry -StartupType Disabled

# Disable Secondary features (only if unused)
Stop-Service WMPNetworkSvc -Force
Set-Service WMPNetworkSvc -StartupType Disabled

Stop-Service PrintNotify -Force
Set-Service PrintNotify -StartupType Disabled

Stop-Service MapsBroker -Force
Set-Service MapsBroker -StartupType Disabled

Stop-Service RetailDemo -Force
Set-Service RetailDemo -StartupType Disabled

Stop-Service SharedAccess -Force
Set-Service SharedAccess -StartupType Disabled

<#

Status   Name               DisplayName                           
------   ----               -----------                           
Stopped  AarSvc_9dc83       Agent Activation Runtime_9dc83        
Stopped  AJRouter           AllJoyn Router Service                
Stopped  ALG                Application Layer Gateway Service     
Running  AppIDSvc           Application Identity                  
Running  Appinfo            Application Information               
Stopped  AppMgmt            Application Management                
Stopped  AppReadiness       App Readiness                         
Stopped  AppVClient         Microsoft App-V Client                
Running  AppXSvc            AppX Deployment Service (AppXSVC)     
Stopped  AssignedAccessM... AssignedAccessManager Service         
Running  AudioEndpointBu... Windows Audio Endpoint Builder        
Running  Audiosrv           Windows Audio                         
Stopped  autotimesvc        Cellular Time                         
Stopped  AxInstSV           ActiveX Installer (AxInstSV)          
Running  BalloonService     BalloonService                        
Stopped  BcastDVRUserSer... GameDVR and Broadcast User Service_...
Stopped  BDESVC             BitLocker Drive Encryption Service    
Running  BFE                Base Filtering Engine                 
Stopped  BITS               Background Intelligent Transfer Ser...
Stopped  BluetoothUserSe... Bluetooth User Support Service_9dc83  
Running  BrokerInfrastru... Background Tasks Infrastructure Ser...
Stopped  BTAGService        Bluetooth Audio Gateway Service       
Stopped  BthAvctpSvc        AVCTP service                         
Stopped  bthserv            Bluetooth Support Service             
Running  camsvc             Capability Access Manager Service     
Stopped  CaptureService_... CaptureService_9dc83                  
Running  cbdhsvc_9dc83      Clipboard User Service_9dc83          
Running  CDPSvc             Connected Devices Platform Service    
Running  CDPUserSvc_9dc83   Connected Devices Platform User Ser...
Running  CertPropSvc        Certificate Propagation               
Stopped  ClipSVC            Client License Service (ClipSVC)      
Running  CloudBackupRest... Cloud Backup and Restore Service_9dc83
Stopped  cloudidsvc         Microsoft Cloud Identity Service      
Stopped  com.docker.service Docker Desktop Service                
Running  COMSysApp          COM+ System Application               
Stopped  ConsentUxUserSv... ConsentUX User Service_9dc83          
Running  CoreMessagingRe... CoreMessaging                         
Stopped  CredentialEnrol... CredentialEnrollmentManagerUserSvc_...
Running  CryptSvc           Cryptographic Services                
Stopped  CscService         Offline Files                         
Running  DcomLaunch         DCOM Server Process Launcher          
Stopped  dcsvc              Declared Configuration(DC) service    
Stopped  defragsvc          Optimize drives                       
Stopped  DeviceAssociati... DeviceAssociationBroker_9dc83         
Stopped  DeviceAssociati... Device Association Service            
Stopped  DeviceInstall      Device Install Service                
Stopped  DevicePickerUse... DevicePicker_9dc83                    
Running  DevicesFlowUser... DevicesFlow_9dc83                     
Stopped  DevQueryBroker     DevQuery Background Discovery Broker  
Running  Dhcp               DHCP Client                           
Stopped  diagnosticshub.... Microsoft (R) Diagnostics Hub Stand...
Stopped  diagsvc            Diagnostic Execution Service          
Running  DiagTrack          Connected User Experiences and Tele...
Stopped  DialogBlockingS... DialogBlockingService                 
Running  DispBrokerDeskt... Display Policy Service                
Stopped  DisplayEnhancem... Display Enhancement Service           
Stopped  DmEnrollmentSvc    Device Management Enrollment Service  
Stopped  dmwappushservice   Device Management Wireless Applicat...
Running  Dnscache           DNS Client                            
Running  DoSvc              Delivery Optimization                 
Stopped  dot3svc            Wired AutoConfig                      
Running  DPS                Diagnostic Policy Service             
Stopped  DsmSvc             Device Setup Manager                  
Running  DsSvc              Data Sharing Service                  
Running  DusmSvc            Data Usage                            
Stopped  EapHost            Extensible Authentication Protocol    
Stopped  edgeupdate         Microsoft Edge Update Service (edge...
Stopped  edgeupdatem        Microsoft Edge Update Service (edge...
Stopped  EFS                Encrypting File System (EFS)          
Stopped  embeddedmode       Embedded Mode                         
Stopped  EntAppSvc          Enterprise App Management Service     
Running  EventLog           Windows Event Log                     
Running  EventSystem        COM+ Event System                     
Running  Everything         Everything                            
Stopped  fdPHost            Function Discovery Provider Host      
Stopped  FDResPub           Function Discovery Resource Publica...
Stopped  fhsvc              File History Service                  
Running  FontCache          Windows Font Cache Service            
Running  FoxitReaderUpda... Foxit PDF Reader Update Service       
Stopped  FrameServer        Windows Camera Frame Server           
Stopped  FrameServerMonitor Windows Camera Frame Server Monitor   
Stopped  GameInputSvc       GameInput Service                     
Stopped  GoogleChromeEle... Google Chrome Elevation Service (Go...
Stopped  GoogleUpdaterIn... Google Updater Internal Service (Go...
Stopped  GoogleUpdaterIn... Google Updater Internal Service (Go...
Stopped  GoogleUpdaterSe... Google Updater Service (GoogleUpdat...
Stopped  gpsvc              Group Policy Client                   
Stopped  GraphicsPerfSvc    GraphicsPerfSvc                       
Stopped  hidserv            Human Interface Device Service        
Stopped  HvHost             HV Host Service                       
Stopped  icssvc             Windows Mobile Hotspot Service        
Stopped  IKEEXT             IKE and AuthIP IPsec Keying Modules   
Running  InstallService     Microsoft Store Install Service       
Stopped  InventorySvc       Inventory and Compatibility Apprais...
Running  iphlpsvc           IP Helper                             
Stopped  IpxlatCfgSvc       IP Translation Configuration Service  
Running  KeyIso             CNG Key Isolation                     
Stopped  KtmRm              KtmRm for Distributed Transaction C...
Running  LanmanServer       Server                                
Running  LanmanWorkstation  Workstation                           
Running  lfsvc              Geolocation Service                   
Stopped  LibreOfficeMain... LibreOffice Maintenance Service       
Running  LicenseManager     Windows License Manager Service       
Stopped  lltdsvc            Link-Layer Topology Discovery Mapper  
Running  lmhosts            TCP/IP NetBIOS Helper                 
Running  LSM                Local Session Manager                 
Stopped  LxpSvc             Language Experience Service           
Stopped  MapsBroker         Downloaded Maps Manager               
Stopped  McpManagementSe... McpManagementService                  
Running  MDCoreSvc          Microsoft Defender Core Service       
Stopped  MessagingServic... MessagingService_9dc83                
Stopped  MicrosoftEdgeEl... Microsoft Edge Elevation Service (M...
Stopped  MixedRealityOpe... Windows Mixed Reality OpenXR Service  
Stopped  MozillaMaintenance Mozilla Maintenance Service           
Running  mpssvc             Windows Defender Firewall             
Running  MSDTC              Distributed Transaction Coordinator   
Stopped  MSiSCSI            Microsoft iSCSI Initiator Service     
Running  msiserver          Windows Installer                     
Stopped  MsKeyboardFilter   Microsoft Keyboard Filter             
Stopped  NaturalAuthenti... Natural Authentication                
Stopped  NcaSvc             Network Connectivity Assistant        
Running  NcbService         Network Connection Broker             
Stopped  NcdAutoSetup       Network Connected Devices Auto-Setup  
Stopped  Netlogon           Netlogon                              
Stopped  Netman             Network Connections                   
Running  netprofm           Network List Service                  
Stopped  NetSetupSvc        Network Setup Service                 
Stopped  NetTcpPortSharing  Net.Tcp Port Sharing Service          
Stopped  NgcCtnrSvc         Microsoft Passport Container          
Stopped  NgcSvc             Microsoft Passport                    
Stopped  NlaSvc             Network Location Awareness            
Running  NPSMSvc_9dc83      NPSMSvc_9dc83                         
Running  nsi                Network Store Interface Service       
Running  OneSyncSvc_9dc83   Sync Host_9dc83                       
Stopped  p2pimsvc           Peer Networking Identity Manager      
Stopped  p2psvc             Peer Networking Grouping              
Stopped  P9RdrService_9dc83 P9RdrService_9dc83                    
Running  PcaSvc             Program Compatibility Assistant Ser...
Stopped  PeerDistSvc        BranchCache                           
Stopped  PenService_9dc83   PenService_9dc83                      
Stopped  perceptionsimul... Windows Perception Simulation Service 
Stopped  PerfHost           Performance Counter DLL Host          
Stopped  PhoneSvc           Phone Service                         
Running  PimIndexMainten... Contact Data_9dc83                    
Stopped  pla                Performance Logs & Alerts             
Running  PlugPlay           Plug and Play                         
Stopped  PNRPAutoReg        PNRP Machine Name Publication Service 
Stopped  PNRPsvc            Peer Name Resolution Protocol         
Stopped  PolicyAgent        IPsec Policy Agent                    
Running  Power              Power                                 
Stopped  PrintNotify        Printer Extensions and Notifications  
Stopped  PrintWorkflowUs... PrintWorkflow_9dc83                   
Running  ProfSvc            User Profile Service                  
Stopped  PushToInstall      Windows PushToInstall Service         
Stopped  QEMU Guest Agen... QEMU Guest Agent VSS Provider         
Running  QEMU-GA            QEMU Guest Agent                      
Stopped  QWAVE              Quality Windows Audio Video Experience
Stopped  RasAuto            Remote Access Auto Connection Manager 
Running  RasMan             Remote Access Connection Manager      
Stopped  RemoteAccess       Routing and Remote Access             
Stopped  RemoteRegistry     Remote Registry                       
Stopped  RetailDemo         Retail Demo Service                   
Running  RmSvc              Radio Management Service              
Running  RpcEptMapper       RPC Endpoint Mapper                   
Stopped  RpcLocator         Remote Procedure Call (RPC) Locator   
Running  RpcSs              Remote Procedure Call (RPC)           
Running  SamSs              Security Accounts Manager             
Stopped  SCardSvr           Smart Card                            
Running  ScDeviceEnum       Smart Card Device Enumeration Service 
Running  Schedule           Task Scheduler                        
Stopped  SCPolicySvc        Smart Card Removal Policy             
Stopped  SDRSVC             Windows Backup                        
Running  seclogon           Secondary Logon                       
Running  SecurityHealthS... Windows Security Service              
Stopped  SEMgrSvc           Payments and NFC/SE Manager           
Running  SENS               System Event Notification Service     
Stopped  Sense              Windows Defender Advanced Threat Pr...
Stopped  SensorDataService  Sensor Data Service                   
Stopped  SensorService      Sensor Service                        
Stopped  SensrSvc           Sensor Monitoring Service             
Running  SessionEnv         Remote Desktop Configuration          
Stopped  SharedAccess       Internet Connection Sharing (ICS)     
Stopped  SharedRealitySvc   Spatial Data Service                  
Running  ShellHWDetection   Shell Hardware Detection              
Stopped  shpamsvc           Shared PC Account Manager             
Stopped  smphost            Microsoft Storage Spaces SMP          
Stopped  SmsRouter          Microsoft Windows SMS Router Service. 
Stopped  SNMPTrap           SNMP Trap                             
Stopped  spectrum           Windows Perception Service            
Stopped  spice-agent        Spice Agent                           
Running  Spooler            Print Spooler                         
Stopped  sppsvc             Software Protection                   
Running  SSDPSRV            SSDP Discovery                        
Stopped  ssh-agent          OpenSSH Authentication Agent          
Running  SstpSvc            Secure Socket Tunneling Protocol Se...
Running  StateRepository    State Repository Service              
Stopped  StiSvc             Windows Image Acquisition (WIA)       
Running  StorSvc            Storage Service                       
Stopped  svsvc              Spot Verifier                         
Stopped  swprv              Microsoft Software Shadow Copy Prov...
Running  SysMain            SysMain                               
Running  SystemEventsBroker System Events Broker                  
Stopped  TapiSrv            Telephony                             
Running  TermService        Remote Desktop Services               
Running  TextInputManage... Text Input Management Service         
Running  Themes             Themes                                
Stopped  TieringEngineSe... Storage Tiers Management              
Running  TimeBrokerSvc      Time Broker                           
Running  TokenBroker        Web Account Manager                   
Running  TrkWks             Distributed Link Tracking Client      
Stopped  TroubleshootingSvc Recommended Troubleshooting Service   
Stopped  TrustedInstaller   Windows Modules Installer             
Stopped  tzautoupdate       Auto Time Zone Updater                
Running  UdkUserSvc_9dc83   Udk User Service_9dc83                
Stopped  UevAgentService    User Experience Virtualization Service
Running  uhssvc             Microsoft Update Health Service       
Running  UmRdpService       Remote Desktop Services UserMode Po...
Running  UnistoreSvc_9dc83  User Data Storage_9dc83               
Stopped  upnphost           UPnP Device Host                      
Running  UserDataSvc_9dc83  User Data Access_9dc83                
Running  UserManager        User Manager                          
Running  UsoSvc             Update Orchestrator Service           
Stopped  VacSvc             Volumetric Audio Compositor Service   
Running  VaultSvc           Credential Manager                    
Stopped  vds                Virtual Disk                          
Stopped  VirtioFsSvc        VirtIO-FS Service                     
Stopped  vmicguestinterface Hyper-V Guest Service Interface       
Stopped  vmicheartbeat      Hyper-V Heartbeat Service             
Stopped  vmickvpexchange    Hyper-V Data Exchange Service         
Stopped  vmicrdv            Hyper-V Remote Desktop Virtualizati...
Stopped  vmicshutdown       Hyper-V Guest Shutdown Service        
Stopped  vmictimesync       Hyper-V Time Synchronization Service  
Stopped  vmicvmsession      Hyper-V PowerShell Direct Service     
Stopped  vmicvss            Hyper-V Volume Shadow Copy Requestor  
Stopped  VSInstallerElev... Visual Studio Installer Elevation S...
Stopped  VSS                Volume Shadow Copy                    
Running  W32Time            Windows Time                          
Stopped  WaaSMedicSvc       WaaSMedicSvc                          
Stopped  WalletService      WalletService                         
Stopped  WarpJITSvc         Warp JIT Service                      
Stopped  wbengine           Block Level Backup Engine Service     
Stopped  WbioSrvc           Windows Biometric Service             
Running  Wcmsvc             Windows Connection Manager            
Stopped  wcncsvc            Windows Connect Now - Config Registrar
Stopped  WdiServiceHost     Diagnostic Service Host               
Running  WdiSystemHost      Diagnostic System Host                
Running  WdNisSvc           Microsoft Defender Antivirus Networ...
Stopped  WebClient          WebClient                             
Running  webthreatdefsvc    Web Threat Defense Service            
Running  webthreatdefuse... Web Threat Defense User Service_9dc83 
Stopped  Wecsvc             Windows Event Collector               
Stopped  WEPHOSTSVC         Windows Encryption Provider Host Se...
Stopped  wercplsupport      Problem Reports Control Panel Support 
Stopped  WerSvc             Windows Error Reporting Service       
Stopped  WFDSConMgrSvc      Wi-Fi Direct Services Connection Ma...
Stopped  WiaRpc             Still Image Acquisition Events        
Running  WinDefend          Microsoft Defender Antivirus Service  
Running  WinHttpAutoProx... WinHTTP Web Proxy Auto-Discovery Se...
Running  Winmgmt            Windows Management Instrumentation    
Stopped  WinRM              Windows Remote Management (WS-Manag...
Stopped  wisvc              Windows Insider Service               
Stopped  WlanSvc            WLAN AutoConfig                       
Stopped  wlidsvc            Microsoft Account Sign-in Assistant   
Stopped  wlpasvc            Local Profile Assistant Service       
Stopped  WManSvc            Windows Management Service            
Stopped  wmiApSrv           WMI Performance Adapter               
Stopped  WMPNetworkSvc      Windows Media Player Network Sharin...
Stopped  workfolderssvc     Work Folders                          
Stopped  WpcMonSvc          Parental Controls                     
Stopped  WPDBusEnum         Portable Device Enumerator Service    
Running  WpnService         Windows Push Notifications System S...
Running  WpnUserService_... Windows Push Notifications User Ser...
Running  wscsvc             Security Center                       
Running  WSearch            Windows Search                        
Stopped  wuauserv           Windows Update                        
Stopped  WwanSvc            WWAN AutoConfig                       
Stopped  XblAuthManager     Xbox Live Auth Manager                
Stopped  XblGameSave        Xbox Live Game Save                   
Stopped  XboxGipSvc         Xbox Accessory Management Service     
Stopped  XboxNetApiSvc      Xbox Live Networking Service          




#>
