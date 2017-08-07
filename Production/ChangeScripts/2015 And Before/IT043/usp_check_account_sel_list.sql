USE [lp_enrollment]
GO
/****** Object:  StoredProcedure [dbo].[usp_check_account_sel_list]    Script Date: 08/17/2012 09:50:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Modified: Sofia Melo 10/15/2010
-- add field term_months in select 
-- Ticket 18983
-- =============================================
-- Modified: Eric Hernandez 11/15/2010
-- Removed unnecessary code in order to improve performance
-- =============================================
-- Modified: Isabelle Tamanini 06/06/2011
-- Added Days_Aging to the select clause
-- =============================================
-- =============================================
-- Modified: Jaime Forero 11/30/2011
-- Refactored for new schema
-- =============================================

-- create table check_account_log (alert varchar(100), dt datetime)
-- exec usp_check_account_sel_list @p_username=N'libertypower\dmarino'
-- exec usp_check_account_sel_list @p_username=N'libertypower\dmarino',@p_view=N'ALL',@p_rec_sel=N'50',@p_contract_nbr_filter=N'NONE',@p_account_id_filter=N'NONE',@p_account_number_filter=N'NONE',@p_check_type_filter=N'NONE',@p_check_request_id_filter=N'NONE', 'TNONE'
-- exec usp_check_account_sel_list @p_username=N'LIBERTYPOWER\dmarino',@p_view=N'ACCEPTED',@p_rec_sel=N'50',@p_contract_nbr_filter=N'NONE',@p_account_id_filter=N'NONE',@p_account_number_filter=N'NONE',@p_check_type_filter=N'ALL',@p_check_request_id_filter=N'NONE' 

/*

exec usp_check_account_sel_list 
@p_username=N'LIBERTYPOWER\dmarino',
@p_view=N'PENDING', -- @p_view=N'ACCEPTED',
@p_rec_sel=N'0',
@p_contract_nbr_filter=N'2012-0009298',
@p_account_id_filter=N'NONE',
@p_account_number_filter=N'NONE',
@p_check_type_filter=N'PRICE VALIDATION',
@p_check_request_id_filter=N'NONE' ,
@p_request_id = 'NONE'
;


exec usp_check_account_sel_list_JFORERO 
@p_username=N'LIBERTYPOWER\dmarino',
@p_view=N'PENDING', -- @p_view=N'ACCEPTED',
@p_rec_sel=N'0',
@p_contract_nbr_filter=N'2012-0009298',
@p_account_id_filter=N'NONE',
@p_account_number_filter=N'NONE',
@p_check_type_filter=N'PRICE VALIDATION',
@p_check_request_id_filter=N'NONE' ,
@p_request_id = 'NONE'
;


-- drop table #check_account
*/

 
ALTER procedure [dbo].[usp_check_account_sel_list]
(@p_username                                        nchar(100),
 @p_check_type_filter                               varchar(50) = 'NONE',
 @p_account_id_filter                               char(12) = 'NONE',
 @p_account_number_filter                           varchar(30) = 'NONE',
 @p_contract_nbr_filter                             char(12)= 'NONE',
 @p_check_request_id_filter                         char(25)= 'NONE',
 @p_view                                            varchar(50) = 'ALL',
 @p_rec_sel                                         int = 50,
 @p_request_id                                      varchar(50) = 'NONE')
as

DECLARE @pIsIT043InUse BIT
SELECT @pIsIT043InUse = LibertyPower.dbo.ufn_GetApplicationFeatureSetting ('IT043','EnrollmentApp')

IF(@pIsIT043InUse = 1)
BEGIN
	
	EXEC [LibertyPower].[dbo].[usp_WIPTaskSelect] @p_username, @p_check_type_filter, @p_contract_nbr_filter,
			@p_check_request_id_filter, @p_view, @p_rec_sel, @p_request_id

