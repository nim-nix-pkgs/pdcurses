#
#
#            Nim's Runtime Library
#        (c) Copyright 2015 Andreas Rumpf
#
#    See the file "copying.txt", included in this
#    distribution, for details about the copyright.

{.deadCodeElim: on.}

when defined(windows):
  const
    unixOS = false
    PDCURSED = "pdcurses.dll"
  
  {.push callConv:stdcall, dynlib: PDCURSED.}
  
else:
  const
    unixOS = true
    PDCURSED = "libpdcurses.so"
  
  {.push callConv:cdecl, dynlib: PDCURSED.}

type
  cunsignedchar = uint8
  cunsignedlong = uint32

  TMOUSE_STATUS* {.bycopy, pure, final.} = object
    x*: cint                  # absolute column, 0 based, measured in characters
    y*: cint                  # absolute row, 0 based, measured in characters
    button*: array[0..3 - 1, cshort] # state of each button
    changes*: cint            # flags indicating what has changed with the mouse

  MEVENT* {.bycopy, pure, final.} = object
    id*: cshort               # unused, always 0
    x*, y*, z*: cint                  # x, y same as TMOUSE_STATUS; z unused
    bstate*: cunsignedlong    # equivalent to changes + button[], but
                              # in the same format as used for mousemask()

  WINDOW* {.bycopy, pure, final.} = object
    cury*: cint              # current pseudo-cursor
    curx*: cint
    maxy*: cint              # max window coordinates
    maxx*: cint
    begy*: cint              # origin on screen
    begx*: cint
    flags*: cint             # window properties
    attrs*: cunsignedlong    # standard attributes and colors
    bkgd*: cunsignedlong     # background, normally blank
    clear*: cunsignedchar    # causes clear at next refresh
    leaveit*: cunsignedchar  # leaves cursor where it is
    scroll*: cunsignedchar   # allows window scrolling
    nodelay*: cunsignedchar  # input character wait flag
    immed*: cunsignedchar    # immediate update flag
    sync*: cunsignedchar     # synchronise window ancestors
    use_keypad*: cunsignedchar # flags keypad key mode active
    y*: ptr ptr cunsignedlong # pointer to line pointer array
    firstch*: ptr cint       # first changed character in line
    lastch*: ptr cint        # last changed character in line
    tmarg*: cint             # top of scrolling region
    bmarg*: cint             # bottom of scrolling region
    delayms*: cint           # milliseconds of delay for getch()
    parx*: cint
    pary*: cint              # coords relative to parent (0,0)
    parent*: ptr WINDOW        # subwin's pointer to parent win

  PANELOBS* {.bycopy, pure, final.} = object
    above*: ptr PANELOBS
    pan*: ptr PANEL

  PANEL* {.bycopy, pure, final.} = object
    win*: ptr WINDOW
    wstarty*: cint
    wendy*: cint
    wstartx*: cint
    wendx*: cint
    below*: ptr PANEL
    above*: ptr PANEL
    user*: pointer
    obscure*: ptr PANELOBS

when unixOS:
  type
    SCREEN* {.bycopy, pure, final.} = object
      alive*: cunsignedchar     # if initscr() called, and not endwin()
      autocr*: cunsignedchar    # if cr -> lf
      cbreak*: cunsignedchar    # if terminal unbuffered
      echo*: cunsignedchar      # if terminal echo
      raw_inp*: cunsignedchar   # raw input mode (v. cooked input)
      raw_out*: cunsignedchar   # raw output mode (7 v. 8 bits)
      audible*: cunsignedchar   # FALSE if the bell is visual
      mono*: cunsignedchar      # TRUE if current screen is mono
      resized*: cunsignedchar   # TRUE if TERM has been resized
      orig_attr*: cunsignedchar # TRUE if we have the original colors
      orig_fore*: cshort        # original screen foreground color
      orig_back*: cshort        # original screen foreground color
      cursrow*: cint            # position of physical cursor
      curscol*: cint            # position of physical cursor
      visibility*: cint         # visibility of cursor
      orig_cursor*: cint        # original cursor size
      lines*: cint              # new value for LINES
      cols*: cint               # new value for COLS
      trap_mbe*: cunsignedlong # trap these mouse button events
      map_mbe_to_key*: cunsignedlong # map mouse buttons to slk
      mouse_wait*: cint # time to wait (in ms) for a button release after a press
      slklines*: cint           # lines in use by slk_init()
      slk_winptr*: ptr WINDOW   # window for slk
      linesrippedoff*: cint     # lines ripped off via ripoffline()
      linesrippedoffontop*: cint # lines ripped off on top via ripoffline()
      delaytenths*: cint        # 1/10ths second to wait block getch() for
      preserve*: cunsignedchar # TRUE if screen background to be preserved
      restore*: cint           # specifies if screen background to be restored, and how
      save_key_modifiers*: cunsignedchar # TRUE if each key modifiers saved with each key press
      return_key_modifiers*: cunsignedchar # TRUE if modifier keys are returned as "real" keys
      key_code*: cunsignedchar # TRUE if last key is a special key;
      XcurscrSize*: cint        # size of Xcurscr shared memory block
      sb_on*: cunsignedchar
      sb_viewport_y*: cint
      sb_viewport_x*: cint
      sb_total_y*: cint
      sb_total_x*: cint
      sb_cur_y*: cint
      sb_cur_x*: cint
      line_color*: cshort       # color of line attributes - default -1
else:
  type
    SCREEN* {.bycopy, pure, final.} = object
      alive*: cunsignedchar     # if initscr() called, and not endwin()
      autocr*: cunsignedchar    # if cr -> lf
      cbreak*: cunsignedchar    # if terminal unbuffered
      echo*: cunsignedchar      # if terminal echo
      raw_inp*: cunsignedchar   # raw input mode (v. cooked input)
      raw_out*: cunsignedchar   # raw output mode (7 v. 8 bits)
      audible*: cunsignedchar   # FALSE if the bell is visual
      mono*: cunsignedchar      # TRUE if current screen is mono
      resized*: cunsignedchar   # TRUE if TERM has been resized
      orig_attr*: cunsignedchar # TRUE if we have the original colors
      orig_fore*: cshort        # original screen foreground color
      orig_back*: cshort        # original screen foreground color
      cursrow*: cint            # position of physical cursor
      curscol*: cint            # position of physical cursor
      visibility*: cint         # visibility of cursor
      orig_cursor*: cint        # original cursor size
      lines*: cint              # new value for LINES
      cols*: cint               # new value for COLS
      trap_mbe*: cunsignedlong # trap these mouse button events
      map_mbe_to_key*: cunsignedlong # map mouse buttons to slk
      mouse_wait*: cint # time to wait (in ms) for a button release after a press
      slklines*: cint           # lines in use by slk_init()
      slk_winptr*: ptr WINDOW   # window for slk
      linesrippedoff*: cint     # lines ripped off via ripoffline()
      linesrippedoffontop*: cint # lines ripped off on top via ripoffline()
      delaytenths*: cint        # 1/10ths second to wait block getch() for
      preserve*: cunsignedchar # TRUE if screen background to be preserved
      restore*: cint           # specifies if screen background to be restored, and how
      save_key_modifiers*: cunsignedchar # TRUE if each key modifiers saved with each key press
      return_key_modifiers*: cunsignedchar # TRUE if modifier keys are returned as "real" keys
      key_code*: cunsignedchar # TRUE if last key is a special key;
      line_color*: cshort       # color of line attributes - default -1


const PDC_RGB = false
#[
    Adjust the above constant according to how
    the dynamic library was compiled!
    
    Below is the C code from "curses.h" that defines this constant.

    #ifdef PDC_RGB        /* RGB */
    # define COLOR_RED    1
    # define COLOR_GREEN  2
    # define COLOR_BLUE   4
    #else                 /* BGR */
    # define COLOR_BLUE   1
    # define COLOR_GREEN  2
    # define COLOR_RED    4
    #endif
]#

when (PDC_RGB == true):
  const
    COLOR_RED* = 1
    COLOR_GREEN* = 2
    COLOR_BLUE* = 4
else:
  const
    COLOR_RED* = 4
    COLOR_GREEN* = 2
    COLOR_BLUE* = 1

