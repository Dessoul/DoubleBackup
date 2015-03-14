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

CREATE TABLE liste_fichiers (

	dossier VARCHAR(500) NOT NULL ,
	fichier VARCHAR(500) NOT NULL ,

	date_modification DATE NOT NULL ,
	date_envoi DATE NULL ,

	INDEX (dossier) ,
	INDEX (fichier) ,
	INDEX (date_modification) ,
	INDEX (date_envoi) ,

	UNIQUE (dossier, fichier)

) ENGINE = MyISAM ;

CREATE TABLE horaires (

	jour TINYINT(1) NOT NULL ,
	heure_debut TIME NOT NULL ,
	heure_fin TIME NOT NULL ,

	INDEX (jour) ,
	INDEX (heure_debut) ,
	INDEX (heure_fin)

) ENGINE = MyISAM ;

CREATE TABLE liste_fichiers_temporaire (

	dossier VARCHAR(500) NOT NULL ,
	fichier VARCHAR(500) NOT NULL ,
	mois VARCHAR(10) NOT NULL ,
	jour INT NOT NULL ,
	annee INT NULL ,
	mois_nombre INT NULL ,
	date DATE NULL

) ENGINE = MyISAM ;
