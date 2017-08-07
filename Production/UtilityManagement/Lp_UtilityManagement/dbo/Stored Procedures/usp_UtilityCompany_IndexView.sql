CREATE PROC [dbo].[usp_UtilityCompany_IndexView]
AS
BEGIN

	SELECT
		UC.Id,
		UC.UtilityIdInt,
		UC.UtilityCode,
		UC.FullName,
		UC.ParentCompany,
		I.Name ISO,
		UC.IsoId,
		M.Market,
		UC.MarketId,
		M.MarketIdInt,
		UC.PrimaryDunsNumber,
		UC.LpEntityId,
		UC.UtilityStatusId,
		PAI.Value AS UtilityStatus,
		PAI.NumericValue AS UtilityStatusIdInt,
		UC.EnrollmentLeadDays,
		UC.AccountLength,
		UC.AccountNumberPrefix,
		UC.PorOption,
		UC.MeterNumberRequired,
		UC.MeterNumberLength,
		UC.EdiCapabale AS EdiCapable,
		UC.UtilityPhoneNumber,
		BT.ShortName AS BillingType,
		UC.Inactive,
		UC.CreatedBy,
		UC.CreatedDate,
		UC.LastModifiedBy,
		UC.LastModifiedDate
	FROM	
		dbo.UtilityCompany (NOLOCK) UC
		LEFT OUTER JOIN dbo.ISO (NOLOCK) I
			ON UC.IsoId = I.Id
		LEFT OUTER JOIN dbo.Market (NOLOCK) M
			ON UC.MarketId = M.Id
		LEFT OUTER JOIN dbo.TriStateValuePendingActiveInactive (NOLOCK) PAI
			ON UC.UtilityStatusId = PAI.Id
		LEFT OUTER JOIN dbo.BillingType (NOLOCK) BT
			ON UC.BillingTypeId = BT.Id

END