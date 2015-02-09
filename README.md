# bluetoothManager
<div><br /></div><div>Recently, I worked with iBeacons. It's a really incredible development for indoor position and ads pushing. Apple provide some convenient apis to support this. Developers can easily find iBeacons and get rssi or transfer datas.</div><div><br /></div>
# What's this?
<div>This is a similar function, just basic, to iBeacons. It now mainly focuses on how to search the bluetooth devices, read the devices' names, and their rssis.&nbsp;</div><div><br /></div>
# Why this?
<div>For some reason, Apple only allow users to search, or get information from iBeacons, which you already knew their UUIDs. We only can identify iBeacons by their majors and minors. In addition, the bluetooth devices also have to follow the protocol of iBeacons.&nbsp;</div><div>However, we can easily get bluetooth devices, and it is also simple for users to convert their mobile devices to bluetooth devices. In this situation, we can not use the iBeacons apis to support our requirement.</div><div><br /></div>
# Functions
<div>SPBeacon contains all properties of beacons.</div><div>SPBlueToothManager is responsible for Searching beacons(or said bluetooth devices), Getting information from beacons, Filtering beacons, and backing information.</div><div><br /></div>
# What's new?
<div>2015.01.28&nbsp;</div><div>(1)Work well with beacons searching.</div><div>(2)Filter bluetooth devices with their names.</div><div>(3)Simply use rssi to distinguish the distance from beacons.</div><div>2015.02.09</div><div>1) In foreground mode, the app will continue to display all the beacons' information without filter.</div><div>2) Users can filter beacons by two ways: name &amp; UUID. And also they can define their own filter characters.</div><div>3) Deprecated readRSSI function. The substitute is using the CBCentralManagerScanOptionAllowDuplicatesKey when scan begin.</div><div>4) Add connect to beacons function &amp; fix the connection problems. The app can connects multiple devices at the same time.</div>
# Next:
<div>1) Add the background mode, which can make the app still refresh RSSI by 1 or 2 seconds, depending on the consideration of the speed of users.</div><div>2) Add the CoreLocation framework to help locate the users.</div><div>3) Add the motion sensor of the iPhone to help judge the direction and the speed of users.</div><div><br /></div>