const
  A_ALTCHARSET* = 0x00010000
  A_ATTRIBUTES* = 0xFFFF0000
  A_BLINK* = 0x00400000
  A_BOLD* = 0x00800000
  A_CHARTEXT* = 0x0000FFFF
  A_COLOR* = 0xFF000000
  A_INVIS* = 0x00080000
  A_ITALIC* = A_INVIS
  A_LEFTLINE* = 0x00040000
  A_NORMAL* = 0
  A_DIM* = A_NORMAL
  A_UNDERLINE* = 0x00100000
  A_RIGHTLINE* = 0x00020000
  A_PROTECT* = (A_UNDERLINE or A_LEFTLINE or A_RIGHTLINE)
  A_REVERSE* = 0x00200000
  A_STANDOUT* = (A_REVERSE or A_BOLD) # X/Open
  ALL_MOUSE_EVENTS* = 0x1FFFFFFF
  ALT_0* = 0x00000197
  ALT_1* = 0x00000198
  ALT_2* = 0x00000199
  ALT_3* = 0x0000019A
  ALT_4* = 0x0000019B
  ALT_5* = 0x0000019C
  ALT_6* = 0x0000019D
  ALT_7* = 0x0000019E
  ALT_8* = 0x0000019F
  ALT_9* = 0x000001A0
  ALT_A* = 0x000001A1
  ALT_B* = 0x000001A2
  ALT_BKSP* = 0x000001F8      # alt-backspace
  ALT_BQUOTE* = 0x000001F0    # alt-back quote
  ALT_BSLASH* = 0x00000210    # alt-back slash
  ALT_C* = 0x000001A3
  ALT_COMMA* = 0x000001F5     # alt-comma
  ALT_D* = 0x000001A4
  ALT_DEL* = 0x000001DE       # alt-delete
  ALT_DOWN* = 0x000001EB      # alt-down arrow
  ALT_E* = 0x000001A5
  ALT_END* = 0x000001E9
  ALT_ENTER* = 0x000001EE     # alt-enter
  ALT_EQUAL* = 0x000001E5
  ALT_ESC* = 0x000001EF       # alt-escape
  ALT_F* = 0x000001A6
  ALT_FQUOTE* = 0x000001F4    # alt-forward quote
  ALT_FSLASH* = 0x000001F7    # alt-forward slash
  ALT_G* = 0x000001A7
  ALT_H* = 0x000001A8
  ALT_HOME* = 0x000001E6
  ALT_I* = 0x000001A9
  ALT_INS* = 0x000001DF       # alt-insert
  ALT_J* = 0x000001AA
  ALT_K* = 0x000001AB
  ALT_L* = 0x000001AC
  ALT_LBRACKET* = 0x000001F1  # alt-left bracket
  ALT_LEFT* = 0x000001ED      # alt-left arrow
  ALT_M* = 0x000001AD
  ALT_MINUS* = 0x000001E4
  ALT_N* = 0x000001AE
  ALT_O* = 0x000001AF
  ALT_P* = 0x000001B0
  ALT_PAD0* = 0x00000205      # alt-keypad 0
  ALT_PAD1* = 0x00000206
  ALT_PAD2* = 0x00000207
  ALT_PAD3* = 0x00000208
  ALT_PAD4* = 0x00000209
  ALT_PAD5* = 0x0000020A
  ALT_PAD6* = 0x0000020B
  ALT_PAD7* = 0x0000020C
  ALT_PAD8* = 0x0000020D
  ALT_PAD9* = 0x0000020E
  ALT_PADENTER* = 0x000001CD  # alt-enter on keypad
  ALT_PADMINUS* = 0x000001D9  # alt-minus on keypad
  ALT_PADPLUS* = 0x000001D8   # alt-plus on keypad
  ALT_PADSLASH* = 0x000001DA  # alt-slash on keypad
  ALT_PADSTAR* = 0x000001DB   # alt-star on keypad
  ALT_PADSTOP* = 0x000001DC   # alt-stop on keypad
  ALT_PGDN* = 0x000001E8
  ALT_PGUP* = 0x000001E7
  ALT_Q* = 0x000001B1
  ALT_R* = 0x000001B2
  ALT_RBRACKET* = 0x000001F2  # alt-right bracket
  ALT_RIGHT* = 0x000001EC     # alt-right arrow
  ALT_S* = 0x000001B3
  ALT_SEMICOLON* = 0x000001F3 # alt-semi-colon
  ALT_STOP* = 0x000001F6      # alt-stop
  ALT_T* = 0x000001B4
  ALT_TAB* = 0x000001E3
  ALT_U* = 0x000001B5
  ALT_UP* = 0x000001EA        # alt-up arrow
  ALT_V* = 0x000001B6
  ALT_W* = 0x000001B7
  ALT_X* = 0x000001B8
  ALT_Y* = 0x000001B9
  ALT_Z* = 0x000001BA
  ATR_MSK* = A_ATTRIBUTES     # Obsolete
  ATR_NRM* = A_NORMAL         # Obsolete
  ATTR_SHIFT* = 19
  BSDcurses* = 1              # BSD Curses routines
  BUILD* = 3401
  BUTTON_ACTION_MASK* = 0x00000007 # PDCurses
  BUTTON_CLICKED* = 0x00000002
  BUTTON_DOUBLE_CLICKED* = 0x00000003
  BUTTON_MODIFIER_ALT* = 0x10000000 # PDCurses
  BUTTON_MODIFIER_CONTROL* = 0x08000000 # PDCurses
  BUTTON_MODIFIER_MASK* = 0x00000038 # PDCurses
  BUTTON_MODIFIER_SHIFT* = 0x04000000 # PDCurses
  BUTTON_MOVED* = 0x00000005  # PDCurses
  BUTTON_PRESSED* = 0x00000001
  BUTTON_RELEASED* = 0x00000000
  BUTTON_TRIPLE_CLICKED* = 0x00000004
  BUTTON1_CLICKED* = 0x00000004
  BUTTON1_DOUBLE_CLICKED* = 0x00000008
  BUTTON1_MOVED* = 0x00000010 # PDCurses
  BUTTON1_PRESSED* = 0x00000002
  BUTTON1_RELEASED* = 0x00000001
  BUTTON1_TRIPLE_CLICKED* = 0x00000010
  BUTTON2_CLICKED* = 0x00000080
  BUTTON2_DOUBLE_CLICKED* = 0x00000100
  BUTTON2_MOVED* = 0x00000200 # PDCurses
  BUTTON2_PRESSED* = 0x00000040
  BUTTON2_RELEASED* = 0x00000020
  BUTTON2_TRIPLE_CLICKED* = 0x00000200
  BUTTON3_CLICKED* = 0x00001000
  BUTTON3_DOUBLE_CLICKED* = 0x00002000
  BUTTON3_MOVED* = 0x00004000 # PDCurses
  BUTTON3_PRESSED* = 0x00000800
  BUTTON3_RELEASED* = 0x00000400
  BUTTON3_TRIPLE_CLICKED* = 0x00004000
  BUTTON4_CLICKED* = 0x00020000
  BUTTON4_DOUBLE_CLICKED* = 0x00040000
  BUTTON4_PRESSED* = 0x00010000
  BUTTON4_RELEASED* = 0x00008000
  BUTTON4_TRIPLE_CLICKED* = 0x00080000
  BUTTON5_CLICKED* = 0x00400000
  BUTTON5_DOUBLE_CLICKED* = 0x00800000
  BUTTON5_PRESSED* = 0x00200000
  BUTTON5_RELEASED* = 0x00100000
  BUTTON5_TRIPLE_CLICKED* = 0x01000000
  CHR_MSK* = A_CHARTEXT       # Obsolete
  CHTYPE_LONG* = 1            # size of chtype; long
  CLIP_ACCESS_ERROR* = 1
  CLIP_EMPTY* = 2
  CLIP_MEMORY_ERROR* = 3
  CLIP_SUCCESS* = 0
  COLOR_BLACK* = 0
  COLOR_CYAN* = (COLOR_BLUE or COLOR_GREEN)
  COLOR_MAGENTA* = (COLOR_RED or COLOR_BLUE)
  COLOR_SHIFT* = 24
  COLOR_WHITE* = 7
  COLOR_YELLOW* = (COLOR_RED or COLOR_GREEN)
  CTL_BKSP* = 0x000001F9      # ctl-backspace
  CTL_DEL* = 0x0000020F       # clt-delete
  CTL_DOWN* = 0x000001E1      # ctl-down arrow
  CTL_END* = 0x000001C0
  CTL_ENTER* = 0x00000211     # ctl-enter
  CTL_HOME* = 0x000001BF
  CTL_INS* = 0x000001DD       # ctl-insert
  CTL_LEFT* = 0x000001BB      # Control-Left-Arrow
  CTL_PAD0* = 0x000001FB      # ctl-keypad 0
  CTL_PAD1* = 0x000001FC
  CTL_PAD2* = 0x000001FD
  CTL_PAD3* = 0x000001FE
  CTL_PAD4* = 0x000001FF
  CTL_PAD5* = 0x00000200
  CTL_PAD6* = 0x00000201
  CTL_PAD7* = 0x00000202
  CTL_PAD8* = 0x00000203
  CTL_PAD9* = 0x00000204
  CTL_PADCENTER* = 0x000001D3 # ctl-enter on keypad
  CTL_PADENTER* = 0x000001CC  # ctl-enter on keypad
  CTL_PADMINUS* = 0x000001D5  # ctl-minus on keypad
  CTL_PADPLUS* = 0x000001D4   # ctl-plus on keypad
  CTL_PADSLASH* = 0x000001D6  # ctl-slash on keypad
  CTL_PADSTAR* = 0x000001D7   # ctl-star on keypad
  CTL_PADSTOP* = 0x000001D2   # ctl-stop on keypad
  CTL_PGDN* = 0x000001BE
  CTL_PGUP* = 0x000001BD
  CTL_RIGHT* = 0x000001BC
  CTL_TAB* = 0x000001E2       # ctl-tab
  CTL_UP* = 0x000001E0        # ctl-up arrow
  ERR* = (- 1)
  KEY_A1* = 0x000001C1        # upper left on Virtual keypad
  KEY_A2* = 0x000001C2        # upper middle on Virt. keypad
  KEY_A3* = 0x000001C3        # upper right on Vir. keypad
  KEY_ABORT* = 0x0000015C     # abort/terminate key (any)
  KEY_ALT_L* = 0x00000220     # Left-alt
  KEY_ALT_R* = 0x00000221     # Right-alt
  KEY_B1* = 0x000001C4        # middle left on Virt. keypad
  KEY_B2* = 0x000001C5        # center on Virt. keypad
  KEY_B3* = 0x000001C6        # middle right on Vir. keypad
  KEY_BACKSPACE* = 0x00000107 # not on pc
  KEY_BEG* = 0x00000160       # beg(inning) key
  KEY_BREAK* = 0x00000101     # Not on PC KBD
  KEY_BTAB* = 0x0000015F      # Back tab key
  KEY_C1* = 0x000001C7        # lower left on Virt. keypad
  KEY_C2* = 0x000001C8        # lower middle on Virt. keypad
  KEY_C3* = 0x000001C9        # lower right on Vir. keypad
  KEY_CANCEL* = 0x00000161    # cancel key
  KEY_CATAB* = 0x00000156     # clear all tabs
  KEY_CLEAR* = 0x0000014D     # clear screen
  KEY_CLOSE* = 0x00000162     # close key
  KEY_CODE_YES* = 0x00000100  # If get_wch() gives a key code
  KEY_COMMAND* = 0x00000163   # cmd (command) key
  KEY_CONTROL_L* = 0x0000021E # Left-control
  KEY_CONTROL_R* = 0x0000021F # Right-control
  KEY_COPY* = 0x00000164      # copy key
  KEY_CREATE* = 0x00000165    # create key
  KEY_CTAB* = 0x00000155      # clear tab
  KEY_DC* = 0x0000014A        # delete character
  KEY_DL* = 0x00000148        # delete line
  KEY_DOWN* = 0x00000102      # Down arrow key
  KEY_EIC* = 0x0000014C       # exit insert char mode
  KEY_END* = 0x00000166       # end key
  KEY_ENTER* = 0x00000157     # enter or send (unreliable)
  KEY_EOL* = 0x0000014F       # clear to end of line
  KEY_EOS* = 0x0000014E       # clear to end of screen
  KEY_EXIT* = 0x00000167      # exit key
  KEY_F0* = 0x00000108        # function keys; 64 reserved
  KEY_FIND* = 0x00000168      # find key
  KEY_HELP* = 0x00000169      # help key
  KEY_HOME* = 0x00000106      # home key
  KEY_IC* = 0x0000014B        # insert char or enter ins mode
  KEY_IL* = 0x00000149        # insert line
  KEY_LEFT* = 0x00000104      # Left arrow key
  KEY_LHELP* = 0x0000015E     # long help
  KEY_LL* = 0x0000015B        # home down/bottom (lower left)
  KEY_MARK* = 0x0000016A      # mark key
  KEY_MESSAGE* = 0x0000016B   # message key
  KEY_MIN* = KEY_BREAK        # Minimum curses key value
  KEY_MODIFIER_ALT* = 4
  KEY_MODIFIER_CONTROL* = 2
  KEY_MODIFIER_NUMLOCK* = 8
  KEY_MODIFIER_SHIFT* = 1
  KEY_MOUSE* = 0x0000021B     # "mouse" key
  KEY_MOVE* = 0x0000016C      # move key
  KEY_NEXT* = 0x0000016D      # next object key
  KEY_NPAGE* = 0x00000152     # next page
  KEY_OPEN* = 0x0000016E      # open key
  KEY_OPTIONS* = 0x0000016F   # options key
  KEY_PPAGE* = 0x00000153     # previous page
  KEY_PREVIOUS* = 0x00000170  # previous object key
  KEY_PRINT* = 0x0000015A     # print/copy
  KEY_REDO* = 0x00000171      # redo key
  KEY_REFERENCE* = 0x00000172 # ref(erence) key
  KEY_REFRESH* = 0x00000173   # refresh key
  KEY_REPLACE* = 0x00000174   # replace key
  KEY_RESET* = 0x00000159     # reset/hard reset (unreliable)
  KEY_RESIZE* = 0x00000222    # Window resize
  KEY_RESTART* = 0x00000175   # restart key
  KEY_RESUME* = 0x00000176    # resume key
  KEY_RIGHT* = 0x00000105     # Right arrow key
  KEY_SAVE* = 0x00000177      # save key
  KEY_SBEG* = 0x00000178      # shifted beginning key
  KEY_SCANCEL* = 0x00000179   # shifted cancel key
  KEY_SCOMMAND* = 0x0000017A  # shifted command key
  KEY_SCOPY* = 0x0000017B     # shifted copy key
  KEY_SCREATE* = 0x0000017C   # shifted create key
  KEY_SDC* = 0x0000017D       # shifted delete char key
  KEY_SDL* = 0x0000017E       # shifted delete line key
  KEY_SDOWN* = 0x00000224     # Shifted down arrow
  KEY_MAX* = KEY_SDOWN        # Maximum curses key
  KEY_SELECT* = 0x0000017F    # select key
  KEY_SEND* = 0x00000180      # shifted end key
  KEY_SEOL* = 0x00000181      # shifted clear line key
  KEY_SEXIT* = 0x00000182     # shifted exit key
  KEY_SF* = 0x00000150        # scroll 1 line forward
  KEY_SFIND* = 0x00000183     # shifted find key
  KEY_SHELP* = 0x0000015D     # short help
  KEY_SHIFT_L* = 0x0000021C   # Left-shift
  KEY_SHIFT_R* = 0x0000021D   # Right-shift
  KEY_SHOME* = 0x00000184     # shifted home key
  KEY_SIC* = 0x00000185       # shifted input key
  KEY_SLEFT* = 0x00000187     # shifted left arrow key
  KEY_SMESSAGE* = 0x00000188  # shifted message key
  KEY_SMOVE* = 0x00000189     # shifted move key
  KEY_SNEXT* = 0x0000018A     # shifted next key
  KEY_SOPTIONS* = 0x0000018B  # shifted options key
  KEY_SPREVIOUS* = 0x0000018C # shifted prev key
  KEY_SPRINT* = 0x0000018D    # shifted print key
  KEY_SR* = 0x00000151        # scroll 1 line back (reverse)
  KEY_SREDO* = 0x0000018E     # shifted redo key
  KEY_SREPLACE* = 0x0000018F  # shifted replace key
  KEY_SRESET* = 0x00000158    # soft/reset (partial/unreliable)
  KEY_SRIGHT* = 0x00000190    # shifted right arrow
  KEY_SRSUME* = 0x00000191    # shifted resume key
  KEY_SSAVE* = 0x00000192     # shifted save key
  KEY_SSUSPEND* = 0x00000193  # shifted suspend key
  KEY_STAB* = 0x00000154      # set tab
  KEY_SUNDO* = 0x00000194     # shifted undo key
  KEY_SUP* = 0x00000223       # Shifted up arrow
  KEY_SUSPEND* = 0x00000195   # suspend key
  KEY_UNDO* = 0x00000196      # undo key
  KEY_UP* = 0x00000103        # Up arrow key
  MOUSE_MOVED* = 0x00000008
  MOUSE_POSITION* = 0x00000010
  MOUSE_WHEEL_DOWN* = 0x00000040
  MOUSE_WHEEL_SCROLL* = 0x02000000 # PDCurses
  MOUSE_WHEEL_UP* = 0x00000020
  OK* = 0
  PAD0* = 0x000001FA          # keypad 0
  PADENTER* = 0x000001CB      # enter on keypad
  PADMINUS* = 0x000001D0      # minus on keypad
  PADPLUS* = 0x000001D1       # plus on keypad
  PADSLASH* = 0x000001CA      # slash on keypad
  PADSTAR* = 0x000001CF       # star on keypad
  PADSTOP* = 0x000001CE       # stop on keypad
  PDCURSES* = 1               # PDCurses-only routines
  REPORT_MOUSE_POSITION* = 0x20000000
  SHF_DC* = 0x0000021A        # shift-delete on keypad
  SHF_DOWN* = 0x00000218      # shift-down on keypad
  SHF_IC* = 0x00000219        # shift-insert on keypad
  SHF_PADENTER* = 0x00000212  # shift-enter on keypad
  SHF_PADMINUS* = 0x00000216  # shift-minus on keypad
  SHF_PADPLUS* = 0x00000215   # shift-plus  on keypad
  SHF_PADSLASH* = 0x00000213  # shift-slash on keypad
  SHF_PADSTAR* = 0x00000214   # shift-star  on keypad
  SHF_UP* = 0x00000217        # shift-up on keypad
  SYSVcurses* = 1             # System V Curses routines
  WA_ALTCHARSET* = A_ALTCHARSET
  WA_BLINK* = A_BLINK
  WA_BOLD* = A_BOLD
  WA_DIM* = A_DIM
  WA_HORIZONTAL* = A_NORMAL
  WA_INVIS* = A_INVIS
  WA_LEFT* = A_LEFTLINE
  WA_LOW* = A_NORMAL
  WA_PROTECT* = A_PROTECT
  WA_REVERSE* = A_REVERSE
  WA_RIGHT* = A_RIGHTLINE
  WA_STANDOUT* = A_STANDOUT
  WA_TOP* = A_NORMAL
  WA_UNDERLINE* = A_UNDERLINE
  WA_VERTICAL* = A_NORMAL
  WHEEL_SCROLLED* = 0x00000006 # PDCurses
  XOPEN* = 1                  # X/Open Curses routines

