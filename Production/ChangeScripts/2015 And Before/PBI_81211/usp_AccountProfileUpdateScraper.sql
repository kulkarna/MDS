use [Libertypower]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * usp_AccountProfileUpdateScraper 
 * <Purpose,,> Update the Load Profile Id if mising  for Scraper Accounts. 
 *
 * History

 *******************************************************************************
 * 07/28/2015 - Manoj Thanath
 * Created.
 *******************************************************************************
 */

 CREATE PROC usp_AccountProfileUpdateScraper
       @AccountNumber VARCHAR(30)
AS 
BEGIN
    SET NOCOUNT ON;
		select	*
		INTO	#A
		from	Libertypower..Account (nolock)
		where	DateCreated > '1/1/2013' 
		AND		Utilityid=18 -- For Coned, get the profile from the scraper
		AND		(LoadProfile = '' 
		OR		LoadProfile is Null)
		And     AccountNumber = @AccountNumber -- Input Argument

		--drop table #P

		IF @@ROWCOUNT >  0
		   BEGIN
				SELECT	distinct a.*, e.StratumVariable AS SV, e.ServiceClass, e.Created, a.LoadProfile as  NewProfile
				into	#P
				from	#A a (nolock)
				inner	join lp_transactions..ConedAccount e (nolock)
				on		a.AccountNumber=e.AccountNumber
				and		e.StratumVariable is not null
				and		e.StratumVariable <> ''
				AND		e.ServiceClass is not null
				AND		e.ServiceClass <> ''

				select	AccountID, MAX(Created) as MAxDAte 
				into	#MaxDate
				from	#P
				group	by AccountID

				SELECT	p.AccountID, p.AccountNumber, p.UtilityID, p.LoadProfile, p.LoadProfileRefID, p.SV, p.ServiceClass, p.NewProfile
				into	#Profiles
				from	#P p
				inner	join #MaxDate d
				on		p.AccountID=d.AccountID
				and		p.Created=d.MAxDAte

				-- For CONED accounts, the profile = service mappingID + - + stratum end
				Update	p
				SET		p.NewProfile = s.LoadShapeServiceClass
				from	#Profiles p
				inner	Join UtilityStratumServiceClassMapping  s
				On		p.ServiceClass = s.CustomerServiceClass

				Delete	p
				from	#Profiles p
				WHERE	LTRim(RTRIM(p.NewProfile)) = ''

				select	p.AccountID, MIN(StratumEnd) as StratumEnd
				INTO	#StratumEnd
				from	#Profiles p
				inner	join UtilityStratumRange r
				On		p.NewProfile = r.ServiceRateClass
				and		p.SV <= r.StratumEnd
				Group	by p.AccountID

				Update	p
				SET		p.NewProfile = p.NewProfile + '-' + cast(s.StratumEnd as VArchar(20))
				--select	p.AccountID,  cast(s.StratumEnd as VArchar(20)) ,s.StratumEnd, CONVERT(varchar(50), s.StratumEnd)
				from	#Profiles p
				inner	Join #StratumEnd  s
				On		p.AccountID = s.AccountID
				where	s.StratumEnd<>99999999

				Update	p
				SET		p.NewProfile = p.NewProfile + '-99999999'
				from	#Profiles p
				inner	Join #StratumEnd  s
				On		p.AccountID = s.AccountID
				where	s.StratumEnd=99999999

				--drop table #NewProfiles
				SELECT	distinct a.*, u.UtilityCode, exM.InternalRefID, exM.InternalRef
				into	#NewProfiles
				FROM	#Profiles a
				Inner	Join Utility u
				on		a.UtilityID = u.ID
				INNER	Join vw_ExternalEntityMapping exM
				ON		exM.ExtEntityPropertyID=2
				AND		exM.ExtEntityTypeID=2
				AND		exM.ExtEntityName = u.UtilityCode
				AND		exM.ExtEntityValue = NewProfile
				AND		exM.ExtEntityValueInactive=0

				Update	a
				SET		a.LoadProfile = p.NewProfile,
						a.LoadProfileRefID=isnull(p.InternalRefID,0),
						a.Modified=GETDATE()
				FRom	Account a
				Inner	Join #NewProfiles p
				on		a.AccountID=p.AccountID

				SELECT ID  = 1;
		 END
END
