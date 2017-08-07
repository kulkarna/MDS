
CREATE PROCEDURE [dbo].[usp_VRE_CapacityTransmissionFactorInsert]
	@FileContextGUID uniqueidentifier,
	@UtilityCode varchar(50),
	@LoadShapeID VARCHAR(50),
	@Month int,
	@Year int,
	@Capacity decimal(18,4),
	@Transmission decimal(18,4),
	@CreatedBy int
AS
BEGIN
   INSERT INTO [VRECapacityTransmissionFactor]
           ([FileContextGUID]
           ,[UtilityCode]
           ,[LoadShapeID]
           ,[Month]
           ,[Year]
           ,[Capacity]
           ,[Transmission]
           ,[CreatedBy]
           ,[ModifiedBy])
     VALUES
           (@FileContextGUID,
			@UtilityCode,
			@LoadShapeID,
			@Month,
			@Year ,
			@Capacity,
			@Transmission,
			@CreatedBy,
			@CreatedBy);
			
	IF @@ROWCOUNT > 0
	BEGIN
		SELECT [ID]
		  ,[FileContextGUID]
		  ,[UtilityCode]
		  ,[LoadShapeID]
		  ,[Month]
		  ,[Year]
		  ,[Capacity]
		  ,[Transmission]
		  ,[DateCreated]
		  ,[CreatedBy]
		  ,[DateModified]
		  ,[ModifiedBy]
		FROM [VRECapacityTransmissionFactor] 
		WHERE ID = SCOPE_IDENTITY();
	END


END

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_CapacityTransmissionFactorInsert';

