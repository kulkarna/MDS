use [Libertypower]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * usp_AccountProfileUpdateEdi 
 * <Purpose,,> Update the Load Profile Id if mising  for Edi Accounts. 
 *
 * History

 *******************************************************************************
 * 07/28/2015 - Manoj Thanath
 * Created.
 *******************************************************************************
 */
CREATE PROC usp_AccountProfileUpdateEdi
       @AccountNumber VARCHAR(30)
AS 
BEGIN
     SET NOCOUNT ON;
	      
		select	*
		INTO	#A
		from	Libertypower..Account (nolock)
		where	DateCreated > '1/1/2013' 
		AND		Utilityid<>18 -- For Non Coned
		AND		(LoadProfile = '' 
		OR		LoadProfile is Null)
		AND     AccountNumber = @AccountNumber

		IF @@ROWCOUNT >  0
		   BEGIN 
				SELECT	distinct a.*, e.LoadProfile as EdiProfile, e.TimeStampInsert, u.WholeSaleMktID as ISO
				into	#P
				from	#A a (nolock)
				inner	join lp_transactions..EdiAccount e (nolock)
				on		a.AccountNumber=e.AccountNumber
				and		e.LoadProfile is not null
				and		e.LoadProfile <> ''
				Inner	Join Utility u (nolock)
				ON		e.UtilityCode=u.UtilityCode
				and		u.ID = a.UtilityID

				-- For Ercot Accounts, the profile should be only the first 2 sections of the whole string
				SELECT	AccountID, EdiProfile, SUBSTRING(ediProfile,0, CHARINDEX('_',ediProfile, charindex('_',ediprofile,0)+1)) as validEdiProfile
				INTO	#Ercot
				from	#P
				where	ISO = 'ERCOT'

				update p
				set		p.EdiProfile = e.validEdiProfile
				from	#P p 
				Inner	Join #Ercot e
				on		p.AccountID=e.AccountID

				select	AccountID, MAX(TimestampInsert) as MAxDAte 
				into	#MaxDate
				from	#P
				group	by AccountID

				SELECT	p.AccountID, p.AccountNumber, p.UtilityID, p.LoadProfile, p.LoadProfileRefID, p.EdiProfile, p.DateCreated
				into	#Profiles
				from	#P p
				inner	join #MaxDate d
				on		p.AccountID=d.AccountID
				and		p.TimeStampInsert=d.MAxDAte

				--drop table #NewProfiles
				SELECT	distinct a.*, u.UtilityCode, exM.InternalRefID, exM.InternalRef
				into	#NewProfiles
				FROM	#Profiles a
				Inner	Join Utility u
				on		a.UtilityID = u.ID
				LEFT	Join vw_ExternalEntityMapping exM
				ON		exM.ExtEntityPropertyID=2
				AND		exM.ExtEntityTypeID=2
				AND		exM.ExtEntityName = u.UtilityCode
				AND		exM.ExtEntityValue = EdiProfile
				AND		exM.ExtEntityValueInactive=0

				Update	a
				SET		a.LoadProfile = p.EdiProfile,
						a.LoadProfileRefID=isnull(p.InternalRefID,0),
						a.Modified=GETDATE()
				FRom	Account a
				Inner	Join #NewProfiles p
				on		a.AccountID=p.AccountID

				SELECT ID = 1;
			END
	SET NOCOUNT OFF;
END
