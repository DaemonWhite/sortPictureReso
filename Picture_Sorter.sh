#!/bin/bash

# Default path to search for images
inPath="$HOME/Bureau/trie"
# Default path for where the images will be stored
pcPath="$HOME/Bureau/pc"
mixPath="$HOME/Bureau/mixt"
mobPath="$HOME/Bureau/mobile"
autPath="$HOME/Bureau/tmp"

#Interval data
pc=1.9
mixte=1.5
mobile=0.9

initialise=0

iListe=$initialise
iListeRatio=$initialise

#variable programe
er=1	#Erreur
declare -a Liste #Declare the tab i
declare -a ListeRatio


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


function configure()
{

}

function ChangePath()
{
	
}

while [[ $# -gt 0 ]]; do


  case "${1}" in
      # Parameters that don't require value
    -c |--configure)
      echo "For later asshole"; shift ;;
    -p |--path)
			inPath=${2}
      echo "Yeah so lazy ${2}"; shift ;;
    -s | --secure)
			echo "Ouai la c'est pour plus tard"; shift;;
		-p | --output)
			echo "chemin se sortie"; shift;;
    -h |--help)
      help; shift ;;
    *)
     
  esac

  #echo "$# et ${1}"

done

exitfff

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
		echo "Finish"
		echo "Copy in progress"
		er=0

		for (( n=0; n<$iListe; n++ ))
		do
			calc=$(python3 -c "print(${listeRatio[$n]})")

			#other

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

			#mobile phone

			if [[ [$calc<$mobile] && [$calc==$mobile] ]]; then
				mv "$inPath/${Liste[$n]}" "$mobPath"
				k=$k+4
			fi

			echo "$n : ${Liste[$n]} = $k = ${listeRatio[$n]} = $calc)"
   	 
		done

	echo "copy finish"
	
fi
}

fileSearch
analyst
move

if [[ 1 == $er ]]; then

	echo "An error has occurred this may be due to the use of a gif please remove them"

fi

exit
