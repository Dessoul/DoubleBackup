<h1>Double Backup</h1>
<hr/>
<p>Double Backup is a set of UNIX scripts that backup your backups somewhere else, eg. on a offsite FTP or on a portable harddrive or a magnetic tape.</p>
<p>It support FTP read / write and file read (one day write to).</p>
<p>Backups can be planned during the day.</p>
<p>Made for Duplicity's backup.</p>
<hr/>
<h2>Install</h2>
<p>Install packages : wput mysql-server lftp</p>
<p>Update the "param-" files to put you parameters (more especially the source folder that contain the scripts' folder name)</p>
<p>Launch "Creation_base.sh"</p>
<p>Launch or plan "Mise_a_jour_base.sh" script to update the database</p>
<p>Launch or plan "Backup.sh" script to double backup</p>
<p>Attention : Place the "param-" files on the folder from where you will launch the scripts.</p>
<hr/>
<h2>Usefull Scripts</h2>
<h3>Creation_base.sh</h3>
<p>Create all needed tables on the MySQL database</p>
<p>Arguments : NONE. Just ask the root's password</p>
<h3>Mise_a_jour_base.sh</h3>
<p>Update the files list on the database</p>
<p>Arguments : "file"|"ftp" url </p>
<p>Argument 1 : The type of protocole to use : local file or FTP
<p>Argument 2 : The URL of the folder : /home/user/FolderToSave/ or ftp://userFTP:passwordFTP@FTPserveurAdress/Folder/To/Save/
<h3>Backup.sh</h3>
<p>Realise the double backup</p>
<p>Arguments : "file"|"ftp" urlSource "file"|"ftp" urlTarget</p>
<h3>Changer_mode.sh</h3>
<p>Modify the working mode of the backup, from stop to full-time, passing by part-time</p>
<p>Arguments : "suspend"|"parttime"|"fulltime"  </p>