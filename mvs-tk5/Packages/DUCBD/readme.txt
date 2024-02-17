DUCBD for MVS3.8J / Hercules                                               
============================                                               


Date: 02/10/2022  Release V1R1M00
      08/10/2020  Release V1R0M00  **INITIAL software distribution

*  Author:  Larry Belmontes Jr.
*           https://ShareABitofIT.net/DUCBD-in-MVS38J
*           Copyright (C) 2020-2022  Larry Belmontes, Jr.


---------------------------------------------------------------------- 
|    DUCBD        I n s t a l l a t i o n   R e f e r e n c e        | 
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
|    DUCBD        C h a n g e   H i s t o r y                        | 
---------------------------------------------------------------------- 
*
*  MM/DD/CCYY Version  Change Description
*  ---------- -------  -----------------------------------------------
*  02/10/2022 1.1.00   - Allow device type filtering for DASD
*                      - Enhance messaging                   
*                      - Add SELECT processing
*                      - Enhance SORT command processing
*                      - Incorporate GETDTE for date-time
*                      - Miscellanous documentation updates
*                      - Add transaction logging
*
*  08/10/2020 1.0.00   Initial version released to MVS 3.8J
*                      hobbyist public domain
*
*
======================================================================
* I. C o n t e n t   o f   Z I P   F i l e                           |
======================================================================

o  $INST00.JCL          Define Alias for HLQ DUCBD in Master Catalog
 
o  $INST01.JCL          Load CNTL data set from distribution tape
 
o  $RECVXMI.JCL         Receive XMI SEQ to MVS PDSs                  
 
o  DUCBD.V1R1M00.HET    Hercules Emulated Tape (HET) multi-file volume
                        with VOLSER of VS1100 containing software
                        distribution.
 
o  DUCBD.V1R1M00.XMI    XMIT file containing software distribution.   
 
o  DSCLAIMR.TXT         Disclaimer
 
o  PREREQS.TXT          Required user-mods 
 
o  README.TXT           This File                                              
 
 
Note:   ISPF v2.0 or higher must be installed under MVS3.8J TSO             
-----   including associated user-mods per ISPF Installation Pre-reqs.
 
Note:   Two user-mods, ZP60014 and ZP60038, are REQUIRED to process
-----   CLIST symbolic variables via the IKJCT441 API on MVS 3.8J
        using this software installation.
        More information at:
        http://www.prycroft6.com.au/vs2mods/
 
Note:   The ISRZ00 ISPF Message set must be installed as a pre-requisite.
-----   Current version can be downloaded and more information at:
        https://www.shareabitofit.net/isrz00-in-mvs38j/
 
Note:   The SHRABIT.MACLIB macro PDS must be installed as a pre-requisite.
-----   For convenience purposes, a current version is installed 
        into DUCBD.V1R1M00.MACLIB.
        Current version can be downloaded and more information at:
        https://www.shareabitofit.net/shrabit-maclib-in-mvs-3-8j/
 
Note:   GETDTE obtains date-time-environment information
-----   and is OPTIONAL for this install.  
        Current version can be downloaded and more information at:
        https://www.shareabitofit.net/getdte-in-mvs38j/    

Note:   CLOGIT performs transaction logging and must be installed as a
-----   pre-requisite.
        Current version can be downloaded and more information at:
        https://www.shareabitofit.net/clglst-in-mvs38j/    

 
======================================================================
* II. P r e - i n s t a l l a t i o n   R e q u i r e m e n t s      |
======================================================================

o  The Master Catalog password may be required for some installation
   steps. 
 
o  Tape files use device 480.
 
