#!/bin/bash
chmod 777 upload/local/in_order/
chmod 777 upload/local/out_order/
chmod 777 upload/local/watch1/
chmod 777 upload/local/watch2/
chmod 777 upload/local/watch3/

docker compose up -d

echo "SMP | http://localhost:8882/csp/sys/%25CSP.Portal.Home.zen"
echo "SMP | https://localhost:8883/csp/sys/%25CSP.Portal.Home.zen"
echo "MSG Bank SMP | http://localhost:8882/iris2/csp/sys/%25CSP.Portal.Home.zen"
echo "Web Gateway http://localhost:8882/csp/bin/Systems/Module.cxw"