CREATE PROC usp_MeterType_GetCountOfUtilityCompanyIdAndMeterTypeCode
	@UtilityCompanyId AS NVARCHAR(50),
	@MeterTypeCode AS NVARCHAR(255)
AS
BEGIN

	SELECT 
		COUNT(Id)
	FROM
		dbo.MeterType (NOLOCK) 
	WHERE
		UtilityCompanyId = @UtilityCompanyId
		AND MeterTypeCode = RTRIM(LTRIM(@MeterTypeCode))

END
GO