o  As default, DASD files will be loaded to VOLSER=MVSDLB, type 3350 device.
    
   Below is a DATASET List after tape distribution load for reference purposes:
    
   DATA-SET-NAME------------------------------- VOLUME ALTRK USTRK ORG FRMT % XT
   DUCBD.V1R1M00.ASM                            MVSDLB    20     9 PO  FB  45  1
   DUCBD.V1R1M00.CLIST                          MVSDLB     2     1 PO  FB  50  1
   DUCBD.V1R1M00.CNTL                           MVSDLB    20     9 PO  FB  45  1
   DUCBD.V1R1M00.HELP                           MVSDLB     2     1 PO  FB  50  1
   DUCBD.V1R1M00.ISPF                           MVSDLB     5     3 PO  FB  60  1
   DUCBD.V1R1M00.MACLIB                         MVSDLB    10     5 PO  FB  50  1
   **END**    TOTALS:      59 TRKS ALLOC        28 TRKS USED       6 EXTENTS    
    
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
| Step 1. Define Alias for HLQ DUCBD in MVS User Catalog             |
+--------------------------------------------------------------------+
|         JCL Member: DUCBD.V1R1M00.CNTL($INST00)                    |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//DUCBD000 JOB (SYS),'Def DUCBD Alias',      <-- Review and Modify 
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  DUCBD for MVS3.8J TSO / Hercules                    *
//* *  JOB: $INST00  Define Alias for HLQ DUCBD            *
//* *  Note: The master catalog password will be required  *
//* -------------------------------------------------------*
//DEFALIAS EXEC PGM=IDCAMS 
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
 PARM GRAPHICS(CHAIN(SN))
 LISTCAT ALIAS  ENT(DUCBD) 
 
 IF LASTCC NE 0 THEN -
    DEFINE ALIAS(NAME(DUCBD) RELATE(SYS1.UCAT.MVS))                          
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
|         JCL Member: DUCBD.V1R1M00.CNTL($RECVXMI)                   |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//RECV000A JOB (SYS),'Receive DUCBD XMI',        <-- Review and Modify
//             CLASS=A,MSGCLASS=X,REGION=0M,     <-- Review and Modify
//             MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  JOB: $RECVXMI  Receive Application XMI Files        *
//* -------------------------------------------------------*
//RECV     PROC HLQ=DUCBD,VRM=V1R1M00,TYP=XXXXXXXX,
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
//ISPF     EXEC RECV,TYP=ISPF,DSPACE='(TRK,(05,05,10))'
//ASM      EXEC RECV,TYP=ASM,DSPACE='(TRK,(20,10,10))'
//MACLIB   EXEC RECV,TYP=MACLIB,DSPACE='(TRK,(10,02,02))'
//
______________________________________________________________________
Figure 2: $RECVXMI.JCL
 
 
    a) Transfer DUCBD.V1R1M00.XMI to MVS using your 3270 emulator.
       
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
 
       DUCBD.V1R1M00.ASM   
       DUCBD.V1R1M00.CLIST 
       DUCBD.V1R1M00.CNTL  
       DUCBD.V1R1M00.HELP  
       DUCBD.V1R1M00.ISPF  
       DUCBD.V1R1M00.MACLIB
 
    f) Subsequent installation steps will be submitted from members
       contained in the CNTL data set.
 
    g) Proceed to STEP 6.   ****
 
 
