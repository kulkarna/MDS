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
-- Author:		<Lev Rosenblum>
-- Create date: <10/01/2012>
-- Description:	<Select AccountContractRate records having a specified AccountCotractId>
-- Enhancement/PBI:	<MD084/PBI0999>
-- =============================================
CREATE PROCEDURE dbo.usp_GetAccountContractRatesByAccountContractId
(
	@AccountContractId int
)
AS
BEGIN

	SET NOCOUNT ON;
	SELECT [AccountContractRateID]
      ,[AccountContractID]
      ,[LegacyProductID]
      ,[Term]
      ,[RateID]
      ,[Rate]
      ,[RateCode]
      ,[RateStart]
      ,[RateEnd]
      ,[IsContractedRate]
      ,[HeatIndexSourceID]
      ,[HeatRate]
      ,[TransferRate]
      ,[GrossMargin]
      ,[CommissionRate]
      ,[AdditionalGrossMargin]
      ,[Modified]
      ,[ModifiedBy]
      ,[DateCreated]
      ,[CreatedBy]
      ,[PriceID]
	FROM dbo.AccountContractRate with (nolock)
	WHERE dbo.AccountContractRate.AccountContractID=@AccountContractId 
END
GO
