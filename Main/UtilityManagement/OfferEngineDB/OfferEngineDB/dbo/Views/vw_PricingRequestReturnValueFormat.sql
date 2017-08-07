

CREATE VIEW [dbo].[vw_PricingRequestReturnValueFormat]
AS
SELECT  ID ,
        REQUEST_ID AS RequestID ,
        CUSTOMER_NAME AS CustomerName ,
        OPPORTUNITY_NAME AS OpportunityName ,
        DUE_DATE AS DueDate ,
        CREATION_DATE AS CreationDate ,
        TYPE AS Type ,
        SALES_REPRESENTATIVE AS SalesRepresentative ,
        STATUS AS Status ,
        TOTAL_NUMBER_OF_ACCOUNTS AS TotalNumberOfAccounts ,
        ANNUAL_ESTIMATED_MHW AS AnnualEstimatedMWh ,
        COMMENTS AS Comments ,
        CHANGE_REASON AS ChangeReason ,
        HOLD_TIME AS HoldTime ,
        ANALYST AS Analyst ,
        APPROVE_COMMENTS AS ApproveComments ,
        APPROVE_DATE AS ApproveDate ,
        ACCOUNT_TYPE AS AccountType ,
        REFRESH_STATUS AS RefreshStatus ,
        SALES_CHANNEL AS SalesChannel
FROM    dbo.OE_PRICING_REQUEST

