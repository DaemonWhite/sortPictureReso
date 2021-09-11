path="/home/matheo/Images/Font d'écran";
inPath="$path/a trier"

pcPath="$path/tmp pc"
mixPath="$path/tmp mixt"
mobPath="$path/tmp mob"
autPath="$path/tmp autre"

#Initialise les donner
initialise=0;

iListe=$initialise;
iListeH=$initialise;
iListeW=$initialise;

#Interval de donner
pc=1.9
mixte=1.5
mobile=0.9

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
