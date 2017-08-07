-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Lev Rosenblum
-- Create date: <01/15/2013>
-- Description:	Overrides rates into dbo.deal_contract_account table
-- =============================================
CREATE PROCEDURE [dbo].[usp_contract_account_override_rates]
(
	@ContractNumber                                 char(12)
	, @AccountNumber                                varchar(30)
	, @Rate                                         float
	, @RatesString									varchar(50)
)
AS
BEGIN
	UPDATE dbo.deal_contract_account
	SET rate=@Rate, RatesString=@RatesString
	WHERE account_number=@AccountNumber and contract_nbr=@ContractNumber

END
GO
