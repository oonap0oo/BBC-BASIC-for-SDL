      REM Café Wall Illusion            K Moerman 2026
      REM see https://en.wikipedia.org/wiki/Caf%C3%A9_wall_illusion
      REM BBC BASIC for SDL using gfxlib library

      INSTALL @lib$ + "gfxlib" : PROC_gfxInit: REM install and initialise gfxlib
      H% = 450: REM height image in pixels
      Nrows% = 9: Nrect%=13: REM number of rows of rectangles and number of rectangles in one row
      Dt = 5: REM wait time between frames in 1/100 seconds
      Srect% = H% / Nrows%: REM calculated size of rectangle
      Wrows% = Nrect% * Srect%: REM calculated width of one row
      Maxxoffset% = Srect% / 2: REM calculated maximum horizontal offset of rows
      W% = Wrows% + Maxxoffset%*2: REM calculated width of image

      VDU 23,22,W%;H%;16,16,16,0: REM set graphical mode W% by H% pixels; 16 logical colors
      GCOL 0: OFF: REM use logical color 0 or black for drawing, text cursor off

      REM draw content on display once and store in texture
      PROC_DrawVertBarOfRect: REM draw one bar of rectangles
      t%% = FN_gfxCreateTexture(Wrows%,Srect%): REM create empty texture of given size, return handle t%%
      PROC_gfxCopy(t%%,Wrows%,Srect%,0,0): REM copy bar of rectangles on display to texture

      REM animation loop, turn automatic image refresh off, display will only update at *REFRESH
      *REFRESH OFF
      WHILE TRUE
        FOR xoffset%=-Maxxoffset% TO Maxxoffset%
          PROC_DisplayBars(xoffset%): REM display one frame with given horizontal offset between rows
          *REFRESH
          IF INKEY(0) <> -1 THEN EXIT WHILE
          IF xoffset%=0 THEN WAIT 100 ELSE WAIT Dt
        NEXT
        WAIT 150
        FOR xoffset%=Maxxoffset% TO -Maxxoffset% STEP -1
          PROC_DisplayBars(xoffset%): REM display one frame with given horizontal offset between rows
          *REFRESH
          IF INKEY(0) <> -1 THEN EXIT WHILE
          IF xoffset%=0 THEN WAIT 100 ELSE WAIT Dt
        NEXT
        WAIT 150
      ENDWHILE
      PROC_gfxDestroyTexture(t%%); REM release memory space of texture before ending program
      END

      REM draw unfilled rectangle
      DEF PROC_Rectangle(x%,y%,w%,h%,r%,g%,b%)
      PROC_gfxLine(x%,y%,x%+w%,y%,r%,g%,b%)
      PROC_gfxLine(x%+w%,y%,x%+w%,y%+h%,r%,g%,b%)
      PROC_gfxLine(x%+w%,y%+h%,x%,y%+h%,r%,g%,b%)
      PROC_gfxLine(x%,y%+h%,x%,y%,r%,g%,b%)
      ENDPROC

      REM called only once to draw one row of rectangles before copying to texture
      DEF PROC_DrawVertBarOfRect
      LOCAL x%
      PROC_gfxClr(255,255,255): REM clear image and set background color
      FOR x%=0 TO Wrows%-Srect% STEP 2*Srect%: REM draw filled rectangles leaving equal space in between
        PROC_gfxRectangleSolid(x%,0,Srect%,Srect%,0,0,0)
      NEXT
      PROC_Rectangle(0,0,Wrows%,Srect%,127,127,127): REM add grey border around rows, 2px thick
      PROC_Rectangle(1,1,Wrows%-2,Srect%-2,127,127,127)
      ENDPROC

      REM copy texture mutiple times to display in order to show all bars with horizontal offsets
      REM this procedure is called for every frame of animation
      DEF PROC_DisplayBars(xoffset%)
      LOCAL x%,y%,dx%,xl%,xu%
      PROC_gfxClr(200,200,200): REM clear image and set background color
      x% = Maxxoffset% - xoffset%: dx% = xoffset%: REM start value of coord. x and delta to add or subtract
      xl% = x%: xu% = x%+2*dx%:REM lower and upper limts of x
      FOR y%=0 TO H%-Srect% STEP Srect%
        PROC_gfxPlotScale(t%%,Wrows%,Srect%,x%,y%): REM copy texture containing row of rectangles to image
        x% = x% + dx%: REM update coord x
        IF x% = xu% THEN dx% = -xoffset%: REM change btween increasing and decreasing x when reaching limits
        IF x% = xl% THEN dx% = xoffset%
      NEXT
      ENDPROC
