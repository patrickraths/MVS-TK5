FINDSRCH for MVS3.8J / Hercules                                               
===============================                                               


Date: 02/14/2022  Release V0R9M11
      10/22/2021  Release V0R9M10
       9/26/2020  Release V0R9M00

*  Author:  Larry Belmontes Jr.
*           https://ShareABitofIT.net/FINDSRCH-in-MVS38J
*           Copyright (C) 2020-2021  Larry Belmontes, Jr.


---------------------------------------------------------------------- 
|    FINDSRCH     I n s t a l l a t i o n   R e f e r e n c e        | 
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

o  $INST00.JCL          Define Alias for HLQ FINDSRCH in Master Catalog
 
o  $INST01.JCL          Load CNTL data set from distribution tape
 
o  $RECVXMI.JCL         Receive XMI SEQ to MVS PDSs                  
 
o  FINDSRCH.V0R9M11.HET Hercules Emulated Tape (HET) multi-file volume
                        with VOLSER of VS0911 containing software  
                        distribution.
 
o  RECVXMIT.V0R9M11.XMI XMIT file containing software distribution.   
 
o  DSCLAIMR.TXT         Disclaimer
 
o  PREREQS.TXT          Required user-mods 
 
o  README.TXT           This File                                              
 
 
Note:   ISPF v2.1 or higher must be installed under MVS3.8J TSO             
-----   including associated user-mods per ISPF Installation Pre-reqs.
 
Note:   VTOC (TSO CP) is a pre-requisite for this install
-----   and is available on MVS3.8J TK3 and TK4- systems.          
        Various versions of VTOC are available from CBT website. 
        More information at:
        https://www.cbttape.org/cbtdowns.htm               
       
Credit: Program FIND is authored by Vinh Vu as part of CBT File #166.
------- More information at:
        https://www.cbttape.org/cbtdowns.htm  FILE #166
       
        FIND was modified by Jay Moseley for assembly under MVS 3.8J using
        the IFOX00 assembler.  Jay consolidated FIND source with assemble,
        link-edit and IEBUPDTE steps into a single JCL installation package.
        More information at:
        http://www.jaymoseley.com/hercules/cbt_ware/find.htm
       
Note:   Using Jay's version of FIND as the base, FINDSRCH was created and 
-----   modifed to include new keywords for use by this new ISPF Find add-on.
        A new name, FINDSRCH, was selected to preserve the original 
        FIND program, should it exist on your system.
        Thanks to Vinh and Jay for their contributions to CBT and MVS 3.8J
        communities.   
 
Credit: Program LOCATE originally authored by Sam Lepore and modified 
------- by Kermit Kiser as part of CBT File #270.
        More information at:
        https://www.cbttape.org/cbtdowns.htm  FILE #270
       
        LOCATE uses DSNTAB, as a sub-routine.  Thanks to Sam and Kermit for 
        their contributions to CBT and MVS 3.8J communities.      
       
Note:   Both programs, LOCATE and DSNTAB, are used as-is and include        
-----   in-line macros for successful assembly sourced from File #270.
       
Credit: Program FINDMEM is authored by Rob Wunderlich as part of CBT File #474.
------- More information at:
        https://www.cbttape.org/cbtdowns.htm  FILE #474
       
Note:   FINDMEM is modified to run under MVS 3.8J / Hercules and
-----   ISPF 2.1 (Wally Mclaughlin's ISPF-like product).              
        Thanks to Rob for his contributions to CBT and MVS 3.8J communities.

Note:   CHKDSN checks for presence of a dataset or dataset/member.
-----   For convenience purposes, a current version is included.
        More information at:
        https://www.shareabitofit.net/CHKDSN-in-MVS38j        
 
Note:   CUTIL00 is a TSO utility for CLIST variables.              
-----   For convenience purposes, a current version is included.   
        More information at:
        https://www.shareabitofit.net/CUTIL00-in-MVS38j        

Note:   LISTDSJ, alias LISTDSI, is a LISTDSI-like program that creates CLIST
-----   variables for some dataset attributes.  For convenience purposes, a
        current version is included.                  
        More information at:
        https://www.shareabitofit.net/LISTDSJ-for-MVS-3-8j    

======================================================================
* II. P r e - i n s t a l l a t i o n   R e q u i r e m e n t s      |
======================================================================

o  The Master Catalog password may be required for some installation
   steps. 
 
o  Tape files use device 480.
 
o  As default, DASD files will be loaded to VOLSER=MVSDLB, type 3350 device.
    
   Below is a DATASET List after tape distribution load for reference purposes:
    
   DATA-SET-NAME------------------------------- VOLUME ALTRK USTRK ORG FRMT % XT
   FINDSRCH.V0R9M11.ASM                         MVSDLB    90    83 PO  FB  92  2
   FINDSRCH.V0R9M11.CLIST                       MVSDLB     4     2 PO  FB  50  1
   FINDSRCH.V0R9M11.CNTL                        MVSDLB    20    10 PO  FB  50  1
   FINDSRCH.V0R9M11.HELP                        MVSDLB     4     3 PO  FB  75  1
   FINDSRCH.V0R9M11.ISPF                        MVSDLB    20    14 PO  FB  70  1
   FINDSRCH.V0R9M11.MACLIB                      MVSDLB     2     1 PO  FB  50  1
   **END**    TOTALS:     140 TRKS ALLOC       113 TRKS USED       7 EXTENTS    
    
    
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
| Step 1. Define Alias for HLQ FINDSRCH in MVS User Catalog          |
+--------------------------------------------------------------------+
|         JCL Member: FINDSRCH.V0R9M11.CNTL($INST00)                 |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//FINDSRC0 JOB (SYS),'Def FINDSRCH Alias',   <-- Review and Modify 
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  FINDSRCH for MVS3.8J TSO / Hercules                 *
//* *  JOB: $INST00  Define Alias for HLQ FINDSRCH         *
//* *  Note: The master catalog password will be required  *
//* -------------------------------------------------------*
//DEFALIAS EXEC PGM=IDCAMS 
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
 PARM GRAPHICS(CHAIN(SN))
 LISTCAT ALIAS  ENT(FINDSRCH) 
 IF LASTCC NE 0 THEN -
    DEFINE ALIAS(NAME(FINDSRCH) RELATE(SYS1.UCAT.MVS))                          
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
|         JCL Member: FINDSRCH.V0R9M11.CNTL($RECVXMI)                |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//RECV000A JOB (SYS),'Receive FINDSRCH XMI',     <-- Review and Modify
//             CLASS=A,MSGCLASS=X,REGION=0M,     <-- Review and Modify
//             MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  JOB: $RECVXMI  Receive Application XMI Files        *
//* -------------------------------------------------------*
//RECV     PROC HLQ=FINDSRCH,VRM=V0R9M11,TYP=XXXXXXXX,
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
 
 
    a) Transfer FINDSRCH.V0R9M11.XMI to MVS using your 3270 emulator.
       
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
 
       FINDSRCH.V0R9M11.ASM   
       FINDSRCH.V0R9M11.CLIST 
       FINDSRCH.V0R9M11.CNTL  
       FINDSRCH.V0R9M11.HELP  
       FINDSRCH.V0R9M11.ISPF  
       FINDSRCH.V0R9M11.MACLIB
 
    f) Subsequent installation steps will be submitted from members
       contained in the CNTL data set.
 
    g) Proceed to STEP 6.   ****
 
