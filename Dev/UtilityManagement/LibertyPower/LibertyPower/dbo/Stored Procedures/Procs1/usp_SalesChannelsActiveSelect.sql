/****** END usp_SalesChannelUpdate *******************************************************************************/

/****** usp_SalesChannelsActiveSelect *******************************************************************************/

/*******************************************************************************
 * usp_SalesChannelsActiveSelect
 * Gets all active sales channels
 *
 * History
 *******************************************************************************
 * 6/18/2010 - Rick Deigsler
 * Created.
 **************************************************************************************
 * 10/18/2010 - GW
 *	Changed query to pull active ChannelGroupId from SalesChannelChannelGroup table
 *  Added optional Parameter @GroupDate
 *		- If GroupDate is supplied, then the ChannelGroupId at the given time is returned; 
			otherwise, the current ChannelGroupId is returned.
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_SalesChannelsActiveSelect]
	@GroupDate DateTime = null
AS
BEGIN
    SET NOCOUNT ON;

	if(@GroupDate is null)
	Begin
		Set @GroupDate = GETDATE()
	End

	SELECT	sc.ChannelID, 
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
			LEFT OUTER JOIN SalesChannelChannelGroup sccg on sccg.ChannelId = SC.ChannelID  
					AND sccg.EffectiveDate <= @GroupDate
					AND Coalesce(sccg.ExpirationDate, cast('1/1/9999' as DateTime)) >= @GroupDate
			INNER JOIN SalesChannelPricingOptions o  WITH (NOLOCK) ON sc.ChannelID = o.ChannelID
	WHERE	sc.Inactive = 0
	--and sc.ChannelID = 357
	ORDER BY sc.ChannelName

    SET NOCOUNT OFF;
END
-- Copyright 2010 Liberty Power
