C> @file
C>
C> @author IREDELL @date 94-04-01
C
C>  PACK AND WRITE A GRIB MESSAGE.
C>  THIS SUBPROGRAM IS NEARLY THE INVERSE OF GETGBE.
C>
C> PROGRAM HISTORY LOG:
C>   94-04-01  IREDELL
C>   95-10-31  IREDELL     REMOVED SAVES AND PRINTS
C>   97-02-11  Y.ZHU       INCLUDED PROBABILITY AND CLUSTER ARGUMENTS
C> 2002-03-18  GILBERT     MODIFIED FROM PUTGBEX TO ACCOUNT FOR
C>                         BINARY SCALE FACTORS.
C>
C> USAGE:    CALL PUTGBEXN(LUGB,KF,KPDS,KGDS,KENS,
C>    &                   KPROB,XPROB,KCLUST,KMEMBR,IBS,NBITS,LB,F,IRET)
C>   INPUT ARGUMENTS:
C>     LUGB         INTEGER UNIT OF THE UNBLOCKED GRIB DATA FILE
C>     KF           INTEGER NUMBER OF DATA POINTS
C>     KPDS         INTEGER (200) PDS PARAMETERS
C>          (1)   - ID OF CENTER
C>          (2)   - GENERATING PROCESS ID NUMBER
C>          (3)   - GRID DEFINITION
C>          (4)   - GDS/BMS FLAG (RIGHT ADJ COPY OF OCTET 8)
C>          (5)   - INDICATOR OF PARAMETER
C>          (6)   - TYPE OF LEVEL
C>          (7)   - HEIGHT/PRESSURE , ETC OF LEVEL
C>          (8)   - YEAR INCLUDING (CENTURY-1)
C>          (9)   - MONTH OF YEAR
C>          (10)  - DAY OF MONTH
C>          (11)  - HOUR OF DAY
C>          (12)  - MINUTE OF HOUR
C>          (13)  - INDICATOR OF FORECAST TIME UNIT
C>          (14)  - TIME RANGE 1
C>          (15)  - TIME RANGE 2
C>          (16)  - TIME RANGE FLAG
C>          (17)  - NUMBER INCLUDED IN AVERAGE
C>          (18)  - VERSION NR OF GRIB SPECIFICATION
C>          (19)  - VERSION NR OF PARAMETER TABLE
C>          (20)  - NR MISSING FROM AVERAGE/ACCUMULATION
C>          (21)  - CENTURY OF REFERENCE TIME OF DATA
C>          (22)  - UNITS DECIMAL SCALE FACTOR
C>          (23)  - SUBCENTER NUMBER
C>          (24)  - PDS BYTE 29, FOR NMC ENSEMBLE PRODUCTS
C>                  128 IF FORECAST FIELD ERROR
C>                   64 IF BIAS CORRECTED FCST FIELD
C>                   32 IF SMOOTHED FIELD
C>                  WARNING: CAN BE COMBINATION OF MORE THAN 1
C>          (25)  - PDS BYTE 30, NOT USED
C>     KGDS         INTEGER (200) GDS PARAMETERS
C>          (1)   - DATA REPRESENTATION TYPE
C>          (19)  - NUMBER OF VERTICAL COORDINATE PARAMETERS
C>          (20)  - OCTET NUMBER OF THE LIST OF VERTICAL COORDINATE
C>                  PARAMETERS
C>                  OR
C>                  OCTET NUMBER OF THE LIST OF NUMBERS OF POINTS
C>                  IN EACH ROW
C>                  OR
C>                  255 IF NEITHER ARE PRESENT
C>          (21)  - FOR GRIDS WITH PL, NUMBER OF POINTS IN GRID
C>          (22)  - NUMBER OF WORDS IN EACH ROW
C>       LATITUDE/LONGITUDE GRIDS
C>          (2)   - N(I) NR POINTS ON LATITUDE CIRCLE
C>          (3)   - N(J) NR POINTS ON LONGITUDE MERIDIAN
C>          (4)   - LA(1) LATITUDE OF ORIGIN
C>          (5)   - LO(1) LONGITUDE OF ORIGIN
C>          (6)   - RESOLUTION FLAG (RIGHT ADJ COPY OF OCTET 17)
C>          (7)   - LA(2) LATITUDE OF EXTREME POINT
C>          (8)   - LO(2) LONGITUDE OF EXTREME POINT
C>          (9)   - DI LONGITUDINAL DIRECTION OF INCREMENT
C>          (10)  - DJ LATITUDINAL DIRECTION INCREMENT
C>          (11)  - SCANNING MODE FLAG (RIGHT ADJ COPY OF OCTET 28)
C>       GAUSSIAN  GRIDS
C>          (2)   - N(I) NR POINTS ON LATITUDE CIRCLE
C>          (3)   - N(J) NR POINTS ON LONGITUDE MERIDIAN
C>          (4)   - LA(1) LATITUDE OF ORIGIN
C>          (5)   - LO(1) LONGITUDE OF ORIGIN
C>          (6)   - RESOLUTION FLAG  (RIGHT ADJ COPY OF OCTET 17)
C>          (7)   - LA(2) LATITUDE OF EXTREME POINT
C>          (8)   - LO(2) LONGITUDE OF EXTREME POINT
C>          (9)   - DI LONGITUDINAL DIRECTION OF INCREMENT
C>          (10)  - N - NR OF CIRCLES POLE TO EQUATOR
C>          (11)  - SCANNING MODE FLAG (RIGHT ADJ COPY OF OCTET 28)
C>          (12)  - NV - NR OF VERT COORD PARAMETERS
C>          (13)  - PV - OCTET NR OF LIST OF VERT COORD PARAMETERS
C>                             OR
C>                  PL - LOCATION OF THE LIST OF NUMBERS OF POINTS IN
C>                       EACH ROW (IF NO VERT COORD PARAMETERS
C>                       ARE PRESENT
C>                             OR
C>                  255 IF NEITHER ARE PRESENT
C>       POLAR STEREOGRAPHIC GRIDS
C>          (2)   - N(I) NR POINTS ALONG LAT CIRCLE
C>          (3)   - N(J) NR POINTS ALONG LON CIRCLE
C>          (4)   - LA(1) LATITUDE OF ORIGIN
C>          (5)   - LO(1) LONGITUDE OF ORIGIN
C>          (6)   - RESOLUTION FLAG  (RIGHT ADJ COPY OF OCTET 17)
C>          (7)   - LOV GRID ORIENTATION
C>          (8)   - DX - X DIRECTION INCREMENT
C>          (9)   - DY - Y DIRECTION INCREMENT
C>          (10)  - PROJECTION CENTER FLAG
C>          (11)  - SCANNING MODE (RIGHT ADJ COPY OF OCTET 28)
C>       SPHERICAL HARMONIC COEFFICIENTS
C>          (2)   - J PENTAGONAL RESOLUTION PARAMETER
C>          (3)   - K      "          "         "
C>          (4)   - M      "          "         "
C>          (5)   - REPRESENTATION TYPE
C>          (6)   - COEFFICIENT STORAGE MODE
C>       MERCATOR GRIDS
C>          (2)   - N(I) NR POINTS ON LATITUDE CIRCLE
C>          (3)   - N(J) NR POINTS ON LONGITUDE MERIDIAN
C>          (4)   - LA(1) LATITUDE OF ORIGIN
C>          (5)   - LO(1) LONGITUDE OF ORIGIN
C>          (6)   - RESOLUTION FLAG (RIGHT ADJ COPY OF OCTET 17)
C>          (7)   - LA(2) LATITUDE OF LAST GRID POINT
C>          (8)   - LO(2) LONGITUDE OF LAST GRID POINT
C>          (9)   - LATIT - LATITUDE OF PROJECTION INTERSECTION
C>          (10)  - RESERVED
C>          (11)  - SCANNING MODE FLAG (RIGHT ADJ COPY OF OCTET 28)
C>          (12)  - LONGITUDINAL DIR GRID LENGTH
C>          (13)  - LATITUDINAL DIR GRID LENGTH
C>       LAMBERT CONFORMAL GRIDS
C>          (2)   - NX NR POINTS ALONG X-AXIS
C>          (3)   - NY NR POINTS ALONG Y-AXIS
C>          (4)   - LA1 LAT OF ORIGIN (LOWER LEFT)
C>          (5)   - LO1 LON OF ORIGIN (LOWER LEFT)
C>          (6)   - RESOLUTION (RIGHT ADJ COPY OF OCTET 17)
C>          (7)   - LOV - ORIENTATION OF GRID
C>          (8)   - DX - X-DIR INCREMENT
C>          (9)   - DY - Y-DIR INCREMENT
C>          (10)  - PROJECTION CENTER FLAG
C>          (11)  - SCANNING MODE FLAG (RIGHT ADJ COPY OF OCTET 28)
C>          (12)  - LATIN 1 - FIRST LAT FROM POLE OF SECANT CONE INTER
C>          (13)  - LATIN 2 - SECOND LAT FROM POLE OF SECANT CONE INTER
C>     KENS         INTEGER (200) ENSEMBLE PDS PARMS
C>          (1)   - APPLICATION IDENTIFIER
C>          (2)   - ENSEMBLE TYPE
C>          (3)   - ENSEMBLE IDENTIFIER
C>          (4)   - PRODUCT IDENTIFIER
C>          (5)   - SMOOTHING FLAG
C>     KPROB        INTEGER (2) PROBABILITY ENSEMBLE PARMS
C>     XPROB        REAL    (2) PROBABILITY ENSEMBLE PARMS
C>     KCLUST       INTEGER (16) CLUSTER ENSEMBLE PARMS
C>     KMEMBR       INTEGER (8) CLUSTER ENSEMBLE PARMS
C>     IBS          INTEGER BINARY SCALE FACTOR (0 TO IGNORE)
C>     NBITS        INTEGER NUMBER OF BITS IN WHICH TO PACK (0 TO IGNORE)
C>     LB           LOGICAL*1 (KF) BITMAP IF PRESENT
C>     F            REAL (KF) DATA
C>   OUTPUT ARGUMENTS:
C>     IRET         INTEGER RETURN CODE
C>                    0      ALL OK
C>                    OTHER  W3FI72 GRIB PACKER RETURN CODE
C>
C> SUBPROGRAMS CALLED:
C>   R63W72         MAP W3FI63 PARAMETERS ONTO W3FI72 PARAMETERS
C>   GETBIT         GET NUMBER OF BITS AND ROUND DATA
C>   W3FI72         PACK GRIB
C>   WRYTE          WRITE DATA
C>
C> REMARKS: SUBPROGRAM CAN BE CALLED FROM A MULTIPROCESSING ENVIRONMENT.
C>   DO NOT ENGAGE THE SAME LOGICAL UNIT FROM MORE THAN ONE PROCESSOR.
C>
C> ATTRIBUTES:
C>   LANGUAGE: FORTRAN 77
C>   MACHINE:  CRAY, WORKSTATIONS
C>
C>
      SUBROUTINE PUTGBEXN(LUGB,KF,KPDS,KGDS,KENS,
     &                   KPROB,XPROB,KCLUST,KMEMBR,IBS,NBITS,LB,F,IRET)

      INTEGER KPDS(200),KGDS(200),KENS(200)
      INTEGER KPROB(2),KCLUST(16),KMEMBR(80)
      REAL XPROB(2)
      LOGICAL*1 LB(KF)
      REAL F(KF)
C      PARAMETER(MAXBIT=16)
      PARAMETER(MAXBIT=24)
      INTEGER IBM(KF),IPDS(200),IGDS(200),IBDS(200)
      CHARACTER PDS(400),GRIB(1000+KF*(MAXBIT+1)/8)
C - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C  GET W3FI72 PARAMETERS
      !print *,'SAGT: start putgbexn'
      CALL R63W72(KPDS,KGDS,IPDS,IGDS)
      IBDS=0
C - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C  COUNT VALID DATA
      KBM=KF
      IF(IPDS(7).NE.0) THEN
        KBM=0
        DO I=1,KF
          IF(LB(I)) THEN
            IBM(I)=1
            KBM=KBM+1
          ELSE
            IBM(I)=0
          ENDIF
        ENDDO
        IF(KBM.EQ.KF) IPDS(7)=0
      ENDIF
C - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C  GET NUMBER OF BITS AND ROUND DATA
      IF(NBITS.GT.0) THEN
        NBIT=NBITS
      ELSE
        IF(KBM.EQ.0) THEN
          DO I=1,KF
            F(I)=0.
          ENDDO
          NBIT=0
        ELSE
          !print *,'SAGT:',IPDS(7),IBS,IPDS(25),KF
          !print *,'SAGT:',count(ibm.eq.0),count(ibm.eq.1)
          CALL SETBIT(IPDS(7),-IBS,IPDS(25),KF,IBM,F,FMIN,FMAX,NBIT)
          NBIT=MIN(NBIT,MAXBIT)
        ENDIF
      ENDIF
C - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C  CREATE PRODUCT DEFINITION SECTION
      CALL W3FI68(IPDS,PDS)
      IF(IPDS(24).EQ.2) THEN
        ILAST=45
        IF ( IPDS(8).EQ.191.OR.IPDS(8).EQ.192 ) ILAST=55
        IF ( KENS(2).EQ.5) ILAST=76
        IF ( KENS(2).EQ.5) ILAST=86
        IF ( KENS(2).EQ.4) ILAST=86
        CALL PDSENS(KENS,KPROB,XPROB,KCLUST,KMEMBR,ILAST,PDS)
      ENDIF
C - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C  PACK AND WRITE GRIB DATA
      igflag=1
      igrid=kpds(3)
      if ( igrid.ne.255 ) igflag=0
      !print *,minval(f(1:kf)),maxval(f(1:kf))
      !print *,nbit,kf
      !print *,(ipds(j),j=1,28)
      !write(6,fmt='(28z2)') (pds(j),j=1,28)
      !print *,(kgds(j),j=1,28)
      !print *,(igds(j),j=1,28)
      icomp=0
      CALL W3FI72(0,F,0,NBIT,1,IPDS,PDS,
     &            igflag,igrid,IGDS,ICOMP,0,IBM,KF,IBDS,
     &            KFO,GRIB,LGRIB,IRET)
      IF(IRET.EQ.0) CALL WRYTE(LUGB,LGRIB,GRIB)
C - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      RETURN
      END


