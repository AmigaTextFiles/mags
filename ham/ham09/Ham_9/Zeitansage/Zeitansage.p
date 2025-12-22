PROGRAM Zeitansage;

USES Exec, ExecIO;

{$Include "Devices/Narrator.h"}
{$Include "Devices/Timer.h"}
{$opt b-}

CONST version = '$VER: Zeitansage 1.0 (17.9.93)';

CONST
  TEXT_VOR = 'BAY2M  NAE4/CSTEHN  TOH4N  IX3ST  EH2S';
  TEXT_EIN = 'AY4N';
  TEXT_0 = 'NUH4L';
  TEXT_1 = 'AY4NEH';
  TEXT_2 = 'TSWAY4';
  TEXT_3 = 'DRAY4';
  TEXT_4 = 'FIY4R';
  TEXT_5 = 'FAH4NF';
  TEXT_6 = 'ZEH4KS';
  TEXT_7 = 'ZIY4BEHN';
  TEXT_8 = 'AA4/CT';
  TEXT_9 = 'NOY4N';
  TEXT_10 = 'TSEH4N';
  TEXT_11 = 'EH4LF';
  TEXT_12 = 'TSWER4LF';
  TEXT_13 = 'DRAY4TSEH4N';
  TEXT_14 = 'FIY4RTSEH4N';
  TEXT_15 = 'FAH4NFTSEH4N';
  TEXT_16 = 'ZEH4CHTSEH4N';
  TEXT_17 = 'SIY3BTSEH4N';
  TEXT_18 = 'AA4/CTTSEH4N';
  TEXT_19 = 'NOY4NTSEH4N';
  TEXT_20 = 'TSWAH4NTSIHG';
  TEXT_21 = 'AY4NUH1ND TSWAH3NTSIHG';
  TEXT_22 = 'TSWAY4UH1ND TSWAH3NTSIHG';
  TEXT_23 = 'DRAY4UH1ND TSWAH3NTSIHG';
  TEXT_24 = 'FIY4RUH1ND TSWAH3NTSIHG';
  TEXT_25 = 'FAH4NFUH1ND TSWAH3NTSIHG';
  TEXT_26 = 'ZEH4KSUH1ND TSWAH3NTSIHG';
  TEXT_27 = 'ZIY4BEHNUH1ND TSWAH3NTSIHG';
  TEXT_28 = 'AA4/CTUH1ND TSWAH3NTSIHG';
  TEXT_29 = 'NOY4NUH1ND TSWAH3NTSIHG';
  TEXT_30 = 'DRAY4SIHG';
  TEXT_31 = 'AY4NUH1NDRAY3SIHG';
  TEXT_32 = 'TSWAY4UH1NDRAY3SIHG';
  TEXT_33 = 'DRAY4UH1NDRAY3SIHG';
  TEXT_34 = 'FIY4RUH1NDRAY3SIHG';
  TEXT_35 = 'FAH4NFUH1NDRAY3SIHG';
  TEXT_36 = 'ZEH4KSUH1NDRAY3SIHG';
  TEXT_37 = 'ZIY4BEHNUH1NDRAY3SIHG';
  TEXT_38 = 'AA4/CTUH1NDRAY3SIHG';
  TEXT_39 = 'NOY4NUH1NDRAY3SIHG';
  TEXT_40 = 'FIH4ERTSIHG';
  TEXT_41 = 'AY4NUH1ND FIH3ERTSIHG';
  TEXT_42 = 'TSWAY4UH1ND FIH3ERTSIHG';
  TEXT_43 = 'DRAY4UH1ND FIH3ERTSIHG';
  TEXT_44 = 'FIY4RUH1ND FIH3ERTSIHG';
  TEXT_45 = 'FAH4NFUH1ND FIH3ERTSIHG';
  TEXT_46 = 'ZEH4KSUH1ND FIH3ERTSIHG';
  TEXT_47 = 'ZIY4BEHNUH1ND FIH3ERTSIHG';
  TEXT_48 = 'AA4/CTUH1ND FIH3ERTSIHG';
  TEXT_49 = 'NOY4NUH1ND FIH3ERTSIHG';
  TEXT_50 = 'FAH4NFTSIHG';
  TEXT_51 = 'AY4NUH1ND FAH3NFTSIHG';
  TEXT_52 = 'TSWAY4UH1ND FAH3NFTSIHG';
  TEXT_53 = 'DRAY4UH1ND FAH3NFTSIHG';
  TEXT_54 = 'FIY4RUH1ND FAH3NFTSIHG';
  TEXT_55 = 'FAH4NFUH1ND FAH3NFTSIHG';
  TEXT_56 = 'ZEH4KSUH1ND FAH3NFTSIHG';
  TEXT_57 = 'ZIY4BEHNUH1ND FAH3NFTSIHG';
  TEXT_58 = 'AA4/CTUH1ND FAH3NFTSIHG';
  TEXT_59 = 'NOY4NUH1ND FAH3NFTSIHG';
  TEXT_UHR = 'UW4ER';
  TEXT_MINUTE = 'MIHNUH6DXTEH';
  TEXT_MINUTEN = 'MIHNUH6DXTEHN';
  TEXT_UND = 'UH1ND';
  TEXT_SEKUNDE = 'SEHKUH4NDEH.';
  TEXT_SEKUNDEN = 'SEHKUH4NDEHN.';
  TEXT_PIEP = 'IY9';

