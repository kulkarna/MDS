USE [lp_mtm]
GO
/****** Object:  StoredProcedure [dbo].[usp_MtMViewLogs]    Script Date: 12/11/2013 11:38:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* **********************************************************************************************
*    Author:           Cghazal                                                                                                                 *
*    Created:    10/10/2011                                                                                                        *
*    Descp:            view logs for a batch/quote number                                                                    *
*    Modified:   10/15/2013  - Gail Mangaroo                                                                                             *
********************************************************************************************** */
ALTER PROCEDURE [dbo].[usp_MtMViewLogs] (
            @BatchNumber AS VARCHAR(50),
            @QuoteNumber AS VARCHAR(50)
)

AS

BEGIN

SET NOCOUNT ON; 

      SELECT      DISTINCT
                  ID, Description, Type, DateCreated
      FROM	 MtMTracking (nolock)
      WHERE (QuoteNumber = @QuoteNumber
      AND         BatchNumber = @BatchNumber)
      OR          (Description like '%' + @BatchNumber + '%' + @QuoteNumber + '%')
      
      UNION 
      
      SELECT      DISTINCT
                  ID = ExceptionId 
                  , Description = ExceptionDescription
                  , Type = case when Severity = 0 or Severity = 3 then 'I' -- None,Information
                                -- when Severity = 1 or Severity = 2 then 'F' -- Warning,Error
                              else 'F'
                              end 
              
                  , DateCreated
      FROM  MtMExceptionLog (nolock)
      WHERE BatchNumber = @BatchNumber
            OR    ExceptionDescription like '%' + @BatchNumber + '%'
            OR    ExceptionDescription like '%' + @QuoteNumber + '%'
            OR    AdditionalInfo like '%' + @QuoteNumber + '%'
            
      ORDER BY DateCreated 
      
 SET NOCOUNT OFF; 
 
END

