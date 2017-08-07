use LibertyPower
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/************************************************************************************************
 Author:		Gail Mangaroo
 Create date: 03/14/2013
 Description:	Update missing Delivery Points
************************************************************************************************/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'usp_AccountContractDeliveryPointUpdate')
    BEGIN
    	DROP PROCEDURE usp_AccountContractDeliveryPointUpdate
    END
GO


CREATE PROCEDURE usp_AccountContractDeliveryPointUpdate
AS
BEGIN
	SET NOCOUNT ON;
	
	-- Questions/Issues !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	-- Lp_transactions..ediProxyQuery to be replaced by results of query from Douglas (EDIQuery) 
	-- Verify that join with LibertyPower..Utility takes care of the correct id of the ISO returned by the EDIQuery 
	-- Which DB should these SPs reside in ...
	
	-- SELECT DISTINCT e.accountNumber, ZoneCode , idpm.*, ac.AccountContractID , u.UtilityCode , e.UtilityCode
	UPDATE ac SET DeliveryPointIntRefID = idpm.DeliveryPointIntRefID
	FROM Lp_transactions..ediProxyQuery e  (NOLOCK) 
		JOIN LibertyPower..IsoDeliveryPointMapping idpm (NOLOCK) on e.ZoneCode = idpm.isovalue
		JOIN LibertyPower..Account a (NOLOCK) on a.AccountNumber = e.AccountNumber 
		JOIN LibertyPower..AccountContract (NOLOCK) ac on ac.AccountID = a.AccountID 
		JOIN LibertyPower..Utility u (NOLOCK) on a.UtilityID = u.ID 
			AND u.UtilityCode = e.UtilityCode	
	WHERE ZoneCode IS NOT NULL 
		AND isnull(ac.DeliveryPointIntRefID , 0) = 0
		AND ISNULL(idpm.DeliveryPointIntRefID, 0) > 0 
	ORDER BY e.accountnumber 

	SET NOCOUNT OFF
END 
GO	