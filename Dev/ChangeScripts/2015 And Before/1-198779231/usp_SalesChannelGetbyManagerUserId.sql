USE LibertyPower
GO

-- =============================================
-- Author:		Jaime Forero
-- Create date: 05/05/2011
-- Description:	Get Sales Channel by manager user
-- =============================================
-- 8/10/2011 Gail Mangaroo 
-- Added Contact Feilds etc.
-- ==============================================
-- Updated: 09/03/2013 Sadiel Jarvis: 
-- Added Affinity, AffinityProgram fields
-- ==============================================

ALTER PROCEDURE [dbo].[usp_SalesChannelGetbyManagerUserId]
	@ManagerUserId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	--SELECT	SC.*
	--FROM	LibertyPower..SalesChannel SC
	--WHERE	SC.ChannelDevelopmentManagerID = @ManagerUserId
	--;
					
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
		 SC.[LegalStatus] 
		,o.EnableTieredPricing
		,o.QuoteTolerance
		,SC.Affinity
		,SC.AffinityProgram 		 
	FROM EntityOrganization EO WITH (NOLOCK)         
		JOIN Entity E WITH (NOLOCK) on E.EntityID = EO.EntityID        
		JOIN SalesChannel  SC WITH (NOLOCK) on E.EntityID= SC.EntityID  
		LEFT JOIN lp_commissions..vendor v WITH (NOLOCK) ON SC.ChannelID = v.ChannelID
		LEFT JOIN lp_commissions..vendor_category vc WITH (NOLOCK) ON v.vendor_category_id = vc.vendor_category_id
		LEFT JOIN LibertyPower..ChannelType ct WITH (NOLOCK) ON vc.vendor_category_code = ct.Name
		LEFT JOIN SalesChannelChannelGroup sccg WITH (NOLOCK) 
			ON sccg.ChannelId = SC.ChannelID  
			AND sccg.EffectiveDate <= GETDATE()	
			AND Coalesce(sccg.ExpirationDate, cast('1/1/9999' as DateTime)) > GETDATE()
		INNER JOIN SalesChannelPricingOptions o  WITH (NOLOCK) ON sc.ChannelID = o.ChannelID
	WHERE SC.ChannelDevelopmentManagerID = @ManagerUserId

	SET NOCOUNT OFF;		
END


