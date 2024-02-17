RCQCAL for MVS3.8J / Hercules                                               
=============================                                               


Date: 10/01/2022  Release V0R9M01
      03/30/2022  Release V0R9M00  **INITIAL software distribution

*  Author:  Larry Belmontes Jr.
*           https://ShareABitofIT.net/RCQCAL-in-MVS38J
*           Copyright (C) 2022  Larry Belmontes, Jr.


---------------------------------------------------------------------- 
|    RCQCAL       I n s t a l l a t i o n   R e f e r e n c e        | 
---------------------------------------------------------------------- 

   The approach for this installation procedure is to transfer the
distribution content from your personal computing device to MVS with
minimal JCL and to continue the installation procedure using supplied
JCL from the MVS CNTL data set under TSO.                         

   Below are descriptions of ZIP file content, pre-installation
requirements (notes, credits) and installation steps.
 
Thanks!
-Larry Belmontes



---------------------------------------------------------------------- 
|    RCQCAL       C h a n g e   H i s t o r y                        | 
---------------------------------------------------------------------- 
*  MM/DD/CCYY Version  Name / Description                                       
*  ---------- -------  -----------------------------------------------          
*  10/01/2022 0.9.01   Larry Belmontes Jr.                                      
*                      - Added starting julian date to each month   
*                        displayed on calendar
*
*  03/30/2022 0.9.00   Larry Belmontes Jr.                                      
*                      - Retrofitted version of CBT File#182 RCQDATE
*                        application from Michael Theys for MVS 3.8J
*                        and ISPF v2.2.0.                 
*                      - Released to MVS 3.8J hobbyist public domain
*
======================================================================
* I. C o n t e n t   o f   Z I P   F i l e                           |
======================================================================

o  $INST00.JCL          Define Alias for HLQ RCQCAL in Master Catalog
 
o  $INST01.JCL          Load CNTL data set from distribution tape
 
o  $RECVXMI.JCL         Receive XMI SEQ to MVS PDSs                  
 
o  RCQCAL.V0R9M01.HET   Hercules Emulated Tape (HET) multi-file volume
                        with VOLSER of VS0901 containing software
                        distribution.
 
o  RCQCAL.V0R9M01.XMI   XMIT file containing software distribution.   
 
o  DSCLAIMR.TXT         Disclaimer
 
o  PREREQS.TXT          Required user-mods 
 
o  README.TXT           This File                                              
 
 
Note:   ISPF v2.2 or higher must be installed under MVS3.8J TSO             
-----   including associated user-mods per ISPF Installation Pre-reqs.
 
Note:   Two user-mods, ZP60014 and ZP60038, are REQUIRED to process
-----   CLIST symbolic variables via the IKJCT441 API on MVS 3.8J before
        using RCQCAL.
        More information at:
        http://www.prycroft6.com.au/vs2mods/
 
Note:   RCQDATE displays a perpetual calendar using an ISPF dialogue. 
-----   A retrofitted version is included which executes under MVS 3.8J
        and ISPF v2.2
 
Credit  The original RCQDATE is authored by Michael Theys from Rockwell
------  International and associated components are contained in this
        software distribution.
 
        Additionally, RCQDATE components are contained in CBT FIle#182,
        the PDS Command package, and can be downloaded from the following
        website:
        https://www.cbttape.org/cbtdowns.htm  as CBT182
 
 
 
 
======================================================================
* II. P r e - i n s t a l l a t i o n   R e q u i r e m e n t s      |
======================================================================

o  The Master Catalog password may be required for some installation
   steps. 
 
o  Tape files use device 480.
 
o  As default, DASD files will be loaded to VOLSER=MVSDLB, type 3350 device.
    
   Below is a DATASET List after tape distribution load for reference purposes:
    
   DATA-SET-NAME------------------------------- VOLUME ALTRK USTRK ORG FRMT % XT
   RCQCAL.V0R9M01.ASM                           MVSDLB     5     1 PO  FB  20  1
   RCQCAL.V0R9M01.CLIST                         MVSDLB     2     1 PO  FB  50  1
   RCQCAL.V0R9M01.CNTL                          MVSDLB    20     7 PO  FB  35  1
   RCQCAL.V0R9M01.HELP                          MVSDLB     2     1 PO  FB  50  1
   RCQCAL.V0R9M01.ISPF                          MVSDLB    20     6 PO  FB  30  1
   RCQCAL.V0R9M01.MACLIB                        MVSDLB     2     1 PO  FB  50  1
   **END**    TOTALS:      51 TRKS ALLOC        17 TRKS USED       6 EXTENTS    
    
    
   Confirm the TOTAL track allocation is available on MVSDLB.                 
    
   Note: A different DASD device type may be used to yield
         different usage results.
 
o  TSO user-id with sufficient access rights to update SYS2.CMDPROC,  
   SYS2.CMDLIB, SYS2.HELP, SYS2.LINKLIB and/or ISPF libraries.
 
o  For installations with a security system (e.g. RAKF), you MAY need to
   insert additional JOB statement information.
    
   //         USER=???????,PASSWORD=????????
 
o  Names of ISPCLIB (Clist), ISPMLIB (Message), ISPLLIB (Load) and/or 
   ISPPLIB (Panel) libraries.
 
o  Download ZIP file to your PC local drive.    
 
o  Unzip the downloaded file into a temp directory on your PC device.
  
o  Install pre-requisite (if any) software and/or user modifications.
  
 
                                                
======================================================================
* III. I n s t a l l a t i o n   S t e p s                           |
======================================================================
                                                
