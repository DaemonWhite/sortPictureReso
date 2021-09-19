# Chemin par default pour chercher les images
inPath="$HOME/Images/Font d'écran/a trier"
# Chemin par default ou seron ranger les immage
pcPath="$HOME/Images/Font d'écran/tmp pc"
mixPath="$HOME/Images/Font d'écran/tmp mixt"
mobPath="$HOME/Images/Font d'écran/tmp mob"
autPath="$HOME/Images/Font d'écran/tmp autre"

#Initialise les donner
initialise=0;

iListe=$initialise;
iListeH=$initialise;
iListeW=$initialise;

#Interval de donner
pc=1.9
mixte=1.5
mobile=0.9

if [[ -f "$HOME/.trieCache" ]]; then

  source "$HOME/.trieCache"
  echo "inPath=\"$inPath\"" >> $HOME/.trieCache

fi



installVerif=false;# Si vraie il ne créra pas les dossier si il n'existe pas

help()
{
  echo "
  -i  --install   configure des nouveau chemin fixe
  -u  --uninstall suprime les chemin fixe installer
  -s  --secure    copie les fichier au lieux de les deplacer
  -p  --path      defini le chemin d'accer
  -o  --output    definie le chemin de sortie
  -f  --format    Definie les valeur des format
    {pc} {mixte} {mobile}
  -h  --help      information commande
  "
}

install()
{

  while [[ 1 ]]; do

  echo "Voulez vous qu'on crées les chemins si ils n'existent? [y/n]"

  read repsInsVerif

    case $repsInsVerif in
         # Parameters that don't require value
       n | n )
         installVerif=false; break ;;
       y | Y | o | O)
         installVerif=true; break ;;
       *)
         echo "Valeur incorecte"; shift ;;
    esac

  done

  if [[ -f "$HOME/.trieCache" ]]; then

    rm "$HOME/.trieCache"
      
  fi

  touch "$HOME/.trieCache"

  echo "Donner le chemin ou son vos immage à trouver"

  read inPath

  echo "Donner le chemin ou vous voulez envoyer vos Image foramt pc"

  echo "Donner le chemin ou vous voulez envoyer vos Image foramt mixte"

  echo "Donner le chemin ou vous voulez envoyer vos Image foramt mobile"

  echo "";

  while [[ 1 ]]; do

     echo "Voulez vous changer les valeur par defaut pour le trie des image [y/n] -i pour plus d'info
pc=1.9
mixte=1.5
mobile=0.9
"  
    read repsInsValue

    case $repsInsValue in
         # Parameters that don't require value
       -i | -I | --info )
         echo "
Les valeurs son caculer a partir de leur fraction exemple 16/9 fait 1.78 plus la valeur sera petite plus le format serat en portrait(etroit) et inversemnt plus il sera grand plus le foramt sera proche d'un paysage(Large)

Les donner sont rangée dans cette ordre 'Aurtre > PC > Mixte > mobile' tout ce qui sera supérieur à 1.9 sera donc mit dans 'autre' si on prend les valeur par défaut les immage pc devron êtres inferieur à 1.9 et supéreiurs à 1.5
"; shift ;;
       n | n )
         repsInsValue=true; break ;;
       y | Y | o | O)
         repsInsValue=true; break ;;
       *)
         echo "Valeur incorecte"; shift ;;
    esac



  done;


}

#Demande l'avis à l'utilisateur

while [[ $# -gt 0 ]]; do


  case "${1}" in
      # Parameters that don't require value
    -i|--install)
      install; shift ;;
    -p|--path)
      echo "coucou ${2}"; shift ;;
    -h|--help)
      help; shift ;;
    *)
      has_any_error="true"; shift ;;
  esac

  #echo "$# et ${1}"

done

exit

#parité
br=0

declare -a Liste #Declare le tableau i

#reinitialise i
function reset {
	i=$initialise;
}

reset

echo "Recherche de fichier...";

while read x
do 

	Liste+=("$x");

	let "i = $i + 1"

done << EOF
$(ls "$inPath/")
EOF

iListe=$i;

echo "$i Fichier trouver"

reset

#echo "${Liste[@]} \n";



echo "Analise des format";

for (( n=0; n<$iListe; n++ ))
	do

	res=$(identify -format "%w/%h" "$inPath/${Liste[$n]}");

	listeH+=($res)

	let "i = 1+$n"
   	 
	done

iListeH=$i;

reset

echo "Verifcation des entrée"

#echo "$iListe $iListeH"

if [[ $iListeH == $iListe ]]; then
	echo "Terminer"
	echo "Copie en cours"
	br=1

	for (( n=0; n<$iListe; n++ ))
	do

		calc=$(python3 -c "print(${listeH[$n]})")

		#autre

		k=0
		if [[ $calc>$pc ]]; then
			mv "$inPath/${Liste[$n]}" "$autPath"
			k=$k+1
		fi

		#pc

		if [[ [$calc>$mixte] && [$calc<$pc] && [$calc==$pc] ]]; then
			mv "$inPath/${Liste[$n]}" "$pcPath"
			k=$k+2
		fi

		#mixte

		if [[ [$calc>$mobile] && [$calc<$mixte] && [$calc==$mixte] ]]; then
			mv "$inPath/${Liste[$n]}" "$mixPath"
			k=$k+3
		fi

		#mobile

		if [[ [$calc<$mobile] && [$calc==$mobile] ]]; then
			mv "$inPath/${Liste[$n]}" "$mobPath"
			k=$k+4
		fi

		#echo "${Liste[$n]} = $k = ${listeH[$n]} = $calc)"
   	 
	done

	echo "copie terminer"
	
fi

e=0

if [[ $e == $br ]]; then

	echo "Une erreur est survenu sela peut êtres du à l'utilisation gif veulier les enlever"

fi
