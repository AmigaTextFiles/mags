<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<!-- Datei: notizkalender.php -->
<!-- 15.09.2002, Michael Christoph <michael@meicky-soft.de> -->

<HTML>
<HEAD>
  <META HTTP-EQUIV="content-type" CONTENT="text/html; charset=iso-8859-1">
  <META HTTP-EQUIV="content-language" CONTENT="de">
  <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
</HEAD>

<BODY>

<?php

  /* Hilfsfunktion zur Ermittlung von Feiertagen */
  function isFeiertag($m,$d,$y)
  {
    /* es wird nur der Sonntag als Feiertag erkannt */
    if( date("w",mktime(1,1,1,$m,$d,$y)) == 0 )
      return 'red';
    else
      return 'black';
  }


  /* erstes Element leer, damit Monat 1 = Januar ist */
  $monatstr = array("","Januar","Februar","März","April","Mai","Juni","Juli","August","September","Oktober","November","Dezember");

  /* beim ersten Aufruf das heutige Monat und Jahr anzeigen */
  if(!(isset($jahr)))
  {
    $jahr=date("Y",time());
    $monat=date("n",time());
  }
  $tag = 1;
  $timestamp = mktime(1,1,1,$monat,$tag,$jahr);

  /* das Kalenderblatt als Tabelle ausgeben */
  echo "<center><br><br>\n";
  echo "<table border='0'>\n";
  echo "<tr>\n";
  echo "<td align='center' valign='top'>\n";

  /* Link für vorherigen Monat erzeugen */
  if($monat > 1)
    echo "<a href='notizkalender.php?monat=" . ($monat-1) . "&jahr=" . $jahr . "'>" . $monatstr[$monat-1] . " " . $jahr . "</a><BR><BR>\n";
  else
    echo "<a href='notizkalender.php?monat=12&jahr=" . ($jahr-1) . "'>" . $monatstr[12] . " " . ($jahr-1) . "</a><BR><BR>\n";

  /* das aktuelle Monat dazwischen mit Jahreszahl ausgeben */
  echo " <font size='5' face='tahoma'>" . $monatstr[$monat] . " $jahr</font> \n";

  echo "<table width='150' border='1'>\n";

  /* als Überschrift die Wochentage eintragen */
  echo "<td align='center' width='30'>Mo</th>\n";
  echo "<td align='center' width='30'>Di</th>\n";
  echo "<td align='center' width='30'>Mi</th>\n";
  echo "<td align='center' width='30'>Do</th>\n";
  echo "<td align='center' width='30'>Fr</th>\n";
  echo "<td align='center' width='30'>Sa</th>\n";
  echo "<td align='center' width='30'><font color='red'>So</font></th>\n";
  echo "<tr>\n";

  /* erst mal einrücken bis zum Wochentag des 1. */
  $wochentag = date("w",$timestamp);
  if($wochentag == 0) $wochentag = 7;  /* 0=Sonntag */
  for($i=1; $i<$wochentag; $i++)
  {
    echo "<td align='center'>&nbsp;</td>\n";
  }

  /* dann alle Tage des Monats ausgeben */
  while(checkdate($monat,$tag,$jahr))
  {
    echo "<td align='center'><font color='" . isFeiertag($monat,$tag,$jahr) . "'><a href='notizeintrag.php?tag=$tag&monat=$monat&jahr=$jahr' target='eintrag'>$tag</a></font></td>\n";
    /* am Sonntag ist die Zeile zu Ende und eine neue wird begonnen */
    if(isFeiertag($monat,$tag,$jahr) == "red") { echo "</tr><tr>\n"; }
    $tag++;
  }

  /* noch auffüllen bis zum Sonntag */
  if(! (isFeiertag($monat,$tag-1,$jahr) == "red"))
  {
    while(! (isFeiertag($monat,$tag,$jahr) == "red"))
    {
      echo "<td align='center'>&nbsp;</td>\n";
      $tag++;
    }
    echo "<td align='center'>&nbsp;</td>\n";
  }

  echo "</tr>\n";
  echo "</table>\n";



  /* Link für folgenden Monat erzeugen */
  if($monat < 12)
    echo "<BR><a href='notizkalender.php?monat=" . ($monat+1) . "&jahr=" . $jahr . "'>" . $monatstr[$monat+1] . " " . $jahr . "</a><BR>\n";
  else
    echo "<BR><a href='notizkalender.php?monat=1&jahr=" . ($jahr+1) . "'>" . $monatstr[1] . " " . ($jahr+1) . "</a><BR>\n";


  echo "</td>\n";

  echo "</tr>\n";
  echo "</table>\n";
  echo "</center>\n";

?>

</BODY>
</HTML>

