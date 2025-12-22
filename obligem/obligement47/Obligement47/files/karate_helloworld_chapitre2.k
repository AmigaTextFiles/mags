<KIMG> fond | data/realeyez.iff </KIMG>

<KIMG> fantome | data/ghost1.iff </KIMG>

<KIMG> texture | data/texture1.iff </KIMG>

<KDBM> module | data/chiptune.dbm </KDBM>

<KTABLE> fadeout | 0,1 | 899,1 | 999,0 </KTABLE>

<KCOLORTABLE> coltab0255 | data/remaptable.iff | 0 | 255 | 255 | 255 </KCOLORTABLE>

<KIMG> ghost64 | data/lightghost.iff </KIMG>

<KPART>
	<ID> premiere </ID>

	<FX>
		<PA> PlayDBM </PA>
		<PA> module </PA>
	</FX>

	<FX>
		<PA> SpritePlain </PA>
		<PA> </PA>	Rectangle par défaut
		<PA> fond </PA>
		<PA> CTE | 0 </PA>
		<PA> CTE | 0 </PA>
		<PA> CTE | 1 </PA>
		<PA> CTE | 1 </PA>
	</FX>

	<FX>
		<PA> Sprite </PA>
		<PA> </PA>	Rectangle par défaut
		<PA> fantome </PA>
		<PA> BOUNCE | 0 | 200 | 500 | -0.3 | 0.15 </PA>
		<PA> CTE | 0 </PA>
		<PA> BOUNCE | 0 | 200 | 500 | -0.1 | 0.35 </PA>
		<PA> CTE | 0.26 </PA>
	</FX>

	<FX>
		<PA> SetPalette </PA>
		<PA> fond </PA>
	</FX>

</KPART>

<KSCRIPT>
	<ID> script </ID>
	< PLAY> premiere | 1000 | 0 | 1 </PLAY>
	<PLAY> deuxieme | 1000 | 0 | 1 </PLAY>

</KSCRIPT>

<MAIN> script | 0 | 1 </ID>

<KPART>
	<ID> deuxieme </ID>

	<FX>
		<PA> DBMVol </PA>
		<PA> spl | fadeout | 0 | 0 </PA>
	</FX>

	<FX>
		<PA> SetPalette </PA>
		<PA> texture </PA>
	</FX>

	<FX>
		<PA> Twirl </PA>
		<PA> </PA>
		<PA> texture </PA>
	
		<PA> SIN | 0 | 1 | 0.25 </PA>	Décalage en X
		<PA> COS | 0 | 1 | 0.25 </PA> 	Décalage en Y

		<PA> CTE | 0 </PA>	start angle
		<PA> CTE | 0 </PA>	amp. angle
		<PA> CTE | 0 </PA>	freq angle

		<PA> SIN | 0 | 0.1 | 0.2 </PA>	start dist.
		<PA> CTE | 0.4 </PA>	amp.dist
		<PA> CTE | 16 </PA>	freq dist

		<PA> CTE | 0 </PA> mapping type
	</FX>

	< FX>
		<PA> MotionBlur </PA>
		<PA> </PA>
		<PA> coltab0255 </PA>
	</FX>

	<FX>
		<PA> RadialBlur </PA>
		<PA> </PA>
		<PA> coltab0255 </PA>
		<PA> 2CTE | 0.5 | 0.5 </PA>
		<PA> SIN | 0.5 | 0.05 | 0.4 </PA>
		<PA> SIN | 0.5 | 0.05 | 0.4 </PA>
		< PA> 2CTE | 1 | 1 </PA>
	</FX>

	< FX>
		<PA> Sprite </PA>
		<PA> </PA>
		<PA> fantome </PA>
		<PA> RND | 0.395 | 0.405 </PA>
		<PA> RND | 0.365 | 0.375 </PA>
		<PA> RND | 0.595 | 0.605 </PA>
		<PA> RND | 0.625 | 0.635 </PA>
	</FX>

	<FX>
		<PA> SpriteTable </PA>
		<PA> </PA>
		<PA> fantome </PA>
		<PA> RND | 0.395 | 0.405 </PA>
		<PA> RND | 0.365 | 0.375 </PA>
		<PA> RND | 0.595 | 0.605 </PA>
		<PA> RND | 0.625 | 0.635 </PA>
		<PA> coltab0255 </PA>
	</FX>

	<FX>
		<PA> SpriteLight </PA>
		<PA> </PA>
		<PA> ghost64 </PA>
		<PA> COS | 0.45 | 0.1 | 0.4 </PA>
		<PA> SIN | 0.45 | 0.1 | 0.4 </PA>
		<PA> COS | 0.55 | 0.1 | 0.4 </PA>
		<PA> SIN | 0.55 | 0.1 | 0.4 </PA>
		<PA> coltab0255 </PA>
		<PA> SIN | 0.5 | 1 | 0.4 </PA>
	</FX>

</KPART>
