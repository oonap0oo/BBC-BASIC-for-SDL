      REM Golden Dragon            K Moerman 2026
      REM Summoning the Golden Dragon using chaos game and array operations
      REM using info from https://larryriddle.agnesscott.org/ifs/heighway/goldenDragon.htm

      DIM XY(1,0), A1(1,1), A2(1,1), C2(1,0), SCR(1,0), WH(1,0), SCL(1,0), TRNSL(1,0)
      A1() = 0.62367, -0.40337, 0.40337, 0.62367: REM affine transformation array for function 1
      A2() = -0.37633, -0.40337, 0.40337, -0.37633: REM affine transformation array for function 2
      C2() = 1, 0: REM affine transformation vector for function 2
      XY() = 0, 0: REM arrray holding x and y coord.
      WH() = 1200, 650: REM width and height of screen
      SCL() = 1.4, 2.3: REM scaling for plotting in x and y dir. as fraction of width, height
      SCL() *= WH(): REM scale values in array are now absolute values
      TRNSL() = -0.58, -0.43: REM shifting for plotting in x and y dir. as fraction of width, height
      TRNSL() *= WH(): REM shift values in array are now absolute values in pixels
      Npoints = 200000: REM total number of points plotted
      VDU 23,22,WH(0,0);WH(1,0);8,8,16,0: REM custom graph. mode
      OFF: ORIGIN WH(0,0), WH(1,0): REM text cursor off, put point x=0, y=0 in middle of image
      COLOUR 1, 255,215,0: COLOUR 2, 0,255,215: REM redefine two logical colors  using RGB
      FOR  t=0 TO Npoints-1
        IF RND(1) < 0.6445 THEN
          REM function 1, probability 0.6445
          XY() = A1() . XY(): REM affine transformation using array dot product
          GCOL 1: REM set logical color to plot
        ELSE
          REM function 2, probability 0.3555
          XY() = A2() . XY(): REM affine transformation using array dot product
          XY() += C2(): REM and vector addition
          GCOL 2
        ENDIF
        SCR() = XY() * SCL() + TRNSL(): REM scaling and shifting using element wise array ops
        PLOT SCR(0,0),SCR(1,0): REM plot point
      NEXT
      END
