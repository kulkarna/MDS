USE [Lp_commissions]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_vendor_payment_option_sel_by_id]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[usp_vendor_payment_option_sel_by_id]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/*
**********************************************************************
* 8/15/2012 Created
* Gail Mangaroo 
* Get vendor payment options
**********************************************************************
*/
CREATE Procedure [dbo].[usp_vendor_payment_option_sel_by_id]
( @p_option_id int) 
AS
BEGIN 

	SELECT *
	FROM [lp_commissions].[dbo].[vendor_payment_option] vp (NOLOCK) 
	WHERE option_id = @p_option_id
	
END 
GO


