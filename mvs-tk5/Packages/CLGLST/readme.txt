CLGLST for MVS3.8J / Hercules                                               
=============================                                               


Date: 02/10/2022  Release V0R9M00  **INITIAL software distribution
      09/11/2019  Release V0R5M00

*  Author:  Larry Belmontes Jr.
*           https://ShareABitofIT.net/CLGLST-in-MVS38J
*           Copyright (C) 2019-2022  Larry Belmontes, Jr.


---------------------------------------------------------------------- 
|    CLGLST       I n s t a l l a t i o n   R e f e r e n c e        | 
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
|    CLGLST       C h a n g e   H i s t o r y                        | 
---------------------------------------------------------------------- 
*  MM/DD/CCYY Version  Name / Description                                       
*  ---------- -------  -----------------------------------------------          
*  02/10/2022 0.9.00   Larry Belmontes Jr.                                      
*                      - Initial version released to MVS 3.8J                   
*                        hobbyist public domain
*                                                                               
*  09/11/2019 0.5.00   Larry Belmontes Jr.
*                      Initial prototyping and development
*                      w ISPF 2.x
*                                                                               
*
======================================================================
* I. C o n t e n t   o f   Z I P   F i l e                           |
======================================================================

o  $INST00.JCL          Define Alias for HLQ CLGLST in Master Catalog
 
o  $INST01.JCL          Load CNTL data set from distribution tape
 
o  $RECVXMI.JCL         Receive XMI SEQ to MVS PDSs                  
 
o  CLGLST.V0R9M00.HET   Hercules Emulated Tape (HET) multi-file volume
                        with VOLSER of VS0900 containing software
                        distribution.
 
o  CLGLST.V0R9M00.XMI   XMIT file containing software distribution.   
 
o  DSCLAIMR.TXT         Disclaimer
 
o  PREREQS.TXT          Required user-mods 
 
o  README.TXT           This File                                              
 
 
Note:   ISPF v2.0 or higher must be installed under MVS3.8J TSO             
-----   including associated user-mods per ISPF Installation Pre-reqs.
 
Note:   Two user-mods, ZP60014 and ZP60038, are REQUIRED to process
-----   CLIST symbolic variables via the IKJCT441 API on MVS 3.8J before
        using this software installation.
        More information at:
        http://www.prycroft6.com.au/vs2mods/
 
Note:   CUTIL00 is a TSO utility for CLIST variables and           
-----   must be installed as a pre-requisite.  
        More information at:
        https://www.ShareABitOfIT.net/CUTIL00-for-MVS-3-8J/    
 
Note:   DELAY is a utility that 'sleeps' for a number of seconds and
-----   must be installed as a pre-requisite.
        DELAY may be available on MVS3.8J TK3 and TK4- systems.
        More information at:
        https://www.cbttape.org/cbtdowns.htm  FILE #547   
 
Note:   PRINTOFF (TSO CP) is a pre-requisite for this install
-----   and may be available on MVS3.8J TK3 and TK4- systems.          
        More information at:
        https://www.cbttape.org/cbtdowns.htm  FILE #325 
        - or -                                                  
        may be downloaded in a MVS 3.8J install-ready format from
        Jay Moseley's site:
        http://www.jaymoseley.com/hercules/cbt_ware/printoff.htm

 
======================================================================
* II. P r e - i n s t a l l a t i o n   R e q u i r e m e n t s      |
======================================================================

o  The Master Catalog password may be required for some installation
   steps. 
 
o  Tape files use device 480.
 
