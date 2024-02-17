CCOMPR for MVS3.8J / Hercules                                               
=============================                                               


Date: 2/10/2022  Release V0R9M01
      8/10/2020  Release V0R9M00

*  Author:  Larry Belmontes Jr.
*           https://ShareABitofIT.net/CCompare-in-MVS38J
*           Copyright (C) 2020  Larry Belmontes, Jr.


---------------------------------------------------------------------- 
|    CCOMPR       I n s t a l l a t i o n   R e f e r e n c e        | 
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

o  $INST00.JCL          Define Alias for HLQ CCOMPR in Master Catalog
 
o  $INST01.JCL          Load CNTL data set from distribution tape
 
o  $RECVXMI.JCL         Receive XMI SEQ to MVS PDSs                  
 
o  CCOMPR.V0R9M01.HET   Hercules Emulated Tape (HET) multi-file volume
                        with VOLSER of VS0901 containing software  
                        distribution.
 
o  CCOMPR.V0R9M01.XMI   XMIT file containing software distribution.   
 
o  DSCLAIMR.TXT         Disclaimer
 
o  PREREQS.TXT          Required user-mods 
 
o  README.TXT           This File                                              
 
o  CCOMPR_SVC99RC.TXT   SVC 99 Return Codes                               
                          
o  GC28-0627-2-pp.PDF   Relevant pages (pp27-32) for SVC 99 Return,
                        Error Reason and Information Reason codes
                        from GC28-0627-2 OS/VS2 MVS System Programming
                        Library Job Management reference manual
                        in PDF format
 
Note:   ISPF v2.1 or higher must be installed under MVS3.8J TSO             
-----   including associated user-mods per ISPF Installation Pre-reqs.
 
Note:   COMPARE / COMPAREB (TSO CPs) from CBT File#296 are required for  
-----   this install and differs from the original COMPARE version supplied
        in the MVS 3.8J Tur(n)key 3 and TK4- distributions.          
        More information at:
        https://www.cbttape.org/cbtdowns.htm               
        See section V below for installation details. ***
       
Credit: Thanks to the COMPARE / COMPAREB authors and/or contributors     
-----   for this CBT contribution -
        Brent Tolman, Bill Godfrey, Jim Marshall, Bruce Leland,
        and Guy L. Albertelli.
       
Note:   PRINTOFF (TSO CP) is a pre-requisite for this install
-----   and available on MVS3.8J TK3 and TK4- systems.          
        More information at:
        https://www.cbttape.org/cbtdowns.htm               
       
Note:   Program CHKDSN must be installed as a pre-requisite.
-----   For convenience purposes, a current version is included.
        More information at:
        https://www.shareabitofit.net/CHKDSN-in-MVS38j/

Note:   The SHRABIT.MACLIB macro PDS must be installed as a pre-requisite.
-----   For convenience purposes, a current version is included.
        More information at:
        https://www.shareabitofit.net/SHRABIT-MACLIB-in-MVS-3-8J/


======================================================================
* II. P r e - i n s t a l l a t i o n   R e q u i r e m e n t s      |
======================================================================

o  The Master Catalog password may be required for some installation
   steps. 
 
o  Tape files use device 480.
 
