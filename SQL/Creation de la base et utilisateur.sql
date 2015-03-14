-- ################################################################################
-- Copyright (C) 2014  PLEYNET & Partners <contact@pleynet.lu>
-- 
-- A Luxembourgish Company, PLEYNET & Partners, www.pleynet.lu
-- 
-- This program is free software: you can redistribute it and/or modify it
-- under the terms of the GNU General Public License as published by the
-- Free Software Foundation, either version 3 of the License, or (at your
-- option) any later version, with the additional term under section 7(b)
-- of GPLv3 that the text 
-- "A Luxembourgish Company, PLEYNET & Partners, www.pleynet-jb.com"
-- must be preserved.
-- 
-- This program is distributed in the hope that it will be useful, but
-- WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
-- General Public License for more details.
-- 
-- You should have received a copy of the GNU General Public License along
-- with this program.  If not, see <http://www.gnu.org/licenses/>.
-- ################################################################################

CREATE DATABASE IF NOT EXISTS gestion_backups_secondaires ;

CREATE USER 'user_gestion_bac'@'localhost' IDENTIFIED BY 'user_gestion_backup_password' ;
GRANT ALL PRIVILEGES ON gestion_backups_secondaires.* TO 'user_gestion_bac'@'localhost' ;
FLUSH PRIVILEGES ;