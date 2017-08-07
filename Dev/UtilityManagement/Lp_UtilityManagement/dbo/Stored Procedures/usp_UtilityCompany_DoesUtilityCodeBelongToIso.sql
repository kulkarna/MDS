CREATE PROC usp_UtilityCompany_DoesUtilityCodeBelongToIso
	@IsoName NVARCHAR(50),
	@UtilityCode NVARCHAR(50)
AS
BEGIN

	SELECT 
		CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END
	FROM 
		Lp_UtilityManagement..UtilityCompany (NOLOCK) UC
		INNER JOIN Lp_UtilityManagement..Iso (NOLOCK) I
			ON uc.isoid = I.id
	WHERE
		I.Name = @IsoName
		AND UC.UtilityCode = @UtilityCode

END