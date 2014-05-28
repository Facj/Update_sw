Get always the latest code in a repository. Update_sw is flexible and self-updatable mechanism for embedded software based on collaborative software features that includes support for dynamic updates.
The repository contains the update agent, the Dynamic_c library, some test scripts and documentation on them.
The update agent handles every step of the update process, including testing and crash report, while the C library provides the functionality required to make source code updatable. Features such as dynamic updates and test require the code to be adapted as explained below.
It can be downloaded to Unix-based systems. It has been successfully used in Raspbian and Ubuntu.

INSTALLING:

	1.Clone the repository
	2.Make changes on the configuration file (update.cfg)
		-Path to the repository you want to update from
		-Enabling/disabling features
	3.Change paths on the files update.sh update.cfg and func.cfg.
    	  Raspbian requires absolute paths.
 

UPDATING:

	1.On manual request:
    
 	       bash update.sh

   	2.Set automatic updates:
	
		bash update.sh -f  <minutes>   [m <minutes>] [h <hours>] [d <days>] 

   
BUILD UPDATABLE CODE:
 In order to build dynamically updatable code compatible with the system, the following instructions must be followed.

	1.Included files:		
		-Structures.x file. Definition of structs of data of the new and the old version,together with the one containing update variables, already provided. Structs can also be declared in a different .x file.
		-Makefile. As well as compiling instructions it includes rpcgen statements to create the serialization functions. Any other library to link can be inserted.
		-Unittest. Including unittest for your source files. It has to be name test_<program_name>.c
	2.Code modifications:
		-Implementation of the option –version so it can be recognised as updatable.• Library headers: Structures.c and dynamic_c.h have to included in the source code.
		-Initialization of the variable PROGRAM_NAME after which serialization files will be named.
		-Update status checking at the beginning of the program. It is performed using the function of the same name implemented in the library.
		-Update points and flow control with if statements.
		-Implementation of functions save_data and restore_data. If no modifications to the data are required, the functions include just the serialization/deserialization.

