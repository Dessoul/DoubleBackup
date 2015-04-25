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

TEMPFILE="/tmp/recuperation_log"

if [ -f "$TEMPFILE" ]; then
    rm "$TEMPFILE"
fi

echo "Creation du ficheir de log"

if [
	echo "Log complet"
	mysql $HOST $USER $PASSWD -e "SELECT date_modification,HEX(uuid),programme,code_message,message FROM log" -D $BDD > "$TEMPFILE"
fi

if [
	echo "Log des $1 derinieres lignes"
	mysql $HOST $USER $PASSWD -e "SELECT date_modification,HEX(uuid),programme,code_message,message FROM log ORDER BY date_modification DESC LIMIT $1" -D $BDD > "$TEMPFILE"
fi

echo "Fichier de log créée. Vosu pouvez le consulter : $TEMPFILE"

echo "Faite 1 pour l'ouvrir avec nano, 2 pour l'afficher dans la console, n'importe quoi d'autre pour fermer"

read A

if [ $A -eq "1" ]; then
	nano "$TEMPFILE"
fi

if [ $A -eq "2" ]; then
	cat "$TEMPFILE"
fi

if [ -f "$TEMPFILE" ]; then
    rm "$TEMPFILE"
fi
