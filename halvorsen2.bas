      REM Halvorsen-attractor              K Moerman 2026
      REM BBC BASIC for SDL

      Nstore%=6000:REM number of xyz values stored in array and plotted
      Nextra%=130: REM extra loops done to be able to make time step smaller for accuracy Euler method
      Nframe%=280: REM number of frames in one 360 degrees rotation of figure around z axis
      DIM XYZ(2,Nstore%), XYZr(2,Nstore%): REM xyz values are stored here for rotation each frame
      DIM cs(Nframe%), sn(Nframe%): REM SIN() and COS() values for rotation are pre-calc. and stored here
      DIM ROTXY(2,2), ROTXZ(2,2), ROT(2,2): REM 3x3 rotation matrixes
      W% = 800: H% = 600: W2%=2*W%: H2%=2*H%: REM dimensions of image
      CHSIZE% = 16: REM height and width of 1 text character, also determines size of PLOT() points
      VDU 23,22,W%;H%;CHSIZE%,CHSIZE%,128,0: REM custom graphics mode
      VDU 24,0;0;W2%;H2%-2*CHSIZE%; : REM redefine graphics viewport, leaving room for 1 row of text
      PRINT TAB(10,0);"Halvorsen-attractor";TAB(10,2);"Calculating values.."
      ORIGIN W%,H%: OFF: REM set point 0,0 in middle
      alpha=127: VDU 19,0+128,alpha,0,0,0: REM redefine logical color 0 as semi transparent black
      dscr=20: dxyz=50: REM 3D to 2D, dscr: distance camera to scr, dxyz: distance camera to origin
      xoffset=3: yoffset=5: zoffset=3: REM added to z values to move figure upwards
      scale=100: REM xyz values multiplied by scale for display
      h=1.5E-4: REM time step for Euler method
      a=1.4: REM parameter of Halvorsen-attractor
      xinit=0.0: yinit=-2.0: zinit=1.0: REM initial values of xyz
      PROC_Calculate_xyz(xinit,yinit,zinit): REM calculate xyz coord. of points and store in array
      CLG
      *REFRESH OFF
      scale_dscr = scale*dscr
      anglexy = 0: danglexy = 2*PI/Nframe%: anglexz = 0: danglexz = 2*PI/Nframe%/12
      WHILE INKEY(0)=-1
        GCOL 0: RECTANGLE FILL -W%,-H%,W2%,H2%:REM put semi transparent rectangle over image
        REM rotation matrixes around Z axis and around X axis
        ROTXY() = COS(anglexy), -SIN(anglexy), 0, SIN(anglexy), COS(anglexy), 0, 0, 0, 1
        ROTXZ() = COS(anglexz), 0, SIN(anglexz),0, 1, 0, -SIN(anglexz), 0, COS(anglexz)
        ROT() = ROTXZ() . ROTXY(): REM total rotation matrix
        XYZr() = ROT() . XYZ(): REM rotate all xyz values and store result in XYZr
        FOR t%=0 TO Nstore%-1: REM iterate over all stored points
          proj = scale_dscr/(dxyz + XYZr(1,t%)): REM 3D to 2D projection factor depending on y coord
          xscr% = XYZr(0,t%)*proj: yscr% = XYZr(2,t%)*proj
          GCOL t% DIV 20 MOD 128: PLOT xscr%,yscr%: REM plot z as function of x, both scaled depending on y
        NEXT
        *REFRESH
        anglexy += danglexy: IF anglexy>2*PI THEN anglexy=0
        anglexz += danglexz: IF anglexz>2*PI THEN anglexz=0
      ENDWHILE
      END

      REM pre-calculate xyz values using coupled ODEs from Halvorsen attractor and Euler method
      DEF PROC_Calculate_xyz(x,y,z)
      LOCAL t%,k%,dx_dt,dy_dt,dz_dt
      FOR t%=0 TO Nstore%-1: REM outer loop, each iteration a set of xyz points will be stored in array
        FOR k%=0 TO Nextra%-1: REM inner loop with extra iterations to be able to reduce time step h
          dx_dt = -a*x-4*y-4*z-y*y: REM Halvorsen attractor diff. equations
          dy_dt = -a*y-4*z-4*x-z*z
          dz_dt = -a*z-4*x-4*y-x*x
          x += dx_dt*h: REM calc new xyr using Euler method
          y += dy_dt*h
          z += dz_dt*h
        NEXT
        XYZ(0,t%)=x+xoffset: XYZ(1,t%)=y+yoffset: XYZ(2,t%)=z+zoffset: REM store values in XYZ array in intervals
      NEXT
      ENDPROC

