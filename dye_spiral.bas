      REM Dye Spiral          K Moerman 2026
      REM simulation of physical color effect using dyes, a stick and a turning table
      REM shown in FB video from channel "Dyes by Redd" https://www.facebook.com/share/r/1Ev61TnyEA/

      W% = 712: H% = 576: HW=W%/2: HH=H%/2 REM size image in pixels
      Wcol%=8: Nspiral%=6: Maxdispl = 50: REM width color bands, number of spirals, maximum displacement of dye
      MODE 10 REM built in mode 720x576 pixels; 16 logical colors
      GCOL 128: GCOL 15: CLG: REM logical color 0 for background, logical color 15 for plotting,
      *REFRESH OFF
      omega=Nspiral%*PI/HH: d=10/Maxdispl: PI_2=PI/2 REM pre-calc constants
      FOR x=HW-HH TO W%-HW+HH
        xx=x-HW
        FOR y=0 TO H%
          yy=y-HH
          rad = FN_HYPOT(xx,yy): REM distance pixel to center of image
          REM if pixel is inside disk with radius HH
          IF rad<HH THEN
            angle = FN_ATN2(xx,yy): REM angle of pixel w.r.t. x axis
            radwave = SIN(omega*rad+0.5*angle): REM spiral sinwave pattern emanating from center image
            displ = 10/(ABS(radwave)+d): REM magnitude of displacement of dye, shape =1/(|sin(r)|)
            angledispl = angle+PI_2: REM angle of displacement, 90° relative to line origin to pixel
            dx = displ*COS(angledispl): REM x component of displacement
            col% = ((x+dx) DIV Wcol%) * Wcol%: REM color consists of displaced bands of thickness Wcol%
            r%=2*col% AND 255: g%=11*col% AND 255: b%=5*col% AND 255: REM derive in some way RGB components
            COLOUR 15,r%,g%,b%: REM logical color 15 is redefined with rgb
            PROC_PLOT(x,y): REM plot pixel
          ENDIF
        NEXT
        *REFRESH
      NEXT
      END

      REM calc arc tan of angle between point x,y and x axis
      DEF FN_ATN2(x,y)
      IF x=0 THEN t = PI/2*SGN(y) ELSE t = ATN(y/x)
      IF x<0 THEN t = t+PI
      =t

      REM calc distance from point x,y to origin 0,0
      DEF FN_HYPOT(x,y):
      =SQR(x*x+y*y)

      REM plot pixel at pixel coord. x,y with current color
      DEF PROC_PLOT(x,y)
      xscr%=2*x: yscr%=2*y: REM graphical units are 2 times pixel coordinates
      LINE xscr%,yscr%,xscr%,yscr%: REM plot exactly 1 pixel
      ENDPROC
