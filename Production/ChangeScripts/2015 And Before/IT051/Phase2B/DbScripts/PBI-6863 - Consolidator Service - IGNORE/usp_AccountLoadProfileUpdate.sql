use LibertyPower
go

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/************************************************************************************************
 Author:		Gail Mangaroo
 Create date: 03/14/2013
 Description:	Update missing Load Profiles
************************************************************************************************/

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'usp_AccountLoadProfileUpdate')
    BEGIN
    	DROP PROCEDURE usp_AccountLoadProfileUpdate
    END
GO


CREATE PROCEDURE usp_AccountLoadProfileUpdate
AS
BEGIN
	SET NOCOUNT ON;
	
	-- Questions/Issues !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	-- Lp_transactions..ediProxyQuery to be replaced by results of query from Douglas (EDIQuery) 
	-- Verify that join with LibertyPower..Utility takes care of the correct id of the ISO returned by the EDIQuery 
	-- Which DB should these SPs reside in ...
	
	-- SELECT DISTINCT e.accountNumber, ZoneCode ,  u.UtilityCode , e.UtilityCode , e.LoadProfile , a.LoadProfile
	UPDATE a SET LoadProfile = e.LoadProfile 
	FROM Lp_transactions..ediProxyQuery e (NOLOCK) 
		JOIN LibertyPower..Account a (NOLOCK) on a.AccountNumber = e.AccountNumber 
		JOIN LibertyPower..Utility u (NOLOCK) on a.UtilityID = u.ID and u.UtilityCode = e.UtilityCode	
	WHERE rtrim(isnull(e.LoadProfile, '')) <> ''
		and rtrim(isnull(a.LoadProfile, '')) = ''
	--ORDER BY e.accountnumber 

	SET NOCOUNT OFF;
END 
GO	