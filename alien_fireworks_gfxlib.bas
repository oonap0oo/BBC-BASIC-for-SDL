      REM Alien Fireworks..                       K Moerman  2026
      REM loosely inspired by work of Simone Conradi https://fb.watch/Hqr6gkxun5/
      REM version using library "gfxlib - A 2D Game Graphics Library for BBCSDL"

      INSTALL @lib$ + "gfxlib" : PROC_gfxInit: REM install and initialise gfxlib
      Niter%=1500: Nparam%=1600 REM Niter iterations with same parameters, Nparam values parameters 0..2*PI
      FADE%=252 REM factor to fade the existing content to black
      DIM xy%(Niter%-1,1): REM this array will contain xy coord. of series of points to be plotted with same color
      MODE 21: OFF: W%=800: H%=600: WH%=W%/2: HH%=H%/2: REM built-in mode 800x600 pixels, text cursor off
      SYS "SDL_SetWindowPosition", @hwnd%, &2FFF0000, &2FFF0000, @memhdc%: REM move window to center
      *REFRESH OFF
      PI2=2*PI: stepab=PI2 / Nparam%
      x=0.0: y=0.0: r%=0: g%=0: b%=0
      zone%% = FN_gfxCreateTexture(W%, H%): REM create bitmap in memory and return handle
      FOR a=PI2 TO 0 STEP -stepab
        FOR b=0 TO PI2 STEP stepab
          PROC_gfxCopy(zone%%, W%, H%, 0, 0): REM copy excisting image content to bitmap in memory
          PROC_gfxPlotScaleFade(zone%%, W%, H%, 0, 0, FADE%): REM copy bitmap back to display and mult. RGBs by FADE%
          r%=(r% + 87) AND 255: g%=(g% + 51) AND 255: b%=(b% + 13) AND 255: REM update plot color defined by rgb
          FOR t%=0 TO Niter%-1
            xnew = SIN(x*x - y*y + a) REM iterate x and y through map formulas
            y = SIN(2*x*y + b) REM x and y are within -1 to +1
            x = xnew
            xy%(t%,0)= WH%*x: xy%(t%,1)=-HH%*y: REM store scaled coord. in array for use by PROC_gfxPlotPixelList()
          NEXT
          REM plot Niter% points at coord. in xy(), starting at 0, with color r%g%b% and offset WH%, HH%
          PROC_gfxPlotPixelList(xy%(),Niter%,0,r%,g%,b%,WH%,HH%)
          SWAP x,y: REM next initial values are swapped end values of x,y
          *REFRESH
        NEXT
      NEXT
      END

