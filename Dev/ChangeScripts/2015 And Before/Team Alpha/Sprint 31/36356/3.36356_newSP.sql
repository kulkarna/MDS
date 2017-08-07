---------------------------------------------------------------------------------------------------
--New SP to get the current contract number or Account Number
--5/21/2014 36356 Unsubmitted Deals
--------------------------------------------------------------------------------------------------
USE [Lp_deal_capture]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetCurrentContractNumberbyContractNumber_Select]    Script Date: 05/20/2014 15:23:01 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_GetCurrentContractNumberbyContractNumber_Select]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_GetCurrentContractNumberbyContractNumber_Select]
GO

USE [Lp_deal_capture]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetCurrentContractNumberbyContractNumber_Select]    Script Date: 05/20/2014 15:23:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*
*
* PROCEDURE:	[usp_GetCurrentContractNumberbyContractNumber_Select]
*
* DEFINITION:  Get the top 1 CurrentContractNumber from Contract Number
*
* RETURN CODE: Returns the CurrentContractNumber from Contract Number
*
* REVISIONS:	Sara lakshamanan 5/20/2014
*/

CREATE PROCEDURE [dbo].[usp_GetCurrentContractNumberbyContractNumber_Select]
	 @p_ContractNumber varchar(50)
AS
BEGIN

SET NOCOUNT ON

                                                                                                                                       
Select Top 1 C.CurrentContAcc, C.CurrentNumber from  Lp_deal_capture..deal_contract C with (NoLock)
where
C.contract_nbr=@p_ContractNumber
order BY C.date_created desc


Set NOCOUNT OFF;
END

GO


---------------------------------------------------------------------------------------------------------