o  As default, DASD files will be loaded to VOLSER=MVSDLB, type 3350 device.
    
   Below is a DATASET List after tape distribution load for reference purposes:
    
   DATA-SET-NAME------------------------------- VOLUME ALTRK USTRK ORG FRMT % XT
   CCOMPR.V0R9M01.ASM                           MVSDLB    50    19 PO  FB  38  1
   CCOMPR.V0R9M01.CLIST                         MVSDLB     2     1 PO  FB  50  1
   CCOMPR.V0R9M01.CNTL                          MVSDLB    20     8 PO  FB  40  1
   CCOMPR.V0R9M01.HELP                          MVSDLB     2     1 PO  FB  50  1
   CCOMPR.V0R9M01.ISPF                          MVSDLB    15     3 PO  FB  20  1
   CCOMPR.V0R9M01.MACLIB                        MVSDLB     6     5 PO  FB  83  3
   **END**    TOTALS:      95 TRKS ALLOC        37 TRKS USED       8 EXTENTS    
    
    
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
| Step 1. Define Alias for HLQ CCOMPR in MVS User Catalog            |
+--------------------------------------------------------------------+
|         JCL Member: CCOMPR.V0R9M01.CNTL($INST00)                   |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//CCOMPR0  JOB (SYS),'Define CCOMPR Alias',  <-- Review and Modify 
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  CCOMPR for MVS3.8J TSO / Hercules                   *
//* *  JOB: $INST00  Define Alias for HLQ CCOMPR           *
//* *  Note: The master catalog password will be required  *
//* -------------------------------------------------------*
//DEFALIAS EXEC PGM=IDCAMS 
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
 PARM GRAPHICS(CHAIN(SN))
 LISTCAT ALIAS  ENT(CCOMPR) 
 IF LASTCC NE 0 THEN -
    DEFINE ALIAS(NAME(CCOMPR) RELATE(SYS1.UCAT.MVS))                          
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
|         JCL Member: CCOMPR.V0R9M01.CNTL($RECVXMI)                  |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//RECV000A JOB (SYS),'Receive CCOMPR XMI',       <-- Review and Modify
//             CLASS=A,MSGCLASS=X,REGION=0M,     <-- Review and Modify
//             MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  JOB: $RECVXMI  Receive Application XMI Files        *
//* -------------------------------------------------------*
//RECV     PROC HLQ=CCOMPR,VRM=V0R9M01,TYP=XXXXXXXX,
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
//ISPF     EXEC RECV,TYP=ISPF,DSPACE='(TRK,(15,05,10))'
//ASM      EXEC RECV,TYP=ASM,DSPACE='(TRK,(50,10,10))'
//MACLIB   EXEC RECV,TYP=MACLIB,DSPACE='(TRK,(06,02,06))'
//
______________________________________________________________________
Figure 2: $RECVXMI.JCL
 
 
    a) Transfer CCOMPR.V0R9M01.XMI to MVS using your 3270 emulator.
       
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
 
       CCOMPR.V0R9M01.ASM   
       CCOMPR.V0R9M01.CLIST 
       CCOMPR.V0R9M01.CNTL  
       CCOMPR.V0R9M01.HELP  
       CCOMPR.V0R9M01.ISPF  
       CCOMPR.V0R9M01.MACLIB
 
    f) Subsequent installation steps will be submitted from members
       contained in the CNTL data set.
 
    g) Proceed to STEP 6.   ****
 
