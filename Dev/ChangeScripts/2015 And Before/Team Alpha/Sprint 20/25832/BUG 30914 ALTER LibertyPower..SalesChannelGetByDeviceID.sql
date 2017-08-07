USE LibertyPower
GO
-- =============================================
-- Author:		Markus Geiger
-- Create date: 12/10/2013
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[usp_SalesChannelGetByDeviceID] 
	@deviceID varchar(50) 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT  TOP 1
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
	FROM LibertyPower..EntityOrganization EO WITH (NOLOCK)       
	JOIN LibertyPower..Entity E WITH (NOLOCK) ON E.EntityID = EO.EntityID      
	JOIN LibertyPower..SalesChannel  SC WITH (NOLOCK) ON E.EntityID= SC.EntityID   
	LEFT JOIN lp_commissions..vendor v WITH (NOLOCK) ON SC.ChannelID = v.ChannelID
	LEFT JOIN lp_commissions..vendor_category vc WITH (NOLOCK) ON v.vendor_category_id = vc.vendor_category_id
	LEFT JOIN LibertyPower..ChannelType ct WITH (NOLOCK) ON vc.vendor_category_code = ct.Name	 
	LEFT JOIN LibertyPower..SalesChannelChannelGroup sccg WITH (NOLOCK) ON sccg.ChannelId = SC.ChannelID  
												AND sccg.EffectiveDate <= GETDATE()	
												AND Coalesce(sccg.ExpirationDate, cast('1/1/9999' as DateTime)) > GETDATE()
	INNER JOIN LibertyPower..SalesChannelPricingOptions o  WITH (NOLOCK) ON sc.ChannelID = o.ChannelID
	INNER JOIN LibertyPower..SalesChannelDeviceAssignment A WITH (NOLOCK) ON SC.ChannelID = A.ChannelID												
	WHERE 1=1 AND 
	(A.DeviceID = @deviceID)
    
    --SELECT TOP 1 @channelID = ChannelID FROM LibertyPower..SalesChannelDeviceAssignment WHERE DeviceID = @deviceID;
    
    --EXEC usp_SalesChannelSelect @ChannelID;
    
    SET NOCOUNT OFF;
END
