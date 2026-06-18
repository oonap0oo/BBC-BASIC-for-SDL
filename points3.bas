      REM Dancing points      KMoerman 2026
      REM Made only to generate a visual effect, not a accurate simulation of a physics phenomenon
      REM for example a lot of constants in real physics are assumed equal to 1 here, also this is 2D only
      REM Based on the general idea of charged particles being attracted to a number of 'attractors'
      REM while also being influenced by a magnetic field perpendicular to the image which generates a
      REM force 90 degrees to the direction of travel and proportional to the velocity

      W%=700: H%=650: H2%=H%*2: W2%=W%*2: REM size of image
      CHSIZE%=16: REM defines txt size AND size of points using PLOT() statement
      VDU 23,22,W%;H%;CHSIZE%,CHSIZE%,128,0: REM custom graphics mode
      ORIGIN W%,H%: OFF: REM put coord. x:0, y:0 in the middle of image
      alpha=16: VDU 19,0+128,alpha,0,0,0: REM redefine logical color 0 as semi transparent black
      Npoints%=400: REM total number of points in system
      Nattract=2: REM total number of attractors in system
      R=280: REM maximum distance from center for start position of points
      B=0.01: REM similar to magnetic field perpendicular to screen, points start to turn as soon as v>0
      G=40: REM similar to gravitation, points are pulled towards attractors
      DIM x(Npoints%-1),y(Npoints%-1),vx(Npoints%-1),vy(Npoints%-1),col%(Npoints%-1)
      DIM xattract(Nattract-1),yattract(Nattract-1)
      xattract()=-R/3, R/3: REM define position of attractors
      yattract()=-R/3, R/3
      PROC_Init_Points: REM all points get start position, velocity and color
      t%=0
      WHILE TRUE: REM main loop
        REM update x() and y() of all points in every iteration of the main loop
        PROC_UpdatePos
        REM at intervals put an almost transparent black filled rectangle  over image
        REM and redraw the attractors
        IF t% MOD 15=0 THEN
          PROC_ApplySemiTranspOverlay
          PROC_DrawAttractors
        ENDIF
        REM at intervals draw the points at their new positions and wait some time
        IF t% MOD 5=0 THEN
          PROC_DrawPoints
          WAIT 1
          IF INKEY(0)<>-1 THEN EXIT WHILE
        ENDIF
        t%+=1: IF t%>1200 THEN t%=0
      ENDWHILE
      END

      REM give all points starting position, velocity and color
      REM only called once at start of program
      DEF PROC_Init_Points
      FOR k%=0 TO  Npoints%-1
        rad=0.7*R+0.3*R*RND(1)
        angle=2*PI*RND(1)
        x(k%)=rad*COS(angle)
        y(k%)=rad*SIN(angle)
        vx(k%)=0
        vy(k%)=0
        col%(k%)=1+(k% MOD 127)
      NEXT k%
      ENDPROC

      REM Update velocity of a point due to attraction, based on Dx, Dy and constant G
      REM Dx, Dy is distance between the point and an attractor in x and y direction
      REM called by PROC_UpdatePos for each point and for each attractor
      DEF PROC_UpdateVelAttract(Dx,Dy,k%)
      IF Dx<>0 AND Dy<>0 THEN
        rsq=Dx*Dx+Dy*Dy
        r=SQR(rsq)
        f=G/(r*rsq)
        vx(k%)+=-f*Dx
        vy(k%)+=-f*Dy
      ENDIF
      ENDPROC

      REM Update position of all points
      DEF PROC_UpdatePos
      FOR k%=0 TO  Npoints%-1: REM update velocities vx and vy of all points first
        FOR n%=0 TO Nattract-1: REM take influence of each attractor into account
          PROC_UpdateVelAttract(x(k%)-xattract(n%),y(k%)-yattract(n%),k%)
        NEXT
      NEXT
      REM Update velocity of a point due to B field, based on current vx, vy and constant B
      REM This simulates (kind of) a force applied to the point at 90deg from its direction of travel
      vx()+=-vy()*B: REM is equivalent to vx(k%)+=-vy(k%)*B inside the FOR loop
      vy()+=vx()*B: REM is equivalent to vy(k%)+=vx(k%)*B inside the FOR loop
      REM finally update the positions
      x()+=vx(): REM is equivalent to x(k%)+=vx(k%) inside the FOR loop
      y()+=vy(): REM is equivalent to y(k%)+=vy(k%) inside the FOR loop
      ENDPROC

      DEF PROC_ApplySemiTranspOverlay
      GCOL 0:RECTANGLE FILL -W%,-H%,W2%,H2%
      ENDPROC

      REM draw a disk at position of all attractors
      DEF PROC_DrawAttractors
      GCOL 15
      FOR n%=0 TO Nattract-1
        CIRCLE FILL 2*xattract(n%),2*yattract(n%),15
      NEXT
      ENDPROC

      REM draw all the points using their stored logical color defined at start in array col%()
      DEF PROC_DrawPoints
      FOR k%=0 TO  Npoints%-1
        GCOL col%(k%): PLOT 2*x(k%),2*y(k%)
      NEXT
      ENDPROC





