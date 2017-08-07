-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
-- EXEC DEV_SalesChannelMassUpdate @SalesChannel = 'CASA', @UserEmail ='jforero@libertypowercorp.com'

CREATE PROCEDURE [dbo].[DEV_SalesChannelMassUpdate]
	@SalesChannel varchar(50),
	@UserEmail	varchar(512)
AS
BEGIN
	--- Bogus Comment
	DECLARE @A AS NVARCHAR(1000)
	SET @A='BogusValue'
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @SalesChannelSupportID	INT ;
	DECLARE @ChannelID				INT;
	DECLARE @UserID					INT;
	DECLARE @CustomName				VARCHAR(64);
	DECLARE @CustomEmail			VARCHAR(64);
	DECLARE @SendEmail				BIT;
	DECLARE @DateModified			DATETIME;
	
	
	SET @SalesChannelSupportID = NULL; -- always null since we're inserting
	SET @CustomName = NULL;
	SET @CustomEmail = NULL;
	SET @UserID = NULL;
	
	
	
	SET @DateModified = GETDATE();
	SET @SendEmail = 1; -- always send email
	
	
	-- select user first if exists
	SET @UserEmail = RTRIM(LTRIM(@UserEmail));
	SET @SalesChannel = RTRIM(LTRIM(@SalesChannel));
	
	IF EXISTS(SELECT top(1) * FROM LibertyPower..[User] WHERE LibertyPower..[User].Email = @UserEmail)
	BEGIN
		SELECT @UserID = UserID FROM LibertyPower..[User] WHERE LibertyPower..[User].Email = @UserEmail;
	END
	ELSE
	BEGIN
		PRINT 'Could not find match for user with email :' + @UserEmail + ' record will be added as custom email ';
		SET @CustomName		= 'Support ' + @SalesChannel;
		SET @CustomEmail	= @UserEmail;
	END
	
	IF EXISTS(SELECT top(1) * FROM LibertyPower..SalesChannel WHERE LibertyPower..SalesChannel.ChannelName = @SalesChannel)
	BEGIN
	
		SELECT @ChannelID = ChannelID FROM LibertyPower..SalesChannel WHERE LibertyPower..SalesChannel.ChannelName = @SalesChannel;
		
		
		EXEC [dbo].[usp_SalesChannelSupportInsertUpdate] 
		@SalesChannelSupportID,
		@ChannelID				,
		@UserID					,
		@CustomName				,
		@CustomEmail			,
		@SendEmail				,
		@DateModified			
		;
		
		IF @UserID IS NOT NULL 
		BEGIN
			-- update with userid
			PRINT 'Successful update for user: ' + @UserEmail + ' Sales channel: ' + @SalesChannel;
		END
		ELSE
		BEGIN
			-- update without userid
			PRINT 'Successful update for user: ' + @CustomName + ' Sales channel: ' + @CustomEmail;
		END
	
	END
	ELSE
	BEGIN
		PRINT ' ********************** ERROR Could not find match for sales channel:' + @SalesChannel + ' could not add the record. *************************';
	END
	
END
