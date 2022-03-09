#!/bin/bash

# Chemin par default pour chercher les images
inPath="$HOME/Bureau/trie"
# Chemin par default ou seron ranger les immage
pcPath="$HOME/Bureau/pc"
mixPath="$HOME/Bureau/mixt"
mobPath="$HOME/Bureau/mobile"
autPath="$HOME/Bureau/tmp"

#Interval de donner
pc=1.9
mixte=1.5
mobile=0.9

initialise=0

iListe=$initialise
iListeRatio=$initialise

#variable programe
er=1	#Erreur
declare -a Liste #Declare le tableau i
declare -a ListeRatio


#Creation du fichier de configuration si non existant
if [[ -f "$HOME/.confPictSorter" ]]; 
then
	echo "existe"

	source "$HOME/.confPictSorter"
else

	echo "Creation du fichier par default"
	touch $HOME/.confPictSorter

	echo "inPath=\"$inPath\"" >> $HOME/.confPictSorter
	echo "pcPath=\"$pcPath\"" >> $HOME/.confPictSorter
	echo "mixPath=\"$mixPath\"" >> $HOME/.confPictSorter
	echo "mobPath=\"$mobPath\"" >> $HOME/.confPictSorter
	echo "autPath=\"$autPath\"" >> $HOME/.confPictSorter

	mkdir -p $inPath $pcPath $mixPath $mobPath $autPath

	echo "pc=$pc" >> $HOME/.confPictSorter
	echo "mixte=$mixte" >> $HOME/.confPictSorter
	echo "mobile=$mobile" >> $HOME/.confPictSorter	


fi

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

#Argument au lancment programe
#ex ./mon_rograme -path /mon_beau_chemin/

while [[ $# -gt 0 ]]; do


  case "${1}" in
      # Parameters that don't require value
    -i|--install)
      echo "Pour plus tard connard"; shift ;;
    -p|--path)
      echo "Ouis beauf la fleme ${2}"; shift ;;
    -h|--help)
      help; shift ;;
    *)
      has_any_error="true"; shift ;;
  esac

  #echo "$# et ${1}"

done



#reinitialise i
function reset {
	i=$initialise;
}

function fileSearch()
{

	reset
	echo "Recherche de fichier...";

	while read x
	do 

		Liste+=("$x");

		let "i = $i + 1"

done << EOF
$(ls "$inPath/")
EOF

iListe=$i

echo "$i Image trouver"
}

function analyst()
{

	echo "Analise des ratios";

	for (( n=0; n<$iListe; n++ ))
	do

		res=$(identify -format "%w/%h" "$inPath/${Liste[$n]}");
		listeRatio+=("$res")

		let "i = 1+$n"
   	 
	done
	
	iListeRatio=$i;

	reset
}

function move()
{
	if [[ $iListeRatio == $iListe ]]; then
		echo "Terminer"
		echo "Copie en cours"
		er=0

		for (( n=0; n<$iListe; n++ ))
		do
			calc=$(python3 -c "print(${listeRatio[$n]})")

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

			echo "$n : ${Liste[$n]} = $k = ${listeRatio[$n]} = $calc)"
   	 
		done

	echo "copie terminer"
	
fi
}

fileSearch
analyst
move

if [[ 1 == $er ]]; then

	echo "Une erreur est survenu cela peut êtres du à l'utilisation gif veulier les enlever"

fi


exit