/*  This is a simple multimedia slideshow program.  Requires Multiview. */


/* the following section of code checks to see if the library is open,
   and it attempts to open the library if it is not already open.  If it
   cannot open the library, it will not continue, since the program will
   fail without the library functions available. */
if ~show('l','rexxbgui.library') then do
    /* the numeric parameters for addlib are priority and offset. Priority is
    somewhat arbitrary (between -/+ 100), and offset is specific to each
    library, although I often see -30 used.*/
   if ~addlib('rexxbgui.library',0,-30) then do
      exit(20)
       /* 20 is an error code; you can exit with any value, or none at all. */
   end
end

if ~show('l','rexxsupport.library') then do
   if ~addlib('rexxsupport.library',0,-30) then do
      exit(20)
       /* 20 is an error code; you can exit with any value, or none at all. */
   end
end


/* this section of code loads the settings for the slideshow. */
/* configfile is the name of the file used to store the slideshow settings and
   names of the pictures.*/
configfile="slideshow.prefs"
shows. = ''           /* clear out the entire stem. */
texts. = ''           /* clear out the entire stem. */
curShowIndex = 0      /* keeps track of selection in list of slides */
shows.count = 0
newpath = ""          /* used by the file requester.  see the add button.*/
if exists(configfile) then do
    /* This will only parse the file for content if it exists. */
    open('prefsfile',configfile,'R')
    i=0
    do while EOF('prefsfile')=0
        /* read the filename of each "slide" */
        curshow = readln('prefsfile')
        if length(curshow)>0 then shows.i = curshow
        /* read the title, description, and date for each slide */
        curtitle = readln('prefsfile')
        if length(curtitle)>0 then texts.i.title = curtitle
        curdescription = readln('prefsfile')
        if length(curdescription)>0 then texts.i.description = curdescription
        curdate = readln('prefsfile')
        if length(curdate)>0 then texts.i.date = curdate
        i = i+1
        end
    shows.count = i-1  /* count of entries */
    close('prefsfile')
    end

call bguiopen() /* causes error 12 if it did not work */
/* supply a second argument for a '0' return code instead of an ARexx
   error */

/* the following "signal" statements trap errors */
signal on syntax /* important: bguiclose() MUST be called */
signal on halt
signal on break_c


FixMinSize=bguilayout(LGO_FixMinWidth,1,LGO_FixMinHeight,1)

/* GUI function calls for creating the primary intreface window */
/* All the "GUI" lines are segments of the user interface description.
   Each of these entries is combined into groups, and then into one group
   at the end (called GUIcombined).  The parameters for each of these
   functions are described in the BGUI documentation.  Basically, there are
   GUI elements, groups, and layouts described. in all this.  Note that the
   GUI elements, such as the listview, buttons, and string text field all
   have a name.  BGUI creates a branch on the ubiquitous "obj." stem, based
   on these set names.  */
if (shows.count = 0) then do            /* if the list is empty, don't put
                                           the empty stem down. */
    GUIshowlist=bguilistview('listv',,,'S')
    end
else
    GUIshowlist=bguilistview('listv',,'SHOWS','S')  /* list is not empty. */

GUIlistcontrols=bguivgroup(bguibutton('add','_Add')bguibutton('drp','_Drop')bguibutton('up','_Up')bguibutton('down','D_own'),0,,,'W')FixMinSize
GUItop=bguihgroup(GUIlistcontrols||GUIshowlist,0,,,)
GUItitle=bguistring('title','Title:','',80)
GUIdate=bguistring('date','Date:','12/31/1999',11)bguilayout(LGO_FixMinHeight,1,LGO_FixWidth,120)
GUIcaption=bguihseparator('Description')bguilayout(LGO_FixMinHeight,1)
GUIdescription=bguistring('desc',,'',500)bguilayout(LGO_FixMinHeight,1)
GUIShow=bguihgroup(bguivarspace(50)bguibutton('show','_Show')bguilayout(LGO_FixMinHeight,1)bguivarspace(50))
GUImiddle=bguihgroup(GUItitle||Guidate,0,,,'H')bguilayout(LGO_FixMinHeight,1)
GUIbottom=bguivgroup(GUIcaption||GUIdescription||GUIShow,0,,,)bguilayout(LGO_FixMinHeight,1)

/* this last one is where they are all combined. */
GUIcombined=bguivgroup(GUItop||GUImiddle||GUIbottom,0)

/* Disable the "drop" button initially; wait until something is selected. */
call bguiset(obj.drp,,GA_Disabled,1)

/* Open the main window.
   parameters:    title, object, %wide, %high */
mainwindowObj=bguiwindow('Slide Show',GUIcombined,40,70)
if bguiwinopen(mainwindowObj)=0 then bguierror(12)

/* "id" is another ubiquitous BGUI stem variable; it identifies which BGUI
   object responded to an event. */
id=0

/* this is the main program loop.  Bguiwinwaitevent idles until the window
   receives an event.  The loop exits if the window is closed. */
