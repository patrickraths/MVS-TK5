ISPOPT5 for MVS3.8J / Hercules                                               
==============================                                               


Date: 10/31/2021  Release V0R9M00  **INITIAL software distribution

*  Author:  Larry Belmontes Jr.
*           https://ShareABitofIT.net/ISPOPT5-in-MVS38J
*           Copyright (C) 2021  Larry Belmontes, Jr.


---------------------------------------------------------------------- 
|    ISPOPT5      I n s t a l l a t i o n   R e f e r e n c e        | 
---------------------------------------------------------------------- 

   The approach for this installation procedure is to transfer the
distribution content from your personal computing device to MVS with
minimal JCL and to continue the installation procedure using supplied
JCL from the MVS CNTL data set under TSO.                         

   Below are descriptions of ZIP file content, pre-installation
requirements (notes, credits) and installation steps.
 
Good luck and enjoy this software as added value to MVS 3.8J!
-Larry Belmontes



---------------------------------------------------------------------- 
|    ISPOPT5      C h a n g e   H i s t o r y                        | 
---------------------------------------------------------------------- 
*
*  MM/DD/CCYY Version  Change Description
*  ---------- -------  -----------------------------------------------
*  10/31/2021 0.9.00   Initial version released to MVS 3.8J
*                      hobbyist public domain
*
*
======================================================================
* I. C o n t e n t   o f   Z I P   F i l e                           |
======================================================================

o  $INST00.JCL          Define Alias for HLQ ISPOPT5 in Master Catalog
 
o  $INST01.JCL          Load CNTL data set from distribution tape
 
o  $RECVXMI.JCL         Receive XMI SEQ to MVS PDSs                  
 
o  ISPOPT5.V0R9M00.HET  Hercules Emulated Tape (HET) multi-file volume
                        with VOLSER of VS0900 containing software  
                        distribution.
 
o  ISPOPT5.V0R9M00.XMI  XMIT file containing software distribution.   
 
o  DSCLAIMR.TXT         Disclaimer
 
o  PREREQS.TXT          Required user-mods 
 
o  README.TXT           This File                                              
 
 
Note:   ISPF v2.1 or higher must be installed under MVS3.8J TSO             
-----   including associated user-mods per ISPF Installation Pre-reqs.
 
Note:   SYSCPK (compiler and tool DASD) is a pre-requisite for this install.
-----   More information at:
        http://www.jaymoseley.com/hercules/compilers/syscpk.htm
       
Note:   LISTDSJ, alias LISTDSI, is a LISTDSI-like program that creates CLIST
-----   variables for some dataset attributes.  For convenience purposes, a
        current version is included for installation.                  
        More information at:
        https://www.shareabitofit.net/LISTDSJ-for-MVS-3-8j    
         
Note:   CUTIL00 is a TSO utility for CLIST variables.              
-----   For convenience purposes, a current version is included for
        installation.  More information at:
        https://www.shareabitofit.net/CUTIL00-for-MVS-3-8j/

Credit: PUTCARD is a pre-requisite for this install and available from
------- an MVS Update article titled "CONTROL CARD IMAGE QUICK BUILDER"
        dated September 1998 by author UNKNOWN.  
        Thanks to Xephon and CBT for this contribution.
        For convenience purposes, a modified version is included for    
        installation.  More information at:  
        https://www.cbttape.org/xephon  as mvs9809.pdf
 



======================================================================
* II. P r e - i n s t a l l a t i o n   R e q u i r e m e n t s      |
======================================================================

o  The Master Catalog password may be required for some installation
   steps. 
 
o  Tape files use device 480.
 
o  As default, DASD files will be loaded to VOLSER=MVSDLB, type 3350 device.
    
   Below is a DATASET List after tape distribution load for reference purposes:
    
   DATA-SET-NAME------------------------------- VOLUME ALTRK USTRK ORG FRMT % XT
   ISPOPT5.V0R9M00.ASM                          MVSDLB    80    63 PO  FB  78  1
   ISPOPT5.V0R9M00.CLIST                        MVSDLB     6     3 PO  FB  50  1
   ISPOPT5.V0R9M00.CNTL                         MVSDLB    20    10 PO  FB  45  1
   ISPOPT5.V0R9M00.HELP                         MVSDLB     4     2 PO  FB  50  1
   ISPOPT5.V0R9M00.ISPF                         MVSDLB    80    57 PO  FB  66  1
   ISPOPT5.V0R9M00.MACLIB                       MVSDLB     2     1 PO  FB  50  1
   **END**    TOTALS:     192 TRKS ALLOC       131 TRKS USED       6 EXTENTS    
    
    
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
| Step 1. Define Alias for HLQ ISPOPT5 in MVS User Catalog           |
+--------------------------------------------------------------------+
|         JCL Member: ISPOPT5.V0R9M00.CNTL($INST00)                  |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//ISPOPT50 JOB (SYS),'Def ISPOPT5 Alias',    <-- Review and Modify 
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  ISPOPT5 in MVS3.8J TSO / Hercules                   *
//* *  JOB: $INST00  Define Alias for HLQ ISPOPT5          *
//* *  Note: The master catalog password will be required  *
//* -------------------------------------------------------*
//DEFALIAS EXEC PGM=IDCAMS 
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
 PARM GRAPHICS(CHAIN(SN))
 LISTCAT ALIAS  ENT(ISPOPT5) 
  
 IF LASTCC NE 0 THEN -
    DEFINE ALIAS(NAME(ISPOPT5) RELATE(SYS1.UCAT.MVS))                          
