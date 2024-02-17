DSCOPY for MVS3.8J / Hercules                                               
=============================                                               


Date: 04/20/2021  Release V0R9M00

*  Author:  Larry Belmontes Jr.
*           https://ShareABitofIT.net/DSCOPY-in-MVS38J
*           Copyright (C) 2021  Larry Belmontes, Jr.


---------------------------------------------------------------------- 
|    DSCOPY       I n s t a l l a t i o n   R e f e r e n c e        | 
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

o  $INST00.JCL          Define Alias for HLQ DSCOPY in Master Catalog
 
o  $INST01.JCL          Load CNTL data set from distribution tape
 
o  $RECVXMI.JCL         Receive XMI SEQ to MVS PDSs                  
 
o  DSCOPY.V0R9M00.HET Hercules Emulated Tape (HET) multi-file volume
                        with VOLSER of VS0900 containing software  
                        distribution.
 
o  RECVXMIT.V0R9M00.XMI XMIT file containing software distribution.   
 
o  DSCLAIMR.TXT         Disclaimer
 
o  PREREQS.TXT          Required user-mods 
 
o  README.TXT           This File                                              
 
 
Note:   COPYPDS (TSO CP) from CBT File# 168 is required for this installation.
-----   More information at CBT Website:
        https://www.cbttape.org/covdowns.htm/
 
Credit: Thanks to Bill Godfrey who authored COPYPDS and for his         
------- CBT contribution.                               
 
Note:   IFALC (TSO CP) from CBT File# 270 is required for this installation.
-----   More information at CBT Website:
        https://www.cbttape.org/cbtdowns.htm/
 
Credit: Thanks to Kermit Kiser from WDPSC for this 
------- CBT contribution.                               
 
Note:   Programs for CUTIL00 must be installed as a pre-requisite.
-----   For convenience purposes, a current version is included.
        More information at:
        https://www.shareabitofit.net/cutil00-for-mvs-3-8j/
         
Note:   Programs for LISTDSJ must be installed as a pre-requisite.
-----   For convenience purposes, a current version is included.
        More information at:
        https://www.shareabitofit.net/listdsj-for-mvs-3-8j/
         
Note:   ISPF v2.1 or higher must be installed under MVS3.8J TSO             
-----   including associated user-mods per ISPF Installation Pre-reqs.
 
 
Note:   DDN (TSO CP) from CBT File# 300 is optional for this installation.
-----   More information at:
        https://www.cbttape.org/cbtdowns.htm  FILE #300
 
Credit: Program DD is authored by Bill Godfrey.  This program is from a   
------- collection of TSO commands submitted by Jim Marshall as part of
        CBT File #300.
       
        DD was renamed to DDN and modified by Jay Moseley for assembly using
        the IFOX00 assembler.  Jay consolidated Assembler source members for 
        link-edit and IEBUPDTE (HELP) into a single JCL installation package.
        More information at:
        http://www.jaymoseley.com/hercules/cbt_ware/ddn.htm
       
        Thanks to Bill Godfrey, Jim Marshall and Jay Moseley for their 
        contributions to CBT and MVS 3.8J communities.
 
Note:   $ (TSO CP) from CBT File# 077 is optional for this installation.
-----   This MVS 3.8J Utility may already be install in you MVS 3.8J
        TK3 or TK4- system.
        More information at CBT Website:
        https://www.cbttape.org/cbtdowns.htm/
 
Credit: Thanks to Brian Westerman who submitted various utilities      
------- as a CBT contribution.  Also, thanks to BMD and K True whose 
        names appear in the $ source program. 
 

======================================================================
* II. P r e - i n s t a l l a t i o n   R e q u i r e m e n t s      |
======================================================================

o  The Master Catalog password may be required for some installation
   steps. 
 
o  Tape files use device 480.
 
