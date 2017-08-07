-- ==================================================
-- Author: Agata Studzinska
-- Date:   12/05/2012
-- Comments: This proc will be called by a schedulled job to update regularly the stratum variable and Icap once it becomes available.  
--                  

CREATE PROCEDURE [dbo].[usp_StratumVariableAndIcapUpdate] 
AS
BEGIN

	UPDATE Libertypower..Account
	SET StratumVariable		= CNA.StratumVariable,
		Icap = CNA.ICAP
	FROM Libertypower..Account   A WITH (NOLOCK)  
	INNER JOIN lp_transactions..ConedAccount CNA WITH (NOLOCK) 
	ON A.AccountNumber = CNA.AccountNumber
	WHERE ((A.StratumVariable	IS NULL) OR (A.StratumVariable = ''))
	OR ((A.Icap	IS NULL) OR (A.Icap = ''))
	AND A.UtilityID = 18
	
END