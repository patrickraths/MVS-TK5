LISTDSJ for MVS3.8J / Hercules                                               
==============================                                               


Date: 4/02/2021  Release V2R0M00
      2/27/2021  Release V1R0M40
      5/07/2020  Release V1R0M30
      4/10/2020  Release V1R0M20
      9/30/2019  Release V1R0M10
      5/17/2019  Release V1R0M01
      4/29/2019  Release V1R0M00  **INITIAL software distribution

*  Author:  Larry Belmontes Jr.
*           https://ShareABitofIT.net/LISTDSJ-for-MVS-3-8J
*           Copyright (C) 2019-2021  Larry Belmontes, Jr.


---------------------------------------------------------------------- 
|    LISTDSJ      I n s t a l l a t i o n   R e f e r e n c e        | 
---------------------------------------------------------------------- 

   The approach for this installation procedure is to transfer the
distribution content from your personal computing device to MVS with
minimal JCL and to continue the installation procedure using supplied
JCL from the MVS CNTL data set under TSO.                         

   Below are descriptions of ZIP file content, pre-installation
requirements (notes, credits) and installation steps.
 
Good luck and enjoy using LISTDSJ as added value to MVS 3.8J!
-Larry Belmontes



---------------------------------------------------------------------- 
|    LISTDSJ      C h a n g e   H i s t o r y                        | 
---------------------------------------------------------------------- 
*
*  MM/DD/CCYY Version  Change Description
*  ---------- -------  -----------------------------------------------
*  04/02/2021 2.0.00   - Change software distribution packaging     
*                        (HET and XMI)
*                      - LISTDSJ Shared macros                          
*                      - Externalize message processing (LDSJMSG)       
*                      - Externalize ISPF Service processing (LDSJISP)  
*                      - Misc documentation updates                     
*                                                                       
*  02/27/2021 1.0.40   - Support new variable, &SYSUPDATED              
*                      - Correct TSO environment test      
*                      - Add TSOB  parm keyword    
*                      - Activate reason code 12 (VSAM not supported)
*                      - Activate reason code 14 (not found UCB entry)  
*                      - Activate reason code 7  (not found in internal 
*                        table DVCLST)                                  
*                      - Activate reason code 27 (no volser for DSN)    
*                      - Activate reason code 3 (cannot process DSORG)  
*                      - Add support of '?ABOUT' as first paramter      
*                        for ABOUT information                          
*                      - Various program documentation updates          
*
*  05/07/2020 1.0.30   - Change software distribution packaging and
*                        installation procedure to use a Hercules
*                        Emulated Tape (HET)
*                      - No change to LISTDSJ program
*                                                                       
*  04/10/2020 1.0.20   - Correct TSB addr for TSO ENV testing           
*                      - Minor corrections to LISTDSJ
*                      - Minor updates to CLIST CLISTDIJ
*                      - Updated message member
*                                                                       
*  09/30/2019 1.0.10   - Add comments for DF and DS keywords            
*                      - Add keywords DIRECTORY and VOLUME              
*                      - Changed list of values for &SYSUNITS to        
*                        CYLINDER, TRACK, BLOCK, ABSOLUTE               
*                      - Support new variable, &SYSALLOC,               
*                      - Support USERID prefix for unquoted DSN         
*                      - Changed date seperator and format defaults     
*                        - Date Separator to dash    (-)                
*                        - Date Format to CCYY_MM_DD (3)                
*                      - Support FILE keyword   
*                      - Support DL0 and DL1 keywords
*                      - Enhance calling of IKJCT441 and ISPLINK        
*                                                                       
*  05/17/2019 1.0.01   - Add DS (Date Separator) keyword
*                      - Add DF (Date Format layout) keyword
*                      - Defaults can be customized at installation
*                                                                       
*  04/29/2019 1.0.00   - Initial version released to MVS 3.8J
*                        hobbyist public domain
*
*
*
======================================================================
* I. C o n t e n t   o f   Z I P   F i l e                           |
======================================================================

