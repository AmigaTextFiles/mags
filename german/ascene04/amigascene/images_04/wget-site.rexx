/*
 * wget-page.rexx - recursively retrieve WWW-site
 */

version = '$VER: wget-site.rexx 1.0 (25.3.1998)'

/* File extensions indicating data we won't need */
trash = 'mpg,mpeg,wav,au,aiff,aif,tgz,Z,gz,zip,lha,lzx,ps'

PARSE ARG options

/* Validate options */
IF ((options = '?') | (options = '')) THEN DO
    /* View help and exit */
    SAY SUBSTR(version, 7) '- recursively retrieve WWW-site'
    SAY 'Usage: rx wget-site.rexx [wget-options] URI'
    EXIT 0
END

/* Compute command call for wget */
wget = 'wget --recursive --no-parent --reject=' || trash options

/* View the command so the user knows what is going to happen */
SAY wget
SAY

/* Invoke the command viewed before
 * and remember its amiga-fied returncode */
ADDRESS COMMAND wget
wgetRC = 10*RC

/* Exit with code returned by wget */
EXIT wgetRC

