


CREATE PROC [dbo].[usp_AccountInfoFieldRequired_GetByUtility]
AS
BEGIN
	set nocount on
	
	SELECT
		AIFR.Id,
		UC.UtilityIdInt,
		UC.UtilityCode,
		AIF.NameMachineUnfriendly AS NameUserFriendly,
		AIFR.IsRequired,
		AIFR.Inactive,
		AIFR.CreatedBy,
		AIFR.CreatedDate,
		AIFR.LastModifiedBy,
		AIFR.LastModifiedDate
	FROM
		UtilityCompany (NOLOCK) UC
		INNER JOIN AccountInfoFieldRequired (NOLOCK) AIFR
			ON UC.Id = AIFR.UtilityCompanyId
		INNER JOIN AccountInfoField (NOLOCK) AIF
			ON AIFR.AccountInfoFieldId = AIF.ID
	WHERE
		AIFR.IsRequired = 1
		AND UC.Inactive = 0		
	ORDER BY
		UC.UtilityCode,
		AIF.NameUserFriendly

	set nocount off
		
END
GO