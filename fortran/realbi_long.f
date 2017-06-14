C     PROGRAM REALBI.F
C  Program computes bispectrum from real data
c  read in from the input data file in the following format
c        time, real-data
C prgram uses   CALL BISPC1(SFREQ,NPARTS,NPTS,NSKIP,RDATA,IDATA,BI)
c BISPC1 assumes real input data
c
c npoints =    number of data points to be read in, i.e npoint=2048
c nparts =     number of data intervals to average
c npts =       number of points per data interval
c nskip =      number of data points to skip (if no overlap nskip=npts)
c
      COMMON/DATA/ RDATA(12000),IDATA(12000),TIME(12000)
      REAL RDATA,IDATA,TIME
      COMMON/LARGE1/  BI(1024,1024)
      CHARACTER*30 FILE1,FILE2,NAME
C****************************
      WRITE(6,*) "ENTER: INPUT DATA FILE NAME"
      READ(5,'(A18)') FILE1
      OPEN(20,FILE=FILE1,STATUS="UNKNOWN",ERR=1000)
      WRITE(6,*) "ENTER: OUTPUT DATA FILE NAME"
      READ(5,'(A18)') FILE2
      OPEN(16,FILE=FILE2,STATUS="UNKNOWN",ERR=1000)
C
      WRITE(6,*)"ENTER: NPOINTS, NPTS, NPARTS,NSKIP"
      READ(5,*) NPOINTS,NPTS,NPARTS,NSKIP
      WRITE(6,*) "ENTER: COH. THRESH. "
      READ(5,*) THRESH
      WRITE(6,*) "ENTER: START TIME. "
      READ(5,*) TSTART
C*****************************
      NPT2 = NPTS/2
      do I=1,NPOINTS
         RDATA(I)=0.0
         IDATA(I)=0.0
         TIME(I)=0.0
      END do
C*******READ*IN*DATA**********
      do i=1,100000
         READ(20,*) XTIME,XDATA
         RDATA(1) = XDATA
         IDATA(1) = 0.0
         TIME(1) = XTIME
         IF(XTIME.GE.TSTART) GOTO 5
      END do
  5   TSTART = TIME(1)
      DO 10 I=2,NPOINTS
         READ(20,*)XTIME,XDATA
         IF(I.EQ.NPTS) TEND = XTIME
         RDATA(I) = XDATA
         IDATA(I) = 0.0
         TIME(I) = XTIME
  10  CONTINUE
C*************************************
C   CALL BISPECTRAL ROUTINE
      WRITE(6,*)"PRE-BISPC",NPARTS,NPTS,NPOINTS
      TSAMPLE  = (TEND-TSTART)/FLOAT(NPTS-1)
      TLENGTH  = TEND - TSTART
      SFREQ = 1./TSAMPLE
      DFREQ = 1/TLENGTH
      CALL BISPC(SFREQ,NPARTS,NPTS,NSKIP,RDATA,IDATA,BI)
C
      NUM=0.
      IMAX = NPT2
      NMAX = NPTS
      ND2  = NPT2/2
      WRITE(16,9) NPTS,SFREQ,DFREQ
  9   FORMAT(" NPTS,SFREQ,DFREQ",1X,I3,1X,F8.2,1X,F9.3)
      DO 1 I=1,NPT2
         II = I
         IF(II.GT.NPT2/2) II =  NPT2 - I
         DO 2 J=1,II
            IJ = I + J
            FREQ1 = DFREQ*FLOAT(I-1)
            FREQ2 = DFREQ*FLOAT(J-1)
            FREQ3= FREQ1 + FREQ2
            COH=BI(I,J)
            IF (COH.LE.THRESH) COH = 0.
            WRITE(16,11) I,J,IJ,FREQ1,FREQ2,FREQ3,COH
   11       FORMAT(" I,J,IJ,F1,F2,F3,COH",1X,I3,1X,I3,1X,I3,
     +                 1X,F7.2,1X,F7.2,1X,F7.2,1X,F6.4)
         SUMCOH=SUMCOH+COH
         NUM=NUM+1
2        CONTINUE
1     CONTINUE
      AVGCOH=SUMCOH/NUM
C     WRITE(16,-)AVGCOH,NUM
 1000 STOP
      END
c----------------------------------------------------
C
c    routine that calculates the bispectra
c
C --------------------------------------------------
      SUBROUTINE BISPC(SFREQ,NPART,N,NINC,XA,XB,BI)
