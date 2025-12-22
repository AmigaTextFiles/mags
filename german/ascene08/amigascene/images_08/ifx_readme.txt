ImageFX 3.2 Update Disk
Copyright © 1998 Nova Design, Inc.
All Rights Reserved

-------------------------------------------------------------------------

Revision History

-------------------------------------------------

3.2:

Fixed preview thumbnails to support regions.

Fixed bug in scan.library/CheckMask() that caused
the wrong value to be returned for rectangular
masks.

Worked around a problem in scan.library/PrepareProcess()
that caused problems in processing rectangular
regions.

Re-implemented the SLIDER gadget type for
the Arexx NewComplexRequest command.

Fixed case where Perspective would crash when
attempting to free a non-existant brush mask.
Also updated it to use newer mask allocation routines.
Also fixed some enforcer hits when used via. Arexx.

Added "Name" argument to Arexx Alpha2Buffer so
you can name the new buffer immediately.  Only
works when you also specify the New option.

Added "Move" arguments to Arexx Alpha2Buffer and
Buffer2Alpha commands to delete the source buffer
after the copy is finished.

Fixed alpha channel operation in IMP.  Also fixed
problems with forgetting gadget settings.

Added a "New" argument to the Arexx Alpha2Buffer
command.  This copies the main buffer's alpha
channel to a brand new buffer view.

Updated Arexx Buffer2Alpha to include a source
buffer name argument.  This lets you copy any
arbitrary buffer into the current buffer's
alpha channel.

Added Arexx "GetBufferList" command to list info
about all buffers in memory.  See Help/
Arexx_ImageFX.guide.

Opening a new view window during an Arexx script no
longer triggers an asyncronous redraw, which could
cause major problems in subsequent commands.

Includes newer ScanJet module.

Swap Alpha no longer causes an invalid state
which causes the alpha channel to appear to
have its own alpha channel, which causes um
slight problems when saving the alpha channel.

ILBM Loader now loads all 256-color greyscale
images as greyscale instead of colormapped.

ILBM Saver no longer asks if you want to save
the alpha channel associated with a buffer, it
just does it.

Arexx SaveAlphaAs command now returns an
error code if it fails.

Under the classic interface, the "New" param of
the LoadBuffer and CreateBuffer commands now push
the current main buffer to the swap buffer to
emulate windowed interface behavior.  The previous
swap buffer is stored in the multiple buffer list.

Did a lot of tweaking to the internals of various
Arexx commands that I couldn't possibly document
even if I wanted to.  Anyway, a bunch of stuff that
wasn't working before should now be working.  Mostly
alpha channel and classic interface related stuff.

Arexx KillBuffer now ghosts the toolbox panel
properly.

Arexx SelectBuffer command now able to find
full pathnames (for some inexplicable reason,
I had set it to only look for filenames and
ignore the full pathname).

Incorporated some changes to macro recording
into FXForge.  Don't ask me what they are or
whether they work.

Macro recording create buffer now adds the
"New" param.

Fixed some problems with processing gadget
hotkeys.  Remember you have to use Right Amiga +
the underlined key.

Fixed a really obscure bug in handling cached
saver modules.	This caused ImageFX to use a
previously cached module (eg. ILBM) instead of the
requested one (eg. JPEG) under certain circumstances.

Removed the 'undo' statement from the EOT
Fire scripts.

No longer records a hook's CPU extension when
macro recording.

Fixed undo after Deinterlace.  Also fixed lack
of redraw after Deinterlace on classic interface.

Tweaked FXForge interface to fit on a 200-pixel
display.  Also did some fairly major cosmetic work
on gadget placement.

Tweaked Splash interface to (sort of) fit on a
200-pixel display.

Implemented support for making Ged integer gadgets
smaller than the interface font.

Tweaked Perspective interface to fit on a 200-pixel
display.

Tweaked Spherize interface to fit on a 200-pixel
display.

Fixed some gadgets that should have been ghosted
in the classic interface.

Should now ghost the layer gadget in all cases
on the classic interface.

Functions that load/create/copy to the alpha
channel now explicitely set ScanBase->Alpha;
fixes problems with the classic interface
alpha channel support.

Fixed crash in classic interface for anything
that used the ReplaceBuffer() function, introduced
in 3.1c RC2.

Added some extra sanity checking to the Arexx
Scale command.

Fixed classic interface so you can show greyscale
images without the psychodelic colors.

Fixed Swap Alpha from the classic interface.

Added CLASSIC and INTERFACE=CLASSIC tool types
as synonyms for the SCREENED and INTERFACE=SCREEN
tool types.

Added CLASSIC/s command line argument to launch
the classic interface.

Fixed Light Table and Light Table Alpha when
used from the classic interface.

Fixed problems with installing new swap buffer
in the classic interface.

Fixed problems with swapping buffers in the
classic interface.

Fixed Delete All Buffers in classic interface.

Select Buffer by Name now strips the pathname
from buffer names.

Fixed brush handle macro recording so it
adds quotes around the numbers.

No longer able to open more than one pen menu.

Fixed brush stencil rendering for AGA/ECS
graphics modes.