o  $INST00.JCL          Define Alias for HLQ LISTDSJ in Master Catalog
 
o  $INST01.JCL          Load CNTL data set from distribution tape
 
o  $RECVXMI.JCL         Receive XMI SEQ to MVS PDSs                  
 
o  LISTDSJ.V2R0M00.HET  Hercules Emulated Tape (HET) multi-file volume
                        with VOLSER of VS2000 containing software  
                        distribution.
 
o  LISTDSJ.V2R0M00.XMI  XMIT file containing software distribution.   
 
o  DSCLAIMR.TXT         Disclaimer
 
o  PREREQS.TXT          Required user-mods 
 
o  README.TXT           This File                                              
 
 
Note:   Although not necessary to install LISTDSJ, two user-mods 
-----   are required before using LISTDSJ. See PREREQS.TXT file.

Note:   ISPF v2.0 or higher must be installed under MVS3.8J TSO             
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
   LISTDSJ.V2R0M00.ASM                          MVSDLB    40    27 PO  FB  67  1
   LISTDSJ.V2R0M00.CLIST                        MVSDLB     6     5 PO  FB  83  1
   LISTDSJ.V2R0M00.CNTL                         MVSDLB    20    11 PO  FB  55  1
   LISTDSJ.V2R0M00.HELP                         MVSDLB     2     1 PO  FB  50  1
   LISTDSJ.V2R0M00.ISPF                         MVSDLB     5     4 PO  FB  80  1
   LISTDSJ.V2R0M00.MACLIB                       MVSDLB     4     2 PO  FB  50  1
   **END**    TOTALS:      77 TRKS ALLOC        50 TRKS USED       6 EXTENTS    
    
    
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
| Step 1. Define Alias for HLQ LISTDSJ in MVS User Catalog           |
+--------------------------------------------------------------------+
|         JCL Member: LISTDSJ.V2R0M00.CNTL($INST00)                  |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//LISTDSJ0 JOB (SYS),'Define LISTDSJ Alias', <-- Review and Modify 
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  LISTDSJ for MVS3.8J TSO / Hercules                  *
//* *  JOB: $INST00  Define Alias for HLQ LISTDSJ          *
//* *  Note: The master catalog password will be required  *
//* -------------------------------------------------------*
//DEFALIAS EXEC PGM=IDCAMS 
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
 PARM GRAPHICS(CHAIN(SN))
 LISTCAT ALIAS  ENT(LISTDSJ) 
 IF LASTCC NE 0 THEN -
    DEFINE ALIAS(NAME(LISTDSJ) RELATE(SYS1.UCAT.MVS))                          
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
|         JCL Member: LISTDSJ.V2R0M00.CNTL($RECVXMI)                 |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//RECV000A JOB (SYS),'Receive LISTDSJ XMI',      <-- Review and Modify
//             CLASS=A,MSGCLASS=X,REGION=0M,     <-- Review and Modify
//             MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  JOB: $RECVXMI  Receive Application XMI Files        *
//* -------------------------------------------------------*
//RECV     PROC HLQ=LISTDSJ,VRM=V2R0M00,TYP=XXXXXXXX,
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
//CLIST    EXEC RECV,TYP=CLIST,DSPACE='(TRK,(06,02,02))'
//ISPF     EXEC RECV,TYP=ISPF,DSPACE='(TRK,(05,05,10))'
//ASM      EXEC RECV,TYP=ASM,DSPACE='(TRK,(40,10,10))'
//MACLIB   EXEC RECV,TYP=MACLIB,DSPACE='(TRK,(04,02,02))'
//
______________________________________________________________________
Figure 2: $RECVXMI.JCL
 
 
    a) Transfer LISTDSJ.V2R0M00.XMI to MVS using your 3270 emulator.
       
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
 
       LISTDSJ.V2R0M00.ASM   
       LISTDSJ.V2R0M00.CLIST 
       LISTDSJ.V2R0M00.CNTL  
       LISTDSJ.V2R0M00.HELP  
       LISTDSJ.V2R0M00.ISPF  
       LISTDSJ.V2R0M00.MACLIB
 
    f) Subsequent installation steps will be submitted from members
       contained in the CNTL data set.
 
    g) Proceed to STEP 6.   ****
 