+--------------------------------------------------------------------+
| Step 1. Define Alias for HLQ RCQCAL in MVS User Catalog            |
+--------------------------------------------------------------------+
|         JCL Member: RCQCAL.V0R9M01.CNTL($INST00)                   |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//RCQCAL00 JOB (SYS),'Def RCQCAL Alias',     <-- Review and Modify 
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  RCQCAL for MVS3.8J TSO / Hercules                   *
//* *  JOB: $INST00  Define Alias for HLQ RCQCAL           *
//* *  Note: The master catalog password will be required  *
//* -------------------------------------------------------*
//DEFALIAS EXEC PGM=IDCAMS 
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
 PARM GRAPHICS(CHAIN(SN))
 LISTCAT ALIAS  ENT(RCQCAL) 
 IF LASTCC NE 0 THEN -
    DEFINE ALIAS(NAME(RCQCAL) RELATE(SYS1.UCAT.MVS))                          
/*                                                                      
//
______________________________________________________________________
Figure 1: $INST00 JCL
 
 
    a) Copy and paste the above JCL to a PDS member, update JOB 
       statement to conform to your installation standard.             
 
    b) Submit the job.                                  
 
    c) Review job output for successful DEFINE ALIAS.
 
    Note: When $INST00 runs for the first time,
          Job step DEFALIAS returns RC=0004 due to LISTCAT ALIAS function
          completing with condition code of 4 and DEFINE ALIAS function 
          completing with condition code of 0.
           
    Note: When $INST00 runs after the ALIAS is defined,
          Job step DEFALIAS returns RC=0000 due to LISTCAT ALIAS function
          completing with condition code of 0 and DEFINE ALIAS 
          function being bypassed.
           
 
+--------------------------------------------------------------------+
| Step 2. Determine software installation source                     |
+--------------------------------------------------------------------+
|         HET or XMI ?                                               |
+--------------------------------------------------------------------+
 
 
    a) Software can be installed from two sources, HET or XMI.    
          
       - For tape installation (HET), proceed to STEP 4. ****     
          
         or
          
       - For XMIT installation (XMI), proceed to next STEP.     
 
 
+--------------------------------------------------------------------+
| Step 3. Load XMIPDS data set from XMI SEQ file                     |
+--------------------------------------------------------------------+
|         JCL Member: RCQCAL.V0R9M01.CNTL($RECVXMI)                  |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//RECV000A JOB (SYS),'Receive RCQCAL XMI',        <-- Review and Modify
//             CLASS=A,MSGCLASS=X,REGION=0M,     <-- Review and Modify
//             MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  JOB: $RECVXMI  Receive Application XMI Files        *
//* -------------------------------------------------------*
//RECV     PROC HLQ=RCQCAL,VRM=V0R9M01,TYP=XXXXXXXX,
//             DSPACE='(TRK,(10,05,40))',DDISP='(,CATLG,DELETE)',
//             DUNIT=3350,DVOLSER=MVSDLB         <-- Review and Modify
//*
//RECV370  EXEC PGM=RECV370
//STEPLIB  DD  DSN=SYS2.LINKLIB,DISP=SHR         <-- Review and Modify
//RECVLOG  DD  SYSOUT=*
//XMITIN   DD  DISP=SHR,DSN=&&XMIPDS(&TYP)
//SYSPRINT DD  SYSOUT=*
//SYSUT1   DD  DSN=&&SYSUT1,
//   UNIT=SYSALLDA,SPACE=(CYL,(10,05)),DISP=(,DELETE,DELETE) 
//SYSUT2   DD  DSN=&HLQ..&VRM..&TYP,DISP=&DDISP,
//   UNIT=&DUNIT,SPACE=&DSPACE,VOL=SER=&DVOLSER
//SYSIN    DD  DUMMY
//SYSUDUMP DD  SYSOUT=*
//         PEND
//* RECEIVE XMIPDS TEMP                                       
//XMIPDS   EXEC RECV,TYP=XMIPDS,DSPACE='(CYL,(10,05,10),RLSE)' 
//RECV370.XMITIN DD  DISP=SHR,DSN=your.transfer.xmi    <-- XMI File 
//RECV370.SYSUT2   DD  DSN=&&XMIPDS,DISP=(,PASS), 
//   UNIT=SYSDA,SPACE=&DSPACE
//* RECEIVE CNTL, HELP, CLIST, ISPF, ASM, MACLIB
//CNTL     EXEC RECV,TYP=CNTL,DSPACE='(TRK,(20,10,10))'
//HELP     EXEC RECV,TYP=HELP,DSPACE='(TRK,(02,02,02))'
//CLIST    EXEC RECV,TYP=CLIST,DSPACE='(TRK,(02,02,02))'
//ISPF     EXEC RECV,TYP=ISPF,DSPACE='(TRK,(20,05,10))'
//ASM      EXEC RECV,TYP=ASM,DSPACE='(TRK,(05,10,10))'
//MACLIB   EXEC RECV,TYP=MACLIB,DSPACE='(TRK,(02,02,02))'
//
______________________________________________________________________
Figure 2: $RECVXMI.JCL
 
 
    a) Transfer RCQCAL.V0R9M01.XMI to MVS using your 3270 emulator.
       
       Make note of the DSN assigned on MVS transfer.       
       
       Use transfer IND$FILE options:                   
       
          NEW BLKSIZE=3200 LRECL=80 RECFM=FB     
             
       Ensure the DSN on MVS exists with the correct DCB information:
       
          ORG=PS BLKSIZE=3200 LRECL=80 RECFM=FB     
       
          
    b) Copy and paste the above JCL to a PDS member, update JOB 
       statement to conform to your installation standard.
 
       Review JCL and apply any modifications per your installation 
       including the DSN assigned during the transfer above for
       the XMI file.
 
    d) Submit the job.                                              
 
    e) Review job output for successful load of the following PDSs:
 
       RCQCAL.V0R9M01.ASM   
       RCQCAL.V0R9M01.CLIST 
       RCQCAL.V0R9M01.CNTL  
       RCQCAL.V0R9M01.HELP  
       RCQCAL.V0R9M01.ISPF  
       RCQCAL.V0R9M01.MACLIB
 
    f) Subsequent installation steps will be submitted from members
       contained in the CNTL data set.
 
    g) Proceed to STEP 6.   ****
 
           
+--------------------------------------------------------------------+
| Step 4. Load CNTL data set from distribution tape                  |
+--------------------------------------------------------------------+
|         JCL Member: RCQCAL.V0R9M01.CNTL($INST01)                   |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//RCQCAL01 JOB (SYS),'Install CNTL PDS',     <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  RCQCAL for MVS3.8J TSO / Hercules                   *
//* *  JOB: $INST01  Load CNTL PDS from distribution tape  *
//* *  Note: Uses tape drive 480                           *
//* -------------------------------------------------------*
//LOADCNTL PROC HLQ=RCQCAL,VRM=V0R9M01,TVOLSER=VS0901,      
//   TUNIT=480,DVOLSER=MVSDLB,DUNIT=3350     <-- Review and Modify
//LOAD001  EXEC PGM=IEBCOPY                                           
//SYSPRINT DD  SYSOUT=*                                              
//INCNTL   DD  DSN=&HLQ..&VRM..CNTL.TAPE,UNIT=&TUNIT,
//             VOL=SER=&TVOLSER,DISP=OLD,LABEL=(1,SL)                 
//CNTL     DD  DSN=&HLQ..&VRM..CNTL,
//             UNIT=&DUNIT,VOL=SER=&DVOLSER,
//             SPACE=(TRK,(20,10,10)),DISP=(,CATLG),
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=3600) 
//         PEND                                                     
//STEP001  EXEC LOADCNTL                     Load CNTL PDS
//SYSIN    DD  *                                                        
    COPY INDD=INCNTL,OUTDD=CNTL 
//                                                                  
______________________________________________________________________
Figure 3: $INST01 JCL
 
 
    a) Before submitting the above job, the distribution tape   
       must be made available to MVS by issuing the following
       command from the Hercules console:
 
       DEVINIT 480 X:\dirname\RCQCAL.V0R9M01.HET READONLY=1
 
       where X:\dirname is the complete path to the location
       of the Hercules Emulated Tape file. 
 
    b) Issue the following command from the MVS console to vary
       device 480 online:
 
       V 480,ONLINE
 
    c) Copy and paste the above JCL to a PDS member, update JOB 
       statement to conform to your installation standard.
 
       Review JCL and apply any modifications per your installation.
 
    d) Submit the job.                                              
 
    e) Review job output for successful load of the CNTL data set.
 
    f) Subsequent installation steps will be submitted from members
       contained in the CNTL data set.
 
 
+--------------------------------------------------------------------+
| Step 5. Load Other data sets from distribution tape                |
+--------------------------------------------------------------------+
|         JCL Member: RCQCAL.V0R9M01.CNTL($INST02)                   |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//RCQCAL02 JOB (SYS),'Install Other PDSs',   <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  RCQCAL for MVS3.8J TSO / Hercules                   *
//* *  JOB: $INST02  Load other PDS from distribution tape *
//* *  Tape Volume:  File 1 - CNTL                         *
//* *                File 2 - CLIST                        *
//* *                File 3 - HELP                         *
//* *                File 4 - ISPF                         *
//* *                File 5 - ASM                          *
//* *                File 6 - MACLIB                       *
//* *  Note: Default TAPE=480, DASD=3350 on MVSDLB         *
//* -------------------------------------------------------*
//LOADOTHR PROC HLQ=RCQCAL,VRM=V0R9M01,TVOLSER=VS0901,            
//   TUNIT=480,DVOLSER=MVSDLB,DUNIT=3350     <-- Review and Modify
//LOAD02   EXEC PGM=IEBCOPY                                           
//SYSPRINT DD  SYSOUT=*                                              
//INCLIST  DD  DSN=&HLQ..&VRM..CLIST.TAPE,UNIT=&TUNIT,
//             VOL=SER=&TVOLSER,DISP=OLD,LABEL=(2,SL)                   
//INHELP   DD  DSN=&HLQ..&VRM..HELP.TAPE,UNIT=&TUNIT,
//             VOL=SER=&TVOLSER,DISP=OLD,LABEL=(3,SL)                   
//INISPF   DD  DSN=&HLQ..&VRM..ISPF.TAPE,UNIT=&TUNIT,
//             VOL=SER=&TVOLSER,DISP=OLD,LABEL=(4,SL)                   
//INASM    DD  DSN=&HLQ..&VRM..ASM.TAPE,UNIT=&TUNIT,
//             VOL=SER=&TVOLSER,DISP=OLD,LABEL=(5,SL)                   
//INMACLIB DD  DSN=&HLQ..&VRM..MACLIB.TAPE,UNIT=&TUNIT,
//             VOL=SER=&TVOLSER,DISP=OLD,LABEL=(6,SL)   
//CLIST    DD  DSN=&HLQ..&VRM..CLIST,UNIT=&DUNIT,VOL=SER=&DVOLSER,
//             SPACE=(TRK,(02,02,02)),DISP=(,CATLG),
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=3600) 
//HELP     DD  DSN=&HLQ..&VRM..HELP,UNIT=&DUNIT,VOL=SER=&DVOLSER,
//             SPACE=(TRK,(02,02,02)),DISP=(,CATLG),
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=3600) 
//ISPF     DD  DSN=&HLQ..&VRM..ISPF,UNIT=&DUNIT,VOL=SER=&DVOLSER,
//             SPACE=(TRK,(20,05,10)),DISP=(,CATLG),
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=3600) 
//ASM      DD  DSN=&HLQ..&VRM..ASM,UNIT=&DUNIT,VOL=SER=&DVOLSER,
//             SPACE=(TRK,(05,10,10)),DISP=(,CATLG),
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=3600) 
//MACLIB   DD  DSN=&HLQ..&VRM..MACLIB,UNIT=&DUNIT,VOL=SER=&DVOLSER,
//             SPACE=(TRK,(02,02,02)),DISP=(,CATLG),
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=3600)
//         PEND                                                         
//*
//STEP001  EXEC LOADOTHR                     Load ALL other PDSs
//SYSIN    DD  *                                                        
    COPY INDD=INCLIST,OUTDD=CLIST
    COPY INDD=INHELP,OUTDD=HELP
    COPY INDD=INISPF,OUTDD=ISPF
    COPY INDD=INASM,OUTDD=ASM
    COPY INDD=INMACLIB,OUTDD=MACLIB
//                                                                  
______________________________________________________________________
Figure 4: $INST02 JCL
 
 
    a) Member $INST02 installs remaining data sets from distribution
       tape.                                 
 
    b) Review and update JOB statement and other JCL to conform to your
       installation standard.                                       
 
    c) Before submitting the above job, the distribution tape   
       must be made available to MVS by issuing the following
       command from the Hercules console:
 
       DEVINIT 480 X:\dirname\RCQCAL.V0R9M01.HET READONLY=1
 
       where X:\dirname is the complete path to the location
       of the Hercules Emulated Tape file. 
 
    d) Issue the following command from the MVS console to vary
       device 480 online:
 
       V 480,ONLINE
 
    e) Submit the job.
 
    f) Review job output for successful loads.  
 
 
+--------------------------------------------------------------------+
| Step 6. FULL or UPGRADE Installation                               |
+--------------------------------------------------------------------+
|         JCL Member: RCQCAL.V0R9M01.CNTL($UP0901)                   |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//RCQCAL0U JOB (SYS),'Upgrade RCQCAL',       <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  RCQCAL for MVS3.8J TSO / Hercules                   *
//* *                                                      *
//* *  JOB: $UP0901  Upgrade RCQCAL Software               *
//* *       Upgrade to release V0R9M01 from V0R9M00        *
//* *                                                      *
//* *  Review JCL before submitting!!                      *
//* -------------------------------------------------------*
//*
//* -------------------------------------------------------*
//* *                                                      *
//* *  PROC: PARTSISPF                                     *
//* *       Copy ISPF Parts                                *
//* *                                                      *
//* -------------------------------------------------------*
//PARTSI   PROC HLQ=MYHLQ,VRM=VXRXMXX,
//             CLIB='XXXXXXXX.ISPCLIB',    
//             MLIB='XXXXXXXX.ISPMLIB',    
//             PLIB='XXXXXXXX.ISPPLIB',   
//             SLIB='XXXXXXXX.ISPSLIB',   
//             TLIB='XXXXXXXX.ISPTLIB'    
//*
//* -------------------------------------------------------*
//* *                                                      *
//* *  ISPF Library Member Installation                    *
//* *                                                      *
//* *  Suggested Location:                                 *
//* *      DSN defined or concatenated to ISPF Libraries   *
//* *      - ISPCLIB, ISPMLIB, ISPPLIB, ISPSLIB, ISPTLIB   *
//* *                                                      *
//* *  Note: If you use a new PDS, it must be defined      *
//* *        before executing this install job AND the     *
//* *        ISPF start-up procedure should include the    *
//* *        new PDS in the ISPxLIB allocation step.       *
//* *                                                      *
//* -------------------------------------------------------*
//ISPFLIBS EXEC PGM=IEBCOPY              
//SYSPRINT DD  SYSOUT=*
//ISPFIN   DD  DSN=&HLQ..&VRM..ISPF,DISP=SHR             
//CLIBOUT  DD  DSN=&CLIB,DISP=SHR
//MLIBOUT  DD  DSN=&MLIB,DISP=SHR
//PLIBOUT  DD  DSN=&PLIB,DISP=SHR
//SLIBOUT  DD  DSN=&SLIB,DISP=SHR
//TLIBOUT  DD  DSN=&TLIB,DISP=SHR
//SYSIN    DD  DUMMY          
//*
//         PEND
//*
//* -------------------------------------------------------*
//* *  Update ISPF parts for this release distribution     *
//* -------------------------------------------------------*
//* *  Note: Duplicate members are over-written.           *
//* -------------------------------------------------------*
//*
//* *  - Install libraries marked...                       *
//* *    - Search for '<--TARGET'                          *
//* *    - Update install libraries per your               *
//* *      installation standard                           *
//*
//* -------------------------------------------------------*
//ISPFPRTS EXEC PARTSI,HLQ=RCQCAL,VRM=V0R9M01,
//         CLIB='XXXXXXXX.ISPCLIB',                <--TARGET
//         MLIB='XXXXXXXX.ISPMLIB',                <--TARGET
//         PLIB='XXXXXXXX.ISPPLIB',                <--TARGET
//         SLIB='XXXXXXXX.ISPSLIB',                <--TARGET
//         TLIB='XXXXXXXX.ISPTLIB'                 <--TARGET
//SYSIN    DD  *
   COPY INDD=((ISPFIN,R)),OUTDD=CLIBOUT
   SELECT MEMBER=RCQDATEC
   COPY INDD=((ISPFIN,R)),OUTDD=MLIBOUT
   SELECT MEMBER=NO#MBR#                     /*dummy entry no mbrs! */
   COPY INDD=((ISPFIN,R)),OUTDD=PLIBOUT
   SELECT MEMBER=RCQDATE
   SELECT MEMBER=RCQDATE$
   COPY INDD=((ISPFIN,R)),OUTDD=SLIBOUT
   SELECT MEMBER=NO#MBR#                     /*dummy entry no mbrs! */
   COPY INDD=((ISPFIN,R)),OUTDD=TLIBOUT
   SELECT MEMBER=NO#MBR#                     /*dummy entry no mbrs! */