+--------------------------------------------------------------------+
| Step 4. Load CNTL data set from distribution tape                  |
+--------------------------------------------------------------------+
|         JCL Member: FINDSRCH.V0R9M11.CNTL($INST01)                 |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//FINDSRC1 JOB (SYS),'Install CNTL PDS',     <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  FINDSRCH for MVS3.8J TSO / Hercules                 *
//* *  JOB: $INST01  Load CNTL PDS from distribution tape  *
//* *  Note: Uses tape drive 480                           *
//* -------------------------------------------------------*
//LOADCNTL PROC HLQ=FINDSRCH,VRM=V0R9M11,TVOLSER=VS0911,      
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
 
       DEVINIT 480 X:\dirname\FINDSRCH.V0R9M11.HET READONLY=1
 
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
|         JCL Member: FINDSRCH.V0R9M11.CNTL($INST02)                 |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//FINDSRC2 JOB (SYS),'Install Other PDSs',   <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  FINDSRCH for MVS3.8J TSO / Hercules                 *
//* *  JOB: $INST02  Load other PDS from distribution tape *
//* *  Tape Volume:  File 1 - CNTL                         *
//* *                File 2 - CLIST                        *
//* *                File 3 - HELP                         *
//* *                File 4 - ISPF                         *
//* *                File 5 - ASM                          *
//* *                File 6 - MACLIB                       *
//* *  Note: Default TAPE=480, DASD=3350 on MVSDLB         *
//* -------------------------------------------------------*
//LOADOTHR PROC HLQ=FINDSRCH,VRM=V0R9M11,TVOLSER=VS0911,            
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
 
       DEVINIT 480 X:\dirname\FINDSRCH.V0R9M11.HET READONLY=1
 
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
|         JCL Member: FINDSRCH.V0R9M11.CNTL($INST03)                 |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//FINDSRC3 JOB (SYS),'Install TSO Parts',    <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  FINDSRCH for MVS3.8J TSO / Hercules                 *
//* *                                                      *
//* *  JOB: $INST03  Install TSO parts                     *
//* *                                                      *
//* *  Note: Duplicate members are over-written.           *
//* -------------------------------------------------------*
//STEP001  EXEC PGM=IEBCOPY                                           
//SYSPRINT DD  SYSOUT=*                                              
//INCLIST  DD  DSN=FINDSRCH.V0R9M11.CLIST,DISP=SHR            
//INHELP   DD  DSN=FINDSRCH.V0R9M11.HELP,DISP=SHR             
//OUTCLIST DD  DSN=SYS2.CMDPROC,DISP=SHR                               
//OUTHELP  DD  DSN=SYS2.HELP,DISP=SHR
//SYSIN    DD  *                                                        
    COPY INDD=((INCLIST,R)),OUTDD=OUTCLIST
    SELECT MEMBER=NO#MBR#                    /*dummy entry no mbrs! */
    COPY INDD=((INHELP,R)),OUTDD=OUTHELP
    SELECT MEMBER=CHKDSN
    SELECT MEMBER=CUTIL00
    SELECT MEMBER=FINDSRCH
    SELECT MEMBER=LOCATE
    SELECT MEMBER=FINDMEM
    SELECT MEMBER=CFLDSI 
    SELECT MEMBER=CLDSI
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
| Step 7. Install FINDSRCH Programs                                  |  
+--------------------------------------------------------------------+
|         JCL Member: FINDSRCH.V0R9M11.CNTL($INST04)                 |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//FINDSRC4 JOB (SYS),'Install FINDSRCH',     <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  FINDSRCH for MVS3.8J TSO / Hercules                 *
//* *                                                      *
//* *  JOB: $INST04                                        *
//* *       Install FINDSRCH Programs                      *
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
//* *  Assemble Link-Edit FINDSRCH to ISPLLIB              *
//* -------------------------------------------------------*
//FINDSRCH EXEC  ASML,HLQ=FINDSRCH,VRM=V0R9M11,MBR=FINDSRCH,
//         PARM.LKED='MAP,LIST,LET,RENT,XREF,REUS,REFR'
//LKED.SYSLMOD DD  DISP=SHR,
//         DSN=XXXXXXXX.ISPLLIB(&MBR)             <--TARGET 
//*
//* -------------------------------------------------------*
//* *  Assemble Link-Edit DSNTAB  to SYS2.LINKLIB          *
//* -------------------------------------------------------*
//DSNTAB   EXEC  ASML,HLQ=FINDSRCH,VRM=V0R9M11,MBR=DSNTAB,   
//         PARM.LKED='MAP,LIST,LET,RENT,XREF,REUS,REFR'
//LKED.SYSLMOD DD  DISP=SHR,
//         DSN=SYS2.LINKLIB(&MBR)                 <--TARGET 
//*
//* -------------------------------------------------------*
//* *  Assemble Link-Edit LOCATE  to SYS2.CMDLIB           *
//* -------------------------------------------------------*
//LOCATE   EXEC  ASML,HLQ=FINDSRCH,VRM=V0R9M11,MBR=LOCATE,  
//         PARM.LKED='MAP,LIST,LET,RENT,XREF,REUS,REFR'
//LKED.SYSLMOD DD  DISP=SHR,
//         DSN=SYS2.CMDLIB(&MBR)                  <--TARGET 
//LKED.SYSLIB  DD  DSN=SYS2.LINKLIB,DISP=SHR
//*
//* -------------------------------------------------------*
//* *  Assemble Link-Edit FINDMEM to SYS2.CMDLIB           *
//* -------------------------------------------------------*
//FINDMEM  EXEC  ASML,HLQ=FINDSRCH,VRM=V0R9M11,MBR=FINDMEM,
//         PARM.ASM='NODECK,LOAD,TERM,XREF',
//         PARM.LKED='MAP,LIST,LET,XREF'
//***      PARM.LKED=(XREF,LET,LIST,NCAL) 
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
Figure 6: $INST04 JCL
 
 
    a) Member $INST04 installs program(s).
 
    b) Review and update JOB statement and other JCL to conform to your
       installation standard.                                       
 
    c) Submit the job.
 
    d) Review job output for successful completion.
 
 
