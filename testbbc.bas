      REM First test of BBC BASIC for SDL  K Moerman 2026
      REM set parameters, % for integer vars, # for floating point vars
      W% = 800 : HW% = W% DIV 2
      H% = 600 : HH% = H% DIV 2
      REM define an user-defined display mode
      VDU 23, 22, W%; H%; 8, 16, 16, 0
      REM move coord 0,0 to center, uses graphical units not pixels
      ORIGIN W%, H%
      REM set foreground logical colour
      GCOL 1
      REM loop through pixels
      FOR X% = -HW% TO HW%
        XX# = 0.85 * X%
        FXX# = 2.5E-5 * XX#^3 - XX# REM pre-calc this, only depends on X
        FOR Y% = -HH% TO HH%
          YY# = 0.85 * Y% + 150
          D% = INT(ABS(FXX#  + 3 * YY# - 1E-2 * YY# * YY#))
          R% = D% MOD 256 REM derive rgb values from D%
          G% = (D% MOD 128) * 2
          B% = (D% MOD 32) * 8
          REM change logical colour 1 to new physical colour using r,g,b components
          COLOUR 1, R%, G%, B%
          REM DRAW the pixel, commands use Graphics units not pixel coordinates
          MOVE 2*X%, 2*Y%  : DRAW 2*X%, 2*Y%
        NEXT
      NEXT
      OFF: WHILE INKEY$(2) = "": ENDWHILE REM wait for key press to show cursor
      END
