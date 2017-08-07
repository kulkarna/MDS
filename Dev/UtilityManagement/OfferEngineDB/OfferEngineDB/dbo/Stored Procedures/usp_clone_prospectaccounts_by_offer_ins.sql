
-- =============================================
-- Author:		Rick Deigsler
-- Create date: 8/16/2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_clone_prospectaccounts_by_offer_ins]

@p_offer_id			varchar(50),
@p_offer_id_clone	varchar(50)

AS

INSERT INTO	lp_historical_info..ProspectAccounts
SELECT		Utility, CustomerName, AccountNumber, ServiceAddress, ZipCode, LoadShapeID, RateClass, 
			RateCode, Rider, StratumVariable, ICAP, TCAP, POLRType, BillGroup, Voltage, Zone, 
			ISO, LoadProfile, IDR, TotalKWH, TotalDays, @p_offer_id_clone, GETDATE(), CreatedBy, NULL, 
			NULL, AlternativeAcctNum, CustomerType, SupplyGroup, MeterNumber, OnPeakKWH, 
			OffPeakKWH, BillingDemandKW, MonthlyPeakDemandKW, CurrentCharges, Comments, Active
FROM		lp_historical_info..ProspectAccounts
WHERE		[Deal ID] = @p_offer_id

