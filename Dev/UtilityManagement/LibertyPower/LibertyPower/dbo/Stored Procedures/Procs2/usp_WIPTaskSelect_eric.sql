
-- =============================================
-- Created: Isabelle Tamanini 07/23/2012
-- Selects the WIP tasks
-- =============================================
-- Changed by Lev Rosenblum 10/31/2012 (MD084, pbi999)
-- Replace dbo.AccountContractRate onto dbo.vw_AccountContractRate
-- =============================================
/*
exec libertypower..[usp_WIPTaskSelect] @p_username=N'LIBERTYPOWER\itamanini',@p_view=null,@p_rec_sel=N'50',@p_contract_nbr_filter=N'20120337520',@p_check_type_filter=NULL,@p_check_request_id_filter=NULL
exec lp_enrollment..usp_check_account_sel_list @p_username=N'LIBERTYPOWER\dmarino',@p_view=N'ALL',@p_rec_sel=N'50',@p_contract_nbr_filter=N'none',@p_account_id_filter=N'NONE',@p_account_number_filter=N'NONE',@p_check_type_filter=N'ALL',@p_check_request_id_filter=N'NONE'
exec lp_enrollment..usp_check_account_sel_list_eric @p_username=N'LIBERTYPOWER\dmarino',@p_view=N'ALL',@p_rec_sel=N'50',@p_contract_nbr_filter=N'02795488',
													@p_account_id_filter=N'NONE',@p_account_number_filter=N'NONE',@p_check_type_filter=N'ALL',@p_check_request_id_filter=N'NONE'
*/ 

CREATE PROCEDURE [dbo].[usp_WIPTaskSelect_eric]
(@p_username                                        nchar(100)=null,
 @p_check_type_filter                               varchar(50)= null,
 @p_contract_nbr_filter                             char(12)= null,
 @p_check_request_id_filter                         char(25)= null,
 @p_view                                            varchar(50)= null,
 @p_rec_sel                                         int = 50,
 @p_request_id                                      varchar(50)= null,
 @p_WIPTaskId										int = null)
as

IF (@p_check_type_filter IN ('NONE', 'ALL'))
BEGIN
	SET @p_check_type_filter = NULL
END
IF (@p_contract_nbr_filter IN ('NONE', 'ALL'))
BEGIN
	SET @p_contract_nbr_filter = NULL
END
IF (@p_check_request_id_filter IN ('NONE', 'ALL'))
BEGIN
	SET @p_check_request_id_filter = NULL
END
IF (@p_view IN ('NONE', 'ALL'))
BEGIN
	SET @p_view = null
END
IF (@p_request_id IN ('NONE', 'ALL'))
BEGIN
	SET @p_request_id = NULL
END
IF (@p_rec_sel = 0)
BEGIN
	SET @p_rec_sel = 5000
END

DECLARE @TaskTypeID INT
IF (@p_check_type_filter IS NOT NULL)
BEGIN
	SELECT @TaskTypeID = TaskTypeID
	FROM LibertyPower..TaskType
	WHERE TaskName = @p_check_type_filter
END

DECLARE @TaskStatusID INT
IF (@p_view IS NOT NULL)
BEGIN
	SELECT @TaskStatusID = TaskStatusID
	FROM LibertyPower..TaskStatus
	WHERE StatusName = @p_view
END



CREATE TABLE #ContractTemp (ContractID INT)
DECLARE @ContractID INT

CREATE TABLE #WIP (WIPTaskHeaderID INT)  

IF @p_WIPTaskId is not null
BEGIN
	INSERT INTO #WIP  
	SELECT WT.WIPTaskHeaderID  
	FROM LibertyPower..WIPTask   WT  (NOLOCK)  
	JOIN LibertyPower..WorkflowTask     WFT (NOLOCK) ON WT.workflowtaskid = WFT.workflowtaskid  
	WHERE WT.WIPTaskId = @p_WIPTaskId

	INSERT INTO #ContractTemp  
	SELECT WTH.ContractID  
	FROM LibertyPower..WIPTaskHeader WTH (NOLOCK)     
	JOIN #WIP W ON WTH.WIPTaskHeaderID = W.WIPTaskHeaderID  
END

