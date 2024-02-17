CALNDR2 for MVS3.8J / Hercules                                               
==============================                                               


Date: 03/20/2022  Release V0R9M00

*  Author:  Larry Belmontes Jr.
*           https://ShareABitofIT.net/CALNDR2-in-MVS38J
*           Copyright (C) 2022  Larry Belmontes, Jr.


---------------------------------------------------------------------- 
|    CALNDR2      I n s t a l l a t i o n   R e f e r e n c e        | 
---------------------------------------------------------------------- 

   The approach for this installation procedure is to transfer the
distribution content from your personal computing device to MVS with
minimal JCL and to continue the installation procedure using supplied
JCL from the MVS CNTL data set under TSO.                         

   Below are descriptions of ZIP file content, pre-installation
requirements (notes, credits) and installation steps.
 
Good luck and enjoy this software as added value to MVS 3.8J!
-Larry Belmontes



======================================================================
* I. C o n t e n t   o f   Z I P   F i l e                           |
======================================================================

o  $INST00.JCL          Define Alias for HLQ CALNDR2 in Master Catalog
 
o  $INST01.JCL          Load CNTL data set from distribution tape
 
o  $RECVXMI.JCL         Receive XMI SEQ to MVS PDSs                  
 
o  CALNDR2.V0R9M00.HET Hercules Emulated Tape (HET) multi-file volume
                        with VOLSER of VS0900 containing software  
                        distribution.
 
o  RECVXMIT.V0R9M00.XMI XMIT file containing software distribution.   
 
o  DSCLAIMR.TXT         Disclaimer
 
o  PREREQS.TXT          Required user-mods 
 
o  README.TXT           This File                                              
 
 
Note:   CALNDRs must be installed as a pre-requisite due to use of
-----   selected components.
        More information at:
        https://www.shareabitofit.net/calndrs-in-mvs38j/
 
Note:   The appropriate compilers must be installed as a pre-requiste
-----   on your system (Fortran G, Fortran H, PL/I (F), GCC).
 
Note:   ISPF v2.1 or higher must be installed under MVS3.8J TSO             
-----   including associated user-mods per ISPF Installation Pre-reqs.
 

======================================================================
* II. P r e - i n s t a l l a t i o n   R e q u i r e m e n t s      |
======================================================================

o  The Master Catalog password may be required for some installation
   steps. 
 
o  Tape files use device 480.
 
o  As default, DASD files will be loaded to VOLSER=MVSDLB, type 3350 device.
    
   Below is a DATASET List after tape distribution load for reference purposes:
    
   DATA-SET-NAME------------------------------- VOLUME ALTRK USTRK ORG FRMT % XT
   CALNDR2.V0R9M00.ASM                          MVSDLB    80    22 PO  FB  27  1
   CALNDR2.V0R9M00.CLIST                        MVSDLB     4     1 PO  FB  25  1
   CALNDR2.V0R9M00.CNTL                         MVSDLB    20    11 PO  FB  55  1
   CALNDR2.V0R9M00.HELP                         MVSDLB     4     1 PO  FB  25  1
   CALNDR2.V0R9M00.ISPF                         MVSDLB    20     1 PO  FB   5  1
   CALNDR2.V0R9M00.MACLIB                       MVSDLB     2     1 PO  FB  50  1
   **END**    TOTALS:     130 TRKS ALLOC        37 TRKS USED       6 EXTENTS    
    
    
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
| Step 1. Define Alias for HLQ CALNDR2 in MVS User Catalog           |
+--------------------------------------------------------------------+
|         JCL Member: CALNDR2.V0R9M00.CNTL($INST00)                  |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//CALNDR20 JOB (SYS),'Def CALNDR2 Alias',   <-- Review and Modify 
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  CALNDR2 in MVS3.8J TSO / Hercules                   *
//* *  JOB: $INST00  Define Alias for HLQ CALNDR2          *
//* *  Note: The master catalog password will be required  *
//* -------------------------------------------------------*
//DEFALIAS EXEC PGM=IDCAMS 
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
 PARM GRAPHICS(CHAIN(SN))
 LISTCAT ALIAS  ENT(CALNDR2) 
  
 IF LASTCC NE 0 THEN -
    DEFINE ALIAS(NAME(CALNDR2) RELATE(SYS1.UCAT.MVS))                          
