use [Libertypower]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * usp_AccountProfileUpdateUI 
 * <Purpose,,> Update the Load Profile Id if mising  for UI Accounts. 
 *
 * History

 *******************************************************************************
 * 07/28/2015 - Manoj Thanath
 * Created.
 *******************************************************************************
 */
CREATE PROC usp_AccountProfileUpdateUI
       @AccountNumber VARCHAR(30)
AS 
BEGIN
      SET NOCOUNT ON;
			-- Obtain all UI account that do not have LoadProfile value populated
			select	*
			INTO	#A
			from	Libertypower..Account (nolock)
			where	1=1 
			AND		Utilityid = 46  -- UI accounts only
			AND		(LoadProfile = '' 
			OR		LoadProfile is Null)
			And     AccountNumber  = @AccountNumber -- Input Argument

			IF @@ROWCOUNT >  0
		      BEGIN 
					-- Obtain the Internal Reference ID for the LoadProfile; match value on ServiceRateClass
					--drop table #NewProfiles
					SELECT	distinct a.*, u.UtilityCode, exM.InternalRefID, exM.InternalRef
					into	#NewProfiles
					FROM	#A a
					Inner	Join Utility u
					on		a.UtilityID = u.ID
					LEFT	Join vw_ExternalEntityMapping exM
					ON		exM.ExtEntityPropertyID=2
					AND		exM.ExtEntityTypeID=2
					AND		exM.ExtEntityName = u.UtilityCode
					AND		exM.ExtEntityValue = A.ServiceRateClass
					AND		exM.ExtEntityValueInactive=0

					-- Update Account table to set LoadProfile = ServiceRateClass and the internal ref if for Load Profile

					Update	a
					SET		a.LoadProfile = a.ServiceRateClass,
							a.LoadProfileRefID=isnull(p.InternalRefID,0),
							a.Modified=GETDATE()
					FRom	Account a
					Inner	Join #NewProfiles p
					on		a.AccountID=p.AccountID
					where p.InternalRefID is not null
			 END
			 Select ID = 1;
	 SET NOCOUNT OFF;
END