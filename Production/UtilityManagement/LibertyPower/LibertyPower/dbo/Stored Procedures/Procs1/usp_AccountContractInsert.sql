

/*
*
* PROCEDURE:	[[usp_AccountContractInsert]]
*
* DEFINITION:  Inserts a record into AccountContract Table
*
* RETURN CODE: 
*
* REVISIONS:	9/2/2011 Jaime Forero
*/

CREATE PROCEDURE [dbo].[usp_AccountContractInsert]
	@AccountID	INT,
	@ContractID	INT,
	@RequestedStartDate DATETIME = null,
	@SendEnrollmentDate DATETIME = null,
	@ModifiedBy INT,
	@IsSilent BIT = 0
AS
BEGIN
-- set nocount on and default isolation level
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET FMTONLY OFF
SET NO_BROWSETABLE OFF

	DECLARE @AccountContractID INT;
	
	INSERT INTO [LibertyPower].[dbo].[AccountContract]
           ([AccountID]
           ,[ContractID]
           ,[RequestedStartDate]
           ,[SendEnrollmentDate]
           ,[Modified]
           ,[ModifiedBy]
           ,[DateCreated]
           ,[CreatedBy])
     VALUES
           (
            @AccountID,
            @ContractID, 
            @RequestedStartDate,
            @SendEnrollmentDate,
            GETDATE(),
            @ModifiedBy,
            GETDATE(),
            @ModifiedBy
            )
	;
	SET @AccountContractID  = SCOPE_IDENTITY();
	
	IF @IsSilent = 0
		EXEC LibertyPower.dbo.usp_AccountContractSelect @AccountContractID  ;
	
	DECLARE @pIsIT043InUse BIT
	SELECT @pIsIT043InUse = LibertyPower.dbo.ufn_GetApplicationFeatureSetting ('IT043','EnrollmentApp')

	IF(@pIsIT043InUse = 1)
	BEGIN
		/* BEGIN THE LOGIC TO START THE CORRESPONDING WORKFLOW FOR THIS ACCOUNT */
		
		Declare @HasWorkflow as int
		Declare @ContractNumber as varchar(20)
		Declare @Username as nvarchar(50)
		
		SET @HasWorkflow = 0
		
		SELECT	@ContractNumber = number 
		FROM	libertypower..[contract] (nolock) 
		WHERE	Contractid = @ContractID
		
		SELECT	@HasWorkflow = count(*)
		FROM	Libertypower.dbo.WipTaskHeader (nolock)
		WHERE	contractid = @ContractID
		
		SELECT	@Username = Username
		FROM	Libertypower.dbo.[User] (nolock)
		WHERE	UserId = @ModifiedBy
		
		-- CHECK IF THE CONTRACT ALREADY HAS A WORKFLOW ASSIGNED
		IF @HasWorkFlow <= 0 
		BEGIN
			-- START THE WIP INSERT
			EXEC [usp_WorkflowStartItem] @ContractNumber,@Username
			
			-- TO DO  HANDLE HERE THE ACCOUNT STATUS LOGIC	
			/* LOGIC START */
			
			/* LOGIC END */
		END
	END
	
	RETURN @AccountContractID ;
END
