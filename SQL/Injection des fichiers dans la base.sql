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

UPDATE liste_fichiers_temporaire
	SET
		mois_nombre =
			IF(mois='Jan',1,
			IF(mois='Feb',2,
			IF(mois='Mar',3,
			IF(mois='Apr',4,
			IF(mois='May',5,
			IF(mois='Jun',6,
			IF(mois='Jul',7,
			IF(mois='Aug',8,
			IF(mois='Sep',9,
			IF(mois='Oct',10,
			IF(mois='Nov',11,
			IF(mois='Dec',12,
			IF(mois='jan',1,
			IF(mois='fÃ©v',2,
			IF(mois='mar',3,
			IF(mois='avr',4,
			IF(mois='mai',5,
			IF(mois='jun',6,
			IF(mois='jui',7,
			IF(mois='aoÃ»',8,
			IF(mois='sep',9,
			IF(mois='oct',10,
			IF(mois='nov',11,
			IF(mois='dÃ©c',12
			,0)))))))))))))))))))))))) ;

UPDATE liste_fichiers_temporaire
	SET
		date = STR_TO_DATE(CONCAT(
			jour,'-',
			mois_nombre,'-',
			IF(annee<2000,
				IF(mois_nombre>MONTH(NOW()),
					YEAR(NOW())-1,
					YEAR(NOW())),
				annee)),
			'%e-%c-%Y');

INSERT INTO liste_fichiers (dossier, fichier, date_modification)
SELECT
		dossier,
		RTRIM(fichier),
		date
	FROM liste_fichiers_temporaire
ON DUPLICATE KEY UPDATE liste_fichiers.date_modification = liste_fichiers_temporaire.date;
