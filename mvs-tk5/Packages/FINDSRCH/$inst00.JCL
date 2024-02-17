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
