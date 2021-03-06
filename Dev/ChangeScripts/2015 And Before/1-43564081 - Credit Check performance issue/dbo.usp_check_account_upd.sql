
USE [lp_enrollment]
GO

BEGIN TRANSACTION _STRUCTURE_
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO

 
ALTER PROCEDURE [dbo].[usp_check_account_upd]
(@p_username                                        VARCHAR(100),
 @p_contract_nbr                                    VARCHAR(50),
 @p_credit_score                                    REAL = 0,
 @p_credit_score_encrypted							NVARCHAR(512) = NULL,
 @p_credit_agency                                   VARCHAR(30) = 'NONE',
 @p_error                                           CHAR(01) = ' ' OUTPUT,
 @p_msg_id                                          CHAR(08) = ' ' OUTPUT,
 @p_descp                                           VARCHAR(250) = ' ' OUTPUT,
 @p_result_ind                                      CHAR(01) = 'Y')
AS

/*********************************************************************/
-- Modified By: Sheri Scott
-- Date:  12/19/2012
-- Description:  Changed update to update tables instead of view and 
--               removed update for the renewal view since all the 
--               accounts get updated by the first update.
/*********************************************************************/
 
DECLARE @w_error                                    CHAR(01)
DECLARE @w_msg_id                                   CHAR(08)
DECLARE @w_descp                                    VARCHAR(250)
DECLARE @w_return                                   INT
 
SELECT @w_error                                     = 'I'
SELECT @w_msg_id                                    = '00000001'
SELECT @w_descp                                     = ' '
SELECT @w_return                                    = 0

DECLARE @w_application                              VARCHAR(20)
SELECT @w_application                               = 'COMMON'

DECLARE @CreditAgencyID INT
SET @CreditAgencyID = (SELECT CreditAgencyID 
						 FROM Libertypower.dbo.CreditAgency (NOLOCK)
						WHERE UPPER(Name) = UPPER(@p_credit_agency))

    UPDATE Libertypower.dbo.Customer 
    SET CreditAgencyID = @CreditAgencyID,
		CreditScoreEncrypted = ISNULL(@p_credit_score_encrypted,CreditScoreEncrypted)
	WHERE CustomerID IN
	(
		SELECT A.CustomerID FROM Libertypower.dbo.Account A (NOLOCK)
		JOIN Libertypower.dbo.AccountContract AC (NOLOCK) ON AC.AccountID = A.AccountID
		JOIN Libertypower.dbo.Contract C (NOLOCK) ON C.ContractID = AC.ContractID
		AND C.Number = @p_contract_nbr
	)
	
	-- This is updating the same thing as the previous update.
	--update account_renewal set credit_agency = @p_credit_agency,
 --                  credit_score = @p_credit_score,
 --                  CreditScoreEncrypted = isnull(@p_credit_score_encrypted,CreditScoreEncrypted)
	--from lp_account..account_renewal 
	--where account_id in
	--(
	--	select account_id from lp_account..account where contract_nbr = @p_contract_nbr
	--	UNION 	
	--	select account_id from lp_account..account_renewal where contract_nbr = @p_contract_nbr
	--)

goto_select: 
 
if @w_error                                        <> 'N'
begin
   exec lp_common..usp_messages_sel @w_msg_id,
                                    @w_descp output,
                                    @w_application
end
 
if @p_result_ind                                    = 'Y'
begin
   select flag_error                                = @w_error,
          code_error                                = @w_msg_id,
          message_error                             = @w_descp
   goto goto_return
end
 
select @p_error                                     = @w_error,
       @p_msg_id                                    = @w_msg_id,
       @p_descp                                     = @w_descp
 
goto_return:
return @w_return
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO

IF @@TRANCOUNT>0
	COMMIT TRANSACTION _STRUCTURE_
GO

SET NOEXEC OFF
GO
