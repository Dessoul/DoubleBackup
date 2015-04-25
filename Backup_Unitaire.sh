# ################################################################################
# Copyright (C) 2014  PLEYNET & Partners <contact@pleynet.lu>
# 
# A Luxembourgish Company, PLEYNET & Partners, www.pleynet.lu
# 
# This program is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the
# Free Software Foundation, either version 3 of the License, or (at your
# option) any later version, with the additional term under section 7(b)
# of GPLv3 that the text 
# "A Luxembourgish Company, PLEYNET & Partners, www.pleynet-jb.com"
# must be preserved.
# 
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
# 
# You should have received a copy of the GNU General Public License along
# with this program.  If not, see <http://www.gnu.org/licenses/>.
# ################################################################################

HOST=$(< ./param-host.txt)
BDD=$(< ./param-base_donnee.txt)
USER=$(< ./param-user.txt)
PASSWD=$(< ./param-password.txt)
SRC=$(< ./param-source.txt)

NUMPROG=3
LOG="$SRC""Log.sh"

UUID=$(cat /proc/sys/kernel/random/uuid | sed -e "s/-//g")

DATEFICHIERSUPPR="2999-01-01"

bash $LOG $UUID $NUMPROG 1 "Date : $(date), Lancement du programme de backup unitaire, Nombre d aguments :