+--------------------------------------------------------------------+
| Step 4. Load CNTL data set from distribution tape                  |
+--------------------------------------------------------------------+
|         JCL Member: LISTDSJ.V2R0M00.CNTL($INST01)                  |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//LISTDSJ1 JOB (SYS),'Install CNTL PDS',     <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  LISTDSJ for MVS3.8J TSO / Hercules                  *
//* *  JOB: $INST01  Load CNTL PDS from distribution tape  *
//* *  Note: Uses tape drive 480                           *
//* -------------------------------------------------------*
//LOADCNTL PROC HLQ=LISTDSJ,VRM=V2R0M00,TVOLSER=VS2000,      
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
 
       DEVINIT 480 X:\dirname\LISTDSJ.V2R0M00.HET READONLY=1
 
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
|         JCL Member: LISTDSJ.V2R0M00.CNTL($INST02)                  |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//LISTDSJ2 JOB (SYS),'Install Other PDSs',   <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  LISTDSJ for MVS3.8J TSO / Hercules                  *
//* *  JOB: $INST02  Load other PDS from distribution tape *
//* *  Tape Volume:  File 1 - CNTL                         *
//* *                File 2 - CLIST                        *
//* *                File 3 - HELP                         *
//* *                File 4 - ISPF                         *
//* *                File 5 - ASM                          *
//* *                File 6 - MACLIB                       *
//* *  Note: Default TAPE=480, DASD=3350 on MVSDLB         *
//* -------------------------------------------------------*
//LOADOTHR PROC HLQ=LISTDSJ,VRM=V2R0M00,TVOLSER=VS2000,            
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
//             SPACE=(TRK,(02,02,02)),DISP=(,CATLG),
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=3600) 
//ISPF     DD  DSN=&HLQ..&VRM..ISPF,UNIT=&DUNIT,VOL=SER=&DVOLSER,
//             SPACE=(TRK,(05,05,10)),DISP=(,CATLG),
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=3600) 
//ASM      DD  DSN=&HLQ..&VRM..ASM,UNIT=&DUNIT,VOL=SER=&DVOLSER,
//             SPACE=(TRK,(40,10,10)),DISP=(,CATLG),
//             DCB=(RECFM=FB,LRECL=80,BLKSIZE=3600) 
//MACLIB   DD  DSN=&HLQ..&VRM..MACLIB,UNIT=&DUNIT,VOL=SER=&DVOLSER,
//             SPACE=(TRK,(04,02,02)),DISP=(,CATLG),
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
 
       DEVINIT 480 X:\dirname\LISTDSJ.V2R0M00.HET READONLY=1
 
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
|         JCL Member: LISTDSJ.V2R0M00.CNTL($UP2000)                  |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//LISTDSJU JOB (SYS),'Upgrade LISTDSJ',      <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  LISTDSJ for MVS3.8J TSO / Hercules                  *
//* *                                                      *
//* *  JOB: $UP2000                                        *
//* *       Upgrade LISTDSJ Software from release V1R0M40  *
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
//INCLIST  DD  DSN=LISTDSJ.V2R0M00.CLIST,DISP=SHR            
//INHELP   DD  DSN=LISTDSJ.V2R0M00.HELP,DISP=SHR             
//OUTCLIST DD  DSN=SYS2.CMDPROC,DISP=SHR          <--TARGET            
//OUTHELP  DD  DSN=SYS2.HELP,DISP=SHR             <--TARGET
//SYSIN    DD  *                                                        
    COPY INDD=((INCLIST,R)),OUTDD=OUTCLIST
    SELECT MEMBER=CFLDSI
    SELECT MEMBER=CLDSI 
    SELECT MEMBER=CLDSI2
    COPY INDD=((INHELP,R)),OUTDD=OUTHELP
    SELECT MEMBER=CFLDSI
    SELECT MEMBER=CLDSI 
    SELECT MEMBER=CLDSI2
