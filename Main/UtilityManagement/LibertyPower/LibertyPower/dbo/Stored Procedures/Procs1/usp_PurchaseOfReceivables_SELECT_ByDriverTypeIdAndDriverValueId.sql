CREATE PROC usp_PurchaseOfReceivables_SELECT_ByDriverTypeIdAndDriverValueId
	@DriverTypeId INT,
	@DriverValue NVARCHAR(100)
AS
BEGIN

	SELECT 
		POR.[Id],
		[DriverTypeId],
		[DriverValueId],
		[PorOffered],
		[PorParticipated],
		[DoesPorRecourseExist],
		[PorRisk],
		[PorDiscountRate],
		[PorFlatFee],
		[PorDiscountEffectiveDate],
		[PorDiscountExpirationDate],
		[CreateBy],
		[CreateDate],	
		[LastModifiedBy],
		[LastModifiedDate]	
	FROM 
		dbo.PurchaseOfReceivables (NOLOCK) POR
		INNER JOIN dbo.Property (NOLOCK) P
			ON POR.DriverTypeId = P.ID
		INNER JOIN dbo.PropertyInternalRef (NOLOCK) PIR
			ON POR.DriverValueId = PIR.ID
				AND P.ID = PIR.PropertyId
	WHERE
		POR.DriverTypeId = @DriverTypeId
		AND PIR.Value = @DriverValue
		AND ISNULL(PIR.Inactive,0) = 1


END