TYPE zahlentyp = ARRAY [0 .. 59] OF STRING [40];

VAR nport: p_MsgPort;
    nio: p_narrator_rb;
    aud_ChanMasks: ARRAY [0 .. 3] OF BYTE;
    time: timeval;
    zahlen: zahlentyp;

PROCEDURE GetTime;
  VAR tport: p_MsgPort;
      tio: p_timerequest;
      d: BYTE;
  BEGIN
    time := timeval (0, 0);
                             { Fehlerbehandlung übernimmt das Laufzeitsystem }
    tport := CreatePort (NIL, 0);
    tio := CreateExtIO (tport, SizeOf (timerequest));
    Open_Device ('timer.device', UNIT_VBLANK, Ptr (tio), 0);
    tio^.tr_node.io_Command := TR_GETSYSTIME;
    tio^.tr_node.io_Flags := IOF_QUICK;
    d := DoIO (Ptr (tio));
    time.tv_secs := tio^.tr_time.tv_secs + 10;
    Close_Device (Ptr (tio));
    DeleteExtIO (tio);
    DeletePort (tport);
  END; { GetTime }

PROCEDURE WaitTime;
  VAR tport: p_MsgPort;
      tio: p_timerequest;
      d: BYTE;
  BEGIN
                             { Fehlerbehandlung übernimmt das Laufzeitsystem }
    tport := CreatePort (NIL, 0);
    tio := CreateExtIO (tport, SizeOf (timerequest));
    Open_Device ('timer.device', UNIT_WAITUNTIL, Ptr (tio), 0);
    tio^.tr_node.io_Command := TR_ADDREQUEST;
    tio^.tr_time := time;
    d := DoIO (Ptr (tio));
    Close_Device (Ptr (tio));
    DeleteExtIO (tio);
    DeletePort (tport);
  END; { WaitTime }

PROCEDURE SageVorText;
  VAR s: Str;
      d: BYTE;
  BEGIN
    s := TEXT_VOR;
    nio^.message.io_Command := CMD_WRITE;
    nio^.message.io_Data := Ptr (s);
    nio^.message.io_Length := Length (s);
    nio^.rate := DEFRATE;
    nio^.pitch := DEFPITCH;
    nio^.mode := DEFMODE;
    nio^.sex := DEFSEX;
    nio^.volume := DEFVOL;
    nio^.sampfreq := DEFFREQ;
    nio^.mouths := 0;
    d := DoIO (Ptr (nio));
  END; { SageVorText }

PROCEDURE SageStunden (st: INTEGER);
  VAR s: STRING [255];
      d: BYTE;
  BEGIN
    s := zahlen [st] + '  ' + TEXT_UHR;
    nio^.message.io_Command := CMD_WRITE;
    nio^.message.io_Data := Ptr (^s);
    nio^.message.io_Length := Length (s);
    d := DoIO (Ptr (nio));
  END; { SageStunden }

