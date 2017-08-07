
/****** usp_SalesChannelGet *******************************************************************************/
/**************************************************************************************
* Updated: 11/24/2009 GW: Added SC.Description to the Select clause.
*                          Removed SC.ActiveDirectoryLoginID  
* 6/18/2010 - Rick Deigsler
* Added ChannelTypeID
**************************************************************************************
* 10/18/2010 - GW
*	Changed query to pull active ChannelGroupId from SalesChannelChannelGroup table
**************************************************************************************
* 8/10/2011 Gail Mangaroo 
* Added Contact Feilds etc.
**************************************************************************************
* 3/5/2012 Eric Hernandez
* Consolidated proc into usp_SalesChannelSelect
**************************************************************************************/
CREATE PROCEDURE [dbo].[usp_SalesChannelGet] (@ChannelID int)      
as      
BEGIN     
	EXEC usp_SalesChannelSelect @ChannelID = @ChannelID

/*
	Select     
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
		 E.StartDate  ,
		 SCCG.ChannelGroupId,
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
		 SC.[LegalStatus]  

	From EntityOrganization EO        
		inner join Entity E on E.EntityID = EO.EntityID      
		inner join SalesChannel  SC on E.EntityID= SC.EntityID   
		LEFT OUTER JOIN lp_commissions..vendor v ON SC.ChannelID = v.ChannelID
		LEFT OUTER JOIN lp_commissions..vendor_category vc ON v.vendor_category_id = vc.vendor_category_id
		LEFT OUTER JOIN LibertyPower..ChannelType ct ON vc.vendor_category_code = ct.Name	 
		LEFT OUTER JOIN SalesChannelChannelGroup sccg on sccg.ChannelId = SC.ChannelID  
				AND sccg.EffectiveDate <= GETDATE()	
				AND Coalesce(sccg.ExpirationDate, cast('1/1/9999' as DateTime)) > GETDATE()
	Where SC.ChannelID = @ChannelID 
*/
END 

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'SalesChannel', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_SalesChannelGet';

