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