Fixed brush rendering for AGA/ECS modes.

Pressure support should be working again.

Added pressure support to drawstyles.

Opens windows with WA_TabletMessages TRUE
so we can get pressure event messages again.

JPEG loader now able to read CMYK jpegs, although
the color conversion is really bad.  Currently only
tries to read photoshop's (non-standard) CMYK jpegs.

ReplaceBuffer() now refreshes the main view
sliders if working on the current buffer.

Fixed problems in deinterlace hook.  Should now
perform just like the 2.6 version.

Fixed Arexx documentation for Fire hook
Radial_Out and Radial_In parameters.

AllocBuffer() now copies the 'name' parameter
into the Buffer struct.  This means DeLace
now properly names the buffers it creates.

Fixed problem of not setting new slider ranges
when switching to YIQ/YUV colorspaces in the
palette panel.

Fixed problem with Amiga render module color
cycle gadget after rendering to a HAM display
mode (it wouldn't let you select higher than
64 colors after that point).

I believe I fixed the problems with layer masks
not rendering in the right place.  This should
also fix kermit's (and I guess everyone else's)
problem with loading psds with user masks.

Default binding for 'n' key is now
"CreateBuffer New" instead of just "CreateBuffer".

Added back keyboard shortcuts to the IV24
Framegrabber module.  New shortcuts are
Amiga-C to capture, Amiga-F to freeze, and
Amiga-V to preview.  Also fixed slight
V109 gadget incompatibility when switching
between NTSC/PAL.  (Probably caused a crash.)

Fixed 3.0 compatibility problems (or so I'm
told) with AutoFX SaveBufferAs_MPEG script.

Fixed the BMP loader to handle more varieties
of BMPs.  (It now actually heeds the field
that says where the image data actually starts
in the file.)

Fixed Arexx KillSwap and the Delete Swap menus.

Worked on handling of iconification and
un-iconification.  Should work a lot better now.

Arexx RenameBuffer now updates window titlebar
immediately.

Arexx KillBuffer now deletes the view(s) associated
with the buffer being deleted.

Now redraws the brush properly when changing between
buffer views.

Ported the ImageFX 2.6 JPEG loader and saver
to ImageFX 3.1, which adds back the support
for progressive JPEGs.	(The 2.6 modules used
IJG 6a whereas the 3.0 modules were still using
IJG version 4.something.)

Text hook now uses AllocMask(); fixes memory
problems when freeing text brushes.

Fixed Negative, Balance, and all "FX" module
functions to support brushes again.


-------------------------------------------------

3.1b:

Fixed the useage of the SelectBuffer, NextBuffer,
and PrevBuffer commands.  Also fixed the useage
of the select buffer button.  It now just activates
the selected buffer.

Fixed parsing of CLI args (it now parses them
after tool types).

Fixed problem with Save requester listview
(switching from Main to Render would not update
the render list properly.)

Fixed feather out trashing.

Liquid/Bubble back on the Distort menu in
classic interface.

Preserves region when swapping to alpha.

Fixed redraw and undo after halving/doubling
buffer.

Added New Layer From Brush.

Region mask should now move around properly
when zoomed in and stuff.  There seems to be
a bug in Cybergraphx that trashes the render
mask when it is drawn off the left side of
the window though.

Inserted a little kludge to clip layer masks
to buffer boundaries before running hooks,
so they work again.

Fixed tiny memory leak in rendering region
mask.

Region masks are now independant of layers
(actually they are attached to the background
layer).  So you can draw a region in one layer,
then switch to another and the region is still
there in the same place.

Re-worked a lot of the code involved in
creating, rendering, and using region masks
to handle operating independantly from
layers.  It is now possible for a region
mask to be outside the boundaries of a
layer.

Convert To CMAP now macro records.

Fixed mungwall hits when buffer allocation
fails in AllocBuffer().  (It wasn't using
FreeSharedMem() to free the partially
allocated planes.)  This could fix the
memory loss reported during scanning.

Fixed mungwall hits when scaling brush
masks.	(It now uses AllocMask() instead
of trying to allocate the mask plane data
directly.)

Worked on moving the region drawing into the
redraw task.  This should fix a lot of cases
where the redraw task would write over the
mask and vice versa.

Fixed regions being drawn in the wrong location
when working on a layer with offsets.

Fixed crash and general mayhem when deleting
the main buffer in the Classic interface.

Fixed Scale command argument processing from
Arexx.	So Scale Border should now work.
Also added SMOOTH option to allow picking
between Smooth and Accurate scaling.

Fixed up Load From Clipboard.

Tranform unghosts for colormapped images now.

Border Scale now handles colormapped images.

Fixed channel masking so it works with the
Process functions again.

Fixed arexx execution to automatically redraw
if necessary after running an Arexx program.

Fixed learning scale operations when launched
from the interface.

Fixed mungwall hit when freeing a buffer
that had been layerized.

Sets modified flag upon making layer changes.

Fixed undo offset problem with Blur, etc. drawmodes
when used with realtime airbrush.

Fixed the Palette Sort window.

Fixed lock up when copying background layer
to new buffer.

