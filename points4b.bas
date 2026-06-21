      REM Dancing points      KMoerman 2026
      REM Made only to generate a visual effect, not a accurate simulation of a physics phenomenon
      REM for example a lot of constants in real physics are assumed equal to 1 here, also this is 2D only
      REM Based on the general idea of charged particles being attracted to a number of 'attractors'
      REM while also being influenced by a magnetic field perpendicular to the image which generates a
      REM force 90 degrees to the direction of travel and proportional to the velocity

      REM define a graphics window
      W%=900: H%=650: H2%=H%*2: W2%=W%*2: REM size of image
      CHSIZE%=16: REM defines txt size AND size of points using PLOT() statement
      VDU 23,22,W%;H%;CHSIZE%,CHSIZE%,128,0: REM custom graphics mode
      ORIGIN W%,H%: OFF: REM put coord. x:0, y:0 in the middle of image
      alpha=16: REM transparency for black overlay drawn between each frame to fade old content to back
      REM parameters of system
      R=350: REM maximum distance from center for start position of points
      B=0.01: REM similar to magnetic field perpendicular to screen, points start to turn as soon as v>0
      G=70: REM strength of attractors, points are pulled towards attractors
      RP=10: REM strength of repulsors, points are pushed away from repulsors
      DRAG=1.3E-3: REM drag proportional to velocity
      ATTRACTRAD=12: ATTRACTRADSQ=ATTRACTRAD^2
      Npoints%=375: REM total number of points in system
      Nattract=2: REM total number of attractors in system
      Nrepulse=1: REM total number of repulsors in system
      DIM x(Npoints%-1),y(Npoints%-1),vx(Npoints%-1),vy(Npoints%-1),col%(Npoints%-1)
      DIM xattract(Nattract-1),yattract(Nattract-1),xrepulse(Nrepulse-1),yrepulse(Nrepulse-1)
      xattract()=-2*R/3, 2*R/3: REM define position of attractors
      yattract()=-R/4, R/4
      xrepulse()=0: REM define position of repulsors
      yrepulse()=0
      PROC_Init_Points: REM all points get start position, velocity and color
      PROC_ModifyLogical_colors
      REM main loop
      t%=0: velfactor=1-DRAG
      WHILE TRUE
        REM update x() and y() of all points in every iteration of the main loop
        PROC_UpdatePos
        REM at intervals put an almost transparent black filled rectangle  over image
        REM and redraw the attractors
        IF t% MOD 12=0 THEN
          PROC_ApplySemiTranspOverlay
          PROC_DrawAttractorsRepulsors
        ENDIF
        REM at intervals draw the points at their new positions and wait some time
        IF t% MOD 5=0 THEN
          PROC_DrawPoints
          WAIT 1: REM wait and release CPU, specified in 1/100 seconds
          IF INKEY(0)<>-1 THEN EXIT WHILE
        ENDIF
        t%+=1: IF t%>1200 THEN t%=0
      ENDWHILE
      END

      REM give 1 point starting position, velocity and color
      REM called by PROC_Init_Points at start of program and by
      REM PROC_UpdateVelAttract when a point reaches an attractor
      DEF PROC_InitPoint(k%)
      rad=0.06*R
      angle=2*PI*k%/Npoints%
      x(k%)=rad*COS(angle)
      y(k%)=rad*SIN(angle)
      vx(k%)=0
      vy(k%)=0
      col%(k%)=3+(k% MOD 125)
      ENDPROC

      REM give all points starting position, velocity and color
      REM only called once at start of program
      DEF PROC_Init_Points
      FOR k%=0 TO  Npoints%-1
        PROC_InitPoint(k%)
      NEXT
      ENDPROC

      REM Update velocity of a point k% due to attraction, based on Dx, Dy and constant G
      REM Dx, Dy is distance between the point and an attractor in x and y direction
      REM called by PROC_UpdatePos for each point and for each attractor
      DEF PROC_UpdateVelAttract(Dx,Dy,k%)
      rsq=Dx*Dx+Dy*Dy
      IF rsq>ATTRACTRADSQ THEN
        f=G/(SQR(rsq)*rsq)
        vx(k%)-=f*Dx
        vy(k%)-=f*Dy
      ELSE
        PROC_InitPoint(k%): REM if point k% has reached edge of attractor
      ENDIF
      ENDPROC

      REM Update velocity of a point k% due to repulsion, based on Dx, Dy and constant RP
      DEF PROC_UpdateVelRepulse(Dx,Dy,k%)
      rsq=Dx*Dx+Dy*Dy
      IF rsq>0 THEN
        f=RP/(SQR(rsq)*rsq)
        vx(k%)+=f*Dx
        vy(k%)+=f*Dy
      ENDIF
      ENDPROC

      REM Update position of all points
      DEF PROC_UpdatePos
      FOR k%=0 TO  Npoints%-1: REM update velocities vx and vy of all points first
        FOR n%=0 TO Nattract-1: REM take influence of each attractor into account
          PROC_UpdateVelAttract(x(k%)-xattract(n%),y(k%)-yattract(n%),k%)
        NEXT
        FOR n%=0 TO Nrepulse-1: REM take influence of each repulsor into account
          PROC_UpdateVelRepulse(x(k%)-xrepulse(n%),y(k%)-yrepulse(n%),k%)
        NEXT
      NEXT
      REM Update velocity of a point due to B field, based on current vx, vy and constant B
      REM This simulates (kind of) a force applied to the point at 90deg from its direction of travel
      vx()+=-vy()*B: REM is equivalent to vx(k%)+=-vy(k%)*B inside the FOR loop
      vy()+=vx()*B: REM is equivalent to vy(k%)+=vx(k%)*B inside the FOR loop
      REM Update velocity with some drag, velfactor=1-DRAG
      vx()*=velfactor:  REM is equivalent to vx(k%)*=velfactor inside the FOR loop
      vy()*=velfactor:  REM is equivalent to vy(k%)*=velfactor inside the FOR loop
      REM finally update the positions
      x()+=vx(): REM is equivalent to x(k%)+=vx(k%) inside the FOR loop
      y()+=vy(): REM is equivalent to y(k%)+=vy(k%) inside the FOR loop
      ENDPROC

      REM put a filled rectangle over screen
      REM logical color 0 has been changed to black with high transparency or low aplha
      DEF PROC_ApplySemiTranspOverlay
      GCOL 0:RECTANGLE FILL -W%,-H%,W2%,H2%
      ENDPROC

      REM draw a disk at position of all attractors and repulsors
      DEF PROC_DrawAttractorsRepulsors
      GCOL 1
      FOR n%=0 TO Nattract-1
        CIRCLE FILL 2*xattract(n%),2*yattract(n%),2*ATTRACTRAD
      NEXT
      GCOL 2
      FOR n%=0 TO Nrepulse-1
        CIRCLE FILL 2*xrepulse(n%),2*yrepulse(n%),2*ATTRACTRAD: REM just use same radius as attractors
      NEXT
      ENDPROC

      REM draw all the points using their stored logical color defined at start in array col%()
      DEF PROC_DrawPoints
      FOR k%=0 TO  Npoints%-1
        GCOL col%(k%): PLOT 2*x(k%),2*y(k%)
      NEXT
      ENDPROC

      REM modify logical colors using RGB, called once at start of program
      DEF PROC_ModifyLogical_colors
      FOR k%=3 TO 127: REM logical colors 3 to 127 used for points
        angle=k%/127*4*PI
        r%=127+127*SIN(angle)
        g%=127+127*SIN(angle+2*PI/3)
        b%=127+127*SIN(angle+4*PI/4)
        COLOUR k%,r%,g%,b%
      NEXT
      VDU 19,0+128,alpha,0,0,0: REM logical color 0 as semi transparent black for overlay
      COLOUR 1,0,255,0: REM logical color 1 for attractors
      COLOUR 2,255,0,0: REM logical color 2 for repulsors
      ENDPROC