/*                                                                      
//
______________________________________________________________________
Figure 1: $INST00 JCL
 
 
    a) Copy and paste the above JCL to a PDS member, update JOB 
       statement to conform to your installation standard.             
 
    b) Submit the job.                                  
 
    c) Review job output for successful DEFINE ALIAS.
 
    Note: When $INST00 runs initially for the first time,
          Job step DEFALIAS returns RC=0004 due to LISTCAT ALIAS function
          completing with condition code of 4 and DEFINE ALIAS function 
          completing with condition code of 0.
           
    Note: If $INST00 runs after the ALIAS is defined,
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
|         JCL Member: ISPOPT5.V0R9M00.CNTL($RECVXMI)                 |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//RECV000A JOB (SYS),'Receive ISPOPT5 XMI',      <-- Review and Modify
//             CLASS=A,MSGCLASS=X,REGION=0M,     <-- Review and Modify
//             MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  JOB: $RECVXMI  Receive Application XMI Files        *
//* -------------------------------------------------------*
//RECV     PROC HLQ=ISPOPT5,VRM=V0R9M00,TYP=XXXXXXXX,
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
//ASM      EXEC RECV,TYP=ASM,DSPACE='(TRK,(80,10,20))'
//CLIST    EXEC RECV,TYP=CLIST,DSPACE='(TRK,(06,02,02))'
//CNTL     EXEC RECV,TYP=CNTL,DSPACE='(TRK,(20,10,10))'
//HELP     EXEC RECV,TYP=HELP,DSPACE='(TRK,(04,02,02))'
//ISPF     EXEC RECV,TYP=ISPF,DSPACE='(TRK,(80,05,20))'
//MACLIB   EXEC RECV,TYP=MACLIB,DSPACE='(TRK,(02,02,02))'
//
______________________________________________________________________
Figure 2: $RECVXMI.JCL
 
 
    a) Transfer ISPOPT5.V0R9M00.XMI to MVS using your 3270 emulator.
       
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
 
       ISPOPT5.V0R9M00.ASM   
       ISPOPT5.V0R9M00.CLIST 
       ISPOPT5.V0R9M00.CNTL  
       ISPOPT5.V0R9M00.HELP  
       ISPOPT5.V0R9M00.ISPF  
       ISPOPT5.V0R9M00.MACLIB
 
    f) Subsequent installation steps will be submitted from members
       contained in the CNTL data set.
 
    g) Proceed to STEP 6.   ****
 
+--------------------------------------------------------------------+
| Step 4. Load CNTL data set from distribution tape                  |
+--------------------------------------------------------------------+
|         JCL Member: ISPOPT5.V0R9M00.CNTL($INST01)                  |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//ISPOPT51 JOB (SYS),'Install CNTL PDS',     <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  ISPOPT5 for MVS3.8J TSO / Hercules                  *
//* *  JOB: $INST01  Load CNTL PDS from distribution tape  *
//* *  Note: Uses tape drive 480                           *
//* -------------------------------------------------------*
//LOADCNTL PROC HLQ=ISPOPT5,VRM=V0R9M00,TVOLSER=VS0900,      
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
 
       DEVINIT 480 X:\dirname\ISPOPT5.V0R9M00.HET READONLY=1
 
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
|         JCL Member: ISPOPT5.V0R9M00.CNTL($INST02)                  |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//ISPOPT52 JOB (SYS),'Install Other PDSs',   <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  ISPOPT5 for MVS3.8J TSO / Hercules                  *
//* *  JOB: $INST02  Load other PDS from distribution tape *
//* *  Tape Volume:  File 1 - CNTL                         *
//* *                File 2 - CLIST                        *
//* *                File 3 - HELP                         *
//* *                File 4 - ISPF                         *
//* *                File 5 - ASM                          *
//* *                File 6 - MACLIB                       *
//* *  Note: Default TAPE=480, DASD=3350 on MVSDLB         *
//* -------------------------------------------------------*
//LOADOTHR PROC HLQ=ISPOPT5,VRM=V0R9M00,TVOLSER=VS0900,            
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
//             SPACE=(TRK,(06,02,02)),DISP=(,CATLG),
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=3600) 
//HELP     DD  DSN=&HLQ..&VRM..HELP,UNIT=&DUNIT,VOL=SER=&DVOLSER,
//             SPACE=(TRK,(04,02,02)),DISP=(,CATLG),
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=3600) 
//ISPF     DD  DSN=&HLQ..&VRM..ISPF,UNIT=&DUNIT,VOL=SER=&DVOLSER,
//             SPACE=(TRK,(80,05,20)),DISP=(,CATLG),
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=3600) 
//ASM      DD  DSN=&HLQ..&VRM..ASM,UNIT=&DUNIT,VOL=SER=&DVOLSER,
//             SPACE=(TRK,(80,10,20)),DISP=(,CATLG),
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
 
       DEVINIT 480 X:\dirname\ISPOPT5.V0R9M00.HET READONLY=1
 
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
|         JCL Member: ISPOPT5.V0R9M00.CNTL($UP0900)                  |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//ISPOPT5U JOB (SYS),'Upgrade ISPOPT5',      <-- Review and Modify 
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  ISPOPT5 in MVS3.8J TSO / Hercules                   *
//* *                                                      *
//* *  JOB: $UP0902                                        *
//* *       Upgrade ISPOPT5 Software from release V0R9M00  *
//* *                                                      *
//* *       - No upgrade! INITIAL distribution             *
//* *                                                      *
//* -------------------------------------------------------*
//*
//UP00000  EXEC PGM=IEFBR14
//SYSPRINT DD  SYSOUT=*
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
 
       - Initial distribution, no updates available!

 
    d) After upgrade is applied, proceed to validation, STEP 11.
 
 
+--------------------------------------------------------------------+
| Step 7. Install TSO parts                                          |
+--------------------------------------------------------------------+
|         JCL Member: ISPOPT5.V0R9M00.CNTL($INST03)                  |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//ISPOPT53 JOB (SYS),'Install TSO Parts',    <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  ISPOPT5 for MVS3.8J TSO / Hercules                  *
//* *                                                      *
//* *  JOB: $INST03  Install TSO parts                     *
//* *  - C$IPSOP5 clist   installs to SYS2.CMDPROC         *
//* *                                                      *
//* *  Note: Duplicate members are over-written.           *
//* -------------------------------------------------------*
//STEP001  EXEC PGM=IEBCOPY                                           
//SYSPRINT DD  SYSOUT=*                                              
//INCLIST  DD  DSN=ISPOPT5.V0R9M00.CLIST,DISP=SHR            
//INHELP   DD  DSN=ISPOPT5.V0R9M00.HELP,DISP=SHR             
//INPROC   DD  DSN=ISPOPT5.V0R9M00.CLIST,DISP=SHR            
//OUTCLIST DD  DSN=SYS2.CMDPROC,DISP=SHR                               
//OUTHELP  DD  DSN=SYS2.HELP,DISP=SHR
//OUTPROC  DD  DSN=SYS2.PROCLIB,DISP=SHR
//SYSIN    DD  *                                                        
    COPY INDD=((INCLIST,R)),OUTDD=OUTCLIST
    SELECT MEMBER=C$ISPOP5
    SELECT MEMBER=CFLDSI
    SELECT MEMBER=CLDSI
    COPY INDD=((INHELP,R)),OUTDD=OUTHELP
    SELECT MEMBER=CFLDSI
    SELECT MEMBER=CLDSI
    SELECT MEMBER=CUTIL00
    SELECT MEMBER=LISTDSJ
    COPY INDD=((INPROC,R)),OUTDD=OUTPROC
    SELECT MEMBER=GCCISP5
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
| Step 8. Install ISPOPT5 Programs                                   |  
+--------------------------------------------------------------------+
|         JCL Member: ISPOPT5.V0R9M00.CNTL($INST04)                  |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//ISPOPT54 JOB (SYS),'Install ISPOPT5',      <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  ISPOPT5 for MVS3.8J TSO / Hercules                  *
//* *                                                      *
//* *  JOB: $INST04  Install Programs                      *
//* *       Install ISPOPT5 Programs                       *
//* *                                                      *
//* *  - Install libraries marked...                       *
//* *    - Search for '<--TARGET'                          *
//* *    - Update install libraries per your               *
//* *      installation standard                           *
//* *                                                      *
//* -------------------------------------------------------*
//*
//*
//* -------------------------------------------------------*
//* *  IEFBR14                                             *
//* -------------------------------------------------------*
//DUMMY    EXEC PGM=IEFBR14
//SYSPRINT DD   SYSOUT=*
//*
// 
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
|         JCL Member: ISPOPT5.V0R9M00.CNTL($INST05)                  |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//ISPOPT55 JOB (SYS),'Install ISPF Parts',   <-- Review and Modify 
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  ISPOPT5 for MVS3.8J TSO / Hercules                  *
//* *                                                      *
//* *  JOB: $INST05  Install ISPF parts                    *
//* *                                                      *
//* *  Note: Duplicate members are over-written.           *
//* *                                                      *
//* *  - Uses ISPF 2.1 product from Wally Mclaughlin       *
//* *  - Install libraries marked...                       *
//* *    - Search for '<--TARGET'                          *
//* *    - Update install libraries per your               *
//* *      installation standard                           *
//* *                                                      *
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
//ISPF     EXEC PARTSI,HLQ=ISPOPT5,VRM=V0R9M00,
//         CLIB='XXXXXXXX.ISPCLIB',                <--TARGET
//         MLIB='XXXXXXXX.ISPMLIB',                <--TARGET
//         PLIB='XXXXXXXX.ISPPLIB',                <--TARGET
//         SLIB='XXXXXXXX.ISPSLIB',                <--TARGET
//         TLIB='XXXXXXXX.ISPTLIB'                 <--TARGET
//ADDCLIB.SYSIN    DD  *                  CLIB
   COPY INDD=((CLIBIN,R)),OUTDD=CLIBOUT
   SELECT MEMBER=CBGIJCL0
   SELECT MEMBER=CBGIQGO
   SELECT MEMBER=CBGLLIBS 
   SELECT MEMBER=CBGVALIN 
   SELECT MEMBER=CBGP5    
   SELECT MEMBER=CBGP51   
   SELECT MEMBER=CBGP52   
   SELECT MEMBER=CBGP53   
   SELECT MEMBER=CBGP54   
   SELECT MEMBER=CBGP55   
   SELECT MEMBER=CBGP56   
   SELECT MEMBER=CBGP57   
   SELECT MEMBER=CBGP58   
   SELECT MEMBER=CBGP59   
   SELECT MEMBER=CBGP5A   
   SELECT MEMBER=CBGP5B   
   SELECT MEMBER=CBGP5C   
   SELECT MEMBER=CBGP5D   
   SELECT MEMBER=CBGP5E   
   SELECT MEMBER=CBGP5F   
   SELECT MEMBER=CBGP5G   
   SELECT MEMBER=CBGP5H   
   SELECT MEMBER=CBGP5I   
//ADDMLIB.SYSIN    DD  *                  MLIB
   COPY INDD=((MLIBIN,R)),OUTDD=MLIBOUT
   SELECT MEMBER=BGOPT0 
   SELECT MEMBER=BGOPT1 
   SELECT MEMBER=BGOPT5 
   SELECT MEMBER=BGOPT55
//ADDPLIB.SYSIN    DD  *                  PLIB
   COPY INDD=((PLIBIN,R)),OUTDD=PLIBOUT
   SELECT MEMBER=HSPOPT5  
   SELECT MEMBER=HSPOPT51 
   SELECT MEMBER=HSPOPT52 
   SELECT MEMBER=HSPOPT53 
   SELECT MEMBER=HSPOPT54 
   SELECT MEMBER=HSPOPT55 
   SELECT MEMBER=HSPOPT56 
   SELECT MEMBER=HSPOPT57 
   SELECT MEMBER=HSPOPT58 
   SELECT MEMBER=HSPOPT59 
   SELECT MEMBER=HSPOPT5A 
   SELECT MEMBER=HSPOPT5B 
   SELECT MEMBER=HSPOPT5C 
   SELECT MEMBER=HSPOPT5D 
   SELECT MEMBER=HSPOPT5E 
   SELECT MEMBER=HSPOPT5F 
   SELECT MEMBER=HSPOPT5G 
   SELECT MEMBER=HSPOPT5H 
   SELECT MEMBER=HSPOPT5I 
   SELECT MEMBER=ISPOPT5  
   SELECT MEMBER=ISPOPT51 
   SELECT MEMBER=ISPOPT52 
   SELECT MEMBER=ISPOPT53 
   SELECT MEMBER=ISPOPT54 
   SELECT MEMBER=ISPOPT55 
   SELECT MEMBER=ISPOPT56 
   SELECT MEMBER=ISPOPT57 
   SELECT MEMBER=ISPOPT58 
   SELECT MEMBER=ISPOPT59 
   SELECT MEMBER=ISPOPT5A 
   SELECT MEMBER=ISPOPT5B 
   SELECT MEMBER=ISPOPT5C 
   SELECT MEMBER=ISPOPT5D 
   SELECT MEMBER=ISPOPT5E 
   SELECT MEMBER=ISPOPT5F 
   SELECT MEMBER=ISPOPT5G 
   SELECT MEMBER=ISPOPT5H 
   SELECT MEMBER=ISPOPT5I 
   SELECT MEMBER=ISPOPT5X 
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
| Step 10. Install Other Program(s)                                  |  
+--------------------------------------------------------------------+
|         JCL Member: ISPOPT5.V0R9M00.CNTL($INST40)                  |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//ISPOP540 JOB (SYS),'Install Other Pgms',   <-- Review and Modify 
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  ISPOPT5 for MVS3.8J TSO / Hercules                  *
//* *                                                      *
//* *  JOB: $INST40  Install Other Components              *
//* *                                                      *
//* *       Install PUTCARD  Programs                      *
//* *       Install CUTIL00  Programs                      *
//* *       Install LISTDSJ  Programs                      *
//* *       **Note: CUTIL00 and LISTSDJ                    *
//* *               require two user-mods                  *
//* *               ZP60014 and ZP60038.                   *
//* *               Refer to program documenation          *
//* *               or pre-reqs documenation.              *
//* *                                                      *
//* *  - PUTCARD  programs installs to ISPLLIB             *
//* *  - CUTIL00  programs installs to SYS2.CMDLIB         *
//* *  - LISTDSJ  program  installs to SYS2.CMDLIB         *
//* *  - Install libraries marked...                       *
//* *    - Search for '<--TARGET'                          *
//* *    - Update install libraries per your               *
//* *      installation standard                           *
//* *                                                      *
//* -------------------------------------------------------*
//*
//* -------------------------------------------------------*
//* *                                                      *
//* *  PROC: ASMLKED                                       *
//* *       Assembler Link-Edit                            *
//* *                                                      *
//* -------------------------------------------------------*
//ASML     PROC HLQ=WHATHLQ,VRM=VXRXMXX,
//             MBR=WHOWHAT
//*
//ASM      EXEC PGM=IFOX00,
//             PARM='NODECK,LOAD,RENT,TERM,XREF'
//SYSGO    DD  DSN=&&LOADSET,DISP=(MOD,PASS),SPACE=(CYL,(1,1)),
//             UNIT=VIO,DCB=(DSORG=PS,RECFM=FB,LRECL=80,BLKSIZE=800)
//SYSLIB   DD  DSN=SYS1.MACLIB,DISP=SHR
//         DD  DSN=SYS1.AMODGEN,DISP=SHR
//         DD  DSN=SYS2.MACLIB,DISP=SHR          ** YREG  **
//         DD  DSN=&HLQ..&VRM..MACLIB,DISP=SHR   * myMACLIB **
//SYSTERM  DD  SYSOUT=*
//SYSPRINT DD  SYSOUT=*
//SYSPUNCH DD  DSN=NULLFILE
//SYSUT1   DD  UNIT=VIO,SPACE=(CYL,(6,1))
//SYSUT2   DD  UNIT=VIO,SPACE=(CYL,(6,1))
//SYSUT3   DD  UNIT=VIO,SPACE=(CYL,(6,1))
//SYSIN    DD  DSN=&HLQ..&VRM..ASM(&MBR),DISP=SHR <--INPUT
//*
//LKED     EXEC PGM=IEWL,PARM='MAP,LIST,LET,RENT,XREF',
//             COND=(0,NE,ASM)
//SYSLIN   DD  DSN=&&LOADSET,DISP=(OLD,DELETE)
//         DD  DDNAME=SYSIN
//SYSLMOD  DD  DUMMY
//SYSPRINT DD  SYSOUT=*
//SYSUT1   DD  UNIT=VIO,SPACE=(CYL,(5,2))
//SYSIN    DD  DUMMY
//*
//         PEND
//*
//* -------------------------------------------------------*
//* *  Assemble Link-Edit PUTCARD to ISPLLIB               *
//* -------------------------------------------------------*
//PUTCARD  EXEC  ASML,HLQ=ISPOPT5,VRM=V0R9M00,MBR=PUTCARD,
//         PARM.ASM='OBJECT,NODECK,XREF,TERM',
//         PARM.LKED='LET,LIST,MAP,XREF,SIZE=(900K,124K)'
//LKED.SYSLMOD DD  DISP=SHR,
//         DSN=XXXXXXXX.ISPLLIB(&MBR)             <--TARGET 
//*
//* -------------------------------------------------------*
//* *  Assemble Link-Edit CUTILTBL to SYS2.CMDLIB          *
//* -------------------------------------------------------*
//CUTILTBL EXEC  ASML,HLQ=ISPOPT5,VRM=V0R9M00,MBR=CUTILTBL, 
//         PARM.LKED='MAP,LIST,LET,RENT,XREF,REUS,REFR'
//LKED.SYSLMOD DD  DISP=SHR,
//         DSN=SYS2.CMDLIB(&MBR)                  <--TARGET 
//*
//* -------------------------------------------------------*
//* *  Assemble Link-Edit CUTIL00 to SYS2.CMDLIB           *
//* -------------------------------------------------------*
//CUTIL00  EXEC  ASML,HLQ=ISPOPT5,VRM=V0R9M00,MBR=CUTIL00,
//         PARM.LKED='MAP,LIST,LET,RENT,XREF,REUS,REFR'
//LKED.SYSLMOD DD  DISP=SHR,
//         DSN=SYS2.CMDLIB(&MBR)                  <--TARGET 
//LKED.SYSLIB  DD  DISP=SHR,
//         DSN=SYS2.CMDLIB
//*
//* -------------------------------------------------------*
//* *  Assemble Link-Edit LISTDSJ to SYS2.CMDLIB           *
//* -------------------------------------------------------*
//LISTDSJ  EXEC  ASML,HLQ=ISPOPT5,VRM=V0R9M00,MBR=LISTDSJ,
//         PARM.LKED='MAP,LIST,LET,RENT,XREF,REUS,REFR'
//LKED.SYSLMOD DD  DISP=SHR,
//         DSN=SYS2.CMDLIB                        <--TARGET 
//LKED.SYSIN   DD  *
 ALIAS LISTDSI
 NAME LISTDSJ(R)
/*
//*
//* -------------------------------------------------------*
//* *                                                      *
//* *  If SYSn.LINKLIB or SYSn.CMDLIB is updated           *
//* *                                                      *
//* -------------------------------------------------------*
//DBSTOP   EXEC DBSTOP,
//             COND=(0,NE)               
//DBSTART  EXEC DBSTART,
//             COND=(0,NE)                
// 
______________________________________________________________________
Figure 9: $INST40 JCL
 
 
    a) Member $INST40 installs additional programs.
 
       Note:  If no other programs are included for this distribution,
       -----  an IEFBR14 step is executed.
 
    b) Review and update JOB statement and other JCL to conform to your
       installation standard.                                       
 
    c) Submit the job.
 
    d) Review job output for successful completion.
 
 
+--------------------------------------------------------------------+
| Step 11. Validate ISPOPT5                                          |
+--------------------------------------------------------------------+
 
 
    This validation will submit a Hello World Fortran compile JOB for
    batch processing.
 
 
    a) Run JOB to declare a temporary OBJ PDS for validation.  The JCL
       is located at:

            ISPOPT5.V0R9M00.CNTL($INST99)  
        
       Check for successful completion.
        
    b) From the ISPF Main Menu, enter the following command:
       TSO C$ISPOP5
 
    c) Press ENTER.                       
 
    d) Panel ISPOPT5 is displayed.                                  
 
________________________________________________________________________________
 -----------------------  Background Selection Menu  ---------------------------
 SELECT OPTION ===> 3                                                           
                                                                                
    1 - Assembler          A - RPG                J - TBD               yourid  
    2 - OS/VS Cobol        B - Simula             K - TBD               ISPOPT5 
    3 - Fortran IV         C - SNOBOL             L - TBD                       
    4 - Mortran            D - WATFIV                                           
    5 - PL/I               E - XPL                                              
    6 - Linkage Editor     F - SPITBOL                                          
    7 - ASSIST             G - GCC                                              
    8 - ALGOL              H - PL360                                            
    9 - Pascal             I - BASIC 360                                        
                                                                                
                                                                                
                                                                                
 Source DATA online ===> Y   (Y/N)     Delete SUBMIT JCL ===> Y   (Y/N)         
 USING ===> yourid.CARDS.Dyyjjj.Thhmmss                                        
 JOB STATEMENT INFORMATION:  (Verify before proceeding)                         
   ===> //youridA JOB (SYS),'BG-SUB',CLASS=A,MSGCLASS=A,                   
   ===> //   MSGLEVEL=(1,1),NOTIFY=yourid,REGION=0M                            
   ===>                                                                         
   ===>                                                                         
 
 
________________________________________________________________________________
Figure 10a: Background Selection Menu
 
    e) Referring to the above panel:
 
        1. Enter  3 in SELECT OPTION         as shown
        2. Enter  Y in Source DATA online    as shown
        3. Enter  Y in Delete SUBMIT JCL     as shown
        4. Enter  JOB STATEMENT INFORMATION  as shown
        5. Press ENTER
        
    f) Panel ISPOPT53 (Fortran Compiler) is displayed:
 
________________________________________________________________________________
 ------------------------  BACKGROUND Fortran Compiler  ------------------------
 COMMAND ===>                                                                   
                                                                                
 ISPF Library:                                                          yourid  
    PROJECT ===> ISPOPT5                                                ISPOPT53
    LIBRARY ===> V0R9M00   ===>           ===>           ===>                   
    TYPE    ===> CNTL                                                           
    MEMBER  ===> HELLOFOR                                                       
                                                                                
 Other Partitioned or Sequential Data Set:                                      
    Data Set Name  . .                           
 *SYSLIBs are ignored...*                                                       
 Processor options:       Term ==>         QuikGO ==> Y    Process------------- 
  STEPLIB ==> SYSC.LINKLIB                                 1  1. FORTRAN IV G   
  List ID ==>          or SYSOUT class ==> *                  2. FORTRAN IV H   
  Parms   ==>                                                 3. n/a            
  SYSLIB1 ==>                                                                   
  SYSLIB2 ==>                                                                   
  SYSLIB3 ==>                                                                   
  SYSLIB4 ==>                                                                   
  MoreJCL ==>                                           
          ==>                                                                   
          ==>                                                                   
          ==>                                                                   
________________________________________________________________________________
Figure 10b: BACKGROUND Fortran Compiler Panel
 
    g) Referring to the above panel:
 
        1. Enter  ISPF Library information   as shown
        2. Enter  Y for Quik GO              as shown
        3. Enter  STEPLIB                    as shown
        4. Enter  1 for Process              as shown
        4. Enter  * for SYSOUT class         as shown
        5. Press ENTER
 
        
    f) Panel ISPOPT5X (Background Selection Menu) is displayed acknowledging
       JCL generation.
 
________________________________________________________________________________
 -----------------------  BACKGROUND SELECTION MENU  ---------------------------
 SELECT OPTION ===>                                                             
 BGOPT553 Fortran IV JCL generated for ISPOPT5.V0R9M00.CNTL(HELLOFOR)
    1 - Assembler          A - RPG                                      yourid  
    2 - OS/VS Cobol        B - Simula                                   ISPOPT5X
    3 - Fortran IV         C - SNOBOL                                           
    4 - Mortran            D - WATFIV                                           
    5 - PL/I               E - XPL                                              
    6 - Linkage Editor     F - SPITBOL                                          
    7 - ASSIST             G - GCC                                              
    8 - ALGOL              H - PL360                                            
    9 - Pascal             I - BASIC 360                                        
                                                                                
 Select OPTION to continue generating JCL                                       
 Enter CANCEL on OPTION LINE to EXIT without submitting JOB                     
 Press END KEY to submit JOB                                                    
 Source DATA online ===> Y   (Y/N)     Delete SUBMIT JCL ===> Y   (Y/N)         
 USING ===> yourid.CARDS.Dyyjjj.Thhmmss                                        
 JOB STATEMENT INFORMATION:                                                     
       //youridA  JOB (SYS),'BG PROCESS',CLASS=A,MSGCLASS=A,                    
       //   MSGLEVEL=(1,1),NOTIFY=&SYSUID,REGION=0M                             
       //                                                                       
       //                                                                       
                                                                                
________________________________________________________________________________
Figure 10c: Background Selection Menu
 
    g) Press PF3 to end batch selection and submit Fortran JOB for batch
       processing.
 
    h) Upon job completion, review the compile-n-go reports searching for
       HELLO WORLD message on a single page.
 
    i) Validation for ISPOPT5 is complete.
 
 
+--------------------------------------------------------------------+
| Step 12. Done                                                      |
+--------------------------------------------------------------------+
 
 
    a) Congratulations!  You completed the installation for ISPOPT5.


+--------------------------------------------------------------------+
| Step 13. Integrate ISPOPT5 into ISPF PRIMARY OPTION Menu           |
+--------------------------------------------------------------------+
 
 
    a) It is suggested using the existing option 5 in the PRIMARY OPTION MENU
       (panel ISP@PRIM).                           
                                                                     
    b) Create a copy of ISP@PRIM in your application panel library
       instead of the ISPF system panel library to preserve the original
       system panel in addition to preserving your ISP@PRIM changes      
       when upgrading your ISPF system with a new version.    
                                                                     
         5  BATCH       - Submit job for language processing  
 
    c) Add the 'COMMENT' and 'NEW ENTRY' lines as shown below to process
       the option 5:
                                                                          

       1       10        20        30        40        50        60        70
       +---+----+----+----+----+----+----+----+----+----+----+----+----+----+
       )PROC
         &ZSEL = TRANS( TRUNC (&ZCMD,'.')
                       0,'PANEL(ISPOP0)'                 
                       1,'PANEL(ISPREVB) NEWAPPL(ISR)'
                       .
                       .
       /*              5,'PGM(ISRJB1) PARM(ISRJPA) NOCHECK'      <-- COMMENT
                       5,'CMD(%CBGP5 ICMD(&ZCMD)) NEWAPPL(CBGP)' <-- NEW ENTRY
                       .
                       .
                       .
                     ' ',' '
                       *,'?' )
       )END
 
    e) Save PRIMARY OPTION MENU panel changes.

    f) Type =5 in the COMMAND line and press ENTER.

    g) The new Background Selection Menu should display.




Enjoy ISPOPT5 for ISPF 2.x on MVS 3.8J!
                                                                            

======================================================================
* IV. S o f t w a r e   I n v e n t o r y   L i s t                  |
======================================================================

  - ISPOPT5.V0R9M00.ASM 
   . CUTIL00     TSO CP for CLIST Variables
   . CUTILTBL    CUTIL00 messages program 
   . LISTDSJ     TSO CP LISTDSI-like program
   . PUTCARD     Write CARD images to PS file
    
  - ISPOPT5.V0R9M00.CLIST
   . C$ISPOP5    Validate BG Selection CLIST for IVP
   . CFLDSI      List session allocated datasets using LISTA and LISTDSI
   . CLDSI       List dataset attributes using LISTDSI
   . GCCISP5     GCC PROC used by GCC Compiler JCL Generation CLIST

  - ISPOPT5.V0R9M00.CNTL
   . $INST00     Define Alias for HLQ ISPOPT5       
   . $INST01     Load CNTL data set from distribution tape (HET)
   . $INST02     Load other data sets from distribution tape (HET)
   . $INST03     Install TSO Parts
   . $INST04     Install ISPOPT5 CP and utilities
   . $INST05     Install ISPF Parts
   . $INST40     Install Other programs                  
   . $INST99     Install OBJ PDS (for validation)      
   . $RECVXMI    Receive XMI SEQ to MVS PDSs via RECV370
   . $UP0900     Upgrade to V0R9M00   from   V0R9M00 (IEFBR14)
   . DSCLAIMR    Disclaimer
   . PREREQS     Required User-mods
   . README      Documentation and Installation instructions
   . HELLOFOR    Fortran HELLO WORLD program for validation 

  - ISPOPT5.V0R9M00.HELP
   . CUTIL00     Help file      
   . LISTDSI *   Help file(Alias)
   . LISTDSJ     Help file      
   . CFLDSI      Help file
   . CLDSI       Help file

  - ISPOPT5.V0R9M00.ISPF
   . HSPOPT5     Help Panel - Background Selection Menu
   . HSPOPT51    Help Panel - Assembler 
   . HSPOPT52    Help Panel - OS/VS Cobol
   . HSPOPT53    Help Panel - Fortran IV
   . HSPOPT54    Help Panel - Mortran
   . HSPOPT55    Help Panel - PL/I 
   . HSPOPT56    Help Panel - Linkage Editor
   . HSPOPT57    Help Panel - ASSIST
   . HSPOPT58    Help Panel - ALGOL
   . HSPOPT59    Help Panel - Pascal
   . HSPOPT5A    Help Panel - RPG
   . HSPOPT5B    Help Panel - Simula
   . HSPOPT5C    Help Panel - SNOBOL
   . HSPOPT5D    Help Panel - WATFIV
   . HSPOPT5E    Help Panel - XPL
   . HSPOPT5F    Help Panel - SPITBOL 370     
   . HSPOPT5G    Help Panel - GCC
   . HSPOPT5H    Help Panel - PL360
   . HSPOPT5I    Help Panel - BASIC 360
   . ISPOPT5     Panel - Background Selection Menu (initial)
   . ISPOPT51    Panel - Assembler        
   . ISPOPT52    Panel - OS/VS Cobol
   . ISPOPT53    Panel - Fortran IV
   . ISPOPT54    Panel - Mortran
   . ISPOPT55    Panel - PL/I 
   . ISPOPT56    Panel - Linkage Editor
   . ISPOPT57    Panel - ASSIST
   . ISPOPT58    Panel - ALGOL
   . ISPOPT59    Panel - Pascal
   . ISPOPT5A    Panel - RPG
   . ISPOPT5B    Panel - Simula
   . ISPOPT5C    Panel - SNOBOL
   . ISPOPT5D    Panel - WATFIV
   . ISPOPT5E    Panel - XPL
   . ISPOPT5F    Panel - SPILBOL 370
   . ISPOPT5G    Panel - GCC
   . ISPOPT5H    Panel - PL360
   . ISPOPT5I    Panel - BASIC 360
   . ISPOPT5X    Panel - Background Selection Menu
   . CBGIJCL0    CLIST - Insert Common Langauage Processor DD statements
   . CBGIQGO     CLIST - Insert Quick Loader step after processor
   . CBGLLIBS    CLIST - List Libraries            
   . CBGVALIN    CLIST - Validate Source, STEPLIB, SYSLIBs for existence
   . CBGP5       CLIST - Background Selection Driver
   . CBGP51      CLIST - Assembler XF, XF MACRO XREF, G Waterloo
   . CBGP52      CLIST - OS/VS Cobol
   . CBGP53      CLIST - Fortran IV F, G
   . CBGP54      CLIST - Mortran w Fortran IV F, G
   . CBGP55      CLIST - PL/I F
   . CBGP56      CLIST - Linkage Editor
   . CBGP57      CLIST - ASSIST
   . CBGP58      CLIST - ALGOL F, Algol 68
   . CBGP59      CLIST - Pascal 8000, Stonybrook, Stanford
   . CBGP5A      CLIST - RPG E MVT
   . CBGP5B      CLIST - Simula
   . CBGP5C      CLIST - SNOBOL
   . CBGP5D      CLIST - WATFIV
   . CBGP5E      CLIST - XPL Analyzer, Compile-Go
   . CBGP5F      CLIST - SPILBOL 370
   . CBGP5G      CLIST - GCC
   . CBGP5H      CLIST - PL360
   . CBGP5I      CLIST - BASIC 360
   . BGOPT0      Messages BGOPT00-BGOPT09
   . BGOPT1      Messages BGOPT10-BGOPT19
   . BGOPT5      Messages BGOPT50-BGOPT59
   . BGOPT55     Messages BGOPT551-BGOPT559
                
  - ISPOPT5.V0R9M00.MACLIB
   . README      Dummy member, this is intentional
       
       
  - After downloading any other required software, consult provided
    documentation including any configuration steps (if applicable)
    for software and HELP file installation. 
       
       
 $ - Denotes modified software component for THIS DISTRIBUTION               
     relative to prior DISTRIBUTION               
       
       
