USE lp_commissions
GO

IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'usp_vendor_grace_period_sel_by_id')
	DROP  Procedure  usp_vendor_grace_period_sel_by_id
GO

/*
**********************************************************************
* 4/4/2012 Created
* Gail Mangaroo 
* Get vendor grace period settings
**********************************************************************

*/
CREATE Procedure usp_vendor_grace_period_sel_by_id
(@p_option_id int ) 
AS
BEGIN 

SELECT *
  FROM [lp_commissions].[dbo].[vendor_grace_period] (NOLOCK) 
  WHERE option_id = @p_option_id
	  
END 
GO