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
