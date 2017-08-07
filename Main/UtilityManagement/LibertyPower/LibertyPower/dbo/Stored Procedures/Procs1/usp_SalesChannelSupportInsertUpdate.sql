-- =============================================
-- Author:		Jaime Forero
-- Create date: 4/7/2011
-- Description:	Inserts/Updates a Sales Channel Support record
-- =============================================
CREATE PROCEDURE [dbo].[usp_SalesChannelSupportInsertUpdate]
	-- Add the parameters for the stored procedure here
	@SalesChannelSupportID	INT = NULL,
	@ChannelID				INT = NULL,
	@SupportUserID			INT = NULL,
	@ManagerUserID			INT = NULL,
	@SendEmail				BIT = NULL,
	@ExpirationDate			DATETIME = NULL,
	@DateModified			DATETIME = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	IF @DateModified IS NULL
	BEGIN
		SET @DateModified = GETDATE();
	END
	
	IF	@SalesChannelSupportID IS NULL 
	BEGIN
		-- We intent to insert a record
		INSERT INTO LibertyPower.dbo.SalesChannelSupport 
		(	ChannelID,
			ManagerUserID,
			SupportUserID,
			SendEmail,
			ExpirationDate,
			DateModified,
			DateCreated
		)
		VALUES
		(	@ChannelID,
			@ManagerUserID,
			@SupportUserID,
			@SendEmail,
			@ExpirationDate,
			@DateModified,
			GETDATE()
		)
		
		SET @SalesChannelSupportID = SCOPE_IDENTITY();
	END
	ELSE
	BEGIN
	
		UPDATE	LibertyPower.dbo.SalesChannelSupport
		SET	
			ChannelID		= @ChannelID, -- should be able to set to null
			SupportUserID	= ISNULL(@SupportUserID, SupportUserID),
			ManagerUserID	= ISNULL(@ManagerUserID, ManagerUserID),
			SendEmail		= ISNULL(@SendEmail, SendEmail),
			ExpirationDate  = @ExpirationDate,
			DateModified	= @DateModified
		WHERE
			LibertyPower.dbo.SalesChannelSupport.SalesChannelSupportID	= @SalesChannelSupportID
		;
		
	END
    
	SELECT	SCS.SalesChannelSupportID,
			SCS.ChannelID,
			SCS.ManagerUserID,
			SCS.SupportUserID,
			SCS.SendEmail,
			SCS.ExpirationDate,
			SCS.DateModified,
			SCS.DateCreated
	FROM	LibertyPower.dbo.SalesChannelSupport SCS (NOLOCK)
	WHERE	SCS.SalesChannelSupportID = @SalesChannelSupportID
	;
END

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'SalesChannel', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_SalesChannelSupportInsertUpdate';

