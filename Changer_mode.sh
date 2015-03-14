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

SRC=$(< ./param-source.txt)

NUMPROG=4
LOG="$SRC""Log.sh"

UUID=$(cat /proc/sys/kernel/random/uuid | sed -e "s/-//g")

if [

    echo "Pas assez d'arguments" 1>&2
    bash $LOG $UUID $NUMPROG 2 "Pas assez d'arguments"
	exit 1
fi

if [ "$1" != "suspend" -a "$1" != "parttime" -a "$1" != "fulltime" ]; then

    echo "Argument incorecte" 1>&2
    bash $LOG $UUID $NUMPROG 2 "Argument incorecte"
	exit 2
fi

FILESUSPEND="/tmp/DB_suspend"
FILEFORCE="/tmp/DB_force"

if [ -f "$FILESUSPEND" ]; then
    rm "$FILESUSPEND"
fi
if [ -f "$FILEFORCE" ]; then
    rm "$FILEFORCE"
fi

if [ "$1" = "suspend" ]; then
    echo "Suspention des backups"
    bash $LOG $UUID $NUMPROG 2 "Suspention des backups"
    echo "" > "$FILESUSPEND"
fi

if [ "$1" = "fulltime" ]; then
    echo "Forçage des backups"
    bash $LOG $UUID $NUMPROG 2 "Forçage des backups"
    echo "" > "$FILEFORCE"
fi