// 
// 
______________________________________________________________________
Figure 5: $UP0900.JCL  Upgrade from previous version to V0R9M01
 
    a) If this is the INITIAL software distribution, proceed to STEP 7.
 
    b) This software may be installed in FULL or UPGRADE from a
       prior version.
 
    Note:  If the installed software version is customized, a manual
    -----  review and evaluation is suggested to properly incorporate
           customizations into this software distribution before
           proceeding with the installation.
 
           Refer to the $UPvrmm.JCL members for upgraded software
           components being installed.
 
 
    c) If a FULL install of this software distribution is elected   
       regardless of previous version installed on your system,
       proceed to STEP 7.
 
    d) If this is an UPGRADE from the PREVIOUS version,       
       execute the below JCL based on current installed version:  
 
       - V0R9M01 upgrade from V0R9M00
 
    e) After upgrade is applied, proceed to validation, STEP 11.
 
 
+--------------------------------------------------------------------+
| Step 7. Install TSO parts                                          |
+--------------------------------------------------------------------+
|         JCL Member: RCQCAL.V0R9M01.CNTL($INST03)                   |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//RCQCAL03 JOB (SYS),'Install TSO Parts',    <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  RCQCAL for MVS3.8J TSO / Hercules                   *
//* *                                                      *
//* *  JOB: $INST03  Install TSO parts                     *
//* *                                                      *
//* *  Note: Duplicate members are over-written.           *
//* -------------------------------------------------------*
//STEP001  EXEC PGM=IEBCOPY                                           
//SYSPRINT DD  SYSOUT=*                                              
//INCLIST  DD  DSN=RCQCAL.V0R9M01.CLIST,DISP=SHR            
//INHELP   DD  DSN=RCQCAL.V0R9M01.HELP,DISP=SHR             
//OUTCLIST DD  DSN=SYS2.CMDPROC,DISP=SHR                               
//OUTHELP  DD  DSN=SYS2.HELP,DISP=SHR
//SYSIN    DD  *                                                        
    COPY INDD=((INCLIST,R)),OUTDD=OUTCLIST
    SELECT MEMBER=NO#MBR#                    /*dummy entry no mbrs! */
    COPY INDD=((INHELP,R)),OUTDD=OUTHELP
    SELECT MEMBER=NO#MBR#                    /*dummy entry no mbrs! */