-- Here we create a temp table of Contract IDs to help the following query run faster.
ELSE IF @p_contract_nbr_filter IS NULL AND @TaskTypeID IS NOT NULL AND @TaskStatusID IS NOT NULL
BEGIN
	INSERT INTO #WIP
	SELECT WT.WIPTaskHeaderID
	FROM LibertyPower..WIPTask			WT  (NOLOCK)
	JOIN LibertyPower..WorkflowTask     WFT (NOLOCK) ON WT.workflowtaskid = WFT.workflowtaskid
	WHERE WFT.TaskTypeID = @TaskTypeID
	AND WT.TaskStatusID = @TaskStatusID

	INSERT INTO #ContractTemp
	SELECT WTH.ContractID
	FROM LibertyPower..WIPTaskHeader WTH (NOLOCK)   
	JOIN #WIP W ON WTH.WIPTaskHeaderID = W.WIPTaskHeaderID
END
ELSE IF @p_contract_nbr_filter IS NOT NULL
BEGIN
	INSERT INTO #ContractTemp
	SELECT ContractID
	FROM LibertyPower.dbo.Contract (NOLOCK)
	WHERE Number = @p_contract_nbr_filter
	
	SELECT @ContractID = ContractID
	FROM #ContractTemp
END
ELSE
BEGIN
	INSERT INTO #ContractTemp
	SELECT ContractID
	FROM LibertyPower.dbo.Contract (NOLOCK)
END


SELECT WTH.*
INTO #WIPTaskHeader
FROM #ContractTemp CT
JOIN LibertyPower..WIPTaskHeader WTH (NOLOCK) ON WTH.ContractID = CT.ContractID   


SELECT TOP (@p_rec_sel) 
	   C.Number [contract_nbr]
	 , '' as [account_number]
	 , '' as [account_id]
     , TT.TaskName AS [check_type]
     , [check_request_id] = case when cdt.DealType = 'New' then 'Enrollment'
							else cdt.DealType
							end
     , TS.StatusName  AS [approval_status]
     , WT.DateCreated AS [approval_status_date] 
     , ISNULL(WT.TaskComment, '')  AS [approval_comments]
     , ISNULL(WT.DateUpdated, '1900-01-01') AS [approval_eff_date]
     , '' AS [userfield_text_01]
     , '' AS [userfield_text_02]
     , '1900-01-01 00:00:00.000' AS [userfield_date_03]
     , '' AS [userfield_text_04]
     , '1900-01-01 00:00:00.000' AS [userfield_date_05]
     , '1900-01-01 00:00:00.000' AS [userfield_date_06]
     , '0' AS [userfield_amt_07]
     , ISNULL(wt.UpdatedBy, wt.CreatedBy) as [username]
     , WT.DateCreated AS [date_created]
	 , days_aging = case when isnull(wt.DateUpdated, convert(datetime, 0)) = convert(datetime, 0) then 
					  DATEDIFF(day, wt.DateCreated, getdate())  
				    else  
					  DATEDIFF(day, wt.DateCreated, wt.DateUpdated)  
				    end
	 , wt.WIPTaskId
	 , 1 as credit_ind
	 , W.WorkflowName
INTO #check_account
FROM #WIPTaskHeader					WTH (NOLOCK)
JOIN LibertyPower..WIPTask			WT  (NOLOCK) ON WTH.WIPTaskHeaderId = WT.WIPTaskHeaderId
JOIN LibertyPower..WorkflowTask     WFT (NOLOCK) ON WT.workflowtaskid = WFT.workflowtaskid
JOIN LibertyPower..TaskStatus       TS  (NOLOCK) ON WT.TaskStatusId = TS.TaskStatusId
JOIN LibertyPower..TaskType         TT  (NOLOCK) ON WFT.tasktypeid = TT.tasktypeid
JOIN LibertyPower..Workflow         W   (NOLOCK) ON WTH.WorkflowId = W.WorkflowId
JOIN LibertyPower..[Contract]       C   (NOLOCK) ON WTH.ContractId = C.contractid
JOIN LibertyPower..ContractDealType CDT (NOLOCK) ON C.ContractDealTypeID = CDT.ContractDealTypeID
--JOIN #ContractTemp CT ON C.ContractID = CT.ContractID
WHERE WT.IsAvailable = 1
AND WFT.IsDeleted = 0 -- ADDED TO MAKE SURE TO EXCLUDE WORKFLOW TASKS THAT HAVE BEEN DELETED SR 1-33971758
AND WFT.TaskTypeID = ISNULL(@TaskTypeID, WFT.TaskTypeID)
AND WT.TaskStatusID = ISNULL(@TaskStatusID, WT.TaskStatusID)
AND WT.WIPTaskId = ISNULL(@p_WIPTaskId, WT.WIPTaskId)
AND CDT.DealType = ISNULL(@p_check_request_id_filter, CDT.DealType)



