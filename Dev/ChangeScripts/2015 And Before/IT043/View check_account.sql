USE [lp_enrollment]
GO

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[check_account]'))
DROP VIEW [dbo].[check_account]
GO

sp_RENAME 'check_account_bak' , 'check_account'
GO

USE [lp_enrollment]
GO

sp_RENAME 'check_account' , 'check_account_bak'
GO

USE [lp_enrollment]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[check_account]
AS

SELECT C.Number    AS [contract_nbr]
	 , ''		   AS [account_id]
     , TT.TaskName AS [check_type]
     , [check_request_id] = case when cdt.DealType = 'New' then 'Enrollment'
							else cdt.DealType
							end
     , TS.StatusName  AS [approval_status]
     , WT.DateCreated AS [approval_status_date] 
     , ISNULL(WT.TaskComment, '')  AS [approval_comments]
     , ISNULL(WT.DateUpdated, '1900-01-01') AS [approval_eff_date]
     , [origin] = (SELECT TOP 1 Origin
				   FROM LibertyPower..Account A
				   JOIN LibertyPower..AccountContract AC ON A.AccountId = AC.AccountId
				   WHERE AC.ContractId = C.ContractId)
     , '' AS [userfield_text_01]
     , '' AS [userfield_text_02]
     , '1900-01-01 00:00:00.000' AS [userfield_date_03]
     , '' AS [userfield_text_04]
     , '1900-01-01 00:00:00.000' AS [userfield_date_05]
     , '1900-01-01 00:00:00.000' AS [userfield_date_06]
     , '0' AS [userfield_amt_07]
     , ISNULL(WT.UpdatedBy, WT.CreatedBy) AS [username]
     , WT.DateCreated AS [date_created]
	 , 0 AS [chgstamp]
  FROM LibertyPower..WIPTaskHeader    WTH (NOLOCK)   
  JOIN LibertyPower..WIPTask	      WT  (NOLOCK) ON WTH.WIPTaskHeaderId = WT.WIPTaskHeaderId
  JOIN LibertyPower..WorkflowTask     WFT (NOLOCK) ON WT.workflowtaskid = WFT.workflowtaskid
  JOIN LibertyPower..TaskStatus       TS  (NOLOCK) ON WT.TaskStatusId = TS.TaskStatusId
  JOIN LibertyPower..TaskType         TT  (NOLOCK) ON WFT.TaskTypeId = TT.TaskTypeId
  JOIN LibertyPower..[Contract]       C   (NOLOCK) ON WTH.ContractId = C.ContractId
  JOIN LibertyPower..ContractDealType CDT (NOLOCK) ON C.ContractDealTypeID = CDT.ContractDealTypeID


GO






