USE [LibertyPower]
GO
/****** Object:  StoredProcedure [dbo].[usp_SalesChannelSelect]    Script Date: 8/2/2013 3:55:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/****** usp_SalesChannelSelect *******************************************************************************/
/**************************************************************************************
* Updated: 08/02/2013 Sadiel Jarvis: 
*					Added Affinity, AffinityProgram fields
**************************************************************************************
* 3/05/2012 Eric Hernandez
* Created new proc to consolidate other SalesChannel retrieval procs.
**************************************************************************************/
ALTER PROCEDURE [dbo].[usp_SalesChannelSelect] 
(
	@ChannelID INT = NULL,
	@ChannelName VARCHAR(100) = NULL
)      
AS      
BEGIN     

	SET NOCOUNT ON

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
		,SC.Affinity
		,SC.AffinityProgram
	FROM EntityOrganization EO WITH (NOLOCK)       
	JOIN Entity E WITH (NOLOCK) ON E.EntityID = EO.EntityID      
	JOIN SalesChannel  SC WITH (NOLOCK) ON E.EntityID= SC.EntityID   
	LEFT JOIN lp_commissions..vendor v WITH (NOLOCK) ON SC.ChannelID = v.ChannelID
	LEFT JOIN lp_commissions..vendor_category vc WITH (NOLOCK) ON v.vendor_category_id = vc.vendor_category_id
	LEFT JOIN LibertyPower..ChannelType ct WITH (NOLOCK) ON vc.vendor_category_code = ct.Name	 
	LEFT JOIN SalesChannelChannelGroup sccg WITH (NOLOCK) ON sccg.ChannelId = SC.ChannelID  
												AND sccg.EffectiveDate <= GETDATE()	
												AND Coalesce(sccg.ExpirationDate, cast('1/1/9999' as DateTime)) > GETDATE()
	INNER JOIN SalesChannelPricingOptions o  WITH (NOLOCK) ON sc.ChannelID = o.ChannelID												
	WHERE 1=1
	AND (@ChannelID IS NULL OR SC.ChannelID = @ChannelID)
	AND (@ChannelName IS NULL OR SC.ChannelName = @ChannelName)

	SET NOCOUNT OFF

END 

