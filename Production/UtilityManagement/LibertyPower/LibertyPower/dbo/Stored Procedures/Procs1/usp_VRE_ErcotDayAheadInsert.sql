
CREATE PROCEDURE [dbo].[usp_VRE_ErcotDayAheadInsert]
	@FileContextGUID uniqueidentifier,
	@Date DATETIME,
	@IntervalEnding INT,
	@Houston decimal(18,4),
	@North decimal(18,4),
	@South decimal(18,4),
	@West decimal(18,4),
	@CreatedBy int
AS
BEGIN
   INSERT INTO [VREErcotDayAhead]
           (
           [FileContextGUID]
           ,[Date]
		   ,[IntervalEnding]
		   ,[Houston]
		   ,[North]
		   ,[South]
		   ,[West]
           ,[CreatedBy]
           ,[ModifiedBy]
           )
     VALUES
           (@FileContextGUID,
			@Date,
			@IntervalEnding,
			@Houston,
			@North,
			@South,
			@West,
			@CreatedBy,
			@CreatedBy);
			
	IF @@ROWCOUNT > 0
	BEGIN
		SELECT [ID]
		  ,[FileContextGUID]
		  ,[Date]
		  ,[IntervalEnding]
		  ,[Houston]
		  ,[North]
		  ,[South]
		  ,[West]
		  ,[DateCreated]
		  ,[CreatedBy]
		  ,[DateModified]
		  ,[ModifiedBy]
		FROM [VREErcotDayAhead] 
		WHERE ID = SCOPE_IDENTITY();
	END


END




GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_ErcotDayAheadInsert';

