      REM Vogel's formula from Phyllotaxis using BBC BASIC for SDL  K Moerman 2026
      REM --------------------------------------------------------
      REM angle = n * 137,5°
      REM r = c * √n
      REM set parameters, % for integer vars, # for floating point vars
      W% = 800 : REM dimensions image in pixels
      H% = 600
      GA# = RAD(137.5) REM "Golden Angle" related to vogel's formula
      C# = 15: REM constant from Phyllotaxis formula
      NMAX% = 340: REM Number of shapes
      SIDESMALL% = 44: SIDEINCR% = 7: REM side of shape in graphical units
      CPI_6 = COS(PI/6): SPI_6 = SIN(PI/6): REM used to calc vertices of triangle
      CPI_4 = COS(PI/4): SPI_4 = SIN(PI/4): REM used to calc vertices of diamond
      REM define an user-defined display mode, note ; and , usage
      VDU 23, 22, W%; H%; 8, 16, 16, 0 : CLG
      GCOL 1: REM set foreground logical colour
      REM move graphics origin to center, in graphical units
      ORIGIN W%, H%
      REM no automatic image updates for faster output
      *REFRESH OFF
      REM loop draws triangles
      SHAPE% = 0
      REPEAT
        FOR OFFS%=0 TO 512
          CLG
          FOR N% = 0 TO NMAX%
            NRAT# = N% / NMAX%: REM ramps from 0 to 1
            REM Phyllotaxis formula
            ANGLE# = N% * GA#
            R# = C# * SQR(N%)
            REM polar to cartesian coord.
            CANGLE# = COS(ANGLE#): SANGLE# = SIN(ANGLE#)
            X% = R# * CANGLE#
            Y% = R# * SANGLE#
            REM calc. color comp. out of N% and OFFS%
            R% = NRAT# * 255: R% = (R% + OFFS%) MOD 255
            G% = ABS(R% - 127) * 2
            B% = 255 - R%
            SIDE% = SIDESMALL% + SIDEINCR% * NRAT#
            REM change logical colour 1 to new physical colour using r,g,b components
            COLOUR 1, R%, G%, B%
            REM draw one of the shapes
            CASE SHAPE% OF
              WHEN 0: PROC_TRIANGLE(X%,Y%,SIDE%,CANGLE#,SANGLE#)
              WHEN 1: PROC_DIAMOND(X%,Y%,SIDE%,CANGLE#,SANGLE#)
              WHEN 2: PROC_DISK(X%,Y%,SIDE%)
            ENDCASE
          NEXT
          REM update image here
          *REFRESH
          REM WAIT specified in 1/100th of a second
          WAIT 1
        NEXT
        REM update figure counter, cycling through triangle, disk, diamond
        SHAPE% = (SHAPE% + 1) MOD 3
      UNTIL FALSE
      END

      REM draw commands use Graphics units not pixel coordinates
      REM "BBC BASIC for Windows and BBC BASIC for SDL 2.0 use 'graphics units'
      REM such that one pixel (picture element) corresponds to two graphics units."

      REM draw a filled triangle, rotated using angle through the sine and cosine
      DEF PROC_TRIANGLE(X%,Y%,SIDE%,CANGLE#,SANGLE#)
      REM draw commands use Graphics units not pixel coordinates
      XP% = 2 * X% - 0.5 * SIDE% * CANGLE#: YP% = 2 * Y% - 0.5 * SIDE% * SANGLE#
      REM Calculate other 2 vertices of triangle
      REM COS(ANGLE# + PI_6 = COS(ANGLE#) * COS(PI_6) - SIN(ANGLE#) * SIN(PI_6)
      REM SIN(ANGLE# + PI_6 = SIN(ANGLE#) * COS(PI_6) + COS(ANGLE#) * SIN(PI_6)
      XP2% = XP% + SIDE% * CANGLE# * CPI_6 - SIDE% * SANGLE# * SPI_6
      YP2% = YP% + SIDE% * SANGLE# * CPI_6 + SIDE% * CANGLE# * SPI_6
      XP3% = XP% + SIDE% * CANGLE# * CPI_6 + SIDE% * SANGLE# * SPI_6
      YP3% = YP% + SIDE% * SANGLE# * CPI_6 - SIDE% * CANGLE# * SPI_6
      REM draw a filled triangle using 2 MOVE statements and PLOT 85
      MOVE XP%, YP%: MOVE XP2%,YP2%: PLOT 85, XP3%, YP3%
      ENDPROC

      REM draw a filled circle
      DEF PROC_DISK(X%,Y%,DIAM%)
      XP% = 2 * X%: YP% = 2 * Y%: R% = DIAM% / 2
      CIRCLE FILL XP%, YP%, R%
      ENDPROC

      REM draw a filled diamond, rotated using angle through the sine and cosine
      DEF PROC_DIAMOND(X%,Y%,SIDE%,CANGLE#,SANGLE#)
      SIDE% = SIDE% * 0.8
      REM draw commands use Graphics units not pixel coordinates
      XP% = 2 * X% - 0.66* SIDE% * CANGLE#: YP% = 2 * Y% - 0.66 * SIDE% * SANGLE#
      REM Calculate other 2 vertices of triangle
      REM COS(ANGLE# + PI_4 = COS(ANGLE#) * COS(PI_4) - SIN(ANGLE#) * SIN(PI_4)
      REM SIN(ANGLE# + PI_4 = SIN(ANGLE#) * COS(PI_4) + COS(ANGLE#) * SIN(PI_4)
      XP2% = XP% + SIDE% * CANGLE# * CPI_4 - SIDE% * SANGLE# * SPI_4
      YP2% = YP% + SIDE% * SANGLE# * CPI_4 + SIDE% * CANGLE# * SPI_4
      XP3% = XP% + SIDE% * CANGLE# * CPI_4 + SIDE% * SANGLE# * SPI_4
      YP3% = YP% + SIDE% * SANGLE# * CPI_4 - SIDE% * CANGLE# * SPI_4
      REM draw a filled diamond using 2 MOVE statements and PLOT 117
      REM the 4th point is calc. automat.
      MOVE XP2%, YP2%: MOVE XP%,YP%: PLOT 117, XP3%, YP3%
      ENDPROC
