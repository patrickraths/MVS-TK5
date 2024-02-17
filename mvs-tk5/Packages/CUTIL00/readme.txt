CUTIL00 for MVS3.8J / Hercules                                               
==============================                                               


Date: 10/05/2021  Release V1R1M05
       4/10/2021  Release V1R1M00
       5/03/2020  Release V1R0M10
       3/20/2020  Release V1R0M00  **INITIAL software distribution

*  Author: Larry Belmontes Jr.
*          https://ShareABitOfIT.net/CUTIL00-for-mvs-3-8j/
*          Copyright (C) 2020-2021 Larry Belmontes, Jr.


---------------------------------------------------------------------- 
|    CUTIL00      I n s t a l l a t i o n   R e f e r e n c e        | 
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
|    CUTIL00      C h a n g e   H i s t o r y                        | 
---------------------------------------------------------------------- 
*
*  MM/DD/CCYY Version  Change Description
*  ---------- -------  -----------------------------------------------
*  10/05/2021 1.1.05   - Add new functions LEN SLEN OVERLAY UTDSN TRUNC
*                      - Correction to REPLACE function
*                      - Load CUTILTBL and call via BALR
*                      - Miscellaneous documentation and program updates
*
*  04/10/2021 1.1.00   - Add new functions GET1 PUT1 MCAL
*                      - Externalize constants and tables to new program
*                      - Miscellaneous documentation and program updates
*
*  05/03/2020 1.0.10   - Change software distribution packaging and
*                        installation procedure to use Hercules 
*                        Emulated Tape (HET)
*                      - No change to CUTIL00 program
*
*  04/20/2020 1.0.01   - Correction to Step ADDHELP in $inst01.JCL to
*                        load two HELP members instead of one
*                      - Thanks to Tom Armstrong!!
*
*  03/20/2020 1.0.00   Initial version released to MVS 3.8J
*                      hobbyist public domain
*
*
======================================================================
* I. C o n t e n t   o f   Z I P   F i l e                           |
======================================================================

o  $INST00.JCL          Define Alias for HLQ CUTIL00 in Master Catalog
 
o  $INST01.JCL          Load CNTL data set from distribution tape
 
o  $RECVXMI.JCL         Receive XMI SEQ to MVS PDSs                  
 
o  CUTIL00.V1R1M05.HET  Hercules Emulated Tape (HET) multi-file volume
                        with VOLSER of VS1105 containing software  
                        distribution.
 
o  CUTIL00.V1R1M05.XMI  XMIT file containing software distribution.   
 
o  DSCLAIMR.TXT         Disclaimer
 
o  PREREQS.TXT          Required user-mods 
 
