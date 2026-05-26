      REM 3D Surface plot with hidden-line removal for BBC BASIC    K Moerman 2026

      W% = 700 : HW% = W% / 2 REM dimensions of image
      H% = 600 : HH% = H% / 2: HHSQ% = HH%^2
      OMEGA# = 2 * PI / HH% * 2.5 REM frequency of plotted 3D function
      TILT# = 0.3 REM parameter for the simple projection used, igger value tilts graph forward, kind of
      SPACINGLINES% = 4.5 REM spacing between horizontal lines following the surface
      REM define an user-defined display mode
      VDU 23, 22, W%; H%; 8, 16, 16, 0
      REM move graphics origin, coord. are in graphical units
      ORIGIN W%, H%
      REM set logical color and clear screen
      GCOL 10: CLG
      FOR X% = -HH% TO HH%: REM iterate through part of image horizontally
        XSQ% = X% * X%
        YP2# = -HH%: YP3# = HH%
        DY% =  SQR(HHSQ% - XSQ%) REM range of Y at the current X value
        FOR Y% = -DY%  TO DY%: REM iterate trough part of image vertically
          R# = SQR(XSQ% + Y% * Y%)
          Z# = FN_ZVALUE(R#): REM calc Z value
          YP# = 0.7 * HH% * Z#  + Y% * TILT#: REM display Y value is combination of Z and Y out of XY plane
          REM plot point if it is higher on the display then previously drawn point
          IF YP# > YP2# THEN
            IF YP2# > -HH% THEN PROC_DRAWINGUP(X%, YP#, YP2#)
            YP2# = YP# REM keep track of last YP value to compare against next one
          ENDIF
          IF YP# < YP3# THEN
            IF YP3# < HH% THEN PROC_DRAWINGDOWN(X%, YP#, YP3#)
            YP3# = YP# REM keep track of last YP value to compare against next one
          ENDIF
        NEXT
      NEXT
      END

      REM function to plot
      DEF FN_ZVALUE(R#):
      = 1.2 * SIN(OMEGA# * R#) * EXP(-7E-3 * R#)
      REM IF R# = 0 THEN = 1.2 ELSE = 1.2 * SIN(OMEGA# * R#) / (OMEGA# * R#)

      REM implementing a hyperbolic tangent function
      DEF FN_TANH(Z#)
      LOCAL E2Z#
      REM avoid very large or small values of EXP(X)
      IF Z# > 100 THEN = 1.0 ELSEIF Z# < -100 THEN = -1.0
      E2Z# = EXP(2 * Z#)
      = (E2Z# - 1) / (E2Z# + 1)

      REM plotting upper side of surface
      DEF PROC_DRAWINGUP(X%, YP#, YP2#)
      LOCAL XG%, YG%, GR%
      XG% = 2 * X%: YG% = 2 * YP#: REM calc graphical units from pixel coord.
      REM define color based on increase in Y (slope in Y direction) with TANH function as limiter
      GR% =  80 + 175 * FN_TANH((YP# - YP2#) * 0.15)
      COLOUR 10, 0, GR%, 0 REM change logical colour to new physical color using R,G,B
      LINE XG%, YG%, XG%, 2*YP2# + 2 REM draw vertical line from prev. Y value to new Y
      REM with spacing draw a extra point to form hor. lines following the surface
      IF (Y% MOD SPACINGLINES%) = 0 THEN
        COLOUR 10, 0,0,0
        LINE XG%, YG%, XG%, YG% REM plot 1 pixel
      ENDIF
      ENDPROC

      REM plotting lower side of surface
      DEF PROC_DRAWINGDOWN(X%, YP#, YP3#)
      LOCAL XG%, YG%, GR%
      XG% = 2 * X%: YG% = 2 * YP#: REM calc graphical units from pixel coord.
      REM define color based on increase in Y (slope in Y direction) with TANH function as limiter
      GR% =  60 + 115 * FN_TANH((YP3# - YP#) * 0.15)
      COLOUR 10, 0, GR%, 0 REM change logical colour to new physical color using R,G,B
      LINE XG%, YG%, XG%, 2*YP3# - 2 REM draw vertical line from prev. Y value to new Y
      REM with spacing draw a extra point to form hor. lines following the surface
      IF (Y% MOD SPACINGLINES%) = 0 THEN
        COLOUR 10, 0,0,0
        LINE XG%, YG%, XG%, YG% REM plot 1 pixel
      ENDIF
      ENDPROC

