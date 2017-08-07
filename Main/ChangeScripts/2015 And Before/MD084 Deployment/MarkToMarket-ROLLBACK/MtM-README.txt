README

ROLLBACK MARK TO MARKET HOST SET UP SERVICE ON LPCNOCWS4

1- Uninstall the service from lpcnocws4 located at C:\Program Files (x86)\Liberty Power\MarkToMarketServiceLibraryHostSetup
2- Install the MSI in the same folder as this README, dated 8/2/2012
3- Replace the dll MarkToMarket in C:\Program Files (x86)\Liberty Power\MarkToMarketServiceLibraryHostSetup on LPCNOCWS4 with the one in this folder dated 12/17/2012 (it is already in production as of 12/27/2012) 
	with the version present in the same folder as this README
4- Start the service.

PS:
The service name is MarktoMarketServiceHost. It runs under the LocalSystem user.
If rolling back Deal capture, this service should rollback also.