when appType == "gui":
  const
    BUTTON_ALT* = BUTTON_MODIFIER_ALT
    BUTTON_CONTROL* = BUTTON_MODIFIER_CONTROL
    BUTTON_CTRL* = BUTTON_MODIFIER_CONTROL
    BUTTON_SHIFT* = BUTTON_MODIFIER_SHIFT
else:
  const
    BUTTON_ALT* = 0x00000020
    BUTTON_CONTROL* = 0x00000010
    BUTTON_SHIFT* = 0x00000008

var
  acs_map* {.importc: "acs_map".}: ptr cunsignedlong
  COLOR_PAIRS* {.importc: "COLOR_PAIRS".}: cint
  COLORS* {.importc: "COLORS".}: cint
  COLS* {.importc: "COLS".}: cint
  curscr* {.importc: "curscr".}: ptr WINDOW
  LINES* {.importc: "LINES".}: cint
  Mouse_status* {.importc: "Mouse_status".}: TMOUSE_STATUS
  SP* {.importc: "SP".}: ptr SCREEN
  stdscr* {.importc: "stdscr".}: ptr WINDOW
  TABSIZE* {.importc: "TABSIZE".}: cint
  ttytype* {.importc: "ttytype".}: cstring

template BUTTON_CHANGED*(x: untyped): untyped =
  (Mouse_status.changes and (1 shl ((x) - 1)))

template BUTTON_STATUS*(x: untyped): untyped =
  (Mouse_status.button[(x) - 1])

template ACS_PICK*(w, n: untyped): untyped = int32(w) or A_ALTCHARSET

template KEY_F*(n: untyped): untyped = KEY_F0 + n

template COLOR_PAIR*(n: untyped): untyped =
  ((cunsignedlong(n) shl COLOR_SHIFT) and A_COLOR)

template PAIR_NUMBER*(n: untyped): untyped =
  (((n) and A_COLOR) shr COLOR_SHIFT)

