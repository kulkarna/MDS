

CREATE PROCEDURE [dbo].[usp_Determinants_FieldValueSelect] 
	@UtilityID varchar( 80 ),
	@AccountNumber varchar( 50 ),
	@FieldName varchar( 60 ),
	@ContextDate datetime = null
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @EffectiveDate datetime	
	DECLARE @accountFieldHistory TABLE( ID bigint, UtilityID varchar(80), AccountNumber varchar(50), FieldName varchar(60), FieldValue varchar( 200 ), EffectiveDate datetime, FieldSource varchar(60), UserIdentity varchar(256), DateCreated datetime, LockStatus varchar(60), Active bit);

	IF @ContextDate IS NULL 
	BEGIN
		SET @EffectiveDate = getdate() 
	END
	ELSE 
	BEGIN
		SET @EffectiveDate = @ContextDate
	END

	INSERT INTO @accountFieldHistory
	SELECT AccountPropertyHistoryID, UtilityID, AccountNumber, FieldName, FieldValue, EffectiveDate, FieldSource, CreatedBy, DateCreated, LockStatus, Active
	FROM AccountPropertyHistory (NOLOCK) WHERE UtilityID = @UtilityID
	AND AccountNumber = @AccountNumber
	AND FieldName = @FieldName
	AND EffectiveDate <= @ContextDate
	AND Active = 1 
	ORDER BY AccountPropertyHistoryID;
	
	IF EXISTS (SELECT * FROM @accountFieldHistory WHERE LockStatus = 'Locked' AND Active = 1)
	BEGIN
		SELECT TOP 1 ID ,
		UtilityID ,
		AccountNumber ,
		FieldName ,
		FieldValue ,
		EffectiveDate ,
		FieldSource ,
		UserIdentity ,
		DateCreated ,
		LockStatus ,
		Active
		FROM @accountFieldHistory
		WHERE LockStatus = 'Locked'
		AND Active = 1
		ORDER BY ID DESC;
	END
	ELSE
	BEGIN
		SELECT TOP 1 ID ,
		UtilityID ,
		AccountNumber ,
		FieldName ,
		FieldValue ,
		EffectiveDate ,
		FieldSource ,
		UserIdentity ,
		DateCreated ,
		LockStatus ,
		Active
		FROM @accountFieldHistory
		WHERE Active = 1
		ORDER BY ID DESC;
	END

	SET NOCOUNT OFF;
END;



