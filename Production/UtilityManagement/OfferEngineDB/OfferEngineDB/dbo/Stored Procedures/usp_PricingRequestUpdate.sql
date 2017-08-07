CREATE PROCEDURE [dbo].[usp_PricingRequestUpdate]
    @Id INT = NULL ,
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
    @Comments VARCHAR(4000),
    @HoldTime DATETIME,
    @AccountType VARCHAR(50),
    @Analyst NVARCHAR(100) = NULL,
    @ApproveComments NVARCHAR(200) = NULL ,
    @ApproveDate DATETIME = NULL,
    @SalesChannel VARCHAR(100) = NULL,
    @RefreshStatus VARCHAR(100) = NULL,
    @ChangeReason VARCHAR(250) = NULL
AS 
    BEGIN
        SET NOCOUNT ON ;

        IF @Id IS NULL 
            SET @Id = ( SELECT  ID
                        FROM    dbo.OE_PRICING_REQUEST
                        WHERE   REQUEST_ID = @PricingRequestId
                      )

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
                ANALYST = @Analyst ,
                APPROVE_COMMENTS = @ApproveComments ,
                APPROVE_DATE = @ApproveDate ,
                ACCOUNT_TYPE = @AccountType ,
                REFRESH_STATUS = @RefreshStatus ,
                SALES_CHANNEL = @SalesChannel
        WHERE   id = @Id

        SELECT  * FROM    dbo.vw_PricingRequestReturnValueFormat WHERE   ID = @Id
        
        SET NOCOUNT OFF ;
    END                                                                                                                                              