+--------------------------------------------------------------------+
| Step 4. Load CNTL data set from distribution tape                  |
+--------------------------------------------------------------------+
|         JCL Member: DUCBD.V1R1M00.CNTL($INST01)                    |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//DUCBD001 JOB (SYS),'Install CNTL PDS',     <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  DUCBD for MVS3.8J TSO / Hercules                    *
//* *  JOB: $INST01  Load CNTL PDS from distribution tape  *
//* *  Note: Uses tape drive 480                           *
//* -------------------------------------------------------*
//LOADCNTL PROC HLQ=DUCBD,VRM=V1R1M00,TVOLSER=VS1100,      
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
 
       DEVINIT 480 X:\dirname\DUCBD.V1R1M00.HET READONLY=1
 
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
|         JCL Member: DUCBD.V1R1M00.CNTL($INST02)                    |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//DUCBD002 JOB (SYS),'Install Other PDSs',   <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  DUCBD for MVS3.8J TSO / Hercules                    *
//* *  JOB: $INST02  Load other PDS from distribution tape *
//* *  Tape Volume:  File 1 - CNTL                         *
//* *                File 2 - CLIST                        *
//* *                File 3 - HELP                         *
//* *                File 4 - ISPF                         *
//* *                File 5 - ASM                          *
//* *                File 6 - MACLIB                       *
//* *  Note: Default TAPE=480, DASD=3350 on MVSDLB         *
//* -------------------------------------------------------*
//LOADOTHR PROC HLQ=DUCBD,VRM=V1R1M00,TVOLSER=VS1100,            
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
//             SPACE=(TRK,(10,02,02)),DISP=(,CATLG),
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
 
       DEVINIT 480 X:\dirname\DUCBD.V1R1M00.HET READONLY=1
 
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
|         JCL Member: DUCBD.V1R1M00.CNTL($UP1100)                    |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//DUCBD00U JOB (SYS),'Upgrade DUCBD',        <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  DUCBD for MVS3.8J TSO / Hercules                    *
//* *                                                      *
//* *  JOB: $UP1100                                        *
//* *       Upgrade DUCBD Software from release V1R1M00    *
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
//* *  Assemble Link-Edit DUCBD to ISPLLIB                 *
//* -------------------------------------------------------*
//DUCBD    EXEC  ASML,HLQ=DUCBD,VRM=V1R1M00,MBR=DUCBD,
//         PARM.LKED='MAP,LIST,LET,RENT,XREF,REUS,REFR'
//LKED.SYSLMOD DD  DISP=SHR,
//         DSN=XXXXXXXX.ISPLLIB(&MBR)             <--TARGET 
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
//ISPFPRTS EXEC PARTSI,HLQ=DUCBD,VRM=V1R1M00,
//         CLIB='XXXXXXXX.ISPCLIB',                <--TARGET
//         MLIB='XXXXXXXX.ISPMLIB',                <--TARGET
//         PLIB='XXXXXXXX.ISPPLIB',                <--TARGET
//         SLIB='XXXXXXXX.ISPSLIB',                <--TARGET
//         TLIB='XXXXXXXX.ISPTLIB'                 <--TARGET
//SYSIN    DD  *
   COPY INDD=((ISPFIN,R)),OUTDD=CLIBOUT
   SELECT MEMBER=C$DUCBD
   COPY INDD=((ISPFIN,R)),OUTDD=MLIBOUT
   SELECT MEMBER=NO#MBR#                     /*dummy entry no mbrs! */
   COPY INDD=((ISPFIN,R)),OUTDD=PLIBOUT
   SELECT MEMBER=PDUCBD0
   SELECT MEMBER=HDUCBD0
   SELECT MEMBER=PDUCBT0
   SELECT MEMBER=HDUCBT0
   COPY INDD=((ISPFIN,R)),OUTDD=SLIBOUT
   SELECT MEMBER=NO#MBR#                     /*dummy entry no mbrs! */
   COPY INDD=((ISPFIN,R)),OUTDD=TLIBOUT
   SELECT MEMBER=NO#MBR#                     /*dummy entry no mbrs! */
// 
______________________________________________________________________
Figure 5: $UP1100.JCL  Upgrade from previous version to V1R1M00
 
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
 
       - Upgrading from V1R0M00, use $UP1100.JCL
       - V1R0M00 is initial release, thus, no updates available!
 
    e) After upgrade is applied, proceed to validation, STEP 11.
 
 
