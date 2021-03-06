10 '******* STARTREK for the IBM PC **********  (C) Graham Wheeler 1984
20 REM======================================================================
30 REM
40 REM
50 RANDOMIZE TIMER:OPTION BASE 0:SND=0   'Init randomizer, set array subscript base to zero and deselect sound
60 REM-------------------------------------------------------------------
70 REM
80 REM    Define functions for random number generation and code extraction
90 REM
100 DEF FNSETUP(X)=-(RND>X)
110 DEF FNUM(X)=RND*X+1
120 DEF FNCOOR=INT(FNUM(8))
130 DEF FNEXA(X)=X MOD 10
140 DEF FNEXB(X)=INT((X MOD 100)/10)
150 DEF FNEXC(X)=INT((X MOD 1000)/100)
160 DEF FNEXD(X)=INT(X/1000)
170 DEF FNEXE(X)=INT(X/100)
180 DEF FNR(X)=INT(X+.5)
190 REM
200 REM --------------------------------------------------------------------
210 REM Set up data arrays
220 REM
230 DIM GALAXY(8,8,2),DAMAGE(8),QUADRANT(9,9),PLANET(8,8,4)
240 DIM DAM$(8),INFO$(8),SEC$(7),PLAN$(10),PLBN$(10)
250 RESTORE
260 FOR I=1 TO 8:READ DAM$(I):NEXT
270 DATA WARP DRIVES,S.R. SENSORS,L.R. SENSORS,PHASERS,PHOTON TUBES,SUBSPACE RADIO,SHIELDS,TELEPORTER
280 FOR I=1 TO 8:READ INFO$(I):NEXT
290 DATA STARDATE,ENERGY,SHIELDS,TORPEDOES,KLINGONS,STATUS,QUADRANT,SECTOR
300 FOR I=1 TO 7:READ SEC$(I):NEXT
310 DATA KLINGON,ASTEROID,BLACK HOLE,K. BASE,STARBASE,PLANET,STAR
320 FOR I=1 TO 10:READ PLAN$(I),PLBN$(I):NEXT I
330 DATA ARCTURUS,MAJOR,SIRIUS,MINOR,CORONUS,ALPHA,PHAEDRUS,BETA,BETELGUESE,DELTA,APHRAXIS,GAMMA,DARIUS,OMEGA,JUXUS,I,CRYTON,II,GESSERIT,IV
340 REM
350 REM---------------------------------------------------------------------
360 REM
370 REM Get player name, display instructions and set up galaxy
380 REM
390 GOSUB 3950
400 ENERGY=4000:TORPS=15:QUADX=FNCOOR:QUADY=FNCOOR:SECX=FNCOOR:SECY=FNCOOR:KLG=0:KLB=0:STB=0:SHIELD=0:CREW=357:INJUR=0:MORALE=10:SUPPLIES=100
410 FOR I=1 TO 8:FOR J=1 TO 8
420 KL=-INT(LOG(RND+.000001)*.8+.001):KLG=KLG+KL
430 KB=FNSETUP(.94):KLB=KLB+KB
440 SB=FNSETUP(.94):STB=STB+SB
450 ST=FNCOOR
460 BH=FNSETUP(.96):AS=FNSETUP(.6):PL=FNSETUP(.75)
470 PLANET(I,J,1)=INT(FNUM(10)):PLANET(I,J,2)=INT(FNUM(10)):PLANET(I,J,3)=FNSETUP(.5):PLANET(I,J,4)=FNSETUP(.5)
480 GALAXY(I,J,1)=1000*PL+100*AS+10*BH+ST
490 GALAXY(I,J,2)=100*KL+10*KB+SB
500 NEXT J:NEXT I
510 YEARS=INT(KLG*(1.5+RND*.8)):DATE=100*INT(20+RND*20)
520 IF STB=0 THEN STB=1:I=FNCOOR:J=FNCOOR:GALAXY(I,J,2)=GALAXY(I,J,2)+1
530 IF KLB=0 THEN KLB=1:I=FNCOOR:J=FNCOOR:GALAXY(I,J,2)=GALAXY(I,J,2)+10
540 REM
550 REM-----------------------------------------------------------------------
560 REM
570 REM Confirm configuration with player
580 REM
590 CLS:COLOR 2,4:PRINT"CONFIGURATION":PRINT
600 COLOR 2,0:PRINT "STARDATE ";DATE;"   KLINGONS ";KLG
610 PRINT "KLINGON BASES ";KLB;"    STARBASES ";STB;"   YEARS ";YEARS
620 PRINT "QUADRANT ";QUADX;"-";QUADY;"   SECTOR ";SECX;"-";SECY:PRINT
630 COLOR 4,0:INPUT "DO YOU WANT A DIFFERENT CONFIGURATION Y/N";A$
640 IF A$="Y" THEN GOTO 400 ELSE COLOR 7:CLS
650 REM
660 REM-----------------------------------------------------------------------
670 REM
680 REM  Set up quadrant
690 REM
700 IF QUADX>0 AND QUADX<9 AND QUADY>0 AND QUADY<9 THEN GOTO 760
710 IF QUADX<0 THEN QUADX=0
720 IF QUADX>9 THEN QUADX=9
730 IF QUADY<0 THEN QUADY=0
740 IF QUADY>9 THEN QUADY=9
750 COLOR 20,0:PRINT "YOU ARE OUT OF THE GALAXY IN QUADRANT ";QUADX;"-";QUADY:QUAD1=0:QUAD2=0:GOTO 770
760 QUAD1=GALAXY(QUADX,QUADY,1):QUAD2=GALAXY(QUADX,QUADY,2)
770 SB=FNEXA(QUAD2):KB=FNEXB(QUAD2):KL=FNEXE(QUAD2)
780 ST=FNEXA(QUAD1):BH=FNEXB(QUAD1):AS=FNEXC(QUAD1):PL=FNEXD(QUAD1)
790 FOR I=0 TO 9:FOR J=0 TO 9:QUADRANT(I,J)=0:NEXT:NEXT
800 QUADRANT(SECX,SECY)=300
810 RANDUM=RND:RANDOMIZE(QUAD1):ATTACK=-1
820 IF ST>0 THEN FOR I=1 TO ST:GOSUB 4010:QUADRANT(X,Y)=299:NEXT
830 IF BH>0 THEN GOSUB 4010:QUADRANT(X,Y)=295
840 IF AS>0 THEN GOSUB 4010:QUADRANT(X,Y)=294
850 IF PL>0 THEN GOSUB 4010:QUADRANT(X,Y)=298
860 RANDOMIZE(RANDUM)
870 IF KL>0 THEN FOR I=1 TO KL:GOSUB 4010:QUADRANT(X,Y)=INT(150+RND*70-50*(KB>0)):NEXT
880 IF KB>0 THEN GOSUB 4010:QUADRANT(X,Y)=296
890 IF SB>0 THEN GOSUB 4010:QUADRANT(X,Y)=297
900 ATTACK=-1
910 REM
920 REM----------------------------------------------------------------------
930 REM
940 REM  Short Range Scan
950 REM
960 IF ATTACK THEN GOSUB 3530
970 I=SECX-1:STATU$="GREEN":CL=18:NOB=-1
980 J=SECY-1
990 IF QUADRANT(I,J)=297 THEN STATU$="DOCKED":ENERGY=4000:CL=23:TORPS=15:SHIELD=0:MORALE=10:CREW=CREW+INT(RND*(357-CREW)):INJUR=0:SUPPLIES=100:GOTO 1070
1000 IF QUADRANT(I,J)=298 THEN STATU$="ORBITING":CL=22:NOB=0
1010 IF J<SECY+1 THEN J=J+1:GOTO 990
1020 IF I<SECX+1 THEN I=I+1:GOTO 980
1030 IF ENERGY<1000 OR MORALE<4 OR SUPPLIES<30 THEN STATU$="YELLOW":CL=30
1040 IF KL>0 THEN STATU$="RED":CL=20
1050 IF KB>0 THEN STATU$="ORANGE":CL=21
1060 IF QUADX<1 OR QUADX>8 OR QUADY<1 OR QUADY>8 THEN STATU$="LOST":CL=17
1070 IF DAMAGE(2)>=0 THEN COLOR 7:PRINT "1    2    3    4    5    6    7    8":GOTO 1090
1080 COLOR 20,0:PRINT "** SHORT RANGE SENSORS ARE OUT **":COLOR 7
1090 FOR I=1 TO 8:IF DAMAGE(2)<0 THEN GOTO 1200
1100 FOR J=1 TO 8
1110 PT=QUADRANT(J,I):C$=" ":CO=7
1120 IF PT=300 THEN C$=CHR$(&HE0):CO=18
1130 IF PT=299 THEN C$="*":CO=15
1140 IF PT=298 THEN C$="O":CO=6
1150 IF PT=297 THEN C$=CHR$(&HE4):CO=9
1160 IF PT=296 THEN C$=CHR$(&HEE):CO=12
1170 IF PT=294 THEN C$=CHR$(&HB0):CO=7
1180 IF PT>0 AND PT<290 THEN C$=CHR$(&HE8):CO=4
1190 COLOR CO:PRINT C$;"    ";:NEXT :COLOR 7:PRINT I;" ";
1200 PRINT INFO$(I);" ";
1210 IF I=1 THEN PRINT DATE;"   YEARS ";YEARS
1220 IF I=2 THEN PRINT ENERGY
1230 IF I<>3 THEN GOTO 1250
1240 IF SHIELD THEN PRINT "UP" ELSE PRINT "DOWN"
1250 IF I=4 THEN PRINT TORPS
1260 IF I=5 THEN PRINT KLG
1270 IF I=6 THEN COLOR CL:PRINT STATU$:COLOR 7
1280 IF I=7 THEN PRINT QUADX;"-";QUADY
1290 IF I=8 THEN PRINT SECX;"-";SECY
1300 PRINT :NEXT
1310 REM
1320 REM -------------------------------------------------------------------------
1330 REM
1340 REM  Get a command and process it
1350 REM
1360 IF ATTACK THEN GOSUB 3730
1370 IF ATTACK THEN GOSUB 3800
1380 INPUT "COMMAND ( ENTER H FOR HELP )";CMD$:ATTACK=0:MORALE=MORALE*CREW/(INJ+1)*SUPPLIES/1000:IF MORALE>10 THEN MORALE=10
1390 IF MORALE<3 AND RND>.7 THEN CLS:PRINT "THE CREW REVOLT AGAINST YOUR BAD LEADERSHIP AND JETTISON YOU INTO DEEP SPACE!":END
1400 IF CMD$="H" THEN GOSUB 1480:GOTO 1380
1410 IF CMD$="10" THEN GOSUB 4020:GOTO 1380
1420 IF CMD$="11" THEN GOTO 4650
1430 IF CMD$="12" THEN GOTO 1470
1440 IF CMD$="13" THEN SND=-(SND+1):GOTO 1380
1450 IF VAL(CMD$)<0 OR VAL(CMD$)>255 THEN GOTO 1160
1460 SUPPLIES=SUPPLIES-INT(FNUM((9-VAL(CMD$))/2)):ON VAL(CMD$) GOTO 1620,2700,2330,2470,3160,970,2250,2540,2920:GOSUB 1480:GOTO 1380
1470 CLS:PRINT "THANKS FOR PLAYING, CAPTAIN ";NME$:PRINT "GOODBYE...":END
1480 CLS:PRINT "THE AVAILABLE COMMANDS ARE :":PRINT
1490 PRINT "1 - Move the Enterprise":PRINT "2 - Fire Photon Torpedo"
1500 PRINT "3 - Fire Phasers":PRINT "4 - Raise/Lower Shields"
1510 PRINT "5 - Beam down for supplies":PRINT "6 - Short Range Scan"
1520 PRINT "7 - Long Range Scan":PRINT "8 - Ship Status Report"
1530 PRINT "9 - On-board Computer":PRINT "10 - Instructions"
1540 PRINT "11 - Save/Load Game":PRINT "12 - Flight Operations Stop"
1550 PRINT "13 - Toggle sound on/off"
1560 RETURN
1570 REM
1580 REM-----------------------------------------------------------------------
1590 REM
1600 REM  Move the Enterprise
1610 REM
1620 COLOR 7:PRINT "COURSE";:COLOR 6:INPUT DIR$
1630 DR=((VAL(DIR$)+180)MOD 360)*.0174533
1640 COLOR 7:PRINT "WARP";:COLOR 6:INPUT WRP$
1650 COLOR 7:WRP=VAL(WRP$):IF WRP<=0 THEN GOTO 1380
1660 IF WRP>8 THEN PRINT "WARP VALUES FROM 0.1 TO 8 ONLY!!":GOTO 1640
1670 IF DAMAGE(1)<0 AND WRP>.2 THEN PRINT "ENGINES UNDERGOING REPAIRS - MAX WARP IS 0.2":GOTO 1640
1680 ERQ=5*WRP*WRP-5:IF ENERGY<=ERQ THEN PRINT "INSUFFICIENT ENERGY - MAX WARP IS ";INT(SQR((ENERGY-5)/5)):GOTO 1640
1690 ENERGY=ENERGY-ERQ:FOR I=1 TO 8:DAMAGE(I)=DAMAGE(I)-(DAMAGE(I)<0):NEXT
1700 FOR I=1 TO 8:IF ABS(I-QUADX)<2 THEN GOTO 1780
1710 FOR J=1 TO 8:IF ABS(J-QUADY)<2 THEN GOTO 1770
1720 KLS=FNEXE(GALAXY(I,J,2)):IF KLS=0 THEN GOTO 1770
1730 FOR K=1 TO KLS:IF RND>.6 THEN GOTO 1760
1740 XC=FNCOOR:YC=FNCOOR
1750 GALAXY(XC,YC,2)=GALAXY(XC,YC,2)+100:GALAXY(I,J,2)=GALAXY(I,J,2)-100
1760 NEXT
1770 NEXT
1780 NEXT
1790 WRP=1.25*WRP-.25*INT(WRP):DATE=DATE+1:YEARS=YEARS-1
1800 IF YEARS=0 THEN GOTO 2080
1810 DX=-COS(DR):DY=SIN(DR):GOSUB 3440:I=1
1820 QUADRANT(SECX,SECY)=0
1830 X=SECX:Y=SECY
1840 SECX=SECX+DX:SECY=SECY+DY
1850 IF SECX<.5 OR SECX>=8.5 OR SECY<.5 OR SECY>=8.5 THEN GOTO 1980
1860 IT=QUADRANT(FNR(SECX),FNR(SECY))
1870 IF IT=0 THEN GOTO 1950
1880 IT=IT-292:IF IT<0 THEN IT=1
1890 PRINT SEC$(IT);" AT ";FNR(SECX);"-";FNR(SECY)
1900 IF DAMAGE(2)<0 OR (IT<>2 AND IT<>3 AND IT<>7) THEN GOTO 1940
1910 IF IT=7 THEN COLOR 23:PRINT "*** STAR WENT SUPERNOVA AND DESTROYED ENTERPRISE ***":COLOR 7:GOTO 2080
1920 IF IT=2 THEN I=FNCOOR:DAMAGE(I)=DAMAGE(I)-1:PRINT DAM$(I);" DAMAGED":GOTO 1950
1930 SECX=FNCOOR:SECY=FNCOOR:QUADX=FNCOOR:QUADY=FNCOOR:PRINT "--- ENTERPRISE REAPPEARS IN QUADRANT ";QUADX;"-";QUADY;"  SECTOR ";SECX;"-";SECY:GOTO 700
1940 SECX=FNR(X):SECY=FNR(Y):GOTO 1970
1950 IF I<8*WRP THEN I=I+1:GOTO 1820
1960 SECX=FNR(SECX):SECY=FNR(SECY)
1970 QUADRANT(SECX,SECY)=300:GOTO 900
1980 WRP=WRP-(I-1)/8:ZX=QUADX+(X-.5)/8+WRP*DX:ZY=QUADY+(Y-.5)/8+WRP*DY
1990 QUADX=INT(ZX):IF ZX<0 THEN QUADX=QUADX-1
2000 QUADY=INT(ZY):IF ZY<0 THEN QUADY=QUADY-1
2010 SECX=INT((ZX-QUADX)*8+1):SECY=INT((ZY-QUADY)*8+1)
2020 COLOR 17:PRINT "ENTERPRISE THROUGH QUADRANT....":COLOR 7:GOTO 700
2030 REM
2040 REM------------------------------------------------------------------------
2050 REM
2060 REM   Lose routine
2070 REM
2080 PRINT "IT IS STARDATE ";DATE
2090 PRINT "THE ENTERPRISE HAS BEEN DESTROYED":PRINT "YOU HAVE BEEN MADE AMBASSADOR TO AN OBSCURE PLANET IN THE S-K SYSTEM"
2100 PRINT "THERE ARE STILL ";KLG;" KLINGON BATTLE CRUISERS":IF KLB>0 THEN PRINT "AND ";KLB;" KLINGON BASES"
2110 INPUT"Do you want another game Y/N";A$:IF A$="Y" THEN GOTO 400 ELSE GOTO 1470
2120 REM
2130 REM-----------------------------------------------------------------------
2140 REM
2150 REM   Win routine
2160 REM
2170 PRINT "IT IS STARDATE ";DATE
2180 PRINT "THE LAST KLINGON CRUISER HAS BEEN DESTROYED":IF KLD>0 THEN PRINT "YOU HAVE DESTROYED ";KLD;" KLINGON BASES"
2190 PRINT "YOU HAVE BEEN PROMOTED TO ADMIRAL":GOTO 2110
2200 REM
2210 REM----------------------------------------------------------------------
2220 REM
2230 REM   Long Range scan
2240 REM
2250 INPUT "WHICH QUADRANT ";Q$:QX=VAL(LEFT$(Q$,1)):QY=VAL(RIGHT$(Q$,1))
2260 IF QX>0 AND QX<9 AND QY>0 AND QY<9 THEN GOSUB 3850
2270 GOTO 1380
2280 REM
2290 REM ---------------------------------------------------------------------
2300 REM
2310 REM   Fire Phasers
2320 REM
2330 IF SHIELD THEN PRINT "SHIELD RAISED - PHASERS NOT OPERATIONAL":GOTO 1380
2340 INPUT "ENERGY";EN$:EN=VAL(EN$):IF EN<=0 OR EN>ENERGY OR KL<=0 THEN GOTO 1380
2350 GOSUB 3410
2360 ENERGY=ENERGY-EN:COLOR 3
2370 FOR I=1 TO 8:FOR J=1 TO 8
2380 IT=QUADRANT(I,J):IF IT=0 OR IT>290 THEN GOTO 2410
2390 HT=FNUM(EN):IT=IT-INT(HT):PRINT "KLINGON HIT AT ";I;"-";J
2400 IF IT<=0 THEN PRINT "   **** DESTROYED ****":BEEP:KL=KL-1:KLG=KLG-1:GOSUB 2860:IT=0
2410 QUADRANT(I,J)=IT:NEXT :NEXT :COLOR 7:GOSUB 3530:GOTO 1380
2420 REM
2430 REM----------------------------------------------------------------------
2440 REM
2450 REM  Raise/Lower Shields
2460 REM
2470 SHIELD=-(SHIELD+1):PRINT "SHIELDS ";:IF SHIELD THEN PRINT "RAISED" ELSE PRINT "LOWERED"
2480 GOTO 1380
2490 REM
2500 REM----------------------------------------------------------------------
2510 REM
2520 REM  Ship Status Report
2530 REM
2540 CLS:COLOR 14,4:PRINT "SHIP STATUS":COLOR ,3
2550 PRINT :PRINT "DAMAGE CONTROL":COLOR ,0:PRINT
2560 FOR I=1 TO 8:PRINT DAM$(I);" - ";
2570 IF DAMAGE(I)=0 THEN PRINT "No";:GOTO 2590
2580 IF DAMAGE(I)<-2 THEN PRINT "Heavy"; ELSE PRINT "Light";
2590 PRINT " damage":NEXT:PRINT :PRINT :COLOR ,2
2600 PRINT "PERSONNEL CONTROL":COLOR ,0:PRINT
2610 PRINT CREW;" Able members of crew":PRINT "Supplies are ";:IF SUPPLIES<30 THEN PRINT "low" ELSE IF SUPPLIES<70 THEN PRINT "adequate" ELSE PRINT "good"
2620 PRINT "Morale is ";:IF MORALE<4 THEN PRINT "low" ELSE IF MORALE<7 THEN PRINT "dropping" ELSE PRINT "high"
2630 PRINT :PRINT "Sick bay reports that ";INJUR;" crew members are injured"
2640 COLOR 7,0:GOTO 1380
2650 REM
2660 REM----------------------------------------------------------------------
2670 REM
2680 REM  Fire Photon Torpedo
2690 REM
2700 IF TORPS<0 THEN PRINT "NO TORPEDOES LEFT":GOTO 1380
2710 IF DAMAGE(5)<0 THEN PRINT DAM$(5);" DAMAGED":GOTO 1380
2720 INPUT "COURSE";DR$:DR=((VAL(DR$)+180)MOD 360)*.0174533
2730 DX=-COS(DR):DY=SIN(DR):X=SECX:Y=SECY:TORPS=TORPS-1
2740 COLOR 18:PRINT "TRACK THROUGH SPACE...":COLOR 7:GOSUB 3460
2750 X=X+DX:Y=Y+DY:IF X<.5 OR Y<.5 OR X>=8.5 OR Y>=8.5 THEN PRINT "** MISSED **":GOSUB 3530:GOTO 1380
2760 XX=FNR(X):YY=FNR(Y):PRINT XX;"-";YY
2770 IT=QUADRANT(XX,YY):IF IT=0 OR IT=300 THEN GOTO 2750
2780 COLOR 28:IF IT=299 THEN ST=ST-1
2790 IF IT=298 THEN PL=0
2800 IF IT=297 THEN SB=0:STB=STB-1
2810 IF IT=296 THEN KB=0:KLB=KLB-1:KLD=KLD+1
2820 IF IT=294 THEN AS=0
2830 IF IT<290 THEN KL=KL-1:KLG=KLG-1:IT=293
2840 PRINT SEC$(IT-292):IF IT<>295 THEN PRINT " DESTROYED":QUADRANT(XX,YY)=0
2850 GOSUB 2860:COLOR 7,0:GOTO 1360
2860 GALAXY(QUADX,QUADY,2)=SB+10*KB+100*KL:GALAXY(QUADX,QUADY,1)=1000*PL+100*AS+10*BH+ST:IF KLG<=0 THEN GOTO 2170 ELSE RETURN
2870 REM
2880 REM----------------------------------------------------------------------
2890 REM
2900 REM  On-board Computer Info
2910 REM
2920 CLS:COLOR 5:PRINT "COMPUTER ACTIVATED":COLOR 7:QX=QUADX:QY=QUADY:PRINT
2930 FOR I=1 TO 8:FOR J=1 TO 8:IF FNEXA(GALAXY(I,J,2))>0 THEN PRINT "STARBASE AT ";I;"-";J
2940 NEXT:NEXT:PRINT
2950 GOSUB 3850
2960 IF FNEXD(GALAXY(QX,QY,1))=0 THEN GOTO 2990
2970 PRINT "THE PLANET ";PLAN$(PLANET(QX,QY,1));"-";PLBN$(PLANET(QX,QY,2));" IS ";
2980 IF PLANET(QX,QY,3) THEN PRINT "UNEXPLORED" ELSE IF PLANET(QX,QY,4) THEN PRINT "HOSTILE" ELSE PRINT "FRIENDLY"
2990 IF QX<>QUADX OR QY<>QUADY THEN GOTO 3100
3000 PRINT :PRINT "TORPEDO ANGLES":PRINT
3010 I=1
3020 J=1
3030 IT=QUADRANT(I,J):IF IT=0 OR IT>290 THEN GOTO 3080
3040 DX=SECX-I:DY=SECY-J:IF DX=0 THEN IF DY>0 THEN THETA=90 ELSE THETA=270:GOTO 3070
3050 THETA=57.29578*ATN(DY/DX)
3060 IF DX<0 THEN THETA=(360-THETA) MOD 360 ELSE THETA=180-THETA
3070 PRINT "KLINGON AT ";I;"-";J;" IS AT ANGLE ";INT(THETA)
3080 IF J<8 THEN J=J+1:GOTO 3030
3090 IF I<8 THEN I=I+1:GOTO 3020
3100 GOTO 1360
3110 REM
3120 REM-----------------------------------------------------------------------
3130 REM
3140 REM  Beam down for supplies
3150 REM
3160 IF NOB THEN PRINT "ENTERPRISE NOT IN ORBIT":GOTO 1380
3170 INPUT "HOW MANY CREW MEMBERS";BM$:BM=VAL(BM$):IF BM<=0 THEN GOTO 1380
3180 PRINT "LOCKING COORDINATES WITH ";PLAN$(PLANET(QUADX,QUADY,1));"-";PLBN$(PLANET(QUADX,QUADY,2)):FOR I=0 TO 999:NEXT:PRINT "BEAMING...":GOSUB 3370:CREW=CREW-BM
3190 FOR I=0 TO 999:NEXT
3200 PLANET(QUADX,QUADY,3)=0:IF PLANET(QUADX,QUADY,4) THEN PRINT "THE PLANET IS HOSTILE" ELSE GOTO 3220
3210 RTN=INT(FNUM(BM)):GOTO 3230
3220 RTN=BM
3230 GSUP=10*RND*RTN-BM:GOSUB 3370
3240 IF GSUP<0 THEN GSUP=0
3250 IF GSUP+SUPPLIES>100 THEN GSUP=100-SUPPLIES
3260 IF RTN=BM THEN PRINT "ALL";:GOTO 3290
3270 IF RTN=0 THEN PRINT "NO";:GOTO 3290
3280 PRINT RTN;
3290 PRINT " CREW MEMBERS RETURN"
3300 IF GSUP>0 THEN PRINT " WITH SUPPLIES":SUPPLIES=SUPPLIES+GSUP
3310 CREW=CREW+RTN:GOTO 1360
3320 REM
3330 REM----------------------------------------------------------------------
3340 REM
3350 REM  Sound Effects
3360 REM
3370 IF SND THEN FOR I=1 TO 3:SOUND 523,3:SOUND 8000,10:NEXT 'Beaming sound
3380 RETURN
3390 IF SND THEN FOR J=1 TO 3:FOR I=1500 TO 2500 STEP 50:SOUND I,1:NEXT:NEXT 'Siren
3400 RETURN
3410 IF NOT(SND) THEN RETURN
3420 I=8000:DCC=200
3430 SOUND I,1:I=I-DCC:DCC=DCC+2:IF I>4000 THEN GOTO 3430 ELSE RETURN 'Phaser
3440 IF SND THEN FOR I=1 TO 50:SOUND(37+RND*15),1:NEXT 'Move
3450 RETURN
3460 IF SND THEN FOR I=1 TO 3:SOUND 523,3:SOUND 8000,10:NEXT
3470 RETURN
3480 REM
3490 REM---------------------------------------------------------------------
3500 REM
3510 REM  Klingon Attack routine
3520 REM
3530 IF KL<=0 THEN RETURN
3540 PRINT "KLINGON ATTACK !!!!!!!!!!!":GOSUB 3390
3550 I=1
3560 J=1
3570 IT=QUADRANT(I,J)
3580 IF IT>290 OR IT=0 THEN GOTO 3650
3590 HIT=INT(FNUM(IT)):QUADRANT(I,J)=IT-HIT:IF QUADRANT(I,J)<=0 THEN QUADRANT(I,J)=0:KL=KL-1:KLG=KLG-1
3600 IF KB>0 THEN HIT=HIT+INT(FNUM(100))
3610 IF SHIELD THEN HIT=FNUM(HIT*.8)+HIT*.2
3620 ENERGY=ENERGY-HIT:COLOR 14:INJ=INT(RND*HIT*CREW/ENERGY/2):CREW=CREW-INJ:INJUR=INJUR+INJ
3630 PRINT "ENTERPRISE HIT BY KLINGON AT ";I;"-";J;"   ENERGY DRAIN ";HIT;"   INJURIES ";INJ
3640 IF ENERGY<0 THEN GOTO 2080
3650 IF J<8 THEN J=J+1:GOTO 3570
3660 IF I<8 THEN I=I+1:GOTO 3560
3670 COLOR 7,0:RETURN
3680 REM
3690 REM----------------------------------------------------------------------
3700 REM
3710 REM   Meteor shower, truce and subspace radio routines
3720 REM
3730 IF RND>.3 THEN RETURN ELSE COLOR 9
3740 IT=FNCOOR:IF DAMAGE(IT)<0 OR RND>.67 THEN GOTO 3760
3750 PRINT "METEOR SHOWER - ";DAM$(IT);" DAMAGED":DAMAGE(IT)=DAMAGE(IT)-INT(FNUM(5)):GOTO 3790
3760 IT=1
3770 IF DAMAGE(IT)=0 AND IT<8 THEN IT=IT+1:GOTO 3770
3780 IF DAMAGE(IT)<0 THEN PRINT "TRUCE - ";DAM$(IT);" REPAIRED":DAMAGE(IT)=0
3790 COLOR 7:RETURN
3800 IF DAMAGE(6)<0 OR SHIELD OR RND>.6 THEN RETURN
3810 QX=FNCOOR:IF ABS(QX-QUADX)<2 THEN GOTO 3810
3820 QY=FNCOOR:IF ABS(QY-QUADY)<2 THEN GOTO 3820
3830 COLOR 31:PRINT "SUBSPACE RADIO MESSAGE":COLOR 4
3840 GOSUB 3850:COLOR 7:RETURN
3850 PRINT "STATUS OF QUADRANT ";QX;"-";QY;" IS "
3860 I1=GALAXY(QX,QY,1):I2=GALAXY(QX,QY,2)
3870 II=1:TT=FNEXE(I2):GOSUB 3880:TT=FNEXC(I1):GOSUB 3880:TT=FNEXB(I1):GOSUB 3880:TT=FNEXB(I2):GOSUB 3880:TT=FNEXA(I2):GOSUB 3880:TT=FNEXD(I1):GOSUB 3880:TT=FNEXA(I1):GOSUB 3880:RETURN
3880 IF TT>0 THEN PRINT TT;" ";SEC$(II);:IF TT>1 THEN PRINT "S" ELSE PRINT
3890 II=II+1:RETURN
3900 REM
3910 REM----------------------------------------------------------------------
3920 REM
3930 REM   Greeting and Instructions
3940 REM
3950 CLS:INPUT "PLEASE ENTER YOUR FULL NAME";NME$:CLS
3960 FOR I=0 TO 999:NEXT
3970 PRINT "GREETINGS, CAPTAIN ";NME$;", FROM FEDERATION HEADQUARTERS":PRINT
3980 PRINT "YOU HAVE BEEN CHOSEN TO LEAD THE STARSHIP U.S.S ENTERPRISE ON ITS MISSION"
3990 PRINT "TO RID THE GALAXY OF THE EVIL KLINGON MENACE.":PRINT :INPUT "BEFORE YOU BEGIN, WOULD YOU LIKE INSTRUCTIONS";A$:IF A$="Y" THEN GOSUB 4020
4000 RETURN
4010 X=FNCOOR:Y=FNCOOR:IF QUADRANT(X,Y)<>0 THEN GOTO 4010 ELSE RETURN
4020 CLS
4030 COLOR 4:PRINT "STAR TREK":PRINT "==== ====":COLOR 7:PRINT
4040 PRINT "As Commander of the United Starship ENTERPRISE, your mission is to rid the":PRINT "galaxy of the deadly Klingon menace. To accomplish this, you must explore the"
4050 PRINT "galaxy, destroying the invading Klingon battle cruisers wherever possible.":PRINT "You have a limited amount of time to complete your mission.":PRINT "The universe is an 8 by 8 square of 64 quadrants, each quadrant being divided"
4060 PRINT "into 64 sectors. Note that if the Enterprise leaves a quadrant without first":PRINT "destroying the Klingon cruisers in that quadrant, the Klingons will have their"
4070 PRINT "energy replenished to the full value.":PRINT "Aside from the Enterprise and the Klingon cruisers, there are also six"
4080 PRINT "other things scattered around the universe. These are stars, asteroids,":PRINT "Klingon bases, Federation Starbases, planets and black holes (which are"
4090 PRINT "invisible). Klingons in the same quadrant as a Klingon base are more powerful":PRINT "than usual."
4100 PRINT "If the Enterprise moves into a sector adjacent to a Federation Starbase, it is":PRINT "docked, and is replenished with energy, food and possibly crew. Supplies can"
4110 PRINT "also be fetched by orbiting (ie, moving adjacent to) a planet and beaming down":PRINT "crew members. However, if the planet is hostile, the crew members may never be"
4120 PRINT "seen again, and morale on the ship will drop. If the Enterprise accidentally":PRINT "enters a black hole, it will go through a spacetime warp and reappear somewhere"
4130 PRINT "else in the galaxy. If the Enterprise hits a star, it will be destroyed.":COLOR 5:INPUT "MORE INSTRUCTIONS Y/N";A$:COLOR 7
4140 IF A$="N" THEN RETURN
4150 GOSUB 1480:PRINT :COLOR 5:INPUT"MORE INSTRUCTIONS Y/N";A$:COLOR 7:IF A$="N" THEN RETURN
4160 CLS:COLOR 4:PRINT "MOVING THE ENTERPRISE":COLOR 7:PRINT
4170 PRINT "To move the Enterprise, a course direction in degrees must be given and a warp":PRINT "factor specified. Directions are, for example :":PRINT
4180 PRINT "   0  Right":PRINT "  90  Up":PRINT " 180  Left":PRINT " 270  Down":PRINT
4190 PRINT "Warp factors specify the distance moved. The integer part is the number of":PRINT "quadrants to be moved, and the fractional part the number of sectors. Thus, for"
4200 PRINT "example, a warp of 0.3 will move the Enterprise 3 sectors, while a warp of 2":PRINT "will move it 2 quadrants. Each move uses up one Stardate, and also allows some"
4210 PRINT "repairs to be carried out on damaged equipment. Entering a negative warp will":PRINT "cancel the move command.":PRINT "Care should be taken when moving, as moving into the same sector as a star will"
4220 PRINT "destroy the Enterprise, while an asteroid causes damage.":PRINT :COLOR 5:INPUT "MORE INSTRUCTIONS Y/N";A$:IF A$="N" THEN RETURN
4230 CLS:COLOR 4:PRINT "PHOTON TORPEDOES":COLOR 7:PRINT
4240 PRINT "The Enterprise is equipped with up to 15 Photon Torpedoes. When a torpedo is":PRINT "fired, its course must be specified as for moving the Enterprise. The torpedo"
4250 PRINT "will move through the quadrant, and destroy whatever it hits first, if anything.":PRINT "Once the torpedo reaches the edge of the quadrant, it is no longer effective.":PRINT
4260 PRINT "Torpedo courses can be found by consulting the on-board computer, and more":PRINT "can be aquired by docking the Enterprise at a Starbase.":PRINT
4270 COLOR 5:INPUT "MORE INSTRUCTIONS Y/N";A$:IF A$="N" THEN RETURN
4280 CLS:COLOR 4:PRINT "PHASERS":COLOR 7:PRINT
4290 PRINT "Any part of the Enterprise's energy can be fired by the phasers. Phasers affect":PRINT "only Klingon cruisers, the effect being bigger the greater the energy and"
4300 PRINT "closer the Klingon. Phasers cannot be fired when the shields are raised.":PRINT
4310 PRINT "The phasers have the effect of draining the energy of the Klingons and thus":PRINT "weakening them, possibly enough to destroy them. Even if a cruiser is not"
4320 PRINT "destroyed, it will have less energy available for attacking the Enterprise.":PRINT :COLOR 5:INPUT "MORE INSTRUCTIONS Y/N";A$:COLOR 7:IF A$="N" THEN RETURN
4330 CLS:COLOR 4:PRINT "SHIELDS":COLOR 7:PRINT
4340 PRINT "The Enterprise's shields can be used to minimise the effect of Klingon attacks":PRINT "by deflecting some of the Klingon phaser energy. However, when the shields are"
4350 PRINT "raised, the subspace radio, phasers and teleporter are disabled.":PRINT :COLOR 5:INPUT "MORE INSTRUCTIONS Y/N";A$:IF A$="N" THEN RETURN
4360 CLS:COLOR 4:PRINT "TELEPORTER":COLOR 7:PRINT
4370 PRINT "When supplies are low, there are two ways in which more can be obtained- either":PRINT "by docking the Enterprise at a Starbase, or by beaming down crew to a planet."
4380 PRINT "To beam down crew, the Enterprise must be in orbit about the planet and the":PRINT "shields must be lowered. Planets may be either friendly or hostile - it is"
4390 PRINT "often possible to find out which by consulting the on-board computer. However,":PRINT "some planets are unexplored, and thus their nature is unknown until actually"
4400 PRINT "beaming down.":PRINT :PRINT "If the planet is hostile, not all of the crew may return alive...":PRINT :COLOR 5:INPUT "MORE INSTRUCTIONS Y/N";A$:IF A$="N" THEN RETURN
4410 CLS:COLOR 4:PRINT "SHORT RANGE SCAN":COLOR 7:PRINT
4420 PRINT "A short range scan provides information both about the status of the Enterprise":PRINT "and about the current quadrant. The symbols used to represent the items are:":PRINT
4430 COLOR 18:PRINT "   ";CHR$(&HE0);:COLOR 7:PRINT " - Enterprise"
4440 COLOR 15:PRINT "   *";:COLOR 7:PRINT " - Star"
4450 COLOR 6:PRINT "   O";:COLOR 7:PRINT " - Planet"
4460 COLOR 9:PRINT "   ";CHR$(&HE4);:COLOR 7:PRINT " - Starbase"
4470 COLOR 12:PRINT "   ";CHR$(&HEE);:COLOR 7:PRINT " - Klingon base"
4480 COLOR 7:PRINT "   ";CHR$(&HB0);:COLOR 7:PRINT " - Asteroid"
4490 COLOR 4:PRINT "   ";CHR$(&HE8);:COLOR 7:PRINT " - Klingon cruiser"
4500 PRINT :PRINT "Black holes are invisible and cannot be detected by the short range scanner.":PRINT :COLOR 5:INPUT "MORE INSTRUCTIONS Y/N";A$:IF A$="N" THEN RETURN
4510 CLS:COLOR 4:PRINT "LONG RANGE SCAN":COLOR 7:PRINT
4520 PRINT "The long range scanner provides information about any quadrant in the galaxy.":PRINT "The desired quadrant must be specified, in any of several forms."
4530 PRINT "For example, 2-3  23   2,3   2 3  are all equivalent ways of specifying quadrant":PRINT "2-3.":PRINT :COLOR 5:INPUT "MORE INSTRUCTIONS Y/N";A$:COLOR 7:IF A$="N" THEN RETURN
4540 CLS:COLOR 4:PRINT "GENERAL":COLOR 7:PRINT
4550 PRINT "A typical game can take quite a long time. Thus it is possible to save your":PRINT "game on disc and reload it at a later time ( command 11 ). In both cases, you"
4560 PRINT "must specify the name of the file in which the game details are to be saved or":PRINT "from which they are to be loaded. The game sound effects can be switched on or"
4570 PRINT "off by command 13. To end a game, command 12 can be used. If you wish to review":PRINT "these instructions at any time, use command 10.":PRINT :PRINT
4580 COLOR 3:PRINT "Good luck on your mission!":COLOR 5:PRINT
4590 INPUT "Press RETURN to continue";A$:COLOR 7:RETURN
4600 REM
4610 REM------------------------------------------------------------------------
4620 REM
4630 REM   Load/Save Game on Disc
4640 REM
4650 CLS:INPUT "LOAD OR SAVE GAME (L/S)";A$
4660 INPUT "WHAT IS THE NAME OF THE FILE";P$:N$=P$+".TRK"
4670 IF A$="L" THEN GOTO 4730
4680 OPEN N$ FOR OUTPUT AS 1
4690 PRINT #1,ENERGY;TORPS;QUADX;QUADY;SECX;SECY;KLG;KLB;STB;SHIELD;CREW;INJUR;MORALE;SUPPLIES;YEARS;DATE;
4700 FOR I=1 TO 8:PRINT #1,DAMAGE(I);
4710 FOR J=1 TO 8:PRINT #1,GALAXY(I,J,1);GALAXY(I,J,2);PLANET(I,J,1);PLANET(I,J,2);PLANET(I,J,3);PLANET(I,J,4);
4720 NEXT:NEXT:GOTO 4780
4730 OPEN N$ FOR INPUT AS 1
4740 INPUT #1,ENERGY,TORPS,QUADX,QUADY,SECX,SECY,KLG,KLB,STB,SHIELD,CREW,INJUR,MORALE,SUPPLIES,YEARS,DATE
4750 FOR I=1 TO 8:INPUT #1,DAMAGE(I)
4760 FOR J=1 TO 8:INPUT #1,GALAXY(I,J,1),GALAXY(I,J,2),PLANET(I,J,1),PLANET(I,J,2),PLANET(I,J,3),PLANET(I,J,4)
4770 NEXT :NEXT
4780 CLOSE 1:IF A$="L" THEN GOTO 700 ELSE GOTO 1380
4790 REM
4800 REM **************************************************************************************************************
