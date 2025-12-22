/* Simple example and test program to demonstrate use of template Listview
   class */

#define MUIPP_DEBUG         // Turn debugging mode on for invalid use of classes
//#define MUIPP_NOINLINES       // No inlines makes code compile quicker but the resulting
                            // executable is larger and slower. Best to use this
                            // option when developing and turn off for final release.
#define MUIPP_TEMPLATES     // Allows use of MUI template classes

// This is the main C++ header file

#include <libraries/mui.hpp>

#include <inline/exec.h>

// These objects are inserted directly into the listview. Using template
// listview means that the objects are retrieved and inserted as Person
// objects (ie there is no need to convert to/from void *).


class Person
{
public:
    Person (const char *_name)
    {
        name = (char *)_name;
    }

    char *name;
};




typedef unsigned long (*HookFunction)();

struct UtilityBase *UtilityBase = NULL;
struct IntuitionBase *IntuitionBase = NULL;
struct Library *MUIMasterBase = NULL;



// Hook function to display Person object in listview


void DisplayPerson2 (void)
{
    register Person* a1 __asm("a1");
    Person* person=a1;

    register char** a2 __asm("a2");
    char** column=a2;

    static  char buf2[20],buf1[20];

    strcpy(buf2,person->name);
    sprintf(buf1,"%ld",(column[-1]+1));


    *column++ = buf1;
    *column   = buf2;
    return;
}

void DisplayPerson1 (void)
{
    register Person* a1 __asm("a1");
    Person* person=a1;

    register char** a2 __asm("a2");
    char** column=a2;

    static  char buf[20];

    strcpy(buf,person->name);


    *column = buf;
    return;
}


struct Hook displayHook2 = {{NULL, NULL}, (HookFunction)DisplayPerson2, NULL, NULL};
struct Hook displayHook1 = {{NULL, NULL}, (HookFunction)DisplayPerson1, NULL, NULL};


// Hier die "normale" C++-Version

void ChangeList (void)
{
    register CTMUI_Listview<Person>* a2 __asm("a2");
    CTMUI_Listview<Person>* liste=a2;


    if (liste->Format()!="BAR,")
      {
        liste->SetDisplayHook(&displayHook2);
        liste->SetFormat("BAR,");
      }
    else
      {
        liste->SetDisplayHook(&displayHook1);
        liste->SetFormat("");
      }
}


// Hier die gcc-Version

/*
void ChangeList (void)
{
    register CTMUI_Listview<Person>* a2 __asm("a2");
    CTMUI_Listview<Person>* liste=a2;


    char* list_format;

    GetAttr(MUIA_List_Format,(Tag)liste,(ULONG)&list_format);

    if (list_format!="BAR,")
      {
        SetAttrs((Tag)liste,MUIA_List_DisplayHook,(ULONG)&displayHook2,TAG_DONE);
        SetAttrs((Tag)liste,MUIA_List_Format,(ULONG)"BAR,",TAG_DONE);
      }
    else
      {
        SetAttrs((Tag)liste,MUIA_List_DisplayHook,(ULONG)&displayHook1,TAG_DONE);
        SetAttrs((Tag)liste,MUIA_List_Format,(ULONG)"",TAG_DONE);
      }

}
*/

struct Hook changeListHook = {{NULL, NULL}, (HookFunction)ChangeList, NULL, NULL};



// Although the listview is passed by value it is actually passed by reference
// always. This is because the class is only a wrapper to the BOOPSI class
// and only has one attribute - the BOOPSI object pointer. Hence, it is the
// equivalent of passing an Object * on the stack.

void
PrintPersonList (CTMUI_Listview<Person> list)
{
    // You can use Length() or Entries() to get the length of a list

    int numPeople = list.Length();

    printf ("Number of people in list = %d\n", numPeople);

    // You can treat Listviews just like arrays!!

    for (int i = 0; i < numPeople; i++)
    {
        printf ("%d %s\n", i, list[i].name);
    }
}




