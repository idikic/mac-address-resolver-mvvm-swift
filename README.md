#M.A.C.
M.A.C. - MAC address resolver universal application written in Swift using MVVM

##m.a.c. address resolver

	resolve vendor details based on MAC address
	support > iOS7
	

M.A.C. (media access control) is a simple way to use the utility application which helps users to find the manufacturer or a vendor of any device that has a MAC address (usually every device that has some kind of network communication). 
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