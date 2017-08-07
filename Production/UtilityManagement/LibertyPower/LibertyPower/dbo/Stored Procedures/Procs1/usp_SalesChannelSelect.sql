

/****** usp_SalesChannelSelect *******************************************************************************/
/**************************************************************************************
* 3/05/2012 Eric Hernandez
* Created new proc to consolidate other SalesChannel retrieval procs.
**************************************************************************************/
CREATE PROCEDURE [dbo].[usp_SalesChannelSelect] 
(
	@ChannelID INT = NULL,
	@ChannelName VARCHAR(100) = NULL
)      
AS      
BEGIN     

	SELECT     
		SC.ChannelID         
		,SC.ChannelName 
		,SC.ChannelDescription        
		,SC.DateCreated         
		,SC.DateModified        
		,SC.CreatedBy         
		,SC.ModifiedBy   
		,SC.ChannelDevelopmentManagerID     
		,SC.HasManagedUsers    
		,SC.Inactive
		,E.EntityID          
		,EO.DunsNumber        
		,EO.CustomerName          
		,EO.TaxID         
		,E.Tag      
		,E.StartDate  
		,SCCG.ChannelGroupId
		,ChannelTypeID = ct.ID
		,SC.ContactFirstName
		,SC.ContactLastName
		,SC.ContactAddress1
		,SC.ContactAddress2
		,SC.ContactCity
		,SC.ContactState
		,SC.ContactZip
		,SC.ContactEmail
		,SC.ContactPhone
		,SC.ContactFax
		 
		,SC.RenewalGracePeriod
		,SC.AllowRetentionSave
		,SC.AlwaysTransfer
		,SC.AllowRenewalOnDefault
		 
		,SC.AllowInfoOnWelcomeLetter
		,SC.AllowInfoOnRenewalLetter
		,SC.AllowInfoOnRenewalNotice
		,SC.SalesStatus
		,SC.LegalStatus
		,SC.DoNotTransfer
		,SC.DoNotTransferTime
		,SC.DoNotTransferComment
		,o.EnableTieredPricing
		,o.QuoteTolerance  
	FROM EntityOrganization EO        
	JOIN Entity E ON E.EntityID = EO.EntityID      
	JOIN SalesChannel  SC ON E.EntityID= SC.EntityID   
	LEFT JOIN lp_commissions..vendor v ON SC.ChannelID = v.ChannelID
	LEFT JOIN lp_commissions..vendor_category vc ON v.vendor_category_id = vc.vendor_category_id
	LEFT JOIN LibertyPower..ChannelType ct ON vc.vendor_category_code = ct.Name	 
	LEFT JOIN SalesChannelChannelGroup sccg ON sccg.ChannelId = SC.ChannelID  
												AND sccg.EffectiveDate <= GETDATE()	
												AND Coalesce(sccg.ExpirationDate, cast('1/1/9999' as DateTime)) > GETDATE()
	INNER JOIN SalesChannelPricingOptions o  WITH (NOLOCK) ON sc.ChannelID = o.ChannelID												
	WHERE 1=1
	AND (@ChannelID IS NULL OR SC.ChannelID = @ChannelID)
	AND (@ChannelName IS NULL OR SC.ChannelName = @ChannelName)

END 


GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'SalesChannel', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_SalesChannelSelect';

