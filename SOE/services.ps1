# --- Disable services (exact names) ---
$svcExact = @(
    # Updates/Store
    "wuauserv","UsoSvc","WaaSMedicSvc","DoSvc","BITS","InstallService",
    # Defender/Security
    "WdNisSvc","WinDefend","SecurityHealthService",
    # Telemetry/Diag
    "DiagTrack","dmwappushservice","diagnosticshub.standardcollector.service","WerSvc","RemoteRegistry",
    # Networking
    #"SharedAccess","lfsvc","RemoteAccess",
    # RDP
    #"TermService","UmRdpService","SessionEnv",
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

Running  AppIDSvc           Application Identity
Running  Appinfo            Application Information
Running  AppXSvc            AppX Deployment Service (AppXSVC)
Running  AudioEndpointBu... Windows Audio Endpoint Builder
Running  Audiosrv           Windows Audio
Running  BalloonService     BalloonService
Running  BFE                Base Filtering Engine
Running  BrokerInfrastru... Background Tasks Infrastructure Ser...
Running  camsvc             Capability Access Manager Service
Running  cbdhsvc_9dc83      Clipboard User Service_9dc83
Running  CDPSvc             Connected Devices Platform Service
Running  CDPUserSvc_9dc83   Connected Devices Platform User Ser...
Running  CertPropSvc        Certificate Propagation
Running  CloudBackupRest... Cloud Backup and Restore Service_9dc83
Running  COMSysApp          COM+ System Application
Running  CoreMessagingRe... CoreMessaging
Running  CryptSvc           Cryptographic Services
Running  DcomLaunch         DCOM Server Process Launcher
Running  DevicesFlowUser... DevicesFlow_9dc83
Running  DiagTrack          Connected User Experiences and Tele...
Running  DispBrokerDeskt... Display Policy Service
Running  Dnscache           DNS Client
Running  DoSvc              Delivery Optimization
Running  DPS                Diagnostic Policy Service
Running  DsSvc              Data Sharing Service
Running  DusmSvc            Data Usage
Running  EventLog           Windows Event Log
Running  EventSystem        COM+ Event System
Running  Everything         Everything
Running  FontCache          Windows Font Cache Service
Running  FoxitReaderUpda... Foxit PDF Reader Update Service
Running  InstallService     Microsoft Store Install Service
Running  iphlpsvc           IP Helper
Running  KeyIso             CNG Key Isolation
Running  LanmanServer       Server
Running  LanmanWorkstation  Workstation
Running  lfsvc              Geolocation Service
Running  LicenseManager     Windows License Manager Service
Running  lmhosts            TCP/IP NetBIOS Helper
Running  LSM                Local Session Manager
Running  MDCoreSvc          Microsoft Defender Core Service
Running  mpssvc             Windows Defender Firewall
Running  MSDTC              Distributed Transaction Coordinator
Running  msiserver          Windows Installer
Running  ncbservice         Network Connection Broker
Running  netprofm           Network List Service
Running  NPSMSvc_9dc83      NPSMSvc_9dc83
Running  nsi                Network Store Interface Service
Running  OneSyncSvc_9dc83   Sync Host_9dc83
Running  PcaSvc             Program Compatibility Assistant Ser...
Running  PimIndexMainten... Contact Data_9dc83
Running  PlugPlay           Plug and Play
Running  Power              Power
Running  ProfSvc            User Profile Service
Running  QEMU-GA            QEMU Guest Agent
Running  RasMan             Remote Access Connection Manager
Running  RmSvc              Radio Management Service
Running  RpcEptMapper       RPC Endpoint Mapper
Running  RpcSs              Remote Procedure Call (RPC)
Running  SamSs              Security Accounts Manager
Running  ScDeviceEnum       Smart Card Device Enumeration Service
Running  Schedule           Task Scheduler
Running  seclogon           Secondary Logon
Running  SecurityHealthS... Windows Security Service
Running  SENS               System Event Notification Service
Running  SessionEnv         Remote Desktop Configuration
Running  ShellHWDetection   Shell Hardware Detection
Running  Spooler            Print Spooler
Running  SstpSvc            Secure Socket Tunneling Protocol Se...
Running  StateRepository    State Repository Service
Running  StorSvc            Storage Service
Running  SysMain            SysMain
Running  SystemEventsBroker System Events Broker
Running  TermService        Remote Desktop Services
Running  TextInputManage... Text Input Management Service
Running  Themes             Themes
Running  TimeBrokerSvc      Time Broker
Running  TokenBroker        Web Account Manager
Running  TrkWks             Distributed Link Tracking Client
Running  UdkUserSvc_9dc83   Udk User Service_9dc83
Running  uhssvc             Microsoft Update Health Service
Running  UmRdpService       Remote Desktop Services UserMode Po...
Running  UnistoreSvc_9dc83  User Data Storage_9dc83
Running  UserDataSvc_9dc83  User Data Access_9dc83
Running  UserManager        User Manager
Running  UsoSvc             Update Orchestrator Service
Running  VaultSvc           Credential Manager
Running  Wcmsvc             Windows Connection Manager
Running  WdiSystemHost      Diagnostic System Host
Running  WdNisSvc           Microsoft Defender Antivirus Networ...
Running  webthreatdefsvc    Web Threat Defense Service
Running  webthreatdefuse... Web Threat Defense User Service_9dc83
Running  WinDefend          Microsoft Defender Antivirus Service
Running  WinHttpAutoProx... WinHTTP Web Proxy Auto-Discovery Se...
Running  Winmgmt            Windows Management Instrumentation
Running  WpnService         Windows Push Notifications System S...
Running  WpnUserService_... Windows Push Notifications User Ser...
Running  wscsvc             Security Center
Running  WSearch            Windows Search



Stopped  AarSvc_9dc83       Agent Activation Runtime_9dc83
Stopped  AJRouter           AllJoyn Router Service
Stopped  ALG                Application Layer Gateway Service
Stopped  AppMgmt            Application Management
Stopped  AppReadiness       App Readiness
Stopped  AppVClient         Microsoft App-V Client
Stopped  AssignedAccessM... AssignedAccessManager Service
Stopped  autotimesvc        Cellular Time
Stopped  AxInstSV           ActiveX Installer (AxInstSV)
Stopped  BcastDVRUserSer... GameDVR and Broadcast User Service_...
Stopped  BDESVC             BitLocker Drive Encryption Service
Stopped  BITS               Background Intelligent Transfer Ser...
Stopped  BluetoothUserSe... Bluetooth User Support Service_9dc83
Stopped  BTAGService        Bluetooth Audio Gateway Service
Stopped  BthAvctpSvc        AVCTP service
Stopped  bthserv            Bluetooth Support Service
Stopped  CaptureService_... CaptureService_9dc83
Stopped  cloudidsvc         Microsoft Cloud Identity Service
Stopped  com.docker.service Docker Desktop Service
Stopped  ConsentUxUserSv... ConsentUX User Service_9dc83
Stopped  CscService         Offline Files
Stopped  dcsvc              Declared Configuration(DC) service
Stopped  defragsvc          Optimize drives
Stopped  DeviceAssociati... DeviceAssociationBroker_9dc83
Stopped  DeviceAssociati... Device Association Service
Stopped  DeviceInstall      Device Install Service
Stopped  DevicePickerUse... DevicePicker_9dc83
Stopped  DevQueryBroker     DevQuery Background Discovery Broker
Stopped  diagnosticshub.... Microsoft (R) Diagnostics Hub Stand...
Stopped  diagsvc            Diagnostic Execution Service
Stopped  DialogBlockingS... DialogBlockingService
Stopped  DisplayEnhancem... Display Enhancement Service
Stopped  DmEnrollmentSvc    Device Management Enrollment Service
Stopped  dmwappushservice   Device Management Wireless Applicat...
Stopped  dot3svc            Wired AutoConfig
Stopped  EapHost            Extensible Authentication Protocol
Stopped  edgeupdate         Microsoft Edge Update Service (edge...
Stopped  edgeupdatem        Microsoft Edge Update Service (edge...
Stopped  EFS                Encrypting File System (EFS)
Stopped  embeddedmode       Embedded Mode
Stopped  EntAppSvc          Enterprise App Management Service
Stopped  fdPHost            Function Discovery Provider Host
Stopped  FDResPub           Function Discovery Resource Publica...
Stopped  fhsvc              File History Service
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
Stopped  InventorySvc       Inventory and Compatibility Apprais...
Stopped  IpxlatCfgSvc       IP Translation Configuration Service
Stopped  KtmRm              KtmRm for Distributed Transaction C...
Stopped  LibreOfficeMain... LibreOffice Maintenance Service
Stopped  lltdsvc            Link-Layer Topology Discovery Mapper
Stopped  LxpSvc             Language Experience Service
Stopped  MapsBroker         Downloaded Maps Manager
Stopped  McpManagementSe... McpManagementService
Stopped  MSiSCSI            Microsoft iSCSI Initiator Service
Stopped  MsKeyboardFilter   Microsoft Keyboard Filter
Stopped  NaturalAuthenti... Natural Authentication
Stopped  NcaSvc             Network Connectivity Assistant
Stopped  NcdAutoSetup       Network Connected Devices Auto-Setup
Stopped  Netlogon           Netlogon
Stopped  Netman             Network Connections
Stopped  NetSetupSvc        Network Setup Service
Stopped  NetTcpPortSharing  Net.Tcp Port Sharing Service
Stopped  NgcCtnrSvc         Microsoft Passport Container
Stopped  NgcSvc             Microsoft Passport
Stopped  NlaSvc             Network Location Awareness
Stopped  p2pimsvc           Peer Networking Identity Manager
Stopped  p2psvc             Peer Networking Grouping
Stopped  P9RdrService_9dc83 P9RdrService_9dc83
Stopped  PeerDistSvc        BranchCache
Stopped  PenService_9dc83   PenService_9dc83
Stopped  perceptionsimul... Windows Perception Simulation Service
Stopped  PerfHost           Performance Counter DLL Host
Stopped  PhoneSvc           Phone Service
Stopped  pla                Performance Logs & Alerts
Stopped  PNRPAutoReg        PNRP Machine Name Publication Service
Stopped  PNRPsvc            Peer Name Resolution Protocol
Stopped  PolicyAgent        IPsec Policy Agent
Stopped  PrintNotify        Printer Extensions and Notifications
Stopped  PrintWorkflowUs... PrintWorkflow_9dc83
Stopped  PushToInstall      Windows PushToInstall Service
Stopped  QEMU Guest Agen... QEMU Guest Agent VSS Provider
Stopped  QWAVE              Quality Windows Audio Video Experience
Stopped  RasAuto            Remote Access Auto Connection Manager
Stopped  RemoteAccess       Routing and Remote Access
Stopped  RemoteRegistry     Remote Registry
Stopped  RetailDemo         Retail Demo Service
Stopped  RpcLocator         Remote Procedure Call (RPC) Locator
Stopped  SCardSvr           Smart Card
Stopped  SCPolicySvc        Smart Card Removal Policy
Stopped  SDRSVC             Windows Backup
Stopped  SEMgrSvc           Payments and NFC/SE Manager
Stopped  Sense              Windows Defender Advanced Threat Pr...
Stopped  SensorDataService  Sensor Data Service
Stopped  SensorService      Sensor Service
Stopped  SensrSvc           Sensor Monitoring Service
Stopped  SharedAccess       Internet Connection Sharing (ICS)
Stopped  SharedRealitySvc   Spatial Data Service
Stopped  shpamsvc           Shared PC Account Manager
Stopped  smphost            Microsoft Storage Spaces SMP
Stopped  SmsRouter          Microsoft Windows SMS Router Service.
Stopped  SNMPTrap           SNMP Trap
Stopped  spectrum           Windows Perception Service
Stopped  spice-agent        Spice Agent
Stopped  sppsvc             Software Protection
Stopped  ssh-agent          OpenSSH Authentication Agent
Stopped  StiSvc             Windows Image Acquisition (WIA)
Stopped  TieringEngineSe... Storage Tiers Management
Stopped  TrustedInstaller   Windows Modules Installer
Stopped  tzautoupdate       Auto Time Zone Updater
Stopped  UevAgentService    User Experience Virtualization Service
Stopped  upnphost           UPnP Device Host
Stopped  vds                Virtual Disk
Stopped  VirtioFsSvc        Virt


#>