+--------------------------------------------------------------------+
| Step 4. Load CNTL data set from distribution tape                  |
+--------------------------------------------------------------------+
|         JCL Member: CCOMPR.V0R9M01.CNTL($INST01)                   |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//CCOMPR1  JOB (SYS),'Install CNTL PDS',     <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  CCOMPR for MVS3.8J TSO / Hercules                   *
//* *  JOB: $INST01  Load CNTL PDS from distribution tape  *
//* *  Note: Default TAPE=480, DASD=3350 on MVSDLB         *
//* -------------------------------------------------------*
//LOADCNTL PROC HLQ=CCOMPR,VRM=V0R9M01,TVOLSER=VS0901,      
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
 
       DEVINIT 480 X:\dirname\CCOMPR.V0R9M01.HET READONLY=1
 
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
|         JCL Member: CCOMPR.V0R9M01.CNTL($INST02)                   |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//CCOMPR2  JOB (SYS),'Install Other PDSs',   <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  CCOMPR for MVS3.8J TSO / Hercules                   *
//* *  JOB: $INST02  Load other PDS from distribution tape *
//* *  Tape Volume:  File 1 - CNTL                         *
//* *                File 2 - CLIST                        *
//* *                File 3 - HELP                         *
//* *                File 4 - ISPF                         *
//* *                File 5 - ASM                          *
//* *                File 6 - MACLIB                       *
//* *  Note: Default TAPE=480, DASD=3350 on MVSDLB         *
//* -------------------------------------------------------*
//LOADOTHR PROC HLQ=CCOMPR,VRM=V0R9M01,TVOLSER=VS0901,            
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
//             SPACE=(TRK,(05,05,10)),DISP=(,CATLG),
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=3600) 
//ASM      DD  DSN=&HLQ..&VRM..ASM,UNIT=&DUNIT,VOL=SER=&DVOLSER,
//             SPACE=(TRK,(20,10,10)),DISP=(,CATLG),
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=3600) 
//MACLIB   DD  DSN=&HLQ..&VRM..MACLIB,UNIT=&DUNIT,VOL=SER=&DVOLSER,
//             SPACE=(TRK,(06,02,06)),DISP=(,CATLG),
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
 
       DEVINIT 480 X:\dirname\CCOMPR.V0R9M01.HET READONLY=1
 
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
|         JCL Member: CCOMPR.V0R9M01.CNTL($INST03)                   |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//CCOMPR03 JOB (SYS),'Install TSO Parts',    <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  CCOMPR for MVS3.8J TSO / Hercules                   *
//* *                                                      *
//* *  JOB: $INST03  Install TSO parts                     *
//* *                                                      *
//* *  Note: Duplicate members are over-written.           *
//* -------------------------------------------------------*
//STEP001  EXEC PGM=IEBCOPY                                           
//SYSPRINT DD  SYSOUT=*                                              
//INCLIST  DD  DSN=CCOMPR.V0R9M01.CLIST,DISP=SHR            
//INHELP   DD  DSN=CCOMPR.V0R9M01.HELP,DISP=SHR             
//OUTCLIST DD  DSN=SYS2.CMDPROC,DISP=SHR                               
//OUTHELP  DD  DSN=SYS2.HELP,DISP=SHR
//SYSIN    DD  *                                                        
    COPY INDD=((INCLIST,R)),OUTDD=OUTCLIST
    SELECT MEMBER=NO#MBR#                    /*dummy entry no mbrs! */
    COPY INDD=((INHELP,R)),OUTDD=OUTHELP
    SELECT MEMBER=CHKDSN
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
| Step 7. Install CCOMPR Program                                     |  
+--------------------------------------------------------------------+
|         JCL Member: CCOMPR.V0R9M01.CNTL($INST04)                   |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//CCOMPR04 JOB (SYS),'Install CCOMPR',       <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  CCOMPR for MVS3.8J TSO / Hercules                   *
//* *                                                      *
//* *  JOB: $INST04                                        *
//* *       Install CCOMPR Program                         *
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
//* *  Assemble Link-Edit CCOMPR to ISPLLIB                *
//* -------------------------------------------------------*
//CCOMPR   EXEC  ASML,HLQ=CCOMPR,VRM=V0R9M01,MBR=CCOMPR
//LKED.SYSLMOD DD  DISP=SHR,
//         DSN=XXXXXXXX.ISPLLIB(&MBR)              <--TARGET 
// 
______________________________________________________________________
Figure 6: $INST04 JCL
 
 
    a) Member $INST04 installs program(s).                               
 
    b) Review and update JOB statement and other JCL to conform to your
       installation standard.                                       
 
    c) Submit the job.
 
    d) Review job output for successful completion.
 
 
