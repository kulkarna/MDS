USE [Libertypower]
GO

/****** Object:  StoredProcedure [dbo].[usp_InitialAccountPropertyValuesInsert]    Script Date: 08/22/2013 15:41:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_InitialAccountPropertyValuesInsert]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_InitialAccountPropertyValuesInsert]
GO

USE [Libertypower]
GO

/****** Object:  StoredProcedure [dbo].[usp_InitialAccountPropertyValuesInsert]    Script Date: 08/22/2013 15:41:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================  
-- Author:  Jikku joseph John  
-- Create date: 07/18/2013  
-- Description: Initial filling of account property values history  
-- =============================================  
CREATE PROCEDURE [dbo].[usp_InitialAccountPropertyValuesInsert]  
 -- Add the parameters for the stored procedure here  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
    -- Insert statements for procedure here  
 
 SET NOCOUNT ON;  
 
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
 
 if OBJECT_ID('tempdb..#PROPERTYOUTPUT') is not null  
  drop table #PROPERTYOUTPUT  
 
 CREATE TABLE #PROPERTYOUTPUT (AccountPropertyHistoryID BIGINT PRIMARY KEY NONCLUSTERED, LockStatus VARCHAR(60), CreatedBy VARCHAR(256), DateCreated DATETIME)   
   
 
 DECLARE @CurrDate DateTime  
 SELECT @CurrDate = GETDATE()  
 
 BEGIN TRANSACTION  
 
 INSERT INTO AccountPropertyHistory(UtilityID,AccountNumber,FieldName,FieldValue,EffectiveDate,FieldSource,CreatedBy,DateCreated,LockStatus,Active)  
 OUTPUT INSERTED.AccountPropertyHistoryID, INSERTED.LockStatus,INSERTED.CreatedBy, INSERTED.DateCreated INTO #PROPERTYOUTPUT  
 --SELECT  DISTINCT rt.Utility, aphDriver.AccountNumber,rt.ResultantName, rt.ResultantValue,@CurrDate,'MappingAllElseFillDefaultValue', 'System',@CurrDate,'Unknown',1  
 SELECT   
	 Utility,  
	 AccountNumber,  
	 FieldName,  
	 FieldValue,  
	 EffectiveDate,  
	 'SystemInitialValue',  
	 'System',  
	 @CurrDate,   
	 'Unknown',  
	 1  
 FROM   dbo.TmpAccountPropertyHistory with (nolock)
   
 INSERT INTO AccountPropertyLockHistory (AccountPropertyHistoryID, LockStatus, CreatedBy, DateCreated)  
 SELECT AccountPropertyHistoryID, LockStatus, CreatedBy, DateCreated  
 FROM #PROPERTYOUTPUT
 order by AccountPropertyHistoryID  
 
 IF @@ERROR != 0        
  ROLLBACK        
 ELSE        
  COMMIT     
    truncate table TmpAccountPropertyHistory
 SET NOCOUNT OFF;    
END  
GO