C --------------------------------------------------
C
      PARAMETER (NN=1024,JN=50)
      DIMENSION XR(NN),XI(NN),FREQ(NN),XA(*),XB(*)
      COMMON/LARGE/ SPECT(JN,NN),PHASE(JN,NN)
      REAL BI(NN,NN)
      REAL A,TR,TI,PI,C1,C2,RAD1,RAD2,P
      REAL BISPCT,COH,SUMCOH,ACOH
      REAL PRDSPC,SMPHAS,SPSPCR,SPSPCI
      REAL SMSPC1,SMSPC2,SMSPC3
      REAL PSMSPC
      INTEGER N,M,Z,NU,N2,DLINE,NLINE,NPTSL
      REAL DATA
C
      NPTS = N
      NPT2 = N/2
      DFREQ = SFREQ/FLOAT(NPTS-1)
      ALPHA=FLOAT(NPTS)/10.0
      END=FLOAT(NPTS)-ALPHA
      IALPHA=INT(ALPHA)
      IEND=INT(END)
      IN = 0
      do I=1,N
      do J=1,N
         BI(I,J) = 0.0
         END do
      END do
      do II=1,NPART
         IN = (II-1)*NINC
         do I=1,N
            XR(I)=0.0
            XI(I)=0.0
         END do
C*******READ*IN*DATA**********
         DO 10 I=1,NPTS
            IN = IN + 1
            ADATA = XA(IN)
            BDATA = XB(IN)
C********TAPERING*************
C    ***COSINE TAPER*******
            IF(I.LE.IALPHA)THEN
               RAD1=(3.14159265/ALPHA)*FLOAT(I-1)
               C1=0.5*(1-COS(RAD1))
               ADATA=ADATA*C1
               BDATA=BDATA*C1
            END IF
            IF(I.GE.IEND)THEN
               RAD2=(3.14159265/ALPHA)*FLOAT(NPTS-I)
               C2=0.5*(1-COS(RAD2))
               ADATA=ADATA*C2
               BDATA=BDATA*C2
            END IF

C*********************************
            XR(I)=ADATA*1.0
            XI(I)=BDATA*1.0
  10     CONTINUE
C*************************************
C   CALL FFT
         IL = 0
         CALL FFT842(IL,NPTS,XR,XI)
C
         DO 150 I=1,N
            J=I
            APHASE=ATAN2(XI(J),XR(J))
            AMAG=(XI(J)**2+XR(J)**2)**0.5
            SPECT(II,I)=AMAG
            PHASE(II,I)=APHASE
 150     CONTINUE
      END do
C*******END*OF*FFT**FFT**FFT**FFT**FFT**
C*******COMPUTES*THE*COHERENCY**********
C********************+++++++++++++++++++
      SUMCOH=0.
      NUM=0.
      DO 1 I=1,NPT2
         II = I
         IF(II.GT.NPT2/2) II =  NPT2 - I
         DO 2 J=1,II
            IJ = I + J
            COH = 0.
            SPSPCR=0
            SPSPCI=0
            SMSPC1=0
            SMSPC2=0
            SMSPC3=0
            SMSPC4=0
            SMSPC5=0
            SMSPC6=0
            DO 3 K=1,NPART
               PRDSPC=SPECT(K,I)*SPECT(K,J)*SPECT(K,IJ)
               SMPHAS=PHASE(K,I)+PHASE(K,J)-PHASE(K,IJ)
               SPSPCR=PRDSPC*COS(SMPHAS)+SPSPCR
               SPSPCI=PRDSPC*SIN(SMPHAS)+SPSPCI
               SMSPC1=SPECT(K,I)**2+SMSPC1
               SMSPC2=(SPECT(K,J)*SPECT(K,IJ))**2+SMSPC2
               SMSPC3=SPECT(K,J)**2+SMSPC3
               SMSPC4=(SPECT(K,I)*SPECT(K,IJ))**2+SMSPC4
               SMSPC5=SPECT(K,IJ)**2+SMSPC5
               SMSPC6=(SPECT(K,I)*SPECT(K,J))**2+SMSPC6
3           CONTINUE
            PSMSPC1=SMSPC1*SMSPC2
            PSMSPC2=SMSPC3*SMSPC4
            PSMSPC3=SMSPC5*SMSPC6
            BISPCT=SPSPCR**2+SPSPCI**2
            COH1=BISPCT/PSMSPC1
            COH2=BISPCT/PSMSPC2
            COH3=BISPCT/PSMSPC3
            COH=(COH1+COH2+COH3)/3
            F1 = DFREQ*FLOAT(I-1)
            F2 = DFREQ*FLOAT(J-1)
