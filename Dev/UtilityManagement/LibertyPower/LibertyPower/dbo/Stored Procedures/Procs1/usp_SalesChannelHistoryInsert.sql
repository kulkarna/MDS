    
/******************************************************
* Author:		gworthington
* Create date:	12/4/2009
* Description:	Inserts a new SalesChannelHistory record
******************************************************
* 8/10/2011 Gail Mangaroo 
* Added Contact Feilds etc.
********************************************************/

CREATE proc [dbo].[usp_SalesChannelHistoryInsert] (  
        @ChannelId int,   
        @ChannelName varchar(100),  
        @ModifiedBy int,   
        @EntityID int,  
		@ChannelDevelopmentManagerID int,
		@ChannelDescription varchar(100),
		@Inactive bit,
		@ContactFirstName varchar(100) = null,
		@ContactLastName varchar(100) = null,
		@ContactAddress1 varchar(100) = null,
		@ContactAddress2 varchar(100) = null,
		@ContactCity varchar(100) = null,
		@ContactState varchar(50) = null,
		@ContactZip varchar(20) = null,
		@ContactEmail varchar(100) = null,
		@ContactPhone varchar(100) = null,
		@ContactFax varchar(50) = null,
		
		@RenewalGracePeriod int = 0,
		@AllowRetentionSave bit = 0,
		@AlwaysTransfer bit = 0,
		@AllowRenewalOnDefault  bit = 0, 
		
		@AllowInfoOnWelcomeLetter bit = 0,
		@AllowInfoOnRenewalLetter bit = 0,
		@AllowInfoOnRenewalNotice bit = 0,
		@SalesStatus int = 0,
		@LegalStatus int = 0 
)        
as        

BEGIN 
	Insert SalesChannelHistory(
		ChannelId, 
		ChannelName, 
		DateModified, 
		ModifiedBY, 
		EntityID, 
		ChannelDevelopmentManagerID, 
		ChannelDescription, 
		Inactive,
		[ContactFirstName],
		[ContactLastName],
		[ContactAddress1],
		[ContactAddress2],
		[ContactCity],
		[ContactState],
		[ContactZip],
		[ContactEmail],
		[ContactPhone],
		[ContactFax],
		
		[RenewalGracePeriod],
		[AllowRetentionSave],
		[AlwaysTransfer],
		[AllowRenewalOnDefault],
		
		[AllowInfoOnWelcomeLetter],
		[AllowInfoOnRenewalLetter],
		[AllowInfoOnRenewalNotice],
		[SalesStatus],
		[LegalStatus] )        
		
	Values (@ChannelId, 
		@ChannelName, 
		getdate(),
		@ModifiedBy, 
		@EntityID,
		@ChannelDevelopmentManagerID,
		@ChannelDescription,
		@Inactive,
		@ContactFirstName,
		@ContactLastName,
		@ContactAddress1,
		@ContactAddress2,
		@ContactCity,
		@ContactState,
		@ContactZip,
		@ContactEmail,
		@ContactPhone,
		@ContactFax,
		
		@RenewalGracePeriod,
		@AllowRetentionSave,
		@AlwaysTransfer,
		@AllowRenewalOnDefault,
		
		@AllowInfoOnWelcomeLetter,
		@AllowInfoOnRenewalLetter,
		@AllowInfoOnRenewalNotice,
		@SalesStatus,
		@LegalStatus        
		) 
		
	Select     
		 SCH.ChannelHistoryID,         
		 SCH.ChannelID,         
		 SCH.ChannelName,         
		 SCH.ChannelDescription,
		 SCH.DateModified,        
		 SCH.ModifiedBy ,  
		 SCH.ChannelDevelopmentManagerID, 
		 SCH.Inactive,
		 E.EntityID,          
		 EO.DunsNumber,        
		 EO.CustomerName,          
		 EO.TaxID,         
		 E.Tag,      
		 E.StartDate,   

		 SCH.[ContactFirstName],
		 SCH.[ContactLastName],
		 SCH.[ContactAddress1],
		 SCH.[ContactAddress2],
		 SCH.[ContactCity],
		 SCH.[ContactState],
		 SCH.[ContactZip],
		 SCH.[ContactEmail],
		 SCH.[ContactPhone],
		 SCH.[ContactFax],
		 
		 SCH.[RenewalGracePeriod],
		 SCH.[AllowRetentionSave],
		 SCH.[AlwaysTransfer],
		 SCH.[AllowRenewalOnDefault],
		 
		 SCH.[AllowInfoOnWelcomeLetter],
		 SCH.[AllowInfoOnRenewalLetter],
		 SCH.[AllowInfoOnRenewalNotice],
		 SCH.[SalesStatus],
		 SCH.[LegalStatus]   
	   
	From EntityOrganization EO (NOLOCK)        
		inner join Entity E (NOLOCK) on E.EntityID = EO.EntityID      
		inner join SalesChannelHistory  SCH (NOLOCK) on E.EntityID= SCH.EntityID      
	Where ChannelHistoryID = SCOPE_IDENTITY()        

END 

GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'SalesChannel', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_SalesChannelHistoryInsert';

