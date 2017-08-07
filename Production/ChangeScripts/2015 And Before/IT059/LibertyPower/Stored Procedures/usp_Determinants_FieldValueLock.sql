USE [Libertypower]
GO

/****** Object:  StoredProcedure [dbo].[usp_Determinants_FieldValueLock]    Script Date: 07/13/2013 11:47:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_Determinants_FieldValueLock]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_Determinants_FieldValueLock]
GO

USE [Libertypower]
GO

/****** Object:  StoredProcedure [dbo].[usp_Determinants_FieldValueLock]    Script Date: 07/13/2013 11:47:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_Determinants_FieldValueLock]  
	@UtilityID varchar( 80 ),
	@AccountNumber varchar( 50 ),
	@FieldName varchar( 60 ),
	@FieldSource varchar(60),
	@UserIdentity varchar(256),
	@lock bit                                                   
AS
BEGIN   
	SET NOCOUNT ON;

	DECLARE @AccountPropertyHistoryID	bigint,
			@LockStatus					varchar(60),
			@Now						datetime
	
	DECLARE @accountFieldHistory TABLE( ID bigint, UtilityID varchar(80), AccountNumber varchar(50), FieldName varchar(60), FieldValue varchar( 200 ), EffectiveDate datetime, FieldSource varchar(60), UserIdentity varchar(256), DateCreated datetime, LockStatus varchar(60), Active bit);
	
	INSERT INTO @accountFieldHistory
	SELECT AccountPropertyHistoryID, UtilityID, AccountNumber, FieldName, FieldValue, CAST(EffectiveDate AS Date), FieldSource, CreatedBy, DateCreated, LockStatus, Active
	FROM AccountPropertyHistory (NOLOCK) 
	WHERE UtilityID = @UtilityID
	AND AccountNumber = @AccountNumber
	AND FieldName = @FieldName
	ORDER BY AccountPropertyHistoryID;
	
	SET	@Now = GETDATE()
	SET	@LockStatus = CASE WHEN @lock = 0 THEN 'Unlocked' ELSE 'Locked' END

	IF (@lock = 0)
	BEGIN
		SELECT @AccountPropertyHistoryID = ID
		FROM @accountFieldHistory
		WHERE LockStatus = 'Locked'
	END
	ELSE 
	BEGIN
		IF NOT EXISTS (SELECT *
					   FROM @accountFieldHistory
					   WHERE LockStatus = 'Locked')
		BEGIN
			SELECT TOP 1 @AccountPropertyHistoryID = ID
			FROM @accountFieldHistory
			ORDER BY DateCreated DESC
		END		
    END
	
	IF(@AccountPropertyHistoryID IS NOT NULL)
	BEGIN		
		UPDATE AccountPropertyHistory
		SET LockStatus = @LockStatus
		WHERE AccountPropertyHistoryID = @AccountPropertyHistoryID
		
		INSERT INTO AccountPropertyLockHistory (AccountPropertyHistoryID, LockStatus, CreatedBy, DateCreated)
		VALUES		(@AccountPropertyHistoryID, @LockStatus, @UserIdentity, @Now)		
		
		SELECT	AccountPropertyHistoryID AS ID, UtilityID, AccountNumber, FieldName, FieldValue,
				CAST(EffectiveDate AS Date) As EffectiveDate, FieldSource, CreatedBy AS UserIdentity, DateCreated, LockStatus, Active
		FROM	AccountPropertyHistory WITH (NOLOCK)
		WHERE	AccountPropertyHistoryID = @AccountPropertyHistoryID
	 END

	 SET NOCOUNT OFF;
END


GO