+--------------------------------------------------------------------+
| Step 8. Install ISPF parts                                         |
+--------------------------------------------------------------------+
|         JCL Member: FINDSRCH.V0R9M11.CNTL($INST05)                 |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//FINDSRC5 JOB (SYS),'Install ISPF Parts',   <-- Review and Modify 
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  FINDSRCH in MVS3.8J TSO / Hercules                  *
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
//ISPF     EXEC PARTSI,HLQ=FINDSRCH,VRM=V0R9M11,
//         CLIB='XXXXXXXX.ISPCLIB',                <--TARGET
//         MLIB='XXXXXXXX.ISPMLIB',                <--TARGET
//         PLIB='XXXXXXXX.ISPPLIB',                <--TARGET
//         SLIB='XXXXXXXX.ISPSLIB',                <--TARGET
//         TLIB='XXXXXXXX.ISPTLIB'                 <--TARGET
//ADDCLIB.SYSIN    DD  *                  CLIB
   COPY INDD=((CLIBIN,R)),OUTDD=CLIBOUT
   SELECT MEMBER=C$FNDSRH
   SELECT MEMBER=CMEMFIND
   SELECT MEMBER=CSRCH    
   SELECT MEMBER=CVOL     
   SELECT MEMBER=CLOC8    
   SELECT MEMBER=CMEMINDD 
//ADDMLIB.SYSIN    DD  *                  MLIB
   COPY INDD=((MLIBIN,R)),OUTDD=MLIBOUT
   SELECT MEMBER=FIND00 
   SELECT MEMBER=FIND01 