if [

    echo "Pas assez d'arguments" 1>&2
    bash $LOG $UUID $NUMPROG 2 "Pas assez d'arguments"
	exit 1
fi

if [ "$1" != "file" -a "$1" != "ftp" ]; then

    echo "Premier argument incorecte" 1>&2
    bash $LOG $UUID $NUMPROG 2 "Premier argument incorecte"
	exit 2
fi

if [ "$3" != "ftp" ]; then

    echo "Deuxieme argument incorecte" 1>&2
    bash $LOG $UUID $NUMPROG 2 "Deuxieme argument incorecte"
	exit 3
fi

FICHIERVERROU="/tmp/verrou_unitaire"
FICHIERVERROUERR=$FICHIERVERROU"_error"
if [ -f $FICHIERVERROU ]; then
    echo "Un programme est deja lancé"
    bash $LOG $UUID $NUMPROG 1 "Un programme est deja lance"
	exit 0
fi

echo "" > "$FICHIERVERROU"
echo "" > "$FICHIERVERROUERR"

TEMPFILE="/tmp/nom_fichier_temp"

if [ -f "$TEMPFILE" ]; then
    rm "$TEMPFILE" > "$FICHIERVERROU" 2> "$FICHIERVERROUERR"
    bash $LOG $UUID $NUMPROG 1 "$(cat $FICHIERVERROU)"
    bash $LOG $UUID $NUMPROG 2 "$(cat $FICHIERVERROUERR)"
fi

mysql $HOST $USER $PASSWD -e "SELECT fichier FROM liste_fichiers WHERE dossier = '"$2"' AND IFNULL(date_modification>=date_envoi,TRUE) ORDER BY date_modification ASC LIMIT 1" -D $BDD > $TEMPFILE  2> "$FICHIERVERROUERR"
bash $LOG $UUID $NUMPROG 1 "$(cat $FICHIERVERROU)"
bash $LOG $UUID $NUMPROG 2 "$(cat $FICHIERVERROUERR)"

NOMFICHIER="$(tail -n 1 $TEMPFILE)"

if [ -z "$NOMFICHIER" ]; then

	bash $LOG $UUID $NUMPROG 1 "Aucun fichier a traiter"
	rm "$FICHIERVERROU"
	rm "$FICHIERVERROUERR"
	exit 10
fi

bash $LOG $UUID $NUMPROG 1 "Nom du fichier qui va être traité : $NOMFICHIER"

if [ $1 == "ftp" ]; then

    bash $LOG $UUID $NUMPROG 1 "Copie locale"

	if [ -f "/tmp/$NOMFICHIER" ]; then
    	rm "/tmp/$NOMFICHIER" > "$FICHIERVERROU" 2> "$FICHIERVERROUERR"
    	bash $LOG $UUID $NUMPROG 1 "$(cat $FICHIERVERROU)"
    	bash $LOG $UUID $NUMPROG 2 "$(cat $FICHIERVERROUERR)"
	fi

	bash $LOG $UUID $NUMPROG 1 "Rapatriement"

	wget -nv -P "/tmp/" "$2""$NOMFICHIER" > "$FICHIERVERROU" 2> "$FICHIERVERROUERR"
	RES=$?
    bash $LOG $UUID $NUMPROG 1 "$(cat $FICHIERVERROU)"
    bash $LOG $UUID $NUMPROG 2 "$(cat $FICHIERVERROUERR)"

    if [ $RES -eq "8" ]; then

		bash $LOG $UUID $NUMPROG 1 "Le fichier n'existe plus"
		mysql $HOST $USER $PASSWD -e "UPDATE liste_fichiers SET date_envoi = '$DATEFICHIERSUPPR' WHERE dossier = '$2' AND fichier = '$NOMFICHIER'" -D $BDD > $FICHIERVERROU  2> "$FICHIERVERROUERR"
		bash $LOG $UUID $NUMPROG 1 "$(cat $FICHIERVERROU)"
		bash $LOG $UUID $NUMPROG 2 "$(cat $FICHIERVERROUERR)"
		rm "$FICHIERVERROU"
		rm "$FICHIERVERROUERR"
		exit 0
    fi

	if [ $RES -ne "0" ]; then

		bash $LOG $UUID $NUMPROG 1 "Echec du rapatriment, fin du programme"
	    rm "$TEMPFILE" > "$FICHIERVERROU" 2> "$FICHIERVERROUERR"
    	bash $LOG $UUID $NUMPROG 1 "$(cat $FICHIERVERROU)"
    	bash $LOG $UUID $NUMPROG 2 "$(cat $FICHIERVERROUERR)"
	    rm "/tmp/$NOMFICHIER" > "$FICHIERVERROU" 2> "$FICHIERVERROUERR"
    	bash $LOG $UUID $NUMPROG 1 "$(cat $FICHIERVERROU)"
    	bash $LOG $UUID $NUMPROG 2 "$(cat $FICHIERVERROUERR)"
	    rm "$FICHIERVERROU"
		rm "$FICHIERVERROUERR"
	    exit 4
	fi

	bash $LOG $UUID $NUMPROG 1 "Rapatriment reussi"

fi

if [ $3 == "ftp" ]; then

	bash $LOG $UUID $NUMPROG 1 "Envoi"

	if [ $1 == "ftp" ]; then
		wput -nv "/tmp/$NOMFICHIER" "$4""$NOMFICHIER" > "$FICHIERVERROU" 2> "$FICHIERVERROUERR"
		RES=$?
    	bash $LOG $UUID $NUMPROG 1 "$(cat $FICHIERVERROU)"
    	bash $LOG $UUID $NUMPROG 2 "$(cat $FICHIERVERROUERR)"
	fi

	if [ $1 == "file" ]; then

		if [ ! -f "$2""$NOMFICHIER" ]; then
			bash $LOG $UUID $NUMPROG 1 "Le fichier n'existe plus"
		    mysql $HOST $USER $PASSWD -e "UPDATE liste_fichiers SET date_envoi = '$DATEFICHIERSUPPR' WHERE dossier = '$2' AND fichier = '$NOMFICHIER'" -D $BDD > $FICHIERVERROU  2> "$FICHIERVERROUERR"
			bash $LOG $UUID $NUMPROG 1 "$(cat $FICHIERVERROU)"
			bash $LOG $UUID $NUMPROG 2 "$(cat $FICHIERVERROUERR)"
			rm "$FICHIERVERROU"
			rm "$FICHIERVERROUERR"
			exit 0
		fi

		wput -nv "$2""$NOMFICHIER" "$4""$NOMFICHIER" > "$FICHIERVERROU" 2> "$FICHIERVERROUERR"
		RES=$?
    	bash $LOG $UUID $NUMPROG 1 "$(cat $FICHIERVERROU)"
    	bash $LOG $UUID $NUMPROG 2 "$(cat $FICHIERVERROUERR)"
	fi

	if [ $RES -ne "0" ]; then

	    bash $LOG $UUID $NUMPROG 1 "Echec de l'envoie, fin du programme"
	    rm "$TEMPFILE" > "$FICHIERVERROU" 2> "$FICHIERVERROUERR"
    	bash $LOG $UUID $NUMPROG 1 "$(cat $FICHIERVERROU)"
    	bash $LOG $UUID $NUMPROG 2 "$(cat $FICHIERVERROUERR)"
	    rm "/tmp/$NOMFICHIER" > "$FICHIERVERROU" 2> "$FICHIERVERROUERR"
    	bash $LOG $UUID $NUMPROG 1 "$(cat $FICHIERVERROU)"
    	bash $LOG $UUID $NUMPROG 2 "$(cat $FICHIERVERROUERR)"
	    rm "$FICHIERVERROU"
		rm "$FICHIERVERROUERR"
	    exit 4
	fi

	bash $LOG $UUID $NUMPROG 1 "Envoi reussi"

fi

if [ -f "/tmp/$NOMFICHIER" ]; then
    rm "/tmp/$NOMFICHIER" > "$FICHIERVERROU" 2> "$FICHIERVERROUERR"
    bash $LOG $UUID $NUMPROG 1 "$(cat $FICHIERVERROU)"
    bash $LOG $UUID $NUMPROG 2 "$(cat $FICHIERVERROUERR)"

fi

if [ -f "$TEMPFILE" ]; then
    rm $TEMPFILE  > "$FICHIERVERROU" 2> "$FICHIERVERROUERR"
    bash $LOG $UUID $NUMPROG 1 "$(cat $FICHIERVERROU)"
    bash $LOG $UUID $NUMPROG 2 "$(cat $FICHIERVERROUERR)"
fi

mysql $HOST $USER $PASSWD -e "UPDATE liste_fichiers SET date_envoi = NOW() WHERE dossier = '$2' AND fichier = '$NOMFICHIER'" -D $BDD > $FICHIERVERROU  2> "$FICHIERVERROUERR"
bash $LOG $UUID $NUMPROG 1 "$(cat $FICHIERVERROU)"
bash $LOG $UUID $NUMPROG 2 "$(cat $FICHIERVERROUERR)"

rm "$FICHIERVERROU"
rm "$FICHIERVERROUERR"

bash $LOG $UUID $NUMPROG 1 "Date : $(date), Fin du programme de backup unitaire"