/*                                                                  
//*
//* -------------------------------------------------------*
//* *  Assemble Link-Edit LISTDSJ to SYS2.CMDLIB           *
//* -------------------------------------------------------*
//LISTDSJ EXEC   ASML,HLQ=LISTDSJ,VRM=V2R0M00,MBR=LISTDSJ,
//         PARM.LKED='MAP,LIST,LET,RENT,XREF,REUS,REFR'
//LKED.SYSLMOD DD  DISP=SHR,
//         DSN=SYS2.CMDLIB                        <--TARGET 
//*
//********************************************************************/
//* 04/10/2020 1.0.20   Larry Belmontes Jr.                          */
//*                     - Added ALIAS LISTDSI to LKED step           */
//********************************************************************/
//LKED.SYSIN DD *
 ALIAS LISTDSI
 NAME LISTDSJ(R)
/*
//*
//* -------------------------------------------------------*
//* *  Assemble Link-Edit LDSJMSG to SYS2.CMDLIB           *
//* -------------------------------------------------------*
//LDSJMSG EXEC   ASML,HLQ=LISTDSJ,VRM=V2R0M00,MBR=LDSJMSG,
//         PARM.LKED='MAP,LIST,LET,RENT,XREF,REUS,REFR'
//LKED.SYSLMOD DD  DISP=SHR,
//         DSN=SYS2.CMDLIB(&MBR)                  <--TARGET 
//*
//* -------------------------------------------------------*
//* *  Assemble Link-Edit LDSJISP to SYS2.CMDLIB           *
//* -------------------------------------------------------*
//LDSJISP EXEC   ASML,HLQ=LISTDSJ,VRM=V2R0M00,MBR=LDSJISP,
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
//ISPFPRTS EXEC PARTSI,HLQ=LISTDSJ,VRM=V2R0M00,
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
   SELECT MEMBER=PLISTDSJ
   SELECT MEMBER=HLISTDSJ
   COPY INDD=((ISPFIN,R)),OUTDD=SLIBOUT
   SELECT MEMBER=NO#MBR#                     /*dummy entry no mbrs! */
   COPY INDD=((ISPFIN,R)),OUTDD=TLIBOUT
   SELECT MEMBER=NO#MBR#                     /*dummy entry no mbrs! */
// 
______________________________________________________________________
Figure 5: $UP2000.JCL  Upgrade from previous version to V2R0M00
 
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
 
       - Upgrading from V1R0M40, use $UP2000.JCL
       - V1R0M00 is initial release, thus, no updates available!
 
    d) After upgrade is applied, proceed to validation, STEP 11.
 
 