//ADDPLIB.SYSIN    DD  *                  PLIB
   COPY INDD=((PLIBIN,R)),OUTDD=PLIBOUT
   SELECT MEMBER=PFINDM   
   SELECT MEMBER=HFINDM   
   SELECT MEMBER=PMEMFIND 
   SELECT MEMBER=HMEMFIND 
   SELECT MEMBER=PSRCH    
   SELECT MEMBER=HSRCH    
   SELECT MEMBER=PVOL     
   SELECT MEMBER=HVOL     
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
|         JCL Member: FINDSRCH.V0R9M11.CNTL($INST40)                 |
+--------------------------------------------------------------------+
 
 
______________________________________________________________________
//FINDSR40 JOB (SYS),'Install Other Pgms',   <-- Review and Modify
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  FINDSRCH for MVS3.8J TSO / Hercules                 *
//* *                                                      *
//* *  JOB: $INST40                                        *
//* *       Install CHKDSN   Programs                      *
//* *       Install CUTIL00  Programs                      *
//* *       Install LISTDSJ  Programs                      *
//* *       **Note: CUTIL00 and LISTSDJ                    *
//* *               require two user-mods                  *
//* *               ZP60014 and ZP60038.                   *
//* *               Refer to program documenation          *
//* *               or pre-reqs documenation.              *
//* *                                                      *
//* *  - CHKDSN   programs installs to SYS2.CMDLIB         *
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
//* *  Assemble Link-Edit CHKDSN to SYS2.CMDLIB            *
//* -------------------------------------------------------*
//CHKDSN   EXEC  ASML,HLQ=FINDSRCH,VRM=V0R9M11,MBR=CHKDSN,
//         PARM.LKED='MAP,LIST,LET,RENT,XREF,REUS,REFR'
//LKED.SYSLMOD DD  DISP=SHR,
//         DSN=SYS2.CMDLIB(&MBR)                  <--TARGET 
//*
//* -------------------------------------------------------*
//* *  Assemble Link-Edit CHKDSNMS to SYS2.CMDLIB          *
//* -------------------------------------------------------*
//CHKDSNSM EXEC  ASML,HLQ=FINDSRCH,VRM=V0R9M11,MBR=CHKDSNMS, 
//         PARM.LKED='MAP,LIST,LET,RENT,XREF,REUS,REFR'
//LKED.SYSLMOD DD  DISP=SHR,
//         DSN=SYS2.CMDLIB(&MBR)                  <--TARGET 
//*
//* -------------------------------------------------------*
//* *  Assemble Link-Edit CUTIL00 to SYS2.CMDLIB           *
//* -------------------------------------------------------*
//CUTIL00  EXEC  ASML,HLQ=FINDSRCH,VRM=V0R9M11,MBR=CUTIL00,
//         PARM.LKED='MAP,LIST,LET,RENT,XREF,REUS,REFR'
//LKED.SYSLMOD DD  DISP=SHR,
//         DSN=SYS2.CMDLIB(&MBR)                  <--TARGET 
//*
//* -------------------------------------------------------*
//* *  Assemble Link-Edit CUTILTBL to SYS2.CMDLIB          *
//* -------------------------------------------------------*
//CUTILTBL EXEC  ASML,HLQ=FINDSRCH,VRM=V0R9M11,MBR=CUTILTBL, 
//         PARM.LKED='MAP,LIST,LET,RENT,XREF,REUS,REFR'
//LKED.SYSLMOD DD  DISP=SHR,
//         DSN=SYS2.CMDLIB(&MBR)                  <--TARGET 
//*
//* -------------------------------------------------------*
//* *  Assemble Link-Edit LISTDSJ to SYS2.CMDLIB           *
//* -------------------------------------------------------*
//LISTDSJ  EXEC  ASML,HLQ=FINDSRCH,VRM=V0R9M11,MBR=LISTDSJ,
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
 
 
    Note:  If CHKDSN and/or CUTIL00 already installed on your system,
    -----  comment the appropriate job steps.
 
    Note:  If both CHKDSN and CUTIL00 are installed on your system,
    -----  proceed to next step.
 
    a) Member $INST40 installs programs CHKDSN and CUTIL00.
 
    b) Review and update JOB statement and other JCL to conform to your
       installation standard.                                       
 
    c) Submit the job.
 
    d) Review job output for successful completion.
 
 
+--------------------------------------------------------------------+
| Step 10. Validate FINDSRCH                                         |
+--------------------------------------------------------------------+
 
 
    a) From the ISPF Main Menu, enter the following command:    
       TSO %C$FNDSRH                                                   
 
    b) Panel PFINDM is displayed.                                  
 
 
 
    1a) This test uses VTOC and CHKDSN CPs for finding a specified
        member name across selected dataset names.
 
        Enter data on panel:
 
        1. Enter  1      in COMMAND        as shown below
        2. Enter  c      in DSNstrPOS      as shown below
        3. Enter  maclib in DSNstr         as shown below
        4. Enter  wto    in MEMBER         as shown below
        5. Enter  y      in ListAll DSN    as shown below
        6. Press ENTER
 
________________________________________________________________________________
 ----------------------         FINDSRCH Menu         --------------------------
 COMMAND ===> 1                                                                 
                                                                                
  1  Find MEMBER in DSL                                                 LARRY03 
  2  List Datasets in DSL                                               PFINDM  
  3  Find members in DSL with SEARCHstr                                         
       optionally grouped by MEMBER                                             
  4  Find MEMBER in system libraries                                            
  5  Find MEMBER in allocated DDName                                            
                                                                                
                                                                                
  DSL (Dataset List) includes dataset names with DSNstr located at DSNstrPOS    
  where  S start of DSN, or  E end of DSN, or   C contained in DSN.             
                                                                                
 DSNstrPOS ===> C  S/E/C                                                    
 DSNstr ======> maclib                                                        
 DDName ======>                                                               
 MEMBER ======> wto                                                           
 SEARCHstr  ==>                                              Use single quotes
 Fast Search => Y  Y/N  Stop string member search after first found occurrence  
 ListAll DSN => Y  Y/N  List all datasets processed (options 1-3)               
                                                                                
                                                                                
                                                                                
________________________________________________________________________________
Figure 9a: PFINDM FIND Utilities Menu Panel
 
        
    1b) Below is a representative response:
 
