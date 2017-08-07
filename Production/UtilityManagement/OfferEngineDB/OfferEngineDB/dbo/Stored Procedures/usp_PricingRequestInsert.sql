/*******************************************************************************
 * usp_PricingRequestInsert
 * Insert pricing request resord
 *
 * History
 *******************************************************************************
 * 3/27/2009 - Rick Deigsler
 * Created.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_PricingRequestInsert]
    @PricingRequestId VARCHAR(50) ,
    @CustomerName VARCHAR(50) ,
    @OpportunityName VARCHAR(50) ,
    @DueDate DATETIME ,
    @CreatedDate DATETIME ,
    @Type VARCHAR(50) ,
    @SalesRep VARCHAR(150) ,
    @Status VARCHAR(50) ,
    @TotalAccounts INT ,
    @AnnualEstimatedMwh INT ,
    @Comments VARCHAR(4000) ,
    @HoldTime DATETIME ,
    @AccountType VARCHAR(50) ,
    @Analyst NVARCHAR(100) = NULL ,
    @ApproveComments NVARCHAR(200) = NULL ,
    @ApproveDate DATETIME = NULL ,
    @SalesChannel VARCHAR(100) = NULL ,
    @RefreshStatus VARCHAR(100) = NULL ,
    @ChangeReason VARCHAR(250) = NULL
AS
BEGIN
    SET NOCOUNT ON;

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

	SELECT * FROM dbo.vw_PricingRequestReturnValueFormat AS v WHERE v.RequestID = @PricingRequestId
SET NOCOUNT OFF;
END                                                                                                                                              

