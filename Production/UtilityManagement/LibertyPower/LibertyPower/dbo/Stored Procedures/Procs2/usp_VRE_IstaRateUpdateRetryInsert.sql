

CREATE PROCEDURE [dbo].[usp_VRE_IstaRateUpdateRetryInsert]
	@AccountNumber Varchar(50),
	@Utility Varchar(50),
	@Rate decimal(18,10),
	@SwitchDate DateTime,
	@RawEndingDate DateTime,
	@CreatedBy int
AS

Begin

	SET NOCOUNT ON;
	
	Insert Into VREIstaRateUpdateRetries 
		(AccountNumber, Utility, Rate, SwitchDate, RawEndingDate, CreatedBy)
		Values
		(@AccountNumber, @Utility, @Rate, @SwitchDate, @RawEndingDate, @CreatedBy)
		
End

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_IstaRateUpdateRetryInsert';

