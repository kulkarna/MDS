/*******************************************************************************
 * usp_DailyProfileHeaderInsert
 * Insert daily profile header values
 *
 * History
 *******************************************************************************
 * 1/19/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_DailyProfileHeaderInsert]                                                                                     
	@ISO			varchar(50),
	@UtilityCode	varchar(50),
	@LoadShapeID	varchar(100),
	@Zone			varchar(50),
	@FileName		varchar(200),
	@CreatedBy		varchar(100),
	@DailyProfileId	bigint	OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

	DECLARE	@DateCreated	datetime,
			@Version		int

	SET		@DateCreated	= GETDATE()

	SELECT	@Version = ISNULL((MAX(Version) + 1), 1)
	FROM	DailyProfileHeader
	WHERE	UtilityCode	= @UtilityCode
	AND		LoadShapeID	= @LoadShapeID
	AND		((Zone = @Zone) OR (Zone = 'ALL'))

	INSERT INTO	DailyProfileHeader (ISO, UtilityCode, LoadShapeID, 
				Zone, [FileName], DateCreated, CreatedBy, Version)
	VALUES		(@ISO, @UtilityCode, @LoadShapeID, @Zone, 
				@FileName, @DateCreated, @CreatedBy, @Version)

	SELECT	@DailyProfileId = @@IDENTITY

    SET NOCOUNT OFF;
END                                                                                                                                              
-- Copyright 2009 Liberty Power
