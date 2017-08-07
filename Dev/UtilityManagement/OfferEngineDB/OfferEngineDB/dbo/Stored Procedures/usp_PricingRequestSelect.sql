CREATE PROCEDURE [dbo].[usp_PricingRequestSelect]
    @Id INT = NULL ,
    @PricingRequestId VARCHAR(50) = NULL
AS 
    IF @Id IS NULL 
        SET @Id = (SELECT  ID FROM dbo.OE_PRICING_REQUEST WHERE   REQUEST_ID = @PricingRequestId)

    SELECT  * FROM    dbo.vw_PricingRequestReturnValueFormat WHERE   ID = @Id

