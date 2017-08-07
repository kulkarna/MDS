CREATE PROCEDURE [dbo].[usp_VRE_NeisoDayAheadInsert]
	@FileContextGUID uniqueidentifier,
	@Date DATETIME,
	@HourEnd int,
	@LocationID varchar(50),
	@LocationName varchar(50),
	@LocationType varchar(50),
	@LocationalMarginalPrice decimal(18,4),
	@CreatedBy int
AS
BEGIN
   INSERT INTO [VRENeisoDayAhead]
           ([FileContextGUID]
           ,[Date]
           ,[HourEnd]
           ,[LocationID]
           ,[LocationName]
           ,[LocationType]
           ,[LocationalMarginalPrice]
           ,[CreatedBy]
           ,[ModifiedBy]
           )
     VALUES
           (@FileContextGUID,
			@Date,
			@HourEnd,
			@LocationID,
			@LocationName,
			@LocationType,
			@LocationalMarginalPrice,
			@CreatedBy,
			@CreatedBy);
			
	IF @@ROWCOUNT > 0
	BEGIN
		SELECT [ID]
		  ,[FileContextGUID]
		  ,[Date]
		  ,[HourEnd]
		  ,[LocationID]
		  ,[LocationName]
		  ,[LocationType]
		  ,[LocationalMarginalPrice]
		  ,[DateCreated]
		  ,[CreatedBy]
		  ,[DateModified]
		  ,[ModifiedBy]
		FROM [VRENeisoDayAhead] 
		WHERE ID = SCOPE_IDENTITY();
	END


END




GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_NeisoDayAheadInsert';