const
  ACS_URCORNER* = ACS_PICK('k', '+')
  ACS_BBSS* = ACS_URCORNER
  ACS_BLOCK* = ACS_PICK('0', '#')
  ACS_BOARD* = ACS_PICK('h', '#')
  ACS_BTEE* = ACS_PICK('v', '+')
  ACS_BULLET* = ACS_PICK('~', 'o')
  ACS_CKBOARD* = ACS_PICK('a', ':')
  ACS_DARROW* = ACS_PICK('.', 'v')
  ACS_DEGREE* = ACS_PICK('f', '\'')
  ACS_DIAMOND* = ACS_PICK('`', '+')
  ACS_GEQUAL* = ACS_PICK('z', '>')
  ACS_HLINE* = ACS_PICK('q', '-')
  ACS_BSBS* = ACS_HLINE
  ACS_LANTERN* = ACS_PICK('i', '*')
  ACS_LARROW* = ACS_PICK(',', '<')
  ACS_LEQUAL* = ACS_PICK('y', '<')
  ACS_LLCORNER* = ACS_PICK('m', '+')
  ACS_LRCORNER* = ACS_PICK('j', '+')
  ACS_LTEE* = ACS_PICK('t', '+')
  ACS_NEQUAL* = ACS_PICK('|', '+')
  ACS_PI* = ACS_PICK('{', 'n')
  ACS_PLMINUS* = ACS_PICK('g', '#')
  ACS_PLUS* = ACS_PICK('n', '+')
  ACS_RARROW* = ACS_PICK('+', '>')
  ACS_RTEE* = ACS_PICK('u', '+')
  ACS_S1* = ACS_PICK('o', '-')
  ACS_S3* = ACS_PICK('p', '-')
  ACS_S7* = ACS_PICK('r', '-')
  ACS_S9* = ACS_PICK('s', '_')
  ACS_SBBS* = ACS_LRCORNER
  ACS_SBSS* = ACS_RTEE
  ACS_SSBB* = ACS_LLCORNER
  ACS_SSBS* = ACS_BTEE
  ACS_SSSB* = ACS_LTEE
  ACS_SSSS* = ACS_PLUS
  ACS_STERLING* = ACS_PICK('}', 'L')
  ACS_TTEE* = ACS_PICK('w', '+')
  ACS_BSSS* = ACS_TTEE
  ACS_UARROW* = ACS_PICK('-', '^')
  ACS_ULCORNER* = ACS_PICK('l', '+')
  ACS_BSSB* = ACS_ULCORNER
  ACS_VLINE* = ACS_PICK('x', '|')
  ACS_SBSB* = ACS_VLINE
discard """WACS_ULCORNER* = (addr((acs_map['l'])))
  WACS_LLCORNER* = (addr((acs_map['m'])))
  WACS_URCORNER* = (addr((acs_map['k'])))
  WACS_LRCORNER* = (addr((acs_map['j'])))
  WACS_RTEE* = (addr((acs_map['u'])))
  WACS_LTEE* = (addr((acs_map['t'])))
  WACS_BTEE* = (addr((acs_map['v'])))
  WACS_TTEE* = (addr((acs_map['w'])))
  WACS_HLINE* = (addr((acs_map['q'])))
  WACS_VLINE* = (addr((acs_map['x'])))
  WACS_PLUS* = (addr((acs_map['n'])))
  WACS_S1* = (addr((acs_map['o'])))
  WACS_S9* = (addr((acs_map['s'])))
  WACS_DIAMOND* = (addr((acs_map['`'])))
  WACS_CKBOARD* = (addr((acs_map['a'])))
  WACS_DEGREE* = (addr((acs_map['f'])))
  WACS_PLMINUS* = (addr((acs_map['g'])))
  WACS_BULLET* = (addr((acs_map['~'])))
  WACS_LARROW* = (addr((acs_map[','])))
  WACS_RARROW* = (addr((acs_map['+'])))
  WACS_DARROW* = (addr((acs_map['.'])))
  WACS_UARROW* = (addr((acs_map['-'])))
  WACS_BOARD* = (addr((acs_map['h'])))
  WACS_LANTERN* = (addr((acs_map['i'])))
  WACS_BLOCK* = (addr((acs_map['0'])))
  WACS_S3* = (addr((acs_map['p'])))
  WACS_S7* = (addr((acs_map['r'])))
  WACS_LEQUAL* = (addr((acs_map['y'])))
  WACS_GEQUAL* = (addr((acs_map['z'])))
  WACS_PI* = (addr((acs_map['{'])))
  WACS_NEQUAL* = (addr((acs_map['|'])))
  WACS_STERLING* = (addr((acs_map['}'])))
  WACS_BSSB* = WACS_ULCORNER
  WACS_SSBB* = WACS_LLCORNER
  WACS_BBSS* = WACS_URCORNER
  WACS_SBBS* = WACS_LRCORNER
  WACS_SBSS* = WACS_RTEE
  WACS_SSSB* = WACS_LTEE
  WACS_SSBS* = WACS_BTEE
  WACS_BSSS* = WACS_TTEE
  WACS_BSBS* = WACS_HLINE
  WACS_SBSB* = WACS_VLINE
  WACS_SSSS* = WACS_PLUS"""

{.push discardable.}

