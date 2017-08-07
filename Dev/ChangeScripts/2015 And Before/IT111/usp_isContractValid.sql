USE [Lp_documents]
GO

/****** Object:  StoredProcedure [dbo].[usp_IsContractNumberValid]    Script Date: 08/05/2013 14:12:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usp_IsContractNumberValid]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[usp_IsContractNumberValid]
GO

USE [Lp_documents]
GO

/****** Object:  StoredProcedure [dbo].[usp_IsContractNumberValid]    Script Date: 08/05/2013 14:12:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Guy G
-- Create date: 8/5/2013
-- Description:	Checks if a contract number even
--              exists in the system before
-- =============================================
CREATE PROCEDURE [dbo].[usp_IsContractNumberValid] 
	(
		@ContractNumber		varchar(50)
	)
AS

	SET NOCOUNT ON;
BEGIN



    if not exists(select contract_nbr from vw_ConsolidatedAccountInfo where contract_nbr = @ContractNumber)
		begin
			select 0 as 'contractisvalid'
		end
		else
		begin
			select 1  as 'contractisvalid'
		end


END

	set nocount off
GO