int
main (void)
{


    // Open libraries required

    if ((IntuitionBase = (struct IntuitionBase *)OpenLibrary ("intuition.library", 0)) == NULL)
    {
        printf ("Could not open intuition.library\n");
        return 10;
    }

    if ((MUIMasterBase = OpenLibrary ("muimaster.library", 0)) == NULL)
    {
        printf ("Could not open muimaster.library\n");
        return 10;
    }

    // Declare template Listview of type Person to display list of people
    // NOTE: This does no initialization, it's just a declaration.

    CTMUI_Listview<Person> list;

    CMUI_Window window;

    CMUI_Slider mySlider (MUIA_Numeric_Min, 0,MUIA_Numeric_Max, 100,MUIA_Numeric_Value,30,TAG_DONE);

    CMUI_Button myButton ("_Ok");

    // Create Application object. I am not using any shortcuts here to create
    // the objects. I actually prefer the layout like this than when using
    // shortcuts. If you prefer the old way of creating objects by using the
    // shortcuts then you can still do this. See the shortcuts.cpp example
    // for details as some shortcuts have had to change name so as not to clash
    // with class member functions.

    CMUI_Application app
    (
        MUIA_Application_Title,         "TListview",
        MUIA_Application_Author,        "Nicholas Allen",
        MUIA_Application_Base,          "TEST",
        MUIA_Application_Copyright,     "AllenSoft",
        MUIA_Application_Description,   "Test Program For Template Listview class",
        MUIA_Application_Version,       "$VER: Test 1.0 (17.9.96)",
        SubWindow, window = CMUI_Window
        (
            MUIA_Window_Title, "Test Program For Template Listview class",
            MUIA_Window_ID, 10,
            WindowContents, CMUI_VGroup
            (
                Child, list = CTMUI_Listview<Person>
                (
                    MUIA_Listview_List, CMUI_List
                    (
                        MUIA_List_DisplayHook, &displayHook1,
                        InputListFrame,
                        TAG_DONE
                    ),
                    MUIA_CycleChain, 1,
                    MUIA_ShortHelp, "Listview created using templates!!",
                    TAG_DONE
                ),

                Child, mySlider,Child, myButton,
                TAG_DONE
            ),
            TAG_DONE
        ),
        TAG_DONE        // Don't forget these if you're not using shortcuts!
    );

    // Any MUI object created as a C++ class can be tested for validity by
    // calling its IsValid() method. This method just checks that the
    // BOOPSI object pointer is not NULL.

    if (!app.IsValid())
    {
        printf ("Could not create application!\n");
        return 10;
    }

    // Insert some new people into the listview!!

    list.InsertBottom(new Person ("Nick"));
    list.InsertBottom(new Person ("Dom"));
    list.InsertBottom(new Person ("Mart"));
    list.InsertBottom(new Person ("Nicky"));



    // This only copies 4 bytes onto stack!! It is the same as passing a
    // BOOPSI Object *

    PrintPersonList (list);

    // Setup close window notification.
    // Because Notify() is a variable args method we have to pass sva as the
    // first parameter. Failing to do this will result in an error at
    // COMPILE time so there won't be any weird crashes by forgetting to do
    // this.


//*    myButton.Notify(sva, MUIA_Pressed, false,
//*                    list, 3,MUIM_CallHook, &changeListHook, list);

    myButton.Notify(sva, MUIA_Pressed, false,
                    list, 2,MUIM_CallHook, &changeListHook);


    window.Notify(sva, MUIA_Window_CloseRequest, TRUE,
                  app, 2, MUIM_Application_ReturnID, MUIV_Application_ReturnID_Quit);

    window.SetOpen(TRUE);


    list.InsertBottom(new Person ("Stephan"));



    ULONG sigs = 0;
    BOOL running = TRUE;

    while (running)
    {
        switch (app.NewInput(&sigs))
        {
            case MUIV_Application_ReturnID_Quit:
                running = FALSE;
            break;
        }

        if (sigs)
        {
            sigs = Wait (sigs | SIGBREAKF_CTRL_C);
            if (sigs & SIGBREAKF_CTRL_C) break;
        }
    }

    // This disposes of the application and all windows and objects in the
    // windows.

    app.Dispose();

    CloseLibrary ((struct Library *)IntuitionBase);
    CloseLibrary (MUIMasterBase);

    return 0;
}