________________________________________________________________________________
 -------------------   Find Member Results   -----------------------------------
 COMMAND ===>                                                   SCROLL ===> CSR 
                                                                                
 DSN CONTAINS: MACLIB                                                   LARRY03 
 Member Name : WTO      ListAll: Y                                      PMEMFIND
                                                                                
 PF3-End   PF7-Up   PF8-Down                                                    
 Dataset can be Browsed or Edited                                               
                                                                                
 DSNs            DSNs           Not Found     Found         Total               
 Extracted: 40   Searched: 40   Members: 37   Members: 3    Others: 0           
 S   Dataset Name-------------------------------- Member   Found Volume         
     OSMVT.V218.MACLIB                            WTO        Y   PUB007         
     SYS1.AMACLIB                                 WTO        Y   MVSDLB         
     SYS1.MACLIB                                  WTO        Y   MVSRES         
     CBT.MVS38J.MACLIB                                       N   CBTCAT         
     CCOMPR.V1R0M00.MACLIB                                   N   MVSDLB         
     DALCDS.V1R0M00.MACLIB                                   N   PUB006         
     DFSPC.V1R0M00.MACLIB                                    N   PUB006         
     DUCBD.V1R0M00.MACLIB                                    N   PUB006         
     HERC01.KICKSSYS.V1R4M1.MACLIB                           N   MVSCAT         
     LARRY01.CBT.V494.FILE066.MACLIB                         N   PUB007         
     LARRY01.CBT.V494.FILE300.MACLIB                         N   PUB007         
     LARRY01.CBT.V495.FILE270.MACLIB                         N   PUB007         
     LARRY01.COV466.FILE301.SMACLIB                          N   PUB007         
     LARRY01.DBCOLE.MACLIB                                   N   PUB007         
     LARRY01.DDT.MACLIB                                      N   PUB005         
________________________________________________________________________________
Figure 9b: PMEMFIND Results Panel
 
 
    1c) Note that DSNs containing 'MACLIB' in the DSN are listed including
        whether member WTO is found or not found. 
 
    1d) Press PF3 to return to menu PFINDM.
 
 
 
    2a) This test uses VTOC to search for a specific DSNstring in
        dataset names.
 
        Enter data on panel:
 
        1. Enter  2      in COMMAND        as shown below
        2. Enter  c      in DSNstrPOS      as shown below
        3. Enter  maclib in DSNstr         as shown below
        4. Enter  y      in ListAll DSN    as shown below
        5. Press ENTER
 
________________________________________________________________________________
 ----------------------         FINDSRCH Menu         --------------------------
 COMMAND ===> 2                                                                 
                                                                                
  1  Find MEMBER in DSL                                                 LARRY03 
  2  List Datasets in DSL                                               PFINDM  
  3  Find members in DSL with SEARCHstr                                         
       optionally grouped by MEMBER                                             
  4  Find MEMBER in system libraries                                            
  5  Find MEMBER in allocated DDName                                            
                                                                                
                                                                                
  DSL (Dataset List) includes dataset names with DSNstr located at DSNstrPOS    
  where  S start of DSN, or  E end of DSN, or   C contained in DSN.             
                                                                                
 DSNstrPOS ===> C  S/E/C                                                    
 DSNstr ======> maclib                                                        
 DDName ======>                                                               
 MEMBER ======>                                                               
 SEARCHstr  ==>                                              Use single quotes
 Fast Search => Y  Y/N  Stop string member search after first found occurrence  
 ListAll DSN => Y  Y/N  List all datasets processed (options 1-3)               
                                                                                
                                                                                
                                                                                
________________________________________________________________________________
Figure 10a: PFINDM FIND Utilities Menu Panel
 
 
    2b) Below is a representative response:
 
________________________________________________________________________________
 ------------------    Find Datasets Results    --------------------------------
 COMMAND ===>                                                   SCROLL ===> CSR 
                                                                                
 DSN CONTAINS: MACLIB                                                   LARRY01 
                                                                        PVOL    
                                                                                
 PF3-End   PF7-Up   PF8-Down                      C catalogued                  
 Dataset can be Browsed or Edited                 N not catalogued              
                                                  W catalogued on another vol   
 DSNs            DSNs                             E catalog processing error    
 Extracted: 49   Listed: 49                       ^                             
 S   Dataset Name-------------------------------- C Volume DSO RFM LRECL BLKSZ  
     CALNDR.V0R9M00.MACLIB                        C MVSDLB PO  FB     80  3600  
     CBT.MVS38J.MACLIB                            C CBTCAT PO  FB     80 19040  
     CCOMPR.V0R9M00.MACLIB                        C PUB006 PO  FB     80  3600  
     CCOMPR.V0R9M00.MACLIB.OLD                    C PUB006 PO  FB     80  3600  
     CCOMPR.V0R9M00.MACLIB2                       C PUB006 PO  FB     80  3600  
     DALCDS.V1R0M00.MACLIB                        C PUB006 PO  FB     80  3600  
     DFSPC.V1R0M00.MACLIB                         C PUB006 PO  FB     80  3600  
     DUCBD.V1R0M00.MACLIB                         C PUB006 PO  FB     80  3600  
     FINDSRCH.V0R9M10.MACLIB                      C PUB006 PO  FB     80  3600  
     HERC01.KICKSSYS.V1R4M1.MACLIB                C MVSCAT PO  FB     80  6000  
     LARRY01.CBT.V494.FILE066.MACLIB              C PUB007 PO  FB     80 19040  
     LARRY01.CBT.V494.FILE300.MACLIB              C PUB007 PO  FB     80 19040  
     LARRY01.CBT.V495.FILE270.MACLIB              C PUB007 PO  FB     80 19040  
     LARRY01.COV466.FILE301.SMACLIB               C PUB007 PO  FB     80 19040  
     LARRY01.DBCOLE.MACLIB                        C PUB007 PO  FB     80 19040  
