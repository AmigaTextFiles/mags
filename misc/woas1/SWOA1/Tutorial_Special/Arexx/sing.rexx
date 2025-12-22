/* totally annoying singing Amiga */

address command

/* set up about 3 octaves of notes, starting on low C, each number is a
half-step */
/* the 'tone.' stem will hold all the frequencies of notes available.
   Observe that the range is from 0 to 36.  A frequency beyond this range will
   be 65 by default. */
/* This sets a default value for uses of the tone. stem beyond tone.36 */
tone. = '65'
tone.0 = 65

/* create different frequencies for 3 full octaves of range */
/* the formula is for frequencies of consecutive half-steps on a piano, starting from
   the low C, which is 65 Hz. */
i = 0                           /* counting variable */

do i = 1 to 36
   tone.i = tone.0 * (1.059463094**i)
end


songlength = 3
/* songlength is the last number referenced for the stems that make up the song. */
/* mywords is the stem for syllables sung in the song.  I tweaked spelling on purpose.
   mynotes is a reference to the tone stem, and is therefore the musical note sung.
   myspeed is the duration of each note.  1 is briefer than 2, 2 is briefer than 4. */
mywords.0 = "hah pee  ber thday too  yoo"
mynotes.0 = "7   7   9     7     12  11"
myspeed.0 = "1   1   2     2     2   2"

mywords.1 = "hah pee  ber thday too  yoo"
mynotes.1 = "7   7   9     7     14  12"
myspeed.1 = "1   1   2     2     2   2"

mywords.2 = "hah pee  ber thday dear Jay cub"
mynotes.2 = "7   7   19    16    12   9   9"
myspeed.2 = "1   1   2     2     2    2   4"

mywords.3 = "hah  pee ber thday too  you"
mynotes.3 = "12   12  11   7     9   11"
myspeed.3 = "1    1   2    2     4   4"




speed = 300                     /* I experimented to come up with this number. */
                                /* speed is the rate at which the speech translator*/
                                /* will speak a syllable. */

j = 0                           /* another counting variable */
curnote =0                      /* the current note in the song, based on the */
                                /* contents of mynotes. */
curword = "doe"                 /* the current syllable from the stem mywords. */
curspeed = 1                    /* the duration of the current note, based on the */
                                /* contents of myspeed */
curnoise = "hi"                 /* variable created to hold what is sent to the */
                                /* speech translator */

/* ------------------    sing the song. ------------------ */
do i = 0 to songlength          /* iterate through the different lines in the song */
    curnoise="-n -m "           /* codes for the speech translator to sound human. */
                   /* iterate through all the notes in the current line of the song. */
    do j = 1 to words(mynotes.i)
      curnote = word(mynotes.i,j)
      curnote = tone.curnote  /* this is an index into the tone stem. */
      curspeed = speed / (word(myspeed.i,j))  /* a formula for duration */
      curword = word(mywords.i, j)
      curnoise = curnoise" -p"curnote" -s"curspeed curword
                  /* the -p setting sets the pitch, the -s setting sets the speed. */
   end             /* end of iteration on all the notes in the current line. */

/* this calls the speech translator function, sending in the contents of curnoise */
''say curnoise
end