proc add_wch*(a2: ptr cunsignedlong): cint {.importc: "add_wch".}
proc add_wchnstr*(a2: ptr cunsignedlong; a3: cint): cint {.importc: "add_wchnstr".}
proc add_wchstr*(a2: ptr cunsignedlong): cint {.importc: "add_wchstr".}
proc addch*(a2: cunsignedlong): cint {.importc: "addch".}
proc addchnstr*(a2: ptr cunsignedlong; a3: cint): cint {.importc: "addchnstr".}
proc addchstr*(a2: ptr cunsignedlong): cint {.importc: "addchstr".}
proc addnstr*(a2: cstring; a3: cint): cint {.importc: "addnstr".}
proc addnwstr*(a2: cstring; a3: cint): cint {.importc: "addnwstr".}
proc addrawch*(a2: cunsignedlong): cint {.importc: "addrawch".}
proc addstr*(a2: cstring): cint {.importc: "addstr".}
proc addwstr*(a2: cstring): cint {.importc: "addwstr".}
proc assume_default_colors*(a2, a3: cint): cint {.importc: "assume_default_colors".}
proc attr_get*(a2: ptr cunsignedlong; a3: ptr cshort; a4: pointer): cint {.importc: "attr_get".}
proc attr_off*(a2: cunsignedlong; a3: pointer): cint {.importc: "attr_off".}
proc attr_on*(a2: cunsignedlong; a3: pointer): cint {.importc: "attr_on".}
proc attr_set*(a2: cunsignedlong; a3: cshort; a4: pointer): cint {.importc: "attr_set".}
proc attroff*(a2: cunsignedlong): cint {.importc: "attroff".}
proc attron*(a2: cunsignedlong): cint {.importc: "attron".}
proc attrset*(a2: cunsignedlong): cint {.importc: "attrset".}
proc baudrate*(): cint {.importc: "baudrate".}
proc beep*(): cint {.importc: "beep".}
proc bkgd*(a2: cunsignedlong): cint {.importc: "bkgd".}
proc bkgdset*(a2: cunsignedlong) {.importc: "bkgdset".}
proc border_set*(a2, a3, a4, a5, a6, a7, a8, a9: ptr cunsignedlong): cint {.importc: "border_set".}
proc border*(a2, a3, a4, a5, a6, a7, a8, a9: cunsignedlong): cint {.importc: "border".}
proc bottom_panel*(pan: ptr PANEL): cint {.importc: "bottom_panel".}
proc box_set*(a2: ptr WINDOW; a3, a4: ptr cunsignedlong): cint {.importc: "box_set".}
proc box*(a2: ptr WINDOW; a3, a4: cunsignedlong): cint {.importc: "box".}
proc can_change_color*(): cunsignedchar {.importc: "can_change_color".}
proc cbreak*(): cint {.importc: "cbreak".}
proc chgat*(a2: cint; a3: cunsignedlong; a4: cshort; a5: pointer): cint {.importc: "chgat".}
proc clear*(): cint {.importc: "clear".}
proc clearclipboard*(): cint {.importc: "PDC_clearclipboard".}
proc clearok*(a2: ptr WINDOW; a3: cunsignedchar): cint {.importc: "clearok".}
proc clrtobot*(): cint {.importc: "clrtobot".}
proc clrtoeol*(): cint {.importc: "clrtoeol".}
proc color_content*(a2: cshort; a3, a4, a5: ptr cshort): cint {.importc: "color_content".}
proc color_set*(a2: cshort; a3: pointer): cint {.importc: "color_set".}
proc copywin*(a2, a3: ptr WINDOW; a4, a5, a6, a7, a8, a9, a10: cint): cint {.importc: "copywin".}
proc crmode*(): cint {.importc: "crmode".}
proc curs_set*(a2: cint): cint {.importc: "curs_set".}
proc curses_version*(): cstring{.importc: "curses_version".}
proc debug*(a2: cstring) {.varargs, importc: "PDC_debug".}
proc def_prog_mode*(): cint {.importc: "def_prog_mode".}
proc def_shell_mode*(): cint {.importc: "def_shell_mode".}
proc del_panel*(pan: ptr PANEL): cint {.importc: "del_panel".}
proc delay_output*(a2: cint): cint {.importc: "delay_output".}
proc delch*(): cint {.importc: "delch".}
proc deleteln*(): cint {.importc: "deleteln".}
proc delscreen*(a2: ptr SCREEN) {.importc: "delscreen".}
proc delwin*(a2: ptr WINDOW): cint {.importc: "delwin".}
proc derwin*(a2: ptr WINDOW; a3, a4, a5, a6: cint): ptr WINDOW {.importc: "derwin".}
proc doupdate*(): cint {.importc: "doupdate".}
proc draino*(a2: cint): cint {.importc: "draino".}
proc dupwin*(a2: ptr WINDOW): ptr WINDOW{.importc: "dupwin".}
proc echo_wchar*(a2: ptr cunsignedlong): cint {.importc: "echo_wchar".}
proc echo*(): cint {.importc: "echo".}
proc echochar*(a2: cunsignedlong): cint {.importc: "echochar".}
proc endwin*(): cint {.importc: "endwin".}
proc erase*(): cint {.importc: "erase".}
proc erasechar*(): char {.importc: "erasechar".}
proc erasewchar*(a2: cstring): cint {.importc: "erasewchar".}
proc filter*() {.importc: "filter".}
proc fixterm*(): cint {.importc: "fixterm".}
proc flash*(): cint {.importc: "flash".}
proc flushinp*(): cint {.importc: "flushinp".}
proc freeclipboard*(a2: cstring): cint {.importc: "PDC_freeclipboard".}
proc get_input_fd*(): cunsignedlong {.importc: "PDC_get_input_fd".}
proc get_key_modifiers*(): cunsignedlong {.importc: "PDC_get_key_modifiers".}
proc get_wch*(a2: ptr cint): cint {.importc: "get_wch".}
proc get_wstr*(a2: ptr cint): cint {.importc: "get_wstr".}
proc getattrs*(a2: ptr WINDOW): cunsignedlong{.importc: "getattrs".}
proc getbegx*(a2: ptr WINDOW): cint {.importc: "getbegx".}
proc getbegy*(a2: ptr WINDOW): cint {.importc: "getbegy".}
proc getbkgd*(a2: ptr WINDOW): cunsignedlong{.importc: "getbkgd".}
proc getbkgrnd*(a2: ptr cunsignedlong): cint {.importc: "getbkgrnd".}
proc getbmap*(): cunsignedlong{.importc: "getbmap".}
proc getcchar*(a2: ptr cunsignedlong; a3: cstring; a4: ptr cunsignedlong; a5: ptr cshort; a6: pointer): cint {.importc: "getcchar".}
proc getclipboard*(a2: cstringArray; a3: ptr clong): cint {.importc: "PDC_getclipboard".}
proc getcurx*(a2: ptr WINDOW): cint {.importc: "getcurx".}
proc getcury*(a2: ptr WINDOW): cint {.importc: "getcury".}
proc getmaxx*(a2: ptr WINDOW): cint {.importc: "getmaxx".}
proc getmaxy*(a2: ptr WINDOW): cint {.importc: "getmaxy".}
proc getmouse*(): cunsignedlong{.importc: "getmouse".}
proc getn_wstr*(a2: ptr cint; a3: cint): cint {.importc: "getn_wstr".}
proc getnstr*(a2: cstring; a3: cint): cint {.importc: "getnstr".}
proc getparx*(a2: ptr WINDOW): cint {.importc: "getparx".}
proc getpary*(a2: ptr WINDOW): cint {.importc: "getpary".}
proc getstr*(a2: cstring): cint {.importc: "getstr".}
proc getwin*(a2: File): ptr WINDOW{.importc: "getwin".}
proc halfdelay*(a2: cint): cint {.importc: "halfdelay".}
proc has_colors*(): cunsignedchar {.importc: "has_colors".}
proc has_ic*(): cunsignedchar {.importc: "has_ic".}
proc has_il*(): cunsignedchar {.importc: "has_il".}
proc has_key*(a2: cint): cunsignedchar {.importc: "has_key".}
proc hide_panel*(pan: ptr PANEL): cint {.importc: "hide_panel".}
proc hline_set*(a2: ptr cunsignedlong; a3: cint): cint {.importc: "hline_set".}
proc hline*(a2: cunsignedlong; a3: cint): cint {.importc: "hline".}
proc idcok*(a2: ptr WINDOW; a3: cunsignedchar) {.importc: "idcok".}
proc idlok*(a2: ptr WINDOW; a3: cunsignedchar): cint {.importc: "idlok".}
proc immedok*(a2: ptr WINDOW; a3: cunsignedchar) {.importc: "immedok".}
proc in_wch*(a2: ptr cunsignedlong): cint {.importc: "in_wch".}
proc in_wchnstr*(a2: ptr cunsignedlong; a3: cint): cint {.importc: "in_wchnstr".}
proc in_wchstr*(a2: ptr cunsignedlong): cint {.importc: "in_wchstr".}
proc inch*(): cunsignedlong{.importc: "inch".}
proc inchnstr*(a2: ptr cunsignedlong; a3: cint): cint {.importc: "inchnstr".}
proc inchstr*(a2: ptr cunsignedlong): cint {.importc: "inchstr".}
proc init_color*(a2, a3, a4, a5: cshort): cint {.importc: "init_color".}
proc init_pair*(a2, a3, a4: cshort): cint {.importc: "init_pair".}
proc initscr*(): ptr WINDOW{.importc: "initscr".}
proc innstr*(a2: cstring; a3: cint): cint {.importc: "innstr".}
proc innwstr*(a2: cstring; a3: cint): cint {.importc: "innwstr".}
proc ins_nwstr*(a2: cstring; a3: cint): cint {.importc: "ins_nwstr".}
proc ins_wch*(a2: ptr cunsignedlong): cint {.importc: "ins_wch".}
proc ins_wstr*(a2: cstring): cint {.importc: "ins_wstr".}
proc insch*(a2: cunsignedlong): cint {.importc: "insch".}
proc insdelln*(a2: cint): cint {.importc: "insdelln".}
proc insertln*(): cint {.importc: "insertln".}
proc insnstr*(a2: cstring; a3: cint): cint {.importc: "insnstr".}
proc insrawch*(a2: cunsignedlong): cint {.importc: "insrawch".}
proc insstr*(a2: cstring): cint {.importc: "insstr".}
proc instr*(a2: cstring): cint {.importc: "instr".}
proc intrflush*(a2: ptr WINDOW; a3: cunsignedchar): cint {.importc: "intrflush".}
proc inwstr*(a2: cstring): cint {.importc: "inwstr".}
proc is_linetouched*(a2: ptr WINDOW; a3: cint): cunsignedchar {.importc: "is_linetouched".}
proc is_termresized*(): cunsignedchar {.importc: "is_termresized".}
proc is_wintouched*(a2: ptr WINDOW): cunsignedchar {.importc: "is_wintouched".}
proc isendwin*(): cunsignedchar {.importc: "isendwin".}
proc key_name*(a2: char): cstring{.importc: "key_name".}
proc keyname*(a2: cint): cstring{.importc: "keyname".}
proc keypad*(a2: ptr WINDOW; a3: cunsignedchar): cint {.importc: "keypad".}
proc killchar*(): char {.importc: "killchar".}
proc killwchar*(a2: cstring): cint {.importc: "killwchar".}
proc leaveok*(a2: ptr WINDOW; a3: cunsignedchar): cint {.importc: "leaveok".}
proc longname*(): cstring{.importc: "longname".}
proc map_button*(a2: cunsignedlong): cint {.importc: "map_button".}
proc meta*(a2: ptr WINDOW; a3: cunsignedchar): cint {.importc: "meta".}
proc mouse_off*(a2: cunsignedlong): cint {.importc: "mouse_off".}
proc mouse_on*(a2: cunsignedlong): cint {.importc: "mouse_on".}
proc mouse_set*(a2: cunsignedlong): cint {.importc: "mouse_set".}
proc mouse_trafo*(a2: ptr cint; a3: ptr cint; a4: cunsignedchar): cunsignedchar {.importc: "mouse_trafo".}
proc mouseinterval*(a2: cint): cint {.importc: "mouseinterval".}
proc mousemask*(a2: cunsignedlong; a3: ptr cunsignedlong): cunsignedlong {.importc: "mousemask".}
proc move_panel*(pan: ptr PANEL; starty: cint; startx: cint): cint {.importc: "move_panel".}
proc move*(a2, a3: cint): cint {.importc: "move".}
proc mvadd_wch*(a2, a3: cint; a4: ptr cunsignedlong): cint {.importc: "mvadd_wch".}
proc mvadd_wchnstr*(a2, a3: cint; a4: ptr cunsignedlong; a5: cint): cint {.importc: "mvadd_wchnstr".}
proc mvadd_wchstr*(a2, a3: cint; a4: ptr cunsignedlong): cint {.importc: "mvadd_wchstr".}
proc mvaddch*(a2, a3: cint; a4: cunsignedlong): cint {.importc: "mvaddch".}
proc mvaddchnstr*(a2, a3: cint; a4: ptr cunsignedlong; a5: cint): cint {.importc: "mvaddchnstr".}
proc mvaddchstr*(a2, a3: cint; a4: ptr cunsignedlong): cint {.importc: "mvaddchstr".}
proc mvaddnstr*(a2, a3: cint; a4: cstring; a5: cint): cint {.importc: "mvaddnstr".}
proc mvaddnwstr*(a2, a3: cint; a4: cstring; a5: cint): cint {.importc: "mvaddnwstr".}
proc mvaddrawch*(a2, a3: cint; a4: cunsignedlong): cint {.importc: "mvaddrawch".}
proc mvaddstr*(a2, a3: cint; a4: cstring): cint {.importc: "mvaddstr".}
proc mvaddwstr*(a2, a3: cint; a4: cstring): cint {.importc: "mvaddwstr".}
proc mvchgat*(a2, a3, a4: cint; a5: cunsignedlong; a6: cshort; a7: pointer): cint {.importc: "mvchgat".}
proc mvcur*(a2, a3, a4: cint; a5: cint): cint {.importc: "mvcur".}
proc mvdelch*(a2, a3: cint): cint {.importc: "mvdelch".}
proc mvdeleteln*(a2, a3: cint): cint {.importc: "mvdeleteln".}
proc mvderwin*(a2: ptr WINDOW; a3, a4: cint): cint {.importc: "mvderwin".}
proc mvget_wch*(a2, a3: cint; a4: ptr cint): cint {.importc: "mvget_wch".}
proc mvget_wstr*(a2, a3: cint; a4: ptr cint): cint {.importc: "mvget_wstr".}
proc mvgetch*(a2, a3: cint): cint {.importc: "mvgetch".}
proc mvgetn_wstr*(a2, a3: cint; a4: ptr cint; a5: cint): cint {.importc: "mvgetn_wstr".}
proc mvgetnstr*(a2, a3: cint; a4: cstring; a5: cint): cint {.importc: "mvgetnstr".}
proc mvgetstr*(a2, a3: cint; a4: cstring): cint {.importc: "mvgetstr".}
proc mvhline_set*(a2, a3: cint; a4: ptr cunsignedlong; a5: cint): cint {.importc: "mvhline_set".}
proc mvhline*(a2, a3: cint; a4: cunsignedlong; a5: cint): cint {.importc: "mvhline".}
proc mvin_wch*(a2, a3: cint; a4: ptr cunsignedlong): cint {.importc: "mvin_wch".}
proc mvin_wchnstr*(a2, a3: cint; a4: ptr cunsignedlong; a5: cint): cint {.importc: "mvin_wchnstr".}
proc mvin_wchstr*(a2, a3: cint; a4: ptr cunsignedlong): cint {.importc: "mvin_wchstr".}
proc mvinch*(a2, a3: cint): cunsignedlong{.importc: "mvinch".}
proc mvinchnstr*(a2, a3: cint; a4: ptr cunsignedlong; a5: cint): cint {.importc: "mvinchnstr".}
proc mvinchstr*(a2, a3: cint; a4: ptr cunsignedlong): cint {.importc: "mvinchstr".}
proc mvinnstr*(a2, a3: cint; a4: cstring; a5: cint): cint {.importc: "mvinnstr".}
proc mvinnwstr*(a2, a3: cint; a4: cstring; a5: cint): cint {.importc: "mvinnwstr".}
proc mvins_nwstr*(a2, a3: cint; a4: cstring; a5: cint): cint {.importc: "mvins_nwstr".}
proc mvins_wch*(a2, a3: cint; a4: ptr cunsignedlong): cint {.importc: "mvins_wch".}
proc mvins_wstr*(a2, a3: cint; a4: cstring): cint {.importc: "mvins_wstr".}
proc mvinsch*(a2, a3: cint; a4: cunsignedlong): cint {.importc: "mvinsch".}
proc mvinsertln*(a2, a3: cint): cint {.importc: "mvinsertln".}
proc mvinsnstr*(a2, a3: cint; a4: cstring; a5: cint): cint {.importc: "mvinsnstr".}
proc mvinsrawch*(a2, a3: cint; a4: cunsignedlong): cint {.importc: "mvinsrawch".}
proc mvinsstr*(a2, a3: cint; a4: cstring): cint {.importc: "mvinsstr".}
proc mvinstr*(a2, a3: cint; a4: cstring): cint {.importc: "mvinstr".}
proc mvinwstr*(a2, a3: cint; a4: cstring): cint {.importc: "mvinwstr".}
proc mvprintw*(a2, a3: cint; a4: cstring): cint {.varargs, importc: "mvprintw".}
proc mvscanw*(a2, a3: cint; a4: cstring): cint {.varargs, importc: "mvscanw".}
proc mvvline_set*(a2, a3: cint; a4: ptr cunsignedlong; a5: cint): cint {.importc: "mvvline_set".}
proc mvvline*(a2, a3: cint; a4: cunsignedlong; a5: cint): cint {.importc: "mvvline".}
proc mvwadd_wch*(a2: ptr WINDOW; a3, a4: cint; a5: ptr cunsignedlong): cint {.importc: "mvwadd_wch".}
proc mvwadd_wchnstr*(a2: ptr WINDOW; a3, a4: cint; a5: ptr cunsignedlong; a6: cint): cint {.importc: "mvwadd_wchnstr".}
proc mvwadd_wchstr*(a2: ptr WINDOW; a3, a4: cint; a5: ptr cunsignedlong): cint {.importc: "mvwadd_wchstr".}
proc mvwaddch*(a2: ptr WINDOW; a3, a4: cint; a5: cunsignedlong): cint {.importc: "mvwaddch".}
proc mvwaddchnstr*(a2: ptr WINDOW; a3, a4: cint; a5: ptr cunsignedlong; a6: cint): cint {.importc: "mvwaddchnstr".}
proc mvwaddchstr*(a2: ptr WINDOW; a3, a4: cint; a5: ptr cunsignedlong): cint {.importc: "mvwaddchstr".}
proc mvwaddnstr*(a2: ptr WINDOW; a3, a4: cint; a5: cstring; a6: cint): cint {.importc: "mvwaddnstr".}
proc mvwaddnwstr*(a2: ptr WINDOW; a3, a4: cint; a5: cstring; a6: cint): cint {.importc: "mvwaddnwstr".}
proc mvwaddrawch*(a2: ptr WINDOW; a3, a4: cint; a5: cunsignedlong): cint {.importc: "mvwaddrawch".}
proc mvwaddstr*(a2: ptr WINDOW; a3, a4: cint; a5: cstring): cint {.importc: "mvwaddstr".}
proc mvwaddwstr*(a2: ptr WINDOW; a3, a4: cint; a5: cstring): cint {.importc: "mvwaddwstr".}
proc mvwchgat*(a2: ptr WINDOW; a3, a4: cint; a5: cint; a6: cunsignedlong; a7: cshort; a8: pointer): cint {.importc: "mvwchgat".}
proc mvwdelch*(a2: ptr WINDOW; a3, a4: cint): cint {.importc: "mvwdelch".}
proc mvwdeleteln*(a2: ptr WINDOW; a3, a4: cint): cint {.importc: "mvwdeleteln".}
proc mvwget_wch*(a2: ptr WINDOW; a3, a4: cint; a5: ptr cint): cint {.importc: "mvwget_wch".}
proc mvwget_wstr*(a2: ptr WINDOW; a3, a4: cint; a5: ptr cint): cint {.importc: "mvwget_wstr".}
proc mvwgetch*(a2: ptr WINDOW; a3, a4: cint): cint {.importc: "mvwgetch".}
proc mvwgetn_wstr*(a2: ptr WINDOW; a3, a4: cint; a5: ptr cint; a6: cint): cint {.importc: "mvwgetn_wstr".}
proc mvwgetnstr*(a2: ptr WINDOW; a3, a4: cint; a5: cstring; a6: cint): cint {.importc: "mvwgetnstr".}
proc mvwgetstr*(a2: ptr WINDOW; a3, a4: cint; a5: cstring): cint {.importc: "mvwgetstr".}
proc mvwhline_set*(a2: ptr WINDOW; a3, a4: cint; a5: ptr cunsignedlong; a6: cint): cint {.importc: "mvwhline_set".}
proc mvwhline*(a2: ptr WINDOW; a3, a4: cint; a5: cunsignedlong; a6: cint): cint {.importc: "mvwhline".}
proc mvwin_wch*(a2: ptr WINDOW; a3, a4: cint; a5: ptr cunsignedlong): cint {.importc: "mvwin_wch".}
proc mvwin_wchnstr*(a2: ptr WINDOW; a3, a4: cint; a5: ptr cunsignedlong; a6: cint): cint {.importc: "mvwin_wchnstr".}
proc mvwin_wchstr*(a2: ptr WINDOW; a3, a4: cint; a5: ptr cunsignedlong): cint {.importc: "mvwin_wchstr".}
proc mvwin*(a2: ptr WINDOW; a3, a4: cint): cint {.importc: "mvwin".}
proc mvwinch*(a2: ptr WINDOW; a3, a4: cint): cunsignedlong {.importc: "mvwinch".}
proc mvwinchnstr*(a2: ptr WINDOW; a3, a4: cint; a5: ptr cunsignedlong;  a6: cint): cint {.importc: "mvwinchnstr".}
proc mvwinchstr*(a2: ptr WINDOW; a3, a4: cint; a5: ptr cunsignedlong): cint {.importc: "mvwinchstr".}
proc mvwinnstr*(a2: ptr WINDOW; a3, a4: cint; a5: cstring; a6: cint): cint {.importc: "mvwinnstr".}
proc mvwinnwstr*(a2: ptr WINDOW; a3, a4: cint; a5: cstring; a6: cint): cint {.importc: "mvwinnwstr".}
proc mvwins_nwstr*(a2: ptr WINDOW; a3, a4: cint; a5: cstring; a6: cint): cint {.importc: "mvwins_nwstr".}
proc mvwins_wch*(a2: ptr WINDOW; a3, a4: cint; a5: ptr cunsignedlong): cint {.importc: "mvwins_wch".}
proc mvwins_wstr*(a2: ptr WINDOW; a3, a4: cint; a5: cstring): cint {.importc: "mvwins_wstr".}
proc mvwinsch*(a2: ptr WINDOW; a3, a4: cint; a5: cunsignedlong): cint {.importc: "mvwinsch".}
proc mvwinsertln*(a2: ptr WINDOW; a3, a4: cint): cint {.importc: "mvwinsertln".}
proc mvwinsnstr*(a2: ptr WINDOW; a3, a4: cint; a5: cstring; a6: cint): cint {.importc: "mvwinsnstr".}
proc mvwinsrawch*(a2: ptr WINDOW; a3, a4: cint; a5: cunsignedlong): cint {.importc: "mvwinsrawch".}
proc mvwinsstr*(a2: ptr WINDOW; a3, a4: cint; a5: cstring): cint {.importc: "mvwinsstr".}
proc mvwinstr*(a2: ptr WINDOW; a3, a4: cint; a5: cstring): cint {.importc: "mvwinstr".}
proc mvwinwstr*(a2: ptr WINDOW; a3, a4: cint; a5: cstring): cint {.importc: "mvwinwstr".}
proc mvwprintw*(a2: ptr WINDOW; a3, a4: cint; a5: cstring): cint {.varargs, importc: "mvwprintw".}
proc mvwscanw*(a2: ptr WINDOW; a3, a4: cint; a5: cstring): cint {.varargs, importc: "mvwscanw".}
proc mvwvline_set*(a2: ptr WINDOW; a3, a4: cint; a5: ptr cunsignedlong; a6: cint): cint {.importc: "mvwvline_set".}
proc mvwvline*(a2: ptr WINDOW; a3, a4: cint; a5: cunsignedlong; a6: cint): cint {.importc: "mvwvline".}
proc napms*(a2: cint): cint {.importc: "napms".}
proc nc_getmouse*(a2: ptr MEVENT): cint {.importc: "nc_getmouse".}
proc new_panel*(win: ptr WINDOW): ptr PANEL{.importc: "new_panel".}
proc newpad*(a2, a3: cint): ptr WINDOW{.importc: "newpad".}
proc newterm*(a2: cstring; a3, a4: File): ptr SCREEN {.importc: "newterm".}
proc newwin*(a2, a3, a4, a5: cint): ptr WINDOW {.importc: "newwin".}
proc nl*(): cint {.importc: "nl".}
proc nocbreak*(): cint {.importc: "nocbreak".}
proc nocrmode*(): cint {.importc: "nocrmode".}
proc nodelay*(a2: ptr WINDOW; a3: cunsignedchar): cint {.importc: "nodelay".}
proc noecho*(): cint {.importc: "noecho".}
proc nonl*(): cint {.importc: "nonl".}
proc noqiflush*() {.importc: "noqiflush".}
proc noraw*(): cint {.importc: "noraw".}
proc notimeout*(a2: ptr WINDOW; a3: cunsignedchar): cint {.importc: "notimeout".}
proc overlay*(a2, a3: ptr WINDOW): cint {.importc: "overlay".}
proc overwrite*(a2, a3: ptr WINDOW): cint {.importc: "overwrite".}
proc pair_content*(a2, a3, a4: ptr cshort): cint {.importc: "pair_content".}
proc panel_above*(pan: ptr PANEL): ptr PANEL{.importc: "panel_above".}
proc panel_below*(pan: ptr PANEL): ptr PANEL{.importc: "panel_below".}
proc panel_hidden*(pan: ptr PANEL): cint {.importc: "panel_hidden".}
proc panel_userptr*(pan: ptr PANEL): pointer{.importc: "panel_userptr".}
proc panel_window*(pan: ptr PANEL): ptr WINDOW{.importc: "panel_window".}
proc pecho_wchar*(a2: ptr WINDOW; a3: ptr cunsignedlong): cint {.importc: "pecho_wchar".}
proc pechochar*(a2: ptr WINDOW; a3: cunsignedlong): cint {.importc: "pechochar".}
proc pnoutrefresh*(a2: ptr WINDOW; a3, a4, a5, a6, a7, a8: cint): cint {.importc: "pnoutrefresh".}
proc prefresh*(a2: ptr WINDOW; a3, a4, a5, a6, a7, a8: cint): cint {.importc: "prefresh".}
proc printw*(a2: cstring): cint {.varargs, importc: "printw".}
proc putwin*(a2: ptr WINDOW; a3: File): cint {.importc: "putwin".}
proc qiflush*() {.importc: "qiflush".}
proc raw_output*(a2: cunsignedchar): cint {.importc: "raw_output".}
proc raw*(): cint {.importc: "raw".}
proc redrawwin*(a2: ptr WINDOW): cint {.importc: "redrawwin".}
proc refresh*(): cint {.importc: "refresh".}
proc replace_panel*(pan: ptr PANEL; win: ptr WINDOW): cint {.importc: "replace_panel".}
proc request_mouse_pos*(): cint {.importc: "request_mouse_pos".}
proc reset_prog_mode*(): cint {.importc: "reset_prog_mode".}
proc reset_shell_mode*(): cint {.importc: "reset_shell_mode".}
proc resetterm*(): cint {.importc: "resetterm".}
proc resetty*(): cint {.importc: "resetty".}
proc resize_term*(a2, a3: cint): cint {.importc: "resize_term".}
proc resize_window*(a2: ptr WINDOW; a3, a4: cint): ptr WINDOW{.importc: "resize_window".}
proc return_key_modifiers*(a2: cunsignedchar): cint {.importc: "PDC_return_key_modifiers".}
proc save_key_modifiers*(a2: cunsignedchar): cint {.importc: "PDC_save_key_modifiers".}
proc saveterm*(): cint {.importc: "saveterm".}
proc savetty*(): cint {.importc: "savetty".}
proc scanw*(a2: cstring): cint {.varargs, importc: "scanw".}
proc scr_dump*(a2: cstring): cint {.importc: "scr_dump".}
proc scr_init*(a2: cstring): cint {.importc: "scr_init".}
proc scr_restore*(a2: cstring): cint {.importc: "scr_restore".}
proc scr_set*(a2: cstring): cint {.importc: "scr_set".}
proc scrl*(a2: cint): cint {.importc: "scrl".}
proc scroll*(a2: ptr WINDOW): cint {.importc: "scroll".}
proc scrollok*(a2: ptr WINDOW; a3: cunsignedchar): cint {.importc: "scrollok".}
proc set_blink*(a2: cunsignedchar): cint {.importc: "PDC_set_blink".}
proc set_line_color*(a2: cshort): cint {.importc: "PDC_set_line_color".}
proc set_panel_userptr*(pan: ptr PANEL; uptr: pointer): cint {.importc: "set_panel_userptr".}
proc set_term*(a2: ptr SCREEN): ptr SCREEN{.importc: "set_term".}
proc set_title*(a2: cstring) {.importc: "PDC_set_title".}
proc setcchar*(a2: ptr cunsignedlong; a3: cstring; a4: cunsignedlong; a5: cshort; a6: pointer): cint {.importc: "setcchar".}
proc setclipboard*(a2: cstring; a3: clong): cint {.importc: "PDC_setclipboard".}
proc setscrreg*(a2, a3: cint): cint {.importc: "setscrreg".}
proc setsyx*(a2, a3: cint): cint {.importc: "setsyx".}
proc show_panel*(pan: ptr PANEL): cint {.importc: "show_panel".}
proc slk_attr_off*(a2: cunsignedlong; a3: pointer): cint {.importc: "slk_attr_off".}
proc slk_attr_on*(a2: cunsignedlong; a3: pointer): cint {.importc: "slk_attr_on".}
proc slk_attr_set*(a2: cunsignedlong; a3: cshort; a4: pointer): cint {.importc: "slk_attr_set".}
proc slk_attroff*(a2: cunsignedlong): cint {.importc: "slk_attroff".}
proc slk_attron*(a2: cunsignedlong): cint {.importc: "slk_attron".}
proc slk_attrset*(a2: cunsignedlong): cint {.importc: "slk_attrset".}
proc slk_clear*(): cint {.importc: "slk_clear".}
proc slk_color*(a2: cshort): cint {.importc: "slk_color".}
proc slk_init*(a2: cint): cint {.importc: "slk_init".}
proc slk_label*(a2: cint): cstring{.importc: "slk_label".}
proc slk_noutrefresh*(): cint {.importc: "slk_noutrefresh".}
proc slk_refresh*(): cint {.importc: "slk_refresh".}
proc slk_restore*(): cint {.importc: "slk_restore".}
proc slk_set*(a2: cint; a3: cstring; a4: cint): cint {.importc: "slk_set".}
proc slk_touch*(): cint {.importc: "slk_touch".}
proc slk_wlabel*(a2: cint): cstring {.importc: "slk_wlabel".}
proc slk_wset*(a2: cint; a3: cstring; a4: cint): cint {.importc: "slk_wset".}
proc standend*(): cint {.importc: "standend".}
proc standout*(): cint {.importc: "standout".}
proc start_color*(): cint {.importc: "start_color".}
proc subpad*(a2: ptr WINDOW; a3, a4: cint; a5: cint; a6: cint): ptr WINDOW {.importc: "subpad".}
proc subwin*(a2: ptr WINDOW; a3, a4: cint; a5: cint; a6: cint): ptr WINDOW {.importc: "subwin".}
proc syncok*(a2: ptr WINDOW; a3: cunsignedchar): cint {.importc: "syncok".}
proc termattrs*(): cunsignedlong{.importc: "termattrs".}
proc termattrs2*(): cunsignedlong{.importc: "term_attrs".}
proc termname*(): cstring{.importc: "termname".}
proc timeout*(a2: cint) {.importc: "timeout".}
proc top_panel*(pan: ptr PANEL): cint {.importc: "top_panel".}
proc touchline*(a2: ptr WINDOW; a3, a4: cint): cint {.importc: "touchline".}
proc touchwin*(a2: ptr WINDOW): cint {.importc: "touchwin".}
proc traceoff*() {.importc: "traceoff".}
proc traceon*() {.importc: "traceon".}
proc typeahead*(a2: cint): cint {.importc: "typeahead".}
proc unctrl*(a2: cunsignedlong): cstring{.importc: "unctrl".}
proc unget_wch*(a2: char): cint {.importc: "unget_wch".}
proc ungetch*(a2: cint): cint {.importc: "PDC_ungetch".}
proc ungetmouse*(a2: ptr MEVENT): cint {.importc: "ungetmouse".}
proc untouchwin*(a2: ptr WINDOW): cint {.importc: "untouchwin".}
proc update_panels*() {.importc: "update_panels".}
proc use_default_colors*(): cint {.importc: "use_default_colors".}
proc use_env*(a2: cunsignedchar) {.importc: "use_env".}
proc vid_attr*(a2: cunsignedlong; a3: cshort; a4: pointer): cint {.importc: "vid_attr".}
proc vidattr*(a2: cunsignedlong): cint {.importc: "vidattr".}
proc vline_set*(a2: ptr cunsignedlong; a3: cint): cint {.importc: "vline_set".}
proc vline*(a2: cunsignedlong; a3: cint): cint {.importc: "vline".}
proc vwprintw*(a2: ptr WINDOW; a3: cstring): cint {.varargs, importc: "vw_printw".}
proc vwprintw2*(a2: ptr WINDOW; a3: cstring): cint {.varargs, importc: "vwprintw".}
proc vwscanw*(a2: ptr WINDOW; a3: cstring): cint {.varargs, importc: "vw_scanw".}
proc vwscanw2*(a2: ptr WINDOW; a3: cstring): cint {.varargs, importc: "vwscanw".}
proc wadd_wch*(a2: ptr WINDOW; a3: ptr cunsignedlong): cint {.importc: "wadd_wch".}
proc wadd_wchnstr*(a2: ptr WINDOW; a3: ptr cunsignedlong; a4: cint): cint {.importc: "wadd_wchnstr".}
proc wadd_wchstr*(a2: ptr WINDOW; a3: ptr cunsignedlong): cint {.importc: "wadd_wchstr".}
proc waddch*(a2: ptr WINDOW; a3: cunsignedlong): cint {.importc: "waddch".}
proc waddchnstr*(a2: ptr WINDOW; a3: ptr cunsignedlong; a4: cint): cint {.importc: "waddchnstr".}
proc waddchstr*(a2: ptr WINDOW; a3: ptr cunsignedlong): cint {.importc: "waddchstr".}
proc waddnstr*(a2: ptr WINDOW; a3: cstring; a4: cint): cint {.importc: "waddnstr".}
proc waddnwstr*(a2: ptr WINDOW; a3: cstring; a4: cint): cint {.importc: "waddnwstr".}
proc waddrawch*(a2: ptr WINDOW; a3: cunsignedlong): cint {.importc: "waddrawch".}
proc waddstr*(a2: ptr WINDOW; a3: cstring): cint {.importc: "waddstr".}
proc waddwstr*(a2: ptr WINDOW; a3: cstring): cint {.importc: "waddwstr".}
proc wattr_get*(a2: ptr WINDOW; a3: ptr cunsignedlong; a4: ptr cshort; a5: pointer): cint {.importc: "wattr_get".}
proc wattr_off*(a2: ptr WINDOW; a3: cunsignedlong; a4: pointer): cint {.importc: "wattr_off".}
proc wattr_on*(a2: ptr WINDOW; a3: cunsignedlong; a4: pointer): cint {.importc: "wattr_on".}
proc wattr_set*(a2: ptr WINDOW; a3: cunsignedlong; a4: cshort; a5: pointer): cint {.importc: "wattr_set".}
proc wattroff*(a2: ptr WINDOW; a3: cunsignedlong): cint {.importc: "wattroff".}
proc wattron*(a2: ptr WINDOW; a3: cunsignedlong): cint {.importc: "wattron".}
proc wattrset*(a2: ptr WINDOW; a3: cunsignedlong): cint {.importc: "wattrset".}
proc wbkgd*(a2: ptr WINDOW; a3: cunsignedlong): cint {.importc: "wbkgd".}
proc wbkgdset*(a2: ptr WINDOW; a3: cunsignedlong) {.importc: "wbkgdset".}
proc wbkgrnd*(a2: ptr WINDOW; a3: ptr cunsignedlong): cint {.importc: "wbkgrnd".}
proc wbkgrndset*(a2: ptr WINDOW; a3: ptr cunsignedlong) {.importc: "wbkgrndset".}
proc wborder_set*(a2: ptr WINDOW; a3, a4, a5, a6, a7, a8, a9, a10: ptr cunsignedlong): cint {.importc: "wborder_set".}
proc wborder*(a2: ptr WINDOW; a3, a4, a5, a6, a7, a8, a9, a10: cunsignedlong): cint {.importc: "wborder".}
proc wchgat*(a2: ptr WINDOW; a3: cint; a4: cunsignedlong; a5: cshort; a6: pointer): cint {.importc: "wchgat".}
proc wclear*(a2: ptr WINDOW): cint {.importc: "wclear".}
proc wclrtobot*(a2: ptr WINDOW): cint {.importc: "wclrtobot".}
proc wclrtoeol*(a2: ptr WINDOW): cint {.importc: "wclrtoeol".}
proc wcolor_set*(a2: ptr WINDOW; a3: cshort; a4: pointer): cint {.importc: "wcolor_set".}
proc wcursyncup*(a2: ptr WINDOW) {.importc: "wcursyncup".}
proc wdelch*(a2: ptr WINDOW): cint {.importc: "wdelch".}
proc wdeleteln*(a2: ptr WINDOW): cint {.importc: "wdeleteln".}
proc wecho_wchar*(a2: ptr WINDOW; a3: ptr cunsignedlong): cint {.importc: "wecho_wchar".}
proc wechochar*(a2: ptr WINDOW; a3: cunsignedlong): cint {.importc: "wechochar".}
proc wenclose*(a2: ptr WINDOW; a3, a4: cint): cunsignedchar {.importc: "wenclose".}
proc werase*(a2: ptr WINDOW): cint {.importc: "werase".}
proc wget_wch*(a2: ptr WINDOW; a3: ptr cint): cint {.importc: "wget_wch".}
proc wget_wstr*(a2: ptr WINDOW; a3: ptr cint): cint {.importc: "wget_wstr".}
proc wgetbkgrnd*(a2: ptr WINDOW; a3: ptr cunsignedlong): cint {.importc: "wgetbkgrnd".}
proc wgetch*(a2: ptr WINDOW): cint {.importc: "wgetch".}
proc wgetn_wstr*(a2: ptr WINDOW; a3: ptr cint; a4: cint): cint {.importc: "wgetn_wstr".}
proc wgetnstr*(a2: ptr WINDOW; a3: cstring; a4: cint): cint {.importc: "wgetnstr".}
proc wgetstr*(a2: ptr WINDOW; a3: cstring): cint {.importc: "wgetstr".}
proc whline_set*(a2: ptr WINDOW; a3: ptr cunsignedlong; a4: cint): cint {.importc: "whline_set".}
proc whline*(a2: ptr WINDOW; a3: cunsignedlong; a4: cint): cint {.importc: "whline".}
proc win_wch*(a2: ptr WINDOW; a3: ptr cunsignedlong): cint {.importc: "win_wch".}
proc win_wchnstr*(a2: ptr WINDOW; a3: ptr cunsignedlong; a4: cint): cint {.importc: "win_wchnstr".}
proc win_wchstr*(a2: ptr WINDOW; a3: ptr cunsignedlong): cint {.importc: "win_wchstr".}
proc winch*(a2: ptr WINDOW): cunsignedlong{.importc: "winch".}
proc winchnstr*(a2: ptr WINDOW; a3: ptr cunsignedlong; a4: cint): cint {.importc: "winchnstr".}
proc winchstr*(a2: ptr WINDOW; a3: ptr cunsignedlong): cint {.importc: "winchstr".}
proc winnstr*(a2: ptr WINDOW; a3: cstring; a4: cint): cint {.importc: "winnstr".}
proc winnwstr*(a2: ptr WINDOW; a3: cstring; a4: cint): cint {.importc: "winnwstr".}
proc wins_nwstr*(a2: ptr WINDOW; a3: cstring; a4: cint): cint {.importc: "wins_nwstr".}
proc wins_wch*(a2: ptr WINDOW; a3: ptr cunsignedlong): cint {.importc: "wins_wch".}
proc wins_wstr*(a2: ptr WINDOW; a3: cstring): cint {.importc: "wins_wstr".}
proc winsch*(a2: ptr WINDOW; a3: cunsignedlong): cint {.importc: "winsch".}
proc winsdelln*(a2: ptr WINDOW; a3: cint): cint {.importc: "winsdelln".}
proc winsertln*(a2: ptr WINDOW): cint {.importc: "winsertln".}
proc winsnstr*(a2: ptr WINDOW; a3: cstring; a4: cint): cint {.importc: "winsnstr".}
proc winsrawch*(a2: ptr WINDOW; a3: cunsignedlong): cint {.importc: "winsrawch".}
proc winsstr*(a2: ptr WINDOW; a3: cstring): cint {.importc: "winsstr".}
proc winstr*(a2: ptr WINDOW; a3: cstring): cint {.importc: "winstr".}
proc winwstr*(a2: ptr WINDOW; a3: cstring): cint {.importc: "winwstr".}
proc wmouse_position*(a2: ptr WINDOW; a3: ptr cint; a4: ptr cint) {.importc: "wmouse_position".}
proc wmouse_trafo*(a2: ptr WINDOW; a3: ptr cint; a4: ptr cint; a5: cunsignedchar): cunsignedchar {.importc: "wmouse_trafo".}
proc wmove*(a2: ptr WINDOW; a3, a4: cint): cint {.importc: "wmove".}
proc wnoutrefresh*(a2: ptr WINDOW): cint {.importc: "wnoutrefresh".}
proc wordchar*(): char {.importc: "wordchar".}
proc wprintw*(a2: ptr WINDOW; a3: cstring): cint {.varargs, importc: "wprintw".}
proc wredrawln*(a2: ptr WINDOW; a3, a4: cint): cint {.importc: "wredrawln".}
proc wrefresh*(a2: ptr WINDOW): cint {.importc: "wrefresh".}
proc wresize*(a2: ptr WINDOW; a3, a4: cint): cint {.importc: "wresize".}
proc wscanw*(a2: ptr WINDOW; a3: cstring): cint {.varargs, importc: "wscanw".}
proc wscrl*(a2: ptr WINDOW; a3: cint): cint {.importc: "wscrl".}
proc wsetscrreg*(a2: ptr WINDOW; a3, a4: cint): cint {.importc: "wsetscrreg".}
proc wstandend*(a2: ptr WINDOW): cint {.importc: "wstandend".}
proc wstandout*(a2: ptr WINDOW): cint {.importc: "wstandout".}
proc wsyncdown*(a2: ptr WINDOW) {.importc: "wsyncdown".}
proc wsyncup*(a2: ptr WINDOW) {.importc: "wsyncup".}
proc wtimeout*(a2: ptr WINDOW; a3: cint) {.importc: "wtimeout".}
proc wtouchln*(a2: ptr WINDOW; a3, a4: cint; a5: cint): cint {.importc: "wtouchln".}
proc wunctrl*(a2: ptr cunsignedlong): cstring{.importc: "wunctrl".}
proc wvline_set*(a2: ptr WINDOW; a3: ptr cunsignedlong; a4: cint): cint {.importc: "wvline_set".}
proc wvline*(a2: ptr WINDOW; a3: cunsignedlong; a4: cint): cint {.importc: "wvline".}

