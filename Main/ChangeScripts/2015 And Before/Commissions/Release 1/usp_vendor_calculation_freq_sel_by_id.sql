USE lp_commissions
GO 

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'usp_vendor_calculation_freq_sel_by_id')
	DROP  Procedure  usp_vendor_calculation_freq_sel_by_id
GO

/*
**********************************************************************
* 3/30/2010 Created
* Gail Mangaroo 
* Get all vendor calculation freq setting
**********************************************************************

*/
CREATE Procedure usp_vendor_calculation_freq_sel_by_id
(@p_freq_id int ) 
AS
BEGIN 

	SELECT *
  FROM [lp_commissions].[dbo].[vendor_calculation_freq] (NOLOCK)
  WHERE freq_id = @p_freq_id 
  
END 
GO
