CREATE PROC [dbo].[usp_PurchaseOfReceivables_SELECT_ByUtilityAndPorDriver]
	@UtilityIdInt AS INT,
	@EffectiveDate AS DATETIME,
	@PorDriverId AS UNIQUEIDENTIFIER,
	@PorDriver AS NVARCHAR(50)
AS
BEGIN
	SELECT
		POR.[Id],
		POR.[UtilityCompanyId],
		UC.UtilityCode,
		POR.[PorDriverId],
		PD.Name AS PorDriverName,
		RC.RateClassCode,
		RC.RateClassId,
		LP.LoadProfileCode,
		LP.LoadProfileId,
		TC.TariffCodeCode,
		TC.TariffCodeId,
		POR.[IsPorOffered],
		POR.[IsPorParticipated],
		POR.[PorRecourseId],
		PR.[Name] AS PorRecourseName,
		POR.[IsPorAssurance],
		POR.[PorDiscountRate],
		POR.[PorFlatFee],
		POR.[PorDiscountEffectiveDate],
		POR.[PorDiscountExpirationDate],
		POR.[Inactive],
		POR.[CreatedBy],
		POR.[CreatedDate],
		POR.[LastModifiedBy],
		POR.[LastModifiedDate]
	FROM
		dbo.PurchaseOfReceivables (NOLOCK) POR
		INNER JOIN dbo.PorDriver (NOLOCK) PD
			ON POR.PorDriverId = PD.Id
		INNER JOIN dbo.porRecourse (NOLOCK) PR
			ON POR.PorRecourseId = PR.Id
		INNER JOIN dbo.UtilityCompany (NOLOCK) UC
			ON POR.UtilityCompanyId = UC.Id
		LEFT OUTER JOIN dbo.RateClass (NOLOCK) RC
			ON POR.RateClassId = RC.Id
		LEFT OUTER JOIN dbo.LoadProfile (NOLOCK) LP
			ON POR.LoadProfileId = LP.Id
		LEFT OUTER JOIN dbo.TariffCode (NOLOCK) TC
			ON POR.TariffCodeId = TC.Id
	WHERE
		POR.PorDiscountEffectiveDate IS NOT NULL 
		AND POR.PorDiscountEffectiveDate <= @EffectiveDate
		AND UC.UtilityIdInt = @UtilityIdInt
		AND
		(
			(
				RTRIM(LTRIM(PD.Name)) = 'Load Profile' 
				AND POR.LoadProfileId = @PorDriverId
				AND @PorDriver = 'Load Profile'
			)
			OR	
			(
				RTRIM(LTRIM(PD.Name)) = 'Tariff Code' 
				AND POR.TariffCodeId = @PorDriverId
				AND @PorDriver = 'Tariff Code' 
			)
			OR	
			(
				RTRIM(LTRIM(PD.Name)) = 'Rate Class' 
				AND POR.RateClassId = @PorDriverId
				AND @PorDriver = 'Rate Class' 
			)
		)
	
END
GO