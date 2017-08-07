-- ==========================================================================
-- Author:		Antonio Jr
-- Create date: April, 17, 2009
-- Description:	Gets the Credit Score Criteria by ID
-- ==========================================================================

CREATE PROCEDURE [dbo].[usp_CreditScoreCriteriaHeaderSelect] 
   	@p_CreditScoreCriteriaHeaderID int 
	
AS
BEGIN
	
	SET NOCOUNT ON;
	
	SELECT  *
	FROM dbo.CreditScoreCriteriaHeader
	WHERE CreditScoreCriteriaHeaderID = @p_CreditScoreCriteriaHeaderID

    
END

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DealScreening', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_CreditScoreCriteriaHeaderSelect';

