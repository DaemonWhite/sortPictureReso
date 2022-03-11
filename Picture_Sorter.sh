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
		touch "$HOME/.confPictSorter"
	fi

	echo "inPath=\"$inPath\"" >> $HOME/.confPictSorter
	echo "pcPath=\"$pcPath\"" >> $HOME/.confPictSorter
	echo "mixPath=\"$mixPath\"" >> $HOME/.confPictSorter
	echo "mobPath=\"$mobPath\"" >> $HOME/.confPictSorter
	echo "autPath=\"$autPath\"" >> $HOME/.confPictSorter

	echo "pc=$pc" >> $HOME/.confPictSorter
	echo "mixte=$mixte" >> $HOME/.confPictSorter
	echo "mobile=$mobile" >> $HOME/.confPictSorter	
}

function configure()
{
	echo "test"
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
