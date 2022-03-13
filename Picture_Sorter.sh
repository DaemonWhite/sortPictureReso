#!/bin/bash

#load environement variavle
if [[ -f  "$HOME/.config/user-dirs.dirs" ]]; then
	source $HOME/.config/user-dirs.dirs

	# Default path to search for images
	inPath="$XDG_PICTURES_DIR/trie"
	# Default path for where the images will be stored
	pcPath="$XDG_PICTURES_DIR/pc"
	mixPath="$XDG_PICTURES_DIR/mixt"
	mobPath="$XDG_PICTURES_DIR/mobile"
	autPath="$XDG_PICTURES_DIR/tmp"
else 
	# Si les variables d'environement n'existe pas
	inPath="$HOME/pictureResort/trie"
	
	pcPath="$HOME/pictureResort/pc"
	mixPath="$HOME/pictureResort/mixt"
	mobPath="$HOME/pictureResort/mobile"
	autPath="$HOME/pictureResort/tmp"

fi

outPath=$XDG_PICTURES_DIR

#Interval data
pc=1.9
mixte=1.5
mobile=0.9

initialise=0

iListe=$initialise
iListeRatio=$initialise

#variable programe
er=1	#Erreur
declare -a Liste #Declare the liste Image
declare -a ListeRatio #Declare Ratio Image
secure=false #Activer  le mode securiser
modConfi=false
installVerif=true
tmp=$inPath





#Creation of the configuration file if not existing
if [[ -f "$HOME/.confPictSorter" ]]; 
then
	echo "exist"

	source "$HOME/.confPictSorter"
else

	echo "Creation of the default file"
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
  -c  --configure   configure new fixed path
  -s  --secure    copy files instead of moving them
  -p  --path      define the path
  -o  --output    set the output path
  -f  --format    Define the values of the formats
    {pc} {mixte} {mobile}
  -h  --help      order information
  "
}

#Argument at program launch
#ex ./mon_rograme -path /mon_beau_chemin/

function main()
{
	if [[ modConfi ]]; then
		configure
	fi

	if [[ $outPath != $XDG_PICTURES_DIR ]]; then
		pcPath="$outPath/pc" 
		mixPath="$outPath/mixt"
		mobPath="$outPath/mob"
		autPath="$outPath/tmp"

		mkdir -p $pcPath $mixPath $mobPath $autPath
		
	fi

	

	fileSearch
	analyst
	move
	exit

}

function createConfFile()
{

	if [[ -f "$HOME/.confPictSorter" ]]; then
		rm "$HOME/.confPictSorter"
	fi

	touch "$HOME/.confPictSorter"

	mkdir -p $inPath $pcPath $mixPath $mobPath $autPath

	echo "inPath=\"$inPath\"" >> $HOME/.confPictSorter
	echo "pcPath=\"$pcPath\"" >> $HOME/.confPictSorter
	echo "mixPath=\"$mixPath\"" >> $HOME/.confPictSorter
	echo "mobPath=\"$mobPath\"" >> $HOME/.confPictSorter
	echo "autPath=\"$autPath\"" >> $HOME/.confPictSorter

	echo "pc=$pc" >> $HOME/.confPictSorter
	echo "mixte=$mixte" >> $HOME/.confPictSorter
	echo "mobile=$mobile" >> $HOME/.confPictSorter	
}

function testPath()
{
	#suprime la fin du chemin
	if [[ $tmp ]]; then
		testTmp=$(dirname $(echo $tmp))
	fi
	if [[ $installVerif ]]; then
		ok=1
	else
		if [[ -d "$testTmp" ]]; then
			ok=1
		else
			echo "chemin non existant"
			ok=0
		fi
	fi

	echo $ok;

	return $ok;
}

