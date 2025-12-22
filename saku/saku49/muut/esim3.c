#ifdef __amigaos4__
#	define __USE_INLINE__
#endif

#include <proto/exec.h>
#include <proto/ahi.h>

#include <dos/dos.h>

#include <stdio.h>
#include <vorbis/vorbisfile.h>

/*

gcc -o esim3 esim3.c -lvorbisfile -lvorbis -logg -lm

*/

#define SIZE 4096

OggVorbis_File vf;


// Yritä avata Ogg Vorbis -tiedosto
BOOL AvaaOggVorbis(STRPTR filename)
{
    FILE * file = fopen( filename, "rb" );

    if ( !file )
    {
        printf("Ei voi avata %s-tiedostoa\n", filename);
        return FALSE;
    }

    if ( ov_open(file, &vf, NULL, 0) < 0 )
    {
	    printf("Ei tunnisteta %s-tiedostoa Ogg Vorbis -tiedostoksi\n", filename);
        fclose( file );
        return FALSE;
    }

    printf("Tiedosto ok\n");

    return TRUE;
}

int main(int argc, char **argv)
{
    BYTE buffer1[SIZE];
    BYTE buffer2[SIZE];

    if ( ! ( argc == 2 && AvaaOggVorbis( argv[1] ) ) )
    {
        printf("Virhe parametreissa tai tiedostossa\n");
        return 0;
    }

    struct MsgPort * AHImp = CreateMsgPort();

//    SetTaskPri( FindTask(NULL), 30 );

    if ( AHImp )
    {
        struct AHIRequest * AHIio = (struct AHIRequest *) CreateIORequest(AHImp, sizeof(struct AHIRequest) );

        // Tarvitaan toinen IO-pyyntö kaksoispuskurointia varten
        struct AHIRequest * AHIio2 = AllocVec( sizeof(struct AHIRequest), MEMF_ANY );

        if ( AHIio && AHIio2 )
        {
            BYTE AHIDevice = -1;

       	    AHIio->ahir_Version = 4;

       	    if ( ! (AHIDevice = OpenDevice(AHINAME, AHI_DEFAULT_UNIT, (struct IORequest *) AHIio, 0) ) )
            {
                // Aktiivinen (active) pyyntö on se, jota käsitellään joka kierroksella.
                struct AHIRequest *active;

                // Vanhentunut (old) pyyntö on edellinen pyyntö
				struct AHIRequest *old = NULL;

                BOOL music_left = TRUE;

                // Puskurilippu, voi olla 0 tai 1
                LONG which = 0;

                // Osoitin aktiiviseen puskuriin
				BYTE * buf;

	            // Kopioi IO-pyynnön sisältö toiseen (täytyy tehdä vasta OpenDevice()-kutsun jälkeen!)
    	        CopyMem( AHIio, AHIio2, sizeof(struct AHIRequest) );

                // Dekoodaa ja soittele Ogg Vorbista niin kauan kuin riittää
                while (music_left)
                {
                    // puskurin vapaana olevan tilan määrä, alussa aina 4096 tavua
                    LONG missing = SIZE;

                    // ilmaisee onko puskurissa vapaata tilaa
                    BOOL done = FALSE;

                    // Valitse puskuri ja pyyntö kaksoispuskurointia varten
                    which ^= 1;

                    buf = which ? buffer1 : buffer2;

                	active = which ? AHIio : AHIio2;

                    while ( ! done )
                    {
                    	int bitstream = 0;
                        LONG bytes = ov_read( &vf, buf, missing, 1, 2, 1, &bitstream );

                        if ( bytes <= 0 )
                        {
                            // jos musiikki loppuu kesken, lopeta
                            music_left = FALSE;
                            done = TRUE;
                        }
                        else
                        {
                            missing -= bytes;
                            buf += bytes;

                            // puskuri on tullut täyteen, lopeta
                            if ( missing <= 0 )
                            {
                            	done = TRUE;
                            }
                        }
                    }

                    if ( missing < SIZE )
                    {
                        active->ahir_Std.io_Command = CMD_WRITE;
                    	active->ahir_Std.io_Data = which ? buffer1 : buffer2;
                    	active->ahir_Std.io_Length = SIZE;
                    	active->ahir_Std.io_Offset = 0;
                    	active->ahir_Type = AHIST_S16S; // 16-bit stereo
                    	active->ahir_Frequency = 44100;
                    	active->ahir_Volume = 0x10000;
                    	active->ahir_Position = 0x8000;
                    	active->ahir_Link = old; // Linkitä pyynnöt yhteen

                        // Work around kaksoispuskurointiongelmaan: jos edellinen pyyntö on jo päättynyt,
                        // aloita kaksoispuskurointi uudelleen
		                if ( old && CheckIO( (struct IORequest*) old ) )
        		        {
                		    WaitIO( (struct IORequest*) old );
                    		old = NULL;
                            which = 0;
                    		continue;
		                }

                        // Soita ääninäyte
                        SendIO( (struct IORequest*) active );

                        if ( old )
                        {
		                    ULONG signals = Wait(SIGBREAKF_CTRL_C | (1L << AHImp->mp_SigBit));

                            // Tarkista Control-C
        		            if ( signals & SIGBREAKF_CTRL_C )
                		    {
                    			break;
		                    }

                            // Odota, että vanha pyyntö on toteutettu ja keskeytä jos virhe
        		            if ( WaitIO( (struct IORequest*) old ))
                		    {
                        		break;
		                    }
                        }

                        // Tee aktiivisesta IO-pyynnöstä "uusi" vanha pyyntö, johon linkitetään seuraava IO-pyyntö jne.
                        old = active;
                    }

                } // while


                // Tarkista ovatko IO-pyynnöt kesken, jos ovat niin keskeytä ne
                if ( ! CheckIO( (struct IORequest *) AHIio ) )
                {
                    AbortIO( (struct IORequest*) AHIio );
                    WaitIO( (struct IORequest*) AHIio );
                }

                if ( ! CheckIO( (struct IORequest *) AHIio2 ) )
                {
                    AbortIO( (struct IORequest*) AHIio2 );
                    WaitIO( (struct IORequest*) AHIio2 );
                }

                // Sulje AHI
                CloseDevice( (struct IORequest*) AHIio );
            }

        }

        if ( AHIio )
        {
            // Poista IO-pyyntö
            DeleteIORequest( (struct IORequest*) AHIio );
            AHIio = NULL;
        }

        // Vapauta 2. pyynnölle varattu muisti
        if ( AHIio2 )
        {
            FreeVec( AHIio2 );
            AHIio2 = NULL;
        }

        // Poista viestiportti
        DeleteMsgPort( AHImp );
        AHImp = NULL;
    }

    ov_clear( &vf ); // fclose():a ei tarvitse kutsua erikseen

	return 0;
}
