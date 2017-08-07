-- =============================================
-- Author:		Carlos Lima
-- Create Date: 2012-11-27
-- Description:	Returns a list of documents related to an exisitng LP account
-- =============================================
CREATE PROCEDURE [dbo].[ComplaintAccountDocumentsGet] 
	@AccountID varchar(50) = null ,
 	@ContractNumber varchar(50) = null,   
 	@UserName varchar(100) = '' 
AS
BEGIN
	SET NOCOUNT ON;

	EXEC [Lp_documents].[dbo].[usp_document_history_sel_by_acct_con]
								@p_account_id = @AccountID,
 								@p_contract_nbr = @ContractNumber,   
 								@p_user_name = @UserName
END
