USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_ContractInsert]    Script Date: 10/29/2013 16:19:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*
*
* PROCEDURE:	[usp_ContractInsert]
*
* DEFINITION:  Selects record  from Contract
*
* RETURN CODE: 
*
* REVISIONS:	6/21/2011
				8/29/2011	Jaime Forero
				10/29/2013	Satchi Jena   Added Logic for inserting AffinityCode.
*/


ALTER PROCEDURE [dbo].[usp_ContractInsert]
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
	@DigitalSignature varchar(100) = null,
	@ModifiedBy INT,
	@CreatedBy INT, -- This is here for migration purposes only, in reality both modified and created by should be the same when inserting new records
	@IsSilent BIT = 0,
	@EstimatedAnnualUsage int = NULL,
	@AffinityCode varchar(50) = NULL
AS
BEGIN

-- set nocount on and default isolation level
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
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
           ,[DigitalSignature]
           ,[ModifiedBy]
           ,[Modified]
           ,[DateCreated]
		   ,[EstimatedAnnualUsage]
		   ,[AffinityCode]
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
			@DigitalSignature,
			@ModifiedBy,
			GETDATE(),
			GETDATE(),
			ISNULL(@EstimatedAnnualUsage, 0),
			@AffinityCode
			)
	

	SET @ContractID = SCOPE_IDENTITY();	

	IF @IsSilent = 0
	begin
		EXEC LibertyPower.dbo.usp_ContractSelect @ContractID;
	end
	
	RETURN @ContractID;

SET NOCOUNT OFF 
	
END	