o  As default, DASD files will be loaded to VOLSER=MVSDLB, type 3350 device.
    
   Below is a DATASET List after tape distribution load for reference purposes:
    
   DATA-SET-NAME------------------------------- VOLUME ALTRK USTRK ORG FRMT % XT
   CLGLST.V0R9M00.ASM                           MVSDLB    10     3 PO  FB  30  1
   CLGLST.V0R9M00.CLIST                         MVSDLB     2     1 PO  FB  50  1
   CLGLST.V0R9M00.CNTL                          MVSDLB    20     9 PO  FB  45  1
   CLGLST.V0R9M00.HELP                          MVSDLB     2     1 PO  FB  50  1
   CLGLST.V0R9M00.ISPF                          MVSDLB    40    28 PO  FB  70  1
   CLGLST.V0R9M00.MACLIB                        MVSDLB     2     1 PO  FB  50  1
   **END**    TOTALS:      76 TRKS ALLOC        43 TRKS USED       6 EXTENTS    
    
    
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
| Step 1. Define Alias for HLQ CLGLST in MVS User Catalog            |
+--------------------------------------------------------------------+
|         JCL Member: CLGLST.V0R9M00.CNTL($INST00)                   |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//CLGLST00 JOB (SYS),'Def CLGLST Alias',     <-- Review and Modify 
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  CLGLST for MVS3.8J TSO / Hercules                   *
//* *  JOB: $INST00  Define Alias for HLQ CLGLST           *
//* *  Note: The master catalog password will be required  *
//* -------------------------------------------------------*
//DEFALIAS EXEC PGM=IDCAMS 
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
 PARM GRAPHICS(CHAIN(SN))
 LISTCAT ALIAS  ENT(CLGLST) 
 IF LASTCC NE 0 THEN -
    DEFINE ALIAS(NAME(CLGLST) RELATE(SYS1.UCAT.MVS))                          
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
|         JCL Member: CLGLST.V0R9M00.CNTL($RECVXMI)                  |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//RECV000A JOB (SYS),'Receive CLGLST XMI',        <-- Review and Modify
//             CLASS=A,MSGCLASS=X,REGION=0M,     <-- Review and Modify
//             MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  JOB: $RECVXMI  Receive Application XMI Files        *
//* -------------------------------------------------------*
//RECV     PROC HLQ=CLGLST,VRM=V0R9M00,TYP=XXXXXXXX,
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
//ISPF     EXEC RECV,TYP=ISPF,DSPACE='(TRK,(40,05,10))'
//ASM      EXEC RECV,TYP=ASM,DSPACE='(TRK,(10,10,10))'
//MACLIB   EXEC RECV,TYP=MACLIB,DSPACE='(TRK,(02,02,02))'
//
______________________________________________________________________
Figure 2: $RECVXMI.JCL
 
 
    a) Transfer CLGLST.V0R9M00.XMI to MVS using your 3270 emulator.
       
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
 
       CLGLST.V0R9M00.ASM   
       CLGLST.V0R9M00.CLIST 
       CLGLST.V0R9M00.CNTL  
       CLGLST.V0R9M00.HELP  
       CLGLST.V0R9M00.ISPF  
       CLGLST.V0R9M00.MACLIB
 
    f) Subsequent installation steps will be submitted from members
       contained in the CNTL data set.
 
    g) Proceed to STEP 6.   ****
 
           
