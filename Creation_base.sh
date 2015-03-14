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

CC="mysql"
HOST="-h localhost"
USER="-u root"
EXEC="-e 'source"
SRC="/home/Backup2/SQL/"

echo "Mot de passe ?"
read -s PASSWD
PASSWD="-p$PASSWD"

echo \'source\ "$SRC"Creation de la base et utilisateur.sql\' | xargs mysql $HOST $USER $PASSWD -e

BDD="-D gestion_backups_secondaires"
USER="-u user_gestion_bac"
PASSWD="-puser_gestion_backup_password"

echo \'source\ "$SRC"Creation des tables.sql\' | xargs mysql $HOST $USER $PASSWD $BDD -e
echo \'source\ "$SRC"Crenaux horaires autorisés.sql\' | xargs mysql $HOST $USER $PASSWD $BDD -e
