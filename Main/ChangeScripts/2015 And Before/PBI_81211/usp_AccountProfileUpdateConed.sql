use [Libertypower]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * usp_AccountProfileUpdateConed 
 * <Purpose,,> Update the Load Profile Id if mising  for Coned Account. 
 *
 * History

 *******************************************************************************
 * 07/28/2015 - Manoj Thanath
 * Created.
 *******************************************************************************
 */

CREATE PROC usp_AccountProfileUpdateConed
       @AccountNumber VARCHAR(30)
AS 
BEGIN
    SET NOCOUNT ON;
		SELECT	AccountID, ServiceRateClass, CAST (StratumVariable AS FLOAT) AS StratumVariable
		into	#Account
		FROM	Account (nolock)
		Where	UtilityID = 18
		AND		isnumeric(LTRIM(RTRIM(ISNULL(StratumVariable,'')))) = 1
		And     AccountNumber = @AccountNumber -- Input Argument

		-- get the stratum end

		IF @@ROWCOUNT >  0
		   BEGIN
				SELECT	a.AccountId, m.LoadShapeServiceClass as ServiceMappingId, MIN(StratumEnd) as StratumEnd
				Into	#St
				from	#Account a
				INNER	Join UtilityStratumServiceClassMapping m (nolock)
				ON		a.ServiceRateClass = m.CustomerServiceClass
				INNER	Join UtilityStratumRange s  (nolock)
				ON		m.LoadShapeServiceClass = s.ServiceRateClass
				and		a.StratumVariable <= s.StratumEnd
				and		s.UtilityId = 18
				And     AccountId = @AccountNumber
				Group	by a.AccountID, m.LoadShapeServiceClass
				order	by a.AccountID, m.LoadShapeServiceClass

				--get the profile ID
				SELECt	AccountID, ServiceMappingId + '-' + CAST (CAST( StratumEnd AS INT)AS VARCHAR(50)) as LoadProfile, p.ID as LoadProfileRefId
				into	#toUpdate
				FROM	#St s
				Inner	Join PropertyInternalRef p (nolock)
				on		ServiceMappingId + '-' + CAST (CAST( StratumEnd AS INT)AS VARCHAR(50)) = p.Value

				-- Update the account table
				Update	a
				SET		a.LoadProfile = u.LoadProfile,
						a.LoadProfileRefID = u.LoadProfileRefId,
						a.Modified = GETDATE()
				FRom	Account a
				Inner	Join #toUpdate u
				on		a.AccountID = u.AccountID

				SELECT ID = 1;
		 END
	 SET NOCOUNT OFF;
END

