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

NUMPROG=1
LOG="$SRC""Log.sh"

UUID=$(cat /proc/sys/kernel/random/uuid | sed -e "s/-//g")

bash $LOG $UUID $NUMPROG 1 "Date : $(date), Lancement du programme de mise à jour, Nombre d aguments :

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

FICHIERVERROU="/tmp/verrou_MAJ"
FICHIERVERROUERR=$FICHIERVERROU"_error"
if [ -f $FICHIERVERROU ]; then
    echo "Un programme est deja lancé"
    bash $LOG $UUID $NUMPROG 1 "Un programme est deja lance"
	exit 0
fi

echo "" > "$FICHIERVERROU"
echo "" > "$FICHIERVERROUERR"

TEMPFILE="/tmp/liste_fichiers_temporaire"

if [ -f "$TEMPFILE" ]; then
    rm "$TEMPFILE" > "$FICHIERVERROU" 2> "$FICHIERVERROUERR"
    bash $LOG $UUID $NUMPROG 1 "$(cat $FICHIERVERROU)"
    bash $LOG $UUID $NUMPROG 2 "$(cat $FICHIERVERROUERR)"

fi

if [ "$1" == "file" ]; then

	ls -l $2 | grep "^-" | awk {'print "'"$2"'"","$9" "$10" "$11" "$12" "$13","$6","$7","$8'} > $TEMPFILE 2> "$FICHIERVERROUERR"
	bash $LOG $UUID $NUMPROG 2 "$(cat $FICHIERVERROUERR)"

fi

if [ "$1" == "ftp" ]; then

	lftp "$2" -e "ls -l ; quit" | grep "^-" | awk {'print "'"$2"'"","$9" "$10" "$11" "$12" "$13","$6","$7","$8'} > $TEMPFILE 2> "$FICHIERVERROUERR"
	bash $LOG $UUID $NUMPROG 2 "$(cat $FICHIERVERROUERR)"

fi

mysql $HOST $USER $PASSWD -e "TRUNCATE liste_fichiers_temporaire" -D $BDD > "$FICHIERVERROU" 2> "$FICHIERVERROUERR"
bash $LOG $UUID $NUMPROG 1 "$(cat $FICHIERVERROU)"
bash $LOG $UUID $NUMPROG 2 "$(cat $FICHIERVERROUERR)"

mysqlimport --delete -L --fields-terminated-by=',' --default-character-set=utf8 $HOST $USER $PASSWD $BDD "$TEMPFILE" > "$FICHIERVERROU" 2> "$FICHIERVERROUERR"
bash $LOG $UUID $NUMPROG 1 "$(cat $FICHIERVERROU)"
bash $LOG $UUID $NUMPROG 2 "$(cat $FICHIERVERROUERR)"

echo \'source\ "$SRC"SQL/Injection des fichiers dans la base.sql\' | xargs mysql $HOST $USER $PASSWD -D $BDD -e > "$FICHIERVERROU" 2> "$FICHIERVERROUERR"
bash $LOG $UUID $NUMPROG 1 "$(cat $FICHIERVERROU)"
bash $LOG $UUID $NUMPROG 2 "$(cat $FICHIERVERROUERR)"

if [ -f "$TEMPFILE" ]; then
    rm "$TEMPFILE"  > "$FICHIERVERROU" 2> "$FICHIERVERROUERR"
    bash $LOG $UUID $NUMPROG 1 "$(cat $FICHIERVERROU)"
    bash $LOG $UUID $NUMPROG 2 "$(cat $FICHIERVERROUERR)"

fi

rm "$FICHIERVERROU"
rm "$FICHIERVERROUERR"

bash $LOG $UUID $NUMPROG 1 "Fin du programme de mise à jour"