+--------------------------------------------------------------------+
| Step 8. Install ISPF parts                                         |
+--------------------------------------------------------------------+
|         JCL Member: CCOMPR.V0R9M01.CNTL($INST05)                   |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//CCOMPR05 JOB (SYS),'Install ISPF Parts',   <-- Review and Modify 
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  CCOMPR in MVS3.8J TSO / Hercules                    *
//* *                                                      *
//* *  JOB: $INST05  Install ISPF parts                    *
//* *                                                      *
//* *  Note: Duplicate members are over-written.           *
//* *                                                      *
//* *                                                      *
//* *  - Uses ISPF 2.0 product from Wally Mclaughlin       *
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
//ISPF     EXEC PARTSI,HLQ=CCOMPR,VRM=V0R9M01,
//         CLIB='XXXXXXXX.ISPCLIB',                <--TARGET
//         MLIB='XXXXXXXX.ISPMLIB',                <--TARGET
//         PLIB='XXXXXXXX.ISPPLIB',                <--TARGET
//         SLIB='XXXXXXXX.ISPSLIB',                <--TARGET
//         TLIB='XXXXXXXX.ISPTLIB'                 <--TARGET
//ADDCLIB.SYSIN    DD  *                  CLIB
   COPY INDD=((CLIBIN,R)),OUTDD=CLIBOUT
   SELECT MEMBER=C$CCOMPR
//ADDMLIB.SYSIN    DD  *                  MLIB
   COPY INDD=((MLIBIN,R)),OUTDD=MLIBOUT
   SELECT MEMBER=CMPR00 
   SELECT MEMBER=CMPR01 
//ADDPLIB.SYSIN    DD  *                  PLIB
   COPY INDD=((PLIBIN,R)),OUTDD=PLIBOUT
   SELECT MEMBER=PCOMPR   
   SELECT MEMBER=HCOMPR   
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
| Step 9. Install CHKDSN Program                                     |
+--------------------------------------------------------------------+
|         JCL Member: CCOMPR.V0M9M01.CNTL($INST40)                   |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//CCOMPR40 JOB (SYS),'Install CHKDSN',       <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  CCOMPR for MVS3.8J TSO / Hercules                   *
//* *                                                      *
//* *  JOB: $INST40                                        *
//* *       Install CHKDSN Programs                        *
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
//* *  Assemble Link-Edit CHKDSN to SYS2.CMDLIB            *
//* -------------------------------------------------------*
//CHKDSN   EXEC  ASML,HLQ=CCOMPR,VRM=V0R9M01,MBR=CHKDSN
//LKED.SYSLMOD DD  DISP=SHR,
//         DSN=SYS2.CMDLIB(&MBR)                  <--TARGET 
//*
//* -------------------------------------------------------*
//* *  Assemble Link-Edit CHKDSNMS to SYS2.CMDLIB          *
//* -------------------------------------------------------*
//CHKDSNSM EXEC  ASML,HLQ=CCOMPR,VRM=V0R9M01,MBR=CHKDSNMS
//LKED.SYSLMOD DD  DISP=SHR,
//         DSN=SYS2.CMDLIB(&MBR)                  <--TARGET 
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
 
 
    Note:  If CHKDSN is already installed on your system,
    -----  proceed to next step.
 
    a) Member $INST40 installs CHKDSN.
 
    b) Review and update JOB statement and other JCL to conform to your
       installation standard.                                       
 
    c) Submit the job.
 
    d) Review job output for successful completion.
 
 
+--------------------------------------------------------------------+
| Step 10. Validate CCOMPR                                           |
+--------------------------------------------------------------------+
 
 
    a) From the ISPF Main Menu, enter the following command:    
       TSO %C$CCOMPR                                                 
 
    b) Panel PCOMPR is displayed.  The validation task is to compare
       a dataset to itself!                                         
 
        1. Enter  OLD DSN and Member     as shown below
        2. Enter  NEW DSN and Member     as shown below
        3. Enter  x for FULL             as shown below
        4. Enter  x for COMPAREB         as shown below
        5. Enter  y for Browse           as shown below
        7. Enter  y for Print            as shown below
        8. Enter  y for Delete           as shown below
        9. Press ENTER
        