________________________________________________________________________________
Figure 10b: PVOL Results Panel
 
 
    2c) Note that DSNs containing 'MACLIB' in the DSN are listed including
        some dataset attributes.
 
    2d) Press PF3 to return to menu PFINDM.
 
 
 
    3a) This test uses VTOC, CHKDSN and FINDSRCH to find a member name and
        search for a search string across qualifying DSNs based on DSNstr Type 
        and DSNstring.
 
        For clarity, the request is:
          Search for first occurrence of string "vtoc"
          in PDSs whose DSN contain "asm"
           
        Enter data on panel:
 
        1. Enter  3      in COMMAND        as shown below
        2. Enter  c      in DSNstr Type    as shown below
        3. Enter  asm    in DSNstring      as shown below
        4. Enter  vtoc   in Search String  as shown below
        5. Enter  y      in Quick Search   as shown below
        6. Enter  y      in List all DSN   as shown below
        7. Press ENTER
 
________________________________________________________________________________
 ----------------------         FINDSRCH Menu         --------------------------
 COMMAND ===> 3                                                                 
                                                                                
  1  Find MEMBER in DSL                                                 LARRY03 
  2  List Datasets in DSL                                               PFINDM  
  3  Find members in DSL with SEARCHstr                                         
       optionally grouped by MEMBER                                             
  4  Find MEMBER in system libraries                                            
  5  Find MEMBER in allocated DDName                                            
                                                                                
                                                                                
  DSL (Dataset List) includes dataset names with DSNstr located at DSNstrPOS    
  where  S start of DSN, or  E end of DSN, or   C contained in DSN.             
                                                                                
 DSNstrPOS ===> C  S/E/C                                                    
 DSNstr ======> asm                                                           
 DDName ======>                                                               
 MEMBER ======>                                                               
 SEARCHstr  ==> vtoc                                         Use single quotes
 Fast Search => Y  Y/N  Stop string member search after first found occurrence  
 ListAll DSN => Y  Y/N  List all datasets processed (options 1-3)               
                                                                                
                                                                                
                                                                                
________________________________________________________________________________
Figure 11a: PFINDM FIND Utilities Menu Panel
 
 
    3b) Below is a representative response:
 
________________________________________________________________________________
 --------------------   Search String Results   --------------------------------
 COMMAND ===>                                                   SCROLL ===> CSR 
 FIND004  Exceeded DSN limit.  DSNs Searched reflects applied limit.            
 Group :          Quick: Y  ListAll: Y                                  LARRY03 
 DSN CONTAINS : ASM                                                     PSRCH   
 Search String: VTOC                                                            
                                                                                
 PF3-End   PF7-Up   PF8-Down                                                    
 Dataset can be Browsed or Edited                                               
                                                                                
 DSNs            DSNs           DSN w/       Found      Total                   
 Extracted: 60   Searched: 20   NoHits: 15   Mbrs: 7    Hits: 7                 
 S   Dataset Name-------------------------------- Member   Found Volume         
     CBT.MVS38J.ASM                               BSPAPFCK     1 CBTCAT         
     CBT.MVS38J.ASM                               REQUEUE      1 CBTCAT         
     CBT.MVS38J.ASM                                MBRS->>     2                
     CBT.MVS38J.ASM                                HITS->>     2                
     CBT072.DCMS.ASM                              >*NONE*<       CBTCAT         
     CCOMPR.V0R9M00.ASM                           CHKDSN       1 PUB006         
     CCOMPR.V0R9M00.ASM                            MBRS->>     1                
     CCOMPR.V0R9M00.ASM                            HITS->>     1                
     CUTIL00.V1R0M00.ASM                          >*NONE*<       MVSDLB         
     CUTIL00.V1R1M00.ASM                          >*NONE*<       PUB006         
     DALCDS.V1R0M00.ASM                           >*NONE*<       PUB006         
     DFSPC.V1R0M00.ASM                            DFSPC        1 PUB006         
     DFSPC.V1R0M00.ASM                             MBRS->>     1                
     DFSPC.V1R0M00.ASM                             HITS->>     1                
________________________________________________________________________________
Figure 11b: PSRCH Results Panel
 
 
    3c) Referring to the first dataset, CBT.MVS38J.ASM.  Two members contain
        the string 'vtoc' at least once!  Members BSPAPFCK and REQUEUE.
 
        As summarized, a total of two members (MBRS->>) in CBTMVS38J.ASM contain
        the requested search string for a total of 2 hits (HITS->>).
 
    3d) Press PF3 to return to menu PFINDM.
 
 
    4a) This test uses LOCATE CP to search for a load member in a
        system library.                           
           
        Enter data on panel:
 
        1. Enter  4        in COMMAND        as shown below
        2. Enter  bsposcmd in Member Name    as shown below
        3. Press  ENTER
 
