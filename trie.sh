path="/home/matheo/Images/Font d'écran/a trier";
#Lancer avec bash
initialise=0;

iListe=$initialise;
iListeH=$initialise;
iListeW=$initialise;


pc=1.9
mixte=1.5
mobile=0.9

declare -a Liste

declare -a reso

function reset {
	i=$initialise;
	#echo $i
}

reset

echo "Recherche de ficchier...";

while read x
do 

	Liste+=("$x");

	let "i = $i + 1"


done << EOF
$(ls "$path/")
EOF

iListe=$i;

echo "$i Fichier trouver"

reset

#echo "${Liste[@]};"



echo "Analise des format";

for (( n=0; n<$iListe; n++ ))
	do

	res=$(identify -format "%w/%h" "$path/${Liste[$n]}");

	listeH+=($res)

	let "i = 1+$n"
   	 
	done

#while read x
#do 
#
#	listeH+=("$x");
#
#	let "i = $i + 1"
#
#
#done << EOF
#$(identify -format "%w/%h \n" "$path/*")
#EOF

iListeH=$i;

reset


echo "Verifcation des entrée"

echo "$iListe $iListeH"

if [[ $iListeH == $iListe ]]; then
	echo "Terminer"
	echo "Copie en cours"

	for (( n=0; n<$iListe; n++ ))
	do

		#echo ${listeH[$n]};

		calc=$(python3 -c "print(${listeH[$n]})")

		#autre

		k=0
		if [[ $calc>$pc ]]; then
			#echo "${Liste[$n]} = $calc = $n = ${listeH[$n]}";
			cp "$path/${Liste[$n]}" "/home/matheo/Bureau/autre/"
			k=$k+1
		fi

		if [[ [$calc>$mixte] && [$calc<$pc] && [$calc==$pc] ]]; then
			cp "$path/${Liste[$n]}" "/home/matheo/Bureau/pc/"
			k=$k+2
		fi

		if [[ [$calc>$mobile] && [$calc<$mixte] && [$calc==$mixte] ]]; then
			cp "$path/${Liste[$n]}" "/home/matheo/Bureau/mixte/"
			k=$k+3
		fi

		if [[ [$calc<$mobile] && [$calc==$mobile] ]]; then
			cp "$path/${Liste[$n]}" "/home/matheo/Bureau/mob/"
			k=$k+4
		fi

		echo "${Liste[$n]} = $k = ${listeH[$n]} = $calc)"

		#echo "$n = ${reso[$n]}"
   	 
	done

	break;
fi

echo "Une erreur est survenu sela peut êtres du à l'utilisation gif veulier les enlever"