USE [Lp_transactions]
GO
/****** Object:  StoredProcedure [dbo].[usp_EdiAccountGetLatest]    Script Date: 01/10/2014 10:28:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_EdiAccountGetLatest]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_EdiAccountGetLatest]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_EdiAccountGetLatest]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*******************************************************************************
 * usp_EdiAccountGet
 * Gets the zone, profile, rateclass, bill group for an account number
 *
 * History
 * 4/25/2013: Get the latest account information by ID 
 *******************************************************************************
 * ? - ?
 * Created.
 Modified by: Cathy Ghazal
 *
 * 1/10/2014 - Rick Deigsler
 * Added Icap and Tcap effecive dates to where clauses
 *******************************************************************************
 */

CREATE PROCEDURE [dbo].[usp_EdiAccountGetLatest]
(	@AccountNumber as varchar(50),
	@UtilityCode AS Varchar(50)
 )

AS

BEGIN

	SET NOCOUNT ON;

		DECLARE	@ZoneCode AS VARCHAR(50)
		SET	@ZoneCode = (SELECT	ZoneCode
						FROM	EdiAccount (nolock)
						WHERE	ID IN (
									SELECT	MAX(ID)
									FROM	EdiAccount (nolock)
									WHERE	AccountNumber = @AccountNumber
									AND		UtilityCode = @UtilityCode
									AND		ZoneCode IS NOT NULL
									AND		RTRIM(LTRIM(ZoneCode)) != ''''
									)
						)
						
		DECLARE	@LoadProfile AS VARCHAR(50)
		SET	@LoadProfile = (SELECT	LoadProfile
							FROM	EdiAccount (nolock)
							WHERE	ID IN (
										SELECT	MAX(ID)
										FROM	EdiAccount (nolock)
										WHERE	AccountNumber = @AccountNumber
										AND		UtilityCode = @UtilityCode
										AND		LoadProfile IS NOT NULL
										AND		RTRIM(LTRIM(LoadProfile)) != ''''
										)
							)
					
		DECLARE	@RateClass AS VARCHAR(50)
		SET	@RateClass = (SELECT	RateClass
						FROM	EdiAccount (nolock)
						WHERE	ID IN (
									SELECT	MAX(ID)
									FROM	EdiAccount (nolock)
									WHERE	AccountNumber = @AccountNumber
									AND		UtilityCode = @UtilityCode
									AND		RateClass IS NOT NULL
									AND		RTRIM(LTRIM(RateClass)) != ''''
									)
					)

		DECLARE	@BillGroup AS VARCHAR(50)
		SET	@BillGroup = (SELECT	BillGroup
						FROM	EdiAccount (nolock)
						WHERE	ID IN (
									SELECT	MAX(ID)
									FROM	EdiAccount (nolock)
									WHERE	AccountNumber = @AccountNumber
									AND		UtilityCode = @UtilityCode
									AND		BillGroup IS NOT NULL
									AND		RTRIM(LTRIM(BillGroup)) NOT IN ( '''', ''-1'')
									)
							)	

		DECLARE	@Icap AS VARCHAR(50)
		SET	@Icap = (SELECT	Icap
						FROM	EdiAccount (nolock)
						WHERE	ID IN (
									SELECT	MAX(ID)
									FROM	EdiAccount (nolock)
									WHERE	AccountNumber = @AccountNumber
									AND		UtilityCode = @UtilityCode
									AND		Icap IS NOT NULL
									AND		RTRIM(LTRIM(Icap)) != ''''
									AND		Icap > -1
									AND		IcapEffectiveDate <= CASE WHEN IcapEffectiveDate IS NULL THEN IcapEffectiveDate ELSE GETDATE() END
									)
							)	
		
		DECLARE	@Tcap AS VARCHAR(50)
		SET	@Tcap = (SELECT	Tcap
						FROM	EdiAccount (nolock)
						WHERE	ID IN (
									SELECT	MAX(ID)
									FROM	EdiAccount (nolock)
									WHERE	AccountNumber = @AccountNumber
									AND		UtilityCode = @UtilityCode
									AND		Tcap IS NOT NULL
									AND		RTRIM(LTRIM(Tcap)) != ''''
									AND		Tcap > -1
									AND		TcapEffectiveDate <= CASE WHEN TcapEffectiveDate IS NULL THEN TcapEffectiveDate ELSE GETDATE() END
									)
							)								
														
		SELECT	@ZoneCode AS ZoneCode, @LoadProfile AS LoadProfile, @RateClass as RateClass, @BillGroup as BillGroup, @Icap as Icap, @Tcap as Tcap

		SET NOCOUNT OFF;
END
' 
END
GO
