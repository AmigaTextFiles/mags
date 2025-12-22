; $VER: rename.bat 1.1 (10.08.99)
IF exists Amigazette:Comp&Gfx
rename Amigazette:Comp&Gfx/C&G-Cap1.html as Amigazette:Comp&Gfx/cg-cap1.html
rename Amigazette:Comp&Gfx as Amigazette:comp_e_gfx
ENDIF

IF exists Amigazette:PATTY.MID 
rename Amigazette:PATTY.MID as Amigazette:midi/patty.mid
ENDIF
