#!/bin/bash

# Définir le fichier de sortie
OUTPUT_FILE="utilisateurs_connectes_par_date.txt"

# Obtenir la date actuelle
CURRENT_DATE=$(date "+%Y-%m-%d")

# Obtenir la liste des utilisateurs connectés et les écrire dans le fichier de sortie
who | awk -v date="$CURRENT_DATE" '{ print date " " $1 " " $3 " " $4 }' > "$OUTPUT_FILE"

# Vérifier si le fichier de sortie a été créé et écrit
if [ -f "$OUTPUT_FILE" ]; then
    echo "La liste des utilisateurs connectés a été écrite dans $OUTPUT_FILE"
else
    echo "Erreur : le fichier de sortie n'a pas été créé." >&2
    exit 1
fi