________________________________________________________________________________
 -------------------------- COMPARE TWO ONLINE DATASETS ------------------------
 Command ===> *                                                         LARRY01 
                                                                        PCOMPR  
                                                                                
  OLD DSN ===> 'CCOMPR.V0R9M01.CNTL'                                            
   Member ===> $INST00                                                          
   Volume ===>          (If not catalogued)                                     
     Unit ===>          (Always BLANK)                                          
                                                                                
  NEW DSN ===> 'CCOMPR.V0R9M01.CNTL'                                            
   Member ===> $INST00                                                          
   Volume ===>          (If not catalogued)                                     
     Unit ===>          (Always BLANK)                                          
                                                                                
  Compare Options:                                                              
   Type   : FULL x ASM   NOASM                  (Use 'x' to select one Type)    
   Program: COMPAREB x IEBCOMPR   ZEBCOMPR      (Use 'x' to select one Program) 
   Results: Browse y Print y Delete y           (Y/N for each results action)   
                                                                                
                                                                                
                                                                                
                                                                                
                                                                                
________________________________________________________________________________
Figure 9: PCOMPR Compare Datasets Panel
 
 
    c) The following response is normal:
 
         Working...
         YOU ARE COMPARING A DATA SET TO ITSELF
         ***
        
    d) Press ENTER to continue into a browse session showing COMPARE
       results as in the following representative figure.  Output will
       vary based on installed version of COMPARE.
 
________________________________________________________________________________
 LARRY01.COMPARE.Dyyjjj.Thhmmss on TSO00A --------------------------------------
 Command ===>                                                                   
1       10        20        30        40        50        60        70        80
A---+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+
1PAGE  0001                                                  hh:mm:ss  ccyy.jjj 
-VOL=SER=PUB006  MEMBER=$INST00   OLD DSN=CCOMPR.V0R9M01.CNTL                   
-VOL=SER=PUB006  MEMBER=$INST00   NEW DSN=CCOMPR.V0R9M01.CNTL                   
                                                                                
                                                                                
      0 BLOCKS OF COMPARE ERRORS DETECTED                                       
- Command: COMPARE 'CCOMPR.V0R9M01.CNTL($INST00)' 'CCOMPR.V0R9M01.CNTL($INST00)'
- Results: LARRY01.COMPARE.Dyyjjj.Thhmmss                                       
******EOF-TTR=00010100************************************ BOTTOM OF DATA ******
________________________________________________________________________________
Figure 10: Representative COMPARE Browse Session 
           (truncated to 80 characters in this figure)
 
 
 
    e) Press PF3 to terminate browse session.  The following response is 
       displayed by PRINTOFF after printing the compare results to SYSOUT
       CLASS=A.
 
         PROCESSING HAS BEEN COMPLETED FOR DATASET:  
         LARRY01.COMPARE.Dyyjjj.Thhmmss              
         ***                                         
 
    f) Validation for CCOMPR is complete.
 
 
+--------------------------------------------------------------------+
| Step 11. Done                                                      |
+--------------------------------------------------------------------+
 
 
    a) Congratulations!  You completed the installation for CCOMPR.


+--------------------------------------------------------------------+
| Step 12. Integrate CCOMPR into ISPF UTILITY SELECTION MENU (=3)    |
+--------------------------------------------------------------------+
 
 
    a) To integrate CCOMPR as option C from the ISPF Utilities Selection
       menu, follow the below steps -                                       
 
*     It is suggested that CCOMPR be invoked from an ISPF menu,            
*  preferably, the Utilities menu, as option 3.C, using the following       
*  menu entry:                                                       
*
*    %   C +COMPARE     - Compare Two Online Datasets using COMPARE
*
*     Assume an ISPF menu panel has the following sections, the
*  'NEW ENTRY' line can be added to invoke CCOMPR when menu option 'C'
*  is typed followed by the ENTER key
*
*    )PROC
*      &ZSEL = TRANS( TRUNC (&ZCMD,'.')
*                    1,'CMD(xxxxx) NEWAPPL(ISR)'
*                    6,'PGM(xxxxxx)'            
*                    .
*                    .
*                    C,'CMD(CCOMPR 0) NEWAPPL(CMPR)'     <-- NEW ENTRY
*                    .
*                    .
*                  ' ',' '
*                    *,'?' )
*    )END
*
       
                                                                            
                                                                            



Enjoy CCOMPR!
                                                                            