Fixed enforcer hit when drawing filled oval.

Fixed all cases of improperly allocating
brush mask data.  Now uses AllocSharedMem
throughout.


-------------------------------------------------

3.1a:

Fixed image trashing in Accurate scaling when
scaling the width but the height remained the
same.

Fixed mungwall hits when freeing masks created
by BuildOvalRegion() and BuildPolyRegion().
This showed up when drawing filled circles
and polys.

Fixed mungwall hit when performing feathering
on brushes that had been picked up using
Pickup Swap.

Disabled useage of ppc.library memory functions.

Fixed ** NULL POINTER ** in learning the
LoadBrush command.


-------------------------------------------------

3.1:

Recompiled ScanJet module to use Ged_SetCycleLabels(),
fixing crashes when changing settings.

Recompiled Epson module to use Ged_SetCycleLabels(),
fixing crashes when changing settings.

Created Ged_SetCycleLabels() functions for
changing labels of a cycle gadget, required
by the Epson and ScanJet modules.

Fixed the "psychodelic" image generated by
Smooth Scaling an image larger.

Fixed problems in changing from Windowed to
WindowedCGX previews and vice versa while
view windows were open.

Added back Gaussian Blur, Liquid, Bubble to
the classic toolbox menus.

Fixed a long string of problems that prevented
one from changing preview screenmodes while
view windows were open.

Tinkered with the handling of loading
backdrop images.  Probably won't fix anything
to do with datatypes but ya never know.

Fixed Load Alpha.

Fixed enforcer hits/crashes when saving an undo
for a brush that was created by Pickup Swap.

ReplaceBuffer() now sets the modified flag, so
that operations like scaling and cropping mark
a buffer as modified.

Fixed general mayhem when scaling a buffer that
has multiple views open on it.

Fixed VM_SizeView() to support making the window
larger.  So now the fit window feature will
enlarge a window so the image is completely
visible at the current zoom level (assuming it
will fit on screen).

Really fixed updating scroll bars when sizing
preview windows smaller.

Fixed Brush Tile and Brush Brick to handle
colormapped brushes properly.

Fixed computation of screen pixel aspect.  This
fixes some apparent problems with the 1:1 aspect
lock thingy.

Fixed enforcer hits when using the Proc functions
on buffers with alpha channels.  GetMaskLine()
was not checking for NULL mask pointers.

Fixed updating scroll bars when sizing preview
windows.  Err.. no I didn't.

Fixed crashes/enforcer hits/mungwall hits/general
mayhem when using SetAspect.  (It was trying to
recompute the scaling tables the old way.)

Added explicit support for the ID_Ignore style;
this is what caused all those GED: Unknown
gadget id 0 messages (it was printing the ID
instead of the Style).

Added back support for changing GedLeftOffset
and GedTopOffset via. an Offset_ID style.  This
should fix the problems with IMP rendering
gadgets off the bottom of the window.

Now does a Ged_Remove() before closing the
window, which fixes enforcer hits and crashes
and stuff when closing IMP.  Also bumped the
revision like I should have done with 3.0.

Now handles a NULL initial string when creating
a String_ID gadget.  Seems like IMP is doing
this, causing enforcer hits when starting it.

Worked on fixing problems with loading prefs
in Windowed version.  Not totally fixed yet.

Removed saving prefs on exit.  This means it
won't remember window positions unless you
save prefs manually.

Removed zoom gadget from all Ged_NewWindow()
windows.  Fixes crash if you clicked on one
in the classic ImageFX.  They weren't really
useful anyway.

Added back Film Grain, Fire, and Sparkle to the
screen-based Effects menu.

Fixed cropping CMAP buffers.

Fixed slight compatibility problem in Toaster
preview 2-monitor mode.  (Wasn't handling V109's
lack of bitmap pointer in VM_OutputRow*).  This
would probably cause the crashes since the 2-monitor
mode was the default.

Fixed display problems with scrolling listviews.

Re-implemented SaveFormat_Gui(), which is why
SaveBrushAs was not doing anything.

Fixed Copy Brush To Swap.

Now does a ShowStatus(NULL) inside of
BeginRedrawFull()... This should fix the problem
of not updating the width/height display after
re-sizing an image.

No longer checks for FORM ILBM BMHD .. this
caused some Brilliance ILBMs not to
auto-detect.

Fixed enforcer hit in SetEdgeMode() if a brush
was not allocated.

Fixed slight error in RenderVirtual() --
the call to PostRefreshVirtual did not specify
TRUE or FALSE.

Fixed enforcer hit when changing to the palette
panel when an image was not loaded.

Increased default file I/O buffer size to 16k.


-------------------------------------------------------------------------

Installer and Installer project icon
(c) Copyright 1995-96 Escom AG.  All Rights Reserved.
Reproduced and distributed under license from Escom AG.

INSTALLER SOFTWARE IS PROVIDED "AS-IS" AND SUBJECT TO CHANGE;
NO WARRANTIES ARE MADE.  ALL USE IS AT YOUR OWN RISK.  NO LIABILITY
OR RESPONSIBILITY IS ASSUMED.


