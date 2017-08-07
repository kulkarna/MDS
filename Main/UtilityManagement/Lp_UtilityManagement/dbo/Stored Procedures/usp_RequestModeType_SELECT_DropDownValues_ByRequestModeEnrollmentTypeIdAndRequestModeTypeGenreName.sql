CREATE PROC [dbo].[usp_RequestModeType_SELECT_DropDownValues_ByRequestModeEnrollmentTypeIdAndRequestModeTypeGenreName]
	@RequestModeEnrollmentTypeId NVARCHAR(50),
	@RequestModeTypeGenreName NVARCHAR(50)
AS
BEGIN
	SELECT 
		RMT.Id,
		RMT.Name--,
		--rmet.Id,
		--rmet.Name,
		--rmtg.id,
		--rmtg.name,
		--* 
	FROM 
		dbo.RequestModeType (NOLOCK) RMT
		INNER JOIN dbo.RequestModeTypeToRequestModeEnrollmentType (NOLOCK) RMT2RMET
			ON RMT.Id = RMT2RMET.RequestModeTypeId
		INNER JOIN RequestModeEnrollmentType (NOLOCK) RMET
			ON RMT2RMET.RequestModeEnrollmentTypeId = RMET.Id
		--INNER JOIN RequestModeTypeToRequestModeTypeGenre (NOLOCK) RMT2RMTG
		--	ON RMT.Id = RMT2RMTG.RequestModeTypeId
		INNER JOIN RequestModeTypeGenre (NOLOCK) RMTG
			ON RMT2RMET.RequestModeTypeGenreid = RMTG.Id
	WHERE
		RMET.Id = @RequestModeEnrollmentTypeId
		 and RMTG.Name = @RequestModeTypeGenreName--'historical usage'
END

GO