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

TEMPFILE="/tmp/liste_fichiers_temporaire"

if [ -f "$TEMPFILE" ]; then
    rm "$TEMPFILE"
fi

if [ "$1" == "file" ]; then

	ls -l $2 | grep "^-" | awk {'print "'"$2"'"","$9" "$10" "$11" "$12" "$13","$6","$7","$8'} > $TEMPFILE
fi

if [ "$1" == "ftp" ]; then

	lftp "$2" -e "ls -l ; quit" | grep "^-" | awk {'print "'"$2"'"","$9" "$10" "$11" "$12" "$13","$6","$7","$8'} > $TEMPFILE
fi

mysql $HOST $USER $PASSWD -e "TRUNCATE liste_fichiers_temporaire" -D $BDD
mysqlimport --delete -L --fields-terminated-by=',' --default-character-set=utf8 $HOST $USER $PASSWD $BDD "$TEMPFILE"
echo \'source\ "$SRC"Injection des fichiers dans la base.sql\' | xargs mysql $HOST $USER $PASSWD -D $BDD -e

if [ -f "$TEMPFILE" ]; then
    rm "$TEMPFILE"
fi