/*                                                                  
//
______________________________________________________________________
Figure 6: $INST03 JCL
 
 
    a) Member $INST03 installs TSO component(s).
 
       Note:  If no TSO components are included for this distribution,
       -----  RC = 4 is returned by the corresponding IEBCOPY step.
 
    b) Review and update JOB statement and other JCL to conform to your
       installation standard.                                       
 
    c) Submit the job.
 
    d) Review job output for successful load(s).
 
 
+--------------------------------------------------------------------+
| Step 8. Install RCQCAL Software                                    |  
+--------------------------------------------------------------------+
|         JCL Member: RCQCAL.V0R9M01.CNTL($INST04)                   |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//RCQCAL04 JOB (SYS),'Install RCQCAL',       <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  RCQCAL for MVS3.8J TSO / Hercules                   *
//* *                                                      *
//* *  JOB: $INST04  Install RCQCAL Software               *
//* *       Install xxxxxx Program                         *
//* *                                                      *
//* *  - Install libraries marked...                       *
//* *    - Search for '<--TARGET'                          *
//* *    - Update install libraries per your               *
//* *      installation standard                           *
//* *                                                      *
//* -------------------------------------------------------*
//*
//* -------------------------------------------------------*
//* *  IEFBR14                                             *
//* -------------------------------------------------------*
//DUMMY    EXEC PGM=IEFBR14
//SYSPRINT DD   SYSOUT=*
//                                      
______________________________________________________________________
Figure 7: $INST04 JCL
 
 
    a) Member $INST04 installs program(s).
 
       Note:  If no components are included for this distribution,
       -----  an IEFBR14 step is executed.
 
    b) Review and update JOB statement and other JCL to conform to your
       installation standard.                                       
 
    c) Submit the job.
 
    d) Review job output for successful completion.
 
 
+--------------------------------------------------------------------+
| Step 9. Install ISPF parts                                         |
+--------------------------------------------------------------------+
|         JCL Member: RCQCAL.V0R9M01.CNTL($INST05)                   |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//RCQCAL05 JOB (SYS),'Install ISPF Parts',   <-- Review and Modify 
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  RCQCAL for MVS3.8J TSO / Hercules                   *
//* *                                                      *
//* *  JOB: $INST05  Install ISPF parts                    *
//* *                                                      *
//* *  Note: Duplicate members are over-written.           *
//* *                                                      *
//* *                                                      *
//* *  - Uses ISPF 2.1 product from Wally Mclaughlin       *
//* *  - Install libraries marked...                       *
//* *    - Search for '<--TARGET'                          *
//* *    - Update install libraries per your               *
//* *      installation standard                           *
//* -------------------------------------------------------*
//*
//* -------------------------------------------------------*
//* *                                                      *
//* *  PROC: PARTSISPF                                     *
//* *       Copy ISPF Parts                                *
//* *                                                      *
//* -------------------------------------------------------*
//PARTSI   PROC HLQ=MYHLQ,VRM=VXRXMXX,
//             CLIB='XXXXXXXX.ISPCLIB',    
//             MLIB='XXXXXXXX.ISPMLIB',    
//             PLIB='XXXXXXXX.ISPPLIB',   
//             SLIB='XXXXXXXX.ISPSLIB',   
//             TLIB='XXXXXXXX.ISPTLIB'    
//*
//* -------------------------------------------------------*
//* *                                                      *
//* *  CLIB Member Installation                            *
//* *                                                      *
//* *  Suggested Location:                                 *
//* *      DSN defined or concatenated to ISPCLIB DD       *
//* *                                                      *
//* *  Note: If you use a new PDS, it must be defined      *
//* *        before executing this install job AND the     *
//* *        ISPF start-up procedure should include the    *
//* *        new PDS in the ISPCLIB allocation step.       *
//* *                                                      *
//* -------------------------------------------------------*
//ADDCLIB  EXEC PGM=IEBCOPY              
//SYSPRINT DD  SYSOUT=*
//CLIBIN   DD  DSN=&HLQ..&VRM..ISPF,DISP=SHR             
//CLIBOUT  DD  DSN=&CLIB,DISP=SHR
//SYSIN    DD  DUMMY          
//*
//* -------------------------------------------------------*
//* *                                                      *
//* *  MLIB Member Installation                            *
//* *                                                      *
//* *  Suggested Location:                                 *
//* *      DSN defined or concatenated to ISPMLIB DD       *
//* *                                                      *
//* *  Note: If you use a new PDS, it must be defined      *
//* *        before executing this install job AND the     *
//* *        ISPF start-up procedure should include the    *
//* *        new PDS in the ISPMLIB allocation step.       *
//* *                                                      *
//* -------------------------------------------------------*
//ADDMLIB  EXEC PGM=IEBCOPY              
//SYSPRINT DD  SYSOUT=*
//MLIBIN   DD  DSN=&HLQ..&VRM..ISPF,DISP=SHR             
//MLIBOUT  DD  DSN=&MLIB,DISP=SHR
//SYSIN    DD  DUMMY          
//*
//* -------------------------------------------------------*
//* *                                                      *
//* *  PLIB Member Installation                            *
//* *                                                      *
//* *  Suggested Location:                                 *
//* *      DSN defined or concatenated to ISPPLIB DD       *
//* *                                                      *
//* *  Note: If you use a new PDS, it must be defined      *
//* *        before executing this install job AND the     *
//* *        ISPF start-up procedure should include the    *
//* *        new PDS in the ISPPLIB allocation step.       *
//* *                                                      *
//* -------------------------------------------------------*
//ADDPLIB  EXEC PGM=IEBCOPY              
//SYSPRINT DD  SYSOUT=*
//PLIBIN   DD  DSN=&HLQ..&VRM..ISPF,DISP=SHR             
//PLIBOUT  DD  DSN=&PLIB,DISP=SHR
//SYSIN    DD  DUMMY          
//*
//* -------------------------------------------------------*
//* *                                                      *
//* *  SLIB Member Installation                            *
//* *                                                      *
//* *  Suggested Location:                                 *
//* *      DSN defined or concatenated to ISPSLIB DD       *
//* *                                                      *
//* *  Note: If you use a new PDS, it must be defined      *
//* *        before executing this install job AND the     *
//* *        ISPF start-up procedure should include the    *
//* *        new PDS in the ISPSLIB allocation step.       *
//* *                                                      *
//* -------------------------------------------------------*
//ADDSLIB  EXEC PGM=IEBCOPY              
//SYSPRINT DD  SYSOUT=*
//SLIBIN   DD  DSN=&HLQ..&VRM..ISPF,DISP=SHR             
//SLIBOUT  DD  DSN=&SLIB,DISP=SHR
//SYSIN    DD  DUMMY          
//*
//*
//* -------------------------------------------------------*
//* *                                                      *
//* *  TLIB Member Installation                            *
//* *                                                      *
//* *  Suggested Location:                                 *
//* *      DSN defined or concatenated to ISPTLIB DD       *
//* *                                                      *
//* *  Note: If you use a new PDS, it must be defined      *
//* *        before executing this install job AND the     *
//* *        ISPF start-up procedure should include the    *
//* *        new PDS in the ISPTLIB allocation step.       *
//* *                                                      *
//* -------------------------------------------------------*
//ADDTLIB  EXEC PGM=IEBCOPY              
//SYSPRINT DD  SYSOUT=*
//TLIBIN   DD  DSN=&HLQ..&VRM..ISPF,DISP=SHR             
//TLIBOUT  DD  DSN=&TLIB,DISP=SHR
//SYSIN    DD  DUMMY          
//*
//         PEND
//*
//ISPF     EXEC PARTSI,HLQ=RCQCAL,VRM=V0R9M01,
//         CLIB='XXXXXXXX.ISPCLIB',                <--TARGET
//         MLIB='XXXXXXXX.ISPMLIB',                <--TARGET
//         PLIB='XXXXXXXX.ISPPLIB',                <--TARGET
//         SLIB='XXXXXXXX.ISPSLIB',                <--TARGET
//         TLIB='XXXXXXXX.ISPTLIB'                 <--TARGET
//ADDCLIB.SYSIN    DD  *                  CLIB
   COPY INDD=((CLIBIN,R)),OUTDD=CLIBOUT
   SELECT MEMBER=RCQDATEC
//ADDMLIB.SYSIN    DD  *                  MLIB
   COPY INDD=((MLIBIN,R)),OUTDD=MLIBOUT
   SELECT MEMBER=RCQMO00
//ADDPLIB.SYSIN    DD  *                  PLIB
   COPY INDD=((PLIBIN,R)),OUTDD=PLIBOUT
   SELECT MEMBER=RCQDATE
   SELECT MEMBER=RCQDATE$
//ADDSLIB.SYSIN    DD  *                  SLIB
   COPY INDD=((SLIBIN,R)),OUTDD=SLIBOUT
   SELECT MEMBER=NO#MBR#                     /*dummy entry no mbrs! */
