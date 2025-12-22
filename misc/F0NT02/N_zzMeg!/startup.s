; A CLI vagy Shell-bõl indított programok A0-ban kapnak egy mutatót a
; paraméter string-re, amely egy 10-es értékû byte-al van lezárva. D0-ban a
; string hossza található. A paraméterek kiértékelésére viszont ajánlatosabb
; a Dos/ReadArgs rutint használni és ezt a két regisztert béken hagyni. Én
; itt mindenesetre elmentem õket, hogy megmaradjon a tartalmuk, ha esetleg
; késõbb szükség lenne rájuk.

Start                   MOVEM.L D0/A0,-(SP)

; Az exec.library báziscímének kiolvasása, mivel Exec rutinokat fogunk
; használni.

                        MOVE.L  (4).W,A6

; Megkeressük a mutatót a Task struktúránkra, amely valójában egy Process
; struktúra.

                        SUB.L   A1,A1
                        JSR     (_LVOFindTask,A6)
                        MOVE.L  D0,A5

; Itt nézzük meg, hogy a programunk a CLI-bõl vagy a Workbench-rõl lett-e
; indítva. Ha pr_CLI nulla, akkor ikonnal indultunk, másképpen a CLI-bõl.

                        TST.L   (pr_CLI,A5)
                        BNE     .1

; Várunk, míg megérkezik a WBStartup nevû message a process-ünk port-jára.

                        LEA     (pr_MsgPort,A5),A0
                        JSR     (_LVOWaitPort,A6)

; Megjött a WBStartup message és eltávolítjuk a port-ról. Ebbõl lehet
; megtudni, hogy milyen más ikonok voltak kiválasztva a miénkkel együtt és
; ennek a segítségével kaphatjuk meg az ikonok tooltype-jait is.

                        LEA     (pr_MsgPort,A5),A0
                        JSR     (_LVOGetMsg,A6)
                        MOVE.L  D0,(WBStartupAddress)

; A paraméter regiszterek eredeti tartalmának helyreállítása, hogy a
; fõprogramban esetleg ki lehessen értékelni õket.

.1                      MOVEM.L (SP)+,D0/A0

; Itt hívjuk meg a fõprogramot, amely ha szükséges, akkor a WBStartupAddress
; kiolvasásával megtudhatja, hogy CLI-bõl vagy Workbench-rõl indult-e.

                        BSR     Main

; A CLI-s programok a D0-ás regiszterben szoktak egy hibakódot visszaadni,
; amelyet most gyorsan elmentünk. Ez a szám általában 0, 5, 10 vagy 20
; szokott lenni, a hiba súlyosságától függõen. A 0 azt jelenti, hogy nem
; történt semmi hiba.

                        MOVEM.L D0,-(SP)

; Megnézzük, hogy a program eredetileg a CLI-bõl vagy a Workbench-rõl lett-e
; indítva.

                        MOVE.L  (WBStartupAddress,PC),D0
                        BEQ     .2

; A multitasking-ot le kell tiltani, mielõtt válaszolunk a WBStartup
; message-re, mert ahogy a Workbench megkapja a választ, rögtön
; felszabadítja a programunk által foglalt memóriát. Mi ekkor akár felül
; is íródhatunk egy másik program által, amely azonnal lefoglalja és
; feltölti adatokkal a valaha saját memóriánkat.

                        JSR     (_LVOForbid,A6)

; A WBStarup message visszaküldése a Workbench-hez. Mindig a program
; legvégén kell végrehajtani, természetesen egy Forbid után.

                        MOVE.L  (WBStartupAddress,PC),A1
                        JSR     (_LVOReplyMsg,A6)

; A CLI-hez küldendõ hibakód visszahozása.

.2                      MOVEM.L (SP)+,D0

; Sajnos itt vége is van a rutinnak.

                        RTS

; Itt található a WBStartup message címe, ha a Workbench-rõl indultunk,
; amúgy meg nulla.

WBStartupAddress        DC.L    0

