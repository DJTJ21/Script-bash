#!/bin/bash


#######################################################################
##Recherchez les 10 premiers fichiers les plus volumineux du système###
## de fichiers et écrivez la sortie dans un fichier.		    ###
#######################################################################

## BY MOTSEBO  ROMUALD###########

# Définitions de variables
OUTPUT_FILE="larges_files.txt"

# Vérifiez si un fichier de sortie a été spécifié en argument

 if [ -n "$1" ]; then
  OUTPUT_FILE="$1"
 fi
# Trouver les 10 fichiers les plus volumineux et écrire dans le fichier de sortie
 find / -type f -exec du -h {} + 2>>/dev/null | sort -rh | head -10 >>"$OUTPUT_FILE"
# Vérifier si l'opération a réussi
 if [ $? -eq 0 ]; then
  echo "Les 10 fichiers les plus volumineux ont été écrits dans $OUTPUT_FILE" 
 else
 echo "Une erreur s'est produite lors de la recherche des fichiers">&2
 fi
