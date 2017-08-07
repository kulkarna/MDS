
-- =============================================
-- Author:		Antonio Jr
-- Create date: 4/22/2009
-- Description:	Deletes a record using the Id
-- =============================================
CREATE PROCEDURE [dbo].[usp_DepositAgencyRequirementHeaderSelect]
	-- Add the parameters for the stored procedure here
	@p_id INT
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT * from dbo.DepositAgencyRequirementHeader 
    WHERE DepositAgencyRequirementID = @p_id
                                   
END


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DealScreening', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DepositAgencyRequirementHeaderSelect';

