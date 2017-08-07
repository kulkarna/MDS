

-- =============================================
-- Author:	Sofia Melo
-- Create date: 2010-07-26
-- Description:	Create the procedure to get the Letter Queue by id and docummentType
-- =============================================
CREATE PROCEDURE [dbo].[usp_LetterQueueSelectByAccount_id]
	@documentTypeId		int,
	@account_id			varchar(20)

AS

BEGIN
	SET NOCOUNT ON;

    SELECT
		a.LetterQueueID, a.[Status], a.ContractNumber, a.AccountID, a.DocumentTypeID, a.DateCreated, a.ScheduledDate, a.PrintDate, a.Username,
		b.document_type_name, 
		c.account_number		AS AccountNumber, 
		c.account_id, 
		d.full_name				AS CustomerName
	FROM LibertyPower..LetterQueue		a WITH (NOLOCK)
	JOIN lp_documents..document_type	b WITH (NOLOCK)		ON b.document_type_id = a.DocumentTypeId
	JOIN lp_account..account			c WITH (NOLOCK)		ON c.accountId = a.accountId
	JOIN lp_account..account_name		d WITH (NOLOCK)		ON (d.name_link = c.customer_name_link and d.account_id = c.account_id)
	WHERE c.account_id = @account_id
	AND a.DocumentTypeId = @documentTypeId
	ORDER BY a.[Status] DESC	--Order by reverse status so that "Scheduled" items bubble to the top for processing.

	SET NOCOUNT OFF;
END



GO
EXECUTE sp_addextendedproperty @name = N'VirtualFolder_Path', @value = N'LetterQueue', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'usp_LetterQueueSelectByAccount_id';

