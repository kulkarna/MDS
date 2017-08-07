USE [lp_transactions]
GO
/****** Object:  StoredProcedure [dbo].[usp_EdiAccountGetLatest]    Script Date: 10/09/2013 13:20:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

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
									AND		RTRIM(LTRIM(ZoneCode)) != ''
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
										AND		RTRIM(LTRIM(LoadProfile)) != ''
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
									AND		RTRIM(LTRIM(RateClass)) != ''
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
									AND		RTRIM(LTRIM(BillGroup)) NOT IN ( '', '-1')
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
									AND		RTRIM(LTRIM(Icap)) != ''
									AND		Icap > -1
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
									AND		RTRIM(LTRIM(Tcap)) != ''
									AND		Tcap > -1
									)
							)								
														
		SELECT	@ZoneCode AS ZoneCode, @LoadProfile AS LoadProfile, @RateClass as RateClass, @BillGroup as BillGroup, @Icap as Icap, @Tcap as Tcap

		SET NOCOUNT OFF;
END