o  As default, DASD files will be loaded to VOLSER=MVSDLB, type 3350 device.
    
   Below is a DATASET List after tape distribution load for reference purposes:
    
   DATA-SET-NAME------------------------------- VOLUME ALTRK USTRK ORG FRMT % XT
   DSCOPY.V0R9M00.ASM                           MVSDLB    80    63 PO  FB  78  1
   DSCOPY.V0R9M00.CLIST                         MVSDLB     4     4 PO  FB 100  1
   DSCOPY.V0R9M00.CNTL                          MVSDLB    20    11 PO  FB  55  1
   DSCOPY.V0R9M00.HELP                          MVSDLB     4     2 PO  FB  50  1
   DSCOPY.V0R9M00.ISPF                          MVSDLB    20     4 PO  FB  20  1
   DSCOPY.V0R9M00.MACLIB                        MVSDLB     2     1 PO  FB  50  1
   **END**    TOTALS:     130 TRKS ALLOC        85 TRKS USED       6 EXTENTS    
    
    
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
| Step 1. Define Alias for HLQ DSCOPY in MVS User Catalog            |
+--------------------------------------------------------------------+
|         JCL Member: DSCOPY.V0R9M00.CNTL($INST00)                   |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//DSCOPY00 JOB (SYS),'Def DSCOPY Alias',     <-- Review and Modify 
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  DSCOPY in MVS3.8J TSO / Hercules                    *
//* *  JOB: $INST00  Define Alias for HLQ DSCOPY           *
//* *  Note: The master catalog password will be required  *
//* -------------------------------------------------------*
//DEFALIAS EXEC PGM=IDCAMS 
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
 PARM GRAPHICS(CHAIN(SN))
 LISTCAT ALIAS  ENT(DSCOPY) 
  
 IF LASTCC NE 0 THEN -
    DEFINE ALIAS(NAME(DSCOPY) RELATE(SYS1.UCAT.MVS))                          
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
|         JCL Member: DSCOPY.V0R9M00.CNTL($RECVXMI)                  |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//RECV000A JOB (SYS),'Receive DSCOPY XMI',       <-- Review and Modify
//             CLASS=A,MSGCLASS=X,REGION=0M,     <-- Review and Modify
//             MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  JOB: $RECVXMI  Receive Application XMI Files        *
//* -------------------------------------------------------*
//RECV     PROC HLQ=DSCOPY,VRM=V0R9M00,TYP=XXXXXXXX,
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
 
 
    a) Transfer DSCOPY.V0R9M00.XMI to MVS using your 3270 emulator.
       
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
 
       DSCOPY.V0R9M00.ASM   
       DSCOPY.V0R9M00.CLIST 
       DSCOPY.V0R9M00.CNTL  
       DSCOPY.V0R9M00.HELP  
       DSCOPY.V0R9M00.ISPF  
       DSCOPY.V0R9M00.MACLIB
 
    f) Subsequent installation steps will be submitted from members
       contained in the CNTL data set.
 
    g) Proceed to STEP 6.   ****
 
