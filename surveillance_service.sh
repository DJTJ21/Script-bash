#!/bin/bash

SERVICES=("docker" "docker")

check_service() {
  local service=$1
  systemctl is-active  --quiet $service
  if [ $? -ne 0]; then
    echo "le Servcie $servcie est en panne Redemarrage..."
    systemctl restart $service
    if [$? -eq 0]; then
      echo "le service  $service a Redemarrer avec success..."
    else
      echo " echec du redemarrage du service $service ..."
    fi
  else 
   echo "le servcie est actifs ..."
  fi
}
# Vérifier chaque service dans la liste

for service in "$SERVICES[@]}"; do
  check_service $service
done
