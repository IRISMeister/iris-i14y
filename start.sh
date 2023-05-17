#!/bin/bash
docker compose up -d postgres sftp ftp smtp iris2 
docker compose exec -T iris2 bash -c "\$ISC_PACKAGE_INSTALLDIR/dev/Cloud/ICM/waitISC.sh '' 60"
# wait until msgbank production is ready
sleep 5
docker compose up -d iris

echo "SMP | http://localhost:52773/csp/sys/%25CSP.Portal.Home.zen"