+--------------------------------------------------------------------+
| Step 7. Install TSO parts                                          |
+--------------------------------------------------------------------+
|         JCL Member: DUCBD.V1R1M00.CNTL($INST03)                    |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//DUCBD003 JOB (SYS),'Install TSO Parts',    <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  DUCBD for MVS3.8J TSO / Hercules                    *
//* *                                                      *
//* *  JOB: $INST03  Install TSO parts                     *
//* *                                                      *
//* *  Note: Duplicate members are over-written.           *
//* -------------------------------------------------------*
//STEP001  EXEC PGM=IEBCOPY                                           
//SYSPRINT DD  SYSOUT=*                                              
//INCLIST  DD  DSN=DUCBD.V1R1M00.CLIST,DISP=SHR            
//INHELP   DD  DSN=DUCBD.V1R1M00.HELP,DISP=SHR             
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
| Step 8. Install DUCBD Program                                      |  
+--------------------------------------------------------------------+
|         JCL Member: DUCBD.V1R1M00.CNTL($INST04)                    |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//DUCBD004 JOB (SYS),'Install DUCBD',        <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  DUCBD for MVS3.8J TSO / Hercules                    *
//* *                                                      *
//* *  JOB: $INST04  Install DUCBD Programs                *
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
//* *  Assemble Link-Edit DUCBD to ISPLLIB                 *
//* -------------------------------------------------------*
//DUCBD    EXEC  ASML,HLQ=DUCBD,VRM=V1R1M00,MBR=DUCBD,
//         PARM.LKED='MAP,LIST,LET,RENT,XREF,REUS,REFR'
//LKED.SYSLMOD DD  DISP=SHR,
//         DSN=XXXXXXXX.ISPLLIB(&MBR)              <--TARGET 
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
|         JCL Member: DUCBD.V1R1M00.CNTL($INST05)                    |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//DUCBD005 JOB (SYS),'Install ISPF Parts',   <-- Review and Modify 
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  DUCBD in MVS3.8J TSO / Hercules                     *
//* *                                                      *
//* *  JOB: $INST05  Install ISPF parts                    *
//* *                                                      *
//* *  Note: Duplicate members are over-written.           *
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
//ISPF     EXEC PARTSI,HLQ=DUCBD,VRM=V1R1M00,
//         CLIB='XXXXXXXX.ISPCLIB',                <--TARGET
//         MLIB='XXXXXXXX.ISPMLIB',                <--TARGET
//         PLIB='XXXXXXXX.ISPPLIB',                <--TARGET
//         SLIB='XXXXXXXX.ISPSLIB',                <--TARGET
//         TLIB='XXXXXXXX.ISPTLIB'                 <--TARGET
//ADDCLIB.SYSIN    DD  *                  CLIB
   COPY INDD=((CLIBIN,R)),OUTDD=CLIBOUT
   SELECT MEMBER=C$DUCBD
//ADDMLIB.SYSIN    DD  *                  MLIB
   COPY INDD=((MLIBIN,R)),OUTDD=MLIBOUT
   SELECT MEMBER=NO#MBR#                     /*dummy entry no mbrs! */
//ADDPLIB.SYSIN    DD  *                  PLIB
   COPY INDD=((PLIBIN,R)),OUTDD=PLIBOUT
   SELECT MEMBER=PDUCBD0
   SELECT MEMBER=HDUCBD0
   SELECT MEMBER=PDUCBT0
   SELECT MEMBER=HDUCBT0
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
|         JCL Member: DUCBD.V1R1M00.CNTL($INST40)                    |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//DUCBD040 JOB (SYS),'Install Other Pgms',   <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  DUCBD for MVS3.8J TSO / Hercules                    *
//* *                                                      *
//* *  JOB: $INST40 Install Other Programs                 *
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
| Step 11. Validate DUCBD                                            |
+--------------------------------------------------------------------+
 
 
    a) From the ISPF Main Menu, enter the following command:    
     
       TSO %C$DUCBD                  
 
    b) The panel PDUCBD0 is displayed.
 
