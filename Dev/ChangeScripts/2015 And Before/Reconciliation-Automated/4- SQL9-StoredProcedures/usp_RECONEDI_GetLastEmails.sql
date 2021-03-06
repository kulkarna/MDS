/****** Object:  StoredProcedure [dbo].[usp_RECONEDI_GetLastEmails]    Script Date: 6/26/2014 4:21:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
 * usp_RECONEDI_GetLastEmails
 * Get the last Email ID used. 
 * 
 * History
 *******************************************************************************
 * 2014/04/01 - Felipe Medeiros
 * Created.
 *******************************************************************************
 * <Date Modified,date,> - <Developer Name,,>
 * <Modification Description,,>
 *******************************************************************************
 */
CREATE PROCEDURE [dbo].[usp_RECONEDI_GetLastEmails]   
AS  
BEGIN  
 SET NOCOUNT ON;   
  
    -- Insert statements for procedure here  
 SELECT top 1 EmailList 
 FROM RECONEDI_Header (nolock)
 WHERE EmailList IS NOT NULL ORDER BY ReconID DESC  
   
 SET NOCOUNT OFF;  
END  

GO
