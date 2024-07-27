# SCRIPT BASH !
 
 Il s'agit d'un ensemble de scripts bash conçus pour faciliter  **l'administration quotidienne de votre système.** De plus, ces scripts constituent **une excellente ressource** pour ceux qui aiment apprendre par la pratique. J'y ai également inclus un aide-mémoire rapide pour vous aider à comprendre les scripts présentés ci-dessus.

# Aide-memoire
Ceci n'est pas destinee a celui qui va de zero mais pour vise des gens avec deja des base dans l'ecriture des script

## Expressions Régulières
Voici quelques composants de base des expressions régulières :

-   **Caractères ordinaires** : Représentent eux-mêmes (ex. `a`, `b`, `1`, `2`).
-   **Points** : Le point (`.`) correspond à n'importe quel caractère unique.
-   **Crochets** : Les crochets (`[]`) correspondent à n'importe quel caractère unique à l'intérieur.
    -   `[abc]` correspond à `a`, `b` ou `c`.
    -   `[a-z]` correspond à n'importe quelle lettre minuscule.
-   **Caret (^) et Dollar ($)** : Utilisés pour correspondre au début (^) ou à la fin ($) d'une ligne.
    -   `^abc` correspond à `abc` au début d'une ligne.
    -   `abc$` correspond à `abc` à la fin d'une ligne.
-   **Barre verticale (|)** : Correspondance de l'une des expressions séparées par `|`.
    -   `a|b` correspond à `a` ou `b`.

### 3. Quantificateurs

Les quantificateurs spécifient combien de fois un élément doit être présent pour correspondre :

-   `*` : 0 ou plus fois.
-   `+` : 1 ou plus fois.
-   `?` : 0 ou 1 fois.
-   `{n}` : Exactement `n` fois.
-   `{n,}` : Au moins `n` fois.
-   `{n,m}` : Entre `n` et `m` fois.

### 4. Groupes et Plages

-   **Parenthèses** : Utilisées pour grouper des éléments.
    -   `(abc)+` correspond à `abc`, `abcabc`, etc.
-   **Plages de caractères** : Définies avec des tirets.
    -   `[a-zA-Z]` correspond à toute lettre majuscule ou minuscule.

### 5. Métacaractères

Les métacaractères ont des significations spéciales :

-   **\d** : Correspond à un chiffre (0-9).
-   **\w** : Correspond à un caractère de mot (lettres, chiffres, soulignés).
-   **\s** : Correspond à un espace blanc (espace, tabulation, etc.).
-   **\b** : Correspond à une limite de mot.

### 6. Utilisation dans les Commandes
 `grep`
 ```bash
   grep 'pattern' file
```
-   Utilisez `-E` pour les expressions régulières étendues.
-   Utilisez `-i` pour ignorer la casse.
`awk`
```bash
awk '/pattern/ { print }' file
```

## 7. Exemples Pratiques

### 7.1 Correspondance de motifs
```bash
echo "Hello World" | grep -E "Hello|World"
```
### 7.2 Substitution de texte
```bash
echo "Hello 123 World" | sed -E 's/[0-9]+/NUM/'
```
### 7.3 Extraction de parties de texte
```bash
echo "abc123xyz" | awk '{ if ($0 ~ /[0-9]+/) print $0 }'
```

