USE [lp_transactions]
GO
/****** Object:  StoredProcedure [dbo].[usp_UtilitySelectByDuns]    Script Date: 05/16/2016 13:43:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
ALTER PROCEDURE [dbo].[usp_UtilitySelectByDuns]  
@Duns Varchar (50)  
AS  
BEGIN  
    SET NOCOUNT ON;  
      
 SELECT I.ID,d.UtilityCode, d.MarketCode, f.FieldDelimiter,f.RowDelimiter  
 FROM UtilityDuns d  
 INNER JOIN UtilityFileDelimiters f  
 ON  d.UtilityCode = f.UtilityCode 
 inner join lp_transactions..Utility(NOLOCK)I
 on d.utilityCode=I.UtilityCode 
 WHERE d.DunsNumber = @Duns  
  
  
    SET NOCOUNT OFF;  
END  
-- Copyright 2010 Liberty Power  
  