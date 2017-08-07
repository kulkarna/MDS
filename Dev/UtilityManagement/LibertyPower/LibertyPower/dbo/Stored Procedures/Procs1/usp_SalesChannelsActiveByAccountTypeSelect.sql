/****** END usp_SalesChannelUpdate *******************************************************************************/




/****** usp_SalesChannelsActiveSelect *******************************************************************************/

/*******************************************************************************
 * usp_SalesChannelsActiveByAccountTypeSelect
 * Gets active sales channels for given account type.
 *
 * History
 *******************************************************************************
 * 9/27/2011 - Rick Deigsler
 * Created.
 **************************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_SalesChannelsActiveByAccountTypeSelect]
	@AccountTypeID int
AS
BEGIN
    SET NOCOUNT ON;

	SELECT	DISTINCT sc.ChannelID, 
		sc.ChannelName, 
		sc.ChannelDescription, 
		sc.DateCreated, 
		sc.DateModified, 
		sc.CreatedBy, 
		sc.ModifiedBy, 
		sc.ChannelDevelopmentManagerID, 
		sc.HasManagedUsers, 
		sc.Inactive, 
		e.EntityID, 
		eo.DunsNumber, 
		eo.CustomerName, 
		eo.TaxID, 
		e.Tag, 
		e.StartDate, 
		sccg.ChannelGroupID, 
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
	FROM	EntityOrganization eo WITH (NOLOCK)         
			INNER JOIN Entity e WITH (NOLOCK) ON e.EntityID = eo.EntityID        
			INNER JOIN SalesChannel sc WITH (NOLOCK) ON e.EntityID= sc.EntityID  
			INNER JOIN lp_commissions..vendor v WITH (NOLOCK) ON sc.ChannelID = v.ChannelID
			INNER JOIN lp_commissions..vendor_category vc WITH (NOLOCK) ON v.vendor_category_id = vc.vendor_category_id
			INNER JOIN LibertyPower..ChannelType ct WITH (NOLOCK) ON vc.vendor_category_code = ct.Name
			INNER JOIN Libertypower..SalesChannelAccountType at ON sc.ChannelID = at.ChannelID
			LEFT OUTER JOIN SalesChannelChannelGroup sccg on sccg.ChannelId = SC.ChannelID  
					AND sccg.EffectiveDate <= GETDATE()
					AND Coalesce(sccg.ExpirationDate, cast('1/1/9999' as DateTime)) >= GETDATE()
			INNER JOIN SalesChannelPricingOptions o  WITH (NOLOCK) ON sc.ChannelID = o.ChannelID			
	WHERE	sc.Inactive = 0
	AND		at.AccountTypeID = @AccountTypeID
	ORDER BY sc.ChannelName

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power
