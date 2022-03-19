#!/bin/bash

#Load environement variavle
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
	# If the environment variables do not exist
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

#Variable programe
er=1	#Erreur
declare -a Liste #Declare the liste Image
declare -a ListeRatio #Declare Ratio Image
secure=false #Activate safe mode
modConfi=false
installVerif=true
tmp=$inPath
start=true





#Creation of the configuration file if not existing
if [[ -f "$HOME/.confPictSorter" ]]; 
then
	echo "Exist"

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
  -c  --configure   Configure new fixed path
  -s  --secure      Copy files instead of moving them
  -p  --path        Define the path
  -o  --output      Set the output path
  -n	--none	    Disable file search 
  -h  --help        Order information
  "
}

#Argument at program launch
#ex ./mon_rograme -path /mon_beau_chemin/

function main()
{
	if [[ $modConfi != false ]]; then
		configure
	fi

	if [[ $outPath != $XDG_PICTURES_DIR ]]; then
		pcPath="$outPath/pc" 
		mixPath="$outPath/mixt"
		mobPath="$outPath/mob"
		autPath="$outPath/tmp"

		mkdir -p $pcPath $mixPath $mobPath $autPath
		
	fi

	
	if [[ $start != false ]]; then
		fileSearch
		analyst
		move
	fi

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
	#Remove end of path
	if [[ $tmp ]]; then
		testTmp=$(dirname $(echo $tmp))
	fi
	if [[ $installVerif ]]; then
		ok=1
	else
		if [[ -d "$testTmp" ]]; then
			ok=1
		else
			echo "Path not existing"
			ok=0
		fi
	fi

	echo $ok;

	return $ok;
}

function configure()
{
	while [[ 1 ]]; do

  echo "Do you want to create the paths if they exist? [y/n]"

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


  echo "Do you want to put the outputs under the same path as before [y/n]"

  read repsIdentPath
  while [[ 1 ]]; do
    case $repsIdentPath in
         # Parameters that don't require value
       n | n )
         identPath=false; break ;;
       y | Y | o | O)
         identPath=true; break ;;
       *)
         echo "Incorrect value"; shift ;;
    esac

  done


  echo "Leave blank to leave as is"
  echo "Give the path or your image to find"
  echo "Current Path : $inPath"
  read tmp

  if [[ $tmp ]]; then
  	inPath=$tmp
  	echo "ok $tmp"
  fi

  echo $identPath

  if [[ $identPath == true ]]; then
		echo "Give the output path of your images"
		while [[ 1 ]]; do
			read tmp
			#remove end of path
			if [[ $tmp ]]; then
				testTmp=$(dirname $(echo $tmp))
			fi
			
			if [[ $installVerif == true ]]; then
				ok=1
			else
				if [[ -d $testTmp ]]; then
					ok=1
				else
					echo "path not existing $tmp"
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
			echo "Give the path where you want to send your Image in pc format"
			echo "Current Path: $pcPath"
  		read tmp
  		verifTestPath=$(testPath)  		
  		echo $kkk
  		if [[ $tmp ]]; then
  			if [[ $verifTestPath == 1 ]]; then
  				pcPath=$tmp
  				break
  			fi
  		else
  			echo "The path was not changed"
  			break
  		fi

		done
		
		while [[ 1 ]]; do
			echo "Give the path where you want to send your Image in mixed format"
  		echo "Current Path: $mixPath"
  		read tmp
			verifTestPath=$(testPath)  		
  		echo $kkk
  		if [[ $tmp ]]; then
  			if [[ $verifTestPath == 1 ]]; then
  				mixPath=$tmp
  				break
  			fi
  		else
  			echo "The path has not been changed"
  			break
  		fi
		done

		while [[ 1 ]]; do
			echo "Give the path where you want to send your Image in mobile format"
  		echo "Current Path: $mobPath"
  		read tmp
			verifTestPath=$(testPath)  		
  		echo $kkk
  		if [[ $tmp ]]; then
  			if [[ $verifTestPath == 1 ]]; then
  				mobPath=$tmp
  				break
  			fi
  		else
  			echo "The path has not been changed"
  			break
  		fi
		done

		while [[ 1 ]]; do
			echo "Give the path where you want to send the rest of the images"
  		echo "Current Path : $autPath"
  		read tmp
			verifTestPath=$(testPath)  		
  		echo $kkk
  		if [[ $tmp ]]; then
  			if [[ $verifTestPath == 1 ]]; then
  				autPath=$tmp
  				break
  			fi
  		else
  			echo "The path has not been changed"
  			break
  		fi
		done
  	

  	echo "";
	fi

  while [[ 1 ]]; do

     echo "Do you want to change the default values for sorting images [y/n] -i for more info
pc=1.9
mixte=1.5
mobile=0.9
"  
    read repsInsValue

    case $repsInsValue in
         # Parameters that don't require value
       -i | -I | --info )
         echo "
The values are calculated from their fraction example 16/9 is 1.78 the smaller the value the more the format will be in portrait (narrow) and conversely the larger it will be the closer the format will be to a landscape (Wide)

Give them are arranged in this order 'Other > PC > Mixed > mobile' everything that will be greater than 1.9 will therefore be put in 'other' if we take the default values ​​the pc images must be less than 1.9 and greater than 1.5
"; shift ;;
       n | n )
         repsInsValue=true; break ;;
       y | Y | o | O)
         repsInsValue=true; break ;;
       *)
         echo "Incorrect value"; shift ;;
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
  echo "configure file"

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
				echo "Path not existing"
				exit
			fi; shift;;
    -s | --secure)
			secure=true;;
		-o | --output)
			if [[ -d "${2}" ]]; then
				outPath=${2}
			else
				echo "Path not existing"
				exit
			fi; shift;;
			-n | --none)
				start=false;;
    -h |--help)
      help;;
    *)
			echo "syntax error -h or --help for the list of commands"
			break;;
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