/*                                                                      
//
______________________________________________________________________
Figure 1: $INST00 JCL
 
 
    a) Copy and paste the above JCL to a PDS member, update JOB 
       statement to conform to your installation standard.             
 
    b) Submit the job.                                  
 
    c) Review job output for successful DEFINE ALIAS.
 
    Note: Job step DEFALIAS returns RC=0004 due to LISTCAT function
          completing with condition code of 4 and DEFINE ALIAS 
          function completing with condition code of 0.
           
 
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
|         JCL Member: CALNDR2.V0R9M00.CNTL($RECVXMI)                 |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//RECV000A JOB (SYS),'Receive CALNDR2 XMI',      <-- Review and Modify
//             CLASS=A,MSGCLASS=X,REGION=0M,     <-- Review and Modify
//             MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  JOB: $RECVXMI  Receive Application XMI Files        *
//* -------------------------------------------------------*
//RECV     PROC HLQ=CALNDR2,VRM=V0R9M00,TYP=XXXXXXXX,
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
//HELP     EXEC RECV,TYP=HELP,DSPACE='(TRK,(04,02,02))'
//CLIST    EXEC RECV,TYP=CLIST,DSPACE='(TRK,(04,02,02))'
//ISPF     EXEC RECV,TYP=ISPF,DSPACE='(TRK,(20,05,10))'
//ASM      EXEC RECV,TYP=ASM,DSPACE='(TRK,(80,10,10))'
//MACLIB   EXEC RECV,TYP=MACLIB,DSPACE='(TRK,(02,02,02))'
//
______________________________________________________________________
Figure 2: $RECVXMI.JCL
 
 
    a) Transfer CALNDR2.V0R9M00.XMI to MVS using your 3270 emulator.
       
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
 
       CALNDR2.V0R9M00.ASM   
       CALNDR2.V0R9M00.CLIST 
       CALNDR2.V0R9M00.CNTL  
       CALNDR2.V0R9M00.HELP  
       CALNDR2.V0R9M00.ISPF  
       CALNDR2.V0R9M00.MACLIB
 
    f) Subsequent installation steps will be submitted from members
       contained in the CNTL data set.
 
    g) Proceed to STEP 6.   ****
 
+--------------------------------------------------------------------+
| Step 4. Load CNTL data set from distribution tape                  |
+--------------------------------------------------------------------+
|         JCL Member: CALNDR2.V0R9M00.CNTL($INST01)                  |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//CALNDR21 JOB (SYS),'Install CNTL PDS',     <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  CALNDR2 for MVS3.8J TSO / Hercules                  *
//* *  JOB: $INST01  Load CNTL PDS from distribution tape  *
//* *  Note: Uses tape drive 480                           *
//* -------------------------------------------------------*
//LOADCNTL PROC HLQ=CALNDR2,VRM=V0R9M00,TVOLSER=VS0900,      
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
 
       DEVINIT 480 X:\dirname\CALNDR2.V0R9M00.HET READONLY=1
 
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
|         JCL Member: CALNDR2.V0R9M00.CNTL($INST02)                  |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//CALNDR22 JOB (SYS),'Install Other PDSs',   <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  CALNDR2 for MVS3.8J TSO / Hercules                  *
//* *  JOB: $INST02  Load other PDS from distribution tape *
//* *  Tape Volume:  File 1 - CNTL                         *
//* *                File 2 - CLIST                        *
//* *                File 3 - HELP                         *
//* *                File 4 - ISPF                         *
//* *                File 5 - ASM                          *
//* *                File 6 - MACLIB                       *
//* *  Note: Default TAPE=480, DASD=3350 on MVSDLB         *
//* -------------------------------------------------------*
//LOADOTHR PROC HLQ=CALNDR2,VRM=V0R9M00,TVOLSER=VS0900,            
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
//             SPACE=(TRK,(04,02,02)),DISP=(,CATLG),
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=3600) 
//HELP     DD  DSN=&HLQ..&VRM..HELP,UNIT=&DUNIT,VOL=SER=&DVOLSER,
//             SPACE=(TRK,(04,02,02)),DISP=(,CATLG),
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=3600) 
//ISPF     DD  DSN=&HLQ..&VRM..ISPF,UNIT=&DUNIT,VOL=SER=&DVOLSER,
//             SPACE=(TRK,(20,05,10)),DISP=(,CATLG),
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=3600) 
//ASM      DD  DSN=&HLQ..&VRM..ASM,UNIT=&DUNIT,VOL=SER=&DVOLSER,
//             SPACE=(TRK,(80,10,10)),DISP=(,CATLG),
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
 
       DEVINIT 480 X:\dirname\CALNDR2.V0R9M00.HET READONLY=1
 
       where X:\dirname is the complete path to the location
       of the Hercules Emulated Tape file. 
 
    d) Issue the following command from the MVS console to vary
       device 480 online:
 
       V 480,ONLINE
 
    e) Submit the job.
 
    f) Review job output for successful loads.  
 
 
+--------------------------------------------------------------------+
| Step 6. Install TSO parts                                          |
+--------------------------------------------------------------------+
|         JCL Member: CALNDR2.V0R9M00.CNTL($INST03)                  |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//CALNDR23 JOB (SYS),'Install TSO Parts',    <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  CALNDR2 for MVS3.8J TSO / Hercules                  *
//* *                                                      *
//* *  JOB: $INST03  Install TSO parts                     *
//* *                                                      *
//* *  Note: Duplicate members are over-written.           *
//* -------------------------------------------------------*
//STEP001  EXEC PGM=IEBCOPY                                           
//SYSPRINT DD  SYSOUT=*                                              
//INCLIST  DD  DSN=CALNDR2.V0R9M00.CLIST,DISP=SHR            
//INHELP   DD  DSN=CALNDR2.V0R9M00.HELP,DISP=SHR             
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
Figure 5: $INST03 JCL
 
 
    a) Member $INST03 installs TSO component(s).
 
       Note:  If no TSO components are included for this distribution,
       -----  RC = 4 is returned by the corresponding IEBCOPY step.
 
    b) Review and update JOB statement and other JCL to conform to your
       installation standard.                                       
 
    c) Submit the job.
 
    d) Review job output for successful load(s).
 
 
+--------------------------------------------------------------------+
| Step 7. Install CALNDR2 Programs                                   |  
+--------------------------------------------------------------------+
|         JCL Member: CALNDR2.V0R9M00.CNTL($INST04)                  |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//CALNDR24 JOB (SYS),'Install CALNDR2',      <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  CALNDR2 for MVS3.8J TSO / Hercules                  *
//* *                                                      *
//* *  JOB: $INST04                                        *
//* *       Install CALNDR2 Programs                       *
//* *                                                      *
//* *  - Install libraries marked...                       *
//* *    - Search for '<--TARGET'                          *
//* *    - Update install libraries per your               *
//* *      installation standard                           *
//* *  - ISPF System Library marked...                     *
//* *    - Search for '<--ISPF SYS LLIB'                   *
//* *    - Update system library per your                  *
//* *      installation standard                           *
//* *  - Compiler STEPLIBs marked...                       *
//* *    - Search for '<--Complr STEPLIB'                  *
//* *    - Update compiler STEPLIB per your                *
//* *      installation standard                           *
//* *  - Compiler Run-time libraries marked...             *
//* *    - Search for '<--RUN-TIME Lib'                    *
//* *    - Update compiler RUN-TIME library per your       *
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
//* -------------------------------------------------------*
//* *                                                      *
//* *  PROC: FGLKED                                        *
//* *       Fortran G Link-Edit                            *
//* *                                                      *
//* -------------------------------------------------------*
//FGL      PROC HLQ=WHATHLQ,VRM=VXRXMXX,
//             MBR=WHOWHAT
//*
//FORT     EXEC PGM=IEYFORT,REGION=100K                                 
//STEPLIB  DD  DUMMY
//SYSPRINT DD  SYSOUT=*                                                 
//SYSPUNCH DD  DSN=NULLFILE                                             
//SYSLIN   DD  DSNAME=&LOADSET,DISP=(MOD,PASS),UNIT=SYSSQ,             *
//             SPACE=(80,(200,100),RLSE),DCB=BLKSIZE=80                 
//SYSIN    DD  DSN=&HLQ..&VRM..ASM(&MBR),DISP=SHR <--INPUT
//*
//LKED EXEC PGM=IEWL,REGION=96K,PARM=(XREF,LET,LIST),COND=(4,LT,FORT)   
//SYSLIB   DD  DUMMY                            
//SYSLMOD  DD  DUMMY
//SYSPRINT DD  SYSOUT=*                                                 
//SYSUT1   DD  UNIT=SYSDA,SPACE=(1024,(100,10),RLSE),DCB=BLKSIZE=1024, *
//             DSNAME=&SYSUT1                                           
//SYSLIN   DD  DSNAME=&LOADSET,DISP=(OLD,DELETE)                        
//         DD  DDNAME=SYSIN                                             
//SYSIN    DD  DUMMY
//*
//         PEND
//* -------------------------------------------------------*
//* *                                                      *
//* *  PROC: FHLKED                                        *
//* *       Fortran H Link-Edit                            *
//* *                                                      *
//* -------------------------------------------------------*
//FHL      PROC HLQ=WHATHLQ,VRM=VXRXMXX,
//             MBR=WHOWHAT
//*
//FORT     EXEC PGM=IEKAA00,REGION=228K                           
//STEPLIB  DD  DUMMY
//SYSPRINT DD  SYSOUT=*                                                 
//SYSPUNCH DD  DSN=NULLFILE                                             
//SYSLIN   DD  DSNAME=&LOADSET,UNIT=SYSSQ,DISP=(MOD,PASS),             *
//             SPACE=(400,(200,50),RLSE)                                
//SYSIN    DD  DSN=&HLQ..&VRM..ASM(&MBR),DISP=SHR <--INPUT
//*
//LKED EXEC PGM=IEWL,REGION=96K,PARM=(XREF,LET,LIST),COND=(4,LT,FORT)   
//SYSLIB   DD  DUMMY                            
//SYSLMOD  DD  DUMMY
//SYSPRINT DD  SYSOUT=*                                                 
//SYSUT1   DD  UNIT=SYSDA,SPACE=(1024,(200,20),RLSE),DCB=BLKSIZE=1024, *
//             DSNAME=&SYSUT1                                           
//SYSLIN   DD  DSNAME=&LOADSET,DISP=(OLD,DELETE)                        
//         DD  DDNAME=SYSIN                                             
//SYSIN    DD  DUMMY
//*
//         PEND
//* -------------------------------------------------------*
//* *                                                      *
//* *  PROC: PLIFLKED                                      *
//* *       PL/I (F)  Link-Edit                            *
//* *                                                      *
//* -------------------------------------------------------*
//PLIFL    PROC HLQ=WHATHLQ,VRM=VXRXMXX,
//             MBR=WHOWHAT
//*                                                       
//PL1L     EXEC PGM=IEMAA,PARM='LOAD,NODECK',REGION=128K           
//SYSPRINT DD  SYSOUT=*                                                 
//SYSPUNCH DD  DSN=NULLFILE                                             
//SYSLIN   DD  DSNAME=&&LOADSET,DISP=(MOD,PASS),UNIT=SYSDA,            *
//             SPACE=(80,(250,100))                                     
//SYSUT3   DD  DSNAME=&&SYSUT3,UNIT=SYSDA,SPACE=(80,(250,250)),        *
//             DCB=BLKSIZE=80                                           
//SYSUT1   DD  DSNAME=&&SYSUT1,UNIT=SYSDA,SPACE=(1024,(60,60),,CONTIG),*
//             SEP=(SYSUT3,SYSLIN),DCB=BLKSIZE=1024                     
//SYSIN    DD  DSN=&HLQ..&VRM..ASM(&MBR),DISP=SHR <--INPUT
//*
//LKED     EXEC PGM=IEWL,REGION=96K,PARM=(XREF,LIST),COND=(9,LT,PL1L)   
//SYSLIB   DD  DUMMY                            
//SYSLMOD  DD  DUMMY
//SYSPRINT DD  SYSOUT=*                                                 
//SYSUT1   DD  UNIT=SYSDA,SPACE=(1024,(200,20),RLSE),DCB=BLKSIZE=1024, *
//             DSNAME=&SYSUT1                                           
//SYSLIN   DD  DSNAME=&LOADSET,DISP=(OLD,DELETE)                        
//         DD  DDNAME=SYSIN                                             
//SYSIN    DD  DUMMY
//*
//         PEND
//* -------------------------------------------------------*
//* *                                                      *
//* *  PROC: GCCLKED                                       *
//* *       GCC MVS   Link-Edit                            *
//* *                                                      *
//* -------------------------------------------------------*
//GCCL     PROC HLQ=WHATHLQ,VRM=VXRXMXX,
//             MBR=WHOWHAT,
//             SOUT='*',                     
//             PDPPREF='PDPCLIB',            
//             COPTS='-S -v',                   
//             COS1='-ansi -pedantic-errors',
//             COS2='-o dd:out -',           
//             INFILE='',                    
//             OUTFILE=''                    
//*
//GCC      EXEC PGM=GCC,REGION=4096K,                         
// PARM='&COS1 &COPTS &COS2'                                  
//STEPLIB  DD  DUMMY           
//*                                                           
//* INCLUDE SHOULD HAVE YOUR OWN HEADERS ADDED                
//*                                                           
//INCLUDE  DD DSN=&PDPPREF..INCLUDE,DISP=SHR,DCB=BLKSIZE=32720
//SYSINCL  DD DSN=&PDPPREF..INCLUDE,DISP=SHR,DCB=BLKSIZE=32720
//SYSIN    DD DSN=&INFILE,DISP=SHR                            
//OUT      DD DSN=&&TEMP,DISP=(,PASS),UNIT=SYSALLDA,          
//            DCB=(LRECL=80,BLKSIZE=6160,RECFM=FB),           
//            SPACE=(6160,(500,500))                          
//SYSPRINT DD SYSOUT=&SOUT                                    
//SYSTERM  DD SYSOUT=&SOUT                                    
//*                                                           
//ASM      EXEC PGM=IFOX00,                                   
//            PARM='DECK,NOLIST',                             
//            COND=(4,LT,GCC)                                 
//SYSLIB   DD DSN=SYS1.MACLIB,DISP=SHR,DCB=BLKSIZE=32720      
//         DD DSN=&PDPPREF..MACLIB,DISP=SHR                   
//SYSUT1   DD UNIT=SYSALLDA,SPACE=(CYL,(20,10))               
//SYSUT2   DD UNIT=SYSALLDA,SPACE=(CYL,(10,10))               
//SYSUT3   DD UNIT=SYSALLDA,SPACE=(CYL,(10,10))               
//SYSPRINT DD SYSOUT=&SOUT                                      
//SYSLIN   DD DUMMY                                             
//SYSGO    DD DUMMY                                             
//SYSPUNCH DD DSN=&&OBJSET,UNIT=SYSALLDA,SPACE=(80,(200,200)),  
//            DISP=(,PASS)                                      
//SYSIN    DD DSN=&&TEMP,DISP=(OLD,DELETE)                      
//*                                                             
//LKED     EXEC PGM=IEWL,PARM='&LOPTS',                         
//         COND=((4,LT,GCC),(4,LT,ASM))                         
//SYSLIN   DD DSN=&&OBJSET,DISP=(OLD,DELETE)                    
//         DD DDNAME=SYSIN                                      
//SYSIN    DD DUMMY                                             
//SYSLIB   DD DSN=&PDPPREF..NCALIB,DISP=SHR                     
//SYSLMOD  DD DSN=&OUTFILE,                                     
//            DISP=SHR                                          
//SYSUT1   DD UNIT=SYSALLDA,SPACE=(CYL,(2,1))                   
//SYSPRINT DD SYSOUT=&SOUT                                      
//*
//         PEND
//*
//* -------------------------------------------------------*
//* *  Assemble Link-Edit LBCC2I  to ISPLLIB               *
//* -------------------------------------------------------*
//LBCC2I  EXEC   ASML,HLQ=CALNDR2,VRM=V0R9M00,MBR=LBCC2I, 
//         PARM.ASM='NODECK,LOAD,TERM,XREF',
//         PARM.LKED='MAP,LIST,LET,XREF'
//LKED.SYSLMOD DD  DISP=SHR,
//         DSN=XXXXXXXX.ISPLLIB(&MBR)                <--TARGET 
//*
//* -------------------------------------------------------*
//* *  Assemble Link-Edit LBCI2C  to ISPLLIB               *
//* -------------------------------------------------------*
//LBCI2C  EXEC   ASML,HLQ=CALNDR2,VRM=V0R9M00,MBR=LBCI2C, 
//         PARM.ASM='NODECK,LOAD,TERM,XREF',
//         PARM.LKED='MAP,LIST,LET,XREF'
//LKED.SYSLMOD DD  DISP=SHR,
//         DSN=XXXXXXXX.ISPLLIB(&MBR)                <--TARGET 
//*
//* -------------------------------------------------------*
//* *  Assemble Link-Edit LBISPL  to ISPLLIB               *
//* -------------------------------------------------------*
//LBISPL  EXEC   ASML,HLQ=CALNDR2,VRM=V0R9M00,MBR=LBISPL, 
//         PARM.ASM='NODECK,LOAD,TERM,XREF,RENT',
//         PARM.LKED='MAP,LIST,LET,RENT,XREF,REUS,REFR'
//LKED.SYSLMOD DD  DISP=SHR,
//         DSN=XXXXXXXX.ISPLLIB(&MBR)                <--TARGET 
//LKED.SYSLIB DD DSNAME=ISP.V2R2M0.LLIB,DISP=SHR     <--ISPF SYS LLIB
//*
//* -------------------------------------------------------*
//* *  Assemble Link-Edit LBWTRM  to ISPLLIB               *
//* -------------------------------------------------------*
//LBWTRM  EXEC   ASML,HLQ=CALNDR2,VRM=V0R9M00,MBR=LBWTRM, 
//         PARM.ASM='NODECK,LOAD,TERM,XREF',
//         PARM.LKED='MAP,LIST,LET,XREF'
//LKED.SYSLMOD DD  DISP=SHR,
//         DSN=XXXXXXXX.ISPLLIB(&MBR)                <--TARGET 
//*
//* -------------------------------------------------------*
//* *  Assemble Link-Edit LBWTRMP to ISPLLIB               *
//* -------------------------------------------------------*
//LBWTRMP EXEC   ASML,HLQ=CALNDR2,VRM=V0R9M00,MBR=LBWTRMP,
//         PARM.ASM='NODECK,LOAD,TERM,XREF',
//         PARM.LKED='MAP,LIST,LET,XREF'
//LKED.SYSLMOD DD  DISP=SHR,
//         DSN=XXXXXXXX.ISPLLIB(&MBR)                <--TARGET 
//*
//* -------------------------------------------------------*
//* *  Fortran G Link-Edit CALNDRFG to ISPLLIB             *
//* -------------------------------------------------------*
//CALNDRFG EXEC FGL,HLQ=CALNDR2,VRM=V0R9M00,MBR=CALNDRFG,
//         PARM.FORT='LIST,MAP',
//         PARM.LKED='MAP,LIST,LET,XREF'
//FORT.STEPLIB DD DSN=SYSC.LINKLIB,DISP=SHR          <--Complr STEPLIB
//LKED.SYSLIB DD DSNAME=SYSC.FORTLIB,DISP=SHR        <--RUN-TIME Lib
//            DD DSNAME=XXXXXXXX.ISPLLIB,DISP=SHR    <--Subroutines
//            DD DSNAME=ISP.V2R2M0.LLIB,DISP=SHR     <--ISPF SYS LLIB
//LKED.SYSLMOD DD  DISP=SHR,
//         DSN=XXXXXXXX.ISPLLIB(&MBR)                <--TARGET 
//*
//* -------------------------------------------------------*
//* *  Fortran H Link-Edit CALNDRFH to ISPLLIB             *
//* -------------------------------------------------------*
//CALNDRFH EXEC FHL,HLQ=CALNDR2,VRM=V0R9M00,MBR=CALNDRFH,
//         PARM.FORT='LIST,MAP',
//         PARM.LKED='MAP,LIST,LET,XREF'
//FORT.STEPLIB DD DSN=SYSC.LINKLIB,DISP=SHR          <--Complr STEPLIB
//LKED.SYSLIB DD DSNAME=SYSC.FORTLIB,DISP=SHR        <--RUN-TIME Lib
//            DD DSNAME=XXXXXXXX.ISPLLIB,DISP=SHR    <--Subroutines
//            DD DSNAME=ISP.V2R2M0.LLIB,DISP=SHR     <--ISPF SYS LLIB
//LKED.SYSLMOD DD  DISP=SHR,
//         DSN=XXXXXXXX.ISPLLIB(&MBR)                <--TARGET 
//*
//* -------------------------------------------------------*
//* *  PL/I (F)  Link-Edit CALNDRP  to ISPLLIB             *
//* -------------------------------------------------------*
//CALNDRP  EXEC PLIFL,HLQ=CALNDR2,VRM=V0R9M00,MBR=CALNDRP, 
//    PARM.PL1L='LOAD,NODECK,XREF,EXTREF,LIST,ATR,SOURCE2',
//    PARM.LKED='MAP,LIST,LET,XREF'
//PL1L.STEPLIB DD DSN=SYSC.LINKLIB,DISP=SHR          <--Complr STEPLIB 
//LKED.SYSLIB DD DSNAME=SYSC.PL1LIB,DISP=SHR         <--RUN-TIME Lib
//            DD DSNAME=XXXXXXXX.ISPLLIB,DISP=SHR    <--Subroutines
//            DD DSNAME=ISP.V2R2M0.LLIB,DISP=SHR     <--ISPF SYS LLIB
//LKED.SYSLMOD DD  DISP=SHR,
//         DSN=XXXXXXXX.ISPLLIB(&MBR)                <--TARGET 
//*
//* -------------------------------------------------------*
//* *  GCC MVS   Link-Edit CALNDRGC to ISPLLIB             *
//* -------------------------------------------------------*
//CALNDRGC EXEC GCCL,HLQ=CALNDR2,VRM=V0R9M00,MBR=CALNDRGC,
//     PARM.ASM='DECK,LIST', 
//     PARM.LKED='MAP,XREF,LET,LIST' 
//GCC.STEPLIB DD DSN=SYS2.GCC.LINKLIBN,DISP=SHR      <--Complr STEPLIB
//GCC.SYSIN DD DSN=&HLQ..&VRM..ASM(&MBR),DISP=SHR 
//LKED.SYSLIB DD                                     
//            DD DSNAME=XXXXXXXX.ISPLLIB,DISP=SHR    <--Subroutines
//            DD DSNAME=ISP.V2R2M0.LLIB,DISP=SHR     <--ISPF SYS LLIB
//LKED.SYSLMOD DD  DISP=SHR,
//         DSN=XXXXXXXX.ISPLLIB(&MBR)                <--TARGET 
// 
______________________________________________________________________
Figure 6: $INST04 JCL
 
 
    a) Member $INST04 installs program(s).
 
    b) Review and update JOB statement and other JCL to conform to your
       installation standard.                                       
 
    c) Submit the job.
 
    d) Review job output for successful completion.
 
       Below is a JOB LOG of all steps and return codes for $INST04
       for comparison purposes:

  15.09.01 JOB 2897 $HASP373 CALNDR24 STARTED - INIT 1 - CLASS A - SYS BSP1
  15.09.01 JOB 2897 IEF403I CALNDR24 - STARTED - TIME=15.09.01
  15.09.01 JOB 2897 IEFACTRT - Stepname  Procstep  Program   Retcode
  15.09.01 JOB 2897 CALNDR24   LBCC2I    ASM       IFOX00    RC= 0000
  15.09.01 JOB 2897 CALNDR24   LBCC2I    LKED      IEWL      RC= 0000
  15.09.01 JOB 2897 CALNDR24   LBCI2C    ASM       IFOX00    RC= 0000
  15.09.01 JOB 2897 CALNDR24   LBCI2C    LKED      IEWL      RC= 0000
  15.09.01 JOB 2897 CALNDR24   LBISPL    ASM       IFOX00    RC= 0000
  15.09.01 JOB 2897 CALNDR24   LBISPL    LKED      IEWL      RC= 0000
  15.09.01 JOB 2897 CALNDR24   LBWTRM    ASM       IFOX00    RC= 0000
  15.09.01 JOB 2897 CALNDR24   LBWTRM    LKED      IEWL      RC= 0000
  15.09.02 JOB 2897 CALNDR24   LBWTRMP   ASM       IFOX00    RC= 0000
  15.09.02 JOB 2897 CALNDR24   LBWTRMP   LKED      IEWL      RC= 0000
  15.09.02 JOB 2897 CALNDR24   CALNDRFG  FORT      IEYFORT   RC= 0000
  15.09.02 JOB 2897 CALNDR24   CALNDRFG  LKED      IEWL      RC= 0000
  15.09.02 JOB 2897 CALNDR24   CALNDRFH  FORT      IEKAA00   RC= 0004
  15.09.02 JOB 2897 CALNDR24   CALNDRFH  LKED      IEWL      RC= 0000
  15.09.02 JOB 2897 CALNDR24   CALNDRP   PL1L      IEMAA     RC= 0004
  15.09.02 JOB 2897 CALNDR24   CALNDRP   LKED      IEWL      RC= 0000
  15.09.03 JOB 2897 CALNDR24   CALNDRGC  GCC       GCC       RC= 0000
  15.09.03 JOB 2897 CALNDR24   CALNDRGC  ASM       IFOX00    RC= 0000
  15.09.03 JOB 2897 CALNDR24   CALNDRGC  LKED      IEWL      RC= 0000
  15.09.03 JOB 2897 IEF404I CALNDR24 - ENDED - TIME=15.09.03
  15.09.03 JOB 2897 $HASP395 CALNDR24 ENDED
 
 
+--------------------------------------------------------------------+
| Step 8. Install ISPF parts                                         |
+--------------------------------------------------------------------+
|         JCL Member: CALNDR2.V0R9M00.CNTL($INST05)                  |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//CALNDR25 JOB (SYS),'Install ISPF Parts',   <-- Review and Modify 
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  CALNDR2 in MVS3.8J TSO / Hercules                   *
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
//ISPF     EXEC PARTSI,HLQ=CALNDR2,VRM=V0R9M00,
//         CLIB='XXXXXXXX.ISPCLIB',                <--TARGET
//         MLIB='XXXXXXXX.ISPMLIB',                <--TARGET
//         PLIB='XXXXXXXX.ISPPLIB',                <--TARGET
//         SLIB='XXXXXXXX.ISPSLIB',                <--TARGET
//         TLIB='XXXXXXXX.ISPTLIB'                 <--TARGET
//ADDCLIB.SYSIN    DD  *                  CLIB
   COPY INDD=((CLIBIN,R)),OUTDD=CLIBOUT
   SELECT MEMBER=CCLNDRFG
   SELECT MEMBER=CCLNDRFH
   SELECT MEMBER=CCLNDRGC
//ADDMLIB.SYSIN    DD  *                  MLIB
   COPY INDD=((MLIBIN,R)),OUTDD=MLIBOUT
   SELECT MEMBER=NO#MBR#                     /*dummy entry no mbrs! */
