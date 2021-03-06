
USE [lp_commissions]
GO

BEGIN TRANSACTION _STRUCTURE_
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO
-- ===================================
-- Created By: Gail Mangaroo 
-- Created Date: 3/6/2012
-- ===================================
CREATE PROC [dbo].[usp_vendor_rate_setting_sel_by_vendor] 
(
@p_vendor_id int 
) 
AS 

BEGIN 
	
	SELECT r.*
	FROM [lp_commissions].[dbo].[vendor_rate] r (NOLOCK)
	WHERE r.vendor_id = @p_vendor_id 
		-- AND r.inactive_ind = 0 
		
	ORDER BY r.[rate_vendor_type_id],r.[rate_type_id],r.[transaction_type_id]
END
GO

IF @@ERROR<>0 OR @@TRANCOUNT=0 BEGIN IF @@TRANCOUNT>0 ROLLBACK SET NOEXEC ON END
GO

IF @@TRANCOUNT>0
	COMMIT TRANSACTION _STRUCTURE_
GO

SET NOEXEC OFF
GO
