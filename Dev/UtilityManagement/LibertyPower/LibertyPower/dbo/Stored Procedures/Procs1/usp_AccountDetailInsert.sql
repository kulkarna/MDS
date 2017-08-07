

/*
*
* PROCEDURE:	[[usp_AccountDetailInsert]]
*
* DEFINITION:  Inserts a record into Account Detail record
*
* RETURN CODE: 
*
* REVISIONS:	8/31/2011 Jaime Forero
*
*/

CREATE PROCEDURE [dbo].[usp_AccountDetailInsert]
	@AccountID INT,
	@EnrollmentTypeID INT,
	@OriginalTaxDesignation INT = NULL,
	@ModifiedBy INT,
	@CreatedBy INT = 0,
	@IsSilent BIT = 0
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF
SET NO_BROWSETABLE OFF
	DECLARE @AccountDetailID INT;
	INSERT INTO [Libertypower].[dbo].[AccountDetail]
           ([AccountID]
           ,[EnrollmentTypeID]
           ,[OriginalTaxDesignation]
           ,[Modified]
           ,[ModifiedBy]
           ,[DateCreated]
           ,[CreatedBy])
     VALUES
           (
            @AccountID,
            @EnrollmentTypeID,
            @OriginalTaxDesignation,
            GETDATE(),
            @ModifiedBy,
            GETDATE(),
            @CreatedBy
            )
    ;
	SET @AccountDetailID  = SCOPE_IDENTITY();
	IF @IsSilent = 0
		EXEC LibertyPower.dbo.usp_AccountDetailSelect @AccountDetailID, NULL  ;
	
	RETURN @AccountDetailID;
END