C           WRITE(19,11) I,J,IJ,COH,F1,F2
   11       FORMAT(" I,J,IJ,F1,F2",1X,I3,1X,I3,1X,I3,
     +                         1X,F6.4,1X,F9.3,1X,F9.3)
            BI(I,J) = COH
            SUMCOH=SUMCOH+COH
            NUM=NUM+1
2        CONTINUE
1     CONTINUE
      AVGCOH=SUMCOH/NUM
 1000 RETURN
      END
c----------------------------------------------------
      SUBROUTINE FFT842(IN,N,X,Y)
C----------------------------------------------------------------
C SUBROUTINE:   FFT842
C FAST FOURIER TRANSFORM FOR N=2**M
C COMPLEX INPUT
C
C
C THIS PROGRAM REPLACES THE VECTOR Z=X+iY BY ITS FINITE
C DISCRETE FOURIER TRANSFORM IF IN=0 AND THE INVERSE
C TRANSFORM IF IN=1. IT PERFORMS AS MANY BASE 8 ITERATIONS
C AS POSSIBLE AND THEN FINISHES WITH A BASE 4 OR A BASE 2
C ITERATION IF NEEDED.
C
      DIMENSION X(*),Y(*),L(15)
      COMMON/CON2/ PI2,P7
      EQUIVALENCE (L15,L(1)),(L14,L(2)),(L13,L(3)),(L12,L(4)),
     *     (L11,L(5)),(L10,L(6)),(L9,L(7)),(L8,L(8)),(L7,L(9)),
     *     (L6,L(10)),(L5,L(11)),(L4,L(12)),(L3,L(13)),(L2,L(14)),
     *     (L1,L(15))
C
C IW IS A MACHINE DEPENDENT WRITE DEVICE NUMBER
C
      IW = 6
C
      PI2 = 8.*ATAN(1.)
      P7 = 1./SQRT(2.)
      DO 10 I=1,15
         M = I
         NT = 2**I
         IF(N.EQ.NT)GOTO 20
   10 CONTINUE
      WRITE(IW,9999)
 9999 FORMAT(35H N IS NOT A POWER OF TWO FOR FFT842)
      STOP
   20 N2POW = M
      NTHPO = N
      FN = NTHPO
      IF(IN.EQ.1)GOTO 40
      DO 30 I=1,NTHPO
         Y(I) = -Y(I)
   30 CONTINUE
   40 N8POW = N2POW/3
      IF(N8POW.EQ.0)GOTO 60
C
C RADIX 8 PASSES IF ANY
C
      DO 50 IPASS=1,N8POW
         NXTLT = 2**(N2POW-3*IPASS)
         LENGT = 8*NXTLT
         CALL R8TX(NXTLT,NTHPO,LENGT,X(1),X(NXTLT+1),X(2*NXTLT+1),
     *        X(3*NXTLT+1),X(4*NXTLT+1),X(5*NXTLT+1),X(6*NXTLT+1),
     *        X(7*NXTLT+1),Y(1),Y(NXTLT+1),Y(2*NXTLT+1),Y(3*NXTLT+1),
     *        Y(4*NXTLT+1),Y(5*NXTLT+1),Y(6*NXTLT+1),Y(7*NXTLT+1))
   50 CONTINUE
C
C IS THERE A FOUR FACTOR LEFT
C
   60 IF(N2POW-3*N8POW-1) 90,70,80
C
C GO THROUGH THE BASE 2 ITERATION
C
   70 CALL R2TX(NTHPO,X(1),X(2),Y(1),Y(2))
      GOTO 90
C
C GO THROUGH THE BASE 4 ITERATION
C
   80 CALL R4TX(NTHPO,X(1),X(2),X(3),X(4),Y(1),Y(2),Y(3),Y(4))
