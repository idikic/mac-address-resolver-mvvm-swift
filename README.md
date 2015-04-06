#M.A.C. -> MAC address resolver

- written in Swift
- some classes are in Objective - C and C (low level networking stuff)
- using MVVM
- support >= iOS8
- universal application
- using Swift language features for bindings (WIP)
- still very much **WIP**

**MAC** (media access control) is a simple way to use the utility application which helps users to find the manufacturer or a vendor of any device that has a MAC address (usually every device that has some kind of network communication). 
It uses the first six digits of a MAC address, also known as OUI (Organisationally Unique Identifier) to identify the desired device. 

##Features: 

-> local database that can be updated through Settings

-> online database (default), very small data usage

-> three input modes: PICKER, IP, READER

###PICKER: 
-> classic spinner with 6 columns 

###IP:
-> extracts MAC address using the IP address of a device that is on the same subnet. 

###READER:
-> scans MAC address bar code
