
CREATE PROCEDURE [dbo].[usp_VRE_ARCreditReservePercentInsert]
	@FileContextGUID uniqueidentifier,
	@UtilityCode varchar(50),
	@Month int,
	@Year int,
	@ARPercent decimal(18,4),
	@CreatedBy int
AS
BEGIN
   INSERT INTO [VREARCreditReservePercent]
           ([FileContextGUID]
           ,[UtilityCode]
           ,[Month]
           ,[Year]
           ,[ARPercent]
           ,[CreatedBy]
           ,[ModifiedBy])
     VALUES
           (@FileContextGUID,
			@UtilityCode,
			@Month,
			@Year ,
			@ARPercent ,
			@CreatedBy,
			@CreatedBy);
			
	IF @@ROWCOUNT > 0
	BEGIN
		SELECT 
		   [ID]
		  ,[FileContextGUID]
		  ,[UtilityCode]
		  ,[Month]
		  ,[Year]
		  ,[ARPercent]
		  ,[DateCreated]
		  ,[CreatedBy]
		  ,[DateModified]
		  ,[ModifiedBy]
		FROM [VREARCreditReservePercent] 
		WHERE ID = SCOPE_IDENTITY();
	END


END

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_ARCreditReservePercentInsert';

