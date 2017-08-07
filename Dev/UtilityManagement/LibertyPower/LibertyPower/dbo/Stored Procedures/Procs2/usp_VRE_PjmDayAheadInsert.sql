


CREATE PROCEDURE [dbo].[usp_VRE_PjmDayAheadInsert]
	@FileContextGUID uniqueidentifier,
	@Date DATETIME,
	@Name varchar(50),
	@Type varchar(50),
	@Zone varchar(50),
	@H1 decimal(18,4),
	@H2 decimal(18,4),
	@H3 decimal(18,4),
	@H4 decimal(18,4),
	@H5 decimal(18,4),
	@H6 decimal(18,4),
	@H7 decimal(18,4),
	@H8 decimal(18,4),
	@H9 decimal(18,4),
	@H10 decimal(18,4),
	@H11 decimal(18,4),
	@H12 decimal(18,4),
	@H13 decimal(18,4),
	@H14 decimal(18,4),
	@H15 decimal(18,4),
	@H16 decimal(18,4),
	@H17 decimal(18,4),
	@H18 decimal(18,4),
	@H19 decimal(18,4),
	@H20 decimal(18,4),
	@H21 decimal(18,4),
	@H22 decimal(18,4),
	@H23 decimal(18,4),
	@H24 decimal(18,4),
	@CreatedBy int
AS
BEGIN
   INSERT INTO [VREPjmDayAhead]
           (
           [FileContextGUID]
           ,[Date]
           ,[Name]
           ,[Type]
           ,[Zone]
           ,[H1]
           ,[H2]
           ,[H3]
           ,[H4]
           ,[H5]
           ,[H6]
           ,[H7]
           ,[H8]
           ,[H9]
           ,[H10]
           ,[H11]
           ,[H12]
           ,[H13]
           ,[H14]
           ,[H15]
           ,[H16]
           ,[H17]
           ,[H18]
           ,[H19]
           ,[H20]
           ,[H21]
           ,[H22]
           ,[H23]
           ,[H24]
           ,[CreatedBy]
           ,[ModifiedBy]
           )
     VALUES
           (@FileContextGUID,
			@Date,
			@Name,
			@Type,
			@Zone,
			@H1,
			@H2,
			@H3,
			@H4,
			@H5,
			@H6,
			@H7,
			@H8,
			@H9,
			@H10,
			@H11,
			@H12,
			@H13,
			@H14,
			@H15,
			@H16,
			@H17,
			@H18,
			@H19,
			@H20,
			@H21,
			@H22,
			@H23,
			@H24,
			@CreatedBy,
			@CreatedBy);
			
	IF @@ROWCOUNT > 0
	BEGIN
		SELECT [ID]
		  ,[FileContextGUID]
		  ,[Date]
		  ,[Name]
		  ,[Type]
		  ,[Zone]
		  ,[H1]
		  ,[H2]
		  ,[H3]
		  ,[H4]
		  ,[H5]
		  ,[H6]
		  ,[H7]
		  ,[H8]
		  ,[H9]
		  ,[H10]
		  ,[H11]
		  ,[H12]
		  ,[H13]
		  ,[H14]
		  ,[H15]
		  ,[H16]
		  ,[H17]
		  ,[H18]
		  ,[H19]
		  ,[H20]
		  ,[H21]
		  ,[H22]
		  ,[H23]
		  ,[H24]
		  ,[DateCreated]
		  ,[CreatedBy]
		  ,[DateModified]
		  ,[ModifiedBy]
		FROM [VREPjmDayAhead] 
		WHERE ID = SCOPE_IDENTITY();
	END


END



GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'VRE', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_VRE_PjmDayAheadInsert';