C
   90 DO 110 J=1,15
         L(J) = 1
         IF(J-N2POW) 100,100,110
  100    L(J) = 2**(N2POW+1-J)
  110 CONTINUE
      IJ = 1
      DO 130 J1=1,L1
      DO 130 J2=J1,L2,L1
      DO 130 J3=J2,L3,L2
      DO 130 J4=J3,L4,L3
      DO 130 J5=J4,L5,L4
      DO 130 J6=J5,L6,L5
      DO 130 J7=J6,L7,L6
      DO 130 J8=J7,L8,L7
      DO 130 J9=J8,L9,L8
      DO 130 J10=J9,L10,L9
      DO 130 J11=J10,L11,L10
      DO 130 J12=J11,L12,L11
      DO 130 J13=J12,L13,L12
      DO 130 J14=J13,L14,L13
      DO 130 JI=J14,L15,L14
         IF(IJ-JI) 120,130,130
  120    R = X(IJ)
         X(IJ) = X(JI)
         X(JI) = R
         FI = Y(IJ)
         Y(IJ) = Y(JI)
         Y(JI) = FI
  130    IJ =IJ + 1
      IF(IN.EQ.1)GOTO 150
      DO 140 I=1,NTHPO
         Y(I) = -Y(I)
      X(I) = X(I)/FN
      Y(I) = Y(I)/FN
  140 CONTINUE
      GOTO 170
  150 DO 160 I=1,NTHPO
         X(I) = X(I)
         Y(I) = Y(I)
  160 CONTINUE
 170  CONTINUE
      RETURN
      END
C
C------------------------------------------------------------------
C SUBROUTINE:   R2TX
C RADIX 2 ITERATION SUBROUTINE
C------------------------------------------------------------------
C
      SUBROUTINE R2TX(NTHPO,CR0,CR1,CI0,CI1)
      DIMENSION CR0(*),CR1(*),CI0(*),CI1(*)
      DO 10 K=1,NTHPO,2
         R1 = CR0(K) + CR1(K)
         CR1(K) = CR0(K) - CR1(K)
         CR0(K) = R1
         FI1 = CI0(K) + CI1(K)
         CI1(K) = CI0(K) - CI1(K)
         CI0(K) = FI1
   10 CONTINUE
      RETURN
      END
C
C-----------------------------------------------------------------
C SUBROUTINE:   R4TX
C RADIX 4 ITERATION SUBROUTINE
C-----------------------------------------------------------------
C
      SUBROUTINE R4TX(NTHPO,CR0,CR1,CR2,CR3,CI0,CI1,CI2,CI3)
      DIMENSION CR0(*),CR1(*),CR2(*),CR3(*),CI0(*),CI1(*),
     *      CI2(*),CI3(*)
      DO 10 K=1,NTHPO,4
         R1 = CR0(K) + CR2(K)
         R2 = CR0(K) - CR2(K)
         R3 = CR1(K) + CR3(K)
         R4 = CR1(K) - CR3(K)
         FI1 = CI0(K) + CI2(K)
         FI2 = CI0(K) - CI2(K)
         FI3 = CI1(K) + CI3(K)
         FI4 = CI1(K) - CI3(K)
         CR0(K) = R1 + R3
         CI0(K) = FI1 + FI3
         CR1(K) = R1 - R3
         CI1(K) = FI1 - FI3
         CR2(K) = R2 - FI4
         CI2(K) = FI2 + R4
         CR3(K) = R2 + FI4
         CI3(K) = FI2 - R4
   10 CONTINUE
      RETURN
      END
C
C-----------------------------------------------------------------
C SUBROUTINE:   R8TX
C RADIX 8 ITERATION ROUTINE
C-----------------------------------------------------------------
C
      SUBROUTINE R8TX(NXTLT,NTHPO,LENGT,CR0,CR1,CR2,CR3,CR4,
     *    CR5,CR6,CR7,CI0,CI1,CI2,CI3,CI4,CI5,CI6,CI7)
      DIMENSION CR0(*),CR1(*),CR2(*),CR3(*),CR4(*),CR5(*),
     *    CR6(*),CR7(*),CI0(*),CI1(*),CI2(*),CI3(*),
     *    CI4(*),CI5(*),CI6(*),CI7(*)
      COMMON/CON2/ PI2,P7