//ADDTLIB.SYSIN    DD  *                  TLIB
   COPY INDD=((TLIBIN,R)),OUTDD=TLIBOUT
   SELECT MEMBER=NO#MBR#                     /*dummy entry no mbrs! */
//
______________________________________________________________________
Figure 8: $INST05 JCL
 
 
    a) Member $INST05 installs ISPF component(s).
 
       Note:  If no ISPF components are included for this distribution,
       -----  RC = 4 is returned by the corresponding IEBCOPY step.
        
    b) Review and update JOB statement and other JCL to conform to your
       installation standard.                                       
 
    c) Review and update DD statements for ISPCLIB (clist),
       ISPMLIB (messages), and/or ISPPLIB (panel) library names. 
       The DD statements are tagged with '<--TARGET'.
 
    d) Submit the job.
 
    e) Review job output for successful load(s).
 
 
+--------------------------------------------------------------------+
| Step 10. Install Other Software                                    |  
+--------------------------------------------------------------------+
|         JCL Member: RCQCAL.V0R9M01.CNTL($INST40)                   |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//RCQCAL40 JOB (SYS),'Install Other Pgms',   <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  RCQCAL for MVS3.8J TSO / Hercules                   *
//* *                                                      *
//* *  JOB: $INST40  Install Other Software                *
//* *       Install xxxxxxx  Program                       *
//* *                                                      *
//* *  - Install libraries marked...                       *
//* *    - Search for '<--TARGET'                          *
//* *    - Update install libraries per your               *
//* *      installation standard                           *
//* *                                                      *
//* -------------------------------------------------------*
//*
//* -------------------------------------------------------*
//* *  IEFBR14                                             *
//* -------------------------------------------------------*
//DUMMY    EXEC PGM=IEFBR14
//SYSPRINT DD   SYSOUT=*
// 
______________________________________________________________________
Figure 9: $INST40 JCL
 
 
    a) Member $INST40 installs additional software.
 
       Note:  If no other software is included for this distribution,
       -----  an IEFBR14 step is executed.
 
    b) Review and update JOB statement and other JCL to conform to your
       installation standard.                                       
 
    c) Submit the job.
 
    d) Review job output for successful completion.
 
 
