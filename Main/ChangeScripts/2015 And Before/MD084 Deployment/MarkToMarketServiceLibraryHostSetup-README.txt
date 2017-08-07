README

INSTALL MARK TO MARKET HOST SET UP SERVICE ON LPCNOCWS4

1- Uninstall the current version of the service from lpcnocws4 located at C:\Program Files (x86)\Liberty Power\MarkToMarketServiceLibraryHostSetup
2- Install the MSI in the same folder as this READM
4- Start the service.

PS:
- The service name is MarktoMarketServiceHost. It runs under the LocalSystem user.
- If rolling back Deal capture, this service should rollback also.
- To check if the service is working fine with deal capture, after submitting a contract, we can this query in SQL9, lp_MtM database

select	* 
from	MtMAccount (nolock)
where DateCreated > '2012-12-19 11:05:00.000' -- date with time and seconds of when the deployment occured
order	by DateCreated desc