C
      SCALE = PI2/FLOAT(LENGT)
      DO 30 J=1,NXTLT
         ARG = FLOAT(J-1)*SCALE
         C1 = COS(ARG)
         S1 = SIN(ARG)
         C2 = C1**2 - S1**2
         S2 = C1*S1 + C1*S1
         C3 = C1*C2 - S1*S2
         S3 = C2*S1 + S2*C1
         C4 = C2**2 - S2**2
         S4 = C2*S2 + C2*S2
         C5 = C2*C3 - S2*S3
         S5 = C3*S2 + S3*C2
         C6 = C3**2 - S3**2
         S6 = C3*S3 + C3*S3
         C7 = C3*C4 - S3*S4
         S7 = C4*S3 + S4*C3
         DO 20 K=J,NTHPO,LENGT
            AR0 = CR0(K) + CR4(K)
            AR1 = CR1(K) + CR5(K)
            AR2 = CR2(K) + CR6(K)
            AR3 = CR3(K) + CR7(K)
            AR4 = CR0(K) - CR4(K)
            AR5 = CR1(K) - CR5(K)
            AR6 = CR2(K) - CR6(K)
            AR7 = CR3(K) - CR7(K)
            AI0 = CI0(K) + CI4(K)
            AI1 = CI1(K) + CI5(K)
            AI2 = CI2(K) + CI6(K)
            AI3 = CI3(K) + CI7(K)
            AI4 = CI0(K) - CI4(K)
            AI5 = CI1(K) - CI5(K)
            AI6 = CI2(K) - CI6(K)
            AI7 = CI3(K) - CI7(K)
            BR0 = AR0 + AR2
            BR1 = AR1 + AR3
            BR2 = AR0 - AR2
            BR3 = AR1 - AR3
            BR4 = AR4 - AI6
            BR5 = AR5 - AI7
            BR6 = AR4 + AI6
            BR7 = AR5 + AI7
            BI0 = AI0 + AI2
            BI1 = AI1 + AI3
            BI2 = AI0 - AI2
            BI3 = AI1 - AI3
            BI4 = AI4 + AR6
            BI5 = AI5 + AR7
            BI6 = AI4 - AR6
            BI7 = AI5 - AR7
            CR0(K) = BR0 + BR1
            CI0(K) = BI0 + BI1
            IF(J.LE.1)GOTO 10
            CR1(K) = C4*(BR0-BR1) - S4*(BI0-BI1)
            CI1(K) = C4*(BI0-BI1) + S4*(BR0-BR1)
            CR2(K) = C2*(BR2-BI3) - S2*(BI2+BR3)
            CI2(K) = C2*(BI2+BR3) + S2*(BR2-BI3)
            CR3(K) = C6*(BR2+BI3) - S6*(BI2-BR3)
            CI3(K) = C6*(BI2-BR3) + S6*(BR2+BI3)
            TR = P7*(BR5-BI5)
            TI = P7*(BR5+BI5)
            CR4(K) = C1*(BR4+TR) - S1*(BI4+TI)
            CI4(K) = C1*(BI4+TI) + S1*(BR4+TR)
            CR5(K) = C5*(BR4-TR) - S5*(BI4-TI)
            CI5(K) = C5*(BI4-TI) + S5*(BR4-TR)
            TR = -P7*(BR7+BI7)
            TI = P7*(BR7-BI7)
            CR6(K) = C3*(BR6+TR) - S3*(BI6+TI)
            CI6(K) = C3*(BI6+TI) + S3*(BR6+TR)
            CR7(K) = C7*(BR6-TR) - S7*(BI6-TI)
            CI7(K) = C7*(BI6-TI) + S7*(BR6-TR)
            GOTO 20
   10       CR1(K) = BR0 - BR1
            CI1(K) = BI0 - BI1
            CR2(K) = BR2 - BI3
            CI2(K) = BI2 + BR3
            CR3(K) = BR2 + BI3
            CI3(K) = BI2 - BR3
            TR = P7*(BR5-BI5)
            TI = P7*(BR5+BI5)
            CR4(K) = BR4 + TR
            CI4(K) = BI4 + TI
            CR5(K) = BR4 - TR
            CI5(K) = BI4 - TI
            TR = -P7*(BR7+BI7)
            TI = P7*(BR7-BI7)
            CR6(K) = BR6 + TR
            CI6(K) = BI6 + TI
            CR7(K) = BR6 - TR
            CI7(K) = BI6 - TI
   20    CONTINUE
   30 CONTINUE
      RETURN
      END
c----------------------------------------------------
      subroutine sort(n,p1)
C-------------------------------------------------------------
      dimension p1(8192),w1(8192)
C
      npts = n
      nhalf = npts/2
C
C  D.C. IS REPLACED BY AVERAGE OF THE TWO ADAJACENT FREQUENCIES
c     P1(1)=(P1(2)+P1(NPTS))/2.
C
      do I=1,NHALF-1
      II=I+NHALF
      W1(I)=P1(II+1)
      W1(II-1)=P1(I)
      END do
      W1(NPTS-1)=P1(NHALF)
      W1(NPTS)=P1(NHALF+1)
      do I=1,NPTS
      P1(I)=W1(I)
      END do
      RETURN
      END
C ------------------------------------------------------------








