//ADDPLIB.SYSIN    DD  *                  PLIB
   COPY INDD=((PLIBIN,R)),OUTDD=PLIBOUT
   SELECT MEMBER=PCALNDRF 
//ADDSLIB.SYSIN    DD  *                  SLIB
   COPY INDD=((SLIBIN,R)),OUTDD=SLIBOUT
   SELECT MEMBER=NO#MBR#                     /*dummy entry no mbrs! */
//ADDTLIB.SYSIN    DD  *                  TLIB
   COPY INDD=((TLIBIN,R)),OUTDD=TLIBOUT
   SELECT MEMBER=NO#MBR#                     /*dummy entry no mbrs! */
//
______________________________________________________________________
Figure 7: $INST05 JCL
 
 
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
| Step 9. Install Other Program(s)                                   |  
+--------------------------------------------------------------------+
|         JCL Member: CALNDR2.V0R9M00.CNTL($INST40)                  |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//CALNR240 JOB (SYS),'Install Other Pgms',   <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  CALNDR2 for MVS3.8J TSO / Hercules                  *
//* *                                                      *
//* *  JOB: $INST40                                        *
//* *       Install xxxxxx   Programs                      *
//* *       **Note: Dummy job, no other programs!          *
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
Figure 8: $INST40 JCL
 
 
    Note:  No other programs require installation.
    -----  Please proceed to next step.
 
    a) Member $INST40 installs additional programs.
 
    b) Review and update JOB statement and other JCL to conform to your
       installation standard.                                       
 
    c) Submit the job.
 
    d) Review job output for successful completion.
 
 
