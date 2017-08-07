
CREATE PROCEDURE [dbo].[usp_VRE_NyisoDayAheadInsert]
	@FileContextGUID uniqueidentifier,
	@TimeStamp DATETIME,
	@Name VARCHAR(50),
	@PTID INT,
	@LBMP DECIMAL(18,4),
	@MarginalCostLosses DECIMAL(18,4),
    @MarginalCostCongestion DECIMAL(18,4),
	@CreatedBy INT
AS
BEGIN
   INSERT INTO [VRENyisoDayAhead]
           (
			[FileContextGUID], 
			[TimeStamp],
			[Name], 
			[PTID],
			[LBMP],
			[MarginalCostLosses], 
			[MarginalCostCongestion], 
			[CreatedBy], 
			[ModifiedBy]           
           )
     VALUES
           (
			@FileContextGUID,
			@TimeStamp,
			@Name,
			@PTID,
			@LBMP,
			@MarginalCostLosses,
			@MarginalCostCongestion,
			@CreatedBy,
			@CreatedBy);
			
	IF @@ROWCOUNT > 0
	BEGIN
		SELECT [ID]
		  ,[FileContextGUID]
		  ,[TimeStamp]
		  ,[Name]
		  ,[PTID]
		  ,[LBMP]
		  ,[MarginalCostLosses]
		  ,[MarginalCostCongestion]
		  ,[DateCreated]
		  ,[CreatedBy]
		  ,[DateModified]
		  ,[ModifiedBy]
		FROM [VRENyisoDayAhead] 
		WHERE ID = SCOPE_IDENTITY();
	END


END

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_NyisoDayAheadInsert';

