CREATE PROCEDURE [dbo].[usp_PricingRequestGraphGet]
    @Id INT = NULL ,
    @PricingRequestId VARCHAR(50) = NULL
AS 

	IF @Id IS NULL AND @PricingRequestId IS NULL
		RETURN

	IF @Id IS NULL 
        SET @Id = (SELECT  ID FROM dbo.OE_PRICING_REQUEST WHERE   REQUEST_ID = @PricingRequestId)
        
    IF @PricingRequestId IS NULL
		SET @PricingRequestId = (SELECT REQUEST_ID FROM dbo.OE_PRICING_REQUEST WHERE ID = @Id)

    SELECT  ( SELECT DISTINCT
                        @PricingRequestId AS PricingRequestId ,
                        A.ACCOUNT_NUMBER AS AccountNumber ,
                        A.MARKET AS Market ,
                        A.UTILITY AS Utility ,
                        A.NAME_KEY AS NameKey
              FROM      OE_ACCOUNT A
                        INNER JOIN dbo.OE_PRICING_REQUEST_ACCOUNTS PRA ON a.ACCOUNT_NUMBER = PRA.ACCOUNT_NUMBER
              WHERE     PRA.PRICING_REQUEST_ID = @PricingRequestId AND PRA.IS_ACTIVE = 1
            FOR
              XML PATH('ServiceAccountInfo') ,
                  TYPE
            ) ServiceAccounts ,
            AccountType ,
            Analyst ,
            AnnualEstimatedMWh ,
            ApproveComments ,
            ApproveDate ,
            ChangeReason ,
            Comments ,
            CreationDate ,
            CustomerName ,
            DueDate ,
            HoldTime ,
            Id ,
            OpportunityName ,
            RefreshStatus ,
            RequestID AS RequestId ,
            SalesRepresentative ,
            1 AS Saved ,
            Status ,
            TotalNumberOfAccounts ,
            Type ,
            SalesChannel
    FROM    dbo.vw_PricingRequestReturnValueFormat
    WHERE   ID = @Id
    FOR     XML PATH('PricingRequest')