======================================================================
* IV. S o f t w a r e   I n v e n t o r y   L i s t                  |
======================================================================

  - CCOMPR.V0R9M01.ASM 
   . CCOMPR      TSO CP to compare two Datasets
   . CHKDSN      CHKDSN program                       
   . CHKDSNMS    CHKDSN messages program                

  - CCOMPR.V0R9M01.CLIST
   . README      Dummy member, this is intentional

  - CCOMPR.V1R1M01.CNTL
   . $INST00     Define Alias for HLQ CCOMPR       
   . $INST01     Load CNTL data set from distribution tape (HET)
   . $INST02     Load other data sets from distribution tape (HET)
   . $INST03     Install TSO Parts
   . $INST04     Install CCOMPR CP
   . $INST05     Install ISPF Parts
   . $INST40     Install CHKDSN CPs
   . $RECVXMI    Receive XMI SEQ to MVS PDSs via RECV370
   . DSCLAIMR    Disclaimer
   . PREREQS     Required User-mods
   . README      Documentation and Installation instructions

  - CCOMPR.V0R9M01.HELP
   .CHKDSN       CHKDSN TSO help file                

  - CCOMPR.V0R9M01.ISPF
   . C$CCOMPR    CLIST to invoke Compare Panel from TSO command line 
   . CCOMPR      Compare two Datasets program                               
   . PCOMPR      Compare two Datasets panel                                 
   . HCOMPR      Compare two Datasets help panel                                
   . CMPR00      Compare Message file                                       
   . CMPR01      Compare Message file                                       

  - CCOMPR.V0R9M01.MACLIB
   . DVCTBL      Device Table Entries
   . ISPFPL      ISPF Parameter Address List (10)       
   . ISPFSRV     ISPF Service keywords                
   . LBISPL      Call to ISPLINK (LarryB version)      
   . MISCDC      Constants for double-quotes and Apostrophe
   . MOVEC       Move VAR at R6, len reflected in R8 (requires MOVEI)
   . MOVEI       Init R6 w/ addr of VAR, init R8 to 0
   . MOVER       Move VAR at R6 until BLANK is found         
   . MOVEV       Move VAR at R6                      
   . RDTECOMA    DateTime comm area                   
   . RDTECOMC    DateTime comm area (COBOL)          
   . RTRIM       Remove trailing spaces          
   . SVC78A      SVC78 message area
       
       
                                                                            

