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
UNITBASH="/home/Backup2/Backup_Unitaire.sh"

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

FICHIERVERROU="/tmp/verrou"
if [ -f $FICHIERVERROU ]; then
    echo "Un programme est deja lancé"
	exit 0
fi

echo "Verrou" > $FICHIERVERROU

echo "Lancement backup global : "$(date)

TEMPFILE="/tmp/crenau"

if [ -f "$TEMPFILE" ]; then
    rm "$TEMPFILE"
fi

mysql $HOST $USER $PASSWD -e "SELECT COUNT(*) FROM horaires WHERE (DAYOFWEEK(NOW()) + 6) MOD 7 = jour AND NOW() > heure_debut AND NOW() < heure_fin" -D $BDD > $TEMPFILE

CRENAU="$(tail -n 1 $TEMPFILE)"

RESULTAT=0

while [ "$CRENAU" -gt "0" -a "$RESULTAT" -ne "10" ]
do
	bash "$UNITBASH" "$1" "$2" "$3" "$4"

	RESULTAT=$?

	rm "$TEMPFILE"
	mysql $HOST $USER $PASSWD -e "SELECT COUNT(*) FROM horaires WHERE (DAYOFWEEK(NOW()) + 6) MOD 7 = jour AND NOW() > heure_debut AND NOW() < heure_fin" -D $BDD > $TEMPFILE
	CRENAU="$(tail -n 1 $TEMPFILE)"
done

if [ -f "$TEMPFILE" ]; then
    rm "$TEMPFILE"
fi

echo "Fin backup global : "$(date)

rm $FICHIERVERROU
