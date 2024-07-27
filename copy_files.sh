#!/bin/bash

#############################################
##### Script Shell pour copier des fichiers 
### de manière récursive sur des hôtes distants
##############################################

#############################
####
### MAINTAINER DJETEJE ROMUALD
###
##############################

# Fonction d'affichage de l'aide
function show_help {
    echo "Usage: $0 [OPTIONS] SOURCE DESTINATION"
    echo "Options:"
    echo "  --help, -h      Afficher cette aide"
    echo "  --delete        Supprimer les fichiers du répertoire de destination qui ne sont plus présents dans le répertoire source"
    echo "  --exclude FILE  Exclure le fichier ou le répertoire spécifié de la copie"
    exit 0
}

# Initialiser les variables
DELETE=false
EXCLUDE=""

# Traiter les arguments de la ligne de commande
while [[ "$1" =~ ^- ]]; do
    case "$1" in
        --help | -h)
            show_help
            ;;
        --delete)
            DELETE=true
            shift
            ;;
        --exclude)
            EXCLUDE="--exclude $2"
            shift 2
            ;;
        *)
            echo "Option inconnue: $1" >&2
            show_help
            ;;
    esac
done

# Vérifier que nous avons deux arguments restants : SOURCE et DESTINATION
if [[ $# -ne 2 ]]; then
    echo "Erreur: Nombre incorrect d'arguments." >&2
    show_help
fi

SOURCE=$1
DESTINATION=$2

# Vérifier si SOURCE est un répertoire ou un fichier
if [[ ! -e "$SOURCE" ]]; then
    echo "Erreur: La source spécifiée n'existe pas." >&2
    exit 1
fi

# Copier les fichiers de manière récursive
if $DELETE; then
    rsync -avz --delete $EXCLUDE "$SOURCE" "$DESTINATION"
else
    rsync -avz $EXCLUDE "$SOURCE" "$DESTINATION"
fi

# Vérifier le statut de la commande rsync
if [[ $? -eq 0 ]]; then
    echo "Copie réussie de $SOURCE vers $DESTINATION."
else
    echo "Erreur lors de la copie de $SOURCE vers $DESTINATION." >&2
    exit 1
fi
