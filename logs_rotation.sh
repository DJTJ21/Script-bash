#!/bin/bash

# Définir les variables
LOG_DIR="/var/log/myapp"
ARCHIVE_DIR="/var/log/myapp/archive"
LOG_FILE="application.log"
MAX_LOG_SIZE=10485760  # Taille maximale du fichier journal en octets (10MB)
DATE=$(date "+%Y-%m-%d_%H-%M-%S")

# Vérifier et créer le répertoire d'archive si nécessaire
if [ ! -d "$ARCHIVE_DIR" ]; then
    mkdir -p "$ARCHIVE_DIR"
fi

# Vérifier la taille du fichier journal
if [ -f "$LOG_DIR/$LOG_FILE" ]; then
    LOG_SIZE=$(stat -c%s "$LOG_DIR/$LOG_FILE")

    if [ "$LOG_SIZE" -ge "$MAX_LOG_SIZE" ]; then
        # Nommer l'archive avec la date actuelle
        ARCHIVE_FILE="$ARCHIVE_DIR/$LOG_FILE.$DATE.gz"

        # Compresser le fichier journal et le déplacer vers le répertoire d'archive
        gzip -c "$LOG_DIR/$LOG_FILE" > "$ARCHIVE_FILE"

        if [ $? -eq 0 ]; then
            # Vider le fichier journal actuel
            : > "$LOG_DIR/$LOG_FILE"
            echo "Le fichier journal a été archivé et compressé en $ARCHIVE_FILE"
        else
            echo "Erreur lors de la compression du fichier journal" >&2
            exit 1
        fi
    else
        echo "Le fichier journal n'a pas encore atteint la taille maximale de $MAX_LOG_SIZE octets"
    fi
else
    echo "Le fichier journal $LOG_DIR/$LOG_FILE n'existe pas" >&2
    exit 1
fi

# Suppression des fichiers d'archive plus anciens que 30 jours
find "$ARCHIVE_DIR" -type f -name "*.gz" -mtime +30 -exec rm {} \;
echo "Les fichiers d'archive plus anciens que 30 jours ont été supprimés"
