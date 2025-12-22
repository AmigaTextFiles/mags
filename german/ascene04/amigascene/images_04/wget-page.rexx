/*
 * wget-page.rexx - retrieve single HTML-page with all its images
 */

version = '$VER: wget-page.rexx 1.0 (25.3.1998)'

PARSE ARG options

/* Extract the name of the WWW-server to be downloaded from */
PARSE VAR options . 'http://' server '/' .

/* Validate options */
IF options = '?' THEN DO
    /* View help and exit */
    SAY SUBSTR(version, 7) '- retrieve single HTML-page with all its images'
    SAY 'Usage: rx wget-page.rexx [wget-options] URI'
    EXIT 0
END
ELSE IF server = '' THEN DO
    /* If the server name could not be extracted,
     * view error message and abort */
    SAY 'error in options: server missing or does not start with "http://"'
    EXIT 10
END

/* Compute command call for wget */
wget = 'wget --recursive --level=1 --accept=png,jpg,jpeg,gif --domains=' || server options

/* View the command so the user knows what is going to happen */
SAY wget
SAY

/* Invoke the command viewed before
 * and remember amiga-fied its returncode */
ADDRESS COMMAND wget
wgetRC = 10*RC

/* Exit with code returned by wget */
EXIT wgetRC