+--------------------------------------------------------------------+
| Step 7. Install TSO parts                                          |
+--------------------------------------------------------------------+
|         JCL Member: LISTDSJ.V2R0M00.CNTL($INST03)                  |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//LISTDSJ3 JOB (SYS),'Install TSO Parts',    <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  LISTDSJ for MVS3.8J TSO / Hercules                  *
//* *                                                      *
//* *  JOB: $INST03  Install TSO parts                     *
//* *                                                      *
//* *  Note: Duplicate members are over-written.           *
//* -------------------------------------------------------*
//STEP001  EXEC PGM=IEBCOPY                                           
//SYSPRINT DD  SYSOUT=*                                              
//INCLIST  DD  DSN=LISTDSJ.V2R0M00.CLIST,DISP=SHR            
//INHELP   DD  DSN=LISTDSJ.V2R0M00.HELP,DISP=SHR             
//OUTCLIST DD  DSN=SYS2.CMDPROC,DISP=SHR                               
//OUTHELP  DD  DSN=SYS2.HELP,DISP=SHR
//SYSIN    DD  *                                                        
    COPY INDD=((INCLIST,R)),OUTDD=OUTCLIST
    SELECT MEMBER=CLISTDSJ
    SELECT MEMBER=CFLDSI
    SELECT MEMBER=CLDSI 
    SELECT MEMBER=CLDSI2
    COPY INDD=((INHELP,R)),OUTDD=OUTHELP
    SELECT MEMBER=LISTDSJ
    SELECT MEMBER=CFLDSI
    SELECT MEMBER=CLDSI 
    SELECT MEMBER=CLDSI2
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
| Step 8. Install LISTDSJ Programs                                   |  
+--------------------------------------------------------------------+
|         JCL Member: LISTDSJ.V2R0M00.CNTL($INST04)                  |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//LISTDSJ4 JOB (SYS),'Install LISTDSJ',      <-- Review and Modify 
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  LISTDSJ for MVS3.8J TSO / Hercules                  *
//* *                                                      *
//* *  JOB: $INST04                                        *
//* *       Install LISTDSJ Programs                       *
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
//* *  Assemble Link-Edit LISTDSJ to SYS2.CMDLIB           *
//* -------------------------------------------------------*
//LISTDSJ EXEC   ASML,HLQ=LISTDSJ,VRM=V2R0M00,MBR=LISTDSJ,
//         PARM.LKED='MAP,LIST,LET,RENT,XREF,REUS,REFR'
//LKED.SYSLMOD DD  DISP=SHR,
//         DSN=SYS2.CMDLIB                        <--TARGET 
//*
//********************************************************************/
//* 04/10/2020 1.0.20   Larry Belmontes Jr.                          */
//*                     - Added ALIAS LISTDSI to LKED step           */
//********************************************************************/
//LKED.SYSIN DD *
 ALIAS LISTDSI
 NAME LISTDSJ(R)
/*
//*
//* -------------------------------------------------------*
//* *  Assemble Link-Edit LDSJMSG to SYS2.CMDLIB           *
//* -------------------------------------------------------*
//LDSJMSG EXEC   ASML,HLQ=LISTDSJ,VRM=V2R0M00,MBR=LDSJMSG,
//         PARM.LKED='MAP,LIST,LET,RENT,XREF,REUS,REFR'
//LKED.SYSLMOD DD  DISP=SHR,
//         DSN=SYS2.CMDLIB(&MBR)                  <--TARGET 
//*
//* -------------------------------------------------------*
//* *  Assemble Link-Edit LDSJISP to SYS2.CMDLIB           *
//* -------------------------------------------------------*
//LDSJISP EXEC   ASML,HLQ=LISTDSJ,VRM=V2R0M00,MBR=LDSJISP,
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
//             COND.IEFPROC=(0,NE)
//DBSTART  EXEC DBSTART,
//             COND.IEFPROC=(0,NE)
// 
______________________________________________________________________
Figure 7: $INST04 JCL
 
 
    a) Member $INST04 installs program(s).
 
    b) Review and update JOB statement and other JCL to conform to your
       installation standard.                                       
 
    c) Submit the job.
 
    d) Review job output for successful completion.
 
 
+--------------------------------------------------------------------+
| Step 9. Install ISPF parts                                         |
+--------------------------------------------------------------------+
|         JCL Member: LISTDSJ.V2R0M00.CNTL($INST05)                  |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//LISTDSJ5 JOB (SYS),'Install ISPF Parts',   <-- Review and Modify 
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  LISTDSJ for MVS3.8J TSO / Hercules                  *
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
//ISPF     EXEC PARTSI,HLQ=LISTDSJ,VRM=V2R0M00,
//         CLIB='XXXXXXXX.ISPCLIB',                <--TARGET
//         MLIB='XXXXXXXX.ISPMLIB',                <--TARGET
//         PLIB='XXXXXXXX.ISPPLIB',                <--TARGET
//         SLIB='XXXXXXXX.ISPSLIB',                <--TARGET
//         TLIB='XXXXXXXX.ISPTLIB'                 <--TARGET
//ADDCLIB.SYSIN    DD  *                  CLIB
   COPY INDD=((CLIBIN,R)),OUTDD=CLIBOUT
   SELECT MEMBER=CLISTDIJ
//ADDMLIB.SYSIN    DD  *                  MLIB
   COPY INDD=((MLIBIN,R)),OUTDD=MLIBOUT
   SELECT MEMBER=LDSJ00 
//ADDPLIB.SYSIN    DD  *                  PLIB
   COPY INDD=((PLIBIN,R)),OUTDD=PLIBOUT
   SELECT MEMBER=PLISTDSJ
   SELECT MEMBER=HLISTDSJ
//ADDSLIB.SYSIN    DD  *                  SLIB
   COPY INDD=((SLIBIN,R)),OUTDD=SLIBOUT
   SELECT MEMBER=NO#MBR#                     /*dummy entry no mbrs! */
