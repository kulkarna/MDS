CREATE PROCEDURE [dbo].[usp_PricingRequestGraphSave]
@p_xml AS XML,
@p_use_int_tran bit = 1

AS
SET NOCOUNT ON;

DECLARE @PricingRequest TABLE(
	[Count] [int] IDENTITY(1,1) NOT NULL,
	PricingRequestId [nvarchar](50) NOT NULL,
	CustomerName [nvarchar](50) NULL,
	OpportunityName [nvarchar](50) NULL,
	DueDate [datetime] NULL,
	CreationDate [datetime] NULL,
	[Type] [nvarchar](50) NULL,
	SalesRepresentative [nvarchar](150) NULL,
	[Status] [nvarchar](50) NULL,
	TotalNumberOfAccounts [numeric](18, 0) NULL,
	AnnualEstimatedMWh [numeric](18, 0) NULL,
	Comments [nvarchar](4000) NULL,
	ChangeReason [nvarchar](250) NULL,
	HoldTime [datetime] NULL,
	Analyst [nvarchar](100) NULL,
	ApproveComments [nvarchar](250) NULL,
	ApproveDate [datetime] NULL,
	AccountType [nvarchar](50) NOT NULL,
	RefreshStatus [varchar](100) NOT NULL,
	SalesChannel [varchar](100) NULL,
	ExistingId int
);
INSERT INTO @PricingRequest ( 
	PricingRequestId ,
	CustomerName ,
	OpportunityName ,
	DueDate ,
	CreationDate ,
	[Type] ,
	SalesRepresentative ,
	[Status] ,
	TotalNumberOfAccounts ,
	AnnualEstimatedMWh ,
	Comments ,
	ChangeReason ,
	HoldTime ,
	Analyst ,
	ApproveComments ,
	ApproveDate ,
	AccountType ,
	RefreshStatus,
	SalesChannel,
	ExistingId
)
SELECT 
		 M.Item.query('./RequestId').value('.','NVARCHAR(50)') PricingRequestId
		,M.Item.query('./CustomerName').value('.','NVARCHAR(50)') CustomerName
		,M.Item.query('./OpportunityName').value('.','NVARCHAR(50)') OpportunityName
		,M.Item.query('./DueDate').value('.','datetime') DueDate
		,M.Item.query('./CreationDate').value('.','datetime') CreationDate
		,M.Item.query('./Type').value('.','NVARCHAR(50)') [Type]
		,M.Item.query('./SalesRepresentative').value('.','NVARCHAR(150)') SalesRepresentative
		,M.Item.query('./Status').value('.','NVARCHAR(50)') Status
		,M.Item.query('./TotalNumberOfAccounts').value('.','numeric(18,0)') TotalNumberOfAccounts
		,M.Item.query('./AnnualEstimatedMWh').value('.','numeric(18,0)') AnnualEstimatedMWh
		,M.Item.query('./Comments').value('.','NVARCHAR(4000)') Comments
		,M.Item.query('./ChangeReason').value('.','NVARCHAR(250)') ChangeReason
		,M.Item.query('./HoldTime').value('.','datetime') HoldTime
		,M.Item.query('./Analyst').value('.','NVARCHAR(100)') Analyst
		,M.Item.query('./ApproveComments').value('.','NVARCHAR(250)') ApproveComments
		,M.Item.query('./ApproveDate').value('.','datetime') ApproveDate
		,M.Item.query('./AccountType').value('.','NVARCHAR(50)') AccountType
		,M.Item.query('./RefreshStatus').value('.','NVARCHAR(100)') RefreshStatus
		,M.Item.query('./SalesChannel').value('.','NVARCHAR(100)') SalesChannel
		,M.Item.query('./Id').value('.','VARCHAR(250)') Id
FROM @p_xml.nodes('/PricingRequest') AS M(Item);

DECLARE @ServiceAccount TABLE(
	[Count] [int] IDENTITY(1,1) NOT NULL,
	AccountNumber [varchar](50) NULL,
	Market [varchar](25) NULL,
	Utility [varchar](50) NULL,
	NameKey [varchar](50) NULL
);
INSERT INTO @ServiceAccount (
	AccountNumber,
	Market,
	Utility,
	NameKey
)
SELECT   
        M.Item.query('./AccountNumber').value('.','VARCHAR(50)') AccountNumber
        ,M.Item.query('./Market').value('.','VARCHAR(25)') Market
        ,M.Item.query('./Utility').value('.','VARCHAR(50)') Utility
        ,M.Item.query('./NameKey').value('.','VARCHAR(50)') NameKey
FROM @p_xml.nodes('/PricingRequest/ServiceAccounts/ServiceAccountInfo') AS M(Item);


DECLARE
    @PricingRequestId VARCHAR(50),
    @CustomerName VARCHAR(50),
    @OpportunityName VARCHAR(50),
    @DueDate DATETIME,
    @CreatedDate DATETIME,
    @Type VARCHAR(50),
    @SalesRep VARCHAR(150),
    @Status VARCHAR(50),
    @TotalAccounts INT,
    @AnnualEstimatedMwh INT,
    @Comments VARCHAR(4000) ,
    @HoldTime DATETIME ,
    @AccountType VARCHAR(50) ,
    @Analyst NVARCHAR(100) = NULL ,
    @ApproveComments NVARCHAR(200) = NULL ,
    @ApproveDate DATETIME = NULL ,
    @SalesChannel VARCHAR(100) = NULL ,
    @RefreshStatus VARCHAR(100) = NULL ,
    @ChangeReason VARCHAR(250) = NULL;