do while bguiwinwaitevent(mainwindowObj,'ID')~=id.winclose
   select
       /*** Description Field ***/
      when id=id.desc then do
          /* update the stem "shows" at the current index with the current
             description.*/
         texts.curShowIndex.description = bguiget(obj.desc,STRINGA_TextVal)
      end
       /*** Title Field ***/
      when id=id.title then do
          /* update the stem "shows" at the current index with the current
             title; note that title in the "shows" title does not overlap
             with the "id" stem title. */
         texts.curShowIndex.title = bguiget(obj.title,STRINGA_TextVal)
      end
       /*** Date Field ***/
      when id=id.date then do
          /* update the stem "shows" at the current index with the current
             date; note that date in the "shows" date does not overlap
             with the "id" stem date. */
         texts.curShowIndex.date = bguiget(obj.date,STRINGA_TextVal)
      end
       /*** Slide List ***/
      when id=id.listv then do
          /* when the selection changes in the list view, it changes the text
             description, title, and date, based on the "shows" stem contents
             at the position 'curShowIndex,' which is read as the index into
             the list view.  Also enable the drop button. */
         curShowIndex= bguiget(obj.listv,'LISTV_LastClickedNum')
         call bguiset(obj.desc,mainwindowObj,STRINGA_TextVal,texts.curShowIndex.description)
         call bguiset(obj.title,mainwindowObj,STRINGA_TextVal,texts.curShowIndex.title)
         call bguiset(obj.date,mainwindowObj,STRINGA_TextVal,texts.curShowIndex.date)
         call bguiset(obj.drp,mainwindowObj,GA_Disabled,0)
      end
       /*** Add Button ***/
      when id=id.add then do
            /*newfile identifies the image file as the return value from the
              file requester; pragma finds the current directory name. Note
              that checking the length of newpath allows the file requester
              to be opened without the current directory given; BGUI's file
              requester will remember the last directory automatically. */
            if (length(newpath) = 0) then do
             newpath = bguifilereq(pragma('D'),'Choose an image file',mainwindowObj,'REJECTICONS')
             end
         else do
             newpath = bguifilereq(,'Choose another image file',mainwindowObj,'REJECTICONS')
             end
          if (length(newpath)>0) then do /* a filename was given. */
              /* add the new entry to the listview, enable the drop button,
                 and update description, title, and date fields, as well as
                 the "shows" stem. 'T' option puts at end of list. */
            call bguilistvaddentry(obj.listv,mainwindowObj,newpath,,'T')
            /* this gathers the saved date of the file and formats it.  If
               you prefer a more European date format, replace USA with
               European. The output of the AmigaDos command is stored in
               a text file.  Some file  manipulation is necessary
               to read the results of 'list.'*/
            address command
            tempfile = "ram:SlideshowOutput"
            /* list gets us the current date.  */
            'list "'newpath'" LFORMAT %d >'tempfile
            address
            open('outputfile',tempfile,'R')
            newdat = Readln('outputfile')
            close('outputfile')
            address command
            'delete 'tempfile' >nil:'
            address
            /* clear some text fields, set date field to date of file. */
            call bguiset(obj.listv,mainwindowObj,LISTV_Deselect,curShowIndex)
            call bguiset(obj.date,mainwindowObj,STRINGA_TextVal,newdat)
                curShowCount= bguiget(obj.listv,'LISTV_NumEntries')-1
            texts.curShowCount.date = newdat
            curShowIndex = curShowCount
            call bguiset(obj.listv,mainwindowObj,ListV_Select,curShowCount)
            call bguiset(obj.desc,mainwindowObj,STRINGA_TextVal,"")
            call bguiset(obj.title,mainwindowObj,STRINGA_TextVal,"")
            call bguiset(obj.drp,mainwindowObj,GA_Disabled,0)
             end /* file was chosen */
      end
       /*** Drop Button ***/
      when id=id.drp then do
          /* shift descriptions, titles, date up one, unless at end. */
            curShowIndex= bguiget(obj.listv,'LISTV_LastClickedNum')
            curShowCount= bguiget(obj.listv,'LISTV_NumEntries')-1
            if curShowIndex < curShowCount then do
                i = curShowIndex
                do while i < curShowCount   /* repeat for remaining slides */
                    nextShowIndex = i + 1
                    texts.i.title = texts.nextShowIndex.title
                    texts.i.description = texts.nextShowIndex.description
                    texts.i.date = texts.nextShowIndex.date
                    i = i + 1
                    end /* loop on shifting remaining entries up */
                end /* must shift remaining entries up. */
          /* remove selected entry.  */
         call bguilistvcommand(obj.listv,mainwindowObj,'remselected')
            call bguiset(obj.listv,mainwindowObj,ListV_Select,curShowCount)
         if bguiget(obj.listv,'LISTV_NumEntries')=0 then,
            call bguiset(obj.drp,mainwindowObj,GA_Disabled,1)
      end
       /*** Up Button ***/
      when id=id.up then do
          call bguilistvgetentries(obj.listv, curslide, 'S')
          call bguilistvgetentries(obj.listv, shows,'A')
          matchID =0
          do i=0 to shows.count
              if shows.i = curslide.0 then do
                  /* a match in the list was found for the selected entry */
                  /* curslide is re-used from above as a stem to hold the
                     swap values of the text fields. */
                  matchID = i-1
                  if matchID >= 0 then do
                      /* swap the two entries */
                      curslide.1 = shows.matchID
                      shows.matchID = curslide.0
                      shows.i = curslide.1
                      /* now swap all the text values. */
                      curslide.title = texts.matchID.title
                      curslide.date = texts.matchID.date
                      curslide.description = texts.matchID.description
                      texts.matchID.title = texts.i.title
                      texts.matchID.date = texts.i.date
                      texts.matchID.description = texts.i.description
                      texts.i.title =curslide.title
                      texts.i.date = curslide.date
                      texts.i.description = curslide.description
                      i = shows.count /* stops the loop */
                      end /* end of match not first in list. */
                  end     /* end of match found */
              end         /* end of loop */
          /* clear all the entries. */
          call bguilistvcommand(obj.listv,mainwindowObj,'clear')
          /* add them back in, with the swap. */
          do i=0 to shows.count
              /* if it is the selected one, re-select it. */
              if i=matchID then bguilistvaddentry(obj.listv,, shows.i,'T','S')
              else bguilistvaddentry(obj.listv,, shows.i,'T')
              end
          call bguilistvcommand(obj.listv,mainwindowObj,'refresh')
          end
       /*** Down Button ***/
      when id=id.down then do
          call bguilistvgetentries(obj.listv, curslide, 'S')
          call bguilistvgetentries(obj.listv, shows,'A')
          matchID =0
          do i=0 to shows.count
              if shows.i = curslide.0 then do
                  /* a match in the list was found for the selected entry */
                  /* curslide is re-used from above as a stem to hold the
                     swap values of the text fields. */
                  matchID = i + 1
                  if matchID < shows.count then do
                      /* swap the two entries */
                      curslide.1 = shows.matchID
                      shows.matchID = curslide.0
                      shows.i = curslide.1
                      /* now swap all the text values. */
                      curslide.title = texts.matchID.title
                      curslide.date = texts.matchID.date
                      curslide.description = texts.matchID.description
                      texts.matchID.title = texts.i.title
                      texts.matchID.date = texts.i.date
                      texts.matchID.description = texts.i.description
                      texts.i.title =curslide.title
                      texts.i.date = curslide.date
                      texts.i.description = curslide.description
                      i = shows.count /* stops the loop */
                      end /* end of match not last in list. */
                  end     /* end of match found */
              end         /* end of loop */
          /* clear all the entries. */
          call bguilistvcommand(obj.listv,mainwindowObj,'clear')
          /* add them back in, with the swap. */
          do i=0 to shows.count
              /* if it is the selected one, re-select it. */
              if i=matchID then bguilistvaddentry(obj.listv,, shows.i,'T','S')
              else bguilistvaddentry(obj.listv,, shows.i,'T')
              end
          call bguilistvcommand(obj.listv,mainwindowObj,'refresh')
          end
       /*** Show! Button ***/
      when id=id.show then do
          if shows.count >0 then call ShowSlides
          end
       /*** Nothing happened ***/
      when id=id.wininactive then nop
       /*** Window closed - drops out of while loop from the top. ***/
      when id=id.winclose then nop
      otherwise nop
   end  /* end of select list */