+--------------------------------------------------------------------+
| Step 4. Load CNTL data set from distribution tape                  |
+--------------------------------------------------------------------+
|         JCL Member: CLGLST.V0R9M00.CNTL($INST01)                   |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//CLGLST01 JOB (SYS),'Install CNTL PDS',     <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  CLGLST for MVS3.8J TSO / Hercules                   *
//* *  JOB: $INST01  Load CNTL PDS from distribution tape  *
//* *  Note: Uses tape drive 480                           *
//* -------------------------------------------------------*
//LOADCNTL PROC HLQ=CLGLST,VRM=V0R9M00,TVOLSER=VS0900,      
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
 
       DEVINIT 480 X:\dirname\CLGLST.V0R9M00.HET READONLY=1
 
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
|         JCL Member: CLGLST.V0R9M00.CNTL($INST02)                   |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//CLGLST02 JOB (SYS),'Install Other PDSs',   <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  CLGLST for MVS3.8J TSO / Hercules                   *
//* *  JOB: $INST02  Load other PDS from distribution tape *
//* *  Tape Volume:  File 1 - CNTL                         *
//* *                File 2 - CLIST                        *
//* *                File 3 - HELP                         *
//* *                File 4 - ISPF                         *
//* *                File 5 - ASM                          *
//* *                File 6 - MACLIB                       *
//* *  Note: Default TAPE=480, DASD=3350 on MVSDLB         *
//* -------------------------------------------------------*
//LOADOTHR PROC HLQ=CLGLST,VRM=V0R9M00,TVOLSER=VS0900,            
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
//             SPACE=(TRK,(40,05,10)),DISP=(,CATLG),
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=3600) 
//ASM      DD  DSN=&HLQ..&VRM..ASM,UNIT=&DUNIT,VOL=SER=&DVOLSER,
//             SPACE=(TRK,(10,10,10)),DISP=(,CATLG),
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
 
       DEVINIT 480 X:\dirname\CLGLST.V0R9M00.HET READONLY=1
 
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
|         JCL Member: CLGLST.V0R9M00.CNTL($UP0900)                   |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//CLGLST0U JOB (SYS),'Upgrade CLGLST',       <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  CLGLST for MVS3.8J TSO / Hercules                   *
//* *                                                      *
//* *  JOB: $UP0900  Upgrade CLGLST Software               *
//* *       Upgrade to release V0R9M00 from VxRxMxx        *
//* *                                                      *
//* *  Review JCL before submitting!!                      *
//* -------------------------------------------------------*
//*
//* -------------------------------------------------------*
//* *  No upgrades for V0R9M00                             *
//* -------------------------------------------------------*
//CLGLST   EXEC  PGM=IEFBR14
//*
// 
______________________________________________________________________
Figure 5: $UP0900.JCL  Upgrade from previous version to V0R9M00
 
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
 
       - V0R9M00 is initial release, thus, no updates available!
 
    e) After upgrade is applied, proceed to validation, STEP 11.
 
 