________________________________________________________________________________
 ----------------------         FINDSRCH Menu         --------------------------
 COMMAND ===>                                                                   
                                                                                
  1  Find MEMBER in DSL                                                 LARRY03 
  2  List Datasets in DSL                                               PFINDM  
  3  Find members in DSL with SEARCHstr                                         
       optionally grouped by MEMBER                                             
  4  Find MEMBER in system libraries                                            
  5  Find MEMBER in allocated DDName                                            
                                                                                
                                                                                
  DSL (Dataset List) includes dataset names with DSNstr located at DSNstrPOS    
  where  S start of DSN, or  E end of DSN, or   C contained in DSN.             
                                                                                
 DSNstrPOS ===>    S/E/C                                                    
 DSNstr ======>                                                               
 DDName ======>                                                               
 MEMBER ======> bsposcmd                                                      
 SEARCHstr  ==>                                              Use single quotes
 Fast Search =>    Y/N  Stop string member search after first found occurrence  
 ListAll DSN =>    Y/N  List all datasets processed (options 1-3)               
                                                                                
                                                                                
                                                                                
________________________________________________________________________________
Figure 12a: PFINDM FIND Utilities Menu Panel
 
 
    4b) Below is a representative response in a browse session:
 
________________________________________________________________________________
 LARRY01.CLOC8.S1.LOC8OUT.Dccjjj.Thhmmss on PUB001 -----------------------------
 Command ===>                                                                   
1       10        20        30        40        50        60        70        80
+---+----+----+----+----+----+----+----+----+----+----+----+----+----+----+----+
1:  BSPOSCMD IS A MEMBER IN SYS2.LINKLIB                                        
                                                                                
RESULTS: 'LARRY01.CLOC8.S1.LOC8OUT.D22038.T112736'                              
COMMAND: LOCATE (BSPOSCMD) ALL                                                  
******EOF-TTR=00010100************************************ BOTTOM OF DATA ******
________________________________________________________________________________
Figure 12b: Find Load Member results
 
 
    4c) BSPOSCMD is located in SYS2.LINKLIB.                                 
 
    4d) Press PF3 to return to menu PFINDM.
 
 
 
 
 
 
 
    5a) This test uses FIND CP for locating a PDS member in libraries
        (PDSs) assigned to a TSO session DD.    
           
        Enter data on panel:
 
 
        1. Enter  5       in Command     as shown below
        2. Enter  cvol    in Member Name as shown below
        3. Enter  ispclib in DD          as shown below
    *****  ispclib is your ISPF CLIB DD name on your system
        4. Press ENTER
        
________________________________________________________________________________
 ----------------------         FINDSRCH Menu         --------------------------
 COMMAND ===> 5                                                                 
                                                                                
  1  Find MEMBER in DSL                                                 LARRY03 
  2  List Datasets in DSL                                               PFINDM  
  3  Find members in DSL with SEARCHstr                                         
       optionally grouped by MEMBER                                             
  4  Find MEMBER in system libraries                                            
  5  Find MEMBER in allocated DDName                                            
                                                                                
                                                                                
  DSL (Dataset List) includes dataset names with DSNstr located at DSNstrPOS    
  where  S start of DSN, or  E end of DSN, or   C contained in DSN.             
                                                                                
 DSNstrPOS ===>    S/E/C                                                    
 DSNstr ======>                                                               
 DDName ======> ispclib                                                       
 MEMBER ======> cvol                                                          
 SEARCHstr  ==>                                              Use single quotes
 Fast Search =>    Y/N  Stop string member search after first found occurrence  
 ListAll DSN =>    Y/N  List all datasets processed (options 1-3)               
                                                                                
                                                                                
                                                                                
________________________________________________________________________________
Figure 13a: PFINDM FIND Utilities Menu Panel
 
 
    5b) The following is a satisfactory representative terminal response: 
 
________________________________________________________________________________
 REQUEST: FIND MEMBER-CVOL   IN DD-ISPCLIB                            
 ============================================                         
 MEMBER CVOL FOUND IN PRIVATE LIB AT ISPCLIB+000 (ISP.SYSCOM.ISPCLIB) 
 .                                                                    
 *$$** DDNAME   VOLUME LRECL BLKSZ DATASETNAME                        
 *$$** ISPCLIB  PUB007 00080 03120 ISP.SYSCOM.ISPCLIB                 
 *$$**          PUB005 00080 03120 ISP.V2R2M0.CLIB                    
 *$$**          PUB005 00080 03120 REVIEW.R50M0.CLIST                 
 *$$**          PUB007 00080 03120 LARRY01.SYSLOG.ISPCLIB             
 *$$**          PUB007 00080 03120 LARRY01.ISPCLIB.CBT143             
 LINES PROCESSED:159                                                  
 ***                                                                  
________________________________________________________________________________
Figure 13b: Find PDS Member in DD results         
 
    5c) Note location (PDS) where CVOL resides is displayed including a list of 
        libriaries associated with DD ISPCLIB. 
 
    5d) Press PF3 to return to menu PFINDM.
 
 
 
 
 
 
    e) Validation for FINDSRCH is complete.
 
 
+--------------------------------------------------------------------+
| Step 11. Done                                                      |
+--------------------------------------------------------------------+
 
 
    a) Congratulations!  You completed the installation for FINDSRCH.