o  README.TXT           This File                                              
 
 
Note:   Although not required to install CUTIL00, two user-mods 
-----   are required before using CUTIL00. See PREREQS.TXT file.
 
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
   CUTIL00.V1R1M05.ASM                          MVSDLB    50    42 PO  FB  84  1
   CUTIL00.V1R1M05.CLIST                        MVSDLB    15    10 PO  FB  66  1
   CUTIL00.V1R1M05.CNTL                         MVSDLB    20    10 PO  FB  50  1
   CUTIL00.V1R1M05.HELP                         MVSDLB     4     2 PO  FB  50  1
   CUTIL00.V1R1M05.ISPF                         MVSDLB     5     3 PO  FB  60  1
   CUTIL00.V1R1M05.MACLIB                       MVSDLB     2     1 PO  FB  50  1
   **END**    TOTALS:      96 TRKS ALLOC        68 TRKS USED       6 EXTENTS    
    
    
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
| Step 1. Define Alias for HLQ CUTIL00 in MVS User Catalog           |
+--------------------------------------------------------------------+
|         JCL Member: CUTIL00.V1R1M05.CNTL($INST00)                  |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//CUTIL000 JOB (SYS),'Define CUTIL00 Alias', <-- Review and Modify 
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  CUTIL00 for MVS3.8J TSO / Hercules                  *
//* *  JOB: $INST00  Define Alias for HLQ CUTIL00          *
//* *  Note: The master catalog password will be required  *
//* -------------------------------------------------------*
//DEFALIAS EXEC PGM=IDCAMS 
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
 PARM GRAPHICS(CHAIN(SN))
 LISTCAT ALIAS  ENT(CUTIL00) 
 IF LASTCC NE 0 THEN -
    DEFINE ALIAS(NAME(CUTIL00) RELATE(SYS1.UCAT.MVS))                          
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
|         JCL Member: CUTIL00.V1R1M05.CNTL($RECVXMI)                 |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//RECV000A JOB (SYS),'Receive CUTIL00 XMI',      <-- Review and Modify
//             CLASS=A,MSGCLASS=X,REGION=0M,     <-- Review and Modify
//             MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  JOB: $RECVXMI  Receive Application XMI Files        *
//* -------------------------------------------------------*
//RECV     PROC HLQ=CUTIL00,VRM=V1R1M05,TYP=XXXXXXXX,
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
//CLIST    EXEC RECV,TYP=CLIST,DSPACE='(TRK,(15,02,02))'
//ISPF     EXEC RECV,TYP=ISPF,DSPACE='(TRK,(05,05,10))'
//ASM      EXEC RECV,TYP=ASM,DSPACE='(TRK,(50,10,10))'
//MACLIB   EXEC RECV,TYP=MACLIB,DSPACE='(TRK,(02,02,02))'
//
______________________________________________________________________
Figure 2: $RECVXMI.JCL
 
 
    a) Transfer CUTIL00.V1R1M05.XMI to MVS using your 3270 emulator.
       
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
 
       CUTIL00.V1R1M05.ASM   
       CUTIL00.V1R1M05.CLIST 
       CUTIL00.V1R1M05.CNTL  
       CUTIL00.V1R1M05.HELP  
       CUTIL00.V1R1M05.ISPF  
       CUTIL00.V1R1M05.MACLIB
 
    f) Subsequent installation steps will be submitted from members
       contained in the CNTL data set.
 
    g) Proceed to STEP 6.   ****
 
+--------------------------------------------------------------------+
| Step 4. Load CNTL data set from distribution tape                  |
+--------------------------------------------------------------------+
|         JCL Member: CUTIL00.V1R1M05.CNTL($INST01)                  |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//CUTIL001 JOB (SYS),'Install CNTL PDS',     <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  CUTIL00 for MVS3.8J TSO / Hercules                  *
//* *  JOB: $INST01  Load CNTL PDS from distribution tape  *
//* *  Note: Uses tape drive 480                           *
//* -------------------------------------------------------*
//LOADCNTL PROC HLQ=CUTIL00,VRM=V1R1M05,TVOLSER=VS1105,      
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
 
       DEVINIT 480 X:\dirname\CUTIL00.V1R1M05.HET READONLY=1
 
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
|         JCL Member: CUTIL00.V1R1M05.CNTL($INST02)                  |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//CUTIL002 JOB (SYS),'Install Other PDSs',   <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  CUTIL00 for MVS3.8J TSO / Hercules                  *
//* *  JOB: $INST02  Load other PDS from distribution tape *
//* *  Tape Volume:  File 1 - CNTL                         *
//* *                File 2 - CLIST                        *
//* *                File 3 - HELP                         *
//* *                File 4 - ISPF                         *
//* *                File 5 - ASM                          *
//* *                File 6 - MACLIB                       *
//* *  Note: Default TAPE=480, DASD=3350 on MVSDLB         *
//* -------------------------------------------------------*
//LOADOTHR PROC HLQ=CUTIL00,VRM=V1R1M05,TVOLSER=VS1105,            
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
//             SPACE=(TRK,(15,02,02)),DISP=(,CATLG),
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=3600) 
//HELP     DD  DSN=&HLQ..&VRM..HELP,UNIT=&DUNIT,VOL=SER=&DVOLSER,
//             SPACE=(TRK,(04,02,02)),DISP=(,CATLG),
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=3600) 
//ISPF     DD  DSN=&HLQ..&VRM..ISPF,UNIT=&DUNIT,VOL=SER=&DVOLSER,
//             SPACE=(TRK,(05,05,10)),DISP=(,CATLG),
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=3600) 
//ASM      DD  DSN=&HLQ..&VRM..ASM,UNIT=&DUNIT,VOL=SER=&DVOLSER,
//             SPACE=(TRK,(50,10,10)),DISP=(,CATLG),
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
 
       DEVINIT 480 X:\dirname\CUTIL00.V1R1M05.HET READONLY=1
 
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
|         JCL Member: CUTIL00.V1R1M05.CNTL($UP1105)                  |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//CUTIL00U JOB (SYS),'Upgrade CUTIL00',      <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  CUTIL00 for MVS3.8J TSO / Hercules                  *
//* *                                                      *
//* *  JOB: $UP1105                                        *
//* *       Upgrade CUTIL00 Software from release V1R1M00  *
//* *                                                      *
//* *  Review JCL before submitting!!                      *
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
//* *  Update TSO parts for this release distribution      *
//* -------------------------------------------------------*
//* *  Note: Duplicate members are over-written.           *
//* -------------------------------------------------------*
//TSOPARTS EXEC PGM=IEBCOPY                                           
//SYSPRINT DD  SYSOUT=*                                              
//INCLIST  DD  DSN=CUTIL00.V1R1M05.CLIST,DISP=SHR            
//INHELP   DD  DSN=CUTIL00.V1R1M05.HELP,DISP=SHR             
//OUTCLIST DD  DSN=SYS2.CMDPROC,DISP=SHR          <--TARGET            
//OUTHELP  DD  DSN=SYS2.HELP,DISP=SHR             <--TARGET
//SYSIN    DD  *                                                        
    COPY INDD=((INCLIST,R)),OUTDD=OUTCLIST
    SELECT MEMBER=CCUTIL0V
    COPY INDD=((INHELP,R)),OUTDD=OUTHELP
    SELECT MEMBER=CUTIL00
