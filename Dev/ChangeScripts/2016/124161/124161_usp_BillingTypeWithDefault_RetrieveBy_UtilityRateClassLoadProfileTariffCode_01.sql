

CREATE PROC [dbo].[usp_BillingTypeWithDefault_RetrieveBy_UtilityRateClassLoadProfileTariffCode]

	@UtilityIdInt INT,

	@RateClass AS NVARCHAR(255),

	@LoadProfile AS NVARCHAR(255),

	@TariffCode AS NVARCHAR(255)

AS

BEGIN



	SELECT

		DISTINCT BT.EnumValue,

		 case when 

		  BT.Id=LBT.DefaultBillingTypeId then 1

		  else 0 end as IsDefaultBillingTypeId

	FROM 

		dbo.LpApprovedBillingType (NOLOCK) LABT

		INNER JOIN dbo.LpBillingType (NOLOCK) LBT

			ON LABT.LpBillingTypeId = LBT.Id

		INNER JOIN dbo.BillingType (NOLOCK) BT

			ON LABT.ApprovedBillingTypeId = BT.Id

		INNER JOIN dbo.UtilityCompany (NOLOCK) UC

			ON LBT.UtilityCompanyId = UC.Id

				AND UC.UtilityIdInt = @UtilityIdInt

		INNER JOIN dbo.PorDriver (NOLOCK) PD

			ON LBT.PorDriverId = PD.Id

		LEFT OUTER JOIN dbo.LoadProfile (NOLOCK) LP

			ON LBT.LoadProfileId = LP.Id

		LEFT OUTER JOIN dbo.RateClass (NOLOCK) RC

			ON LBT.RateClassId = RC.Id

		LEFT OUTER JOIN dbo.TariffCode (NOLOCK) TC

			ON LBT.TariffCodeId = TC.Id

	WHERE

		((--PD.Name = 'Load Profile'

		PD.EnumValue = 0

		AND @LoadProfile IS NOT NULL 

		AND LP.LoadProfileCode IS NOT NULL

		AND LP.LoadProfileCode = @LoadProfile) 

		OR

		(--PD.Name = 'Rate Class'

		PD.EnumValue = 2

		AND @RateClass IS NOT NULL 

		AND RC.RateClassCode = @RateClass)

		OR

		(--PD.Name = 'Tariff Code'

		PD.EnumValue = 1

		AND @TariffCode IS NOT NULL 

		AND TC.TariffCodeCode = @TariffCode))

		

END