when unixOS:
  proc sb_get_horz*(a2, a3, a4: ptr cint): cint {.importc: "sb_get_horz".}
  proc sb_get_vert*(a2, a3, a4: ptr cint): cint {.importc: "sb_get_vert".}
  proc sb_init*(): cint {.importc: "sb_init".}
  proc sb_refresh*(): cint {.importc: "sb_refresh".}
  proc sb_set_horz*(a2, a3, a4: cint): cint {.importc: "sb_set_horz".}
  proc sb_set_vert*(a2, a3, a4: cint): cint {.importc: "sb_set_vert".}
  proc XCursesExit*() {.importc: "XCursesExit".}
  proc Xinitscr*(a2: cint; a3: cstringArray): ptr WINDOW {.importc: "Xinitscr".}

template getch*(): untyped =
  wgetch(stdscr)

template ungetch*(ch: untyped): untyped =
  ungetch(ch)

template getbegyx*(w, y, x: untyped): untyped =
  y = getbegy(w)
  x = getbegx(w)

template getmaxyx*(w, y, x: untyped): untyped =
  y = getmaxy(w)
  x = getmaxx(w)

template getparyx*(w, y, x: untyped): untyped =
  y = getpary(w)
  x = getparx(w)

template getyx*(w, y, x: untyped): untyped =
  y = getcury(w)
  x = getcurx(w)

template getsyx*(y, x: untyped): typed =
  if curscr.leaveit:
    (x) = - 1
    (y) = (x)
  else: getyx(curscr, (y), (x))

template getmouse*(x: untyped): untyped =
  nc_getmouse(x)

{.pop.}
