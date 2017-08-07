USE [lp_MtM]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Felipe Medeiros
-- Create date: 10/28/2013
-- Description:	Procedure to validate if there is some custom deal matching record
-- =============================================
CREATE PROCEDURE usp_CPEValidateCustomDealInfo
(
	@BatchNumber AS VARCHAR(50),
	@QuoteNumber AS VARCHAR(50)
) AS 
BEGIN

	SET NOCOUNT ON;

	select 
		COUNT(*) as "Counter"
	FROM
		MtMDailyWholesaleLoadForecast l  (nolock)
		INNER JOIN MtMAccount m (nolock) ON  l.MtMAccountID = m.ID  
		INNER JOIN LibertyPower..Account a (nolock) ON  m.AccountID = a.AccountID  
		INNER JOIN MtMCustomDealAccount ca (nolock) ON  a.AccountNumber = ca.AccountNumber AND  m.CustomDealID = ca.CustomDealID  
	WHERE 
		m.BatchNumber = @BatchNumber  
		AND  m.QuoteNumber = @QuoteNumber

	SET NOCOUNT OFF;		
END
GO