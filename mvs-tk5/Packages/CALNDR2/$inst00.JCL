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
