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

NUMPROG=2
UNITBASH="$SRC""Backup_Unitaire.sh"
LOG="$SRC""Log.sh"

UUID=$(cat /proc/sys/kernel/random/uuid | sed -e "s/-//g")

bash $LOG $UUID $NUMPROG 1 "Date : $(date), Lancement du programme de backup, Nombre d aguments :

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

FICHIERVERROU="/tmp/verrou"
FICHIERVERROUERR=$FICHIERVERROU"_error"
if [ -f $FICHIERVERROU ]; then
    echo "Un programme est deja lancé"
    bash $LOG $UUID $NUMPROG 1 "Un programme est deja lance"
	exit 0
fi

echo "" > "$FICHIERVERROU"
echo "" > "$FICHIERVERROUERR"

TEMPFILE="/tmp/crenau"

if [ -f "$TEMPFILE" ]; then
    rm "$TEMPFILE" > "$FICHIERVERROU" 2> "$FICHIERVERROUERR"
    bash $LOG $UUID $NUMPROG 1 "$(cat $FICHIERVERROU)"
    bash $LOG $UUID $NUMPROG 2 "$(cat $FICHIERVERROUERR)"
fi

mysql $HOST $USER $PASSWD -e "SELECT COUNT(*) FROM horaires WHERE (DAYOFWEEK(NOW()) + 6) MOD 7 = jour AND NOW() > heure_debut AND NOW() < heure_fin" -D $BDD > $TEMPFILE 2> "$FICHIERVERROUERR"
bash $LOG $UUID $NUMPROG 1 "$(cat $FICHIERVERROU)"
bash $LOG $UUID $NUMPROG 2 "$(cat $FICHIERVERROUERR)"

CRENAU="$(tail -n 1 $TEMPFILE)"

bash $LOG $UUID $NUMPROG 1 "Validité du creneau hortaire : $CRENAU"

RESULTAT=0

while [ "$CRENAU" -gt "0" -a "$RESULTAT" -ne "10" ]
do
	bash "$UNITBASH" "$1" "$2" "$3" "$4" > "$FICHIERVERROU" 2> "$FICHIERVERROUERR"
	RESULTAT=$?
    bash $LOG $UUID $NUMPROG 1 "$(cat $FICHIERVERROU)"
    bash $LOG $UUID $NUMPROG 2 "$(cat $FICHIERVERROUERR)"

	rm "$TEMPFILE" > "$FICHIERVERROU" 2> "$FICHIERVERROUERR"
    bash $LOG $UUID $NUMPROG 1 "$(cat $FICHIERVERROU)"
    bash $LOG $UUID $NUMPROG 2 "$(cat $FICHIERVERROUERR)"

	mysql $HOST $USER $PASSWD -e "SELECT COUNT(*) FROM horaires WHERE (DAYOFWEEK(NOW()) + 6) MOD 7 = jour AND NOW() > heure_debut AND NOW() < heure_fin" -D $BDD > $TEMPFILE 2> "$FICHIERVERROUERR"
    bash $LOG $UUID $NUMPROG 1 "$(cat $FICHIERVERROU)"
    bash $LOG $UUID $NUMPROG 2 "$(cat $FICHIERVERROUERR)"

	CRENAU="$(tail -n 1 $TEMPFILE)"
done

if [ -f "$TEMPFILE" ]; then
    rm "$TEMPFILE" > "$FICHIERVERROU" 2> "$FICHIERVERROUERR"
    bash $LOG $UUID $NUMPROG 1 "$(cat $FICHIERVERROU)"
    bash $LOG $UUID $NUMPROG 2 "$(cat $FICHIERVERROUERR)"
fi

rm "$FICHIERVERROU"
rm "$FICHIERVERROUERR"

bash $LOG $UUID $NUMPROG 1 "Date : $(date), Fin du programme de backup"
