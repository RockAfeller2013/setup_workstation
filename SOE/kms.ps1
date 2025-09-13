# Setup Product Key
slmgr.vbs /ipk <your_product_key>
slmgr.vbs /ato
slmgr.vbs /dlv
slmgr /dlv
slmgr /skms kms8.msguides.com
DISM /online /Set-Edition:Enterprise /ProductKey:XX /AcceptEula

# Conversion Methods:
# 1. Using DISM (Deployment Image Servicing and Management)
# This is the official Microsoft method to convert evaluation editions to licensed versions.

powershell
# Check current edition
DISM /Online /Get-CurrentEdition

# See available upgrade paths
DISM /Online /Get-TargetEditions

# Convert to licensed edition (example: to Standard)
DISM /Online /Set-Edition:ServerStandard /ProductKey:XXXXX-XXXXX-XXXXX-XXXXX-XXXXX /AcceptEula

# Or to Datacenter
DISM /Online /Set-Edition:ServerDatacenter /ProductKey:XXXXX-XXXXX-XXXXX-XXXXX-XXXXX /AcceptEula
2. Using SLMGR (Software Licensing Management Tool)
powershell
# Install product key
slmgr.vbs /ipk XXXXX-XXXXX-XXXXX-XXXXX-XXXXX

# Activate (if connected to internet)
slmgr.vbs /ato

# Or activate via phone
slmgr.vbs /dti
Valid Product Keys for Conversion:
Windows Server 2022:

<#
Datacenter: WX4NM-KYWYW-QJJR4-XV3QB-6VM33

Standard: VDYBN-27WPP-V4HQT-9VMD4-VMK7H

Windows Server 2019:

Datacenter: WMDGN-G9PQG-XVVXX-R3X43-63DFG

Standard: N69G4-B89J2-4G8F4-WWYCC-J464C

Windows Server 2016:

Datacenter: CB7KF-BWN84-R7R2Y-793K2-8XDDG

Standard: WC2BQ-8NRM3-FDDYY-2BFGV-KHKQY
#>

Note: These are generic keys for installation only. You still need a valid license for activation.
