#ifdef __amigaos4__
#	define __USE_INLINE__
#endif

#include <proto/exec.h>
#include <proto/ahi.h>

/*

gcc -o esim1 esim1.c

*/

int main(void)
{
    // Luo viestiportti IO-pyyntöä varten
    struct MsgPort * AHImp = CreateMsgPort();

    if ( AHImp )
    {
        struct AHIRequest * AHIio = (struct AHIRequest *) CreateIORequest(AHImp, sizeof(struct AHIRequest) );

        if ( AHIio )
        {
       	    AHIio->ahir_Version = 4;  /* Haluamme vähintään version 4 */

            BYTE AHIDevice = -1;

            // Yritä avata ahi.device
       	    if ( ! (AHIDevice = OpenDevice(AHINAME, AHI_DEFAULT_UNIT, (struct IORequest *) AHIio, 0) ) )
            {

            	// Nyt voimme käyttää AHIa...


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
