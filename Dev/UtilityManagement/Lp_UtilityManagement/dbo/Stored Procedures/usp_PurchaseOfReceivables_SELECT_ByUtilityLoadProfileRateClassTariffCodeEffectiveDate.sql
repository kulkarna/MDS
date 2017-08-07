CREATE PROC [dbo].[usp_PurchaseOfReceivables_SELECT_ByUtilityLoadProfileRateClassTariffCodeEffectiveDate]
	@UtilityIdInt AS INT,
	@EffectiveDate AS DATETIME,
	@LoadProfile AS NVARCHAR(255),
	@RateClass AS NVARCHAR(255),
	@TariffCode AS NVARCHAR(255)
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
		AND (POR.PorDiscountExpirationDate IS NULL OR POR.PorDiscountExpirationDate > @EffectiveDate)
		AND UC.UtilityIdInt = @UtilityIdInt
		AND
		(
			(
				RTRIM(LTRIM(PD.EnumValue)) = 0
				AND LP.LoadProfileCode = @LoadProfile
				AND @LoadProfile IS NOT NULL
				AND LP.LoadProfileCode IS NOT NULL
			)
			OR	
			(
				RTRIM(LTRIM(PD.EnumValue)) = 1
				AND TC.TariffCodeCode = @TariffCode
				AND @TariffCode IS NOT NULL
				AND TC.TariffCodeCode IS NOT NULL
			)
			OR	
			(
				RTRIM(LTRIM(PD.EnumValue)) = 2
				AND RC.RateClassCode = @RateClass
				AND @RateClass IS NOT NULL
				AND RC.RateClassCode IS NOT NULL
			)
		)
	
END