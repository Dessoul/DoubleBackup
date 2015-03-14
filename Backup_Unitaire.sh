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

HOST="-h localhost"
BDD="gestion_backups_secondaires"
USER="-u user_gestion_bac"
PASSWD="-puser_gestion_backup_password"
SRC="/home/Backup2/SQL/"

if [

    echo "Pas assez d'arguments" 1>&2
	exit 1
fi

if [ "$1" != "file" -a "$1" != "ftp" ]; then

    echo "Premier argument incorecte" 1>&2
	exit 2
fi

if [ "$3" != "ftp" ]; then

    echo "Deuxieme argument incorecte" 1>&2
	exit 3
fi

FICHIERVERROU="/tmp/verrou_unitaire"
if [ -f $FICHIERVERROU ]; then
    echo "Un programme est deja lancé"
	exit 0
fi

echo "Verrou" > $FICHIERVERROU

echo "Lancement backup unitaire : "$(date)

TEMPFILE="/tmp/nom_fichier_temp"

if [ -f $TEMPFILE ]; then
    rm $TEMPFILE
fi

mysql $HOST $USER $PASSWD -e "SELECT fichier FROM liste_fichiers WHERE dossier = '"$2"' AND IFNULL(date_modification>=date_envoi,TRUE) LIMIT 1" -D $BDD > $TEMPFILE

NOMFICHIER="$(tail -n 1 $TEMPFILE)"

if [ -z "$NOMFICHIER" ]; then
	echo "Aucun fichier a traiter"
	exit 10
fi

echo "Nom du fichier qui va être traité : "$NOMFICHIER

if [ $1 == "ftp" ]; then
    echo "Copie locale"

	if [ -f "/tmp/$NOMFICHIER" ]; then
    	rm "/tmp/$NOMFICHIER"
	fi

	wget -nv -P "/tmp/" "$2""$NOMFICHIER"

fi

if [ $3 == "ftp" ]; then
	echo "Envoi"

	if [ $1 == "ftp" ]; then
		wput -nv "/tmp/$NOMFICHIER" "$4""$NOMFICHIER"
	fi

	if [ $1 == "file" ]; then
		wput -nv "$2""$NOMFICHIER" "$4""$NOMFICHIER"
	fi

fi

if [ -f "/tmp/$NOMFICHIER" ]; then
    rm "/tmp/$NOMFICHIER"

fi

if [ -f "$TEMPFILE" ]; then
    rm $TEMPFILE
	echo
fi

mysql $HOST $USER $PASSWD -e "UPDATE liste_fichiers SET date_envoi = NOW() WHERE dossier = '$2' AND fichier = '$NOMFICHIER'" -D $BDD > $TEMPFILE

echo "Traitement du fichier '"$NOMFICHIER"' terminé sans erreur"
echo "- Date "$(date)" - Traitement du fichier '"$NOMFICHIER"' terminé sans erreur" 1>&2

rm $FICHIERVERROU
