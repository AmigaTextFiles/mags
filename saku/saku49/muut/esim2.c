#ifdef __amigaos4__
#	define __USE_INLINE__
#endif

#include <proto/exec.h>
#include <proto/ahi.h>

#include <math.h> // sin(), M_PI

/*

gcc -o esim2 esim2.c -lm

*/

#define SIZE 360*10

int main(void)
{
    BYTE buffer[SIZE];

    WORD i = 0;

    // Generoi siniaaltoa
    while (i < SIZE)
    {
        buffer[i] = 127 * sin( i * (M_PI/180) * 10 );
        i++;
    }

    struct MsgPort * AHImp = CreateMsgPort();

    if ( AHImp )
    {
        struct AHIRequest * AHIio = (struct AHIRequest *) CreateIORequest(AHImp, sizeof(struct AHIRequest) );

        if ( AHIio )
        {
       	    AHIio->ahir_Version = 4;

            BYTE AHIDevice = -1;

       	    if ( ! (AHIDevice = OpenDevice(AHINAME, AHI_DEFAULT_UNIT, (struct IORequest *) AHIio, 0) ) )
            {
           		AHIio->ahir_Std.io_Command = CMD_WRITE;
            	AHIio->ahir_Std.io_Data = buffer; // ääninäytteen alku
            	AHIio->ahir_Std.io_Length = SIZE; // ääninäytteen kesto
            	AHIio->ahir_Std.io_Offset = 0;
            	AHIio->ahir_Type = AHIST_M8S; // 8-bittinen mono
            	AHIio->ahir_Frequency = 8000; // soita 8KHz taajuudellaa
            	AHIio->ahir_Volume = 0x10000; // täysi äänenvoimakkuus
            	AHIio->ahir_Position = 0x8000;
            	AHIio->ahir_Link = NULL;

                // Lähetä IO-pyyntö ja jää odottamaan
                DoIO( (struct IORequest*) AHIio );

                // Sulje AHI
                CloseDevice( (struct IORequest*) AHIio );
            }

            // Poista IO-pyyntö
            DeleteIORequest( (struct IORequest*) AHIio );

        }

        // Poista viestiportti
        DeleteMsgPort( AHImp );
    }

	return 0;
}