+--------------------------------------------------------------------+
| Step 4. Load CNTL data set from distribution tape                  |
+--------------------------------------------------------------------+
|         JCL Member: DSCOPY.V0R9M00.CNTL($INST01)                   |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//DSCOPY01 JOB (SYS),'Install CNTL PDS',     <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  DSCOPY for MVS3.8J TSO / Hercules                   *
//* *  JOB: $INST01  Load CNTL PDS from distribution tape  *
//* *  Note: Uses tape drive 480                           *
//* -------------------------------------------------------*
//LOADCNTL PROC HLQ=DSCOPY,VRM=V0R9M00,TVOLSER=VS0900,      
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
 
       DEVINIT 480 X:\dirname\DSCOPY.V0R9M00.HET READONLY=1
 
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
|         JCL Member: DSCOPY.V0R9M00.CNTL($INST02)                   |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//DSCOPY02 JOB (SYS),'Install Other PDSs',   <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  DSCOPY for MVS3.8J TSO / Hercules                   *
//* *  JOB: $INST02  Load other PDS from distribution tape *
//* *  Tape Volume:  File 1 - CNTL                         *
//* *                File 2 - CLIST                        *
//* *                File 3 - HELP                         *
//* *                File 4 - ISPF                         *
//* *                File 5 - ASM                          *
//* *                File 6 - MACLIB                       *
//* *  Note: Default TAPE=480, DASD=3350 on MVSDLB         *
//* -------------------------------------------------------*
//LOADOTHR PROC HLQ=DSCOPY,VRM=V0R9M00,TVOLSER=VS0900,            
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
 
       DEVINIT 480 X:\dirname\DSCOPY.V0R9M00.HET READONLY=1
 
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
|         JCL Member: DSCOPY.V0R9M00.CNTL($INST03)                   |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//DSCOPY03 JOB (SYS),'Install TSO Parts',    <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  DSCOPY for MVS3.8J TSO / Hercules                   *
//* *                                                      *
//* *  JOB: $INST03  Install TSO parts                     *
//* *                                                      *
//* *  Note: Duplicate members are over-written.           *
//* -------------------------------------------------------*
//STEP001  EXEC PGM=IEBCOPY                                           
//SYSPRINT DD  SYSOUT=*                                              
//INCLIST  DD  DSN=DSCOPY.V0R9M00.CLIST,DISP=SHR            
//INHELP   DD  DSN=DSCOPY.V0R9M00.HELP,DISP=SHR             
//OUTCLIST DD  DSN=SYS2.CMDPROC,DISP=SHR                               
//OUTHELP  DD  DSN=SYS2.HELP,DISP=SHR
//SYSIN    DD  *                                                        
    COPY INDD=((INCLIST,R)),OUTDD=OUTCLIST
    SELECT MEMBER=CDSCPY0
    COPY INDD=((INHELP,R)),OUTDD=OUTHELP
    SELECT MEMBER=CDSCPY0
    SELECT MEMBER=CUTIL00
    SELECT MEMBER=LISTDSJ
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
| Step 7. Install DSCOPY Programs                                    |  
+--------------------------------------------------------------------+
|         JCL Member: DSCOPY.V0R9M00.CNTL($INST04)                   |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//DSCOPY04 JOB (SYS),'Install DSCOPY',       <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  DSCOPY for MVS3.8J TSO / Hercules                   *
//* *                                                      *
//* *  JOB: $INST04                                        *
//* *       Install DSCOPY Programs                        *
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
Figure 6: $INST04 JCL
 
 
    a) Member $INST04 installs program(s).
 
       Note:  If no source components are included for this distribution,
       -----  an IEFBR14 step is executed.
 
    b) Review and update JOB statement and other JCL to conform to your
       installation standard.                                       
 
    c) Submit the job.
 
    d) Review job output for successful completion.
 
 
+--------------------------------------------------------------------+
| Step 8. Install ISPF parts                                         |
+--------------------------------------------------------------------+
|         JCL Member: DSCOPY.V0R9M00.CNTL($INST05)                   |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//DSCOPY05 JOB (SYS),'Install ISPF Parts',   <-- Review and Modify 
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  DSCOPY in MVS3.8J TSO / Hercules                    *
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
//ISPF     EXEC PARTSI,HLQ=DSCOPY,VRM=V0R9M00,
//         CLIB='XXXXXXXX.ISPCLIB',                <--TARGET
//         MLIB='XXXXXXXX.ISPMLIB',                <--TARGET
//         PLIB='XXXXXXXX.ISPPLIB',                <--TARGET
//         SLIB='XXXXXXXX.ISPSLIB',                <--TARGET
//         TLIB='XXXXXXXX.ISPTLIB'                 <--TARGET
//ADDCLIB.SYSIN    DD  *                  CLIB
   COPY INDD=((CLIBIN,R)),OUTDD=CLIBOUT
   SELECT MEMBER=NO#MBR#                     /*dummy entry no mbrs! */
//ADDMLIB.SYSIN    DD  *                  MLIB
   COPY INDD=((MLIBIN,R)),OUTDD=MLIBOUT
   SELECT MEMBER=DCPY00 
   SELECT MEMBER=DCPY01 
   SELECT MEMBER=DCPY02 
