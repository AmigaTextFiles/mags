#include <mui_header.h> // must be copied from 'demo.h'

Object *app,*window;	// could use APTR, but must use
							// Object * for C++
Object *STR_example;	// For string gadget
Object *CY_example;	// For cycle gadget

static char *CYA_example[] =
{
	"Entry 1","Entry 2","Entry 3",NULL
};

void main()
{
	
	init();	// initialise MUI system
	
	app = ApplicationObject,
		MUIA_Application_Title      , "DC7 Tutorial",
		MUIA_Application_Version    , "$VER: V1.0",
		MUIA_Application_Copyright  , "©1998 Mark Harman (Freely distributable)",
		MUIA_Application_Author     , "Mark Harman",
		MUIA_Application_Description, "Just a small example",
		MUIA_Application_Base       , "DC7TUT1_MUIDEMO",

		SubWindow, window = WindowObject,
			MUIA_Window_Title, "Hello!",
			MUIA_Window_ID   , MAKE_ID('D','E','M','O'),

			WindowContents, VGroup,
				Child, Label("Hello World!"),
				Child, STR_example=String("Type in Here...",32),
				Child, ColGroup(4),
					Child, Label("Box 1"),
					Child, Label("Box 2"),
					Child, Label("Box 3"),
					Child, CY_example=Cycle(CYA_example),
					End,
				End,
			End,
		End;

	if (!app)
		fail(app,"Failed to create Application.");

	// set close gadget to quit
	DoMethod(window,MUIM_Notify,MUIA_Window_CloseRequest,TRUE,
		app,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit);


/*
** This is the ideal input loop for an object oriented MUI application.
** Everything is encapsulated in classes, no return ids need to be used,
** we just check if the program shall terminate.
** Note that MUIM_Application_NewInput expects sigs to contain the result
** from Wait() (or 0). This makes the input loop significantly faster.
*/

	// open window
	set(window,MUIA_Window_Open,TRUE);

	{
		ULONG sigs = 0;

		while (DoMethod(app,MUIM_Application_NewInput,&sigs) != MUIV_Application_ReturnID_Quit)
		{
			if (sigs)
			{
				sigs = Wait(sigs | SIGBREAKF_CTRL_C);
				if (sigs & SIGBREAKF_CTRL_C) break;
			}
		}
	}

	// close window
	set(window,MUIA_Window_Open,FALSE);


/*
** Shut down...
*/

	fail(app,NULL);
}