## Conditions et Boucles
### 1. Conditions
**If-Else**
Syntaxe de base :
```bash
if [ condition ]; then
    # Commandes si la condition est vraie
elif [ another_condition ]; then
    # Commandes si another_condition est vraie
else
    # Commandes si aucune condition n'est vraie
fi
```
Exemple:
```bash
#!/bin/bash

read -p "Entrez un nombre : " number

if [ $number -gt 10 ]; then
    echo "Le nombre est plus grand que 10"
elif [ $number -eq 10 ]; then
    echo "Le nombre est égal à 10"
else
    echo "Le nombre est plus petit que 10"
fi
```
**Case**
Syntaxe de base :
```bash
case "$variable" in
    pattern1)
        # Commandes pour pattern1
        ;;
    pattern2)
        # Commandes pour pattern2
        ;;
    *)
        # Commandes pour tout autre cas
        ;;
esac
```
Exemple:
```bash 
#!/bin/bash

read -p "Entrez une lettre : " letter

case "$letter" in
    [a-z])
        echo "Vous avez entré une lettre minuscule"
        ;;
    [A-Z])
        echo "Vous avez entré une lettre majuscule"
        ;;
    [0-9])
        echo "Vous avez entré un chiffre"
        ;;
    *)
        echo "Vous avez entré un caractère spécial"
        ;;
esac
```
### Boucles
**For Loop**
Syntaxe de base :
```bash
for variable in list; do
    # Commandes pour chaque élément de la liste
done
```
Exemple :
```bash
#!/bin/bash

for i in {1..5}; do
    echo "Itération $i"
done
```
**While Loop**
Syntaxe de base :
```bash
while [ condition ]; do
    # Commandes tant que la condition est vraie
done
```
Exemple :
```bash
#!/bin/bash

count=1

while [ $count -le 5 ]; do
    echo "Itération $count"
    count=$((count + 1))
done
```
### Boucles Imbriquées
Exemple de boucles imbriquées :
```bash
#!/bin/bash

for i in {1..3}; do
    echo "Boucle externe : $i"
    for j in {1..2}; do
        echo "  Boucle interne : $j"
    done
done
```

## Redirections en Bash

### Redirection de la sortie standard (stdout)

Pour rediriger la sortie standard d'une commande vers un fichier, utilisez le symbole `>`.
Syntaxe :
```bash
command > file
```
Exemple :
```bash
echo "Hello, World!" > output.txt
```
### Redirection de l'entrée standard (stdin)

Pour rediriger l'entrée standard d'une commande à partir d'un fichier, utilisez le symbole `<`.
Syntaxe :
```bash
commande < fichier
```
Exemple:
```bash
ls /nonexistent_directory 2> error.txt
```
### Redirection de la sortie standard et de l'erreur standard vers un même fichier

Pour rediriger la sortie standard et l'erreur standard vers le même fichier, utilisez `&>`.

Syntaxe :
```bash
commande &> fichier
```
Exemple :
```bash
ls /nonexistent_directory &> output_and_error.txt
```
### Append (ajout) à la sortie standard et à l'erreur standard

Pour ajouter à la fin d'un fichier plutôt que de l'écraser, utilisez `>>` pour stdout et `2>>` pour stderr.

Exemple :
```bash
echo "New Line" >> output.txt
ls /nonexistent_directory 2>> error.txt
```
### Redirection de la sortie standard et de l'erreur standard séparément

Pour rediriger stdout et stderr vers des fichiers différents, utilisez `>` et `2>`.
Syntaxe :
```bash
commande > fichier_sortie 2> fichier_erreur
```
Exemple :
```bash
ls /nonexistent_directory > output.txt 2> error.txt
```
### Redirection de la sortie standard vers l'erreur standard

Pour rediriger stdout vers stderr, utilisez `1>&2`.
Syntaxes: 
```bash
commande 1>&2
```
Exemples:
```bash
echo "This is an error message" 1>&2
```
### Redirection de l'erreur standard vers la sortie standard

Pour rediriger stderr vers stdout, utilisez `2>&1`.

Syntaxe :
```bash
commande 2>&1
```
Exemple:
```bash
ls /nonexistent_directory > output_and_error.txt 2>&1
```
### Redirection de l'entrée standard à partir d'une commande (pipe)

Pour rediriger la sortie standard d'une commande vers l'entrée standard d'une autre commande, utilisez le symbole `|` (pipe).

Syntaxe :
```bash
commande1 | commande2
```
Exemple :
```bash
cat input.txt | grep "search_term"
```
### Null Device

Pour rediriger la sortie ou l'erreur vers null (suppression de la sortie), utilisez `/dev/null`.
Syntaxe :
```bash
commande > /dev/null 2>&1
```
Exemple :
```bash
ls /nonexistent_directory > /dev/null 2>&1
```
Ce Aide-memoire sera probablement ajouter avec le temps profitez en.

```Romuald DJETEJE```