//ADDPLIB.SYSIN    DD  *                  PLIB
   COPY INDD=((PLIBIN,R)),OUTDD=PLIBOUT
   SELECT MEMBER=HDCPY0   
   SELECT MEMBER=HDCPY0R  
   SELECT MEMBER=PDCPY0   
   SELECT MEMBER=PDCPY0R  
   SELECT MEMBER=PDCPY1   
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
|         JCL Member: DSCOPY.V0R9M00.CNTL($INST40)                   |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//DSCOPY40 JOB (SYS),'Install Other Pgms',   <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  DSCOPY for MVS3.8J TSO / Hercules                   *
//* *                                                      *
//* *  JOB: $INST40                                        *
//* *       Install CUTIL00  Programs                      *
//* *       Install LISTDSJ  Programs                      *
//* *       **Note: CUTIL00 and LISTSDJ                    *
//* *               require two user-mods                  *
//* *               ZP60014 and ZP60038.                   *
//* *               Refer to program documenation          *
//* *               or pre-reqs documenation.              *
//* *                                                      *
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
//* *  Assemble Link-Edit CUTIL00 to SYS2.CMDLIB           *
//* -------------------------------------------------------*
//CUTIL00  EXEC  ASML,HLQ=DSCOPY,VRM=V0R9M00,MBR=CUTIL00,
//         PARM.LKED='MAP,LIST,LET,RENT,XREF,REUS,REFR'
//LKED.SYSLMOD DD  DISP=SHR,
//         DSN=SYS2.CMDLIB(&MBR)                  <--TARGET 
//*
//* -------------------------------------------------------*
//* *  Assemble Link-Edit CUTILTBL to SYS2.CMDLIB          *
//* -------------------------------------------------------*
//CUTILTBL EXEC  ASML,HLQ=DSCOPY,VRM=V0R9M00,MBR=CUTILTBL, 
//         PARM.LKED='MAP,LIST,LET,RENT,XREF,REUS,REFR'
//LKED.SYSLMOD DD  DISP=SHR,
//         DSN=SYS2.CMDLIB(&MBR)                  <--TARGET 
//*
//* -------------------------------------------------------*
//* *  Assemble Link-Edit LISTDSJ to SYS2.CMDLIB           *
//* -------------------------------------------------------*
//LISTDSJ  EXEC  ASML,HLQ=DSCOPY,VRM=V0R9M00,MBR=LISTDSJ,
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
Figure 8: $INST40 JCL
 
 
    a) Member $INST40 installs additional programs.
 
       Note:  If no other programs are included for this distribution,
       -----  an IEFBR14 step is executed.
 
    b) Review and update JOB statement and other JCL to conform to your
       installation standard.                                       
 
    c) Submit the job.
 
    d) Review job output for successful completion.
 
 
+--------------------------------------------------------------------+
| Step 10. Validate DSCOPY                                           |
+--------------------------------------------------------------------+
 
    Before using CLIST CDSCPY0, the PROC variable PFLG requires review and
    setting.  CDSCPY0 is installed with default setting of PFLG(YYNNNNN9).
                                                           --------------
                                                            
    Specifically, the first two indicators require your review and finalization.
     
    The processing flags are described below:
    +------+--------+------------------------------------------------+
    | Flag | Value  | Description                                    |
    +------+--------+------------------------------------------------+
    |   1  |   Y    | File Allocation using DDN (default) **         |
    |      | other  | File Allocation using ALLOC                    |
    +------+--------+------------------------------------------------+
    |   2  |   Y    | Call IEBGENER using $ CP  (default) **         |
    |      | other  | Call IEBGENER using traditional TSO CALL       |
    +------+--------+------------------------------------------------+
     
    Note: If you elect to use the default settings, ensure the appropriate
          CPs are installed!
 
 
 
    The purpose of step a) and b) is to execute a partitioned and sequential
    data set copy operation in a TSO READY PROMPT.  Do not start ISPF, if
    installed on your system.
 
    a) To execute TSO Sequential DSN copy -
 
       1. Locate a DASD sequential data set on your system. 
 
       2. From the TSO READY prompt, enter the following command:    
 
          %CDSCPY0 DSN1(seq.dsn)                 
 
       3. The copy operation should respond with a similar set of messages:
        
          COPY SEQUENTIAL                                  
          'seq.dsn' --> 'seq.dsn.Dyyjjj.Thhmmss' 
          ** CDSCPY0      RC=0                             
          READY
           
 
    b) To execute TSO Partitioned DSN copy -
 
       1. Locate a DASD partitioned data set on your system. 
 
       2. From the TSO READY prompt, enter the following command:    
 
          %CDSCPY0 DSN1(pds.dsn)                 
 
       3. The copy operation should respond with a similar set of messages:
        
          COPY PDS                                                 
          'pds.dsn' --> 'pds.dsn.Dyyjjj.Thhmmss' 
          WARNING: IDENTICALLY NAMED MEMBERS WILL NOT BE COPIED    
          AND THERE WILL BE NO INDICATION IF THAT HAPPENS          
          ** CDSCPY0      RC=0                                     
          READY
           
 
    c) Logoff TSO.                                                    
           
           
    The purpose of step d) and e) is to execute a partitioned and sequential
    data set copy operation in a TSO/ISPF environment, if ISPF is installed
    on your system.
 
 
    d) To execute TSO/ISPF partitioned DSN copy -
 
       1. Locate a DASD partitioned data set on your system. 
 
       2. From the ISPF PRIMARY MENU, enter the following command:    
 
          OPTION  ===> TSO %CDSCPY0 DSN1(pds.dsn)                 
 
       3. The response should be with panel PDCPY0 displaying source,
          destination data set names and attributes.
        
