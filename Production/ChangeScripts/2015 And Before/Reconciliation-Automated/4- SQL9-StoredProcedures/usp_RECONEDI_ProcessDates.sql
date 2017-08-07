USE [lp_LoadReconciliation]
GO
/****** Object:  StoredProcedure [dbo].[usp_RECONEDI_HeaderInsert]    Script Date: 07/30/2014 10:55:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*******************************************************************************
 * usp_RECONEDI_ProcessDates
 * Insert header information.
 *  
 * History
 *******************************************************************************
 * 2014/07/30 - Felipe Medeiros
 * Created.
 */
CREATE procedure [dbo].[usp_RECONEDI_ProcessDates]      
AS    
    
SET NOCOUNT ON    
    
SELECT DISTINCT RunDate
FROM LP_MtM..MTMZainetDailyData D (NOLOCK)

SET NOCOUNT OFF
