




CREATE FUNCTION [dbo].[GetDeterminantValue]
(
	@UtilityID varchar(80),
	@AccountNumber varchar(30),
	@FieldName varchar(60),
     @ContextDate datetime = null
)

Returns varchar(60)

AS

BEGIN
			
    DECLARE @DeterminantValue varchar(200)
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
	FROM AccountPropertyHistory WITH (NOLOCK INDEX = IDX_AccountPropertyHistoryTemp02) 
	WHERE UtilityID = @UtilityID
	AND AccountNumber	= @AccountNumber
	AND Active			= 1 
	AND FieldName		= @FieldName
	AND EffectiveDate	<= @ContextDate
	ORDER BY AccountPropertyHistoryID;
	
	IF EXISTS (SELECT * FROM @accountFieldHistory WHERE LockStatus = 'Locked' AND Active = 1)
	BEGIN
		SELECT TOP 1 @DeterminantValue = FieldValue
		FROM @accountFieldHistory
		WHERE LockStatus = 'Locked'
		AND Active = 1
		AND RTRIM(LTRIM(FieldValue)) <> '-1'
		AND RTRIM(LTRIM(FieldValue)) <> ''
		ORDER BY ID DESC;
	END
	ELSE
	BEGIN
		SELECT TOP 1 @DeterminantValue = FieldValue
		FROM @accountFieldHistory
		WHERE Active = 1
		AND RTRIM(LTRIM(FieldValue)) <> '-1'
		AND RTRIM(LTRIM(FieldValue)) <> ''
		ORDER BY ID DESC;
	END
	
RETURN @DeterminantValue

END



