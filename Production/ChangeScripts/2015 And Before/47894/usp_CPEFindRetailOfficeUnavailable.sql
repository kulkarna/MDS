use lp_MtM
go

-- =============================================  
-- Author:  Felipe Medeiros  
-- Create date: 08/29/2013  
-- Description: Find if the problem was 'Retail Office Unavailable'
-- =============================================  
CREATE PROCEDURE [dbo].[usp_CPEFindRetailOfficeUnavailable]   
 @BatchNumber as varchar(100),  
 @QuoteNumber as varchar(100)  
AS  
BEGIN  
 SET NOCOUNT ON;  
  
 select   
  ExceptionId as Id, ExceptionDescription, ExceptionDump,   
  ExceptionTypeId, Severity, Source, BatchNumber, AccountId,  
  Internal, AdditionalInfo, ExpirationDate, DateCreated, CreatedBy  from MtMExceptionLog with (nolock)  
 where ExceptionTypeId = 6 
 and [Source] = @QuoteNumber  
 and BatchNumber = @BatchNumber
  
 SET NOCOUNT OFF;  
END  