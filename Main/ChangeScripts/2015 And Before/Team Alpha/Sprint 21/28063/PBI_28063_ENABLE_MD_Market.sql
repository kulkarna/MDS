/******************************************************/
/* 
	Enables Online Enrollment for MD Market
*/
/******************************************************/
USE OnlineEnrollment
go

--Enable these Markets for Online Enrollment UI
UPDATE Market SET EnableOnlineEnrollment = 1 
WHERE MarketCode IN ('MD')

