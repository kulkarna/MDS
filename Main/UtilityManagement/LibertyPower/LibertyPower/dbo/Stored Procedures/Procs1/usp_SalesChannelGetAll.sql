

/****** usp_SalesChannelGetAll *******************************************************************************/

/**************************************************************************************
* Updated: 11/24/2009 GW: Added SC.Description to the Select clause.
*                          Removed SC.ActiveDirectoryLoginID  
* 6/18/2010 - Rick Deigsler
* Added ChannelTypeID
**************************************************************************************
* 10/18/2010 - GW
*	Changed query to pull active ChannelGroupId from SalesChannelChannelGroup table
**************************************************************************************
* 11/18/2010 - Thiago Nogueira
*	Changed to be able to get Sales Channel with minimum data
**************************************************************************************
* 8/10/2011 Gail Mangaroo 
* Added Contact Feilds etc.
**************************************************************************************/

CREATE proc [dbo].[usp_SalesChannelGetAll]      
AS
BEGIN 
	
	SELECT    
		 SC.ChannelID,           
		 SC.ChannelName,     
		 SC.ChannelDescription,       
		 SC.DateCreated,           
		 SC.DateModified,          
		 SC.CreatedBy,           
		 SC.ModifiedBy ,  
		 SC.ChannelDevelopmentManagerID, 
		 SC.HasManagedUsers,
		 SC.Inactive,            
		 E.EntityID,            
		 EO.DunsNumber,          
		 EO.CustomerName,            
		 EO.TaxID,           
		 E.Tag,        
		 E.StartDate ,
		 ChannelGroupID = isnull(sccg.ChannelGroupID,0),
		 ChannelTypeID = isnull(ct.ID,-1),   

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
	FROM EntityOrganization EO          
		JOIN Entity E on E.EntityID = EO.EntityID        
		JOIN SalesChannel  SC on E.EntityID= SC.EntityID  
		LEFT JOIN lp_commissions..vendor v ON SC.ChannelID = v.ChannelID
		LEFT JOIN lp_commissions..vendor_category vc ON v.vendor_category_id = vc.vendor_category_id
		LEFT JOIN LibertyPower..ChannelType ct ON vc.vendor_category_code = ct.Name
		LEFT JOIN SalesChannelChannelGroup sccg 
			ON sccg.ChannelId = SC.ChannelID  
			AND sccg.EffectiveDate <= GETDATE()	
			AND Coalesce(sccg.ExpirationDate, cast('1/1/9999' as DateTime)) > GETDATE()
		INNER JOIN SalesChannelPricingOptions o  WITH (NOLOCK) ON sc.ChannelID = o.ChannelID
END 
