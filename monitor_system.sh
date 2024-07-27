#!/bin/bash
#################################################
###########
##########
##########
###############################################


# Definitions des variables

OUTPUT_FILE="system_monitoring.log"
CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=80

# Fonction pour surveiller l'utilisation du processeur

monitor_cpu(){
	CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 +$4}')
	echo "Cpu Usages: $CPU_USAGE%" | tee -a "$OUTPUT_FILE"
	if (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc -l) )); then
	echo "Alerte: L'utilisation du CPU a dépassé le seuil de $CPU_THRESHOLD% !" | tee -a "$OUTPUT_FILE"
	fi
}

# Fonction pour surveiller l'utilisation de la mémoire

monitor_memory(){
	MEMORY_USAGE=$(free | grep "Mem" | awk '{print $2/$3 * 100}') 
 	echo "MEMORY Usages: $MEMORY_USAGE% " | tee -a "$OUTPUT_FILE"
	if (( $(echo "$MEMORY_USAGE > $MEMORY_THRESHOLD" | bc -l) )); then
	echo "Alerte: L'utilisation du CPU a dépassé le seuil de $MEMORY_THRESHOLD% !" | tee -a "$OUTPUT_FILE"
	fi
}

# Fonction pour surveiller l'utilisation du disque

monitor_disk(){
	DISK_USAGE=$(df / | grep / | awk '{ print $5}' | sed 's/%//g')
	echo "Disk Usage: $DISK_USAGE%" | tee -a "$OUTPUT_FILE"	
	if [ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]; then
	 echo "Alerte: L'utilisation du disque a dépassé le seuil de $DISK_THRESHOLD% !" | tee -a "$OUTPUT_FILE"
	fi
}

main(){
  case "$1" in 
	--help|-h)
	 echo "Usage: $0 [OPTIONS]"
	echo "OPTIONS"
	echo "--help , -h Aficher l'aide"
	echo " --log, -l Specifier le fichier de logs"
	;;
	--log|-l)
	if [ -n "$2" ]; then
	  OUTPUT_FILE="$2"
	else
          echo "aucun fichier de logs specifiers ">&2
 	exit 1
	fi
	;;
esac
# Ajouter l'en-tête au fichier de sortie

 echo "|DATE | CPU USAGE | MEMORY USAGE | DISK USAGE |"> "$OUTPUT_FILE"
 echo "|----|------------|--------------|-----------|">> "$OUTPUT_FILE"
 while true; do
  DATE=$(date '+%Y-%m-%d %H:%M:%S')
  CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
  MEMORY_USAGE=$(free | grep "Mem" | awk '{print $2/$3 * 100}')
  DISK_USAGE=$(df / | grep / | awk '{print $5}' | sed 's/%//g')
 echo "|$DATE|$CPU_USAGE%|$MEMORY_USAGE%|$DISK_USAGE%|">> "$OUTPUT_FILE"
 ## monitor memory
 monitor_memory
### monitor cpu
 monitor_cpu
## monitor disk
 monitor_disk

####### Attendre 60 secondes avant de rescanner le systeme#######
 sleep 60
 done
}
# Appeler la fonction principale avec tous les arguments de la ligne de commande
main"$@"