SELECT TOP 1
    @PricingRequestId = PricingRequestId,
    @CustomerName = CustomerName,
    @OpportunityName = OpportunityName,
    @DueDate = DueDate,
    @CreatedDate = CreationDate,
    @Type = [Type],
    @SalesRep = SalesRepresentative,
    @Status = [Status],
    @TotalAccounts = (SELECT Count(*) FROM @ServiceAccount),
    @AnnualEstimatedMwh = AnnualEstimatedMWh,
    @Comments = Comments,
    @HoldTime =  HoldTime,
    @AccountType = AccountType,
    @Analyst =  Analyst,
    @ApproveComments  =  ApproveComments,
    @ApproveDate  =  ApproveDate,
    @SalesChannel  =  SalesChannel,
    @RefreshStatus  =  RefreshStatus,
    @ChangeReason  = ChangeReason
FROM @PricingRequest

DECLARE
    @account_number VARCHAR(50) ,
    @retail_mkt_id VARCHAR(25) ,
    @utility_id VARCHAR(50) ,
    @name_key VARCHAR(50) ,
    @p_icap DECIMAL(18, 9) = 0 ,
    @p_tcap DECIMAL(18, 9) = 0 ,
    @p_losses DECIMAL(18, 9) = NULL,
    @SaCount INT = (SELECT MAX([Count]) FROM @ServiceAccount),
	@Row INT = 1;

BEGIN TRY
	IF @p_use_int_tran = 1 BEGIN TRAN
		--pricing request
		IF NOT EXISTS (SELECT 1 FROM dbo.OE_PRICING_REQUEST WHERE REQUEST_ID = @PricingRequestId) BEGIN
		 INSERT INTO OE_PRICING_REQUEST
				( REQUEST_ID ,
				  CUSTOMER_NAME ,
				  OPPORTUNITY_NAME ,
				  DUE_DATE ,
				  CREATION_DATE ,
				  [TYPE] ,
				  SALES_REPRESENTATIVE ,
				  [STATUS] ,
				  TOTAL_NUMBER_OF_ACCOUNTS ,
				  ANNUAL_ESTIMATED_MHW ,
				  COMMENTS ,
				  CHANGE_REASON ,
				  HOLD_TIME ,
				  ANALYST ,
				  APPROVE_COMMENTS ,
				  APPROVE_DATE ,
				  ACCOUNT_TYPE ,
				  REFRESH_STATUS,
				  SALES_CHANNEL
				)
		 VALUES ( @PricingRequestId ,
				  @CustomerName ,
				  @OpportunityName ,
				  @DueDate ,
				  @CreatedDate ,
				  @Type ,
				  @SalesRep ,
				  @Status ,
				  @TotalAccounts ,
				  @AnnualEstimatedMwh ,
				  @Comments ,
				  @ChangeReason ,
				  @HoldTime ,
				  ISNULL(@Analyst, '0'),
				  @ApproveComments, 
				  @ApproveDate,
				  @AccountType,
				  ISNULL(@RefreshStatus,'New'),
				  @SalesChannel
				)
		END ELSE BEGIN
		        UPDATE  dbo.OE_PRICING_REQUEST
				SET     REQUEST_ID = @PricingRequestId ,
						CUSTOMER_NAME = @CustomerName ,
						OPPORTUNITY_NAME = @OpportunityName ,
						DUE_DATE = @DueDate ,
						CREATION_DATE = @CreatedDate ,
						[TYPE] = @Type ,
						SALES_REPRESENTATIVE = @SalesRep ,
						[STATUS] = @Status ,
						TOTAL_NUMBER_OF_ACCOUNTS = @TotalAccounts ,
						ANNUAL_ESTIMATED_MHW = @AnnualEstimatedMwh ,
						COMMENTS = @Comments ,
						CHANGE_REASON = @ChangeReason ,
						HOLD_TIME = @HoldTime ,
						ANALYST = ISNULL(@Analyst, '0') ,
						APPROVE_COMMENTS = @ApproveComments ,
						APPROVE_DATE = @ApproveDate ,
						ACCOUNT_TYPE = @AccountType ,
						REFRESH_STATUS = @RefreshStatus ,
						SALES_CHANNEL = @SalesChannel
				WHERE   REQUEST_ID = @PricingRequestId
		END
				
		--deactivate service accounts belonging to the pricing request that are not present in current list of accounts
		IF (@PricingRequestId IS NOT NULL) BEGIN
			UPDATE  dbo.OE_PRICING_REQUEST_ACCOUNTS
			SET     IS_ACTIVE = 0
			WHERE ACCOUNT_NUMBER NOT IN (SELECT AccountNumber FROM @ServiceAccount)
		END
		
		--service accounts
		WHILE @Row <= @SaCount BEGIN
			SELECT
				@account_number = AccountNumber, 
				@retail_mkt_id = Market, 
				@utility_id = Utility,
				@name_key = NameKey
			FROM 
				@ServiceAccount WHERE [Count] = @Row;
			
			EXEC [dbo].[usp_pricing_request_account_ins] 
				@p_pricing_request_id = @PricingRequestId, 
				@p_account_number = @account_number, 
				@p_retail_mkt_id = @retail_mkt_id, 
				@p_utility_id = @utility_id,
				@p_name_key = @name_key,
				@p_icap = 0,
				@p_tcap = 0,
				@p_losses = 0;
			SET @Row = @Row + 1;
		END
    IF @p_use_int_tran = 1 COMMIT TRAN
END TRY
BEGIN CATCH
	IF @p_use_int_tran = 1 ROLLBACK TRAN
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

