

/**************************************************************************************
* Updated: 11/24/2009 GW: Added SC.Description to the Select clause.
*                          Removed SC.ActiveDirectoryLoginID  
* 6/18/2010 - Rick Deigsler
* Added ChannelTypeID
**************************************************************************************
* 8/10/2011 Gail Mangaroo 
* Added Contact Feilds etc.
**************************************************************************************/

CREATE proc [dbo].[usp_SalesChannelGetLibertyPower]        
as        
BEGIN 
	Select         
		SC.ChannelID,        
		SC.ChannelName,
		SC.ChannelDescription,
		SC.DateCreated,        
		SC.DateModified,        
		SC.CreatedBy,        
		SC.ModifiedBy,        
		SC.EntityID ,    
		SC.ChannelDevelopmentManagerID ,
		SC.HasManagedUsers,
		SC.Inactive,
		sccg.ChannelGroupId,
		ct.ID AS ChannelTypeID,   

		 SC.[ContactFirstName],
		 SC.[ContactLastName],
		 SC.[ContactAddress1],
		 SC.[ContactAddress2],
		 SC.[ContactCity],
		 SC.[ContactState],
		 SC.[ContactZip],
		 SC.[ContactEmail],
		 SC.[ContactPhone],
		 SC.[ContactFax],
		 
		 SC.[RenewalGracePeriod],
		 SC.[AllowRetentionSave],
		 SC.[AlwaysTransfer],
		 SC.[AllowRenewalOnDefault],
		 
		 SC.[AllowInfoOnWelcomeLetter],
		 SC.[AllowInfoOnRenewalLetter],
		 SC.[AllowInfoOnRenewalNotice],
		 SC.[SalesStatus],
		 SC.[LegalStatus],
		 o.EnableTieredPricing,   
		 o.QuoteTolerance
	From SalesChannel  SC    
		INNER JOIN lp_commissions..vendor v ON SC.ChannelID = v.ChannelID
		INNER JOIN lp_commissions..vendor_category vc ON v.vendor_category_id = vc.vendor_category_id
		INNER JOIN LibertyPower..ChannelType ct ON vc.vendor_category_code = ct.Name  
		LEFT OUTER JOIN SalesChannelChannelGroup sccg on sccg.ChannelId = SC.ChannelID  
				AND sccg.EffectiveDate <= GETDATE()	
				AND Coalesce(sccg.ExpirationDate, cast('1/1/9999' as DateTime)) > GETDATE()
		INNER JOIN SalesChannelPricingOptions o  WITH (NOLOCK) ON sc.ChannelID = o.ChannelID
	Where ChannelName = 'libertypower\LPC' 

END 
