USE [Libertypower]
GO
/****** Object:  StoredProcedure [dbo].[usp_GetAccountContractRatesByAccountContractId]    Script Date: 10/22/2012 17:32:59 ******/
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
ALTER PROCEDURE [dbo].[usp_GetAccountContractRatesByAccountContractId]
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
      ,[ProductCrossPriceMultiID]
	FROM dbo.AccountContractRate
	WHERE dbo.AccountContractRate.AccountContractID=@AccountContractId 
END
