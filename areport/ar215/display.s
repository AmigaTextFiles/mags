.key x,y,filename,title

if exists sys:utilities/multiview
    sys:utilities/multiview WINDOW <filename>
    quit
    endif

if exists sys:utilities/wdisplay
    sys:utilities/wdisplay WIDTH <x> HEIGHT <y> <filename> TITLE <title>
    quit
    endif

if exists sys:utilities/display
    sys:utilities/display <filename>
    quit
    endif

if exists sys:utilities/display39
    sys:utilities/display39 <filename>
    quit
    endif

if exists c:vt
    c:vt <filename>
    quit
    endif

if exists c:superview
    c:superview <filename>
    quit
    endif

if exists c:mostra
    c:mostra <filename>
    quit
    endif

if exists c:ppshow
    c:ppshow <filename>
    quit
    endif

if exists c:show
    c:show <filename>
    quit
    endif

if exists c:c-show
    c:c-show <filename>
    quit
    endif

if exists c:sv
    c:sv <filename>
    quit
    endif

if exists c:view
    c:view <filename>
    quit
    endif

if exists c:iview
    c:iview <filename>
    quit
    endif

if exists c:showiz
    c:vt <filename>
    quit
    endif

if exists c:vt
    c:showizjr <filename>
    quit
    endif