SELECT ContractID, Number  
INTO #Contract  
FROM LibertyPower..[Contract] C  
JOIN #check_account CA ON C.Number = CA.contract_nbr 

Create clustered index idx1 on #Contract (ContractID) with fillfactor=100


DELETE FROM #check_account WHERE contract_nbr NOT IN
(SELECT C.Number FROM LibertyPower..[Contract] C(NOLOCK)
 JOIN LibertyPower..AccountExpanded E(NOLOCK) ON C.ContractID = E.ContractID WHERE E.ContractID IS NOT NULL  )

-- We create this temp table in order to retrieve enrollment types at a contract level (which will be used below).  
CREATE TABLE #contract_enrollment_type (contract_nbr char(12), enrollment_type varchar(50), term_months int, origin varchar(50) )   


SELECT C.Number as contract_nbr, ET.[Type] as enrollment_type, AC.AccountContractID, 'ONLINE' as Origin
into #t2
FROM #Contract C (NOLOCK)
JOIN #check_account CA (NOLOCK) ON C.Number = CA.contract_nbr
JOIN LibertyPower..AccountContract AC (NOLOCK) ON AC.ContractID = C.ContractID   
JOIN LibertyPower..Account A (NOLOCK) ON A.AccountId = AC.AccountId
									 AND ((A.CurrentContractId = AC.ContractId and CA.check_request_id = 'ENROLLMENT')
									    OR (A.CurrentRenewalContractId = AC.ContractId and CA.check_request_id = 'RENEWAL'))
JOIN LibertyPower..AccountDetail AD (NOLOCK) ON A.AccountID = AD.AccountID  
JOIN LibertyPower..EnrollmentType ET (NOLOCK) ON AD.EnrollmentTypeID = ET.EnrollmentTypeID  
WHERE A.CurrentContractID IS NOT NULL  
AND  AD.EnrollmentTypeID IS NOT NULL  


/* New LUCA */
SELECT acr.AccountContractID, MAX(acr.AccountContractRateID) AcID   
into #t3_1
FROM Libertypower..AccountContractRate (NOLOCK) acr
join #t2 t (nolock) on t.AccountContractID = acr.AccountContractID
join #check_account ca (nolock) on ca.contract_nbr = t.contract_nbr
WHERE acr.IsContractedRate = 0
OR ca.check_request_id = 'RENEWAL'
GROUP BY acr.AccountContractID
                       

/* New LUCA */
INSERT #contract_enrollment_type  
SELECT t.contract_nbr,  MIN(T.[enrollment_type]) as enrollment_type,  
CASE WHEN MIN(ISNULL(AC_DefaultRate.AccountContractRateID,0)) = 0 THEN MAX(ACR2.Term)  
			ELSE MAX(AC_DefaultRate.Term)   
			END AS term_months,
	    t.Origin
FROM #t2 t (NOLOCK)  
JOIN #check_account ca (nolock) on ca.contract_nbr = t.contract_nbr AND ca.check_request_id = 'RENEWAL'
JOIN LibertyPower.dbo.vw_AccountContractRate ACR2 WITH (NOLOCK) ON T.AccountContractID = ACR2.AccountContractID 
--															AND (ACR2.IsContractedRate = 1 )
LEFT JOIN (SELECT ACR_1.* 
			FROM LibertyPower.dbo.AccountContractRate ACR_1 (NOLOCK) 
			JOIN 	 ( SELECT AcID   
                       FROM #t3_1 (NOLOCK) 
                      ) Z  ON ACR_1.AccountContractRateID = Z.AcID   
			) AC_DefaultRate ON AC_DefaultRate.AccountContractID = T.AccountContractID  
GROUP BY T.contract_nbr, t.Origin    
  
SELECT a.*, 1 as [order], e.enrollment_type as EnrollmentType, e.term_months, e.origin
FROM #check_account a  
--JOIN(SELECT check_type, [order] = max([order])  
--     FROM lp_common..common_utility_check_type WITH (NOLOCK) 
--     GROUP by check_type) b ON a.check_type = b.check_type  
LEFT JOIN #contract_enrollment_type e ON a.contract_nbr = e.contract_nbr 
ORDER BY a.date_created, e.enrollment_type, a.approval_status_date  
  
  
DROP TABLE #contract_enrollment_type   
DROP TABLE #check_account

----------------------------------------------------------------------------------------------------------