/*                                                                  
//* -------------------------------------------------------*
//* *  Assemble Link-Edit CUTILTBL to SYS2.CMDLIB          *
//* -------------------------------------------------------*
//CUTILTBL EXEC  ASML,HLQ=CUTIL00,VRM=V1R1M05,MBR=CUTILTBL, 
//         PARM.LKED='MAP,LIST,LET,RENT,XREF,REUS,REFR'
//LKED.SYSLMOD DD  DISP=SHR,
//         DSN=SYS2.CMDLIB(&MBR)                  <--TARGET 
//*
//* -------------------------------------------------------*
//* *  Assemble Link-Edit CUTIL00 to SYS2.CMDLIB           *
//* -------------------------------------------------------*
//CUTIL00  EXEC  ASML,HLQ=CUTIL00,VRM=V1R1M05,MBR=CUTIL00,
//         PARM.LKED='MAP,LIST,LET,RENT,XREF,REUS,REFR'
//LKED.SYSLMOD DD  DISP=SHR,
//         DSN=SYS2.CMDLIB(&MBR)                  <--TARGET 
//*
//* -------------------------------------------------------*
//* *  If SYSn.LINKLIB or SYSn.CMDLIB is updated           *
//* -------------------------------------------------------*
//DBSTOP   EXEC DBSTOP,
//             COND=(0,NE)               
//DBSTART  EXEC DBSTART,
//             COND=(0,NE)                
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
//ISPFPRTS EXEC PARTSI,HLQ=CUTIL00,VRM=V1R1M05,
//         CLIB='XXXXXXXX.ISPCLIB',                <--TARGET
//         MLIB='XXXXXXXX.ISPMLIB',                <--TARGET
//         PLIB='XXXXXXXX.ISPPLIB',                <--TARGET
//         SLIB='XXXXXXXX.ISPSLIB',                <--TARGET
//         TLIB='XXXXXXXX.ISPTLIB'                 <--TARGET
//SYSIN    DD  *
   COPY INDD=((ISPFIN,R)),OUTDD=CLIBOUT
   SELECT MEMBER=NO#MBR#                     /*dummy entry no mbrs! */
   COPY INDD=((ISPFIN,R)),OUTDD=MLIBOUT
   SELECT MEMBER=NO#MBR#                     /*dummy entry no mbrs! */
   COPY INDD=((ISPFIN,R)),OUTDD=PLIBOUT
   SELECT MEMBER=PCUTIL00
   SELECT MEMBER=HCUTIL00
   COPY INDD=((ISPFIN,R)),OUTDD=SLIBOUT
   SELECT MEMBER=NO#MBR#                     /*dummy entry no mbrs! */
   COPY INDD=((ISPFIN,R)),OUTDD=TLIBOUT
   SELECT MEMBER=NO#MBR#                     /*dummy entry no mbrs! */
