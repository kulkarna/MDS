

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


CREATE PROCEDURE [dbo].[usp_ContractInsert_bak]
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
	@PricingTypeID INT,
	@ModifiedBy INT,
	@CreatedBy INT, -- This is here for migration purposes only, in reality both modified and created by should be the same when inserting new records
	@IsSilent BIT = 0
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
           ,[DateCreated])
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
			GETDATE()
			)
	

	SET @ContractID = SCOPE_IDENTITY();	
	IF @IsSilent = 0
	begin
		PRINT('About to execute LibertyPower.dbo.usp_ContractSelect inside [LibertyPoer].[dbo].[usp_ContractInsert]')
		PRINT('@ContractID => ' + cast(@ContractID as varchar))
		EXEC LibertyPower.dbo.usp_ContractSelect @ContractID;
		PRINT('Finished execute LibertyPower.dbo.usp_ContractSelect inside [LibertyPoer].[dbo].[usp_ContractInsert]')
	end
	
	RETURN @ContractID;
	
END	
