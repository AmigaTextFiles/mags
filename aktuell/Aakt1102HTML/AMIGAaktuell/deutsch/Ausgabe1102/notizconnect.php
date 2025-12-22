<!-- diese Datei außerhalb des Webspaces ablegen -->

<?php

/* Verbindung zur Datenbank herstellen */
function connect()
{
  $mysqlhost     = "localhost";  /* mySQL Server */
  $mysqluser     = "root";       /* User */
  $mysqlpasswd   = "";           /* Password */
  $mysqldatabase = "notizbuch";  /* Datenbankname */

  $connID = @mysql_pconnect($mysqlhost, $mysqluser, $mysqlpasswd);

  if($connID)
  {
    mysql_select_db($mysqldatabase);  /* Datenbank connectieren */
    return( $connID );
  }
  else
  {
    echo "<BR><font color='red'>Keine Verbindung zur Datenbank möglich !</font><BR>\n";
    echo "Fehlerursache: " . mysql_error() . "<BR>\n";
    exit();  /* Skript abbrechen */
  }
}

?>

