/****** Object:  StoredProcedure [dbo].[usp_RECONEDI_ListReconciliationHeader]    Script Date: 6/26/2014 4:21:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
 * usp_RECONEDI_ListReconciliationHeader
 * List all reconciliation header  
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
CREATE PROCEDURE [dbo].[usp_RECONEDI_ListReconciliationHeader]  
 @p_ReconID AS int = NULL  
AS  
BEGIN  
 SET NOCOUNT ON;  
  
    SELECT *   
 FROM RECONEDI_Header A (NOLOCK)  
    WHERE A.ReconID = ISNULL(@p_ReconID, ReconID)  
    ORDER BY 1 DESC
   
 SET NOCOUNT OFF;  
END  

GO