+--------------------------------------------------------------------+
| Step 11. Validate RCQCAL                                           |
+--------------------------------------------------------------------+
 
 
    a) From the ISPF Main Menu, enter the following command:
 
       TSO RCQDATEC
 
    b) Press ENTER.                       
 
    c) The Perpetual Calendar panel is displayed.                 
 
________________________________________________________________________________
 ------------------- Perpetual Calendar & Date Conversion ----------------------
 Command ===>                                              000   JANUARY  2022  
                                                                              1 
             Date ===> FEB / 1   / 2022                     2  3  4  5  6  7  8 
                      month/ day /year                      9 10 11 12 13 14 15 
                   or      julian/year                     16 17 18 19 20 21 22 
                                                           23 24 25 26 27 28 29 
     031                 FEBRUARY  2022                    30 31                
 .-------------------------------------------------------. -------------------- 
 ¦  Sun  ¦  Mon  ¦  Tue  ¦  Wed  ¦  Thu  ¦  Fri  ¦  Sat  ¦ 059    MARCH   2022  
 ¦-------+-------+-------+-------+-------+-------+-------¦        1  2  3  4  5 
 ¦       ¦       ¦ >   1 ¦     2 ¦     3 ¦     4 ¦     5 ¦  6  7  8  9 10 11 12 
 ¦-------+-------+-------+-------+-------+-------+-------¦ 13 14 15 16 17 18 19 
 ¦     6 ¦     7 ¦     8 ¦     9 ¦    10 ¦    11 ¦    12 ¦ 20 21 22 23 24 25 26 
 ¦-------+-------+-------+-------+-------+-------+-------¦ 27 28 29 30 31       
 ¦    13 ¦    14 ¦    15 ¦    16 ¦    17 ¦    18 ¦    19 ¦                      
 ¦-------+-------+-------+-------+-------+-------+-------¦ 090    APRIL   2022  
 ¦    20 ¦    21 ¦    22 ¦    23 ¦    24 ¦    25 ¦    26 ¦                 1  2 
 ¦-------+-------+-------+-------+-------+-------+-------¦  3  4  5  6  7  8  9 
 ¦    27 ¦    28 ¦       ¦       ¦       ¦       ¦       ¦ 10 11 12 13 14 15 16 
 ¦-------+-------+-------+-------+-------+-------+-------¦ 17 18 19 20 21 22 23 
 ¦       ¦       ¦ 02/01/2022     032/2022       TUESDAY ¦ 24 25 26 27 28 29 30 
 '-------------------------------------------------------'                      
   PF7 PrevMM   PF8 NextMM   PF10 PrevYY   PF11 NextYY    Today: 02/18/2022.049 
