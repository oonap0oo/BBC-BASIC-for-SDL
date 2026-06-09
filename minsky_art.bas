      REM Minsky Art using BBC BASIC for SDL             K MOERMAN 2026
      REM Based on an earlier version using QB64 Phoenix Edition:
      REM https://github.com/oonap0oo/QB64-projects/blob/main/minskyart5.bas
      REM Using information from article 'The Integer Circle Algorithm'
      REM https://nbickford.wordpress.com/2011/04/03/the-minsky-circle-algorithm/

      MODE 8:REM built in mode 640x512 pixels; 16 logical colors
      W% = 640: H% = 512: HW%=W%/2: HH%=H%/2
      GCOL 128: GCOL 15: CLG: OFF: REM logical color 0 for background, logical color 15 for plotting
      ORIGIN W%,H%: REM put coord. 0,0 in the middle of image
      Nmax%=20000: REM max number of iterations before loop is terminated
      FOR d=1 TO 0.8 STEP -.2: REM stepping through parameter d values
        FOR p=6.5 TO 12 STEP .5: REM stepping through parameter p values
          CLG
          PROC_CalcAndPlotframe(d,p): REM generate image using current d and p values
          PRINT TAB(0,1);" Minsky algorithm  d= ";d;"  p= ";p
          IF INKEY(150)<>-1 THEN END: REM wait given time in 1/100 seconds and stop if key pressed
        NEXT
      NEXT
      PRINT " Done"
      END

      REM calculate and plot 1 frame using combination of d and b parameters
      DEF PROC_CalcAndPlotframe(d,b)
      LOCAL x0,y0,visited&(),x(),y(),hd,e
      DIM x(Nmax%),y(Nmax%): REM x and y coordinates of one cycle are stored here
      DIM visited&(W%,H%): REM keeps track which points have been plotted already, avoids using slow TINT()
      hd=d/2: REM use d/2 because of 3 step Minsky algorithm
      e=4/d*SIN(PI/p)^2: REM value e calculated from d and p to use in algorithm
      FOR y0%=-HH% TO HH% : REM iterate through pixels of image, coordinates serve as initial values
        FOR x0%=-HW% TO HW%: REM for the Minsky algorithm
          REM if the pixel corresponding to init values x0 and y0 has not been plotted already, start loop
          IF visited&(x0%+HW%,y0%+HH%)=0 THEN
            PROC_IterateMinsky(x0%,y0%): REM uses x0% and y0% as init. values
            PROC_SetColor(n%): REM sets RGB color to be used determined by loop counter n%
            PROC_PlotPoints(x(),y(),n%): REM plot points stored in x() and y()
          ENDIF
        NEXT
      NEXT
      ENDPROC

      REM iterate the Minsky algorithm with initial values x0% and y0%
      DEF PROC_IterateMinsky(x0%,y0%)
      x(0)=x0%: y(0)=y0%: REM coord. of point used as inital values for x and y
      FOR n%=1 TO Nmax%-1
        x(n%)=x(n%-1)-INT(y(n%-1)*hd): REM 3 step variant of Minsky algorithm to avoid skewing of image
        y(n%)=y(n%-1)+INT(x(n%)*e):REM note: use newest values x(n%) and y(n%) as soon as available
        x(n%)=x(n%)-INT(y(n%)*hd)
        REM if x and y values have cycled back to initial values ...
        IF x(n%)=x0% AND y(n%)=y0% THEN EXIT FOR: REM exit from FOR loop and thus PROC
      NEXT
      ENDPROC

      REM set color depending on number of iterations stored in n%
      DEF PROC_SetColor(n%)
      g%=n% MOD 256: b%=(n% MOD 128)*2: r%=(n% MOD 65)*4
      COLOUR 15,r%,g%,b%: REM set logical color 15, used for plotting, to new RGB
      ENDPROC

      REM iterate through stored x,y coord of last loop. If x,y lays within image and has not
      REM yet been plotted, plot the point x,y
      DEF PROC_PlotPoints(x(),y(),n%)
      LOCAL k%,xindex%,yindex%,xscr%,yscr%
      FOR k%=0 TO n%
        xindex%=x(k%)+HW%: yindex%=y(k%)+HH%: REM coord. system is set with 0,0 in middle of image
        REM check if coord. are inside image so xindex and yindex are within array visited&()
        IF xindex%>=0 AND xindex%<=W% AND yindex%>=0 AND yindex%<=H% THEN
          REM if point has already been plotted from a previous cycle, don't waste time
          IF visited&(xindex%,yindex%)=0 THEN
            visited&(xindex%,yindex%)=1: REM record point as plotted
            xscr%=2*x(k%): yscr%=2*y(k%): REM graphic commands use graphical units, 2*pixel coord
            PLOT xscr%,yscr%
          ENDIF
        ENDIF
      NEXT
      ENDPROC