+--------------------------------------------------------------------+
| Step 7. Install TSO parts                                          |
+--------------------------------------------------------------------+
|         JCL Member: CLGLST.V0R9M00.CNTL($INST03)                   |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//CLGLST03 JOB (SYS),'Install TSO Parts',    <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  CLGLST for MVS3.8J TSO / Hercules                   *
//* *                                                      *
//* *  JOB: $INST03  Install TSO parts                     *
//* *                                                      *
//* *  Note: Duplicate members are over-written.           *
//* -------------------------------------------------------*
//STEP001  EXEC PGM=IEBCOPY                                           
//SYSPRINT DD  SYSOUT=*                                              
//INCLIST  DD  DSN=CLGLST.V0R9M00.CLIST,DISP=SHR            
//INHELP   DD  DSN=CLGLST.V0R9M00.HELP,DISP=SHR             
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
| Step 8. Install CLGLST Software                                    |  
+--------------------------------------------------------------------+
|         JCL Member: CLGLST.V0R9M00.CNTL($INST04)                   |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//CLGLST04 JOB (SYS),'Install CLGLST',       <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  CLGLST for MVS3.8J TSO / Hercules                   *
//* *                                                      *
//* *  JOB: $INST04  Install CLGLST Software               *
//* *       Install GETMSG Program                         *
//* *                                                      *
//* *  - Install libraries marked...                       *
//* *    - Search for '<--TARGET'                          *
//* *    - Update install libraries per your               *
//* *      installation standard                           *
//* *                                                      *
//* -------------------------------------------------------*
//*
//* -------------------------------------------------------*
//* *                                                      *
//* *  PROC: COBLKED                                       *
//* *       COBOL     Link-Edit                            *
//* *                                                      *
//* -------------------------------------------------------*
//COBL     PROC HLQ=WHATHLQ,VRM=VXRXMXX,
//             MBR=WHOWHAT,
//             CPARM1='LOAD,SUPMAP',                                
//             CPARM2='SIZE=2048K,BUF=1024K'                        
//*COB EXEC  PGM=IKFCBL00,REGION=4096K,                             
//*          PARM='LOAD,SUPMAP,SIZE=2048K,BUF=1024K'                
//COB      EXEC PGM=IKFCBL00,REGION=4096K,                             
//           PARM='&CPARM1,&CPARM2'                                 
//STEPLIB  DD  DUMMY
//SYSPRINT DD  SYSOUT=*                                             
//SYSPUNCH DD  DSN=NULLFILE
//SYSUT1   DD  UNIT=SYSDA,SPACE=(460,(700,100))                        
//SYSUT2   DD  UNIT=SYSDA,SPACE=(460,(700,100))                        
//SYSUT3   DD  UNIT=SYSDA,SPACE=(460,(700,100))                        
//SYSUT4   DD  UNIT=SYSDA,SPACE=(460,(700,100))                        
//SYSLIN   DD  DSNAME=&LOADSET,DISP=(MOD,PASS),UNIT=SYSDA,             
//             SPACE=(80,(500,100))                                 
//SYSLIB   DD  DSN=&HLQ..&VRM..ASM,DISP=SHR
//         DD  DSN=&HLQ..&VRM..MACLIB,DISP=SHR
//SYSIN    DD  DSN=&HLQ..&VRM..ASM(&MBR),DISP=SHR <--INPUT
//*
//LKED     EXEC PGM=IEWL,PARM='LIST,XREF,LET',
//             COND=(5,LT,COB),REGION=96K
//SYSLIN   DD  DSNAME=&LOADSET,DISP=(OLD,DELETE)                      
//         DD  DDNAME=SYSIN                                                
//SYSLMOD  DD  DUMMY                                        
//SYSLIB   DD  DUMMY                  
//SYSUT1   DD  UNIT=SYSDA,SPACE=(1024,(50,20))                         
//SYSPRINT DD  SYSOUT=*                                              
//SYSIN    DD  DUMMY
//*
//         PEND
//*
//* -------------------------------------------------------*
//* *  Compile  Link-Edit GETMSG to ISPLLIB                *
//* -------------------------------------------------------*
//GETMSG   EXEC COBL,HLQ=CLGLST,VRM=V0R9M00,MBR=GETMSG,
//         CPARM1='LIST,LOAD,NODECK,PMAP,DMAP' 
//**       PARM.LKED='MAP,LIST,LET,RENT,XREF,REUS,REFR'
//COB.STEPLIB  DD DSN=SYS1.LINKLIB,DISP=SHR          <--Complr STEPLIB
//LKED.SYSLMOD DD DSN=XXXXXXXX.ISPLLIB(GETMSG),      <-- TARGET
//          DISP=SHR
//LKED.SYSLIB  DD DSNAME=SYS1.COBLIB,DISP=SHR        <-- COBOL Subrtns
//             DD DSNAME=ISP.V2R2M0.LLIB,            <-- ISP SYS LLIB
//          DISP=SHR
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
|         JCL Member: CLGLST.V0R9M00.CNTL($INST05)                   |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//CLGLST05 JOB (SYS),'Install ISPF Parts',   <-- Review and Modify 
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  CLGLST for MVS3.8J TSO / Hercules                   *
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
//ISPF     EXEC PARTSI,HLQ=CLGLST,VRM=V0R9M00,
//         CLIB='XXXXXXXX.ISPCLIB',                <--TARGET
//         MLIB='XXXXXXXX.ISPMLIB',                <--TARGET
//         PLIB='XXXXXXXX.ISPPLIB',                <--TARGET
//         SLIB='XXXXXXXX.ISPSLIB',                <--TARGET
//         TLIB='XXXXXXXX.ISPTLIB'                 <--TARGET
//ADDCLIB.SYSIN    DD  *                  CLIB
   COPY INDD=((CLIBIN,R)),OUTDD=CLIBOUT
   SELECT MEMBER=C$CLOGIT
   SELECT MEMBER=CLOGIT
   SELECT MEMBER=CLOG 
   SELECT MEMBER=CLLDFLT
   SELECT MEMBER=C$CLSTIT
   SELECT MEMBER=CLSTIT
   SELECT MEMBER=CLST 
   SELECT MEMBER=CLSTCHR
   SELECT MEMBER=CLOGLSTX
//ADDMLIB.SYSIN    DD  *                  MLIB
   COPY INDD=((MLIBIN,R)),OUTDD=MLIBOUT
   SELECT MEMBER=CLOG00
   SELECT MEMBER=CLOG01
   SELECT MEMBER=CLOG02
   SELECT MEMBER=CLOG03
   SELECT MEMBER=CLST00
   SELECT MEMBER=CLST01
   SELECT MEMBER=CLST02
   SELECT MEMBER=CLST03
