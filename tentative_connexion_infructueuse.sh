#!/bin/bash


#########################################
#### Script Shell qui affiche le nombre de 
#### tentatives de connexion infructueuses 
####par adresse IP et emplacement.
################################################

#####################################################
#############
#############  MAINTENER : DJETEJE ROMUALD
#####################################################
# Définir le fichier journal à analyser (par exemple, /var/log/auth.log pour les tentatives de connexion SSH)
LOG_FILE="/var/log/auth.log"

# Vérifier si le fichier journal existe
if [ ! -f "$LOG_FILE" ]; then
    echo "Le fichier journal $LOG_FILE n'existe pas."
    exit 1
fi

# Fichier temporaire pour stocker les adresses IP et les tentatives de connexion
TEMP_FILE=$(mktemp)

# Extraire les adresses IP des tentatives de connexion infructueuses
grep "Failed password" "$LOG_FILE" | awk '{print $(NF-3)}' | sort | uniq -c | sort -nr > "$TEMP_FILE"

# Afficher le résultat
echo "Tentatives de connexion infructueuses par adresse IP et emplacement :"
echo "-------------------------------------------------------------"

# Lire le fichier temporaire et afficher les informations
while read -r line; do
    # Obtenir le nombre de tentatives et l'adresse IP
    ATTEMPTS=$(echo "$line" | awk '{print $1}')
    IP=$(echo "$line" | awk '{print $2}')
    
    # Obtenir les informations de géolocalisation pour l'adresse IP
    LOCATION=$(curl -s "http://ip-api.com/line/$IP?fields=country,regionName,city" | paste -s -d ',' -)

    # Afficher les informations
    echo "IP: $IP - Tentatives: $ATTEMPTS - Emplacement: $LOCATION"
done < "$TEMP_FILE"

# Supprimer le fichier temporaire
rm "$TEMP_FILE"
