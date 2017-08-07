USE [lp_enrollment]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =======================================
-- Created 05/31/2012 Isabelle Tamanini
-- Autoapproves the POR contracts in credit check step
-- IT043
-- =======================================

CREATE PROCEDURE [dbo].[usp_ApproveCreditCheckForPOR]
	@contract_nbr as varchar(30)
AS
BEGIN
	
	DECLARE @check_request_id VARCHAR(25)
	DECLARE @comment          NVARCHAR(100)
	DECLARE @process_id       VARCHAR(50)
	DECLARE @approval_status  CHAR(15)
		
	SET @check_request_id = (SELECT TOP 1 check_request_id
							 FROM lp_enrollment..check_account
							 WHERE contract_nbr = @contract_nbr)
	
	
	IF EXISTS (
				SELECT *
				FROM LibertyPower..Account a
				JOIN LibertyPower..Contract c ON a.CurrentContractID = c.ContractID
				LEFT JOIN lp_common..service_rate_class sc ON a.ServiceRateClass = sc.service_rate_class
				LEFT JOIN LibertyPower..CreditPoR por ON sc.service_rate_class_id = por.ServiceClassID
				WHERE c.Number = @contract_nbr
				AND (por.IsPoRAvailable = 0 OR por.IsPoRAvailable IS NULL)
			  )
	BEGIN
		SET @comment = 'Credit Check step could not be autoapproved, there are non POR accounts in the contract.'
		SET @approval_status = 'INCOMPLETE'	
	END
	ELSE
	BEGIN
		SET @comment = 'POR Market/Utilities are automatically approved by the system when the credit check step is enabled for automatic processing.'
		SET @approval_status = 'APPROVED'
	END
	
	IF @check_request_id <> 'RENEWAL'
	BEGIN
		EXEC lp_enrollment.dbo.usp_check_account_approval_reject @p_username = N'System', @p_check_request_id = @check_request_id, @p_contract_nbr = @contract_nbr, @p_account_id = N'NONE', @p_account_number = N' ', @p_check_type = N'CREDIT CHECK', @p_approval_status = @approval_status, @p_comment = @comment
	END
	ELSE
	BEGIN
		EXEC lp_enrollment.dbo.usp_check_account_renewal_approval_reject @p_username = N'System', @p_check_request_id = @check_request_id, @p_contract_nbr = @contract_nbr, @p_account_id = N'NONE', @p_account_number = N' ', @p_check_type = N'CREDIT CHECK', @p_approval_status = @approval_status, @p_comment = @comment
	END

END
