//ISPOPT50 JOB (SYS),'Def ISPOPT5 Alias',    <-- Review and Modify 
//         CLASS=A,MSGCLASS=X,               <-- Review and Modify
//         MSGLEVEL=(1,1),NOTIFY=&SYSUID     <-- Review and Modify
//* -------------------------------------------------------*
//* *  ISPOPT5 in MVS3.8J TSO / Hercules                   *
//* *  JOB: $INST00  Define Alias for HLQ ISPOPT5          *
//* *  Note: The master catalog password will be required  *
//* -------------------------------------------------------*
//DEFALIAS EXEC PGM=IDCAMS 
//SYSPRINT DD  SYSOUT=*
//SYSIN    DD  *
 PARM GRAPHICS(CHAIN(SN))
 LISTCAT ALIAS  ENT(ISPOPT5) 
  
 IF LASTCC NE 0 THEN -
    DEFINE ALIAS(NAME(ISPOPT5) RELATE(SYS1.UCAT.MVS))                          
/*                                                                      
//