________________________________________________________________________________
 dd/mm/yy.jjj hh:mm       ----  UCB DASD Display  ----               ROW 1 OF 54
 COMMAND ===>                                                   SCROLL ===> CSR 
                                                                        userid  
                                                                        PDUCBD0 
 SEL CUU  VOLSER DEVTYPE  DSTAT   VSTAT   MSTAT    SYSRES ASTAT                 
     131  SORT01 2314     Online  Public  PermRes         Unalloc               
     132  SORT02 2314     Online  Public  PermRes         Unalloc               
     133  SORT03 2314     Online  Public  PermRes         Unalloc               
     134  SORT04 2314     Online  Public  PermRes         Unalloc               
     135  SORT05 2314     Online  Public  PermRes         Unalloc               
     136  SORT06 2314     Online  Public  PermRes         Unalloc               
     140  WORK00 3350     Online  Public  PermRes         Unalloc               
     148  MVSRES 3350     Online  Private PermRes  Sysres Alloc                 
     149  SMP001 3350     Online  Public  PermRes         Unalloc               
     14A  SMP002 3350     Online  Public  PermRes         Unalloc               
     14B  SMP003 3350     Online  Public  PermRes         Unalloc               
     14C  SMP004 3350     Online  Public  PermRes         Unalloc               
     150  START1 3330     Online  Private Reserved        Unalloc               
     151  SPOOL0 3330     Online  Public  Reserved        Unalloc               
     152  HASP00 3330     Online  Public  Reserved        Alloc                 
     154  VSAM01 3330     Online  Private PermRes         Alloc                 
     156  SPOOL1 3330     Online  Public  Reserved        Unalloc               
     157  HASP01 3330     Online  Public  Reserved        Alloc                 
________________________________________________________________________________
Figure 10: PDUCBD0 UCB Panel    
 
 
    c) Scroll display using PF7 and PF8.
 
    d) Use PF1 to display HELP panel.
 
    e) Validation is complete.
 
 
+--------------------------------------------------------------------+
| Step 12. Done                                                      |
+--------------------------------------------------------------------+
 
 
    a) Congratulations!  You completed the installation for DUCBD.


+--------------------------------------------------------------------+
| Step 13. Incorporate DUCBD into ISPF menu panel                    |
+--------------------------------------------------------------------+
 
 
    a) To integrate DUCBD into your ISPF system, refer to
       DUCBD.V1R1M00.ASM(DUCBD) for suggested steps in the Overview
       section as a menu item or ISPF command.                      
 
       
                                                                            
                                                                            



Enjoy DUCBD for ISPF 2.x on MVS 3.8J!
                                                                            

======================================================================
* IV. S o f t w a r e   I n v e n t o r y   L i s t                  |
======================================================================

  - DUCBD.V1R1M00.ASM 
 $ . DUCBD       TSO CP Display DASD and TAPE UCB Information
      
  - DUCBD.V1R1M00.CLIST
   . README      Dummy member, this is intentional

  - DUCBD.V1R1M00.CNTL
 $ . $INST00     Define Alias for HLQ DUCBD          
 $ . $INST01     Load CNTL data set from distribution tape (HET)
 $ . $INST02     Load other data sets from distribution tape (HET)
 $ . $INST03     Install TSO Parts
 $ . $INST04     Install DUCBD CP
 $ . $INST05     Install ISPF Parts
 $ . $INST40     Install Other programs                    
 $ . $RECVXMI    Receive XMI SEQ to MVS PDSs via RECV370
 $ . $UP1100     Upgrade to V1R1M00   from   V1R0M00 
 $ . DSCLAIMR    Disclaimer
 $ . PREREQS     Required User-mods
 $ . README      Documentation and Installation instructions

  - DUCBD.V1R1M00.HELP
   . README      Dummy member, this is intentional

  - DUCBD.V1R1M00.ISPF
 $ . C$DUCBD     IVP CLIST for DUCBD
 $ . HDUCBD0     DASD UCB Help panel
 $ . PDUCBD0     DASD UCB Display panel
 $ . HDUCBT0     TAPE UCB Help panel
 $ . PDUCBT0     TAPE UCB Display panel
                
  - DUCBD.V1R1M00.MACLIB
   . DVCTBL      Device Table Entries
   . ISPFPL      ISPF Parameter Address List (10)       
 $ . ISPFSRV     ISPF Service keywords                
 $ . LA#ST       Load Address and Store
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
       
       
  - After downloading any other required software, consult provided
    documentation including any configuration steps (if applicable)
    for software and HELP file installation. 
       
       
 $ - Denotes modified software component for THIS DISTRIBUTION               
     relative to prior DISTRIBUTION               
                                                                            
                                                                            

