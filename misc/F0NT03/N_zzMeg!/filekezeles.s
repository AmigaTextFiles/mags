; Ezekre az include fájlokra van szükség, hogy le lehessen forditani a
; forrást. Mindenki állítsa be magának úgy, ahogy nála találhatóak.

                        INCLUDE "lvos/exec_lib.i"
                        INCLUDE "lvos/dos_lib.i"
                        INCLUDE "exec/memory.i"
                        INCLUDE "dos/dos.i"

; Az exec.library címének a tárolása ajánlott, mivel igy fast RAM-os gépeken
; nem kell mindig a chip RAM-ból kiolvasni, ami által a program valamivel
; gyorsabb lesz.

Main                    MOVE.L  (4).W,(ExecLibraryBase)

; Megnyitjuk a dos.library-t.

                        LEA     (DosLibraryName,PC),A1
                        MOVEQ   #33,D0
                        MOVE.L  (ExecLibraryBase,PC),A6
                        JSR     (_LVOOpenLibrary,A6)
                        MOVE.L  D0,(DosLibraryBase)
                        BEQ     .1

; Megnyitjuk a fájlt, amelynek a nevét már remélhetõleg mindenki átírta egy
; nála valóban létezõre.

                        MOVE.L  #FileName,D1
                        MOVE.L  #MODE_OLDFILE,D2
                        MOVE.L  (DosLibraryBase,PC),A6
                        JSR     (_LVOOpen,A6)
                        MOVE.L  D0,(FileHandleAddress)
                        BEQ     .2

; A fájl méretének meghatározásához egy kis trükkhöz folyamodunk, amelyhez a
; Dos/Seek-et használjuk. 

                        MOVE.L  (FileHandleAddress,PC),D1
                        MOVEQ   #0,D2
                        MOVEQ   #OFFSET_END,D3
                        MOVE.L  (DosLibraryBase,PC),A6
                        JSR     (_LVOSeek,A6)
                        CMP.L   #-1,D0
                        BEQ     .3

                        MOVE.L  (FileHandleAddress,PC),D1
                        MOVEQ   #0,D2
                        MOVEQ   #OFFSET_BEGINNING,D3
                        MOVE.L  (DosLibraryBase,PC),A6
                        JSR     (_LVOSeek,A6)
                        CMP.L   #-1,D0
                        BEQ     .3
                        MOVE.L  D0,(FileSize)

; Memóriafoglalás a fájl tartalmának beolvasásához.

                        MOVE.L  (FileSize,PC),D0
                        MOVEQ   #MEMF_ANY,D1
                        MOVE.L  (ExecLibraryBase,PC),A6
                        JSR     (_LVOAllocMem,A6)
                        MOVE.L  D0,(FileBufferAddress)
                        BEQ     .3

; A fájl tartalmának beolvasása a lefoglalt memóriába.

                        MOVE.L  (FileHandleAddress,PC),D1
                        MOVE.L  (FileBufferAddress,PC),D2
                        MOVE.L  (FileSize,PC),D3
                        MOVE.L  (DosLibraryBase,PC),A6
                        JSR     (_LVORead,A6)
                        CMP.L   D3,D0
                        BNE     .4

; Az éppen beolvasott adatokat visszaírjuk a fájl végére. Szerencsére a fájl
; pozició mutatója már pont a fájl végére mutat.

                        MOVE.L  (FileHandleAddress,PC),D1
                        MOVE.L  (FileBufferAddress,PC),D2
                        MOVE.L  (FileSize,PC),D3
                        MOVE.L  (DosLibraryBase,PC),A6
                        JSR     (_LVOWrite,A6)
                        CMP.L   D3,D0
                        BNE     .4

; A lefoglalt memória felszabadítása.

.4                      MOVE.L  (FileBufferAddress,PC),A1
                        MOVE.L  (FileSize,PC),D0
                        MOVE.L  (ExecLibraryBase,PC),A6
                        JSR     (_LVOFreeMem,A6)

; Lezárjuk a fájlt.

.3                      MOVE.L  (FileHandleAddress,PC),D1
                        MOVE.L  (DosLibraryBase,PC),A6
                        JSR     (_LVOClose,A6)

; Lezárjuk a dos.library-t.

.2                      MOVE.L  (DosLibraryBase,PC),A1
                        MOVE.L  (ExecLibraryBase,PC),A6
                        JSR     (_LVOCloseLibrary,A6)

; Akár történt hiba, akár nem, úgy teszünk, mintha semmi gond sem lett volna.

.1                      MOVEQ   #RETURN_OK,D0
                        RTS

ExecLibraryBase         DC.L    0
DosLibraryBase          DC.L    0
FileHandleAddress       DC.L    0
FileSize                DC.L    0
FileBufferAddress       DC.L    0

DosLibraryName          DC.B    "dos.library",0
FileName                DC.B    "file",0
