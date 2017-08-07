USE [LibertyPower]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
* usp_AccountIdentifierSelect
* Get the AccountID
*
* History
*******************************************************************************
* 7/29/2013 - CGHAZAL
* Created.
*/

CREATE PROCEDURE [dbo].usp_AccountIdentifierSelect                                                                                     
	@AccountNumber	VARCHAR(30),
	@UtilityCode	VARCHAR (50)
AS

BEGIN
    SET NOCOUNT ON;
	
	SELECT	a.AccountID
	FROM	Account a (nolock)
	INNER	JOIN Utility u (nolock)
	ON		a.UtilityID = u.ID
	WHERE	a.AccountNumber = @AccountNumber
	AND		u.UtilityCode = @UtilityCode

    SET NOCOUNT OFF;
    
END                                                                                                                                              




