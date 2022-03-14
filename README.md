# sortPictureReso
#### [Oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)
Trie les immage en fonction de leur format


Lance la configuration

```zsh
./Picture_Sorter.sh -c
```

lance la configuration sans lancer le processus

```zsh
./Picture_Sorter.sh -c -n
```

Changer pour une seule fois le chemin de sortie

```zsh
./Picture_Sorter.sh -p /path/
```

Changer le chemin de sortie

```zsh
./Picture_Sorter.sh -o /path/
```

Copie le fichier au lieu de le déplacer.

```zsh
./Picture_Sorter.sh -s
```

Les valeurs son caculer a partir de leur fraction exemple 16/9 fait 1.78 plus la valeur sera petite plus le format serat en portrait(etroit) et inversemnt plus il sera grand plus le foramt sera proche d'un paysage(Large)

Les donner sont rangée dans cette ordre 'Aurtre > PC > Mixte > mobile' tout ce qui sera supérieur à 1.9 sera donc mit dans 'autre' si on prend les valeur par défaut les images pc devron êtres inferieur à 1.9 et supéreiurs à 1.5

> [!NOTE]
> Information the user should notice even if skimming.