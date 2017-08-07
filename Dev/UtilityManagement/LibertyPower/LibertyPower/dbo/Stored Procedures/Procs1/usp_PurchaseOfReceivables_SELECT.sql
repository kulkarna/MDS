CREATE PROC usp_PurchaseOfReceivables_SELECT
AS
BEGIN

	SELECT 
		[Id],
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

END