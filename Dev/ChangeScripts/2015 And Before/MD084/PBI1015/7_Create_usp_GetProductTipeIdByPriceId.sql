USE [LibertyPower]
GO

/****** Object:  StoredProcedure [dbo].[usp_GetProductTipeIdByPriceId]    Script Date: 09/13/2012 15:46:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Lev A. Rosenblum>
-- Create date: <09/04/2012>
-- Description:	<Get a ProductTypeID by PriceId>
-- =============================================
CREATE PROCEDURE [dbo].[usp_GetProductTipeIdByPriceId] 
(
	@PriceId bigint
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT pb.ProductTypeID
	FROM dbo.Price prc with (nolock) 
		INNER JOIN dbo.ProductBrand pb with(nolock) 
			on prc.productbrandid = pb.ProductBrandID
	WHERE prc.ID=@PriceId

END

GO

