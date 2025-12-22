                        INCLUDE "lvos/exec_lib.i"
                        INCLUDE "lvos/dos_lib.i"
                        INCLUDE "dos/dos.i"

Main                    MOVE.L  (4).W,(ExecLibraryBase)

                        LEA     (DosLibraryName,PC),A1
                        MOVEQ   #36,D0
                        MOVE.L  (ExecLibraryBase,PC),A6
                        JSR     (_LVOOpenLibrary,A6)
                        MOVE.L  D0,(DosLibraryBase)
                        BEQ     .1

; Szükségünk van egy FileInfoBlock-ra, amit így lehet megkapni a legkönnyeben,
; habár le lehet foglalni egy sima Exec/AllocMem-mel is.

                        MOVEQ   #DOS_FIB,D1
                        MOVEQ   #0,D2
                        MOVE.L  (DosLibraryBase,PC),A6
                        JSR     (_LVOAllocDosObject,A6)
                        MOVE.L  D0,(FileInfoBlockAddress)
                        BEQ     .2

; Szerzünk egy FileLock-ot a file-hoz, amelynek a nevét már remélhetõleg
; mindenki átírta egy nála valóban létezõre.

                        MOVE.L  #FileName,D1
                        MOVEQ   #SHARED_LOCK,D2
                        MOVE.L  (DosLibraryBase,PC),A6
                        JSR     (_LVOLock,A6)
                        MOVE.L  D0,(FileLockAddress)
                        BEQ     .3

; Megvizsgáljuk a fájlt, hogy megkapjuk róla az informaciókat a
; FileInfoBlock-ban.

                        MOVE.L  (FileLockAddress,PC),D1
                        MOVE.L  (FileInfoBlockAddress,PC),D2
                        MOVE.L  (DosLibraryBase,PC),A6
                        JSR     (_LVOExamine,A6)
                        TST.W   D0
                        BEQ     .4

; Az adatok elõkészítése.

                        MOVE.L  (FileInfoBlockAddress,PC),A0
                        LEA     (ArgumentArray,PC),A1

                        LEA     (TypeFileText,PC),A2
                        TST.L   (fib_DirEntryType,A0)
                        BMI     .5
                        LEA     (TypeDirectoryText,PC),A2
.5                      MOVE.L  A2,(A1)+

                        LEA     (fib_FileName,A0),A2
                        MOVE.L  A2,(A1)+

                        LEA     (fib_Comment,A0),A2
                        MOVE.L  A2,(A1)+

                        MOVE.L  (fib_Size,A0),(A1)+

                        LEA     (ProtectionText+7,PC),A2
                        MOVE.L  (fib_Protection,A0),D0
                        MOVEQ   #4-1,D1
.7                      LSR.L   #1,D0
                        BCC     .6
                        MOVE.B  #"-",(A2)
.6                      SUBQ.L  #1,A2
                        DBF     D1,.7
                        MOVEQ   #4-1,D1
.9                      LSR.L   #1,D0
                        BCS     .8
                        MOVE.B  #"-",(A2)
.8                      SUBQ.L  #1,A2
                        DBF     D1,.9

                        MOVE.L  #ProtectionText,(A1)+

                        MOVE.L  (fib_DiskKey,A0),(A1)+

                        MOVE.L  (fib_NumBlocks,A0),(A1)+

; Az adatok kiírása, persze csak akkor, ha CLI-bõl lett indítva a program.

                        MOVE.L  #FormatString,D1
                        MOVE.L  #ArgumentArray,D2
                        MOVE.L  (DosLibraryBase,PC),A6
                        JSR     (_LVOVPrintf,A6)

; A FileLock felszabadítása.

.4                      MOVE.L  (FileLockAddress,PC),D1
                        MOVE.L  (DosLibraryBase,PC),A6
                        JSR     (_LVOUnLock,A6)

; A FileInfoBlock felszabadítása.

.3                      MOVE.L  #DOS_FIB,D1
                        MOVE.L  (FileInfoBlockAddress,PC),D2
                        MOVE.L  (DosLibraryBase,PC),A6
                        JSR     (_LVOFreeDosObject,A6)

.2                      MOVE.L  (DosLibraryBase,PC),A1
                        MOVE.L  (ExecLibraryBase,PC),A6
                        JSR     (_LVOCloseLibrary,A6)

.1                      MOVEQ   #RETURN_OK,D0
                        RTS

ExecLibraryBase         DC.L    0
DosLibraryBase          DC.L    0
FileInfoBlockAddress    DC.L    0
FileLockAddress         DC.L    0

ArgumentArray           DCB.L   7,0

DosLibraryName          DC.B    "dos.library",0
FileName                DC.B    "file",0

FormatString            DC.B    10
                        DC.B    "Type: %s",10
                        DC.B    "Name: %s",10
                        DC.B    "Comment: %s",10
                        DC.B    "Size: %ld",10
                        DC.B    "Protection: %s",10
                        DC.B    "Header Block: %ld",10
                        DC.B    "Used Blocks: %ld",10,10,0

TypeFileText            DC.B    "File",0
TypeDirectoryText       DC.B    "Directory",0
ProtectionText          DC.B    "HSPARWED",0
