USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_SalesChannelUpdate]    Script Date: 8/2/2013 3:01:35 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** usp_SalesChannelUpdate *******************************************************************************/
/**************************************************************************************
* Updated: 08/02/2013 Sadiel Jarvis: 
*					Added Affinity, AffinityProgram fields
*************************************************************************************
* Updated: 11/24/2009 GW: Added SC.Description 
*                          Removed SC.ActiveDirectoryLoginID  
 **************************************************************************************
 * 10/18/2010 - GW
 *	Changed query to not update the ChannelGroupId 
**************************************************************************************
* 8/10/2011 Gail Mangaroo 
* Added Contact Feilds etc.
**************************************************************************************/

  ALTER PROCEDURE [dbo].[usp_SalesChannelUpdate] 
  (			
			@ChannelID int,  
			@ChannelName varchar(100),  
			@ModifiedBy int,
			@ChannelDevelopmentManagerID int,
			@ChannelDescription varchar(100),
			@HasManagedUsers bit,
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
			@AlwaysTransfer bit = 0 ,
			@AllowRenewalOnDefault  bit = 0,  
			
			@AllowInfoOnWelcomeLetter bit = 0,
			@AllowInfoOnRenewalLetter bit = 0,
			@AllowInfoOnRenewalNotice bit = 0,
			@SalesStatus int = 1,
			@LegalStatus int = 1,
			@DoNotTransfer bit = 0,
			@DoNotTransferComment varchar(500) = null,
			@Affinity bit = 0,
			@AffinityProgram varchar(100) = null
	)      
as      
BEGIN 

	SET NOCOUNT ON

	-- If the DoNotTransfer flag changes, we record the time that it was changed.
	DECLARE @OldValue_DoNotTransfer BIT
	DECLARE @DoNotTransferTime DATETIME
	SELECT @OldValue_DoNotTransfer = DoNotTransfer, @DoNotTransferTime = DoNotTransferTime
	FROM SalesChannel (NOLOCK)
	WHERE ChannelID = @ChannelID

	IF (@OldValue_DoNotTransfer <> @DoNotTransfer AND @DoNotTransfer = 1)
		SET @DoNotTransferTime = GETDATE()
		

	UPDATE SalesChannel      
	SET ChannelName = @ChannelName,      
		ChannelDescription = @ChannelDescription,
		ModifiedBY= @ModifiedBY,  
		ChannelDevelopmentManagerID = @ChannelDevelopmentManagerID,
		HasManagedUsers = @HasManagedUsers,
		Inactive = CASE WHEN @SalesStatus = 3 THEN 1 ELSE 0 END,--@Inactive,
		ContactFirstName = @ContactFirstName,
		ContactLastName =	@ContactLastName,
		ContactAddress1 = @ContactAddress1,
		ContactAddress2 =	@ContactAddress2,
		ContactCity = 	@ContactCity,
		ContactState =	@ContactState,
		ContactZip = @ContactZip,
		ContactEmail =	@ContactEmail,
		ContactPhone =	@ContactPhone,
		ContactFax = @ContactFax,
		
		RenewalGracePeriod = @RenewalGracePeriod,
		AllowRetentionSave =	@AllowRetentionSave,
		AlwaysTransfer =	@AlwaysTransfer,
		AllowRenewalOnDefault = @AllowRenewalOnDefault,
		
		AllowInfoOnWelcomeLetter = @AllowInfoOnWelcomeLetter,
		AllowInfoOnRenewalLetter = @AllowInfoOnRenewalLetter,
		AllowInfoOnRenewalNotice = @AllowInfoOnRenewalNotice,
		SalesStatus = @SalesStatus,
		LegalStatus = @LegalStatus,
		DateModified = getdate(),
		DoNotTransfer = @DoNotTransfer,
		DoNotTransferTime = @DoNotTransferTime,
		DoNotTransferComment = @DoNotTransferComment,
		Affinity = @Affinity,
		AffinityProgram = @AffinityProgram
		
	WHERE ChannelID  = @ChannelID
      
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
		 E.StartDate, 
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
		LEFT OUTER JOIN SalesChannelChannelGroup sccg WITH (NOLOCK) on sccg.ChannelId = SC.ChannelID  
				AND sccg.EffectiveDate <= GETDATE()	
				AND Coalesce(sccg.ExpirationDate, cast('1/1/9999' as DateTime)) >= GETDATE()
		INNER JOIN SalesChannelPricingOptions o  WITH (NOLOCK) ON sc.ChannelID = o.ChannelID
	WHERE SC.ChannelID = @ChannelID  

	SET NOCOUNT OFF

END 