//ADDPLIB.SYSIN    DD  *                  PLIB
   COPY INDD=((PLIBIN,R)),OUTDD=PLIBOUT
   SELECT MEMBER=HLLDFLT
   SELECT MEMBER=PLLDFLT
   SELECT MEMBER=HLLP01 
   SELECT MEMBER=PLLP01 
   SELECT MEMBER=HLLP02 
   SELECT MEMBER=PLLP02 
   SELECT MEMBER=HLSTCHR
   SELECT MEMBER=PLSTCHR
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
|         JCL Member: CLGLST.V0R9M00.CNTL($INST40)                   |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//CLGLST40 JOB (SYS),'Install Other Pgms',   <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  CLGLST for MVS3.8J TSO / Hercules                   *
//* *                                                      *
//* *  JOB: $INST40  Install Other Software                *
//* *       Install xxxxxx   Programs                      *
//* *                                                      *
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
| Step 11. Validate CLOGIT and CLSTIT                                |
+--------------------------------------------------------------------+
 
 
    a) From the ISPF Main Menu, enter the following command:    
     
       TSO %C$CLOGIT                  
     
    b) The CLIST will initiate tests including testing the GETMSG
       utility and display various messages before starting a browse
       session of the LOGIT data set.
     
       Below is a representative sample output from C$CLOGIT:
 
______________________________________________________________________
 *** C$CLOGIT IVP TESTING CLIST ***                                             
 *** ISPF IS ACTIVE        ***                                                  
 *** TEST GETMSG UTILITY   ***                                                  
 MSGID='CLOG000', RC=0                                                          
 GETMSG VARIABLES DISPLAYED...                                                  
 ERRSM='WELCOME CLOGIT TEST MSG '                                               
 ERRLM='CLOG000  CLOGIT LONG MESSAGE TEXT IVP...                                
        '                                                                       
 ERRALRM='YES'                                                                  
 ERRHM='        '                                                               
 ERRTYPE='        '                                                             
 *** TEST CLOGIT, .......! ***
 *** BROWSE LOG DATA SET   ***
 ***                                                                            
______________________________________________________________________
Figure 10a: Sample messages displayed on terminal from C$CLOGIT
                                                                   
 
    c) The sample LOGIT data set contents should appear as represented in 
       the below browse session:
        
______________________________________________________________________
 userid.LOGIT.Dyyjjj.Thhmmss on TSO00A ------------------------- Line 1 Col 1 80
 Command ===>                                                  Scroll ===> CSR 
1       10        20        30        40        50        60        70       
A---+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+
1PAGE: 1                                                                        
 MM/DD/CCYY HH:MM:SS ID PROCESS  DESCRIPTION                                    
 mm/dd/ccyy hh:mm:ss __ LOGINIT  *** START OF ISPF SESSION LOG -----------------
 mm/dd/ccyy hh:mm:ss __ LOGINIT  JOB userid(TSU00598) EXECUTING    
  .
 mm/dd/ccyy hh:mm:ss                                         
 mm/dd/ccyy hh:mm:ss    IVP      IVP TEST 2                                    
 mm/dd/ccyy hh:mm:ss AB IVP      IVP TEST 3 W ID                               
 mm/dd/ccyy hh:mm:ss MM LOG_MSGS CLOG000: WELCOME CLOGIT TEST MSG               
                        LOG_MSGL CLOG000: CLOG000  CLOGIT LONG MESSAGE TEXT IVP.
 mm/dd/ccyy hh:mm:ss    LOG_MSGS CLOG008: CLOGIT SHORT MSG ONLY         
______________________________________________________________________
Figure 10b: Sample browse session for LOGIT data set after IVP          


    d) Validation for GETMSG and CLOGIT is complete. 
 
 
    e) From the ISPF Main Menu, enter the following command:    
     
       TSO %C$CLSTIT                  
     
    f) The CLIST will initiate tests including and display various
       messages before starting a browse session of the LISTIT
       LISTIT data set.
     
       Below is a representative sample output from C$CLSTIT:
 