+--------------------------------------------------------------------+
| Step 12. Incorporate FINDSRCH into ISPF UTILITY SELECTION Menu     |
+--------------------------------------------------------------------+
 
 
    a) It is suggested using option F from the UTILITY SELECTION MENU
       (panel ISPUTILS) as option 3.F.                           
                                                                     
    b) Create a copy of ISPUTILS in your application panel library
       instead of the ISPF system panel library to preserve the original
       system panel in addition to preserving your ISPUTILS changes      
       when upgrading your ISPF system with a new version.    
                                                                     
    c) Add the 'NEW ENTRY' line as shown below after option 9 as 
       new menu option:
    
     %   9 +COMMANDS    - Create/change an application command table  
     %   F +FIND        - Find-Search Menu               <-- NEW ENTRY
 
    d) Add the 'NEW ENTRY' line as shown below to process the FM option:
                                                                          
       )PROC
         &ZSEL = TRANS( TRUNC (&ZCMD,'.')
                       1,'CMD(RFE 3.1;X) NEWAPPL(ISR)'   
                       .
                       .
                       9,'PANEL(ISPUCMA)' 
                       F,'PANEL(PFINDM) NEWAPPL(FIND)'     <-- NEW ENTRY
                       .
                       .
                     ' ',' '
                       *,'?' )
       )END
 
    e) Save UTILITY SELECTION MENU panel changes.                               

    f) Type =3 in the COMMAND line.  The new menu item (F) should display. 

    g) Type F in the COMMAND line.  The new FIND menu (panel PFINDM) should
       display.



Enjoy FINDSRCH for ISPF 2.x on MVS 3.8J!
                                                                            

======================================================================
* IV. S o f t w a r e   I n v e n t o r y   L i s t                  |
======================================================================

  - FINDSRCH.V0R9M11.ASM 
   . CHKDSN      TSO CP Check for datasets presence        
   . CHKDSNMS    CHKDSN messages program                
   . CUTIL00     TSO CP for CLIST Variables           
   . CUTILTBL    CUTIL00 messages program                
   . DSNTAB      Subroutine used by LOCATE                                   4
   . FINDMEM     TSO CP Find PDS Member in DD list                           5
   . FINDSRCH    TSO CP Find Member in PDS containing string                 3
   . LISTDSJ     TSO CP LISTDSI-like program                                 5
   . LOCATE      TSO CP Find Load Member location and attributes             4
      
  - FINDSRCH.V0R9M11.CLIST
   . CFLDSI      Display DD/DSN allocations and some file attributes         5
   . CLDSI       Display DSN attributes using LISTDSI

  - FINDSRCH.V0R9M11.CNTL
   . $INST00     Define Alias for HLQ FINDSRCH       
   . $INST01     Load CNTL data set from distribution tape (HET)
   . $INST02     Load other data sets from distribution tape (HET)
   . $INST03     Install TSO Parts
   . $INST04     Install FINDSRCH CP
   . $INST05     Install ISPF Parts
   . $INST40     Install CHKDSN, CUTIL00 and LISTDSJ CPs
   . $RECVXMI    Receive XMI SEQ to MVS PDSs via RECV370
   . DSCLAIMR    Disclaimer
   . PREREQS     Required User-mods
   . README      Documentation and Installation instructions

  - FINDSRCH.V0R9M11.HELP
   . CFLDSI      Help file                                                   5
   . CHKDSN      CHKDSN TSO help file
   . CLDSI       CLDSI TSO help file
   . FINDMEM     Help file                                                   5
   . FINDSRCH    Help file                                                   3
   . LISTDSI *   Help file(Alias)                                            5
   . LISTDSJ     Help file                                                   5
   . LOCATE      Help file                                                   4

  - FINDSRCH.V0R9M11.ISPF
   . C$FNDSRH    Invoke Compare Panel from TSO command line 
   . CLOC8       Find Load Member CLIST, uses LOCATE                         4
   . CMEMFIND    Find Member CLIST, uses CPs VTOC and CHKDSN                 1
   . CMEMINDD    Find PDS Member in DD CLIST, uses FINDMEM and CFLDSI CLIST  5
   . FIND00      Find Message file
   . FIND01      Find Message file
   . HMEMFIND    Find Member Help panel                                      1
   . PFINDM      Find Menu panel                                             0
   . HFINDM      Find Menu Help panel                                        0
   . PMEMFIND    Find Member results panel                                   1
   . PVOL        Find Datasets results panel                                 2
   . HVOL        Find Datasets Help panel                                    2
   . CVOL        Find Member CLIST, uses VTOC                                2
   . PSRCH       Find String results panel                                   3
   . HSRCH       Find String Help panel                                      3
   . CSRCH       Find Member CLIST, uses VTOC and FINDSRCH                   3
                
  - FINDSRCH.V0R9M11.MACLIB
   . README      Dummy member, this is intentional
       
       
                                                                            

  - Find-Search Menu options
    - 1 Find PDS MEMBER in DSN
    - 2 Find Datasets with DSN
    - 3 Find PDS members with SEARCH STRING in DSN
    - 4 Find Load MEMBER in system libraries             
    - 5 Find PDS MEMBER in allocated DD                  
                                                                              
  - Other Software used by FINDSRCH              
      o VTOC     Extract VTOC information for a given DSN parameter
                 (included in MVS 3.8J TK3 and TK4- systems)
       
                  
       