________________________________________________________________________________
Figure 10a: Perpetual Calendar Panel - initial display
 
    d) Press PF1 for help panel:
 
________________________________________________________________________________
 Tutorial -------------------   RCQDATE Command  ---------------by Michael Theys
 Command ===>                                                                   
                                                                                
 The RCQDATE command invokes a four month perpetual calendar display and will   
 perform Gregorian to Julian date conversion.  The command will display a       
 calendar for the specified month and also the previous and the next two months
 including start julian date for each month (e.g. 000 for JAN, 031 for FEB...).
                                                                                
 An input date field allows for specifying a given date in either Gregorian     
 format 12/2/1987 or Dec/02/1987 or the Julian format 336/1987.  The month      
 for the given date will then be displayed.  The date is also shown in both     
 Gregorian and Julian formats.  Your scroll PF Keys can be used to scroll to    
 the previous/next month (Up/Down) or to the previous/next year (Left/Right).   
                                                                                
 Syntax:    RCQDATE           Operands:    None                                 
                                                                                
 Panel input date format:   month  /  day or Julian day  /  year                
  where,  month is  Jan - Dec (monthname) or 1 - 12;  or  blank                 
          day   is  1 - 31 (day of month);            or  1 - 366 (Julian day)  
          year  is  1583 - 9999                                                 
                                                                                
    Note: month value should be blank if following day is Julian value          
                                                                                
 Examples:   JAN / 01 / 1987      11 / 16 / 1988          / 365 / 1987          
