# sortPictureReso

trie automatiquement les images en fonction de leur format.

## Options Programe

Lance la configuration

```zsh
./Picture_Sorter.sh -c
```

### lance la configuration sans lancer le processus

```zsh
./Picture_Sorter.sh -c -n
```

### Changer pour une seule fois le chemin de sortie

```zsh
./Picture_Sorter.sh -p /path/
```

### Changer le chemin de sortie

crée automatiquement les dossier de sorties mobile pc mixte tmp


```zsh
./Picture_Sorter.sh -o /path/
```

### Copie le fichier au lieu de les déplacer.

```zsh
./Picture_Sorter.sh -s
```

## Systeme de configuration

Les valeurs son caculer a partir de leur fraction exemple 16/9 fait 1.78 plus la valeur sera petite plus le format serat en portrait(etroit) et inversemnt plus il sera grand plus le foramt sera proche d'un paysage(Large)

Les donner sont rangée dans cette ordre 'Aurtre > PC > Mixte > mobile' tout ce qui sera supérieur à 1.9 sera donc mit dans 'autre' si on prend les valeur par défaut les images pc devron êtres inferieur à 1.9 et supéreiurs à 1.5


## Configuration Manuelle

Le fichier de configuration manuelle ce trouve dans

```bash
~/.confPictSorter
```
il se présente come suit: 

inPath="/home/matheo/Bureau/trie"<br>
pcPath="/home/matheo/Bureau/pc"<br>
mixPath="/home/matheo/Bureau/mixt"<br>
mobPath="/home/matheo/Bureau/mobile"<br>
autPath="/home/matheo/Bureau/tmp"<br>
pc=1.9<br>
mixte=0.9<br>
mobile=1.5<br>

Les chemins peut êtres modifier à la main mais le système ne dispose pas de méthodes de verification en cas d'erreur le programe sera casse