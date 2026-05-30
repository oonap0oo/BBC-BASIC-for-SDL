      REM Alien Fireworks..                       K Moerman  2026
      REM loosely inspired by work of Simone Conradi https://fb.watch/Hqr6gkxun5/

      Niter%=1500: Nparam%= 1600 REM N iterations with same parameters, N values parameters 0..2*PI
      ALPHARECT%=3 REM alpha of black rectangle used to gradually delete prev. plots
      MODE 21: W%=800: H%=600: W2%=2*W%: H2%=2*H%: REM built-in mode, use MODE 20 for smaller points
      SYS "SDL_SetWindowPosition", @hwnd%, &2FFF0000, &2FFF0000, @memhdc%: REM move window to center
      ORIGIN W%, H%: REM put coordinates x=0, y=0 to center of image
      GCOL 15: OFF: REM set logical color 15, text cursor off
      VDU 19,1+128,ALPHARECT%,0,0,0: REM redefine logical color 1 as nearly transparent black
      *REFRESH OFF
      PI2 = 2*PI: stepab=PI2 / Nparam%
      x=0.0: y=0.0: r%=0: g%=0: b%=0: ovl%=FALSE
      FOR a=PI2 TO 0 STEP -stepab
        FOR b=0 TO PI2 STEP stepab
          IF ovl% THEN PROC_overlay REM put nearly transparent black rect. over image
          PROC_setnewcolor REM set new color to draw with
          FOR t%=1 TO Niter%
            xnew = SIN(x*x - y*y + a) REM iterate x and y through map formulas
            y = SIN(2*x*y + b) REM x and y are within -1 to +1
            x = xnew
            PROC_plotpoint(x,y) REM plot the point
          NEXT
          SWAP x,y: REM next initial values are swapped end values of x,y
          ovl% = NOT ovl%
          *REFRESH
        NEXT
      NEXT
      END

      REM change plot color, logical color 15 is redefined
      DEF PROC_setnewcolor
      r%=(r% + 87) AND 255: g%=(g% + 51) AND 255: b%=(b% + 13) AND 255: REM update global rgb variables
      COLOUR 15,r%,g%,255 - b%: REM redefine logical color 15 as rgb value
      GCOL 15 REM set log. color 15 to plot with
      ENDPROC

      REM scale to display and convert to graphical units = 2*pixel
      DEF PROC_plotpoint(x,y)
      LOCAL xscr%, yscr%
      xscr% = W%*x: yscr% = H%*y: PLOT xscr%,yscr%: REM point size depends on char size of MODE
      ENDPROC

      REM put nearly transparent black rect. over image, uses logical color 1 which has been prepared
      DEF PROC_overlay
      GCOL 1: RECTANGLE FILL -W%,-H%,W2%,H2%
      ENDPROC