+--------------------------------------------------------------------+
| Step 10. Validate CALNDR2                                          |
+--------------------------------------------------------------------+
 
    The purpose of this step is to execute different CALNDR components
    to display a yearly calendar.  Each program offer the same function,
    but the underlying source language is different.
 
    a) To execute the Fortran G solution -
 
       From the ISPF Main Menu, enter the following command:    
 
          TSO %CCLNDRFG                                                 
 
       To exit, use PF3.                                              
 
    b) To execute the Fortran H solution -
 
       From the ISPF Main Menu, enter the following command:    
 
          TSO %CCLNDRFH                                                 
 
       To exit, use PF3.                                              
 
    c) To execute the PL/I (F) solution -
 
       From the ISPF Main Menu, enter the following command:    
 
          TSO CALNDRP                                                    
 
       To exit, use PF3.                                              
 
    d) To execute the GCC solution -
 
       From the ISPF Main Menu, enter the following command:    
 
          TSO %CCLNDRGC                                                  
 
       To exit, use PF3.                                              
 
        
 
 
 
________________________________________________________________________________
 ------------------------ Calendar Sample using GCC   --------------------------
 Command ===>                                                   Scroll ==> PAGE 
                                                                                
    Dummy dates:                                          Year: 1993            
                 MM / DD                               S  M  T  W  T  F  S      
   Starting ===> 01 / 01                       -----------------------------    
   Ending   ===> 12 / 31                       ¦ JAN                  1  2 ¦    
                                               ¦       3  4  5  6  7  8  9 ¦    
                                               ¦      10 11 12 13 14 15 16 ¦    
                                               ¦      17 18 19 20 21 22 23 ¦    
                                               ¦      24 25 26 27 28 29 30 ¦    
                                               ¦      31  1  2  3  4  5  6 ¦    
                                               ¦ FEB   7  8  9 10 11 12 13 ¦    
                                               -----------------------------    
                                                                                
                                                                                
 Enter UP or DOWN command to scroll through calendar.                           
                                                                                
                                                                                
                                                                                
                                                                                
                                                                                
                                                                                
                                                                                