======================================================================
* V. I n s t a l l a t i o n   o f   C B T 2 9 6   C O M P A R E     |
======================================================================

 
    a) Download CBT296 from CBTTAPE.ORG to your PC device.
       https://www.cbttape.org/cbtdowns.htm
 
    b) Unzip CBT296 which creates file FILE296.XMI,
 
    c) Receive FILE296.XMI to MVS using RECV370.
    
    d) FILE296.XMI contains member COMPARE, comprised of a multi-step 
       JOB with in-line source content. 
        
    e) Several modification must be made to member COMPARE 
       for MVS38J systems.
     
    f) Edit the COMPARE member  
     
    g) Modify the JOB card (first 3 lines...) per you system standards 
       including any security system parms.
     
    h) To set expectations, only steps ASM1, LNK1, ASM2, LNK2 and COPH
       are to be executed.            

    i) Modify step ASM1 to use IFOX00 assembler and correct SYSLIB  
       per your system standards.
        
       For reference, my MVS38J system modification for ASM1:
  +----------------------------------------------------------------------------+
  | 0        1         2         3         4         5         6         7     |
  | 1...5....0....5....0....5....0....5....0....5....0....5....0....5....0....5|
  | //ASM1  EXEC  PGM=IFOX00,REGION=6000K,                    <-- MODIFICATION |
  | //             PARM=(DECK,NOOBJECT,NORLD,RENT,TERM,'XREF(SHORT)')          |
  | //SYSLIB   DD  DSN=SYS1.AMODGEN,DISP=SHR                  <-- MODIFICATION |
  | //         DD  DSN=SYS1.MACLIB,DISP=SHR                                    |
  | //SYSUT1   DD  UNIT=SYSDA,SPACE=(CYL,(10,5))                               |
  | //SYSUT2   DD  UNIT=SYSDA,SPACE=(CYL,(10,5))                               |
  | //SYSUT3   DD  UNIT=SYSDA,SPACE=(CYL,(10,5))                               |
  | //SYSPUNCH DD  UNIT=SYSDA,SPACE=(TRK,(5,5)),DISP=(,PASS),DSN=&&X,          |
  | //         DCB=BLKSIZE=3120                                                |
  | //SYSPRINT DD  SYSOUT=*                                                    |
  | //SYSTERM  DD  SYSOUT=*                                                    |
  | //SYSLIN   DD  DUMMY                                                       |
  | //SYSIN    DD  *                                                           |
  |                                                                            |
  +----------------------------------------------------------------------------+

    j) Modify step LNK1 to correct SYSLMOD as SYS2.CMDLIB or           
       per your system standards.
        
       For reference, my MVS38J system modification for LNK1:
  +----------------------------------------------------------------------------+
  | 0        1         2         3         4         5         6         7     |
  | 1...5....0....5....0....5....0....5....0....5....0....5....0....5....0....5|
  | //LNK1   EXEC  PGM=IEWL,PARM='LIST,MAP,RENT,REUS,REFR',COND=(5,LT)         |
  | //SYSPRINT DD  SYSOUT=*                                                    |
  | //SYSLINX  DD  DSN=&&X,DISP=(OLD,DELETE)                                   |
  | //SYSLMOD  DD  DISP=SHR,DSN=SYS2.CMDLIB(COMPARE)          <-- MODIFICATION |
  | //SYSUT1   DD  UNIT=SYSDA,SPACE=(TRK,(5,5))                                |
  | //SYSLIN   DD  *                                                           |
  |   INCLUDE SYSLINX                                                          |
  |   ALIAS   COMPARE$                                                         |
  |   NAME    COMPARE(R)                                                       |
  | //*                                                                        |
  |                                                                            |
  +----------------------------------------------------------------------------+

    k) Modify step ASM2 to use IFOX00 assembler and correct SYSLIB  
       per your system standards.
        
       For reference, my MVS38J system modification for ASM2:
  +----------------------------------------------------------------------------+
  | 0        1         2         3         4         5         6         7     |
  | 1...5....0....5....0....5....0....5....0....5....0....5....0....5....0....5|
  | //ASM2  EXEC  PGM=IFOX00,REGION=6000K,                    <-- MODIFICATION |
  | //             PARM=(DECK,NOOBJECT,NORLD,TERM,                             |
  | //             'XREF(SHORT)')                                              |
  | //SYSLIB   DD  DSN=SYS1.AMODGEN,DISP=SHR                  <-- MODIFICATION |
  | //         DD  DSN=SYS1.MACLIB,DISP=SHR                                    |
  | //SYSUT1   DD  UNIT=SYSDA,SPACE=(CYL,(10,5))                               |
  | //SYSUT2   DD  UNIT=SYSDA,SPACE=(CYL,(10,5))                               |
  | //SYSUT3   DD  UNIT=SYSDA,SPACE=(CYL,(10,5))                               |
  | //SYSPUNCH DD  UNIT=SYSDA,SPACE=(TRK,(5,5)),DISP=(,PASS),DSN=&&X,          |
  | //         DCB=BLKSIZE=3120                                                |
  | //SYSPRINT DD  SYSOUT=*                                                    |
  | //SYSLIN   DD  DUMMY                                                       |
  | //SYSTERM  DD  SYSOUT=*                                                    |
  | //SYSIN    DD  *                                                           |
  |                                                                            |
  +----------------------------------------------------------------------------+

    l) Modify step LNK2 to correct SYSLMOD as SYS2.CMDLIB or           
       per your system standards.
        
       For reference, my MVS38J system modification for LNK2:
  +----------------------------------------------------------------------------+
  | 0        1         2         3         4         5         6         7     |
  | 1...5....0....5....0....5....0....5....0....5....0....5....0....5....0....5|
  | //LNK2   EXEC  PGM=IEWL,PARM='MAP',COND=(5,LT)                             |
  | //SYSPRINT DD  SYSOUT=*                                                    |
  | //SYSLIN   DD  DSN=&&X,DISP=(OLD,DELETE)                                   |
  | //SYSLMOD  DD  DISP=SHR,DSN=SYS2.CMDLIB(COMPAREB)         <-- MODIFICATION |
  | //SYSUT1   DD  UNIT=SYSDA,SPACE=(TRK,(5,5))                                |
  |                                                                            |
  +----------------------------------------------------------------------------+

    m) Step COPH uses SYSUT2 as SYS2.HELP.  Modify only if your system
       standard uses a different HELP PDS.

    n) Change //* card to // card to stop execution after step COPH
       This is line 3567 on my version!
        
       For reference, my MVS38J system modification for end of step COPH:
  +----------------------------------------------------------------------------+
  | 0        1         2         3         4         5         6         7     |
  | 1...5....0....5....0....5....0....5....0....5....0....5....0....5....0....5|
  |       'INVOKE' OR '$'.                                                     |
  | //                                                        <-- MODIFICATION |
  | //COPP   EXEC  PGM=IEBGENER,COND=(5,LT)                                    |
  |                                                                            |
  +----------------------------------------------------------------------------+

    o) Submit the job.
        
    p) All return codes should be ZEROS for steps
       ASM1, LNK1, ASM2, LNK2 and COPH
     
    q) Congratulations!  You completed the install of CBT296 COMPARE/COMPAREB.
       
                  
       
