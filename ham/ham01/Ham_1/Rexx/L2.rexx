/* Strings */
ADDRESS COMMAND
OPTIONS PROMPT "ein Satz> "
PARSE PULL satz
DO i=1 TO WORDS(satz)
  SAY WORD(satz,i)
END
DO i=2 TO LENGTH(satz)
  SAY LEFT(satz,i)
END
SAY "Und nun ohne Vokale :"
SAY COMPRESS(satz,"AEIOUaeiou")
SAY "Und jetzt alles mit A :"
SAY TRANSLATE(satz,"AAAAAaaaaa","AEIOUaeiou")
