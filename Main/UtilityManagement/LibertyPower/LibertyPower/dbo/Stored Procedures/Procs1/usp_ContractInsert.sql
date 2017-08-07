

/*
*
* PROCEDURE:	[usp_ContractInsert]
*
* DEFINITION:  Selects record  from Contract
*
* RETURN CODE: 
*
* REVISIONS:	6/21/2011
				8/29/2011 Jaime Forero
*/


CREATE PROCEDURE [dbo].[usp_ContractInsert]
	@Number VARCHAR(50),
	@ContractTypeID INT,
	@ContractDealTypeID INT,
	@ContractStatusID INT,
	@ContractTemplateID INT,
	@ReceiptDate DATETIME,
	@StartDate DATETIME,
	@EndDate DATETIME,
	@SignedDate DATETIME,
	@SubmitDate DATETIME,
	@SalesChannelID INT,
	@SalesRep VARCHAR(64),
	@SalesManagerID INT,
	@PricingTypeID INT = NULL,
	@ModifiedBy INT,
	@CreatedBy INT, -- This is here for migration purposes only, in reality both modified and created by should be the same when inserting new records
	@IsSilent BIT = 0,
	@EstimatedAnnualUsage int = NULL
AS
BEGIN

-- set nocount on and default isolation level
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET FMTONLY OFF
	SET NO_BROWSETABLE OFF
	
	DECLARE @ContractID INT;
	-- DATA CLEANUP
	SET @SalesRep	= lp_account.dbo.ufn_strip_special_characters(@SalesRep);	
	
	INSERT INTO [LibertyPower].[dbo].[Contract]
           ([Number]
           ,[ContractTypeID]
           ,[ContractDealTypeID]
           ,[ContractStatusID]
           ,[ContractTemplateID]
           ,[ReceiptDate]
           ,[StartDate]
           ,[EndDate]
           ,[SignedDate]
           ,[SubmitDate]
           ,[CreatedBy]
           ,[SalesChannelID]
           ,[SalesRep]
           ,[SalesManagerID]
           ,[PricingTypeID]
           ,[ModifiedBy]
           ,[Modified]
           ,[DateCreated]
		   ,[EstimatedAnnualUsage]
)
     VALUES
           (@Number,
			@ContractTypeID,
			@ContractDealTypeID,
			@ContractStatusID,
			@ContractTemplateID,
			@ReceiptDate,
			@StartDate,
			@EndDate,
			@SignedDate,
			@SubmitDate,
			@CreatedBy,
			@SalesChannelID,
			@SalesRep,
			@SalesManagerID,
			@PricingTypeID,
			@ModifiedBy,
			GETDATE(),
			GETDATE(),
			ISNULL(@EstimatedAnnualUsage, 0)
			)
	

	SET @ContractID = SCOPE_IDENTITY();	

	IF @IsSilent = 0
	begin
		EXEC LibertyPower.dbo.usp_ContractSelect @ContractID;
	end
	
	RETURN @ContractID;
	
END	