________________________________________________________________________________
Figure 9a: Sample PCALNDR Calendar Panel
           Note- solution language is displayed on header line
 
 
 
 
 
 
    e) Validation for CALNDR2 is complete.
 
 
+--------------------------------------------------------------------+
| Step 11. Done                                                      |
+--------------------------------------------------------------------+
 
 
    a) Congratulations!  You completed the installation for CALNDR2.


+--------------------------------------------------------------------+
| Step 12. Incorporate CALNDR2 into ISPF UTILITY SELECTION Menu      |
+--------------------------------------------------------------------+
 
 
    a) Not applicable.



Enjoy CALNDR2 for ISPF 2.x on MVS 3.8J!
                                                                            

======================================================================
* IV. S o f t w a r e   I n v e n t o r y   L i s t                  |
======================================================================

  - CALNDR2.V0R9M00.ASM 
   . CALNDRFG    TSO CP Fortran G pgm w ISPF services to display calendar
   . CALNDRFH    TSO CP Fortran H pgm w ISPF services to display calendar
   . CALNDRGC    TSO CP GCC MVS   pgm w ISPF services to display calendar
   . CALNDRP     TSO CP PL/I (F)  pgm w ISPF services to display calendar
   . LBCC2I      Convert Character Digit to Integer (for Fortran CP)
   . LBCI2N      Convert Integer to Character Digits (for Fortran CP)
   . LBISPL      Source pgm - ISPLINK API                   
   . LBWTRM      Write Message to TSO Terminal Display
   . LBWRTMP     Write Message to TSO Terminal Display - PL/I (F) version
      
  - CALNDR2.V0R9M00.CLIST
   . README      Dummy member, this is intentional

  - CALNDR2.V0R9M00.CNTL
   . $INST00     Define Alias for HLQ CALNDR2       
   . $INST01     Load CNTL data set from distribution tape (HET)
   . $INST02     Load other data sets from distribution tape (HET)
   . $INST03     Install TSO Parts
   . $INST04     Install CALNDR2 CP and utilities
   . $INST05     Install ISPF Parts
   . $INST40     Install Other programs                  
   . $RECVXMI    Receive XMI SEQ to MVS PDSs via RECV370
   . DSCLAIMR    Disclaimer
   . PREREQS     Required User-mods
   . README      Documentation and Installation instructions

  - CALNDR2.V0R9M00.HELP
   . README      Dummy member, this is intentional

  - CALNDR2.V0R9M00.ISPF
   . PCALNDRF    Calendar Panel for CALNDRF (Fortran G)
   . CCLNDRFG    Fortran G Calendar CLIST
   . CCLNDRFH    Fortran H Calendar CLIST
   . CCLNDRGC    GCC MVS   Calendar CLIST
                
  - CALNDR2.V0R9M00.MACLIB
   . README      Dummy member, this is intentional
       
       
                                                                            