______________________________________________________________________
 *** C$CLSTIT IVP TESTING CLIST ***                 
 *** ISPF IS ACTIVE        ***                      
 *** IVP TEST CLSTIT ***                            
 1. IVP TEST START LINE                             
 LISTIT ON FILE ALLOC = 'IVP TEST ...'              
 LISTIT ON FILE ALLOC AFTER TOP CC = '1IVP TEST ...'
 RC=0                                               
 2. DEFAULT BLANK LINE                              
 RC=0                                               
 3. TEXT LINE, TRIPLE SPACE                         
 RC=0                                               
 4. BLANK LINE, DOUBLE SPACE, NEW PAGE              
 RC=0                                               
 5. MUTLI-LINE, DOUBLE SPACE                        
 RC=0                                               
 6. MUTLI-LINE, CC PROVIDED, NEW PAGE               
 RC=0                                               
 7. MUTLI-LINE, CC PROVIDED                         
 RC=0                                               
 *** BROWSE LOG DATA SET   ***                      
 ***                                                
______________________________________________________________________
Figure 10c: Sample messages displayed on terminal from C$CLSTIT
                                                                   
 
    g) The sample LISTIT data set contents should appear as represented in 
       the below browse session:
        
______________________________________________________________________
 userid.LISTIT.Dyyjjj.Thhmmss on TSO00A ------------------------ Line 1 Col 1 80
 Command ===>                                                  Scroll ===> CSR 
1       10        20        30        40        50        60        70       
A---+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+
1IVP TEST ...                       
                                    
-TRIPLE SPACE LINE                  
                                    
0LINE 1                             
0LINE 2                             
0LINE 3                             
0LINE 4                             
0LINE 5                             
0LINE 1                             
0LINE 2                             
0LINE 3                             
0LINE 4                             
0LINE 5                             
0ONE DOUBLE SPACED LINE TO LIST FILE
______________________________________________________________________
Figure 10d: Sample browse session for LISTIT data set after IVP          


    h) Validation for CLSTIT is complete. 
 
 
+--------------------------------------------------------------------+
| Step 12. Done                                                      |
+--------------------------------------------------------------------+
 
 
    a) Congratulations!
 
       You completed the installation for the CLOGIT and CLSTIT commands.
 
       At this point, the LOGIT data set is allocated, can perform 
       writes to the LOGIT data set including logging of ISPF messages.

       The LISTIT data set is allocated, can perform writes to the
       LISTIT data set.

       After step 13, the remaining software will be validated.


