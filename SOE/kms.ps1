# Setup Product Key
slmgr.vbs /ipk <your_product_key>
slmgr.vbs /ato
slmgr.vbs /dlv
slmgr /dlv
slmgr /skms kms8.msguides.com
DISM /online /Set-Edition:Enterprise /ProductKey:XX /AcceptEula
