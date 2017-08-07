
USE [Workspace]
GO

Create Procedure [dbo].[usp_ISTA814EDIDataValidation]  --'02310423537001'
AS
BEGIN
BEGIN TRY

SET NOCOUNT ON;

DECLARE @AccountNumber NVARCHAR(100) 
DECLARE @AuditRunId NVARCHAR(100)
DECLARE @FromDate Datetime
DECLARE @ToDate Datetime

--SET @ =AccountNumber '02310423537001'

Select top 1 @AuditRunId=ID,@FromDate=FromDate, @ToDate=Todate
from Workspace.dbo.AuditRunEdiAccount_814 with(nolock)
order by Id desc


IF OBJECT_ID('tempdb..#RecordForProcess') IS NOT NULL
       DROP TABLE #RecordForProcess

CREATE TABLE #RecordForProcess 
(
       Id INT IDENTITY(1,1) NOT NULL,
       EsiId Varchar(100) NOT NULL,
)

Insert into #RecordForProcess (EsiId)
SELECT  S.EsiId
FROM
       ISTA.dbo.tbl_814_Header (NOLOCK) H
       INNER JOIN ISTA.dbo.tbl_814_Name (NOLOCK) N
              ON H.[814_Key] = N.[814_Key]
       INNER JOIN ISTA.dbo.tbl_814_Service (NOLOCK) S
              ON S.[814_Key] = H.[814_Key]
WHERE
      ISNULL(S.EsiId,'')!='' and 
         H.ProcessDate between @FromDate and @ToDate
Group by S.EsiId

DECLARE @RECORDCOUNT int
DECLARE @WHILELOOPCOUNT int
SET @WHILELOOPCOUNT=1
Select @RECORDCOUNT=Count(1) from #RecordForProcess

       WHILE ( @WHILELOOPCOUNT <= @RECORDCOUNT)
       BEGIN
              Select @AccountNumber=EsiId from #RecordForProcess (nolock) where Id= @WHILELOOPCOUNT;
              
			  EXEC usp_ISTA814EDIValidation_V1 @AccountNumber, @AuditRunId, @FromDate, @ToDate

              SET @WHILELOOPCOUNT=@WHILELOOPCOUNT+1;
       END
END TRY
BEGIN CATCH



              SELECT ERROR_NUMBER() AS ErrorNumber
                     ,ERROR_SEVERITY() AS ErrorSeverity
                     ,ERROR_STATE() AS ErrorState
                     ,ERROR_PROCEDURE() AS ErrorProcedure
                     ,ERROR_LINE() AS ErrorLine
                     ,ERROR_MESSAGE() AS ErrorMessage;
END CATCH
SET NOCOUNT OFF;
END