+--------------------------------------------------------------------+
| Step 13. Incorporate CLGLST into ISPF and ISPF Start-up Procedure  |
+--------------------------------------------------------------------+
 
    Four integration modifications are necessary including additional
    validation to complete the CLGLST application installation.
 
    These activities are outlined as follows:
 
 
    -----------------------------------------------
    1) ISPF Log and List Defaults (PLLDFLT)
        - and -
       ISPF List Data Set Characteristics (PLSTCHR)
    -----------------------------------------------
 
    a) It is suggested reusing option 2 and 5 from the ISPF PARAMETER OPTIONS
       menu (ISPOP0, option =0) to select new panels (PLLDFLT and PLSTCHR).
                                                                     
    b) Create a copy of ISPOP0 in your application panel library
       instead of the ISPF system panel library to preserve the original
       system panel in addition to preserving your ISPOP0 changes      
       when upgrading your ISPF system with a new version.    
                                                                     
    c) Edit the copied version of ISPOP0 in your application panel library.
                                                                     
    d) Change the option lines as shown below to enable and display 
       revised menu options:
    
       )BODY section:
    
       -- change line from --
       ^   2 ^LOG/LIST    - Specify ISPF log and list defaults
    
       -- to --   
       %   2 +LOG/LIST    - Specify ISPF log and list defaults^(CLGLST)
 
       -- change line from --
       ^   5 ^LIST        - Specify list data set characteristics
    
       -- to --   
       %   5 +LIST        - Specify list data set characteristics^(CLGLST)
 
    e) Add the 'NEW ENTRY' lines as shown below to process option 2 and 5:
                                                                          
       )PROC section:                                      
                                                                          
         &ZSEL = TRANS(TRUNC(&ZCMD,'.')                    
                       1,'PGM(ISPOPT01)'                   
       /*              2,'PANEL(ISPOP02)'                */
                       2,'CMD(%CLLDFLT) NEWAPPL(ISP)'      <-- NEW ENTRY
                       .
                       .
       /*              5,'PANEL(ISPOP05)'                */
                       5,'CMD(%CLSTCHR) NEWAPPL(ISP)'      <-- NEW ENTRY
                       .
                       .
                     ' ',' '
                       *,'?' )
       )END
 
    f) Save SELECTION MENU panel (ISPOP0) changes.

    g) Type =0 in the COMMAND line and press ENTER.
       The revised menu items (2 and 5) should display. 

    h) Type 2 in the COMMAND line and press ENTER.
       The new panel, PLLDFLT, should display. 
 
    i) You are now ready to declare LOG and LIST default options.
 
    j) When complete, press ENTER to save default options.

    k) Appropriate confirmation message should display on originating panel.
 
    l) Declaring LOG and LIST default values is complete and validated. 
 
    m) Type =0 in the COMMAND line and press ENTER.
       The revised menu item (5) should display. 

    h) Type 5 in the COMMAND line and press ENTER.
       The new panel, PLSTCHR, should display. 
 
    i) You are now ready to declare LIST Data Set Characteristics.
 
    j) When complete, press ENTER to save characteristics.

    k) Appropriate confirmation message should display on originating panel.
 
    l) Declaring LIST Data Set Characteristics is complete and validated. 
 
 
 
 
    -------------------------------------------
    2) Process LOG data set during ISPF session
    -------------------------------------------
 
    a) From the ISPF Main Menu, enter the below command to ensure
       LOG data set is allocated with content by generating   
       a LOG entry:
     
       TSO %CLOGIT TXT(''ENSURE LOG DATA SET IS OPEN'')
     
    b) From the ISPF Main Menu, enter the below command to browse
       LOG data set current content:
     
       TSO %CLOG B
     
       NOTE: CLOG command has several keyword options-
             BROWSE, QUIKPRT, DELETE, PRINT, KEEP
             Refer to CLOG CLIST or              
             https://ShareABitofIT.net/CLGLST-in-MVS38J
     
    c) Press PF3 to exit browse session
     
    d) From the ISPF Main Menu, enter the below command to present
       the LOG data set disposition panel (PLLP01):
     
       TSO %CLOG  
     
    e) The disposition panel includes default values declared
       earlier in the validation process.
 
    f) Type KS for the Process option to keep using the same LOG 
       data set for subsequent logging activity.
 
    g) No other panel data is necessary for this request.
       However, you can change data and save for subsequent use.
 
    h) When complete, press ENTER to process LOG data set.

    i) Appropriate confirmation message should display on originating panel.
 
    j) Processing LOG data set is complete and validated. 
 
 
 
 
    -------------------------------------------- 
    3) Process LIST data set during ISPF session
    -------------------------------------------- 
 
    a) From the ISPF Main Menu, enter the below command to ensure
       LIST data set is allocated with content by generating   
       a LIST entry:
     
       TSO %CLSTIT TXT(''ENSURE LIST DATA SET IS OPEN'') LLEN(28)
     
    b) From the ISPF Main Menu, enter the below command to browse
       LIST data set current content:
     
       TSO %CLST B
     
       NOTE: CLST command has several keyword options-
             BROWSE, QUIKPRT, DELETE, PRINT, KEEP
             Refer to CLST CLIST or              
             https://ShareABitofIT.net/CLGLST-in-MVS38J
     
    c) Press PF3 to terminate browse
     
    d) From the ISPF Main Menu, enter the below command to present
       the LIST data set disposition panel (PLLP02):
     
       TSO %CLST  
     
    e) The disposition panel includes default values declared
       earlier in the validation process.
 
    f) Type KS for the Process option to keep using the same LIST
       data set for subsequent printing activity.
 
    g) No other panel data is necessary for this request.
       However, you can change data and save for subsequent use.
 
    h) When complete, press ENTER to process LIST data set.

    i) Appropriate confirmation message should display on originating panel.
 
    j) Processing LIST data set is complete and validated. 
 
    
 
 
    ---------------------------------------------------------
    4) Process LOG and/or LIST data set after ISPF terminates
    ---------------------------------------------------------
 
    a) Identify Procedure that starts your installation ISPF environment.
 
    b) Place the following command statements after the invocation of ISPF  
       as depicted below:
     
 
       1       10        20        30        40        50        60        70 
       ----+----+----+----+----+----+----+----+----+----+----+----+----+----+-
       /********************************************************************/
       /* POST-ISPF Processing                                             */
       /********************************************************************/
       /**********************************************/                        
       /* Process LOG and LIST Data sets             */                        
       /**********************************************/                        
       ISPF CMD(%CLOGLSTX)                              
 
 
    c) When ISPF terminates, CLOG and CLST commands are executed to process
       LOG and LIST data sets per default processing option. 
 
 
    d) This can be validated by reviewing output and/or data set lists (=3.4)
       depending on default processing option for LOG and LIST data sets.
 
 
 
    You are complete with the CLGLST application installation!
 
 
    Note: You can change the processing option for the LOG and/or LIST data set
          per your personal preference by using option 0.2.


