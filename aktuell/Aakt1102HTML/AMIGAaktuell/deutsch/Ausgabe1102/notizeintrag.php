<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<!-- Datei: notizeintrag.php -->
<!-- 15.09.2002, Michael Christoph <michael@meicky-soft.de> -->

<HTML>
<HEAD>
  <META HTTP-EQUIV="content-type" CONTENT="text/html; charset=iso-8859-1">
  <META HTTP-EQUIV="content-language" CONTENT="de">
  <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
</HEAD>

<BODY>

<?php

  /* erstes Element leer, damit Monat 1 = Januar ist */
  $monatstr = array("","Januar","Februar","März","April","Mai","Juni","Juli","August","September","Oktober","November","Dezember");


function connect()
{
  /*
  ** die folgenden vier Variablen müssen in der Praxis in einer eigenen Datei
  ** hinterlegt werden, die nicht im Webspace des ISP liegt (i.d.R. htdocs-
  ** Verzeichnis), sondern ausserhalb. Nur so ist ein wirksamer Schutz möglich.
  ** einbindung mittels     include("/pfad/dateiname.php");
  ** Außerdem ergibt sich der Vorteil, daß die Datei lokal und beim ISP
  ** funktioniert. Lediglich die Parameter der Include-Datei müssen angepaßt werden.
  */
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

function eintrag_zeigen($dbid,$dbdatum,$dbuhrzeit,$dbtext)
{
  /* einen Tabelleneintrag im Browser anzeigen zum bearbeiten */
  echo "<tr>\n";
  echo "<form name='notizbuch_$dbid' action='notizeintrag.php' method='post'>\n";
  echo "  <td><input type=text   name='uhrzeit'       value='$dbuhrzeit' maxlength=5></td>\n";
  echo "  <td><input type=text   name='text'          value='$dbtext'    maxlength=100></td>\n";
  echo "  <td><input type=hidden name='datum'         value='$dbdatum'>\n";
  echo "      <input type=hidden name='id'            value='$dbid'>\n";
  echo "      <input type=submit name='form_loeschen' value='löschen'>\n";
  echo "      <input type=submit name='form_aendern'  value='ändern'>\n";
  echo "  </td>\n";
  echo "</form>\n";
  echo "</tr>\n";
}

function eintrag_neu($dbdatum,$dbuhrzeit,$dbtext)
{
  /* einen neuen Eintrag erfassen */
  $result = mysql_query("INSERT INTO notizbuch VALUES(0,'$dbdatum','$dbuhrzeit','$dbtext');");
  if($result)
  {
    $newid = mysql_insert_id($result);
  }
  else
  {
    echo "<BR><font color='red'>EINFÜGEN WAR NICHT MÖGLICH !</font><BR>\n";
    echo "Fehlerursache: " . mysql_error() . "<BR>\n";
  }
}

function eintrag_aendern($dbid,$dbdatum,$dbuhrzeit,$dbtext)
{
  /* einen bestehenden Eintrag verändern */
  $result = mysql_query("REPLACE INTO notizbuch VALUES($dbid,'$dbdatum','$dbuhrzeit','$dbtext');");
  if($result)
  {
  }
  else
  {
    echo "<BR><font color='red'>ÄNDERN WAR NICHT MÖGLICH !</font><BR>\n";
    echo "Fehlerursache: " . mysql_error() . "<BR>\n";
  }
}

function eintrag_loeschen($dbid)
{
  /* einen bestehenden Eintrag aus der Tabelle löschen */
  $result = mysql_query("DELETE FROM notizbuch WHERE id = $dbid;");
  if($result)
  {
  }
  else
  {
    echo "<BR><font color='red'>LÖSCHEN WAR NICHT MÖGLICH !</font><BR>\n";
    echo "Fehlerursache: " . mysql_error() . "<BR>\n";
  }
}


  /* zuerst einmal die Verbindung zur Datenbank herstellen */
  connect();
  

  /* wurde ein Formular übergeben ? */
  if(isset($id))
  {
    /* je nach gedrücktem Schalter verzweigen */
    if(isset($form_neu))      eintrag_neu($datum,$uhrzeit,$text);
    if(isset($form_aendern))  eintrag_aendern($id,$datum,$uhrzeit,$text);
    if(isset($form_loeschen)) eintrag_loeschen($id);

    /* zur anzeige unten wird das Datum wieder zerlegt erwartet */
    /* mit substr() wird der String zerlegt und */
    /* mit sprintf() evtl. führende Nullen entfernt */
    $jahr  = sprintf("%d",substr($datum,0,4));
    $monat = sprintf("%d",substr($datum,5,2));
    $tag   = sprintf("%d",substr($datum,8,2));
  }

  /* ab hier Anzeige des Tabelleninhaltes (der Notizen) */
  if(isset($jahr))
  {
    $suchdatum = date("Y-m-d",mktime(0,0,0,$monat,$tag,$jahr));  /* formatieren als jahr-monat-tag */

    echo "Eintragungen für\n<H1>$tag. $monatstr[$monat] $jahr</H1><BR><BR>\n";

    echo "<table border=0>\n";
    echo "  <tr><th>Uhrzeit</th><th>Eintragung</th><th>Aktionen</th></tr>\n";

    /* Datenbankabfrage starten */
    $result = mysql_query("SELECT * FROM notizbuch WHERE datum = '$suchdatum' ORDER BY uhrzeit");
    if($result)
    {
      /* Anzahl Zeilen ermitteln */
      $rows = mysql_num_rows($result);
      if($rows > 0)
      {
        /* Tabellen-Inhalt ausgeben */
        while($dbentry = mysql_fetch_object($result))
        {
          eintrag_zeigen($dbentry->id,
                         $dbentry->datum,
                         substr($dbentry->uhrzeit,0,5),  /* Sekunden weg */
                         $dbentry->text);
        }
      }
      else
      {
        echo "<tr><td colspan=3><i>keine Eintragungen vorhanden</i></td></tr>\n";
      }
    }
    //else: Datenbank existiert nicht oder SQL-Fehler

    /* entfernt die Ergebnisdaten aus dem Speicher */
    mysql_free_result($result);

    /* zum Schluß noch eine leere Eingabezeile erzeugen */
    echo "<tr>\n";
    echo "<form name='notizbuch_0' action='notizeintrag.php' method='post'>\n";
    echo "  <td><input type=text   name='uhrzeit'  value='' maxlength=5></td>\n";
    echo "  <td><input type=text   name='text'     value='' maxlength=100></td>\n";
    echo "  <td><input type=hidden name='datum'    value='$suchdatum'>\n";
    echo "      <input type=hidden name='id'       value='0'>\n";
    echo "      <input type=submit name='form_neu' value='neu erfassen'>\n";
    echo "  </td>\n";
    echo "</form>\n";
    echo "</tr>\n";
    echo "\n";
    echo "</table>\n";
  }
  else
  {
    /* beim ersten Aufruf ist noch kein Datum vorhanden */
    /* daher wird auch gar nichts angezeigt */
  }
?>

</BODY>
</HTML>