//ADDTLIB.SYSIN    DD  *                  TLIB
   COPY INDD=((TLIBIN,R)),OUTDD=TLIBOUT
   SELECT MEMBER=NO#MBR#                     /*dummy entry no mbrs! */
//
______________________________________________________________________
Figure 8: $INST05 JCL
 
 
    a) This step can be omitted if ISPF 2.x is NOT installed on
       your system.  Proceed to the next step.                 
 
    b) Member $INST05 installs ISPF component(s).
 
       Note:  If no ISPF components are included for this distribution,
       -----  RC = 4 is returned by the corresponding IEBCOPY step.
 
    c) Review and update JOB statement and other JCL to conform to your
       installation standard.                                       
 
    d) Review and update DD statements for ISPCLIB (clist),
       ISPMLIB (messages), and/or ISPPLIB (panel) library names. 
       The DD statements are tagged with '<--TARGET'.
 
    e) Submit the job.
 
    f) Review job output for successful load(s).
 
 
+--------------------------------------------------------------------+
| Step 10. Install Other Program(s)                                  |  
+--------------------------------------------------------------------+
|         JCL Member: LISTDSJ.V2R0M00.CNTL($INST40)                  |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//LISTDS40 JOB (SYS),'Install Other Pgms',   <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  LISTDSJ for MVS3.8J TSO / Hercules                  *
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
 
 
    Note:  No other program need to be installed.                  
    -----  Proceed to next step.                   
 
    a) Member $INST40 installs programs CHKDSN and LISTDSJ.
 
    b) Review and update JOB statement and other JCL to conform to your
       installation standard.                                       
 
    c) Submit the job.
 
    d) Review job output for successful completion.
 
 