Enjoy CLGLST!
                                                                            

======================================================================
* IV. S o f t w a r e   I n v e n t o r y   L i s t                  |
======================================================================

  - CLGLST.V0R9M00.ASM 
   . GETMSG      TSO CP get ISPF message
      
  - CLGLST.V0R9M00.CLIST
   . README      Dummy member, this is intentional

  - CLGLST.V0R9M00.CNTL
   . $INST00     Define Alias for HLQ CLGLST          
   . $INST01     Load CNTL data set from distribution tape (HET)
   . $INST02     Load other data sets from distribution tape (HET)
   . $INST03     Install TSO Parts
   . $INST04     Install GETMSG CP
   . $INST05     Install ISPF Parts
   . $INST40     Install Other programs                    
   . $RECVXMI    Receive XMI SEQ to MVS PDSs via RECV370
   . $UP0900     Upgrade to V0R9M00   from   V0R9M00 
   . DSCLAIMR    Disclaimer
   . PREREQS     Required User-mods
   . README      Documentation and Installation instructions

  - CLGLST.V0R9M00.HELP
   . README      Dummy member, this is intentional

  - CLGLST.V0R9M00.ISPF
   . CLLDFLT     CLIST LOG and LIST Defaults driver 
   . CLOGIT      CLIST to write log message    
   . CLOG        CLIST to process LOG data set     
   . C$CLOGIT    IVP CLIST for CLOGIT
   . CLOG00      CLOG00 Messages     
   . CLOG01      CLOG01 Messages     
   . CLOG02      CLOG02 Messages     
   . CLOG03      CLOG03 Messages     
   . HLLP01      LOG Data Set Disposition HELP panel 
   . PLLP01      LOG Data Set Disposition panel 
   . HLLDFLT     LOG and LIST Defaults HELP panel
   . PLLDFLT     LOG and LIST Defaults panel 
    
   . HLLP02      LIST Data Set Disposition HELP panel 
   . PLLP02      LIST Data Set Disposition panel 
   . HLSTCHR     LIST Data Set Characteristics HELP panel
   . PLSTCHR     LIST Data Set Characteristics panel 
   . CLSTCHR     CLIST LIST Characteristics driver 
   . CLSTIT      CLIST to write list message   
   . CLST        CLIST to process LIST data set     
   . C$CLSTIT    IVP CLIST for CLSTIT
 
   . CLOGLSTX    CLIST to process LOG and LIST at ISPF termination
                
  - CLGLST.V0R9M00.MACLIB
   . README      Dummy member, this is intentional
       
       
  - After downloading any other required software, consult provided
    documentation including any configuration steps (if applicable)
    for software and HELP file installation. 
       
       
 $ - Denotes modified software component for THIS DISTRIBUTION               
     relative to prior DISTRIBUTION               
                                                                            
                                                                            

