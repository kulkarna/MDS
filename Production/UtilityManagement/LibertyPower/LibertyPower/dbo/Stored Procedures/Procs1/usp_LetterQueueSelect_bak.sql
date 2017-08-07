-- =============================================  
-- Author: Sofia Melo  
-- Create date: 2010-07-26  
-- Description: Create the procedure to get the Letter Queue  
-- =============================================  
CREATE PROCEDURE [dbo].[usp_LetterQueueSelect_bak]  
   
 @documentTypeId  int = 0,  
 @letterStatus varchar(20) = 'ALL',  
 @ContractNumber varchar(20) = '',  
 @orderBy varchar (50) = '',  
 @SortAscending varchar(5) = ''  
AS  
  
 declare @sqlquery as nvarchar(4000)   
  
BEGIN  
   
 SET NOCOUNT ON;  
    set @sqlquery = 'SELECT a.LetterQueueID, a.Status, a.ContractNumber, a.AccountID, a.DocumentTypeID  
        ,CONVERT(varchar(10), a.DateCreated, 110) as DateCreated  
        ,CONVERT(varchar(10), a.ScheduledDate, 110) as ScheduledDate  
        ,CONVERT(varchar(10), a.PrintDate, 110) as PrintDate  
        ,a.Username, b.document_type_name, c.account_number as AccountNumber, c.account_id, d.full_name as CustomerName  
      FROM [LetterQueue] a   
      join lp_documents..document_type b on b.document_type_id = a.DocumentTypeId  
      join lp_account..account c on c.accountId = a.accountId  
      join lp_account..account_name d on d.name_link = c.customer_name_link and d.account_id = c.account_id'  
   
 IF @DocumentTypeId <> 0  
  begin  
   set @sqlquery = @sqlquery + '    WHERE a.DocumentTypeId = ' + CONVERT(varchar, @documentTypeId) + ''   
  
   IF @LetterStatus <> 'ALL'  
   set @sqlquery = @sqlquery + '     AND a.[Status] = ''' + @LetterStatus + ''' '  
     
   IF @ContractNumber <> ''  
   set @sqlquery = @sqlquery + '     AND a.[ContractNumber] = ''' + @ContractNumber + ''' '  
  end  
 else  
  IF @LetterStatus <> 'ALL'  
  begin  
   set @sqlquery = @sqlquery + '    WHERE a.[Status] = ''' + @LetterStatus + ''' '  
     
   IF @ContractNumber <> ''  
   set @sqlquery = @sqlquery + '     AND a.[ContractNumber] = ''' + @ContractNumber + ''' '  
  end  
 else  
  IF @ContractNumber <> ''  
  set @sqlquery = @sqlquery + '     WHERE a.[ContractNumber] = ''' + @ContractNumber + ''' '  
    
   
 set @sqlquery = @sqlquery + ' ORDER BY ' +  
   
 case when @orderBy = 'BY SCHEDULED DATE' then  'a.ScheduledDate '  
   when @orderBy = 'BY DOCUMENT TYPE' then  'a.DocumentTypeId '  
 else 'a.LetterQueueId '  
 end  
   
 set @sqlquery = @sqlquery + ' ' + @SortAscending +''  
   
 print @sqlquery  
    
 EXEC sp_executesql @sqlquery   
   
 SET NOCOUNT OFF;  
   
END  
  
  
  
  