PROCEDURE SageMinuten (min: INTEGER);
  VAR s: STRING [255];
      d: BYTE;
  BEGIN
    IF min = 1 THEN
      s := TEXT_1 + '  ' + TEXT_MINUTE
    ELSE
      s := zahlen [min] + '  ' + TEXT_MINUTEN;
    nio^.message.io_Command := CMD_WRITE;
    nio^.message.io_Data := Ptr (^s);
    nio^.message.io_Length := Length (s);
    d := DoIO (Ptr (nio));
  END; { SageMinuten }

PROCEDURE SageSekunden (sek: INTEGER);
  VAR s: STRING [255];
      d: BYTE;
  BEGIN
    IF sek = 1 THEN
      s := TEXT_UND + TEXT_1 + '  ' + TEXT_SEKUNDE
    ELSE
      s := TEXT_UND + zahlen [sek] + '  ' + TEXT_SEKUNDEN;
    nio^.message.io_Command := CMD_WRITE;
    nio^.message.io_Data := Ptr (^s);
    nio^.message.io_Length := Length (s);
    d := DoIO (Ptr (nio));
  END; { SageSekunden }

PROCEDURE ErzeugeTon;
  VAR s: Str;
      d: BYTE;
  BEGIN
    s := TEXT_PIEP;
    nio^.message.io_Command := CMD_WRITE;
    nio^.message.io_Data := Ptr (s);
    nio^.message.io_Length := Length (s);
    nio^.rate := DEFRATE;
    nio^.pitch := MAXPITCH;
    nio^.mode := DEFMODE;
    nio^.sex := FEMALE;
    nio^.volume := DEFVOL;
    nio^.sampfreq := DEFFREQ;
    nio^.mouths := 0;
    d := DoIO (Ptr (nio));
  END; { ErzeugeTon }

PROCEDURE doit;
 VAR i:BYTE;
  BEGIN
    zahlen := zahlentyp (TEXT_0,  TEXT_EIN,  TEXT_2,  TEXT_3,  TEXT_4,
                         TEXT_5,  TEXT_6,  TEXT_7,  TEXT_8,  TEXT_9,
                         TEXT_10, TEXT_11, TEXT_12, TEXT_13, TEXT_14,
                         TEXT_15, TEXT_16, TEXT_17, TEXT_18, TEXT_19,
                         TEXT_20, TEXT_21, TEXT_22, TEXT_23, TEXT_24,
                         TEXT_25, TEXT_26, TEXT_27, TEXT_28, TEXT_29,
                         TEXT_30, TEXT_31, TEXT_32, TEXT_33, TEXT_34,
                         TEXT_35, TEXT_36, TEXT_37, TEXT_38, TEXT_39,
                         TEXT_40, TEXT_41, TEXT_42, TEXT_43, TEXT_44,
                         TEXT_45, TEXT_46, TEXT_47, TEXT_48, TEXT_49,
                         TEXT_50, TEXT_51, TEXT_52, TEXT_53, TEXT_54,
                         TEXT_55, TEXT_56, TEXT_57, TEXT_58, TEXT_59);
    GetTime;
    SageVorText;
    SageStunden ((time.tv_secs DIV 3600) MOD 24);
    SageMinuten ((time.tv_secs DIV 60) MOD 60);
    SageSekunden (time.tv_secs MOD 60);
    WaitTime;
    ErzeugeTon;
  END; { doit }

BEGIN
                             { Fehlerbehandlung übernimmt das Laufzeitsystem }
  nport := CreatePort (NIL, 0);
  nio := CreateExtIO (nport, SizeOf (narrator_rb));
  aud_ChanMasks [0] := 3;
  aud_ChanMasks [1] := 5;
  aud_ChanMasks [2] := 10;
  aud_ChanMasks [3] := 12;
  nio^.ch_masks := ^aud_ChanMasks;
  nio^.nm_masks := SizeOf (aud_ChanMasks);
  Open_Device ('narrator.device', 0, Ptr (nio), 0);
  doit;
  Close_Device (Ptr (nio));
  DeleteExtIO (nio);
  DeletePort (nport);
END. { Zeitansage }

