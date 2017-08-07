CREATE PROCEDURE [dbo].[usp_PricingRequestSelectWithServiceAccounts]
    @Id INT = NULL ,
    @PricingRequestId VARCHAR(50) = NULL
AS 

	IF @Id IS NULL AND @PricingRequestId IS NULL
		RETURN

	IF @Id IS NULL 
        SET @Id = (SELECT  ID FROM dbo.OE_PRICING_REQUEST WHERE   REQUEST_ID = @PricingRequestId)
        
    IF @PricingRequestId IS NULL
		SET @PricingRequestId = (SELECT REQUEST_ID FROM dbo.OE_PRICING_REQUEST WHERE ID = @Id)

    SELECT  ID AS Id,
            RequestID AS PricingRequestId,
            ISNULL(CustomerName,'') AS CustomerName,
            ISNULL(OpportunityName,'') AS OpportunityName,
            DueDate ,
            CreationDate ,
            ISNULL(Type, '') AS [Type],
            ISNULL(SalesRepresentative,'') AS SalesRepresentative,
            ISNULL(Status,'') AS [Status],
            TotalNumberOfAccounts , --get actual count of active?
            AnnualEstimatedMWh ,
            ISNULL(Comments,'') AS Comments,
            ISNULL(ChangeReason,'') AS ChangeReason,
            HoldTime ,
            ISNULL(Analyst, '') AS Analyst,
            ISNULL(ApproveComments, '') AS ApproveComments,
            ApproveDate ,
            ISNULL(AccountType, '') AS AccountType,
            ISNULL(RefreshStatus, '') AS RefreshStatus,
            ISNULL(SalesChannel,'') AS SalesChannel,
            1 AS Saved
     FROM    dbo.vw_PricingRequestReturnValueFormat WHERE   ID = @Id
     
     
     SELECT DISTINCT @PricingRequestId AS PricingRequestId ,
            A.ACCOUNT_NUMBER AS AccountNumber ,
            A.MARKET AS Market ,
            A.UTILITY AS Utility ,
            A.NAME_KEY AS NameKey
     FROM   OE_ACCOUNT A
            INNER JOIN dbo.OE_PRICING_REQUEST_ACCOUNTS PRA ON a.ACCOUNT_NUMBER = PRA.ACCOUNT_NUMBER
     WHERE  PRA.PRICING_REQUEST_ID = @PricingRequestId

