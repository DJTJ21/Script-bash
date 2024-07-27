#!bin/bash


# Definir une variable pour stocker le journal des operation

LOG_FILE="zombie_killer.log"

# fonction pour verifier et tuer les proccessus zombie
kill_zombies() {
	#rechercher les proccessus zombies
	ZOMBIES=$(ps aux | awk '$8="Z" {print $2}')
	
	if [ -z "$ZOMBIES" ]; then
	 echo "Aucun proccessus trouver" | tee -a "$LOG_FILE"
	exit 0
       fi
    # Boucle pour tuer les processus zombies
  for ZOMBIE_PID in $ZOMBIES; do 
  #verifions si le PID est toujours actif et est un processus actif
    if ps -p "$ZOMBIE_PID" -o stat= | grep -q "Z" ; then
    echo "Killing zombie process with PID: $ZOMBIE_PID" | tee -a "$LOG_FILE"
     kill -9 "$ZOMBIE_PID"2>>$LOG_FILE
     if [ $? -eq 0 ]; then
       echo " zombie process with PID: $ZOMBIE_PID killed successfully" | tee -a "$LOG_FILE"
     else
      echo "failed to Kill zombie process with PID: $ZOMBIE_PID" | tee -a "$LOG_FILE"
     fi
    fi
  done
}
### Fonction Principale###############

main(){

  case "$1" in 
      --help|-h)
     echo "Usage : $0 [OPTIONS]"
     echo "Options:"
     echo "  --help, -h    Afficher cette aide"
     echo "  --log, -l     Spécifier le fichier de journal (default: zombie_killer.log)"
     exit 0
      ;;
    --log|-l)
     if [ -n "$2" ]; then
      LOG_FILE="$2"
     else 
     echo "Erreur: Aucun fichier de journal spécifié.">&2
     exit 1
     fi
    ;;
esac

###Appel de la fonction kill_zombies
kill_zombies
}

############Appel de la fonction main
main "$@"