======================================================================
* VI. I n s t a l l a t i o n   o f   Z E B C O M P R   Z A P        |
======================================================================

 
    a) Although CBT Tape #316 includes a ZEBCOMPR ZAP, it is not compatable
       with MVS 3.8J.                          
        
       Below is a modified ZAP JCL for MVS 3.8J to be used after copying
       IEBCOMPR to ZEBCOMPR as noted via CBT Tape #316 notes:
        
______________________________________________________________________
//ZWBCOMPR JOB (SYS),'ZEBCOMPR MVS38J ZAP',  <-- Review and Modify 
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//*                                                               
//* CBT File 316     ZEBCOMPR Zap                             
//*                                                               
//*
//*********************************************************************         
//*                                                                   *         
//*  THIS ZAP MODIFIES THE 'ZEBCOMPR' LOAD MODULE, WHICH WAS CREATED  *         
//*  BY COPYING THE IBM UTILITY 'IEBCOMPR' AND RENAMING THE COPY.     *         
//*                                                                   *         
//*  THE ZAP CAUSES UNMATCHED RECORDS TO BE DISPLAYED IN EBCDIC       *         
//*  INSTEAD OF HEXADECIMAL FORMAT.                                   *         
//*                                                                   *         
//*  ZAP CREATED BY BILL GODFREY, PLANNING RESEARCH CORPORATION.      *         
//*  JUNE 12 1981.                                                    *         
//*                                                                   *         
//*                                                                   *         
//*  LARRY BELMONTES Modified for MVS38J , VERIFY AT 1C88             *         
//*                                                                   *         
//*********************************************************************         
//*                                                                             
//S1 EXEC PGM=AMASPZAP                                                          
//SYSPRINT   DD SYSOUT=*                                                        
//SYSLIB     DD DSN=SYS1.LINKLIB,DISP=SHR    <-- Review and Modify
//SYSIN DD *                                                                    
  NAME ZEBCOMPR MAIN                                                            
  VER 1C88 1B99,4392,0000,1869,8890,0004,4293,0000,4263,0001                    
  REP 1C88 0590,D200,3000,2000,4120,2001,4130,3001,0689,07FE                    
//                                                                              
______________________________________________________________________
 
 
 
 
