
/**********************************************************
* Author:		gworthington
* Create date:	12/4/2009
* Description:	Retrieves a dataset of SalesChannelHistory 
					records with given ChannelID
***********************************************************
* 8/10/2011 Gail Mangaroo 
* Added Contact Feilds etc.
***********************************************************/

CREATE proc [dbo].[usp_SalesChannelHistoryGet] (@ChannelID int)      
as      
BEGIN     
    Select     
		 SC.ChannelHistoryID, 
		 SC.ChannelID,         
		 SC.ChannelName, 
		 SC.ChannelDescription,        
		 SC.DateModified,                
		 SC.ModifiedBy ,  
		 SC.ChannelDevelopmentManagerID, 
		 SC.Inactive,            
		 E.EntityID,          
		 EO.DunsNumber,        
		 EO.CustomerName,          
		 EO.TaxID,         
		 E.Tag,      
		 E.StartDate,   

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
		       
	From EntityOrganization EO (NOLOCK)        
		inner join Entity E (NOLOCK) on E.EntityID = EO.EntityID      
		inner join SalesChannelHistory  SC (NOLOCK) on E.EntityID= SC.EntityID      
		     
	Where ChannelID = @ChannelID 
		    
END 

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'SalesChannel', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_SalesChannelHistoryGet';

