USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_AccountStatusInsert]    Script Date: 09/20/2012 14:54:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*
*
* PROCEDURE:	usp_AccountStatus_I
*
* DEFINITION:  Inserts a record into AccountStatus
*
* RETURN CODE: 
*
* REVISIONS:	6/9/2011 11:58:55 AM	Angel Nieves	New
*/


ALTER PROCEDURE [dbo].[usp_AccountStatusInsert]
	@AccountContractID  INT,
	@Status		VARCHAR(15),
	@SubStatus	VARCHAR(15),
	@CreatedBy	INT,
	@ModifiedBy	INT,
	@IsSilent BIT = 0
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF
SET NO_BROWSETABLE OFF

	DECLARE @pIsIT043InUse BIT
	SELECT @pIsIT043InUse = LibertyPower.dbo.ufn_GetApplicationFeatureSetting ('IT043','EnrollmentApp')
	
	IF(@pIsIT043InUse = 1)
	BEGIN
		SET @Status = '01000'
		SET @SubStatus = '10'
	END
	
	DECLARE @AccountStatusID INT;
	
	INSERT INTO [dbo].[AccountStatus]
	(	[AccountContractID],
		[Status],
		[SubStatus],
		[Modified],
		[ModifiedBy],
		[DateCreated],
		[CreatedBy]
	)
	VALUES
	(   
		@AccountContractID,
		@Status,
		@SubStatus,
		GETDATE(),
		@ModifiedBy,
		GETDATE(),
		@CreatedBy
	)

	SET @AccountStatusID = SCOPE_IDENTITY();
	IF @IsSilent = 0
		EXEC LibertyPower.dbo.usp_AccountStatusSelect @AccountStatusID ;
		
	RETURN @AccountStatusID ;
END
