/****** Script for SelectTopNRows command from SSMS  ******/
--USE OnlineEnrollment
--go


-- InactiveInd is used by Data Syncrhonizer when determining whether to pull prices for a given market

--Set Inactive Markets - (indicates Prices are NOT pulled by OnlineEnrollmentDataSynchronizer)
UPDATE Market SET InactiveInd = '1' 
WHERE MarketCode IN ('ALL', 'CA', 'DC', 'DE', 'MA', 'ME', 'RI', 'TX')


--Set Active Markets - (indicates Prices are pulled by OnlineEnrollmentDataSynchronizer)
UPDATE Market SET InactiveInd = '0' 
WHERE MarketCode IN ('CT', 'IL', 'MD', 'NJ', 'NY', 'OH', 'PA')

--Disable these Markets from Online Enrollment UI
UPDATE Market SET EnableOnlineEnrollment = 0 
WHERE MarketCode IN ('ALL', 'CA', 'DC', 'DE', 'MA', 'ME', 'RI', 'TX', 'CT', 'MD', 'NJ', 'OH')

--Enable ONLY these Markets for Online Enrollment UI
UPDATE Market SET EnableOnlineEnrollment = 1 
WHERE MarketCode IN ('PA', 'IL', 'NY')