// 
______________________________________________________________________
Figure 5: $UP1105.JCL  Upgrade from previous version to V1R1M05
 
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
 
       - Upgrading from V1R1M00, use $UP1105.JCL
       - V1R0M00 is initial release, thus, no updates available!
 
    d) After upgrade is applied, proceed to validation, STEP 11.
 
 
+--------------------------------------------------------------------+
| Step 7. Install TSO parts                                          |
+--------------------------------------------------------------------+
|         JCL Member: CUTIL00.V1R1M05.CNTL($INST03)                  |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//CUTIL003 JOB (SYS),'Install TSO Parts',    <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  CUTIL00 for MVS3.8J TSO / Hercules                  *
//* *                                                      *
//* *  JOB: $INST03  Install TSO parts                     *
//* *                                                      *
//* *  Note: Duplicate members are over-written.           *
//* -------------------------------------------------------*
//STEP001  EXEC PGM=IEBCOPY                                           
//SYSPRINT DD  SYSOUT=*                                              
//INCLIST  DD  DSN=CUTIL00.V1R1M05.CLIST,DISP=SHR            
//INHELP   DD  DSN=CUTIL00.V1R1M05.HELP,DISP=SHR             
//OUTCLIST DD  DSN=SYS2.CMDPROC,DISP=SHR                               
//OUTHELP  DD  DSN=SYS2.HELP,DISP=SHR
//SYSIN    DD  *                                                        
    COPY INDD=((INCLIST,R)),OUTDD=OUTCLIST
    SELECT MEMBER=CCUTIL00
    SELECT MEMBER=CCUTIL0V
    COPY INDD=((INHELP,R)),OUTDD=OUTHELP
    SELECT MEMBER=CUTIL00
    SELECT MEMBER=CCUTIL00
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
| Step 8. Install CUTIL00 Programs                                   |  
+--------------------------------------------------------------------+
|         JCL Member: CUTIL00.V1R1M05.CNTL($INST04)                  |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//CUTIL004 JOB (SYS),'Install CUTIL00',      <-- Review and Modify 
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  CUTIL00 for MVS3.8J TSO / Hercules                  *
//* *                                                      *
//* *  JOB: $INST04  Install CUTIL00 Software              *
//* *                                                      *
//* *  - Install libraries marked...                       *
//* *    - Search for '<--TARGET'                          *
//* *    - Update install libraries per your               *
//* *      installation standard                           *
//* *                                                      *
//* *  NOTE:                                               *
//* *  -----                                               *
//* *  Two user-mods, ZP60014 and ZP60038, are REQUIRED.   *
//* *                                                      *
//* *  For more information, refer to program CUTIL00.     *
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
//CUTIL00  EXEC  ASML,HLQ=CUTIL00,VRM=V1R1M05,MBR=CUTIL00,
//         PARM.LKED='MAP,LIST,LET,RENT,XREF,REUS,REFR'
//LKED.SYSLMOD DD  DISP=SHR,
//         DSN=SYS2.CMDLIB(&MBR)                  <--TARGET 
//*
//* -------------------------------------------------------*
//* *  Assemble Link-Edit CUTILTBL to SYS2.CMDLIB          *
//* -------------------------------------------------------*
//CUTILTBL EXEC  ASML,HLQ=CUTIL00,VRM=V1R1M05,MBR=CUTILTBL, 
//         PARM.LKED='MAP,LIST,LET,RENT,XREF,REUS,REFR'
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
|         JCL Member: CUTIL00.V1R1M05.CNTL($INST05)                  |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//CUTIL005 JOB (SYS),'Install ISPF Parts',   <-- Review and Modify 
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  Install CUTIL00 ISPF 2.0 Panels, CLIST and Messages *
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
//ISPF     EXEC PARTSI,HLQ=CUTIL00,VRM=V1R1M05,
//         CLIB='XXXXXXXX.ISPCLIB',                <--TARGET
//         MLIB='XXXXXXXX.ISPMLIB',                <--TARGET
//         PLIB='XXXXXXXX.ISPPLIB',                <--TARGET
//         SLIB='XXXXXXXX.ISPSLIB',                <--TARGET
//         TLIB='XXXXXXXX.ISPTLIB'                 <--TARGET
//SYSIN    DD  * 
   COPY INDD=((ISPFIN,R)),OUTDD=CLIBOUT
   SELECT MEMBER=CCUTIL0I
   COPY INDD=((ISPFIN,R)),OUTDD=MLIBOUT
   SELECT MEMBER=CUTIL0 
   COPY INDD=((ISPFIN,R)),OUTDD=PLIBOUT
   SELECT MEMBER=PCUTIL00
   SELECT MEMBER=HCUTIL00
   COPY INDD=((ISPFIN,R)),OUTDD=SLIBOUT
   SELECT MEMBER=NO#MBR#                     /*dummy entry no mbrs! */
   COPY INDD=((ISPFIN,R)),OUTDD=TLIBOUT
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
|         JCL Member: CUTIL00.V1R1M05.CNTL($INST40)                  |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//CUTIL040 JOB (SYS),'Install Other Pgms',   <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  CUTIL00 for MVS3.8J TSO / Hercules                  *
//* *                                                      *
//* *  JOB: $INST40 Install Other Programs                 *
//* *       Install xxxxxx   Programs                      *
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
 
 
    a) Member $INST40 installs additional programs.
 
       Note:  If no other programs are included for this distribution,
       -----  an IEFBR14 step is executed.
 
    b) Review and update JOB statement and other JCL to conform to your
       installation standard.                                       
 
    c) Submit the job.
 
    d) Review job output for successful completion.
 
 
