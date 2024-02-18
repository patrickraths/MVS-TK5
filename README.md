# MVS 3.8j TK5 Update 2 as docker container
MVS TK5 is an implementation of OS/VS2 MVS Release 3.8J. The successors to MVS 3.8, MVS/XA, MVS/ESA, OS/390 and z/OS all demonstrate their OS/VS MVS 3.8 heritage. 

## Building and running MVS-TK5 as container
Building the container is controlled through the Dockerfile found in the root directory of this repository. T
### Building blocks
- Dockerized version of SDL-Hercules-390 Version 4.5 (https://github.com/patrickraths/docker-SDL-Hercules-390) used as base image
- [TK5 Update 2](https://www.prince-webdesign.nl/tk5)
### Changes to TK5 Update 2
The following changes were applied to the default TK5 Update 2 configuration
- Remove embedded Hercules
- Remove all Windows related startup files
- Remove support to run Hercules in unattended (daemon) mode
- Modifed startup files
- Added support for user defined DASD using docker volume
### Building the MVS-TK5 Docker Image
- Building the Docker image
```
docker build -t mvs-tk5:latest .
```
## Running TK5 as container
When running the container, hercules, the mainframe System/370 emulator, will be started, configured to run MVS 3.8j, and an IPL of TK5 is performed. Once MVS has started, it can be accessed using a TN3270 emulator using port 3270. The Hercules console can be access by connecting to <http://localhost:8038> using any web browser.

```
docker run --name mvs-tk5 -it -p 3270:3270 -p 8038:8038 --cap-add=sys_nice --mount src=mvs-tk5-dasd.usr,target=/opt/tk5/dasd.usr mvs-tk5
```
| Parameters | Description |
| :--- | :-- |
| --name \<name\>  | Name of the container to be created, e.g. **mvs-tk5** |
| -it | Attach interactive terminal to view log output | 
| -p \<host port\>:\<container port\> | Maps ports between host and container<br>Port 3270: Telnet 3270 to access MVS<br>Port 8038 to access the Hecules console |
| --cap-add=sys_nice | Grants the container the `CAP_SYS_NICE` capability, which allows the container to raise process nice values, set real-time scheduling policies, set CPU affinity, and other operations. |
| --mount src=\<volume\>,target=/opt/tk5/dasd.usr | Uses the volume specified by \<volume\> and maps it to the containers file system as specified by target=<br>Creates a volume, e.g. **mvs-tk5_dasd.usr** and maps it to the containers internal file system as **/opt/tk5/dasd.usr** to mount additional DASD[^1] that are not part of the system configuration in a persistent storage.<br>By default all DASD are stored in the directory /opt/tk5/dasd, user created DASD should be placed in **/opt/tk5/dasd.usr**<br>Details on how to create additional DASD and configure MVS to use them can be found in the section **Customizing MVS=TK5** |

Loading of MVS-TK5 is completed when the following is shown on the Hercules console:<br>
<img width="500" alt="image" src="https://github.com/patrickraths/MVS-TK5/assets/43680256/235f3083-788c-4762-a850-c998ae42b465">

### Login into MVS-TK5
- Connect to port 3270 on your local host using an 3270 Emulator
- Logon using **HERC02** as user and **CUL8TR** as password
  <br><img width="250" alt="image" src="https://github.com/patrickraths/MVS-TK5/assets/43680256/f8d7774a-a701-45b3-9bdb-0cbd6fc3871d">
  <img width="250" alt="image" src="https://github.com/patrickraths/MVS-TK5/assets/43680256/34dfc84d-5513-4b3d-b059-ad9182ffca49">
  <img width="250" alt="image" src="https://github.com/patrickraths/MVS-TK5/assets/43680256/367233c8-371a-4921-adf2-f93767a78532">
- Accept the welcome messages until you see the ISPF Primary Menu
  <br><img width="500" alt="image" src="https://github.com/patrickraths/MVS-TK5/assets/43680256/6be9b943-c498-45d1-906a-02a09afa0f37">

## Customizing TK5
### Changing the Timezone
- Select **2** (Edit) from the ISPF primary option menu
- Select **SYS1.PARMLIB(PARMTZ)**
  <br><img width="350" alt="image" src="https://github.com/patrickraths/MVS-TK5/assets/43680256/454e7a68-9897-4c74-8cc6-5701ff9cb890">
- Change the Time Zone setting<br>
  Syntax:<br>
  D,HH[.MM[.SS]]<br><br>
  Parameters:<br>
  "E" or "W" to specify a time zone east or west or Greenwich Mean Time (GMT)
  HH specifies the number of hours deviation from GMT (00-12)
  MM specifies the number of minutes. Optional parameter. (00-59)
  SS specifies the number of seconds. Optional parameter (00-59)

  <img width="1120" alt="image" src="https://user-images.githubusercontent.com/43680256/228867399-c9d08e02-9851-4f09-939c-f7aff5a65d82.png">

### Enabling the CBT Catalogue
To make the CBT Volumes accessibles submit job **SYS1.SETUP.CNTL(MVS0170) [issue **sub** on the Command line when viewing/editing the dataset]. This connects the SYS1.UCAT.CBT user catalog to the master catalog and defines the CBT, CBTCOV, CBT072, CBT129, CBT249, CBT429 HLQ as aliases.

Recommendation:<br>
Change MSGCLASS from 'A' to 'H' so that the result of the job can be viewed

<img width="585" alt="image" src="https://user-images.githubusercontent.com/43680256/229275001-82b5c4a7-8b9e-4284-83f3-9deddf85ce1c.png">

## Adding User DASD
There are different DASD types that vary in capacity; typical models as 3330, 3340, 3350, 3380, 3390, etc. 

MVS communicates to DASD through addresses. MVS-TK5 has assigned the following address ranges for DASD devices:
<img width="640" alt="image" src="https://user-images.githubusercontent.com/43680256/229289077-eb87138d-e61f-4190-968b-8ba2e0680f48.png">

In MVS-TK5 the following addresses for DASD Model 3350 are in use:
| Address | Volume |
| :------ | :----- |
| 0140 | WORK00 |
| 0148 | MVSRES |
| 0149-014A | SMP001, SMP002 |
| 014B-014C | SMP003, SMP004 |
| 0240-0241 | PUB000, PUB010 |
| 0248 | MVSDLB |
| 0340-0342 | CBT000, CBT001, CBT002 |
| 0343 | CBTCAT |
For the actual use of addresses refer to the **conf/tk5-.cnf** file

### Create and configure a user DASD
1. Create the DASD<br>
   For our purpose we want to create the following volume to store user data:
   | Address | Model | Volume |
   | :------ | :---- | :----- |
   | 034A | 3350 | USR000 |
   
   To create the DASD image hercules provides a utility called **dasdinit**. The terminal console of the container can be accessed either by using the Docker Dashboard or by launching a terminal session using `docker exec -it mvs-tk5 /bin/bash` and use the following command to create the DASD.    
   ```
   dasdinit -z -a /opt/tk5/dasd.usr/usr000.34a 3350 USR000
   ````
   This creates a new DASD of Type 3350 with the Volume name **USR000**
   >HHC02499I Hercules utility dasdinit - DASD image file creation program - version 4.5.0.10830-SDL-g58578601-modified<br>
   >HHC01414I (C) Copyright 1999-2022 by Roger Bowler, Jan Jaeger, and others<br>
   >HHC01417I ** The SoftDevLabs version of Hercules **<br>
   >HHC01415I Build date: Mar 28 2023 at 10:51:26<br>
   >HHC00462I 0:0000 CKD file /opt/tk5/dasd.usr/usr000.34a: creating 3350 volume USR000: 560 cyls, 30 trks/cyl, 19456 bytes/track<br>
   >HHC00460I 0:0000 CKD file /opt/tk5/dasd.usr/usr000.34a: 560 cylinders successfully written<br>
   >HHC02423I DASD operation completed<br>
2. Attach DASD<br>
   In order for MVS to communicate with the DASD it must be attached. To attach the DASD at address 34A in the running configuration use the following command in the Hercules console:
   ```
   attach 034a 3350 dasd.usr/usr000.34a
   ```
   <img width="569" alt="image" src="https://user-images.githubusercontent.com/43680256/229291338-b4438109-14fa-4a1e-a3f8-041459a4ef02.png">   
3. Initalize the DASD Image for use by MVS
   Although the dasdinit program creates the raw DASD image, MVS requires additional information that is not written by dasdinit. The following JCL initalizes newly created DASD as Volume **USR000** using address **34A**, and assigns 1 Cylinder (30 Tracks) for the VTOC.
   
   ```
   //INITDASD JOB (INITDASD),                                            
   //             'Initialize DASD',                                     
   //             CLASS=A,                                               
   //             MSGCLASS=H,                                            
   //             MSGLEVEL=(1,1)                                         
   //********************************************************************
   //*                                                                   
   //* Name: (DEFCAT)                                                    
   //*                                                                   
   //* Desc: Initializes a DASD for use with MVS                         
   //*                                                                   
   //********************************************************************
   //STEP1    EXEC PGM=ICKDSF,REGION=4096K                               
   //SYSPRINT DD   SYSOUT=*                                              
   //SYSIN    DD   *                                                     
     INIT UNITADDRESS(34A) NOVERIFY VOLID(USR000) OWNER(HERCULES) -      
                  VTOC(0,1,30)                                           
   //                                                                    
   ```
   You will be asked to confirm that you actually want to initialize the volume at the address specified:
   >*00 ICK003D REPLY U TO ALTER VOLUME 34A CONTENTS, ELSE T

   The reply of U allows the initialization to proceed.  There will be a number of informational messages printed in the SYSPRINT output during the executing of ICKDSF.  The most important thing to verify is that the return code for the job is 0000.
   
   <img width="564" alt="image" src="https://user-images.githubusercontent.com/43680256/229292813-f8b2b471-e8b8-4bad-ae3c-8aabebefaf3b.png">

4. Set the volume online and mount it with the appropriate storage use class<br>
   After the volume is initialized, it must be placed online before MVS will be able to allocate the volume to allow jobs to create datasets on it.  On the MVS console issue the command 
   ```
   /v <address>,online`
   ```
   <img width="566" alt="image" src="https://user-images.githubusercontent.com/43680256/229293847-bbf79122-eec8-4ea6-b7eb-0a6f9cd8faa3.png">

   After the volume is set online it must be mounted.
   ```
   /m 34a,vol=(sl,usr000),use=private
   ```
   <img width="563" alt="image" src="https://user-images.githubusercontent.com/43680256/229294052-0bf92643-5ae9-4a40-b6b0-e710d8375f1d.png">
   
   By using use=private new datasets will be created on this volume only if the user (via JCL or the TSO ALLOCATE command) specifies the volume serial of this disk volume.
   
5. Add the new volume to the MVS & Hercules configuration so it will be mounted automatically
   - Edit MVS Configuration<br>
     By modifying **SYS1.PARMLIB(VATLST00)** MVS will be instructed to automatically mount the volume, if accessible, and assign storage class 2 (Private)
     ```
     USR000,0,2,3350    ,N                  User Volume 1 
     ```
     <img width="636" alt="image" src="https://user-images.githubusercontent.com/43680256/229294781-e78fd5d8-e0f8-4d2e-8155-c4d65568ddcf.png">
   - Edit Hercules Configuration<br>
     Modify the file usr_dasd.cnf in the folder /opt/tk5/dasd.usr to automatically attach the newly created dasd at address 34a. This file is referenced as include in the MVS-TK5 base configuration file (/opt/tk5/conf/tk5-.cnf)

       ```
      #
      # User Added DASD
      #
      034a 3350 dasd.usr/usr000.34a
      ```

      To modify the file use the Docker Dashboard or use the following command to edit it
      ```
      docker exec -it mvs-tk5 nano /opt/tk5/dasd.usr/usr_dasd.cnf
      ```
6. Set Up User Catalogs<br>
   Generally, when adding new storage space to the system, it is also a good time to think about how that storage space will integrate with the catalog structure in place for the system.

   During System Generation, a VSAM Master Catalog was created. It resides on MVSRES and the dataset name of the catalog itself is SYS1.VSAM.MASTER.CATALOG. Although any new datasets you created can be catalogued in the Master Catalog, it is not considered a good practice and would undoubtedly not be allowed in any real world shop.
   
   To create a User catalog called **UCUSR000** that resides on the new volume **USR000** that will be connected to the master catalog, submit the following JCL:
   ```
   //DEFCAT   JOB (DEFCAT),                                              
   //             'Define User Catalog',                                 
   //             CLASS=A,                                               
   //             MSGCLASS=H,                                            
   //             MSGLEVEL=(1,1)                                         
   //********************************************************************
   //*                                                                   
   //* Name: (DEFCAT)                                                    
   //*                                                                   
   //* Desc: Defines a User for the volume(s) specified by //VOL1        
   //*       and create a user catalog on the voluem specifice in the    
   //*       VOLUME (xxxxxx) parameter in DEFINE USERCATALOG.            
   //*                                                                   
   //*       After creating the User catalog, define an alias for all    
   //*       DNS with the High level Qualifer specified in NAME(xxxxx)   
   //*       and relate it to the User catalog                           
   //*                                                                   
   //********************************************************************
   //STEP1    EXEC PGM=IDCAMS,REGION=4096K                        
   //SYSPRINT DD   SYSOUT=A                                       
   //VOL1     DD   VOL=SER=USR000,UNIT=3350,DISP=OLD              
   //SYSIN    DD   *                                              
       DEFINE USERCATALOG -                                      
             (NAME (UCUSR000) -                                  
              VOLUME (USR000) -                                  
              CYLINDERS (20) -                                   
              FOR (9999) -                                       
              BUFFERSPACE (8192) )                               
                                                               
       /* Define Alias for all dataset start with PRATHS      */ 
       DEFINE ALIAS(NAME(PRATHS) RELATE (UCUSR000) )             
   //                                                             
   ```
### Connecting an existing volume to a system
When a volume is brought into the system from a prior functioning system that has its own User Catalog on the volume, the volume must be attached, added to the MVS configuration, and the catalog connected to the master catalog

1. Copy DASD file<br>
   Copy the DASD file to /opt/tk5/dasd.usr directory, respectively run docker using `docker run --name mvs-tk5 -it --mount src=mvs-tk5_dasd.usr,target=/opt/tk5/dasd.usr -p 3270:3270 -p 8038:8038 mvs-tk5:latest` with a docker volume that already contains the DASD files
   
2. Attach the DASD file mount the volume
   - Attach DASD & mount it
   Attach the DASD using the following command in the MVS console:
   ```
   attach 034a 3350 dasd.usr/usr000.34a
   ```
   Once the DASD is attach, set it online using `/v 34a,online` and mount it `/m 34a,vol=(sl,usr000),use=private`

3. Modify the MVS configuration to automatically mount the DASD
   - Edit MVS Configuration<br>
     By modifying **SYS1.PARMLIB(VATLST00)** MVS will be instructed to automatically mount the volume, if accessible, and assign storage class 2 (Private)
     ```
     USR000,0,2,3350    ,N                  User Volume 1 
     ```
     <img width="636" alt="image" src="https://user-images.githubusercontent.com/43680256/229294781-e78fd5d8-e0f8-4d2e-8155-c4d65568ddcf.png">

   - Edit Hercules Configuration<br>
     Modify the file /opt/tk5/dasd.usr/usr_dasd.cnf to automatically attach the newly created dasd at address 34a. This file is referenced as include in the TK5- base configuration file (/opt/tk5/conf/tk5-.cnf)
     ```
     #
     # User Added DASD
     #
     034a 3350 dasd.usr/usr000.34a
     ```

4. Import existing Catalog<br>
   As the existing volume already contains a User Catalog it must be imported and connected to the master catalog using:
   ```
   //IMPCAT   JOB (IMPCAT),                                              
   //             'Import User Catalog',                                 
   //             CLASS=A,                                               
   //             MSGCLASS=H,                                            
   //             MSGLEVEL=(1,1)                                         
   //********************************************************************
   //*                                                                   
   //* Name: (IMPCAT)                                                    
   //*                                                                   
   //* Desc: Imports an existing User catalog and creates alias(es)      
   //*                                                                   
   //********************************************************************
   //STEP1    EXEC PGM=IDCAMS,REGION=4096K                               
   //SYSPRINT DD   SYSOUT=A                                              
   //VOL1     DD   UNIT=3350,DISP=OLD,VOL=SER=USR000                     
   //SYSIN    DD   *                                                     
     IMPORT CONNECT OBJECTS((UCUSR000 VOLUME(USR000) DEVT(3350)))        
     DEFINE ALIAS(NAME(PRATHS) RELATE(UCUSR000))                         
   //
   ```

## Running TK5 as a docker service using Docker Compose
The following is an example of the compose.yaml file to run mvs-tk5. In addition to the volume for user defined DASD additional volumes are being used for the following devices for easier access and to to minimise run-time changes to the container.
| Device | Description | Location in TK5 file system |
| :--- | :--- | :--- |
| User DASD | User defined DASD as described above | /opt/tk5/dasd.usr |
| Logs | TK5 Log files | /opt/tk5/log |
| Tape | Tapes | /opt/tk5/tape |
| Printer | Printer spool files | /opt/tk5/prt |
| Punch | Card Reader | /opt/tk5/pch |

```
#
# Define services
#
services:
  tk5:
    image: praths/mvs-tk5:latest
    container_name: mvs-tk5
    stdin_open: true          # docker run -i
    tty: true                 # docker run -t
    cap_add: 
      - SYS_NICE
    network_mode: bridge
    ports: 
      - 3270:3270
      - 8038:8038
    volumes:
      - dasd.usr:/opt/tk5/dasd.usr
      - log:/opt/tk5/log
      - tape:/opt/tk5/tape
      - prt:/opt/tk5/prt
      - pch:/opt/tk5/pch
    restart: no

volumes:
  #
  # System DASD
  #
  dasd.sys:
  #
  # User DASD
  #
  dasd.usr:
    driver: local
    driver_opts:
      type: 'none'
      o: 'bind'
      device: '/home/user/tk5/dasd.usr'
  #
  # System Logs
  #
  log:
    driver: local
    driver_opts:
      type: 'none'
      o: 'bind'
      device: '/home/user/tk5/log'
  #
  # Tape Devices
  #
  tape:
    driver: local
    driver_opts:
      type: 'none'
      o: 'bind'
      device: '/home/user/tk5/tape'
  #
  # Printers
  #
  prt:
    driver: local
    driver_opts:
      type: 'none'
      o: 'bind'
      device: '/home/user/tk5/prt'
  #
  # Card Readers
  #
  pch:
    driver: local
    driver_opts:
      type: 'none'
      o: 'bind'
      device: '/Users/praths/Documents/tk5/pch'
```
