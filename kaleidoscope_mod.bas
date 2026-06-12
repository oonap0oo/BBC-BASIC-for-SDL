      REM Kaleidoscope Simulator
      REM based on program posted by Steve Furnell on FB
      REM https://www.facebook.com/share/v/18wRGs47oU/
      REM BBC BASIC for SDL
      imsize = 600: REM dimensions square image in pixels
      N = 100: REM total number of circles is 12 x this value
      alpha = 10: REM transparancy of black square used to fade previous drawn image content
      PI_div3 = PI/3: imsize2 = 2*imsize: radius = imsize / SQR(2)
      VDU 23,22,imsize;imsize;8,16,128,0: REM custom graph. mode with square dimensions
      OFF: ORIGIN imsize, imsize: REM text cursor off, put point x=0, y=0 in middle of image
      VDU 19,0+128,alpha,0,0,0: GCOL 128: REM logical color 0 to semi transparent black, set as background
      DIM px(N-1), py(N-1), vx(N-1), vy(N-1), col(N-1)
      FOR i = 0 TO N-1: REM give random start position, velocity and color to N circles
        px(i) = RND(radius) - radius/2
        py(i) = RND(radius) - radius/2
        vx(i) = RND(7)-3.5
        vy(i) = RND(7)-3.5
        col(i) = 1+RND(126): REM don't use logical color 0
      NEXT: REM *REFRESH OFF suspends updating the display untill REFRESH command
      *REFRESH OFF
      REPEAT
        GCOL 0,0: RECTANGLE FILL -imsize,-imsize,imsize2,imsize2: REM fade old content to black
        px() += vx(): py() += vy(): REM opdate all positions using velocities
        FOR i = 0 TO N-1
          GCOL 0,col(i): REM set foreground color to plot
          IF ABS(px(i)) > radius THEN vx(i) = -vx(i)
          IF ABS(py(i)) > radius THEN vy(i) = -vy(i)
          y = py(i)
          FOR s = 0 TO 11
            angle = s * PI_div3: CS = COS(angle): SN = SIN(angle)
            IF s = 6 THEN y = -y
            xr = px(i) * CS -  y * SN: REM place multiple versions of each circle at rotated positions
            yr = px(i) * SN +  y * CS
            CIRCLE FILL xr, yr, 4
          NEXT
        NEXT
        *REFRESH
        WAIT 1: REM wait time specified in 1/100s
      UNTIL INKEY(-99): REM test if spacebar has been pressed
      END
