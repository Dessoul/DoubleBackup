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

mysql $HOST $USER $PASSWD -e "SELECT date_modification,HEX(uuid),programme,code_message,message FROM log" -D $BDD > "$TEMPFILE"

echo "Fichier de log créée. Vosu pouvez le consulter : $TEMPFILE"

echo "Appuyez sur entree lorsque vosu avez fini de le consulter"

read A

if [ -f "$TEMPFILE" ]; then
    rm "$TEMPFILE"
fi