+--------------------------------------------------------------------+
| Step 11. Validate CUTIL00                                          |
+--------------------------------------------------------------------+
|         JCL Member: CUTIL00.V1R1M05.CNTL($IVP1)                    |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//IVP1     JOB (SYS),'CUTIL00 IPV1',         <-- Review and Modify           
//         CLASS=A,MSGCLASS=A,               <-- Review and Modify 
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify 
//* -------------------------------------------------------*
//* *  CUTIL00 for MVS3.8J TSO / Hercules                  *
//* *                                                      *
//* *  JOB: $IVP1                                          *
//* *       Run CUTIL00 Validation                         *
//* *                                                      *
//* *  CUTIL00 validation via CCLIST0V using BATCH TSO     *
//* *  of documented function in program documentation.    *
//* *                                                      *
//* *  Note: CLIST are resolved from SYS2.CMDPROC          *
//* *        and tagged with <--TARGET for search          *
//* *        purposes.                                     *
//* -------------------------------------------------------*
//BATCHTSO PROC
//STEP01   EXEC PGM=IKJEFT01
//SYSPROC  DD  DISP=SHR,DSN=SYS2.CMDPROC           <--TARGET
//SYSPRINT DD  SYSOUT=*
//SYSTSPRT DD  SYSOUT=*
//SYSTSIN  DD  DUMMY       Command Line Input
//         PEND
//*
//TESTIT0  EXEC BATCHTSO 
//STEP01.SYSTSIN DD *
CCUTIL0V                                  
/*
//
______________________________________________________________________
Figure 10: $IVP1 JCL
 
 
    a) Member $IVP1 validates CUTIL00.
 
    b) Review and update JOB statement and other JCL to conform to your
       installation standard.                                       
 
    c) Submit the job.
 
    d) Review job output for successful execution.  Return codes will
       vary but a PASS / FAIL message is displayed for each function.
       Expected results are all PASS.                                 
 
 
+--------------------------------------------------------------------+
| Step 12. CUTIL00 Samples                                           |
+--------------------------------------------------------------------+
|         JCL Member: CUTIL00.V1R1M05.CNTL($SAMPLES)                 |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//IVPS     JOB (SYS),'CUTIL00 IPVS',         <-- Review and Modify           
//         CLASS=A,MSGCLASS=A,               <-- Review and Modify 
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify 
//* -------------------------------------------------------*
//* *  CUTIL00 for MVS3.8J TSO / Hercules                  *
//* *                                                      *
//* *  JOB: $IVP1                                          *
//* *       Run CUTIL00 Samples                            *
//* *                                                      *
//* *  CUTIL00 validation via CCUTIL00 using BATCH TSO     *
//* *  of sample functions.                                *
//* *                                                      *
//* *  Note: CLIST are resolved from SYS2.CMDPROC          *
//* *        and tagged with <--TARGET for search          *
//* *        purposes.                                     *
//* -------------------------------------------------------*
//BATCHTSO PROC
//STEP01   EXEC PGM=IKJEFT01
//SYSPROC  DD  DISP=SHR,DSN=SYS2.CMDPROC           <--TARGET
//SYSPRINT DD  SYSOUT=*
//SYSTSPRT DD  SYSOUT=*
//SYSTSIN  DD  DUMMY       Command Line Input
//         PEND
//*
//TESTITS  EXEC BATCHTSO 
//STEP01.SYSTSIN DD *
CCUTIL00 ABOUT VERBOSE(N)
CCUTIL00 LTRIM    VAR01('   LEADING SPACES') VAR02('')  VERBOSE(N)
CCUTIL00 RTRIM    VAR01('TRAILING SPACES  ') VAR02('')  VERBOSE(N)
CCUTIL00 TRIM     VAR01(' TRIM   MY  DATA ') VAR02('')  VERBOSE(N)
CCUTIL00 TRIM$    VAR01(' TRIM   MY  DATA ') VAR02('')  VERBOSE(N)
CCUTIL00 INDEX    VAR01('MY, STRING, OK?   ') VAR02('","')  VERBOSE(N)
CCUTIL00 INDEXB   VAR01('MY, STRING, OK?   ') VAR02('","')  VERBOSE(N)
CCUTIL00 ISNUM    VAR01('0123456789') VERBOSE(N)
CCUTIL00 ISALPHA  VAR01('ABCDEFGHIJ') VERBOSE(N)
CCUTIL00 ISLOWER  VAR01('abcdefghij') VERBOSE(N)
CCUTIL00 ISUPPER  VAR01('ABCDEFGHIJ') VERBOSE(N)
CCUTIL00 ISBLANK  VAR01('         ') VERBOSE(N)
CCUTIL00 ISDSN    VAR01('A.A1234567') VERBOSE(N)
CCUTIL00 ECHO     VAR01('MY DATA TO DISPLAY') VERBOSE(N)
CCUTIL00 ECHOQ    VAR01('MY DATA TO DISPLAY') VERBOSE(N)
CCUTIL00 REVRS    VAR01('ABCDEFGHIJKLM96%QRS') VAR02('') VERBOSE(N)
CCUTIL00 UPPERC   VAR01('ABCDEFGHIJKLMNOPQRS') VERBOSE(N)
CCUTIL00 LOWERC   VAR01('ABCDEFGHIJKLMNOPQRS') VAR02('') VERBOSE(N)
CCUTIL00 COUNT    VAR01('MY NAME IS DINO, BIG DINO.') VAR02('"DINO"') -        
 VERBOSE(N)
CCUTIL00 FIND     VAR01('MY NAME IS DINO, BIG DINO.') VAR02('"DINO"') -        
 VERBOSE(N)
CCUTIL00 FINDL    VAR01('MY NAME IS DINO, BIG DINO.') VAR02('"DINO"') -        
 VERBOSE(N)
CCUTIL00 CENTER   VAR01('CENTER THIS T E X T ...       ') VAR02('') -
 VERBOSE(N)
CCUTIL00 LJUST    VAR01(' JUSTIFY THIS TEXT    ') VAR02('') VERBOSE(N)
CCUTIL00 RJUST    VAR01(' JUSTIFY THIS TEXT    ') VAR02('') VERBOSE(N)
CCUTIL00 ZFILL    VAR01('12   ') VAR02('') VERBOSE(N)
CCUTIL00 WORDS    VAR01('  ONE TEWO THREE33 FOUR., FIVE ') VERBOSE(N)
CCUTIL00 GEN#     VAR01('') VERBOSE(N)
CCUTIL00 DD2DSN   VAR01('SYSPROC') VAR02('') VERBOSE(N)
CCUTIL00 JOBINFO  VAR01('') VERBOSE(N)
CCUTIL00 DAYSMM   VAR01('022016') VERBOSE(N)
CCUTIL00 DAYSYY   VAR01('2020') VERBOSE(N)
CCUTIL00 ISLEAP   VAR01('2020') VERBOSE(N)
 
CCUTIL00 CYJ-D8   VAR01('2020061') VAR02('') VERBOSE(N)
CCUTIL00 CYJ-DAY  VAR01('1981061') VAR02('') VERBOSE(N)
CCUTIL00 CYJ-DOW  VAR01('1981061') VAR02('') VERBOSE(N)
CCUTIL00 CYJ-MDCY VAR01('2020061') VAR02('') VERBOSE(N)
 
CCUTIL00 JCY-D8   VAR01('1612017') VAR02('') VERBOSE(N)
CCUTIL00 JCY-DAY  VAR01('0611981') VAR02('') VERBOSE(N)
CCUTIL00 JCY-DOW  VAR01('0611981') VAR02('') VERBOSE(N)
CCUTIL00 JCY-MDCY VAR01('1612017') VAR02('') VERBOSE(N)
 
CCUTIL00 MDCY-D8  VAR01('12101990') VAR02('') VERBOSE(N)
CCUTIL00 MDCY-DAY VAR01('12101990') VAR02('') VERBOSE(N)
CCUTIL00 MDCY-DOW VAR01('12101990') VAR02('') VERBOSE(N)
CCUTIL00 MDCY-CYJ VAR01('12101990') VAR02('') VERBOSE(N)
 
CCUTIL00 DMCY-D8  VAR01('15071987') VAR02('') VERBOSE(N)
CCUTIL00 DMCY-DAY VAR01('15071987') VAR02('') VERBOSE(N)
CCUTIL00 DMCY-DOW VAR01('15071987') VAR02('') VERBOSE(N)
CCUTIL00 DMCY-CYJ VAR01('15071987') VAR02('') VERBOSE(N)
 
CCUTIL00 CYMD-D8  VAR01('19951231') VAR02('') VERBOSE(N)
CCUTIL00 CYMD-DAY VAR01('19951231') VAR02('') VERBOSE(N)
CCUTIL00 CYMD-DOW VAR01('19951231') VAR02('') VERBOSE(N)
CCUTIL00 CYMD-CYJ VAR01('19951231') VAR02('') VERBOSE(N)
 
CCUTIL00 CYDM-D8  VAR01('19951605') VAR02('') VERBOSE(N)
CCUTIL00 CYDM-DAY VAR01('19951605') VAR02('') VERBOSE(N)
CCUTIL00 CYDM-DOW VAR01('19951605') VAR02('') VERBOSE(N)
CCUTIL00 CYDM-CYJ VAR01('19951605') VAR02('') VERBOSE(N)
CCUTIL00 FILL     VAR01('') VAR02('*20') VERBOSE(N)
CCUTIL00 LSTRIP   VAR01(',,28,BC,') VAR02(',') VERBOSE(N)
CCUTIL00 RSTRIP   VAR01(',,28,BC,') VAR02(',') VERBOSE(N)
CCUTIL00 STRIP    VAR01(',,28,BC,') VAR02(',') VERBOSE(N)
CCUTIL00 STRIP$   VAR01(',,28,BC,') VAR02(',') VERBOSE(N)
CCUTIL00 CONCAT   VAR01('STRING DATA 1.') -     
 VAR02('A RESULT STRING 2.') VERBOSE(N)   
CCUTIL00 UNSTR    VAR01('1234567 AND SO ON . I AM 78 LONG. ') -     
 VAR02('7') VERBOSE(N)       
CCUTIL00 REPLACE  VAR01('1234567 AND SO ON . I AM 7879.') -     
 VAR02('"SO ON ","890123456--"') VERBOSE(N)       
CCUTIL00 VEXIST   VAR01('VAR01') VERBOSE(N)
CCUTIL00 VEXIST   VAR01('DDD01') VERBOSE(N)
CCUTIL00 TDSN     VAR01('HERC01.CARDS.') VERBOSE(N)
CCUTIL00 NOW      VAR01('') VERBOSE(N)
CCUTIL00 PAD      VAR01('MAKE ME 30 LONG') VAR02(' 30') VERBOSE (N)
CCUTIL00 GET1V    VAR01('THE TABLE TOP IS CLEAR') VAR02('x11') -
 VERBOSE (N)
CCUTIL00 PUT1V    VAR01('THE TABLE TOP IS CLEAR') VAR02('N22') -
 VERBOSE (N)
CCUTIL00 MCAL     VAR01('') VAR02('') VERBOSE (N)
CCUTIL00 LEN      VAR01(' MY WORD IN THE STRING    ')          -
 VERBOSE (N)
CCUTIL00 SLEN     VAR01(' MY WORD IN THE STRING    ')          -
 VERBOSE (N)
CCUTIL00 OVERLAY  VAR01(' MY TEXT TO BE OVERLAYED OK!! ')      -
 VAR02('"----- ",7') VERBOSE(N)       
CCUTIL00 UTDSN    VAR01('CARDS') VERBOSE (N)                     
CCUTIL00 TRUNC    VAR01('THE MAN WALKED HERE') -           
 VAR02('x07') VERBOSE(N)       
/*
//
______________________________________________________________________
Figure 11: $SAMPLES JCL
 
 
    a) Member $SAMPLES runs the CUTIL00 program samples using PROC CCUTIL00.
 
    b) Review and update JOB statement and other JCL to conform to your
       installation standard.                                       
 
    c) Submit the job.
 
    d) Review job output at your leisure.  Return codes will vary by 
       function.                        
 
 
+--------------------------------------------------------------------+
| Step 13. Validate CUTIL00 ISPF 2.x application                     |
+--------------------------------------------------------------------+
 
 
    a) This step can be omitted if ISPF 2.x is NOT installed on
       your system.  Proceed to the next step.                       
 
    b) From the ISPF Main Menu, select option 6, COMMAND.  The TSO
       COMMAND PROCESSOR panel will display. 
 
    c) Enter the TSO command:
       %CCUTIL0I
 
    d) The panel PCUTIL00, CUTIL00 for MVS 38J, is displayed.
       Type the following information in the upper left corner:
       o  Type JOBINFO for FUNCTION
       o  Type N for VAR1 Quote
       o  Type N for VAR2 Use
       o  Press ENTER                                                         
       o  Results will display under VAR1 ruler on the panel       
          Comprised of three 8-byte fields -
              Userid, TSO proc name, and Logon proc name 
       o  Press PF1 to display help panel, HCUTIL00 
       o  Press PF3 twice to exit help and application panel 
       
    e) Validation for CUTIL00 ISPF 2.x Application is complete.
                                                                            
  
  
  
  
  
Enjoy CUTIL00 for MVS 3.8J!
                                                                            

======================================================================
* IV. S o f t w a r e   I n v e n t o r y   L i s t                  |
======================================================================

  - CUTIL00.V1R1M05.ASM 
 $ . CUTIL00     TSO CP for CLIST Variables           
 $ . CUTILTBL    CUTIL00 table processor                 
      
  - CUTIL00.V1R1M05.CLIST
   . CCUTIL00    Testing harness CLIST               
 $ . CCUTIL0V    IVP CLIST                           

  - CUTIL00.V1R1M05.CNTL
 $ . $INST00     Define Alias for HLQ CUTIL00       
 $ . $INST01     Load CNTL data set from distribution tape (HET)
 $ . $INST02     Load other data sets from distribution tape (HET)
 $ . $INST03     Install TSO Parts
 $ . $INST04     Install CUTIL00 CP
 $ . $INST05     Install ISPF Parts
 # . $INST40     Install Other programs
 # . $UP1105     Upgrade to V1R1M05   from   V1R1M00
 $ . $IVP1       IVP JCL                        
 # . $RECVXMI    Receive XMI SEQ to MVS PDSs via RECV370
 $ . $SAMPLES    Samples JCL                    
 $ . DSCLAIMR    Disclaimer
   . PREREQS     Required User-mods
 $ . README      Documentation and Installation instructions

  - CUTIL00.V1R1M05.HELP
 $ . CUTIL00     CUTIL00 Help member 
   . CCUTIL00    CCUTIL00 Help member 

  - CUTIL00.V1R1M05.ISPF
   . CCUTIL0I    CUTIL00 ISPF CLIST
   . CUTIL0      CUTIL00 Message file
 $ . HCUTIL00    CUTIL00 Help panel
 $ . PCUTIL00    CUTIL00 ISPF panel for command line request
                
  - CUTIL00.V1R1M05.MACLIB
 # . README      Dummy member, this is intentional
       
       
                                                                            
  - After downloading any other required software, if noted,
    consult provided documentation including any configuration 
    steps (if applicable) for software and HELP file installation.
       
       
 $ - Denotes modified software component for          
     THIS DISTRIBUTION relative to prior DISTRIBUTION               
       
 # - Denotes new software component for          
     THIS DISTRIBUTION relative to prior DISTRIBUTION               
       
       
       
       
