USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_SalesChannelInsert]    Script Date: 8/2/2013 3:43:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** usp_SalesChannelInsert *******************************************************************************/

/**************************************************************************************
* Updated: 08/02/2013 Sadiel Jarvis: 
*					Added Affinity, AffinityProgram fields
**************************************************************************************
*	Updated: 11/24/2009 GW: Added SC.Description and 
*	                          Removed SC.ActiveDirectoryLoginID  
*
*	Updated: 6/15/2010 GW: Added SC.ChannelGroupId 	
**************************************************************************************
* 10/18/2010 - GW
*	Changed query to save ChannelGroupId to SalesChannelChannelGroup table
**************************************************************************************
* 8/10/2011 Gail Mangaroo 
* Added Contact Feilds etc.
**************************************************************************************/

ALTER PROCEDURE [dbo].[usp_SalesChannelInsert] (  
        @ChannelName varchar(100),  
        @CreatedBy int,   
        @EntityID int,  
        @ChannelDevelopmentManagerID int,
		@ChannelDescription varchar(100),
		@HasManagedUsers bit = 0,
		@Inactive bit =0,
		@ChannelGroupId int = null,
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
		@AlwaysTransfer bit = 0 ,
		@AllowRenewalOnDefault  bit = 0, 
		
		@AllowInfoOnWelcomeLetter bit = 0,
		@AllowInfoOnRenewalLetter bit = 0,
		@AllowInfoOnRenewalNotice bit = 0,
		@SalesStatus int = 1,
		@LegalStatus int = 1,
		@DoNotTransfer bit = 0,
		--@DoNotTransferTime datetime = null,
		@DoNotTransferComment varchar(500) = null,
		@Affinity bit = 0,
		@AffinityProgram varchar(100) = null
   
)        
as        
BEGIN

	SET NOCOUNT ON

	DECLARE @DoNotTransferTime DATETIME
	DECLARE @ChannelId INT
	
	IF @DoNotTransfer = 1
		SET @DoNotTransferTime = GETDATE()
		
	INSERT SalesChannel(
		ChannelName,
		CreatedBy, 
		ModifiedBY, 
		EntityID, 
		ChannelDevelopmentManagerID, 
		ChannelDescription, 
		HasManagedUsers, 
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
		[LegalStatus], 
		[DoNotTransfer],
		[DoNotTransferTime],
		[DoNotTransferComment],
		[Affinity],
		[AffinityProgram]

		)   
	
	VALUES (@ChannelName,
		@CreatedBy,
		@CreatedBy, 
		@EntityID, 
		@ChannelDevelopmentManagerID, 
		@ChannelDescription, 
		@HasManagedUsers, 
		CASE WHEN @SalesStatus = 3 THEN 1 ELSE 0 END,
		--@Inactive,
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
		@LegalStatus,
		@DoNotTransfer, 
		@DoNotTransferTime,
		@DoNotTransferComment,
		@Affinity,
		@AffinityProgram
		) 

	SET @ChannelId = SCOPE_IDENTITY()
	
	print 'channel id: ' + cast(@ChannelId as varchar(10))

	IF (@ChannelGroupId is not null)
	BEGIN
		INSERT INTO [LibertyPower].[dbo].[SalesChannelChannelGroup]
			   ([ChannelId]
			   ,[ChannelGroupId]
			   ,[EffectiveDate]
			   ,[ExpirationDate]
			   ,[UserIdentity]
			   ,[DateCreated])
		 VALUES
			   (@ChannelId
			   ,@ChannelGroupId
			   ,GETDATE()
			   ,null
			   ,@CreatedBy
			   ,GETDATE())
	END

	---- insert default pricing options (tiered pricing enabled, quote tolerance zero)
	--EXEC usp_SalesChannelPricingOptionsInsert @ChannelId, 1, 0
       
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
		 sccg.ChannelGroupId,   

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
		 o.QuoteTolerance,
		 SC.[Affinity],
		 SC.[AffinityProgram]
	FROM EntityOrganization EO WITH (NOLOCK)       
		INNER JOIN Entity E WITH (NOLOCK) on E.EntityID = EO.EntityID      
		INNER JOIN SalesChannel  SC WITH (NOLOCK) on E.EntityID= SC.EntityID      
		LEFT OUTER JOIN SalesChannelChannelGroup sccg WITH (NOLOCK)on sccg.ChannelId = SC.ChannelID  
				AND sccg.EffectiveDate <= GETDATE()	
				AND Coalesce(sccg.ExpirationDate, cast('1/1/9999' as DateTime)) >= GETDATE()
		LEFT JOIN SalesChannelPricingOptions o  WITH (NOLOCK) ON sc.ChannelID = o.ChannelID
	WHERE sc.ChannelID = @ChannelId
	
	SET NOCOUNT OFF
	     
END 