________________________________________________________________________________
 ------------------------- Data Set Copy Action --------------------------------
 Command ===>                                                                   
                                                                                
                                                                        LARRY01 
  From DSN  . : pds.dsn                                                 PDCPY0  
   Volume . . : PUB000                                                          
   DSORG  . . : PO                                                              
   RACF . . . : NONE                                                            
   CurAlloc . : CYLINDER 1                                                      
   DirBlksUsed: 1        Members: 3                                             
                                                                                
                                                                                
  Copy From DSN --> To DSN using below attributes.                              
  Overtype details and press ENTER to perform copy operation.                   
                                                                                
  To DSN  : pds.dsn.Dyyjjj.Thhmmss                                         
   Volume : PUB000   Unit     : 3350                                            
   RECFM  : FB       BLKSIZE  : 19040     LRECL    : 80                         
   Alloc  : CYLINDER Primary  : 30        Secondary: 1                          
   DirBlks: 20                                  
                                                
  List: Y  (Y/N) List copy member log on screen                                 
                                                                                
                                                                                
                                                                                
________________________________________________________________________________
Figure 9a: Sample PDCPY0 Copy Action Panel
                                                                                
       4. After reviewing and/or modifying destination data set name and/or
          attributes, press ENTER to perform the copy operation.      
                                                                                
       5. The ISPF PRIMARY MENU should display a similar response with a
          completion message:
                                                                                
________________________________________________________________________________

 -------------------------  ISPF PRIMARY OPTION MENU    COPYPDS Done RC=0      
 OPTION  ===>                                                                   
                                                            USERID   - LARRY01  
    0  ISPF PARMS  - Specify terminal and user parms        TIME     - 08:44    
    1  BROWSE      - Display source data using Review       TERMINAL - 3277     
    2  EDIT        - Change sou......
                                                                                
                                                                                
                                                                                
                                                                                
________________________________________________________________________________
Figure 9b: Sample ISPF PRIMARY MENU panel (partial content)
                                                                                
 
 
 
    e) To execute TSO/ISPF sequential DSN copy -
 
       1. Locate a DASD sequential data set on your system. 
 
       2. From the ISPF PRIMARY MENU, enter the following command:    
 
          OPTION  ===> TSO %CDSCPY0 DSN1(seq.dsn)                 
 
       3. The response should be with panel PDCPY1 displaying source,
          destination data set names and attributes.
        
________________________________________________________________________________
 ------------------------- Data Set Copy Action --------------------------------
 Command ===>                                                                   
                                                                                
                                                                        LARRY01 
  From DSN  . : seq.dsn                                                 PDCPY1  
   Volume . . : TSO00B                                                          
   DSORG  . . : PS                                                              
   RACF . . . : NONE                                                            
   CurAlloc . : BLOCK    0                                                      
                                                                                
                                                                                
  Copy From DSN --> To DSN using below attributes.                              
  Overtype details and press ENTER to perform copy operation.                   
                                                                                
  To DSN  : seq.dsn.Dyyjjj.Thhmmss                                         
   Volume : TSO00B   Unit     : 3390                                            
   RECFM  : FB       BLKSIZE  : 12000     LRECL    : 120                        
   Alloc  : BLOCK    Primary  : 0         Secondary: 50                         
                                                                                
  List: Y  (Y/N) List copy operation log on screen                              
                                                                                
                                                                                
                                                                                
________________________________________________________________________________
Figure 9c: Sample PDCPY1 Copy Action Panel
                                                                                
       4. After reviewing and/or modifying destination data set name and/or
          attributes, press ENTER to perform the copy operation.      
                                                                                
       5. The ISPF PRIMARY MENU should display a similar response with a
          completion message:
                                                                                
________________________________________________________________________________

 -------------------------  ISPF PRIMARY OPTION MENU    IEBGENER Done RC=0      
 OPTION  ===>                                                                   
                                                            USERID   - LARRY01  
    0  ISPF PARMS  - Specify terminal and user parms        TIME     - 08:44    
    1  BROWSE      - Display source data using Review       TERMINAL - 3277     
    2  EDIT        - Change sou......
                                                                                
                                                                                
                                                                                
                                                                                
