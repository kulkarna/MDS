
-- =============================================
-- Author:		Antonio Jr
-- Create date: 4/22/2009
-- Description:	Inserts a new record 
-- =============================================
CREATE PROCEDURE [dbo].[usp_DepositAgencyRequirementHeaderInsert] 
	-- Add the parameters for the stored procedure here
	@p_agencyID INT, 
	@p_createdBy VARCHAR(50),
	@p_dateCreated DATETIME
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    Insert INTO dbo.DepositAgencyRequirementHeader (AgencyID, CreatedBy, DateCreated)
                                   VALUES(@p_agencyID, @p_createdBy, @p_dateCreated)
	RETURN @@IDENTITY
END


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'DealScreening', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_DepositAgencyRequirementHeaderInsert';

