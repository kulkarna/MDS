USE DataSync
GO 

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
 * usp_MtMPRCustomerInfoSelect
 * Get customer data associated with a pricing request.
 *
 * History
 *******************************************************************************
 * 12/9/2013 Gail Mangaroo
 * Created.
 *******************************************************************************
 */
 
CREATE PROCEDURE usp_MtMPRCustomerInfoSelect
(@PricingRequest varchar(50)) 
AS 
BEGIN

	SET NOCOUNT ON;

	SELECT 
        pr.lpc_PriceRequestNumber as requestId,
        Contact.firstname,
        Contact.lastname,
        Contact.Address1_Telephone1 as phone,  
        Contact.emailaddress1 as Email, 
        Contact.jobtitle as Title,  
        ac.Address1_Line1 as Street,  
        ac.Address1_City as City,
        ac.Address1_StateOrProvince as [State],
        ac.Address1_PostalCode as Zip   ,
        ac.lpc_legalname as customerName

    FROM [LibertyCrm_MSCRM].[dbo].[lpc_pricerequest] pr (NOLOCK)
    
	LEFT JOIN [LibertyCrm_MSCRM].[dbo].[Account] ac (NOLOCK) 
                    ON  pr.lpc_customerlegalname = ac.AccountId

    LEFT JOIN [LibertyCrm_MSCRM].dbo.Contact Contact (NOLOCK)
                    ON ac.PrimaryContactID = Contact.ContactId

    WHERE pr.lpc_PriceRequestNumber = @PricingRequest    
    
	SET NOCOUNT OFF;

END 
-- Copyright 12/9/2013 Liberty Power
GO
