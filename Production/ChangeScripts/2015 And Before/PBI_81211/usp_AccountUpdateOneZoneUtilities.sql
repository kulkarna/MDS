use [Libertypower]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*******************************************************************************
 * usp_AccountUpdateZone 
 * <Purpose,,> Update the Zone value if mising  for Accounts. 
 *
 * History

 *******************************************************************************
 * 07/28/2015 - Manoj Thanath
 * Created.
 *******************************************************************************
 */

CREATE PROC usp_AccountUpdateOneZoneUtilities
       @AccountNumber VARCHAR(30)
AS 
BEGIN
   SET NOCOUNT ON;
		-- Get the Utilities with one zone
		Select	z.utility_id, u.ID as UtilityID, max(zone) as zone, COUNT(*) as CT
		into	#Single_Zone_Utility
		from	lp_common..zone z (nolock)
		join	libertypower..utility u (nolock)
		on		z.utility_id = u.UtilityCode
		group	by z.utility_id, u.ID
		having	count(*) = 1

		-- Use this to check zone distribution among utilities
		select * from lp_common..zone (nolock) order by utility_id 
		select * from #Single_Zone_Utility order by utility_id 
				
		-- Make sure all the zones has a location ID reference
		--drop table #zones

		SELECT	z.*, p.ID as DeliveryLocationRefID
		INTO	#Zones
		FROM	#Single_Zone_Utility z
		Inner	Join PropertyInternalRef p (nolock)
		ON		utility_id + '-' + z.zone = p.Value
		
		--Select the row from the Account  table
		select	a.*, u.zone
		FROM	LibertyPower..Account a (nolock)
		JOIN	#Single_Zone_Utility u on a.UtilityID = u.UtilityID
		WHERE	a.Zone <> u.Zone 
		AND     a.AccountNumber = @AccountNumber

		--Update the Account table
		IF @@ROWCOUNT >  0
		     BEGIN 
				UPDATE	a
				SET		Zone = u.Zone,
						DeliveryLocationRefID = u.DeliveryLocationRefID,
						a.Modified = GETDATE ()
				FROM	LibertyPower..Account a
				JOIN	#Zones u on a.UtilityID = u.UtilityID
				WHERE	a.Zone <> u.Zone 
				AND     a.AccountNumber = @AccountNumber
			END


		----find the Utility Id  for the Account Passed in-
		Declare @UtilityId int;

		SELECT @UtilityId = UtilityID
		From LibertyPower..Account a
		WHERE a.AccountId = @AccountNumber
		
		--------------------------------------------------------------------------------------------
		-- Ameren
		--------------------------------------------------------------------------------------------
		--drop table #AMEREN
		-- HardCode AMEREN Zones to AMIL
		IF   @UtilityId = 11 --AMEREN
		     BEGIN
					SELECT	AccountID 
					INTO	#AMEREN
					FROM	Account a (nolock)
					WHERE	a.UtilityID = 11 -- AMEREN
					AND		(a.Zone <> 'AMIL' or (a.Zone is null))
					and a.DeliveryLocationRefID = 0
					and a.AccountNumber = @AccountNumber

					IF @@ROWCOUNT >  0
					  BEGIN
							UPDATE	a
							SET		a.ZONE = 'AMIL',
									a.DeliveryLocationRefID = 9,
									a.Modified = GETDATE ()
							FROM	Account a
							Inner	Join #AMEREN z
							ON		a.AccountID = z.AccountID
					 END
			 END
		 ELSE IF @UtilityId = 15 --CLP

				--------------------------------------------------------------------------------------------
				-- CL&P
				--------------------------------------------------------------------------------------------
				-- drop table #CLP
				BEGIN
					SELECT	AccountID 
					INTO	#CLP
					FROM	Account a (nolock)
					WHERE	a.UtilityID = 15 -- CLP
					AND		( (a.Zone <> 'CONNECTICUT' AND a.Zone <> 'CT') or (a.Zone is null) )
					and a.DeliveryLocationRefID = 0
					and a.AccountNumber = @AccountNumber

					
					IF @@ROWCOUNT >  0
					  BEGIN
						UPDATE	a
						SET		a.ZONE = 'CONNECTICUT',
								a.DeliveryLocationRefID = 16,
								a.Modified = GETDATE ()
						FROM	Account a
						Inner	Join #CLP z
						ON		a.AccountID = z.AccountID
                      END
				END

		 ELSE IF @UtilityId = 46 --UI
				--------------------------------------------------------------------------------------------
				-- UI
				--------------------------------------------------------------------------------------------
				-- drop table #UI
				BEGIN 
					SELECT	AccountID 
					INTO	#UI
					FROM	Account a (nolock)
					WHERE	a.UtilityID = 46 -- UI
					AND		( (a.Zone <> 'CONNECTICUT' AND a.Zone <> 'CT') or (a.Zone is null) )
					and a.DeliveryLocationRefID = 0
					and a.AccountNumber = @AccountNumber

					
					IF @@ROWCOUNT >  0
					  BEGIN
							UPDATE	a
							SET		a.ZONE = 'CONNECTICUT',
									a.DeliveryLocationRefID = 94,
									a.Modified = GETDATE ()
							FROM	Account a
							Inner	Join #UI z
							ON		a.AccountID = z.AccountID
					 END		
				END


		 ELSE IF @UtilityId = 12 --Bangor
		--------------------------------------------------------------------------------------------
	           BEGIN 
					-- drop table #Bangor
					SELECT	AccountID 
					INTO	#Bangor
					FROM	Account a (nolock)
					WHERE	a.UtilityID = 12 -- Bangor
					AND		( (a.Zone <> 'ME') or (a.Zone is null) )
					and a.DeliveryLocationRefID = 0
					and a.AccountNumber = @AccountNumber

					IF @@ROWCOUNT >  0
					  BEGIN
						UPDATE	a
						SET		a.ZONE = 'ME',
								a.DeliveryLocationRefID = 12,
								a.Modified = GETDATE ()
						FROM	Account a
						Inner	Join #Bangor z
						ON		a.AccountID = z.AccountID
					  END		
				END

		 ELSE IF @UtilityId = 48 --WMECO

		--------------------------------------------------------------------------------------------
				BEGIN 
					-- drop table #wmeco
					SELECT	AccountID 
					INTO	#wmeco
					FROM	Account a (nolock)
					WHERE	a.UtilityID = 48 -- WMECO
					AND		( (a.Zone <> 'WCMASS' AND a.Zone <> 'WCMA') or (a.Zone is null) )
					and a.DeliveryLocationRefID = 0
					and a.AccountNumber = @AccountNumber

					IF @@ROWCOUNT >  0
					  BEGIN
						UPDATE	a
						SET		a.ZONE = 'WCMASS',
								a.DeliveryLocationRefID = 97,
								a.Modified = GETDATE ()
						FROM	Account a
						Inner	Join #wmeco z
						ON		a.AccountID = z.AccountID
					 END
				END
		 ELSE IF @UtilityId = 61 --Dayton
		--------------------------------------------------------------------------------------------
		-- drop table #Dayton
		        BEGIN
					SELECT	AccountID 
					INTO	#Dayton
					FROM	Account a (nolock)
					WHERE	a.UtilityID = 61 -- Dayton
					AND		( (a.Zone <> 'DAYTON') or (a.Zone is null) )
					and a.DeliveryLocationRefID = 0
					and a.AccountNumber = @AccountNumber

					IF @@ROWCOUNT >  0
					  BEGIN
						UPDATE	a
						SET		a.ZONE = 'DAYTON',
								a.DeliveryLocationRefID = 27,
								a.Modified = GETDATE ()
						FROM	Account a
						Inner	Join #Dayton z
						ON		a.AccountID = z.AccountID
					 END
				END

		ELSE IF  @UtilityId = 23 --MECO
		--------------------------------------------------------------------------------------------
		-- drop table #meco
		       BEGIN
					SELECT	AccountID 
					INTO	#meco
					FROM	Account a (nolock)
					WHERE	a.UtilityID = 23 -- MECO
					AND		(isnull(a.Zone, '') = '')
					and a.DeliveryLocationRefID = 0
					and a.AccountNumber = @AccountNumber

					IF @@ROWCOUNT >  0
					  BEGIN
						UPDATE	a
						SET		a.ZONE = 'WCMASS',
								a.DeliveryLocationRefID = 97,
								a.Modified = GETDATE ()
						FROM	Account a
						Inner	Join #meco z
						ON		a.AccountID = z.AccountID
					END
				END
		 SELECT ID = @UtilityId;
END
		