+--------------------------------------------------------------------+
| Step 11. Validate LISTDSJ                                          |
+--------------------------------------------------------------------+
|         JCL Member: LISTDSJ.V2R0M00.CNTL($IVP1)                    |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//IVP1     JOB (SYS),'LISTDSJ IPV1',         <-- Review and Modify           
//         CLASS=A,MSGCLASS=A,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  LISTDSJ for MVS3.8J TSO / Hercules                  *
//* *                                                      *
//* *  JOB: $IVP1                                          *
//* *       Run LISTDSJ Validation                         *
//* *                                                      *
//* *  LISTDSJ validation via CLISTDSJ using BATCH TSO     *
//* *  of documented function in program documentation.    *
//* *                                                      *
//* *  Note: CLIST are resolved from SYS2.CMDPROC          *
//* *        and tagged with <--TARGET for search          *
//* *        purposes.                                     *
//* *                                                      *
//* *                                                      *
//* * Change History: <CHGHIST>                            *
//* * ==================================================== *
//* * MM/DD/CCYY Version  Name / Description               *
//* * ---------- -------  -------------------------------- *
//* * 02/27/2021 1.0.40   Larry Belmontes Jr.              *
//* *                     - Add BTSO keyword parameter to  *
//* *                       CLISTDSJ n PRMS(...)           *
//* *                                                      *
//* * 04/29/2019 1.0.00   Larry Belmontes Jr.              *
//* *                     - Initial version released to    *
//* *                       MVS 3.8J hobbyist public       *
//* *                       domain                         *
//* *                                                      *
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
CLISTDSJ X PRMS('Validate List type 1')
CLISTDSJ 1 PRMS('''HERC01.TEST.CNTL'' BTSO')
/*
//VALDAT2  EXEC BATCHTSO 
//STEP01.SYSTSIN DD *
CLISTDSJ X PRMS('Validate List type 2')
CLISTDSJ 2 PRMS('''HERC01.TEST.CNTL'' BTSO')
/*
//VALDAT3  EXEC BATCHTSO 
//STEP01.SYSTSIN DD *
CLISTDSJ X PRMS('Validate List type 3')
CLISTDSJ 3 PRMS('''HERC01.TEST.CNTL'' BTSO')
/*
//VALDAT4  EXEC BATCHTSO 
//STEP01.SYSTSIN DD *
CLISTDSJ X PRMS('Validate List type 3 with DIR option')
CLISTDSJ 3 PRMS('''HERC01.TEST.CNTL'' DIR BTSO')
/*
//VALDAT5  EXEC BATCHTSO 
//STEP01.SYSTSIN DD *
CLISTDSJ X PRMS('Validate with ABOUT option')
CLISTDSJ 1 PRMS('''HERC01.TEST.CNTL'' ABOUT BTSO')
/*
//VALDAT6  EXEC BATCHTSO 
//STEP01.SYSTSIN DD *
CLISTDSJ X PRMS('Validate as to why NOT to use PNL w CLISTDSJ')
CLISTDSJ 3 PRMS('''HERC01.TEST.CNTL'' PNL BTSO')
/*
//VALDAT7  EXEC BATCHTSO 
//STEP01.SYSTSIN DD *
CLISTDSJ X PRMS('Validate List type 1 with FILE option')        
CLISTDSJ 1 PRMS('SYSPROC FILE BTSO')
/*
//
______________________________________________________________________
Figure 10: $IVP1 JCL
 
 
    a) Member $IVP1 validates LISTDSJ.
 
    b) Review and update JOB statement and other JCL to conform to your
       installation standard.                                       
 
    c) Submit the job.
 
    d) Review job output for successful execution.  All return codes 
       should be zero except for step (VALDAT6).  This is normal.
 
    e) Validation for LISTDSJ is complete.
 
 
+--------------------------------------------------------------------+
| Step 11a. Validate LISTDSJ ISPF 2.x application                    |
+--------------------------------------------------------------------+
 
 
    a) This step can be omitted if ISPF 2.x is NOT installed on
       your system.  Proceed to the next step.                       
 
    b) From the ISPF Main Menu, select option 6, COMMAND.  The TSO
       COMMAND PROCESSOR panel will display. 
 
    c) Enter the TSO command:
       %CLISTDIJ
 
    d) The panel PLISTDSJ, LISTDSJ for MVS 38J, is displayed.
     
________________________________________________________________________________
 -------------------------- LISTDSJ for MVS38J ----------------------- v2.0.00 -
 COMMAND ===>                                                                   
                                                            PANEL    - PLISTDSJ 
 NAME ==> _                                                 USERID   - LARRY03  
 PARMS =>                                                   TIME     - 21:25    
                                                            DATE     - 11/07/22 
 MSG:                                                                - 22.192   
 Return CD:                                                 SYSTEM   - BSP1     
 SYSREASON:                                                 TERMINAL - 3277     
                                                            TermSize 0024 0080  
                                                            APPLID   - ISP      
 DSORG RECFM LRECL BLKSZ KEYL  RKP   PASSWORD RACF CHGD                         
                                                                                
 CREDT             EXPDT             REFDT                CATL:                 
                                                          Cvol:                 
                                                          VOLS:                 
 Allocation:     TYPE     PRI     USED     SEC     ALLOC                        
                                                                                
 Tracks: TOT     USED     UNUSED  EXTENTS                                       
                                                                                
 Device: CYLS    TRKSCYL  TRKLEN  BLKSTRK  CAPACITY                             
                                                                                
 PO Dir: BLKS    USED     UNUSED  MEMBERS  ALIAS                                
                                                                                
________________________________________________________________________________
Figure 11: PLISTDSJ Panel       
 
       Type the following information:
       o  Enter a DSN in NAME===>                         
          e.g.  'HERC01.TEST.CNTL'   (use single quotes)    
       o  Press <ENTER>                                                         
       o  Review results for entered DSN
       o  Press <PF1> to display help panel, HLISTDSJ 
       o  Press <PF3> twice to exit help and application panel 
       
    e) Validation for LISTDSJ ISPF 2.x Application is complete.
                                                                            
                                                                            
+--------------------------------------------------------------------+
| Step 12. Done                                                      |
+--------------------------------------------------------------------+
 
 
    a) Congratulations!  You completed the installation for LISTDSJ.


    b) As examples of using LISTDSJ, the following CLISTS are included
       for educational purposes:
        
       CFLDSI -List allocated data sets on 3270 screen
       CLDSI  -List dataset attributes on 3270 screen
       CLDSI2 -List dataset attributes on 3270 screen  

       Refer to HELP for command syntax and information.

         e.g.   From TSO Ready prompt, HELP CFLDSI
                From ISPF main menu command line, TSO HELP CFLDSI


======================================================================
* IV. S o f t w a r e   I n v e n t o r y   L i s t                  |
======================================================================

  - LISTDSJ.V2R0M00.ASM 
 $ . LDSJISP     ISPF Processor for LISTDSJ
 $ . LDSJMSG     Message Processor for LISTDSJ
 $ . LISTDSJ     TSO CP Data Set Attribute Information
      
  - LISTDSJ.V2R0M00.CLIST
 $ . CFLDSI      List session allocated datasets using LISTA / LISTDSI
 $ . CLDSI       List dataset attributes using LISTDSI (format 1)
 $ . CLDSI2      List dataset attributes using LISTDSI (format 2)
   . CLISTDSJ    LISTDSJ Test harness (displays in 3 formats)

  - LISTDSJ.V2R0M00.CNTL
 $ . $INST00     Define Alias for HLQ LISTDSJ          
 $ . $INST01     Load CNTL data set from distribution tape (HET)
 $ . $INST02     Load other data sets from distribution tape (HET)
 $ . $INST03     Install TSO Parts
 $ . $INST04     Install LISTDSJ CP
 $ . $INST05     Install ISPF Parts
 $ . $INST40     Install Other programs                    
 $ . $RECVXMI    Receive XMI SEQ to MVS PDSs via RECV370
 $ . DSCLAIMR    Disclaimer
 $ . PREREQS     Required User-mods
 $ . README      Documentation and Installation instructions

  - LISTDSJ.V2R0M00.HELP
 $ . CFLDSI      Help member for CFLDSI
 $ . CLDSI       Help member for CLDSI
 $ . CLDSI2      Help member for CLDSI2
   . LISTDSJ     Help member for LISTDSJ

  - LISTDSJ.V2R0M00.ISPF
   . LDSJ00      LISTDSJ ISPF message file
 $ . HLISTDSJ    LISTDSJ Help panel
 $ . PLISTDSJ    LISTDSJ Display panel
                
  - LISTDSJ.V2R0M00.MACLIB
   . #DATEFMT    Date Format Macro   
   . #DATSEP     Date Separator Macro
   . #IPAL       ISPF Service PAL
   . #ISTATS     ISPF Statistics table columns
   . #MPALS      Message Processor PAL
   . DVCTBL      Device Table Entries
   . ISPFPL      ISPF Parameter Address List (10)       
 $ . ISPFSRV     ISPF Service keywords                
   . LBISPL      Call to ISPLINK (LarryB version)      
       
       
  - After downloading any other required software, consult provided
    documentation including any configuration steps (if applicable)
    for software and HELP file installation. 
       
       
 $ - Denotes modified software component for THIS DISTRIBUTION               
     relative to prior DISTRIBUTION               
                                                                            
                                                                            

