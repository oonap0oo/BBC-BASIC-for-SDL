      REM Spiral illusion                     K Moerman 2026
      REM Based on an image posted by Akiyoshi Kitaoka on Facebook
      REM https://www.facebook.com/share/p/1QEpNj9kjW/

      W% = 600 REM size image in pixels
      VDU 23, 22, W%; W%; 8, 16, 16, 0: REM define an user-defined display mode
      ORIGIN W%, W%: REM move coord 0,0 to center, uses graphical units =2*pixels
      COLOUR 129,153,153,153: REM modify logical background color 129 with new rgb
      GCOL 129: CLG: OFF REM set background color, text cursor invisible
      c1%=0: c2%=15 REM two logical colors used
      modfactor# = 0.012: freq# = 32 REM modulation and freq. of sine wave along circles
      radiusavg# = 7.6E-3 * W%: radiusgrowth# = 1.218 REM start and mult. factor of radius
      WHILE radiusavg# < W% / SQR(2)
        stepsize# = 4E-2 / radiusavg# REM angle needs more steps if radius gets bigger
        FOR angle# = 0 TO 2 * PI STEP stepsize#
          Cangle# = COS(angle#): Sangle# = SIN(angle#) REM pre calc values
          anglemult# = freq# * angle# REM angle for sine wave component of radius
          radius# = radiusavg# * (1 + modfactor# * SIN(anglemult#)) REM momentary radius
          x1% = radius# * Cangle#: y1% = radius# * Sangle#
          radius# = radius# * radiusgrowth# REM radius of outer edge of striped circles
          x2% = radius# * Cangle#: y2% = radius# * Sangle#
          bwangle% = INT(DEG(anglemult#) + 30) REM used to determine black or white
          IF (bwangle% MOD 720) > 360 THEN GCOL c1% ELSE GCOL c2% REM set black or white
          IF angle# > 0 THEN
            MOVE 2*x1%, 2*y1%: MOVE 2*x2%, 2*y2%: PLOT 85, 2*x3%, 2*y3% REM filled Trapezium
            MOVE 2*x4%, 2*y4%: PLOT 85, 2*x1%, 2*y1% REM using 2 filled triangles
          ENDIF
          x3% = x2%: y3% = y2%: x4% = x1%: y4% = y1%
        NEXT
        SWAP c1%, c2% REM black and white parts swap each circle
        radiusavg# = radiusavg# * radiusgrowth#^2 REM avg radius for next circle
      ENDWHILE
      WHILE INKEY$(2) = "": ENDWHILE REM wait for key press to show cursor
      END
