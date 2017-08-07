-- =============================================  
-- Author: Sofia Melo  
-- Create date: 2010-07-26  
-- Description: Create the procedure to get the Letter Queue  
-- =============================================  

-- exec libertypower..usp_LetterQueueSelect @DocumentTypeId=0,@letterStatus=N'ALL',@ContractNumber=N'',@orderBy=N'',@SortAscending=N''

CREATE PROCEDURE [dbo].[usp_LetterQueueSelect_BAK2]  
   
 @documentTypeId  int = 0,  
 @letterStatus varchar(20) = 'ALL',  
 @ContractNumber varchar(20) = '',  
 @orderBy varchar (50) = '',  
 @SortAscending varchar(5) = ''  
AS  
BEGIN
/*
DECLARE @documentTypeId  int		
DECLARE @letterStatus varchar(20)	 
DECLARE @ContractNumber varchar(20) 
DECLARE @orderBy varchar (50)		
DECLARE @SortAscending varchar(5)	
    
SET @documentTypeId = 0
SET @letterStatus	= 'ALL'
SET @ContractNumber = ''
SET @orderBy		= ''
SET @SortAscending  = ''  
*/   
	SET NOCOUNT ON;  

	SELECT a.LetterQueueID, a.Status, a.ContractNumber, a.AccountID, a.DocumentTypeID  
			,CONVERT(varchar(10), a.DateCreated, 110) as DateCreated  
			,CONVERT(varchar(10), a.ScheduledDate, 110) as ScheduledDate  
			,CONVERT(varchar(10), a.PrintDate, 110) as PrintDate  
			,a.Username, b.document_type_name, c.AccountNumber as AccountNumber, c.AccountIDLegacy, d.full_name as CustomerName  
	FROM [LetterQueue] a   
	JOIN lp_documents..document_type b on b.document_type_id = a.DocumentTypeId  
	JOIN Account c on c.AccountID = a.AccountID  
	JOIN lp_account..account_name d on c.AccountNameID = d.AccountNameID
	WHERE 1=1
	AND (@DocumentTypeId = 0	 OR a.DocumentTypeId = @documentTypeId)
	AND (@LetterStatus   = 'ALL' OR a.[Status] = @LetterStatus)
	AND (@ContractNumber = ''	 OR a.[ContractNumber] = @ContractNumber)
	ORDER BY a.ScheduledDate
   
	--case when @orderBy = 'BY SCHEDULED DATE' then  'a.ScheduledDate '  
	--  when @orderBy = 'BY DOCUMENT TYPE' then  'a.DocumentTypeId '  
	--else 'a.LetterQueueId '  
   
	SET NOCOUNT OFF;  
   
END  
  
  
  
  