________________________________________________________________________________
Figure 9d: Sample ISPF PRIMARY MENU panel (partial content)
                                                                                
 
 
 
 
 
    f) Validation for DSCOPY is complete.
 
 
+--------------------------------------------------------------------+
| Step 11. Done                                                      |
+--------------------------------------------------------------------+
 
 
    a) Congratulations!  You completed the installation for DSCOPY.


+--------------------------------------------------------------------+
| Step 12. Incorporate DSCOPY into ISPF UTILITY SELECTION Menu       |
+--------------------------------------------------------------------+
 
 
    a) It is suggested using option DC from the UTILITY SELECTION MENU
       (panel ISPUTILS) as option 3.DC.                           
                                                                     
    b) Create a copy of ISPUTILS in your application panel library
       instead of the ISPF system panel library to preserve the original
       system panel in addition to preserving your ISPUTILS changes      
       when upgrading your ISPF system with a new version.    
                                                                     
    c) Add the 'NEW ENTRY' line as shown below after option 9 as 
       new menu option:
    
     %   9 +COMMANDS    - Create/change an application command table  
     %  DC  DSCOPY      - Data Set Copy (Seq or PDS)     <-- NEW ENTRY
 
    d) Add the 'NEW ENTRY' line as shown below to process the DC option:
                                                                          
       )PROC
         &ZSEL = TRANS( TRUNC (&ZCMD,'.')
                       1,'CMD(RFE 3.1;X) NEWAPPL(ISR)'   
                       .
                       .
                       9,'PANEL(ISPUCMA)' 
                      DC,'PANEL(PDCPY0R) NEWAPPL(DCPY)'    <-- NEW ENTRY
                       .
                       .
                     ' ',' '
                       *,'?' )
       )END
 
    e) Save UTILITY SELECTION MENU panel changes.                               

    f) Type =3 in the COMMAND line.  The new menu item (DC) should display. 

    g) Type DC in the COMMAND line.  The new Data Set Copy Request panel
       (PDSCPY0R) should display.



Enjoy DSCOPY for ISPF 2.x on MVS 3.8J!
                                                                            

======================================================================
* IV. S o f t w a r e   I n v e n t o r y   L i s t                  |
======================================================================

  - DSCOPY.V0R9M00.ASM 
   . CUTIL00     TSO CP for CLIST Variables
   . CUTILTBL    CUTIL00 messages program 
   . LISTDSJ     TSO CP LISTDSI-like program
    
  - DSCOPY.V0R9M00.CLIST
   . CDSCPY0     DSCOPY CLIST for SEQ or PDS

  - DSCOPY.V0R9M00.CNTL
   . $INST00     Define Alias for HLQ DSCOPY       
   . $INST01     Load CNTL data set from distribution tape (HET)
   . $INST02     Load other data sets from distribution tape (HET)
   . $INST03     Install TSO Parts
   . $INST04     Install DSCOPY CP and utilities
   . $INST05     Install ISPF Parts
   . $INST40     Install Other programs                  
   . $RECVXMI    Receive XMI SEQ to MVS PDSs via RECV370
   . DSCLAIMR    Disclaimer
   . PREREQS     Required User-mods
   . README      Documentation and Installation instructions

  - DSCOPY.V0R9M00.HELP
   . CDSCPY0     DSCOPY Help file            
   . CUTIL00     Help file      
   . LISTDSI *   Help file(Alias)
   . LISTDSJ     Help file      

  - DSCOPY.V0R9M00.ISPF
   . HDCPY0      DSCOPY Panel Sequential HELP
   . PDCPY0      DSCOPY Panel Sequential
   . HDCPY1      DSCOPY Panel Partitioned HELP
   . PDCPY1      DSCOPY Panel Partitioned
   . HDCPY0R     DSCOPY Request Panel HELP
   . PDCPY0R     DSCOPY Request Panel
   . DCPY00      DSCOPY Messages
   . DCPY01      DSCOPY Messages
   . DCPY02      DSCOPY Messages
                
  - DSCOPY.V0R9M00.MACLIB
   . README      Dummy member, this is intentional
       
       
  - After downloading any other required software, consult provided
    documentation including any configuration steps (if applicable)
    for software and HELP file installation. 
       
       
       
