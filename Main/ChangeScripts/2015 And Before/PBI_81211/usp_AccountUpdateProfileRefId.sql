use [Libertypower]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * usp_AccountUpdateProfileRefId 
 * <Purpose,,> Update theProfile RefId if mising  for Accounts. 
 *
 * History

 *******************************************************************************
 * 07/28/2015 - Manoj Thanath
 * Created.
 *******************************************************************************
 */
CREATE PROC usp_AccountUpdateProfileRefId
       @AccountNumber VARCHAR(30)
AS 
BEGIN
      --2851 internal ref
      SET NOCOUNT ON;
		SELECT	distinct a.*, p.ID, p.Value
		INTO	#Internal
		FROM	Libertypower..Account a (nolock)
		Inner	Join Libertypower..Utility u (nolock)
		on		a.UtilityId = u.ID
		INNER	Join Libertypower..PropertyInternalRef p  (nolock)
		on		p.PropertyID = 2
		AND		p.Value = u.UtilityCode + '-' + a.LoadProfile
		where	a.LoadProfileRefID = 0
		AND		a.LoadProfile <> ''
		AND     AccountNumber = @AccountNumber -- Input Argument

		IF @@ROWCOUNT >  0
		     BEGIN 
				UPDATE	a
				SET		a.LoadProfileRefID = i.ID,
						a.Modified = GETDATE()
				FROM	Libertypower..Account a 
				INNER	Join #Internal i
				ON		i.AccountID = a.AccountID
			 END

		--external Ref
		SELECT	distinct a.*, pir.ID
		Into	#External
		from	Libertypower..Account a (nolock)
		Inner	Join Libertypower..Utility u (NOLOCK) 
		ON		a.UtilityID = u.ID
		Inner	Join Libertypower..WholesaleMarket w (NOLOCK) 
		ON		u.WholesaleMktId = w.WholesaleMktID
		INNER	JOIN LibertyPower..ExternalEntityValue eev (NOLOCK) 
		ON		eev.ExternalEntityID = w.ID
		INNER	JOIN LibertyPower..PropertyValue pv (NOLOCK) 
		ON		eev.PropertyValueID = pv.ID
		AND		pv.Value = a.LoadProfile
		INNER	Join LibertyPower..PropertyInternalRef pir (NOLOCK) 
		ON		pir.ID = pv.InternalRefID
		AND		pir.Value like u.UtilityCode + '-%'
		AND		pir.PropertyId=2
		where	a.LoadProfileRefID = 0
		AND		a.LoadProfile <> ''
		IF @@ROWCOUNT >  0
		     BEGIN 
				UPDATE	a
				SET		a.LoadProfileRefID = i.ID,
						a.Modified = GETDATE()
				FROM	Libertypower..Account a 
				INNER	Join #External i
				ON		i.AccountID = a.AccountID
		   END

		   SELECT ID = 1;
	 SET NOCOUNT OFF;
END