end     /* end of while loop. */
rc=0
call exitfn() /* user has closed window, signifies end of program. */


/* reports errors in the code. */
syntax:
/* errortext prints various error messages based on numeric codes. */
if rc~=0 then say '+++ ['rc']' errortext(rc) 'at line' sigl
call bguiclose()
exit 0

/* separate message if the user halts the program with ctrl-c or some other
   means. */
break_c:
halt:
rc=0        /* rc is a built-in variable for return code in ARexx */
say '+++ Break at line' sigl
signal syntax

/* this is a precursor to the exit routine;
   it saves settings to the prefs file on exit. */
exitfn:
counter=bguilistvgetentries(obj.listv,shows,'A')
    open('prefsfile',configfile,'W')
    do i = 0 to shows.count
        /* write the "slide" filename to the file. */
        if (length(shows.i)>0) then do
            writeln('prefsfile',shows.i)
            /* read the title, description, and date for each slide */
            writeln('prefsfile',texts.i.title)
            writeln('prefsfile',texts.i.description )
            writeln('prefsfile',texts.i.date)
            end /* shows has length */
        end
    close('prefsfile')
call bguiclose()
exit 0

/* this small function does all the display and sound. */
/* be sure to change multiview in both places if you want to change to
   another program.  The break statement stops the first multiview call
   so that countless copies are not running at once. */
ShowSlides:
max = shows.count -1
address command
do i=0 to max
    'run multiview "'shows.i'" >nil:'
    'say -n -m -p100 'texts.i.title'.'
    'say -n -m -p100 was take n on 'texts.i.date
    'say -n -m -p100 'texts.i.description
    'status command multiview >pipe:'
    'break >NIL: <PIPE: ALL ?'
    end
address
return