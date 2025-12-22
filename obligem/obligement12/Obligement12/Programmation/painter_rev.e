-> Bumpee revision bump module. Do not alter this file manually.

OPT MODULE
OPT EXPORT
OPT PREPROCESS

/*
BUMP
  NAME=painter
  VERSION=1
  REVISION=1
ENDBUMP
*/

CONST VERSION=1
CONST REVISION=1

CONST VERSION_DAY=31
CONST VERSION_MONTH=10
CONST VERSION_YEAR=98

#define VERSION_STRING {version_string}
#define VERSION_INFO {version_info}

PROC dummy() IS NIL

version_string:
CHAR '$VER: '
version_info:
CHAR 'painter 1.1 (31.10.98)',0
