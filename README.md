# bluetoothManager

Recently, I worked with iBeacons. It's a really incredible development for indoor position and ads pushing. Apple provide some convenient apis to support this. Developers can easily find iBeacons and get rssi or transfer datas.

# What's this?
This is a similar function, just basic, to iBeacons. It now mainly focuses on how to search the bluetooth devices, read the devices' names, and their rssis. 

# Why this?
For some reason, Apple only allow users to search, or get information from iBeacons, which you already knew their UUIDs. We only can identify iBeacons by their majors and minors. In addition, the bluetooth devices also have to follow the protocol of iBeacons. 
However, we can easily get bluetooth devices, and it is also simple for users to convert their mobile devices to bluetooth devices. In this situation, we can not use the iBeacons apis to support our requirement.

#Functions
SPBeacon contains all properties of beacons.
SPBlueToothManager is responsible for Searching beacons(or said bluetooth devices), Getting information from beacons, Filtering beacons, and backing information.

#What's new
2015.01.28
(1)Work well with beacons searching.
(2)Filter bluetooth devices with their names.
(3)Simply use rssi to distinguish the distance from beacons.