function configure()
{
	while [[ 1 ]]; do

  echo "Voulez vous créer les chemins si ils n'existent? [y/n]"

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


  echo "Voulez vous metre les sortie sous le même chemin [y/n]"

  read repsIdentPath
  while [[ 1 ]]; do
    case $repsIdentPath in
         # Parameters that don't require value
       n | n )
         identPath=false; break ;;
       y | Y | o | O)
         identPath=true; break ;;
       *)
         echo "Valeur incorecte"; shift ;;
    esac

  done


  echo "Laisser vide pour laissez comme telle"
  echo "Donner le chemin ou son vos immage à trouver"
  echo "Chemin Actuelle : $inPath"
  read tmp

  if [[ $tmp ]]; then
  	inPath=$tmp
  	echo "ok $tmp"
  fi

  echo $identPath

  if [[ $identPath == true ]]; then
		echo "Donner le chemin de sortie de vos image"
		while [[ 1 ]]; do
			read tmp
			#suprime la fin du chemin
			if [[ $tmp ]]; then
				testTmp=$(dirname $(echo $tmp))
			fi
			
			if [[ $installVerif == true ]]; then
				ok=1
			else
				if [[ -d $testTmp ]]; then
					ok=1
				else
					echo "chemin non existant $tmp"
					ok=0
				fi
			fi
			if [[ $ok == 1 ]]; then
				pcPath="$tmp/pc"
				mixPath="$tmp/mixt"
				mobPath="$tmp/mob"
				autPath="$tmp/tmp"
				break
			fi
		done
	else
		while [[ 1 ]]; do
			echo "Donner le chemin ou vous voulez envoyer vos Image foramt pc"
			echo "Chemin Actuelle : $pcPath"
  		read tmp
  		verifTestPath=$(testPath)  		
  		echo $kkk
  		if [[ $tmp ]]; then
  			if [[ $verifTestPath == 1 ]]; then
  				pcPath=$tmp
  				break
  			fi
  		else
  			echo "Le chemin na pas étais changer"
  			break
  		fi

		done
		
		while [[ 1 ]]; do
			echo "Donner le chemin ou vous voulez envoyer vos Image foramt mixte"
  		echo "Chemin Actuelle : $mixPath"
  		read tmp
			verifTestPath=$(testPath)  		
  		echo $kkk
  		if [[ $tmp ]]; then
  			if [[ $verifTestPath == 1 ]]; then
  				mixPath=$tmp
  				break
  			fi
  		else
  			echo "Le chemin na pas étais changer"
  			break
  		fi
		done

		while [[ 1 ]]; do
			echo "Donner le chemin ou vous voulez envoyer vos Image foramt mobile"
  		echo "Chemin Actuelle : $mobPath"
  		read tmp
			verifTestPath=$(testPath)  		
  		echo $kkk
  		if [[ $tmp ]]; then
  			if [[ $verifTestPath == 1 ]]; then
  				mobPath=$tmp
  				break
  			fi
  		else
  			echo "Le chemin na pas étais changer"
  			break
  		fi
		done

		while [[ 1 ]]; do
			echo "Donner le chemin ou vous voulez envoyer le reste des images"
  		echo "Chemin Actuelle : $autPath"
  		read tmp
			verifTestPath=$(testPath)  		
  		echo $kkk
  		if [[ $tmp ]]; then
  			if [[ $verifTestPath == 1 ]]; then
  				autPath=$tmp
  				break
  			fi
  		else
  			echo "Le chemin na pas étais changer"
  			break
  		fi
		done
  	

  	echo "";
	fi

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

  if [[ repsInsValue==true ]]; then
  	echo "pc : "
  	read pc
  	echo "mobile : "
  	read mobile
  	echo "mixte : "
  	read mixte
  fi

  createConfFile
  echo "fichier configurer"

}

while [[ $# -gt 0 ]]; do


  case "${1}" in
      # Parameters that don't require value
    -c |--configure)
      modConfi=true;;
    -p |--path)
			if [[ -d "${2}" ]]; then
				inPath=${2}
			else
				echo "Chemin non existant"
				exit
			fi; shift;;
    -s | --secure)
			secure=true;;
		-o | --output)
			if [[ -d "${2}" ]]; then
				outPath=${2}
			else
				echo "Chemin non existant"
				exit
			fi; shift;;
    -h |--help)
      help;;
    *)
			help;;
  esac
  shift

  #echo "$# et ${1}"

done


#reinitialise i
function reset {
	i=$initialise;
}

function fileSearch()
{

	reset
	echo "File search...";

	while read x
	do 

		Liste+=("$x");

		let "i = $i + 1"

done << EOF
$(ls "$inPath/")
EOF

iListe=$i

echo "$i Image found"
}



function analyst()
{

	echo "Ratio analysis";

	for (( n=0; n<$iListe; n++ ))
	do

		echo -ne "[$n/$iListe]"\\r
		res=$(identify -format "%w/%h" "$inPath/${Liste[$n]}");
		listeRatio+=("$res")

		let "i = 1+$n"
   	 
	done

	echo -ne "[$n/$iListe]"
	
	iListeRatio=$i;

	reset
}

function move()
{
	if [[ $iListeRatio == $iListe ]]; then
		echo
		echo "Finish"
		echo "Copy in progress"
		er=0

		

		for (( n=0; n<$iListe; n++ ))
		do
			echo -ne "[$n/$iListe]"\\r
			
			calc=$(python3 -c "print(${listeRatio[$n]})")

			#other

			k=0
			if [[ $calc>$pc ]]; then
				if [[ secure ]]; then
					cp "$inPath/${Liste[$n]}" "$autPath"
				else
					mv "$inPath/${Liste[$n]}" "$autPath"
				fi
				k=$k+1
			fi

			#pc

			if [[ [$calc>$mixte] && [$calc<$pc] && [$calc==$pc] ]]; then
				if [[ secure ]]; then
					cp "$inPath/${Liste[$n]}" "$pcPath"
				else
					mv "$inPath/${Liste[$n]}" "$pcPath"
				fi
				k=$k+2
			fi

			#mixte

			if [[ [$calc>$mobile] && [$calc<$mixte] && [$calc==$mixte] ]]; then
				if [[ secure ]]; then
					cp "$inPath/${Liste[$n]}" "$mixPath"
				else
					mv "$inPath/${Liste[$n]}" "$mixPath"
				fi
				k=$k+3
			fi

			#mobile phone

			if [[ [$calc<$mobile] && [$calc==$mobile] ]]; then
				if [[ secure ]]; then
					cp "$inPath/${Liste[$n]}" "$mobPath"
				else
					mv "$inPath/${Liste[$n]}" "$mobPath"
				fi
				k=$k+4
			fi

			#echo "$n : ${Liste[$n]} = $k = ${listeRatio[$n]} = $calc)"
   	 
		done
		echo -ne "[$n/$iListe]"
		echo
		echo "copy finish"
	
fi
}

main

if [[ 1 == $er ]]; then

	echo "An error has occurred this may be due to the use of a gif please remove them"

fi

exit
