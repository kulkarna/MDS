﻿
/*******************************************************************************
 * LibertyPower.dbo.usp_Determinants_FieldValueInsert
 * Inserts determinant history
 *
 * History
 *******************************************************************************
 * 7/12/2013 - Thiago Nogueira
 * Created.
 *******************************************************************************
 */

CREATE PROCEDURE [dbo].[usp_Determinants_FieldValueInsert]
	
    @UtilityID varchar(80),
    @AccountNumber varchar(50),
    @FieldName varchar(60),
    @FieldValue varchar(200),
    @EffectiveDate datetime,
    @FieldSource varchar(60),
    @UserIdentity varchar(256),
    @LockStatus varchar(30),
    @DateCreated DATETIME = NULL,
    @IsActive BIT = 1,
    @UseInternalTran BIT = 1
AS
SET NOCOUNT ON;
DECLARE @AccountPropertyHistoryID BIGINT;

IF @DateCreated IS NULL
	SET	@DateCreated = GETDATE()

IF @LockStatus NOT IN ('Locked','Unknown','Unlocked')
	SET @LockStatus = 'Unknown'

SET @UtilityID = RTRIM(LTRIM(@UtilityID))
SET @AccountNumber = RTRIM(LTRIM(@AccountNumber))
SET @FieldName = RTRIM(LTRIM(@FieldName))
SET @FieldValue = RTRIM(LTRIM(@FieldValue))
SET @FieldSource = RTRIM(LTRIM(@FieldSource))
SET @UserIdentity = RTRIM(LTRIM(@UserIdentity))
SET @LockStatus = RTRIM(LTRIM(@LockStatus))

BEGIN TRY
--compare with the last entry for the property to avoid duplicates
 IF EXISTS ( SELECT 1
             FROM   dbo.AccountPropertyHistory
             WHERE  AccountPropertyHistoryID = ( SELECT TOP 1
                                                        AccountPropertyHistoryID
                                                 FROM   dbo.AccountPropertyHistory
                                                 WHERE  RTRIM(LTRIM(UtilityID)) = @UtilityID
                                                        AND RTRIM(LTRIM(AccountNumber)) = @AccountNumber
                                                        AND RTRIM(LTRIM(FieldName)) = @FieldName
                                                 ORDER BY AccountPropertyHistoryID DESC
                                               )
                    AND RTRIM(LTRIM(FieldValue)) = @FieldValue
                    AND RTRIM(LTRIM(FieldSource)) = @FieldSource ) 
    BEGIN
        RETURN
    END
                        
	IF @UseInternalTran = 1 BEGIN TRAN

    INSERT  INTO AccountPropertyHistory
            ( UtilityID ,
              AccountNumber ,
              FieldName ,
              FieldValue ,
              EffectiveDate ,
              FieldSource ,
              CreatedBy ,
              DateCreated ,
              LockStatus ,
              Active
            )
    VALUES  ( @UtilityID ,
              @AccountNumber ,
              @FieldName ,
              @FieldValue ,
              @EffectiveDate ,
              @FieldSource ,
              @UserIdentity ,
              @DateCreated ,
              @LockStatus ,
              @IsActive
            )
				
	IF(SCOPE_IDENTITY() IS NOT NULL)
		BEGIN
		   SET	@AccountPropertyHistoryID = SCOPE_IDENTITY()
		   INSERT   INTO AccountPropertyLockHistory
					( AccountPropertyHistoryID ,
					  LockStatus ,
					  CreatedBy ,
					  DateCreated
					)
		   VALUES   ( @AccountPropertyHistoryID ,
					  @LockStatus ,
					  @UserIdentity ,
					  @DateCreated
					)
			
		   SELECT   AccountPropertyHistoryID AS 'ID' ,
					UtilityID ,
					AccountNumber ,
					FieldName ,
					FieldValue ,
					EffectiveDate ,
					FieldSource ,
					CreatedBy AS UserIdentity ,
					DateCreated ,
					LockStatus ,
					Active
		   FROM     AccountPropertyHistory WITH ( NOLOCK )
		   WHERE    AccountPropertyHistoryID = @AccountPropertyHistoryID
		END
	ELSE
		BEGIN
			IF @UseInternalTran = 1 ROLLBACK
		END	

    IF @UseInternalTran = 1 COMMIT TRAN
END TRY
BEGIN CATCH
	IF @UseInternalTran = 1 ROLLBACK TRAN
	DECLARE 
		@ErrorMessage NVARCHAR(4000),
		@ErrorSeverity INT,
		@ErrorState INT;

    SELECT @ErrorMessage = ERROR_MESSAGE(),
           @ErrorSeverity = ERROR_SEVERITY(),
           @ErrorState = ERROR_STATE();
           
    RAISERROR (@ErrorMessage,
               @ErrorSeverity,
               @ErrorState );
END CATCH
SET NOCOUNT OFF;