________________________________________________________________________________
Figure 10c: Perpetual Calendar Help panel
 
    e) Press ENTER to return to calendar panel.
 
    f) Press PF7  to display previous month.
       Press PF8  to display next month.
       Press PF10 to display previous year.
       Press PF11 to display next year.
 
 
    g) Press PF3 to quit calendar application.
 
 
    h) Validation for RCQCAL is complete.
 
 
 
+--------------------------------------------------------------------+
| Step 12. Done                                                      |
+--------------------------------------------------------------------+
 
 
    a) Congratulations!  You completed the installation for RCQCAL.


+--------------------------------------------------------------------+
| Step 13. Integrate RCQDATEC into ISPF Command table                |
+--------------------------------------------------------------------+
 
 
    a) Use option =3.9 under ISPF 2.2 to define a command entry in the
       ISPF command table ISPCMDS.                                  
                                                                     
    b) Insert a new entry per the following snippet:
                                                                     
     +----------------------------------------------------------+
     |                                                          |    
     |          VERB      T  ACTION                             |    
     |                          DESCRIPTION                     |    
     |                                                          |    
     |     ____ PCAL      4  SELECT CMD(%RCQDATEC)              |    
     |                          Perpetual Calendar Display      |    
     |                                                          |    
     +----------------------------------------------------------+
                                                                     
    c) Restart ISPF to refresh the command table.                           
                                                                     
    d) Then, you can access from any ISPF screen by typing PCAL
       on the command line.




Enjoy RCQCAL for ISPF 2.2 on MVS 3.8J!
                                                                            

======================================================================
* IV. S o f t w a r e   I n v e n t o r y   L i s t                  |
======================================================================

  - RCQCAL.V0R9M01.ASM 
   . README      Dummy member, this is intentional
      
  - RCQCAL.V0R9M01.CLIST
   . README      Dummy member, this is intentional

  - RCQCAL.V0R9M01.CNTL
   . $INST00     Define Alias for HLQ RCQCAL          
 $ . $INST01     Load CNTL data set from distribution tape (HET)
 $ . $INST02     Load other data sets from distribution tape (HET)
 $ . $INST03     Install TSO Parts
   . $INST04     Install Programs 
 $ . $INST05     Install ISPF Parts
   . $INST40     Install Other programs                    
 $ . $RECVXMI    Receive XMI SEQ to MVS PDSs via RECV370
   . $UP0901     Upgrade to V0R9M01   from   V0R9M00 
 $ . DSCLAIMR    Disclaimer
 $ . PREREQS     Required User-mods
 $ . README      Documentation and Installation instructions

  - RCQCAL.V0R9M01.HELP
   . README      Dummy member, this is intentional

  - RCQCAL.V0R9M01.ISPF
   . RCQMO00     RCQMO00 Messages (MVS38j/ISPF v2.2.0 version)
 $ . RCQDATEC    Perpetual Calendar CLIST  (MVS38j/ISPF v2.2.0 version)
 $ . RCQDATE$    Perpetual Calendar HELP panel (MVS38j/ISPF v2.2.0 version)
 $ . RCQDATE     Perpetual Calendar panel (MVS38j/ISPF v2.2.0 version)
   . OCQMO00     RCQMO00 Messages (original from CBT File$182)
   . OCQDATEC    Perpetual Calendar CLIST (original from CBT File$182)
   . OCQDATE$    Perpetual Calendar HELP panel (original from CBT File$182)
   . OCQDATE     Perpetual Calendar panel (original from CBT File$182)
                
  - RCQCAL.V0R9M01.MACLIB
   . README      Dummy member, this is intentional
       
       
  - After downloading any other required software, consult provided
    documentation including any configuration steps (if applicable)
    for software and HELP file installation. 
       
       
 $ - Denotes modified software component for THIS DISTRIBUTION               
     relative to prior DISTRIBUTION               
                                                                            
                                                                            