END
ELSE
BEGIN

	Declare @filtered bit
	Set @filtered = 0

	-- There are many records in our DB with these statuses.  Returning them all can cause considerable slowdown.  
	IF (@p_rec_sel = 0 AND @p_view in ('APPROVED','REJECTED') )  
	 SET @p_rec_sel = 200  
	ELSE  
	 SET @p_rec_sel = 10000  


	/* New LUCA */
	CREATE TABLE #check_account(
		[contract_nbr] [char](12) NOT NULL,
		[account_number] [varchar](1) NOT NULL,
		[account_id] [char](12) NOT NULL,
		[check_type] [varchar](30) NOT NULL,
		[check_request_id] [char](25) NOT NULL,
		[approval_status] [char](15) NOT NULL,
		[approval_status_date] [datetime] NOT NULL,
		[approval_comments] [varchar](max) NOT NULL,
		[approval_eff_date] [datetime] NOT NULL,
		[origin] [varchar](50) NOT NULL,
		[userfield_text_01] [varchar](50) NOT NULL,
		[userfield_text_02] [varchar](50) NOT NULL,
		[userfield_date_03] [datetime] NOT NULL,
		[userfield_text_04] [varchar](50) NOT NULL,
		[userfield_date_05] [datetime] NOT NULL,
		[userfield_date_06] [datetime] NOT NULL,
		[userfield_amt_07] [float] NOT NULL,
		[username] [nchar](100) NOT NULL,
		[date_created] [datetime] NOT NULL,
		[days_aging] [int] NULL
	) ON [PRIMARY]

	  
	  
	--set rowcount @p_rec_sel  


	/* New LUCA */
	If @filtered = 0 and @p_contract_nbr_filter <> 'NONE'
	 begin  
	--print '1'
		insert into #check_account
		SELECT  top (@p_rec_sel)   
		   a.contract_nbr,  
			  account_number = '',  
			  a.account_id,  
			  a.check_type,  
			  a.check_request_id,  
			  a.approval_status, a.approval_status_date,  
			  a.approval_comments,  
			  a.approval_eff_date,  
			  a.origin,  
			  a.userfield_text_01, a.userfield_text_02, a.userfield_date_03, a.userfield_text_04, a.userfield_date_05, a.userfield_date_06, a.userfield_amt_07,  
			  a.username,  
			  a.date_created,  
			  days_aging = case when a.approval_eff_date = '1900-01-01' then  
			  DATEDIFF(day, a.date_created, getdate())  
			   else  
				  DATEDIFF(day, a.date_created, a.approval_eff_date)  
			   end    
		FROM lp_enrollment..check_account a  WITH (NOLOCK)--with (NOLOCK INDEX = check_account_idx)  
		WHERE 
				(@p_check_request_id_filter = 'NONE' OR a.check_request_id = @p_check_request_id_filter)   
		AND		(a.contract_nbr = @p_contract_nbr_filter)   
		AND		(@p_check_type_filter = 'NONE' OR @p_check_type_filter = 'ALL' OR a.check_type = @p_check_type_filter)  
		AND		a.approval_status = case when @p_view = 'ALL' then a.approval_status else @p_view end   

		Set @filtered = 1
	end  



	/* New LUCA */
	If @filtered = 0 and @p_view <> 'ALL' 
	 begin  
	--print '2'
		insert into #check_account
		SELECT  top (@p_rec_sel)   
		   a.contract_nbr,  
			  account_number = '',  
			  a.account_id,  
			  a.check_type,  
			  a.check_request_id,  
			  a.approval_status, a.approval_status_date,  
			  a.approval_comments,  
			  a.approval_eff_date,  
			  a.origin,  
			  a.userfield_text_01, a.userfield_text_02, a.userfield_date_03, a.userfield_text_04, a.userfield_date_05, a.userfield_date_06, a.userfield_amt_07,  
			  a.username,  
			  a.date_created,  
			  days_aging = case when a.approval_eff_date = '1900-01-01' then  
			  DATEDIFF(day, a.date_created, getdate())  
			   else  
				  DATEDIFF(day, a.date_created, a.approval_eff_date)  
			   end    
		FROM lp_enrollment..check_account a  WITH (NOLOCK)--with (NOLOCK INDEX = check_account_idx)  
		WHERE 
				(@p_check_request_id_filter = 'NONE' OR a.check_request_id = @p_check_request_id_filter)   
		AND		(@p_contract_nbr_filter = 'NONE' OR a.contract_nbr = @p_contract_nbr_filter)   
		AND		(@p_check_type_filter = 'NONE' OR @p_check_type_filter = 'ALL' OR a.check_type = @p_check_type_filter)  
		AND		a.approval_status = @p_view
		



		Set @filtered = 1
	end  


	/* New LUCA */
	If @filtered = 0
	 begin  
		insert into #check_account
		SELECT  top (@p_rec_sel)   
		   a.contract_nbr,  
			  account_number = '',  
			  a.account_id,  
			  a.check_type,  
			  a.check_request_id,  
			  a.approval_status, a.approval_status_date,  
			  a.approval_comments,  
			  a.approval_eff_date,  
			  a.origin,  
			  a.userfield_text_01, a.userfield_text_02, a.userfield_date_03, a.userfield_text_04, a.userfield_date_05, a.userfield_date_06, a.userfield_amt_07,  
			  a.username,  
			  a.date_created,  
			  days_aging = case when a.approval_eff_date = '1900-01-01' then  
			  DATEDIFF(day, a.date_created, getdate())  
			   else  
				  DATEDIFF(day, a.date_created, a.approval_eff_date)  
			   end  
		FROM lp_enrollment..check_account a  WITH (NOLOCK)--with (NOLOCK INDEX = check_account_idx)  
		WHERE 
				(@p_check_request_id_filter = 'NONE' OR a.check_request_id = @p_check_request_id_filter)   
		AND		(@p_contract_nbr_filter = 'NONE' OR a.contract_nbr = @p_contract_nbr_filter)   
		AND		(@p_check_type_filter = 'NONE' OR @p_check_type_filter = 'ALL' OR a.check_type = @p_check_type_filter)  
		AND		a.approval_status = case when @p_view = 'ALL' then a.approval_status else @p_view end   
	end  




	 --drop index #check_account.idx1
	 --Create clustered index idx1 on #check_account (contract_nbr) with fillfactor=100
	 --Create clustered index idx1 on #check_account () with fillfactor=100

	SELECT ContractID, Number  
	INTO #Contract  
	FROM LibertyPower..[Contract] C  
	JOIN #check_account CA ON C.Number = CA.contract_nbr 

	Create clustered index idx1 on #Contract (ContractID) with fillfactor=100


	DELETE FROM #check_account WHERE contract_nbr NOT IN
	(SELECT C.Number FROM LibertyPower..[Contract] C(NOLOCK)
	 JOIN LibertyPower..AccountExpanded E(NOLOCK) ON C.ContractID = E.ContractID WHERE E.ContractID IS NOT NULL  )

	-- We create this temp table in order to retrieve enrollment types at a contract level (which will be used below).  
	CREATE TABLE #contract_enrollment_type (contract_nbr char(12), enrollment_type varchar(50), term_months int )   
	  

	SELECT C.Number as contract_nbr,  ET.[Type] as enrollment_type, AC.AccountContractID
	into #t2
	FROM LibertyPower..Account A (NOLOCK)  
	JOIN LibertyPower..AccountDetail AD (NOLOCK) ON A.AccountID = AD.AccountID  
	JOIN LibertyPower..AccountContract AC (NOLOCK) ON A.AccountID = AC.AccountID AND A.CurrentContractID = AC.ContractID  
	JOIN #Contract C (NOLOCK) ON A.CurrentContractID = C.ContractID  
	JOIN LibertyPower..EnrollmentType ET (NOLOCK) ON AD.EnrollmentTypeID = ET.EnrollmentTypeID  

	WHERE A.CurrentContractID IS NOT NULL  
	AND  AD.EnrollmentTypeID IS NOT NULL  
	--GROUP BY C.Number   



	--select * from #t2

	/* New LUCA */
	SELECT acr.AccountContractID, MAX(acr.AccountContractRateID) AcID   
	into #t3_1
	FROM Libertypower..AccountContractRate (NOLOCK) acr
	join #t2 t (nolock) on t.AccountContractID = acr.AccountContractID
	WHERE acr.IsContractedRate = 0   
	GROUP BY acr.AccountContractID
	                       

	/* New LUCA */
	INSERT #contract_enrollment_type  
	SELECT t.contract_nbr,  MIN(T.[enrollment_type]) as enrollment_type,  
	CASE WHEN MIN(ISNULL(AC_DefaultRate.AccountContractRateID,0)) = 0 THEN MAX(ACR2.Term)  
				ELSE MAX(AC_DefaultRate.Term)   
				END AS term_months  
	FROM #t2 t (NOLOCK)  
	JOIN LibertyPower.dbo.AccountContractRate ACR2 WITH (NOLOCK) ON T.AccountContractID = ACR2.AccountContractID AND ACR2.IsContractedRate = 1  
	LEFT JOIN (SELECT ACR_1.* 
				FROM LibertyPower.dbo.AccountContractRate ACR_1 (NOLOCK) 
				JOIN 	 ( SELECT AcID   
						   FROM #t3_1 (NOLOCK) 
						  ) Z  ON ACR_1.AccountContractRateID = Z.AcID   
				) AC_DefaultRate ON AC_DefaultRate.AccountContractID = T.AccountContractID  
	GROUP BY T.contract_nbr   

	--INSERT #contract_enrollment_type  
	--SELECT t.contract_nbr,  MIN(T.[enrollment_type]) as enrollment_type,  
	--CASE WHEN MIN(ISNULL(AC_DefaultRate.AccountContractRateID,0)) = 0 THEN MAX(ACR2.Term)  
	--			ELSE MAX(AC_DefaultRate.Term)   
	--			END AS term_months  
	--FROM #t2 t (NOLOCK)  
	--JOIN LibertyPower.dbo.AccountContractRate ACR2 WITH (NOLOCK) ON T.AccountContractID = ACR2.AccountContractID AND ACR2.IsContractedRate = 1  
	--LEFT JOIN (SELECT ACR_1.* 
	--			FROM LibertyPower.dbo.AccountContractRate ACR_1 (NOLOCK) 
	--			JOIN 	 ( SELECT MAX(AccountContractRateID) AcID   
	--                       FROM Libertypower..AccountContractRate (NOLOCK) 
	--                       WHERE IsContractedRate = 0   
	--                       GROUP BY AccountContractID) Z  ON ACR_1.AccountContractRateID = Z.AcID   
	--			) AC_DefaultRate ON AC_DefaultRate.AccountContractID = T.AccountContractID  
	--GROUP BY T.contract_nbr   

	  
	  
	SELECT *, e.enrollment_type as EnrollmentType  
	FROM #check_account a  
	JOIN(SELECT check_type, [order] = max([order])  
		 FROM lp_common..common_utility_check_type WITH (NOLOCK) --with (NOLOCK INDEX = common_utility_check_type_idx)  
		 GROUP by check_type) b ON a.check_type = b.check_type  
	LEFT JOIN #contract_enrollment_type e ON a.contract_nbr = e.contract_nbr  
	-- LEFT JOIN #contract_term t ON a.contract_nbr = t.contract_nbr  
	ORDER BY a.date_created, e.enrollment_type, b.[order], a.approval_status_date  
	  
	  
	DROP Table #contract_enrollment_type  
	--insert into check_account_log select 'checkpoint5',getdate()  

END
