#include <exec/types.h>
#include <intuition/classes.h>
#include <utility/tagitem.h>

/**********************************************/
/* Stub functions to be used in applications. */
/* A call to one function invokes linkage of  */
/* all functions !                            */
/**********************************************/

Object *MUI_NewObjectA      (char *classname,struct TagItem *tags);
Object *MUI_MakeObjectA     (LONG type,ULONG *params);
LONG    MUI_RequestA        (APTR app,APTR win,LONGBITS flags,
                             char *title,char *gadgets,char *format,
                             APTR params);
APTR    MUI_AllocAslRequest (unsigned long reqType,
                             struct TagItem *tagList);
BOOL    MUI_AslRequest      (APTR requester, struct TagItem *tagList);

#pragma amicall(MUIMasterBase,0x1e,MUI_NewObjectA(a0,a1))
#pragma amicall(MUIMasterBase,0x2a,MUI_RequestA(d0,d1,d2,a0,a1,a2,a3))
#pragma amicall(MUIMasterBase,0x30,MUI_AllocAslRequest(d0,a0))
#pragma amicall(MUIMasterBase,0x36,MUI_AslRequest(a0,a1))
#pragma amicall(MUIMasterBase,0x78,MUI_MakeObjectA(d0,a0))

Object *MUI_NewObject(char *classname, Tag tag1, ...)
{
   return(MUI_NewObjectA(classname, (struct TagItem *) &tag1));
}

Object *MUI_MakeObject(LONG type, ULONG arg1, ...)
{
   return(MUI_MakeObjectA(type, &arg1));
}

LONG MUI_Request(APTR app,APTR win,LONGBITS flags,char *title,
                 char *gadgets,char *format, APTR arg1, ...)
{
   return(MUI_RequestA(app, win, flags, title, gadgets, format, &arg1));
}

APTR MUI_AllocAslRequestTags(unsigned long reqType, Tag tag1, ...)
{
   return(MUI_AllocAslRequest(reqType, (struct TagItem *) &tag1));
}

BOOL MUI_AslRequestTags(APTR requester, Tag tag1, ...)
{
   return(MUI_AslRequest(requester, (struct TagItem *) &tag1));
}

